# infrastructure/prod (Production composition)

What this folder does
- Composes reusable modules into the production environment: Lambda functions, DynamoDB table, API Gateway, EventBridge schedules, monitoring, SNS topics, and KMS keys.

How modules are wired
- Lambda artifacts (zips) referenced by module.app_lambda.filename and module.compliance_lambda.filename.
- API Gateway proxy integration calls module.app_lambda.invoke_arn: see [infrastructure/modules/api-gateway/main.tf](infrastructure/modules/api-gateway/main.tf).
- EventBridge rule triggers compliance Lambda: [infrastructure/modules/eventbridge/main.tf](infrastructure/modules/eventbridge/main.tf) and wired in [infrastructure/prod/main.tf](infrastructure/prod/main.tf).

Terraform tips
- Variables live in [infrastructure/prod/variables.tf](infrastructure/prod/variables.tf)
- Providers & backend in [infrastructure/prod/providers.tf](infrastructure/prod/providers.tf)
- Outputs in [infrastructure/prod/outputs.tf](infrastructure/prod/outputs.tf)

Run locally
1. Populate terraform.tfvars
2. terraform init
3. terraform plan
4. terraform apply

Assumptions
- Deploy only to Singapore (ap-southeast-1) for data residency (enforced in variables.tf).