output "api_endpoint" {
  description = "URL base para invocar o API Gateway"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_id" {
  description = "ID do API Gateway"
  value       = aws_apigatewayv2_api.this.id
}

output "api_arn" {
  description = "ARN do API Gateway"
  value       = aws_apigatewayv2_api.this.arn
}
