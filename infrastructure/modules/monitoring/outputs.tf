output "dashboard_name" {
  description = "CloudWatch dashboard name created for this stack"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "lambda_errors_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.lambda_errors.arn
  description = "ARN of the Lambda errors alarm"
}

output "lambda_latency_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.lambda_latency.arn
  description = "ARN of the Lambda latency alarm"
}

output "lambda_throttles_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.lambda_throttles.arn
  description = "ARN of the Lambda throttles alarm"
}

output "dynamodb_throttles_alarm_arn" {
  description = "ARN of the DynamoDB throttles alarm (if table_name provided)"
  value       = try(aws_cloudwatch_metric_alarm.dynamodb_throttles[0].arn, "")
}
