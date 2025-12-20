# ==========================================
# GEP Platform - Deployment Outputs
# ==========================================

output "deployment_bucket_id" {
  value       = module.deployment_bucket.bucket_id
  description = "The unique ID (name) of the S3 bucket used for Lambda artifacts."
}

output "lambda_function_name" {
  value       = module.app_lambda.function_name
  description = "The name of the provisioned Lambda function for entity management."
}

output "table_arn" {
  value       = module.app_table.table_arn
  description = "The Amazon Resource Name (ARN) of the DynamoDB table for the Legal Ledger."
}

output "api_base_url" {
  value       = module.api_gateway.base_url
  description = "The public URL for the GEP API Gateway stage (for testing in Postman)."
}