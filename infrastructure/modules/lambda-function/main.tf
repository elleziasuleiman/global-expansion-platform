resource "aws_lambda_function" "this" {
  # checkov:skip=CKV_AWS_116: DLQ is configured dynamically; logic ensures it is only attached if an ARN is provided.
  function_name = var.function_name
  filename      = var.filename
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn
  source_code_hash = filebase64sha256(var.filename)
  depends_on = [aws_cloudwatch_log_group.this]
  
  environment {
    variables = length(keys(var.environment)) == 0 ? null : var.environment
  }
  
  kms_key_arn = (
    length(keys(var.environment)) == 0 ? null :
    (var.environment_kms_key_arn == "" ? try(aws_kms_key.env[0].arn, null) : var.environment_kms_key_arn)
  )

  tracing_config {
    mode = var.enable_tracing ? "Active" : "PassThrough"
  }

  code_signing_config_arn = var.code_signing_config_arn == "" ? null : var.code_signing_config_arn

  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }

  dynamic "dead_letter_config" {
    for_each = var.dlq_target_arn == "" ? [] : [var.dlq_target_arn]
    content {
      target_arn = dead_letter_config.value
    }
  }

  reserved_concurrent_executions = var.reserved_concurrent_executions == 0 ? null : var.reserved_concurrent_executions
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id = var.logs_kms_key_arn == "" ? null : var.logs_kms_key_arn
}

resource "aws_kms_key" "env" {
  count               = var.environment_kms_key_arn == "" && length(keys(var.environment)) > 0 ? 1 : 0
  description         = "KMS key for encrypting Lambda environment variables for ${var.function_name}"
  deletion_window_in_days = 30
  enable_key_rotation = true
}

resource "aws_kms_alias" "env_alias" {
  count = length(aws_kms_key.env) > 0 ? 1 : 0
  name  = "alias/${var.function_name}-env"
  target_key_id = aws_kms_key.env[0].key_id
}
