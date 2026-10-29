resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_name}-http-api-${var.environment}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST"]
    allow_headers = ["Content-Type", "Authorization"]
  }

  tags = {
    Name = "${var.project_name}-http-api"
  }
}

resource "aws_apigatewayv2_integration" "mock_ingest_price" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "MOCK"

  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_ingest_price" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /ingest-price"

  target = "integrations/${aws_apigatewayv2_integration.mock_ingest_price.id}"
}
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${aws_apigatewayv2_api.this.name}"
  retention_in_days = 1

  tags = {
    Environment = var.environment
  }
}
