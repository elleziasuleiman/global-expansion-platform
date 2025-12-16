# ==========================================
# GEP Platform - Global Variables
# ==========================================

variable "region" {
  type        = string
  description = "The AWS region for GEP deployment. Singapore is required for this project."
  default     = "ap-southeast-1"

  validation {
    condition     = var.region == "ap-southeast-1"
    error_message = "GEP must be deployed in the Singapore region (ap-southeast-1) to comply with local data residency."
  }
}

variable "tags" {
  type        = map(string)
  description = "Standard resource tags for billing and management."
  default = {
    Project     = "GEP"
    Environment = "Prod"
    ManagedBy   = "Terraform"
  }
}

# ==========================================
# Storage Variables (S3 & DynamoDB)
# ==========================================

variable "backend_bucket" {
  type        = string
  description = "The name of the S3 bucket used for Terraform State storage."
}

variable "deployment_bucket_name" {
  type        = string
  description = "The S3 bucket name for hosting Lambda deployment artifacts with versioning enabled."
  
  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.deployment_bucket_name))
    error_message = "S3 bucket names must follow DNS naming conventions (lowercase, no underscores)."
  }
}

variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table for the Legal Ledger."
}

variable "hash_key" {
  type        = string
  description = "The attribute to use as the hash (partition) key for the DynamoDB table."
  default     = "id"
}

# ==========================================
# Compute Variables (Lambda)
# ==========================================

variable "lambda_name" {
  type        = string
  description = "The name of the core entity-management Lambda function."
}

variable "lambda_zip" {
  type        = string
  description = "The local path or S3 key to the Lambda deployment package."
}

variable "lambda_handler" {
  type        = string
  description = "The function entry point (e.g., index.handler)."
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9_]+\\.[a-zA-Z0-9_]+$", var.lambda_handler))
    error_message = "The handler must be in the format 'filename.method'."
  }
}

variable "lambda_runtime" {
  type        = string
  description = "The Node.js runtime version."
  default     = "nodejs22.x"

  validation {
    condition     = contains(["nodejs20.x", "nodejs22.x"], var.lambda_runtime)
    error_message = "Only modern LTS versions of Node.js (20.x or 22.x) are supported."
  }
}