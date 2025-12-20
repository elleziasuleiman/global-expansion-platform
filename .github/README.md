# CI/CD (GitHub Actions)

Workflows
- [.github/workflows/lambda-build.yml](.github/workflows/lambda-build.yml)
  - Builds Lambda artifacts for services/entity-management and services/compliance-agent and uploads as workflow artifacts.
  - Uses Node 22 to build ES module artifacts.

- [.github/workflows/terraform-validate.yml](.github/workflows/terraform-validate.yml)
  - Runs terraform fmt/check and terraform validate for infrastructure/prod.
  - Runs Checkov security scanning for Terraform.

CI/CD strategy
- Two-phase approach:
  1. Build + artifact upload for Lambdas (unit/test steps can be added).
  2. Terraform validation in CI; separate deploy pipelines should pull artifacts and run apply in a controlled environment (manual or gated).
- Keep build and infra validations separate to speed feedback loops.

How pipelines support code quality
- Formatting/validation (terraform fmt / validate)
- Security linting (Checkov)
- Build reproducibility (node version pinned, artifact upload)