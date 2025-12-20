# modules/monitoring

Goal
- Provide CloudWatch alarms and a dashboard for critical Lambda/API/DynamoDB metrics for operational awareness.

Selected metrics & thresholds
- Lambda Errors: threshold > 0 (alert on first error)
- Lambda Throttles: threshold > 0 (indicates concurrency/configuration issues)
- Lambda p90 Duration: threshold 1000ms (adjust per SLA)
- DynamoDB ThrottledRequests: threshold > 0 when table_name provided

Rationale
- Alert on first error/throttle to enable fast investigation for high-value platform functions.
- Dashboard consolidates API, Lambda, and DynamoDB signals for triage.

Example CloudWatch Logs Insights queries
- Failed Lambda invocations (error stack):
  - query: fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 50
- Slow Lambda traces (p90):
  - query: filter service = "GEP-Entity-Management" and duration > 1000 | stats count() by bin(5m)

Notes
- Thresholds are conservative; tune in staging after real traffic.

Architecture Diagram:
![Monitoring High Level Architecture](<Monitoring_HLD.png>)