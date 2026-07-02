# Architecture Guide

## Overview

Seymour MiningCore Command Center is a web application that sits on top
of MiningCore and provides a modern operational dashboard for solo
mining.

It does **not** replace MiningCore. Instead, it consumes MiningCore's
REST API and presents live operational data in an easy-to-understand
interface.

------------------------------------------------------------------------

# High-Level Architecture

``` text
                   +----------------------+
                   |      ASIC Miners     |
                   +----------+-----------+
                              |
                         Stratum (TCP)
                              |
                              v
                   +----------------------+
                   |      MiningCore      |
                   |  Share Validation    |
                   |  Job Management      |
                   +----------+-----------+
                              |
                  +-----------+-----------+
                  |                       |
                  v                       v
          PostgreSQL Database     Blockchain Node
          (Shares, Blocks,        (BCH / BTC / etc.)
           Workers, Stats)
                  |
                  v
          MiningCore REST API
                  |
                  v
    +------------------------------------+
    | Seymour MiningCore Command Center   |
    |  - Live Dashboard                  |
    |  - Charts                          |
    |  - Fleet Health                    |
    |  - ASIC Command Center             |
    |  - Probability Tools               |
    |  - TV Mode                         |
    +----------------+-------------------+
                     |
                     v
              Web Browser / Mobile
```

------------------------------------------------------------------------

# Component Responsibilities

## ASIC Miners

-   Connect using the Stratum protocol.
-   Submit shares.
-   Receive new work from MiningCore.

## MiningCore

Responsible for:

-   Job generation
-   Share validation
-   Block detection
-   Payout calculations
-   Worker statistics

## PostgreSQL

Stores:

-   Shares
-   Worker statistics
-   Block history
-   Payments
-   Pool metadata

## Blockchain Node

Provides blockchain data to MiningCore.

Examples:

-   Bitcoin Cash
-   Bitcoin
-   Additional supported coins

## Seymour MiningCore Dashboard

Consumes the MiningCore REST API and displays:

-   Live statistics
-   Charts
-   Fleet health
-   Worker performance
-   Probability analysis
-   Educational information

------------------------------------------------------------------------

# Data Flow

1.  ASIC submits a share.
2.  MiningCore validates the share.
3.  Statistics are written to PostgreSQL.
4.  MiningCore exposes updated data through the REST API.
5.  Seymour MiningCore polls the API.
6.  The dashboard updates charts and widgets in real time.

------------------------------------------------------------------------

# Deployment Options

Supported deployments include:

-   Raspberry Pi (ARM64)
-   Ubuntu
-   Debian
-   Docker
-   Docker Compose
-   Umbrel

------------------------------------------------------------------------

# Design Goals

-   Modern UI
-   Fast refresh times
-   Multi-coin architecture
-   Educational experience
-   Responsive design
-   Easy installation
-   Transparent operation

------------------------------------------------------------------------

# Future Architecture

Planned enhancements include:

-   Multiple MiningCore instances
-   Multi-pool monitoring
-   Remote fleet management
-   Push notifications
-   Mobile applications
-   Plugin architecture

------------------------------------------------------------------------

# Related Documentation

-   installation.md
-   configuration.md
-   dashboard.md
-   api.md
-   development.md

------------------------------------------------------------------------

Built for the Seymour MiningCore project.
