output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "function_arn" {
  value       = aws_lambda_function.this.arn
  description = "The ARN of the Lambda function."
}

output "invoke_arn" {
  value       = aws_lambda_function.this.invoke_arn
  description = "The ARN used by API Gateway to invoke the Lambda."
}