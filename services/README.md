# services/

Overview
- Each directory is a Lambda service. Services are small, single-responsibility Lambdas.
- services/entity-management: HTTP-facing API for entity lifecycle and retrieval.
- services/compliance-agent: scheduled compliance scanning + alerting.

How handlers are organized
- Each service has index.mjs that exports [`handler`](services/entity-management/index.mjs) which is the Lambda entrypoint.
- Handlers are small files under handlers/ for each route/workflow.

Architecture Diagram (Mermaid)
![Services High Level Diagram Architecture](<Services_HLD.png>)