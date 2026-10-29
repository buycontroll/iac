module "network" {
  source          = "./modules/network"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
}

module "api_gateway" {
  source       = "./modules/api-gateway"
  project_name = var.project_name
  environment  = var.environment
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

output "api_gateway_endpoint" {
  value = module.api_gateway.api_endpoint
}
