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