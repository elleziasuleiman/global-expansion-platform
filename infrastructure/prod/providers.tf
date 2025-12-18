provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "gep-terraform-state-prod"
    key    = "prod/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
