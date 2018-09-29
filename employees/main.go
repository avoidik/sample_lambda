package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"regexp"

	"github.com/aws/aws-lambda-go/events"

	"github.com/aws/aws-lambda-go/lambda"
)

type employee struct {
	ID      string `json:"id"`
	Name    string `json:"name"`
	Surname string `json:"surname"`
	Org     string `json:"org"`
}

var emplRegexp = regexp.MustCompile("^[0-9]+$")
var errorLogger = log.New(os.Stderr, "ERROR ", log.Llongfile)

func clientError(e int) (events.APIGatewayProxyResponse, error) {
	return events.APIGatewayProxyResponse{
		StatusCode: e,
		Body:       http.StatusText(e),
	}, nil
}

func serverError(e error) (events.APIGatewayProxyResponse, error) {
	errorLogger.Println(e.Error())

	code := http.StatusInternalServerError

	return events.APIGatewayProxyResponse{
		StatusCode: code,
		Body:       http.StatusText(code),
	}, nil
}

func showEmployee(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	emplID := req.QueryStringParameters["id"]
	if !emplRegexp.MatchString(emplID) {
		return clientError(http.StatusBadRequest)
	}

	empl, err := getItem(emplID)
	if err != nil {
		return serverError(err)
	}
	if empl == nil {
		return clientError(http.StatusNotFound)
	}

	js, err := json.Marshal(empl)
	if err != nil {
		return serverError(err)
	}

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       string(js),
	}, nil
}

func createEmployee(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	if req.Headers["Content-Type"] != "application/json" && req.Headers["content-type"] != "application/json" {
		return clientError(http.StatusNotAcceptable)
	}

	empl := new(employee)
	err := json.Unmarshal([]byte(req.Body), empl)
	if err != nil {
		return clientError(http.StatusUnprocessableEntity)
	}

	if !emplRegexp.MatchString(empl.ID) {
		return clientError(http.StatusBadRequest)
	}
	if empl.Name == "" || empl.Surname == "" || empl.Org == "" {
		return clientError(http.StatusBadRequest)
	}

	err = putItem(empl)
	if err != nil {
		return serverError(err)
	}

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusCreated,
		Headers: map[string]string{
			"Location": fmt.Sprintf("/employees?id=%s", empl.ID),
		},
	}, nil
}

func router(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	switch req.HTTPMethod {
	case "GET":
		return showEmployee(req)
	case "POST":
		return createEmployee(req)
	default:
		return clientError(http.StatusMethodNotAllowed)
	}
}

func main() {
	lambda.Start(router)
}
