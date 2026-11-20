resource "aws_api_gateway_rest_api" "this" {
  name = "${var.project_name}-rest-api-${var.environment}"

  tags = {
    Name        = "${var.project_name}-rest-api"
    Environment = var.environment
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.ingest_price.id,
      aws_api_gateway_method.post_ingest_price.id,
      aws_api_gateway_integration.mock_ingest_price.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.mock_ingest_price,
    aws_api_gateway_integration_response.mock_202,
  ]
}

resource "aws_api_gateway_resource" "ingest_price" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "ingest-price"
}

resource "aws_api_gateway_method" "post_ingest_price" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.ingest_price.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "mock_ingest_price" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.ingest_price.id
  http_method = aws_api_gateway_method.post_ingest_price.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 202}"
  }
}

resource "aws_api_gateway_method_response" "post_202" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.ingest_price.id
  http_method = aws_api_gateway_method.post_ingest_price.http_method
  status_code = "202"
}

resource "aws_api_gateway_integration_response" "mock_202" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.ingest_price.id
  http_method = aws_api_gateway_method.post_ingest_price.http_method
  status_code = aws_api_gateway_method_response.post_202.status_code

  depends_on = [aws_api_gateway_integration.mock_ingest_price]
}
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.this.name}"
  retention_in_days = 1

  tags = {
    Environment = var.environment
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.environment

  depends_on = [
    aws_api_gateway_account.this
  ]
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "apigw_cloudwatch_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "apigw_cloudwatch_logs" {
  name               = "${var.project_name}-apigw-cloudwatch-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.apigw_cloudwatch_assume_role.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "apigw_cloudwatch_logs" {
  role       = aws_iam_role.apigw_cloudwatch_logs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.apigw_cloudwatch_logs.arn

  depends_on = [
    aws_iam_role_policy_attachment.apigw_cloudwatch_logs
  ]
}
