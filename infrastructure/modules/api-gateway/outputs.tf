output "base_url" {
  value       = aws_api_gateway_stage.this.invoke_url
  description = "The public URL for GEP Platform API."
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.this.execution_arn
}