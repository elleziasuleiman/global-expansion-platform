variable "bucket_name" {
  type = string
  description = "The globally unique name of the S3 bucket."
  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket_name))
    error_message = "The bucket name must contain only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "tags" {
  type    = map(string)
  description = "A mapping of tags to assign to the resource."
  default = {}
}
