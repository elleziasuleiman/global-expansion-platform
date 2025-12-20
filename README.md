# Global Expansion Platform (GEP)

Project overview
- Serverless platform to manage global legal entities (onboarding, governance, compliance).
- Core components: API Gateway -> Lambda (entity-management), scheduled Compliance Agent (EventBridge -> Lambda), DynamoDB Legal Ledger, monitoring, and deployment pipeline.

Folder structure & rationale
- infrastructure/: reusable Terraform modules and environment composition (keeps IaC modular).
- infrastructure/prod/: production composition that composes modules and defines secrets/variables.
- services/: Lambda code, organized per service (entity-management, compliance-agent).
- .github/: CI workflows to validate/build deploy artifacts.
Rationale: separate modules for lifecycle, environment composition in prod for safer review and reuse.

Key architectural decisions
- AWS Serverless (Lambda + API Gateway) for fast, cost-effective event-driven operations.
- Modules (dynamodb, lambda-function, api-gateway, eventbridge, monitoring) for reuse and policy boundaries.
- Node.js 22.x ES modules for modern syntax and top-level await.
- EventBridge-driven scheduled compliance checks decouple scheduled work from HTTP API.

Validate locally
- Build entity lambda: cd services/entity-management && npm ci && npm run build
- Run terraform checks: cd infrastructure/prod && terraform init -backend=false && terraform validate
- CI workflows: see [.github/workflows/lambda-build.yml](.github/workflows/lambda-build.yml) and [.github/workflows/terraform-validate.yml](.github/workflows/terraform-validate.yml)

Assumptions & trade-offs
- DynamoDB used as single "Legal Ledger" (simplicity over multiple DBs).
- Mocked handlers in service code for prototyping; production needs actual DynamoDB calls and error handling.
- KMS keys created in infra to meet compliance; trade-off is operational overhead.

Architecture (Mermaid)
![Overall High Level Architecture](<Overall_HLD_diagram.png>)