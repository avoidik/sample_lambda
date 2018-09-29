resource "aws_api_gateway_rest_api" "gateway_api" {
  name = "${var.gateway_name}"
}

resource "aws_api_gateway_resource" "gateway_employees" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.gateway_api.root_resource_id}"
  path_part   = "employees"
}

resource "aws_api_gateway_method" "gateway_any" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway_api.id}"
  resource_id   = "${aws_api_gateway_resource.gateway_employees.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.gateway_api.id}"
  resource_id             = "${aws_api_gateway_resource.gateway_employees.id}"
  http_method             = "${aws_api_gateway_method.gateway_any.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda_function.arn}/invocations"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.gateway_api.execution_arn}/*/*${aws_api_gateway_resource.gateway_employees.path}"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway_api.id}"
  stage_name  = "test"
  depends_on  = ["aws_api_gateway_integration.integration"]
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}
