# Pool Manager

**Project:** Seymour MiningCore\
**Version:** 0.9.0-alpha

## Purpose

The Pool Manager is responsible for the complete lifecycle of mining
pools within Seymour MiningCore. It provides a single management layer
that is shared by the CLI today and will be reused by the Local Console,
REST API, installer, and Nexus Command Center.

------------------------------------------------------------------------

# Architecture

    CLI
    REST API (future)
    Local Console (future)
    Nexus Command Center
            │
            ▼
       lib/pool.sh
            │
            ▼
     lib/pool_repo.sh
            │
            ▼
     config/pools/

`pool.sh` contains business logic and user-facing commands.

`pool_repo.sh` owns all storage operations.

------------------------------------------------------------------------

# Pool Lifecycle

Implemented:

-   Create
-   Validate
-   List
-   Enable
-   Disable
-   Remove (archive)
-   Restore

Planned:

-   Edit
-   Clone
-   Rename
-   Export
-   Import

------------------------------------------------------------------------

# Repository Layout

    config/
    └── pools/
        ├── btc-solo.json
        ├── btc-public.json
        └── removed/

Templates:

    templates/
    └── coins/
        ├── btc/
        │   ├── solo.json
        │   └── public.json
        └── bch/
            ├── solo.json
            └── public.json

------------------------------------------------------------------------

# Pool Repository Layer

The repository layer centralizes file operations.

Current functions include:

-   pool_repo_exists()
-   pool_repo_list()
-   pool_repo_archive()
-   pool_repo_restore_latest()
-   pool_repo_save()

Future additions:

-   pool_repo_delete()
-   pool_repo_clone()
-   pool_repo_export()
-   pool_repo_import()

------------------------------------------------------------------------

# Pool Validation

Validation checks required fields before a configuration becomes active.

Current required values include:

-   Pool ID
-   Coin
-   Mode
-   Wallet address
-   RPC settings
-   Stratum settings

Future validation will include:

-   Port conflicts
-   Duplicate pool IDs
-   Duplicate wallet usage warnings
-   RPC connectivity tests
-   Coin-specific validation

------------------------------------------------------------------------

# Design Goals

-   One repository layer for all interfaces.
-   Never duplicate pool logic.
-   JSON-first automation.
-   Safe archive instead of destructive deletion.
-   Support both Solo and Public pool hosting.
-   Support adding additional coins after installation without
    reinstalling Seymour MiningCore.

------------------------------------------------------------------------

# Nexus Integration

Nexus should never manipulate pool JSON directly.

Instead it should use Seymour MiningCore commands or the future REST
API.

This keeps validation, lifecycle management, and future compatibility
centralized.
