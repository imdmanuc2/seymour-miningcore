# 11 - SYSTEM ARCHITECTURE

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document defines the high-level architecture of Seymour MiningCore
and the relationships between its major components.

## Architecture Overview

``` text
                 Nexus Command Center
                         │
                  REST API (HTTPS)
                         │
                Seymour MiningCore API
                         │
      ┌──────────────────┼──────────────────┐
      │                  │                  │
      │                  │                  │
   Local Console      smc CLI         Future Clients
      │                  │
      └──────────────┬───┘
                     │
             Core Shell Libraries
                     │
      ┌──────────────┼──────────────┐
      │              │              │
   Pools        Licensing      Services
      │              │              │
      └──────────────┼──────────────┘
                     │
              Mining Infrastructure
```

## Major Components

### CLI

The `smc` command is the primary administration interface and
orchestrates all local operations.

### REST API

The REST API exposes platform data and services to the Local Console,
Nexus, and future integrations.

### Local Console

A single-server management interface built on top of the REST API.

### Nexus Command Center

A centralized management platform capable of monitoring and managing
multiple Seymour MiningCore servers.

### Core Libraries

Shell modules in `lib/` implement business logic shared by the CLI.

### Infrastructure Graph

The infrastructure graph models servers, pools, RPC nodes, and future
mining assets as nodes and relationships.

## Design Principles

-   API-first architecture
-   Shared business logic
-   Single source of truth
-   Modular components
-   Backward compatibility
-   Secure by default

## Repository Layers

-   `bin/` -- CLI entry points
-   `lib/` -- Core shell modules
-   `api/` -- REST API
-   `config/` -- Configuration
-   `systemd/` -- Service definitions
-   `docs/` -- Public documentation

## Future Expansion

The architecture is designed to support:

-   Installer
-   First Boot Wizard
-   Nexus Pairing
-   Marketplace
-   Additional mining coins
-   Plugin framework
-   AI-assisted operations

## Related Documents

-   03-CLI-REFERENCE.md
-   04-API.md
-   06-LOCAL-CONSOLE.md
-   07-NEXUS-INTEGRATION.md
-   10-DATA-MODEL.md
-   12-REPOSITORY-MAP.md
