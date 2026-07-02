# Installation Guide

## Requirements

-   Docker
-   Docker Compose (recommended)
-   MiningCore
-   PostgreSQL
-   Supported blockchain node

## Clone

``` bash
git clone https://github.com/imdmanuc2/seymour-miningcore.git
cd seymour-miningcore
```

## Configure

-   Configure MiningCore.
-   Verify the MiningCore REST API is reachable.
-   Update the dashboard configuration with your API URL.
-   Start the dashboard.

## Runtime Endpoints

Replace `<server-ip>` with your host.

    Dashboard: http://<server-ip>:8559
    MiningCore API: http://<server-ip>:4000
    Stratum: stratum+tcp://<server-ip>:6001

## Verify

-   Dashboard loads
-   Pool status is online
-   Workers appear
-   Charts update
