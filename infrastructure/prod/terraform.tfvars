# ==========================================
# GEP Platform - Production Values
# ==========================================

# Regional Settings
region = "ap-southeast-1"

# Backend & Storage
backend_bucket         = "vistra-gep-terraform-state"
deployment_bucket_name = "gep-production-artifacts-sg"

# Database Configuration
table_name             = "gep-legal-ledger-prod"
hash_key               = "id"

# Compute (Lambda) Configuration
lambda_name            = "gep-entity-management-service"
lambda_zip             = "../../services/entity-management/build/handler.zip"
lambda_handler         = "index.handler"
lambda_runtime         = "nodejs22.x"

# Global Tagging Strategy
tags = {
  Project     = "Global Expansion Platform"
  Environment = "Production"
  ManagedBy   = "Terraform"
  Owner       = "DevOps-Team"
  CostCenter  = "Vistra-Expansion-2025"
}