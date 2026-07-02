# Seymour MiningCore Command Center

> A modern, self-hosted command center for solo cryptocurrency mining.

------------------------------------------------------------------------

# Current Version

**Version:** v0.9.0-alpha

**Status:** Internal Development Build

This release is intended for development and early testing. The
dashboard is functional and showcases the core vision of Seymour
MiningCore.

------------------------------------------------------------------------

# Features

## Dashboard

-   Live Pool Status
-   Live Pool Hashrate
-   Per-Miner Hashrate
-   ASIC Command Center
-   Fleet Health Score
-   Network Difficulty
-   Latest Block Preview
-   Multi-Coin Mining Operations
-   Educational Tooltips
-   TV / NOC Display Mode

## Analytics

-   Multi-Coin Solo Lottery Meter
-   Probability Simulator
-   Block Race Meter
-   Solo Hall of Fame
-   Achievement System

## Mining

-   Transparent 0.75% Developer Fee Display
-   Block Celebration Screen
-   Multi-coin Architecture (BCH live, BTC/DOGE/DGB planned)

------------------------------------------------------------------------

# Runtime Configuration

The dashboard is portable and does **not** require fixed IP addresses.

## Dashboard

Default:

``` text
http://<server-ip>:8559
```

Example:

``` text
http://192.168.1.154:8559
```

## MiningCore API

Configured in `config.js`.

Example:

``` text
http://<server-ip>:4000
```

or

``` text
https://mining.example.com
```

## Stratum

Typical:

``` text
stratum+tcp://<server-ip>:6001
```

------------------------------------------------------------------------

# Installation (Planned)

1.  Install MiningCore.
2.  Configure PostgreSQL.
3.  Configure the coin daemon(s).
4.  Copy Seymour MiningCore Command Center.
5.  Edit `config.js`.
6.  Start your web server.

------------------------------------------------------------------------

# Development Roadmap

## v0.9.0-alpha (Current)

-   Core dashboard
-   Charts
-   ASIC Fleet
-   Fleet Health
-   Hall of Fame
-   Achievements
-   Lottery Meter
-   Probability Simulator
-   Block Celebration
-   Multi-coin UI

## v1.0.0-beta

-   Public YouTuber testing
-   ASIC Command Center
-   Miner drill-down pages
-   Temperature monitoring
-   Fan monitoring
-   Power monitoring
-   Miner IP integration
-   Alerting system
-   Improved installation

## v1.0.0

-   Stable public release
-   BCH support
-   Multi-user support
-   Automatic updates
-   Documentation
-   Installer

## v1.1

-   Bitcoin (BTC)
-   Multi-pool support
-   Historical analytics
-   Revenue reporting

## Future

-   DOGE
-   DGB
-   Additional SHA-256 coins
-   Mobile dashboard
-   Fleet maps
-   AI recommendations

------------------------------------------------------------------------

Built with ❤️ by Seymour MiningCore.
