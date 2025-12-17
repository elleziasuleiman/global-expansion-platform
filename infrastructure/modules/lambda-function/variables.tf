variable "function_name" {
  type = string
  description = "Name of the Lambda function"
}

variable "filename" {
  type = string
  description = "Path to the deployment package (zip) for the Lambda function"
}

variable "handler" {
  type = string
  description = "Function handler (for example: index.handler)"
}

variable "runtime" {
  type    = string
  default = "nodejs22.x"
  description = "Runtime identifier for the Lambda"
}

variable "role_arn" {
  type = string
  description = "ARN of the IAM role assumed by the Lambda function"
}

variable "log_retention_days" {
  type = number
  description = "Number of days to retain CloudWatch Logs for this function's log group"
  default = 7
}