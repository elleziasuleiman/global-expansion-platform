# infrastructure/

Purpose
- Holds Terraform modules and environment composition.
- Modules are small, focused (lambda-function, dynamodb, api-gateway, eventbridge, s3-deploy, iam, monitoring).

How to validate & apply
- For local validation: cd infrastructure/prod && terraform init -backend=false && terraform validate
- For planning/applying: populate terraform.tfvars then terraform init && terraform plan && terraform apply

Important files
- [infrastructure/prod/main.tf](infrastructure/prod/main.tf) — prod composition of modules and wiring.
- Each module has a README (see modules/*).

Notes
- The API Gateway module uses a proxy ANY integration to forward requests to Lambda; routing is implemented inside the Lambda handler: [services/entity-management/index.mjs](services/entity-management/index.mjs).

Architecture Diagram (Mermaid)
![Infrastructure High Level Architecture](<Overall_Infrastructure_HLD.png>)