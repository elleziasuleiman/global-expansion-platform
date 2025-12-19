resource "aws_lambda_function" "this" {
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
