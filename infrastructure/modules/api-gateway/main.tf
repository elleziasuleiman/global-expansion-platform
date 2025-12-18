resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = "GEP Platform API for Entity Management"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_request_validator" "this" {
  name                        = "validate-body-and-params"
  rest_api_id                 = aws_api_gateway_rest_api.this.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id       = aws_api_gateway_rest_api.this.id
  resource_id       = aws_api_gateway_resource.proxy.id
  http_method       = "ANY"
  authorization     = var.authorization
  request_validator_id = aws_api_gateway_request_validator.this.id
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.proxy.id,
      aws_api_gateway_method.proxy.id,
      aws_api_gateway_integration.lambda.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_integration.lambda]
}

resource "aws_cloudwatch_log_group" "access" {
  name              = "/aws/apigateway/${var.api_name}-${var.stage}-access"
  retention_in_days = var.access_log_retention_days
  kms_key_id        = aws_kms_key.apigw.arn
}

resource "aws_api_gateway_client_certificate" "this" {
  count       = var.enable_client_certificate ? 1 : 0
  description = "Generated client certificate (optional)"
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access.arn
    format = <<FORMAT
{ "requestId":"$context.requestId", "ip":"$context.identity.sourceIp", "caller":"$context.identity.caller", "user":"$context.identity.user", "requestTime":"$context.requestTime", "httpMethod":"$context.httpMethod", "resourcePath":"$context.resourcePath", "status":"$context.status" }
FORMAT
  }

  cache_cluster_enabled = var.cache_cluster_enabled
  cache_cluster_size    = var.cache_cluster_size

  xray_tracing_enabled = var.enable_tracing

  client_certificate_id = var.enable_client_certificate ? aws_api_gateway_client_certificate.this[0].id : null
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "apigw" {
  description             = "KMS key for API Gateway access logs"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}