# infrastructure/modules/dynamodb

Goal
- To provide a highly available, resilient, and secure NoSQL storage layer for the GEP Platform.
- Ensures that sensitive legal entity data is encrypted at rest using customer-managed keys and protected against accidental deletion via continuous backups.

Selected Settings & Thresholds
- Billing Mode: PAY_PER_REQUEST (On-demand scaling) to ensure the database scales automatically with GEP traffic without manual intervention or over-provisioning.
- Data Retention: Point-in-Time Recovery (PITR) is enabled, providing a 35-day window for continuous, second-by-second recovery to protect against data corruption or accidental Delete operations.
- Attributes: Initialized with a single string-based (S) Hash Key to support unique Entity Identification (entityId).

Rationale
- On-Demand Capacity: Matches the serverless nature of the GEP architecture (Lambda and API Gateway). This ensures cost-optimization during development while allowing for unlimited scaling during production onboarding cycles.
- CMK Encryption: Standardized on Customer Managed Keys (SSE-KMS) instead of AWS-owned keys to provide Vistra with full control over data access logging and key rotation policies.
- Data Durability: PITR is a "Production-Ready" requirement for GEP to ensure business continuity and meet regulatory data recovery standards for corporate records.

Security Compliance (Checkov & Best Practices)
- Encryption at Rest: Explicitly configured to use a dedicated KMS Key (aws_kms_key.dynamo) rather than the default alias/aws/dynamodb key.
- KMS Key Rotation: enable_key_rotation = true ensures compliance with security best practices for cryptographic hygiene.
- IAM Policy: The KMS key policy explicitly defines root account access, allowing for granular IAM-based permission management while satisfying CKV2_AWS_64.

Notes
- Scalability: The table is designed to handle spikes in GEP entity processing without the need for manual read/write capacity unit (RCU/WCU) management.
- Environment Integration: The module outputs both the table_arn (for IAM policy attachment) and table_name (for Lambda environment variable injection) to ensure a loosely coupled but highly integrated infrastructure.

Architectural Diagram (Mermaid):
![Dynamo DB High Level Architecture](<dynamo_HLD.png>)