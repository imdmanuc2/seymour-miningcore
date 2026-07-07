# API Contract

**Version:** 0.9.0-alpha

## Purpose

This document defines the data contract that Seymour MiningCore exposes
to the Nexus Command Center and future third-party integrations.

## Current Interfaces

Current interfaces are CLI-based:

-   `smc status`
-   `smc health`
-   `smc deps`
-   `smc pool list`
-   `smc pool validate`
-   `scripts/nexus-status.sh`

Future interfaces will expose the same information through REST APIs.

## Status Object

`smc status` returns:

-   Product metadata
-   API version
-   Developer fee
-   License information
-   Nexus connection
-   System information
-   Services
-   Summary
-   Pools
-   Health

### Summary

Fields:

-   poolCount
-   enabledPools
-   soloPools
-   publicPools
-   connectedMiners
-   totalHashrate
-   blocksFound24h
-   pendingPayments

### Pool Object

Each pool contains:

-   poolId
-   name
-   coin
-   network
-   mode
-   enabled
-   stratumPort
-   apiPort
-   payoutScheme
-   feePercent
-   walletAddress
-   rpcHost
-   rpcPort

### Health Object

Contains:

-   overall
-   checks\[\]

Each check includes:

-   name
-   status
-   message

## Future REST Endpoints

GET /api/v1/status

GET /api/v1/health

GET /api/v1/pools

POST /api/v1/pools

PUT /api/v1/pools/{id}

DELETE /api/v1/pools/{id}

## Design Rules

-   Seymour MiningCore owns all business logic.
-   Nexus consumes data; it should not modify JSON configuration files
    directly.
-   REST responses should mirror CLI JSON whenever possible.
-   Backward compatibility should be maintained across API versions.
