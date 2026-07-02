# Configuration Guide

## Overview

This document explains every major configuration area of Seymour
MiningCore Command Center.

The dashboard is designed to be portable. Avoid hard-coded IP addresses
whenever possible and use hostnames or configurable values.

------------------------------------------------------------------------

# Core Settings

## Dashboard Port

**Purpose**

The port used by the web dashboard.

**Example**

``` text
8559
```

------------------------------------------------------------------------

## MiningCore API URL

**Purpose**

The REST API endpoint the dashboard polls for live mining data.

**Example**

``` text
http://<server-ip>:4000
```

------------------------------------------------------------------------

## Refresh Interval

**Purpose**

How often the dashboard refreshes live information.

**Recommended**

``` text
5000 ms (5 seconds)
```

------------------------------------------------------------------------

# Mining Settings

## Wallet Address

The wallet receiving mining rewards.

Example:

``` text
bitcoincash:qqxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

------------------------------------------------------------------------

## Supported Coins

Current and planned support:

  Coin   Status
  ------ -------------------
  BCH    ✅ Supported
  BTC    🚧 In Development
  DOGE   📅 Planned
  DGB    📅 Planned

------------------------------------------------------------------------

## Developer Fee

Seymour MiningCore displays the configured developer fee transparently
in the dashboard.

Default target:

``` text
0.75%
```

------------------------------------------------------------------------

# Dashboard Options

Current dashboard capabilities include:

-   Live Pool Status
-   Pool Hashrate
-   Per-Miner Hashrate
-   ASIC Command Center
-   Fleet Health
-   Probability Simulator
-   Multi-Coin Lottery
-   Block Race Meter
-   Hall of Fame
-   Achievement System
-   TV Mode

------------------------------------------------------------------------

# Runtime Endpoints

Typical deployment:

``` text
Dashboard:
http://<server-ip>:8559

MiningCore API:
http://<server-ip>:4000

Stratum:
stratum+tcp://<server-ip>:6001
```

Replace `<server-ip>` with your hostname or IP address.

------------------------------------------------------------------------

# Configuration Best Practices

-   Keep wallet addresses backed up.
-   Secure MiningCore and PostgreSQL with strong credentials.
-   Place the dashboard behind HTTPS for remote access.
-   Restrict API access to trusted networks when possible.
-   Keep Docker images and dependencies updated.

------------------------------------------------------------------------

# Common Issues

## Dashboard cannot reach the API

-   Verify the MiningCore service is running.
-   Confirm the API URL is correct.
-   Check firewall rules.
-   Test the endpoint with `curl`.

## Data is stale

-   Verify the refresh interval.
-   Confirm MiningCore is updating correctly.
-   Check browser developer tools for API errors.

------------------------------------------------------------------------

# Related Documentation

-   installation.md
-   dashboard.md
-   api.md
-   faq.md

------------------------------------------------------------------------

Built for the Seymour MiningCore project.
