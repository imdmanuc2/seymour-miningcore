# API Guide

## Overview

Seymour MiningCore Command Center retrieves live mining data from the
MiningCore REST API. This document describes the primary endpoints
consumed by the dashboard and the data they provide.

> **Note:** Endpoint availability may vary slightly depending on the
> MiningCore version in use.

------------------------------------------------------------------------

# Base URL

Replace `<server-ip>` with your server hostname or IP address.

``` text
http://<server-ip>:4000
```

------------------------------------------------------------------------

# Pool Information

## Get Pools

``` http
GET /api/pools
```

Returns summary information for all configured pools.

Typical uses:

-   Pool status
-   Pool hashrate
-   Connected miners
-   Network statistics

------------------------------------------------------------------------

## Get Pool Details

``` http
GET /api/pools/{coin}
```

Example:

``` http
GET /api/pools/bch
```

Used by:

-   Pool Status
-   Network cards
-   Difficulty
-   Connected peers

------------------------------------------------------------------------

# Miner Information

## Miner Summary

``` http
GET /api/pools/{coin}/miners/{address}
```

Example:

``` http
GET /api/pools/bch/miners/<wallet-address>
```

Provides:

-   Pending balance
-   Total paid
-   Worker list
-   Current hashrate
-   Shares per second

------------------------------------------------------------------------

## Miner Performance

``` http
GET /api/pools/{coin}/miners/{address}/performance
```

Returns historical performance samples used for charting.

------------------------------------------------------------------------

# Block Information

``` http
GET /api/blocks
```

Provides recent blocks and block history.

Used by:

-   Latest Block
-   Hall of Fame
-   Block Celebration

------------------------------------------------------------------------

# Dashboard Refresh

The dashboard polls the API periodically.

Recommended refresh interval:

``` text
5 seconds
```

------------------------------------------------------------------------

# Error Handling

Common responses include:

-   200 OK
-   400 Bad Request
-   404 Not Found
-   500 Internal Server Error

If the API is unavailable, the dashboard displays cached information
(when available) and connection warnings.

------------------------------------------------------------------------

# Future API Extensions

Planned Seymour MiningCore endpoints:

-   Fleet Health
-   Achievement data
-   Alert Center
-   Revenue projections
-   Multi-pool aggregation
-   ASIC telemetry

------------------------------------------------------------------------

# Related Documentation

-   installation.md
-   configuration.md
-   dashboard.md
-   architecture.md
-   development.md

------------------------------------------------------------------------

Built for the Seymour MiningCore project.
