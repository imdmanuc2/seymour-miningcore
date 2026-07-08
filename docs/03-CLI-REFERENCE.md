# 03 - CLI REFERENCE

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This document is the authoritative reference for every `smc` command.

------------------------------------------------------------------------

## System Commands

``` bash
smc version
smc status
smc health
smc doctor
```

  Command         Description
  --------------- -------------------------------------------------
  `smc version`   Display the current Seymour MiningCore version.
  `smc status`    Show overall system status.
  `smc health`    Run health checks.
  `smc doctor`    Perform installation and readiness diagnostics.

------------------------------------------------------------------------

## Diagnostics

``` bash
smc deps
smc install-plan
smc graph
```

  Command              Description
  -------------------- ----------------------------------------------------
  `smc deps`           Check required software dependencies.
  `smc install-plan`   Display the planned installation workflow.
  `smc graph`          Output the infrastructure graph consumed by Nexus.

------------------------------------------------------------------------

## Pool Management

``` bash
smc pool list
smc pool template
smc pool validate <pool.json>
smc pool create
smc pool enable <poolId>
smc pool disable <poolId>
smc pool remove <poolId>
smc pool restore <poolId>
```

These commands manage mining pools and pool configuration.

------------------------------------------------------------------------

## Service Management

``` bash
smc service status
smc service status <service>
smc service restart <service>
```

Use these commands to inspect and control Seymour MiningCore services.

------------------------------------------------------------------------

## Token Management

``` bash
smc token status
smc token create
smc token show
smc token rotate
```

Tokens are used for secure communication with Nexus Command Center and
future integrations.

------------------------------------------------------------------------

## Licensing

``` bash
smc license status
smc license show
```

The licensing subsystem reports the current edition, limits, enabled
features, and developer fee information.

------------------------------------------------------------------------

## Legacy Compatibility

The following commands remain available for backwards compatibility:

``` bash
smc pools
smc pool-template
smc pool-validate <pool.json>
```

New development should use the `smc pool ...` syntax.

------------------------------------------------------------------------

## Planned Commands

The following commands are planned for future releases:

``` text
smc install
smc setup
smc pair
smc backup
smc restore
smc update
```

------------------------------------------------------------------------

## Related Documentation

-   `04-API.md`
-   `05-POOL-MANAGEMENT.md`
-   `11-SYSTEM-ARCHITECTURE.md`
