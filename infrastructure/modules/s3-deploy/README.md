# infrastructure/modules/s3-deploy
Goal
- To provide a secure, hardened, and compliant storage environment for the GEP platform's deployment artifacts and entity-related documents.
- Implements a dual-bucket strategy to separate primary data from audit logs, ensuring a complete and immutable history of all platform operations.

Selected Settings & Thresholds
- Versioning: Enabled to protect against accidental overwrites and to maintain a historical record of all deployment packages.
- Server-Side Encryption: SSE-KMS using a dedicated Customer Managed Key (CMK) with automated 30-day rotation.
- Lifecycle Management: - Expiration: Objects are transitioned or expired after 365 days to manage storage costs and comply with data retention policies.
- Multipart Cleanup: Incomplete multipart uploads are automatically aborted after 7 days.
- Public Access: Strictly Blocked at the bucket level (All four public access block settings enabled).

Rationale
- Singapore Data Residency: Cross-region replication is explicitly disabled (CKV_AWS_144) to ensure all GEP platform data remains within the Singapore region, satisfying local regulatory and residency requirements.
- Access Logging: A dedicated access_logs bucket is provisioned to capture every request made to the primary bucket, providing the necessary audit trail for compliance reviews.
- Event-Driven Integration: EventBridge notifications are enabled at the bucket level, allowing the platform to trigger automated workflows (like security scans or deployment triggers) whenever new objects are uploaded.

Security Compliance (Checkov & Hardening)
- CKV_AWS_21: Versioning is implemented to ensure data durability.
- CKV_AWS_145: Default encryption is enforced using a CMK rather than the AWS-managed S3 key.
- CKV_AWS_300: Lifecycle policies ensure that failed uploads do not incur perpetual costs or leave orphaned data.
- CKV2_AWS_62: Notifications are routed through EventBridge to satisfy modern event-driven auditing standards.
- CKV_AWS_26: The associated SNS topic for event notifications is encrypted with alias/aws/sns to protect internal messaging.

Notes
- Bucket Naming: The module includes a regex validation to ensure bucket names comply with AWS global naming standards (lowercase, numbers, and hyphens).
- Log Management: The secondary logging bucket is hardened with its own encryption and lifecycle policies to ensure that the audit trail itself is as secure as the data it monitors.