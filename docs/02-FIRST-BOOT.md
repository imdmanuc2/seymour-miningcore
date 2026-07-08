# 02 - FIRST BOOT

**Status:** Active\
**Owner:** Seymour MiningCore Team\
**Last Updated:** v0.9.1-alpha

## Purpose

This guide covers the initial configuration performed after Seymour
MiningCore has been installed.

The goal is to configure a new server without manually editing
configuration files.

## First Boot Workflow

After installation:

1.  Verify the installation.
2.  Review system health.
3.  Create the first mining pool.
4.  Verify the REST API.
5.  (Optional) Pair with Nexus Command Center.

## Verify Installation

Run:

``` bash
./bin/smc version
./bin/smc doctor | jq .
./bin/smc health | jq .
```

Confirm:

-   Version is correct
-   Health checks pass
-   Required services are running
-   No critical errors are reported

## Create Your First Pool

The preferred workflow is:

``` bash
smc pool template
smc pool create
smc pool list
```

Validate the configuration before enabling it:

``` bash
smc pool validate <pool.json>
```

## Verify the API

Confirm the API is responding:

``` bash
curl -s http://127.0.0.1:8560/api/v1/live | jq .
curl -s http://127.0.0.1:8560/api/v1/status | jq .
curl -s http://127.0.0.1:8560/api/v1/readiness | jq .
```

## Verify Services

``` bash
smc service status
```

Ensure:

-   Seymour MiningCore API is running
-   PostgreSQL is running
-   Health status is acceptable

## Licensing

New installations receive the **beta-free** license during the alpha
program.

Current beta license:

-   Unlimited miners
-   Unlimited pools
-   Unlimited managed servers
-   All major features enabled

Commercial editions will be introduced in a future release.

## Nexus Pairing

Future releases will support:

``` bash
smc pair
```

to securely pair a server with Nexus Command Center.

## Next Step

Continue with:

`03-CLI-REFERENCE.md`
