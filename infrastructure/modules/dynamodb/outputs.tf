output "table_arn" {
  value       = aws_dynamodb_table.this.arn
  description = "The ARN of the DynamoDB table, used for IAM policies."
}

output "table_name" {
  value       = aws_dynamodb_table.this.id
  description = "The actual name of the table, used in Lambda environment variables."
}