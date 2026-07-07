# CLI Reference

**Project:** Seymour MiningCore\
**Version:** 0.9.0-alpha

## Overview

The `smc` command-line interface is the primary management interface for
Seymour MiningCore. It is also the reference implementation for the
future REST API and Nexus Command Center integration.

------------------------------------------------------------------------

# Current Commands

## General

### smc version

Displays the installed Seymour MiningCore version.

### smc status

Returns a complete JSON status document containing:

-   Product information
-   API version
-   Developer fee
-   License state
-   Nexus connection
-   System information
-   Service status
-   Pool summary
-   Active pools
-   Embedded health report

### smc health

Runs health checks and returns JSON.

Current checks:

-   MiningCore service
-   PostgreSQL
-   Local Console port
-   Disk usage
-   Pool configuration validation
-   Operating system support

### smc deps

Reports installation dependencies and whether they are installed.

### smc install-plan

Displays the planned installation workflow.

------------------------------------------------------------------------

# Pool Commands

## smc pool template

Outputs a blank pool template.

## smc pool validate `<file>`{=html}

Validates a pool configuration.

## smc pool list

Lists all active pools.

## smc pool create

Creates a pool from a coin template.

Typical options:

-   --coin
-   --mode
-   --pool-id
-   --name
-   --rpc-host
-   --rpc-port
-   --rpc-user
-   --rpc-password
-   --wallet

## smc pool enable `<poolId>`{=html}

Marks a pool as enabled.

## smc pool disable `<poolId>`{=html}

Marks a pool as disabled.

## smc pool remove `<poolId>`{=html}

Archives a pool into:

config/pools/removed/

## smc pool restore `<poolId>`{=html}

Restores the most recent archived copy.

------------------------------------------------------------------------

# Legacy Compatibility

The following remain available:

-   smc pools
-   smc pool list

------------------------------------------------------------------------

# Planned Commands

-   smc install
-   smc update
-   smc backup
-   smc node test
-   smc pool edit
-   smc pool clone
-   smc pool export
-   smc pool import
-   smc pool rename

------------------------------------------------------------------------

# Design Principles

-   JSON-first output for automation.
-   Stable interfaces for Nexus Command Center.
-   Business logic lives in shared library modules.
-   Future REST API should mirror CLI behavior whenever practical.
