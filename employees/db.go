package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

const tableName = "Employees"

var db = dynamodb.New(session.New(), aws.NewConfig().WithRegion("eu-west-1"))

func getItem(id string) (*employee, error) {
	input := &dynamodb.GetItemInput{
		TableName: aws.String(tableName),
		Key: map[string]*dynamodb.AttributeValue{
			"ID": {
				S: aws.String(id),
			},
		},
	}

	result, err := db.GetItem(input)
	if err != nil {
		return nil, err
	}
	if result.Item == nil {
		return nil, nil
	}

	empl := &employee{}
	err = dynamodbattribute.UnmarshalMap(result.Item, empl)
	if err != nil {
		return nil, err
	}

	return empl, nil
}

func putItem(empl *employee) error {
	input := &dynamodb.PutItemInput{
		TableName: aws.String(tableName),
		Item: map[string]*dynamodb.AttributeValue{
			"ID": {
				S: aws.String(empl.ID),
			},
			"Name": {
				S: aws.String(empl.Name),
			},
			"Surname": {
				S: aws.String(empl.Surname),
			},
			"Org": {
				S: aws.String(empl.Org),
			},
		},
	}

	_, err := db.PutItem(input)
	return err
}
