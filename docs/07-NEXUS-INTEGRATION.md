# 07 - NEXUS INTEGRATION

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document defines how Seymour MiningCore integrates with Nexus
Command Center.

Nexus is the centralized management platform for one or more Seymour
MiningCore servers.

------------------------------------------------------------------------

## Design Goals

-   Secure server registration
-   API-first communication
-   Multi-server management
-   Read-only by default
-   Extensible for future cloud services

------------------------------------------------------------------------

## Current Integration

The current REST API exposes information consumed by Nexus:

-   `/api/v1/status`
-   `/api/v1/health`
-   `/api/v1/readiness`
-   `/api/v1/services`
-   `/api/v1/pools`
-   `/api/v1/graph`
-   `/api/v1/license`

These endpoints allow Nexus to discover and monitor a server without
direct filesystem access.

------------------------------------------------------------------------

## Infrastructure Graph

The `/api/v1/graph` endpoint represents infrastructure as nodes and
edges.

Examples of supported node types:

-   Server
-   Pool
-   Coin Node (RPC)
-   ASIC (planned)
-   Worker (planned)
-   Network Device (planned)

Nexus renders this graph to visualize mining infrastructure.

------------------------------------------------------------------------

## Planned Pairing Workflow

Future releases will support:

``` bash
smc pair
```

Expected workflow:

1.  Generate a unique server identity.
2.  Generate a pairing code.
3.  Enter the pairing code in Nexus.
4.  Exchange secure API credentials.
5.  Establish trusted communication.

------------------------------------------------------------------------

## Authentication

Future authenticated communication will use API tokens issued by Seymour
MiningCore.

Planned capabilities:

-   Token rotation
-   Token revocation
-   Role-based permissions
-   Audit logging

------------------------------------------------------------------------

## Synchronization

Nexus will periodically retrieve:

-   Health
-   Pool inventory
-   Infrastructure graph
-   Service status
-   License information
-   System metrics

Future releases may support configuration synchronization and remote
management.

------------------------------------------------------------------------

## Design Principles

-   Seymour MiningCore owns mining operations.
-   Nexus owns fleet management.
-   Communication occurs through documented REST APIs.
-   Both products evolve independently while remaining compatible.

------------------------------------------------------------------------

## Related Documents

-   04-API.md
-   06-LOCAL-CONSOLE.md
-   08-LICENSING.md
-   11-SYSTEM-ARCHITECTURE.md
