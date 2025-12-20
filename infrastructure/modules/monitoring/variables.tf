variable "function_name" {
  description = "Name of the Lambda function to monitor"
  type        = string
}

variable "api_name" {
  description = "Name of the API Gateway to monitor"
  type        = string
}

variable "stage" {
  description = "Deployment stage (eg. prod, dev)"
  type        = string
}

variable "region" {
  description = "AWS region for dashboard metrics"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name (optional)"
  type        = string
  default     = ""
}
