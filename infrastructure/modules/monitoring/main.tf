resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.function_name}-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Alert when Lambda function returns errors"
  
  dimensions = {
    FunctionName = var.function_name
  }
}

locals {
  dynamodb_widget = var.table_name == "" ? null : {
    type   = "metric"
    x      = 12
    y      = 0
    width  = 12
    height = 6
    properties = {
      metrics = [
        ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.table_name],
        [".", "ConsumedWriteCapacityUnits", ".", "."],
        [".", "ThrottledRequests", ".", "."]
      ]
      period = 300
      stat   = "Sum"
      region = var.region
      title  = "DynamoDB Capacity & Throttles"
    }
  }

  base_widgets = [
    {
      type   = "metric"
      x      = 0
      y      = 0
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["AWS/ApiGateway", "Count", "ApiName", var.api_name],
          [".", "4XXError", ".", "."],
          [".", "5XXError", ".", "."]
        ]
        period = 300
        stat   = "Sum"
        region = var.region
        title  = "API Gateway Traffic & Errors"
      }
    },
    {
      type   = "metric"
      x      = 0
      y      = 6
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["AWS/Lambda", "Invocations", "FunctionName", var.function_name],
          [".", "Errors", ".", "."],
          [".", "Throttles", ".", "."]
        ]
        period = 300
        stat   = "Sum"
        region = var.region
        title  = "Lambda Health"
      }
    }
  ]

  widgets = var.table_name == "" ? local.base_widgets : concat(local.base_widgets, [local.dynamodb_widget])
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "${var.function_name}-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Alert when Lambda function is throttled"

  dimensions = {
    FunctionName = var.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_throttles" {
  count               = var.table_name == "" ? 0 : 1
  alarm_name          = "${var.table_name}-throttled-requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ThrottledRequests"
  namespace           = "AWS/DynamoDB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Alert when DynamoDB table has throttled requests"

  dimensions = var.table_name == "" ? {} : {
    TableName = var.table_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_latency" {
  alarm_name          = "${var.function_name}-high-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  extended_statistic  = "p90"
  threshold           = "1000" # 1 second
  alarm_description   = "Alert when Lambda 90th percentile latency is over 1s"
  
  dimensions = {
    FunctionName = var.function_name
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "GEP-Platform-Metrics-${var.stage}"

  dashboard_body = jsonencode({
    widgets = local.widgets
  })
}