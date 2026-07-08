# 04 - API

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document is the authoritative reference for the Seymour MiningCore
REST API.

## Base URL

``` text
http://<server>:8560
```

Current API version:

``` text
/api/v1/
```

## Endpoints

  Endpoint                       Purpose
  ------------------------------ ---------------------------
  `/`                            API discovery
  `/api/v1/live`                 Liveness probe
  `/api/v1/readiness`            Readiness summary
  `/api/v1/status`               Overall platform status
  `/api/v1/health`               Health checks
  `/api/v1/deps`                 Dependency status
  `/api/v1/install-plan`         Installation workflow
  `/api/v1/pools`                Pool inventory
  `/api/v1/graph`                Infrastructure graph
  `/api/v1/services`             All managed services
  `/api/v1/services/<service>`   Individual service status
  `/api/v1/license`              License information
  `/api/v1/version`              Version information

## Response Format

All successful endpoints return JSON.

Example:

``` json
{
  "product": "Seymour MiningCore",
  "version": "0.9.1-alpha"
}
```

Errors should include:

-   success
-   error
-   command (when applicable)
-   return code (when applicable)

## Read-only Mode

The current API is read-only.

Future releases will introduce authenticated write endpoints for:

-   Pool creation
-   Pool updates
-   Service control
-   Installer
-   Nexus pairing

## Health Endpoints

Use:

``` text
/api/v1/live
```

for load balancers and container orchestration.

Use:

``` text
/api/v1/readiness
```

to determine whether the platform is ready for operation.

## Related Documents

-   03-CLI-REFERENCE.md
-   05-POOL-MANAGEMENT.md
-   07-NEXUS-INTEGRATION.md
-   11-SYSTEM-ARCHITECTURE.md
