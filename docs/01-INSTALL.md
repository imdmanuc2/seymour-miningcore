# 01 - INSTALL

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This guide covers installing Seymour MiningCore on a supported Linux
server.

## Supported Operating Systems

**Production Targets**

-   Ubuntu 24.04 LTS
-   Debian 12
-   Debian 13

**Development**

-   Newer Ubuntu releases may work but are not officially supported for
    production.

## Minimum Requirements

-   4 CPU cores
-   8 GB RAM (16 GB recommended)
-   50 GB free disk space
-   Internet connectivity
-   sudo access

## Installation Workflow

1.  Verify the server meets prerequisites.
2.  Clone the repository.
3.  Run the installer.
4.  Verify installation with `smc doctor`.
5.  Complete the First Boot Wizard (`02-FIRST-BOOT.md`).
6.  Pair with Nexus (optional).

## Verify Readiness

Run:

``` bash
./bin/smc doctor | jq .
```

The system should report whether it is ready to install and identify any
missing dependencies.

## Install Components

The installer is responsible for:

-   Installing required packages
-   Installing the .NET runtime
-   Configuring PostgreSQL
-   Building Seymour MiningCore
-   Installing systemd services
-   Creating the API service
-   Generating the server identity
-   Installing the default beta-free license
-   Running health checks

## Verify Installation

Recommended validation:

``` bash
./bin/smc version
./bin/smc status | jq .
./bin/smc health | jq .
./bin/smc doctor | jq .
curl -s http://127.0.0.1:8560/api/v1/live | jq .
curl -s http://127.0.0.1:8560/api/v1/readiness | jq .
```

## Next Step

Continue with:

`02-FIRST-BOOT.md`
