# DATA_MODEL

**Project:** Seymour MiningCore\
**Version:** 0.9.0-alpha

## Purpose

This document is the canonical definition of the data objects used by
Seymour MiningCore.

Any change to a JSON object, REST response, CLI output, or Local Console
model should be reflected here first.

------------------------------------------------------------------------

# Object Ownership

This document defines object structure.

Other documents should reference these objects instead of redefining
them.

------------------------------------------------------------------------

# Node

Represents one Seymour MiningCore server.

## Fields

-   product
-   version
-   apiVersion
-   role
-   status
-   localConsoleUrl

------------------------------------------------------------------------

# System

Represents host operating system information.

Fields:

-   hostname
-   primaryIp
-   os
-   osSupport
-   cpuLoadPercent
-   memoryUsedPercent
-   diskUsedPercent
-   uptimeSeconds

------------------------------------------------------------------------

# Service

Represents a managed service.

Fields:

-   miningcore
-   postgresql
-   localConsolePort

Future:

-   nginx
-   redis
-   bitcoin-node
-   bitcoincash-node

------------------------------------------------------------------------

# Pool

Represents one configured mining pool.

Fields:

-   poolId
-   name
-   coin
-   network
-   mode
-   enabled
-   stratumPort
-   apiPort
-   payoutScheme
-   feePercent
-   walletAddress
-   rpcHost
-   rpcPort

Future additions:

-   hashrate
-   miners
-   workers
-   blocksFound
-   paymentsPending
-   paymentsSent
-   difficulty
-   lastBlockFound

------------------------------------------------------------------------

# PoolSummary

Aggregated pool statistics.

Fields:

-   poolCount
-   enabledPools
-   soloPools
-   publicPools
-   connectedMiners
-   totalHashrate
-   blocksFound24h
-   pendingPayments

------------------------------------------------------------------------

# Health

Represents platform health.

Fields:

-   overall
-   checks\[\]

------------------------------------------------------------------------

# HealthCheck

Each entry inside the Health object.

Fields:

-   name
-   status
-   message

------------------------------------------------------------------------

# DeveloperFee

Fields:

-   required
-   percent
-   status

------------------------------------------------------------------------

# License

Fields:

-   status
-   type
-   tamperStatus

Future:

-   licenseKey
-   expires
-   signatureStatus

------------------------------------------------------------------------

# Nexus

Represents Nexus connectivity.

Fields:

-   connected
-   commandCenterUrl
-   lastSync

Future:

-   nodeId
-   assetId
-   registrationStatus
-   heartbeat

------------------------------------------------------------------------

# InstallerState

Future object used by installer and REST API.

Fields:

-   currentStep
-   totalSteps
-   progressPercent
-   state
-   message

------------------------------------------------------------------------

# Design Rules

-   Every object should have a single canonical definition in this
    document.
-   CLI JSON, REST API responses, Local Console, and Nexus Command
    Center should use these definitions whenever practical.
-   Changes to object structure must be documented here before being
    referenced elsewhere.
