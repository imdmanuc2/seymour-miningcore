# Installation Guide

## Overview

This guide walks through installing Seymour MiningCore Command Center on
a new system.

## Supported Platforms

-   Raspberry Pi 4 / 5 (ARM64)
-   Ubuntu 24.04+
-   Debian 12+
-   Docker
-   Docker Compose (recommended)
-   Umbrel (supported)

## Prerequisites

Before installing, ensure you have:

-   Docker
-   Docker Compose
-   MiningCore
-   PostgreSQL
-   A fully synchronized blockchain node (BCH, BTC, etc.)
-   Network access to the MiningCore REST API

## Installation Steps

### 1. Clone the Repository

``` bash
git clone https://github.com/imdmanuc2/seymour-miningcore.git
cd seymour-miningcore
```

### 2. Configure MiningCore

Verify:

-   MiningCore is running.
-   PostgreSQL is online.
-   Your blockchain node is synchronized.
-   The MiningCore API is reachable.

### 3. Configure Seymour MiningCore

Update the configuration to match your environment.

Typical values:

``` text
Dashboard:
http://<server-ip>:8559

MiningCore API:
http://<server-ip>:4000

Stratum:
stratum+tcp://<server-ip>:6001
```

Replace `<server-ip>` with the hostname or IP address of your server.

### 4. Start the Dashboard

Start the dashboard using your preferred deployment method (Docker,
Docker Compose, or native service).

### 5. Verify Installation

Confirm that:

-   The dashboard loads.
-   Pool status reports **Online**.
-   Workers appear.
-   Charts update every few seconds.
-   Live hashrate is displayed.

## Updating

To update to the latest release:

``` bash
git pull
```

Restart the dashboard service or container after updating.

## Troubleshooting

### Dashboard will not load

-   Verify the web server is running.
-   Check the configured dashboard port.
-   Confirm firewall rules allow access.

### Workers are missing

-   Verify your wallet address.
-   Confirm miners are connected to the correct stratum endpoint.
-   Check the MiningCore API.

### Charts are not updating

-   Verify the MiningCore API is reachable.
-   Check browser developer tools for API errors.

## Next Steps

-   Read **configuration.md**
-   Explore **dashboard.md**
-   Review **faq.md** for common questions.

------------------------------------------------------------------------

Built for the Seymour MiningCore project.
