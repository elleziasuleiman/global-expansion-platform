variable "compliance_agent_lambda_arn" {
  description = "ARN of the compliance agent Lambda"
  type        = string
}

variable "compliance_agent_name" {
  description = "Name of the compliance agent Lambda"
  type        = string
}

variable "schedule_expression" {
  description = "Schedule expression for the EventBridge rule"
  type        = string
  default     = "rate(1 day)"
}

variable "stage" {
  description = "Deployment stage"
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
