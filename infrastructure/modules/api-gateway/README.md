# infrastructure/modules/api-gateway
Goal
- To provide a secure, high-performance, and observable entry point for the GEP Platform.
- Implements a regional REST API that routes traffic to the Entity Management Lambda while enforcing production-grade security and throttling controls.

Selected Settings & Thresholds
- Throttling: Rate limit set to 1000 requests per second with a burst limit of 500 to prevent downstream service exhaustion.
- Caching: 300s TTL (5 minutes) enabled with Encryption at Rest to optimize performance for read-heavy entity lookups while maintaining data security.
- Logging Level: INFO with data_trace_enabled = false to ensure observability without logging sensitive PII/SPI in request/response bodies.
- Request Validation: Mandatory validation of both request body and parameters before passing traffic to Lambda.

Rationale
- Proxy Resource ({proxy+}): Utilized to allow the application-level router (index.mjs) to manage sub-resources dynamically, reducing Terraform overhead for every new endpoint.
- AWS_IAM Authorization: Aligns with Vistra's "Least Privilege" security model, ensuring only authenticated callers with correct IAM policies can access GEP resources.
- KMS Encryption: Access logs are encrypted using a dedicated Customer Managed Key (CMK) to satisfy compliance requirements for data residency and auditability.
- Redeployment Triggers: Uses sha1 hashing of resources to ensure that any change to the API structure or integration automatically triggers a new deployment, eliminating "stale" API configurations.

Security Compliance (Checkov Fixes)
- CKV_AWS_225 & CKV_AWS_308: Caching is explicitly enabled and encrypted to prevent unauthorized data access within the cache layer.
- CKV_AWS_276: Data tracing is disabled to prevent the accidental exposure of sensitive entity information in CloudWatch logs.
- CKV_AWS_338: CloudWatch log retention is parameterized (defaulting to 1 year) to ensure historical audit trails are preserved.

Notes
- WAF Skip (CKV2_AWS_29): Web Application Firewall deployment is currently excluded from the module scope to manage development costs, but it is recommended for a final production release.
- X-Ray Tracing: Enabled at the stage level to provide end-to-end visibility into request latency when combined with the Monitoring module.
- Client Certificates: Support is included but defaulted to false; can be enabled for mutual TLS (mTLS) requirements if jurisdictional regulations chang

Architectural Diagram (Mermaid):
![API Gateway High Level Architecture](<API_HLD.png>)