# 10 - DATA MODEL

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document defines the core logical data model used throughout
Seymour MiningCore.

It describes the major entities and their relationships without tying
the design to a specific storage engine or implementation.

------------------------------------------------------------------------

## Design Principles

-   Stable identifiers
-   API-first design
-   Extensible relationships
-   Clear ownership boundaries
-   Backward-compatible evolution

------------------------------------------------------------------------

## Core Entities

### Server

Represents a Seymour MiningCore installation.

Typical attributes:

-   Server ID
-   Hostname
-   Version
-   Operating System
-   Primary IP
-   Health
-   License
-   Services

------------------------------------------------------------------------

### Pool

Represents a managed mining pool.

Typical attributes:

-   Pool ID
-   Name
-   Coin
-   Network
-   Mode
-   Status
-   Stratum Port
-   API Port
-   RPC Configuration
-   Wallet Address

------------------------------------------------------------------------

### Service

Represents an operating system service managed by Seymour MiningCore.

Examples:

-   Seymour MiningCore
-   Seymour MiningCore API
-   PostgreSQL

------------------------------------------------------------------------

### License

Represents the active platform license.

Contains:

-   Edition
-   Limits
-   Feature Flags
-   Developer Fee
-   Status

------------------------------------------------------------------------

### API Token

Represents an authentication credential used for trusted integrations.

Future attributes may include:

-   Token ID
-   Scope
-   Expiration
-   Status
-   Audit Metadata

------------------------------------------------------------------------

### Infrastructure Graph

Represents the mining infrastructure as nodes and edges.

Typical node types:

-   Server
-   Pool
-   Coin Node (RPC)
-   ASIC (planned)
-   Worker (planned)
-   Network Device (planned)

------------------------------------------------------------------------

## Relationships

``` text
Server
 ├── Pools
 ├── Services
 ├── License
 ├── API Tokens
 └── Infrastructure Graph
```

------------------------------------------------------------------------

## Design Notes

-   Every primary entity should have a stable unique identifier.
-   APIs should expose stable identifiers rather than
    implementation-specific paths.
-   Future schema changes should be additive whenever possible.

------------------------------------------------------------------------

## Related Documents

-   04-API.md
-   05-POOL-MANAGEMENT.md
-   08-LICENSING.md
-   11-SYSTEM-ARCHITECTURE.md
