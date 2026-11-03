resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = module.api_gateway.api_id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = module.lambda.function_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_ingest_price" {
  api_id    = module.api_gateway.api_id
  route_key = "POST /ingest-price"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${module.api_gateway.api_id}/*/*/ingest-price"
}
