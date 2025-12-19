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
  tags               = var.tags
}

module "app_lambda" {
  source        = "../modules/lambda-function"
  function_name = var.lambda_name
  filename      = var.lambda_zip
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role_arn      = module.lambda_role.role_arn
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