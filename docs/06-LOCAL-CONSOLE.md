# 06 - LOCAL CONSOLE

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

The Local Console provides on-server management for a single Seymour
MiningCore instance.

It is designed to work independently of Nexus Command Center while
sharing the same backend APIs.

------------------------------------------------------------------------

## Design Goals

-   Run entirely on the local server
-   Use the REST API for all data access
-   No direct business logic in the UI
-   Operate even when disconnected from Nexus
-   Present a modern, responsive management interface

------------------------------------------------------------------------

## Current Capabilities

Current foundation includes:

-   REST API integration
-   Health monitoring
-   Pool inventory
-   Infrastructure graph
-   Licensing information
-   Service status
-   Readiness reporting

------------------------------------------------------------------------

## Planned Dashboard

The Local Console dashboard will include:

-   Overall system status
-   Health summary
-   Pool overview
-   Connected miners
-   Hashrate
-   Block statistics
-   Recent events
-   Alerts
-   Infrastructure graph

------------------------------------------------------------------------

## Planned Navigation

-   Dashboard
-   Pools
-   Services
-   Health
-   Infrastructure
-   Licensing
-   Settings
-   Logs

------------------------------------------------------------------------

## Relationship to Nexus

The Local Console manages a single server.

Nexus Command Center manages one or many Seymour MiningCore servers from
a centralized interface.

Both use the same REST API whenever possible.

------------------------------------------------------------------------

## Design Principles

-   API-first architecture
-   Responsive interface
-   Minimal configuration
-   Secure by default
-   Read-only where appropriate
-   Authentication required for write operations

------------------------------------------------------------------------

## Related Documents

-   04-API.md
-   07-NEXUS-INTEGRATION.md
-   11-SYSTEM-ARCHITECTURE.md
