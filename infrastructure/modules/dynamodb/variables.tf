variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "The attribute to use as the partition key"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource for billing and management."
  default     = {}
}

variable "kms_key_description" {
  type        = string
  description = "Description for the KMS key used to encrypt the DynamoDB table"
  default     = "DynamoDB table CMK"
}