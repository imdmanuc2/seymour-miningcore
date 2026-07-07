# Architecture

**Project:** Seymour MiningCore\
**Version:** 0.9.0-alpha

## Vision

Seymour MiningCore is more than a MiningCore fork. It is a managed
mining platform designed to power both standalone deployments and the
Nexus Command Center.

------------------------------------------------------------------------

# High-Level Architecture

                     Nexus Command Center
                             │
                  REST API (planned)
                             │
                             ▼
                     Seymour MiningCore
                             │
                        bin/smc CLI
                             │
         ┌───────────────────┼───────────────────┐
         ▼                   ▼                   ▼
     status.sh          health.sh           pool.sh
                                                 │
                                                 ▼
                                          pool_repo.sh
                                                 │
                             ┌───────────────────┴──────────────────┐
                             ▼                                      ▼
                     config/pools/                       templates/coins/

## Major Components

### CLI

The primary automation interface today. Every command emits
machine-friendly JSON where practical.

### Pool Repository

Central persistence layer for active and archived pool configurations.
All interfaces should use this layer rather than reading or writing
configuration files directly.

### Installer

Responsible for dependency detection, OS validation, future
installation, upgrades, and bootstrap configuration.

### Local Console

A lightweight web interface intended for operators who do not deploy the
full Nexus Command Center. It will expose local monitoring and common
administrative tasks.

### Nexus Command Center

A centralized fleet-management platform capable of monitoring and
managing multiple Seymour MiningCore nodes, coordinating deployments,
viewing health, and administering solo and public pools.

## Supported Mining Models

-   Solo pool hosting
-   Public pool hosting
-   Multiple coins per server
-   Additional coins added after installation
-   Multiple pools on the same host

## Design Principles

-   Single source of truth for business logic.
-   Shared modules used by CLI, installer, Local Console, REST API, and
    Nexus.
-   JSON-first interfaces.
-   Safe operations with validation and archived recovery.
-   Modular architecture that supports future expansion without large
    refactoring.

## Road to Beta

Remaining priorities include:

1.  Complete installer.
2.  Complete Local Console.
3.  Publish REST API.
4.  Integrate with Nexus Command Center.
5.  Beta testing on supported operating systems.
6.  Signed releases and licensing enhancements.
