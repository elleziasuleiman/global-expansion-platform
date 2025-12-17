variable "service_name" {
  type = string
  description = "The name of the service."
}

variable "service_principal" {
  type    = string
  default = "lambda.amazonaws.com"
  description = "The AWS service allowed for this role"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "dynamodb_table_arn" {
  type        = string
  description = "The ARN of the DynamoDB table this role should have access to."
}
