output "base_url" {
  value = format("https://%s.execute-api.%s.amazonaws.com/%s", aws_api_gateway_rest_api.this.id, var.region, var.stage)
}
