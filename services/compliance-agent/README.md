# services/compliance-agent

Purpose
- Scheduled scanner that checks upcoming compliance deadlines and issues alerts.
- Triggered from EventBridge rule in infra -> [`compliance_scheduler` in infrastructure/prod/main.tf](infrastructure/prod/main.tf).

Handlers
- Lambda entry: [`handler`](services/compliance-agent/index.mjs) which delegates to [`complianceAuditor.handler`](services/compliance-agent/handlers/complianceAuditor.mjs).

EventBridge integration
- EventBridge rule schedule invokes the compliance Lambda (see [infrastructure/modules/eventbridge/main.tf](infrastructure/modules/eventbridge/main.tf)).
- Recommended next steps: replace sampleEntities with a DynamoDB Scan/Query (ENV var ENTITY_TABLE provided in infra), publish findings to SNS (SNS_TOPIC_ARN).

Error handling
- Implement retries via EventBridge/Lambda DLQ and produce structured logs for failed items. IAM permissions are provided by [infrastructure/modules/iam/main.tf](infrastructure/modules/iam/main.tf).