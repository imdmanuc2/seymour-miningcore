# Nexus Integration

**Document Version:** 0.9.0-alpha\
**Repository:** Seymour MiningCore (beta-foundation)

## Purpose

This document defines the integration contract between Seymour
MiningCore and Nexus Command Center.

## Current Architecture

    Nexus Command Center
            │
            ▼
     Seymour MiningCore
            │
         bin/smc
            │
       lib/*.sh modules
            │
       pool_repo.sh
            │
     config/pools

## Implemented Features

-   Modular CLI dispatcher
-   Installer framework
-   Dependency detection
-   Health reporting
-   Status reporting
-   Pool repository layer
-   Pool lifecycle:
    -   create
    -   list
    -   validate
    -   enable
    -   disable
    -   remove
    -   restore

## Status Payload

The status output contains:

-   Product/version
-   Developer fee
-   License state
-   Nexus connection
-   System details
-   Service status
-   Pool summary
-   Active pools
-   Embedded health report

Nexus should use this as its primary discovery endpoint.

## Health Checks

-   MiningCore service
-   PostgreSQL
-   Local Console port
-   Disk usage
-   Pool configuration validation
-   Supported operating system

## Repository Layout

    config/
      pools/

    templates/
      coins/
        btc/
        bch/

    lib/
      common.sh
      status.sh
      health.sh
      deps.sh
      install.sh
      pool.sh
      pool_repo.sh

## Future REST API

-   GET /api/v1/status
-   GET /api/v1/health
-   GET /api/v1/pools
-   POST /api/v1/pools
-   PUT /api/v1/pools/{id}
-   DELETE /api/v1/pools/{id}

## Integration Rule

Nexus should never edit configuration files directly. It should
communicate with Seymour MiningCore through CLI commands today and REST
APIs in the future. Seymour MiningCore is the single source of truth.
