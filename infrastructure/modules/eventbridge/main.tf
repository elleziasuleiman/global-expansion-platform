resource "aws_cloudwatch_event_rule" "daily_compliance_check" {
  name                = "gep-daily-compliance-scheduler-${var.stage}"
  description         = "Triggers the Compliance Agent to check for upcoming AR/AGM deadlines"
  schedule_expression = var.schedule_expression
  is_enabled          = true
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "compliance_agent_target" {
  rule      = aws_cloudwatch_event_rule.daily_compliance_check.name
  target_id = "ComplianceAgentLambda"
  arn       = var.compliance_agent_lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge-${var.stage}"
  action        = "lambda:InvokeFunction"
  function_name = var.compliance_agent_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_compliance_check.arn
}
