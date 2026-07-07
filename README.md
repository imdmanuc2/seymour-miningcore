# Seymour MiningCore

Seymour MiningCore is a professional mining pool platform built on
MiningCore and extended for modern mining operations.

It can operate as a standalone mining server with a lightweight Local
Console or as a managed node connected to the Nexus Command Center for
centralized monitoring, deployment, and administration.

------------------------------------------------------------------------

# Features

## Mining

-   Solo pool hosting
-   Public pool hosting
-   Multi-coin architecture
-   Multiple pools per server
-   Additional coin deployment after installation
-   Pool template system
-   Pool lifecycle management (Create, Validate, Enable, Disable,
    Remove, Restore)

## Platform

-   Modular CLI (`smc`)
-   Automated installer framework
-   Health monitoring
-   Dependency detection
-   JSON-first automation
-   Repository-based configuration management
-   Future REST API
-   Local Console (in development)
-   Nexus Command Center integration

## Security

-   Mandatory 0.75% developer fee
-   Planned signed releases
-   Planned license verification
-   Planned update verification
-   Planned binary integrity validation

------------------------------------------------------------------------

# Nexus Command Center

Nexus Command Center is the optional centralized management platform for
Seymour MiningCore.

It is designed to manage one or many Seymour MiningCore servers from a
single interface.

Capabilities include:

-   Infrastructure discovery
-   Asset inventory
-   Health monitoring
-   Pool deployment
-   Software lifecycle management
-   Fleet management
-   Central dashboards

Repository:

https://github.com/imdmanuc2/nexus-command-center

------------------------------------------------------------------------

# Documentation

## Start Here

1.  **docs/SYSTEM_DESIGN.md** *(rename to `MASTER_SYSTEM_DESIGN.md`
    later if desired)*\
2.  **docs/PROJECT_BRIEF.md**
3.  **docs/NEXUS_INTEGRATION.md**
4.  **docs/API_CONTRACT.md**
5.  **docs/CLI_REFERENCE.md**
6.  **docs/POOL_MANAGER.md**
7.  **docs/INSTALLER.md**
8.  **docs/REPOSITORY_MAP.md**
9.  **docs/NEXT_STEPS.md**
10. **docs/BETA_GOAL.md**

------------------------------------------------------------------------

# Project Architecture

                     Nexus Command Center
                              │
                       Future REST API
                              │
                              ▼
                     Seymour MiningCore
                              │
                         bin/smc CLI
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                 ▼
       Status Module     Health Module     Pool Manager
                                                  │
                                                  ▼
                                           Pool Repository
                                                  │
                              config/pools + templates/coins

------------------------------------------------------------------------

# Project Status

**Current Version:** v0.9.0-alpha

Current priorities:

-   Complete installer
-   Complete Local Console
-   REST API
-   Nexus Command Center integration
-   Beta testing
-   Signed releases
-   Version 1.0 preparation

------------------------------------------------------------------------

# Design Philosophy

Seymour MiningCore follows a modular architecture where the CLI,
Installer, Local Console, REST API, and Nexus Command Center all share
the same business logic whenever practical.
