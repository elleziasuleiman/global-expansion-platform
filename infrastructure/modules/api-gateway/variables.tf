variable "api_name" {
  type = string
}

variable "stage" {
  type    = string
  default = "prod"
}

variable "region" {
  type = string
}

variable "lambda_invoke_arn" {
  type        = string
  description = "The ARN used to invoke the Lambda function from API Gateway."
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function to grant permissions to."
}

variable "authorization" {
  type    = string
  default = "AWS_IAM"
  description = "Authorization type for methods (e.g. NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS)"
}

variable "enable_access_logs" {
  type    = bool
  default = true
}

variable "access_log_retention_days" {
  type    = number
  default = 365
}

variable "cache_cluster_enabled" {
  type    = bool
  default = true
}

variable "cache_cluster_size" {
  type    = string
  default = "0.5"
}

variable "enable_tracing" {
  type    = bool
  default = true
}

variable "enable_client_certificate" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
  description = "Tags to apply to created resources"
}