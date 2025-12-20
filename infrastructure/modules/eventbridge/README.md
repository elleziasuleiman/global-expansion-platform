# modules/eventbridge

Purpose
- Schedule rules that trigger serverless workers (Compliance Agent).

Event flow & error handling
- EventBridge rule -> invokes Lambda (compliance agent).
- Failures: configure Lambda DLQ (SNS/SQS) or EventBridge retry policy + DLQ. The current composition attaches permission via aws_lambda_permission.


Architecture (Mermaid)
![Event Bridge Architecture](<EventBridge_Archi.png>)