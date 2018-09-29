#
# account id
#
data "aws_caller_identity" "current" {}

#
# role for lambda
#
resource "aws_iam_role" "lambda_role" {
  name        = "${var.lambda_role_name}"
  description = "Role assigned to Lambda function"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

#
# minimal permissions for lambda
#
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_policy_name}"
  description = "Minimal policy for Lambda role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ],
      "Resource": "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_name}"
    }
  ]
}
EOF
}

#
# attach policy to role
#
resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}

#
# create function
#
resource "aws_lambda_function" "lambda_function" {
  description      = "Lambda function for ${var.lambda_name}"
  function_name    = "${var.lambda_name}"
  handler          = "main"
  filename         = "lambda.zip"
  source_code_hash = "${base64sha256(file("lambda.zip"))}"
  role             = "${aws_iam_role.lambda_role.arn}"
  runtime          = "go1.x"
  timeout          = 10

  environment = {
    variables = "${merge(var.lambda_env,
      map(
        "APP_CHECKSUM", base64sha256(file("lambda.zip")),
      )
    )}"
  }
}
