variable "region" {
  default = "eu-west-1"
}

variable "profile" {
  default = "personal"
}

variable "lambda_name" {
  type    = "string"
  default = "app_employees"
}

variable "lambda_role_name" {
  type    = "string"
  default = "lambda.role.app.employees"
}

variable "lambda_policy_name" {
  type    = "string"
  default = "lambda.policy.app.employees"
}

variable "lambda_env" {
  type = "map"

  default = {
    APP_NAME    = "app.employees"
    APP_VERSION = "0.0.1"
  }
}

variable "dynamodb_name" {
  type    = "string"
  default = "Employees"
}

variable "dynamodb_struct" {
  type = "list"

  default = [
    {
      name = "ID"
      type = "S"
    },
  ]
}

variable "gateway_name" {
  type = "string"

  default = "app.employees"
}

