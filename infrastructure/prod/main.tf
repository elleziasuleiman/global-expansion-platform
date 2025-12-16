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
  source       = "../modules/iam"
  service_name = "gep-lambda"
  tags         = var.tags
}

module "app_lambda" {
  source      = "../modules/lambda-function"
  function_name = var.lambda_name
  filename      = var.lambda_zip
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role_arn      = module.lambda_role.role_arn
}
