output "api_endpoint" {
  description = "URL base para invocar o API Gateway"
  value       = aws_apigatewayv2_api.this.api_endpoint
}
