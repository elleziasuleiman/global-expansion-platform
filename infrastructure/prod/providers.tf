provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "gep-terraform-state-prod"
    key    = "prod/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
