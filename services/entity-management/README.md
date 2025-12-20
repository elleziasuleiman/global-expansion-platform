# services/entity-management

Purpose
- Exposes HTTP API for entity onboarding, listing, retrieval, updates and archival.

Routing & handlers
- Lambda entry: [`handler`](services/entity-management/index.mjs)
- Routes implemented:
  - POST /entities -> [`createEntity.handler`](services/entity-management/handlers/createEntity.mjs)
  - GET /entities -> [`listEntities.handler`](services/entity-management/handlers/listEntities.mjs)
  - GET /entities/{id} -> [`getEntity.handler`](services/entity-management/handlers/getEntity.mjs)
  - PUT /entities/{id} -> [`updateEntity.handler`](services/entity-management/handlers/updateEntity.mjs)
  - DELETE /entities/{id} -> [`deleteEntity.handler`](services/entity-management/handlers/deleteEntity.mjs)

Implementation notes
- Current handlers return mocked data for prototyping and log via [`utils.logEvent`](services/entity-management/utils/utils.mjs).
- API Gateway uses a proxy ANY integration; routing is implemented inside the Lambda. See [infrastructure/modules/api-gateway/main.tf](infrastructure/modules/api-gateway/main.tf).

Local validation
- cd services/entity-management && npm ci && npm run build
- Inspect generated zip at services/entity-management/build/handler.zip