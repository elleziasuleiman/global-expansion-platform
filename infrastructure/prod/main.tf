module "deployment_bucket" {
  source      = "../modules/s3-deploy"
  bucket_name = var.deployment_bucket_name
  tags        = var.tags
}

module "app_table" {
  source     = "../modules/dynamodb"
  table_name = var.table_name
  hash_key   = var.hash_key
}

module "lambda_role" {
  source             = "../modules/iam"
  service_name       = "gep-lambda"
  dynamodb_table_arn = module.app_table.table_arn 
  sns_topic_arn      = aws_sns_topic.compliance_alerts.arn
  tags               = var.tags
}

data "aws_caller_identity" "current" {}

locals {
  lambda_env_kms_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "Allow administration by account root",
        Effect = "Allow",
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
        Action = "kms:*",
        Resource = "*"
      },
      {
        Sid = "Allow lambda use",
        Effect = "Allow",
        Principal = { AWS = module.lambda_role.role_arn },
        Action = ["kms:Encrypt","kms:Decrypt","kms:GenerateDataKey*","kms:DescribeKey"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key" "lambda_env" {
  description             = "KMS key for encrypting Lambda environment variables (global)"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = local.lambda_env_kms_policy
}

resource "aws_kms_alias" "lambda_env_alias" {
  name          = "alias/gep-lambda-env"
  target_key_id = aws_kms_key.lambda_env.key_id
}

module "app_lambda" {
  source        = "../modules/lambda-function"
  function_name = var.lambda_name
  filename      = var.lambda_zip
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role_arn      = module.lambda_role.role_arn
  environment_kms_key_arn = aws_kms_key.lambda_env.arn
  log_retention_days = var.log_retention_days
  environment = {
    LOG_FORMAT = "JSON"
    LOG_LEVEL  = "INFO"
  }
  depends_on = [module.lambda_role, module.app_table]
}

module "api_gateway" {
  source               = "../modules/api-gateway"
  api_name             = "gep-api-prod"
  region               = var.region
  stage                = "prod"
  lambda_invoke_arn    = module.app_lambda.invoke_arn
  lambda_function_name = module.app_lambda.function_name
  access_log_retention_days = var.log_retention_days
}

module "monitoring" {
  source        = "../modules/monitoring"
  function_name = module.app_lambda.function_name
  api_name      = "gep-api-prod"
  stage         = "prod"
  region        = var.region
  table_name    = module.app_table.table_name
  depends_on    = [module.app_lambda, module.api_gateway, module.app_table]
}

resource "aws_sns_topic" "compliance_alerts" {
  name = "gep-compliance-alerts-${var.stage}"
  # checkov:skip=CKV_AWS_26: using default SNS key for topic in this scope
}

module "compliance_lambda" {
  source = "../modules/lambda-function"
  function_name = "gep-compliance-agent-${var.stage}"
  filename = var.compliance_agent_zip
  handler = "index.handler"
  runtime = "nodejs22.x"
  role_arn = module.lambda_role.role_arn
  log_retention_days = var.log_retention_days
  environment = {
    LOG_FORMAT = "JSON"
    LOG_LEVEL  = "INFO"
    ENTITY_TABLE = module.app_table.table_name
    SNS_TOPIC_ARN = aws_sns_topic.compliance_alerts.arn
  }
  depends_on = [module.lambda_role, module.app_table]
}

module "compliance_scheduler" {
  source = "../modules/eventbridge"
  compliance_agent_lambda_arn = module.compliance_lambda.invoke_arn
  compliance_agent_name = module.compliance_lambda.function_name
  schedule_expression = "rate(1 day)"
  stage = var.stage
  tags = var.tags
  depends_on = [module.compliance_lambda]
}