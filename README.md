# AWS Lambda in Go

## What's inside

* Sample AWS Lambda function written in Golang with DynamoDB as a storage backend
* AWS API Gateway bridge to AWS Lambda function
* Dependencies management with Glide
* Terraform for infrastructure deployment

## Windows dependency

```
go.exe get -u github.com/aws/aws-lambda-go/cmd/build-lambda-zip
```

## Workflow

1. `aws --profile personal configure` - configure AWS profile
1. `deps.sh` - download dependencies
1. `build.sh` - build Lambda source code
1. `infra.sh` - create infrastructure with Terraform
1. `invoke.sh` - invoke Lambda function
1. `get.sh 1` - invoke API Gateway (GET)
1. `post.sh` - invoke API Gateway (POST)
1. `get.sh 3` - invoke API Gateway (GET)
1. `cleanup.sh` - destroy infrastructure with Terraform
