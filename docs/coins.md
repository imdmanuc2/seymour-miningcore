# Supported Coins Guide

## Overview

Seymour MiningCore is designed as a multi-coin mining command center.
While Bitcoin Cash (BCH) is the primary supported coin today, the
platform is built to support additional Proof-of-Work cryptocurrencies
over time.

------------------------------------------------------------------------

# Current Support Matrix

  Coin           Symbol   Algorithm   Status
  -------------- -------- ----------- -------------------
  Bitcoin Cash   BCH      SHA-256     ✅ Supported
  Bitcoin        BTC      SHA-256     🚧 In Development
  Dogecoin       DOGE     Scrypt      📅 Planned
  DigiByte       DGB      Multiple    📅 Planned

------------------------------------------------------------------------

# Bitcoin Cash (BCH)

**Status:** Production Ready

Bitcoin Cash is the reference implementation for Seymour MiningCore.

Current capabilities include:

-   Solo mining
-   Live dashboard
-   Worker monitoring
-   Probability simulator
-   Block race meter
-   Hall of Fame
-   TV Mode
-   Achievement system

------------------------------------------------------------------------

# Bitcoin (BTC)

**Status:** In Development

Planned capabilities:

-   Solo mining
-   Full dashboard integration
-   Shared multi-coin overview
-   Independent worker statistics
-   Probability calculations

------------------------------------------------------------------------

# Dogecoin (DOGE)

**Status:** Planned

Future support will include:

-   Scrypt mining dashboard
-   Coin-specific statistics
-   Network monitoring
-   Historical analytics

------------------------------------------------------------------------

# DigiByte (DGB)

**Status:** Planned

Goals include support for supported DigiByte mining algorithms and
dashboard integration.

------------------------------------------------------------------------

# Future Coin Support

The architecture is designed to expand to additional coins where
practical.

Future candidates may include:

-   Litecoin (LTC)
-   Bitcoin SV (BSV)
-   Namecoin (NMC)
-   Additional SHA-256 compatible networks

Support decisions will be based on community demand and MiningCore
compatibility.

------------------------------------------------------------------------

# Multi-Coin Dashboard

When multiple pools are configured, the dashboard will provide:

-   One card per active coin
-   Independent hashrate
-   Worker counts
-   Solo odds
-   Network health
-   Coin-specific statistics

------------------------------------------------------------------------

# Coin Selection Philosophy

New coins should:

-   Be supported by MiningCore
-   Have reliable blockchain nodes
-   Provide meaningful value to miners
-   Integrate cleanly into the dashboard experience

------------------------------------------------------------------------

# Related Documentation

-   dashboard.md
-   configuration.md
-   architecture.md
-   roadmap.md

------------------------------------------------------------------------

Built for the Seymour MiningCore project.
