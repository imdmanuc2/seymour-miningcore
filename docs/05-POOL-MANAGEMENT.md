# 05 - POOL MANAGEMENT

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document describes the lifecycle of mining pools within Seymour
MiningCore.

It is the authoritative reference for creating, validating, enabling,
disabling, restoring, and removing pools.

------------------------------------------------------------------------

## Pool Lifecycle

``` text
Template
    ↓
Create
    ↓
Validate
    ↓
Enable
    ↓
Operate
    ↓
Disable
    ↓
Remove
    ↓
Restore
```

------------------------------------------------------------------------

## Supported Pool Modes

-   Solo
-   Public

Future releases may add additional payout schemes and pool types.

------------------------------------------------------------------------

## Supported Coins

Current templates include:

-   Bitcoin (BTC)
-   Bitcoin Cash (BCH)

Additional coin templates will be added over time.

------------------------------------------------------------------------

## CLI Commands

### List Pools

``` bash
smc pool list
```

Displays every configured pool.

### Generate Template

``` bash
smc pool template
```

Creates a starting configuration.

### Validate Configuration

``` bash
smc pool validate <pool.json>
```

Checks configuration before deployment.

### Create Pool

``` bash
smc pool create
```

Creates a new managed pool.

### Enable / Disable

``` bash
smc pool enable <poolId>
smc pool disable <poolId>
```

Controls whether a pool is active.

### Remove / Restore

``` bash
smc pool remove <poolId>
smc pool restore <poolId>
```

Soft-removes or restores a pool configuration.

------------------------------------------------------------------------

## Pool Configuration

Typical configuration includes:

-   Pool ID
-   Name
-   Coin
-   Network
-   Mode
-   Stratum Port
-   API Port
-   RPC Host
-   RPC Port
-   Wallet Address
-   Developer Fee

Configuration files should always be validated before use.

------------------------------------------------------------------------

## API

Current endpoint:

``` text
GET /api/v1/pools
```

Future endpoints will support authenticated pool creation and
management.

------------------------------------------------------------------------

## Best Practices

-   Validate every pool before enabling it.
-   Use unique pool IDs.
-   Verify RPC connectivity.
-   Keep wallet addresses accurate.
-   Run `smc health` after significant changes.

------------------------------------------------------------------------

## Related Documents

-   03-CLI-REFERENCE.md
-   04-API.md
-   11-SYSTEM-ARCHITECTURE.md
