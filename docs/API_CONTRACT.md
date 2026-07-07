# Seymour MiningCore API Contract

Version: 0.1 Draft  
Target Product: Seymour MiningCore  
Consumer: Nexus Command Center, Local Console, CLI tools, installer scripts

## Purpose

This API contract defines how Nexus Command Center reads and manages Seymour MiningCore.

Nexus should treat every Seymour MiningCore install as a managed mining node.

The API should expose every useful piece of data available from:

- MiningCore
- Pool configuration
- Coin daemon RPC
- PostgreSQL
- Operating system
- Systemd services
- Local Console
- License/security/update systems

The API should be richer than the UI. Nexus decides what to display.

---

# Base URL

Default Local Console/API port:

```text
http://server-ip:8559
```

API base path:

```text
/api/v1
```

Example:

```text
http://192.168.1.154:8559/api/v1/status
```

---

# Authentication

Beta phase may allow local/LAN unauthenticated read-only testing.

Production should require:

- API key
- Nexus registration token
- Optional mTLS later
- Role-based permissions later

Recommended header:

```text
Authorization: Bearer <api-token>
```

---

# Core Read Endpoints

## System / Product

```text
GET /api/v1/status
GET /api/v1/system
GET /api/v1/health
GET /api/v1/version
GET /api/v1/license
GET /api/v1/updates
GET /api/v1/security/tamper-status
```

## Pools

```text
GET /api/v1/pools
GET /api/v1/pools/{poolId}
GET /api/v1/pools/{poolId}/summary
GET /api/v1/pools/{poolId}/hashrate
GET /api/v1/pools/{poolId}/workers
GET /api/v1/pools/{poolId}/blocks
GET /api/v1/pools/{poolId}/payments
GET /api/v1/pools/{poolId}/shares
GET /api/v1/pools/{poolId}/config
```

## Workers / Miners

```text
GET /api/v1/workers
GET /api/v1/workers/{workerId}
GET /api/v1/workers/{workerId}/hashrate
GET /api/v1/workers/{workerId}/shares
GET /api/v1/workers/{workerId}/payments
```

## Blocks / Payments

```text
GET /api/v1/blocks
GET /api/v1/blocks/{blockId}
GET /api/v1/payments
GET /api/v1/payments/{paymentId}
```

## Coin Nodes

```text
GET /api/v1/nodes
GET /api/v1/nodes/{nodeId}
GET /api/v1/nodes/{nodeId}/rpc
GET /api/v1/nodes/{nodeId}/sync
GET /api/v1/nodes/{nodeId}/peers
GET /api/v1/nodes/{nodeId}/wallet
```

## Logs / Alerts

```text
GET /api/v1/logs
GET /api/v1/logs/miningcore
GET /api/v1/logs/systemd
GET /api/v1/alerts
GET /api/v1/events
```

---

# Management Endpoints

These should require authentication and elevated permissions.

## Service Control

```text
POST /api/v1/service/start
POST /api/v1/service/stop
POST /api/v1/service/restart
POST /api/v1/service/reload
```

## Pool Lifecycle

```text
POST /api/v1/pools
PUT /api/v1/pools/{poolId}
POST /api/v1/pools/{poolId}/enable
POST /api/v1/pools/{poolId}/disable
POST /api/v1/pools/{poolId}/validate
DELETE /api/v1/pools/{poolId}
```

## Configuration

```text
GET /api/v1/config
POST /api/v1/config/validate
POST /api/v1/config/apply
POST /api/v1/config/backup
POST /api/v1/config/restore
```

## Nexus

```text
GET /api/v1/nexus/status
POST /api/v1/nexus/register
POST /api/v1/nexus/unregister
POST /api/v1/nexus/sync
```

## Updates

```text
POST /api/v1/updates/check
POST /api/v1/updates/apply
```

---

# Required Dashboard Data

Nexus Command Center dashboard needs this immediately:

```text
Product name
Version
License status
Developer fee status
Overall health
Server hostname
Server IP
OS
CPU load
Memory usage
Disk usage
Uptime
MiningCore service status
PostgreSQL status
Local Console URL
Nexus connection status
Pool count
Enabled pools
Solo pool count
Public pool count
Total connected miners
Total hashrate
Blocks found
Pending payments
Recent alerts
Recent events
```

---

# Status Response

Endpoint:

```text
GET /api/v1/status
```

Example:

```json
{
  "product": "Seymour MiningCore",
  "role": "managed-mining-node",
  "version": "0.9.0-alpha",
  "apiVersion": "v1",
  "status": "running",
  "localConsoleUrl": "http://192.168.1.154:8559",
  "developerFee": {
    "required": true,
    "percent": 0.75,
    "status": "active"
  },
  "license": {
    "status": "valid",
    "type": "commercial-open-source",
    "tamperStatus": "unknown"
  },
  "nexus": {
    "connected": false,
    "commandCenterUrl": null,
    "lastSync": null
  },
  "system": {
    "hostname": "miningcore-vm",
    "primaryIp": "192.168.1.154",
    "os": "Ubuntu 24.04",
    "cpuLoadPercent": 12,
    "memoryUsedPercent": 41,
    "diskUsedPercent": 18,
    "uptimeSeconds": 45622
  },
  "summary": {
    "poolCount": 2,
    "enabledPools": 2,
    "soloPools": 1,
    "publicPools": 1,
    "connectedMiners": 14,
    "totalHashrate": "1.21 PH/s",
    "blocksFound24h": 0,
    "pendingPayments": 0
  },
  "health": {
    "overall": "healthy",
    "checks": []
  }
}
```

---

# Pool Object

Every pool must include this shape.

```json
{
  "poolId": "btc-solo",
  "name": "Bitcoin Solo Pool",
  "coin": "BTC",
  "network": "mainnet",
  "mode": "solo",
  "enabled": true,
  "stratum": {
    "host": "192.168.1.154",
    "port": 3333,
    "tls": false,
    "nicehashCompatible": false
  },
  "api": {
    "enabled": true,
    "port": 4000
  },
  "payout": {
    "scheme": "SOLO",
    "feePercent": 0.75,
    "minimumPayment": "0.0001"
  },
  "node": {
    "nodeId": "btc-mainnet-node-1",
    "rpcStatus": "connected",
    "syncStatus": "synced",
    "blockHeight": 0,
    "peers": 0
  },
  "stats": {
    "connectedMiners": 0,
    "hashrate": "0 H/s",
    "validShares": 0,
    "invalidShares": 0,
    "staleShares": 0,
    "blocksFound": 0,
    "lastBlockTime": null
  },
  "health": {
    "overall": "unknown",
    "lastChecked": null
  }
}
```

---

# Pool Modes

## Solo Pool

```json
{
  "mode": "solo",
  "payoutScheme": "SOLO",
  "description": "Block finder receives reward minus mandatory 0.75% developer fee."
}
```

## Public Pool

```json
{
  "mode": "public",
  "payoutScheme": "PPLNS",
  "description": "Miners share rewards according to configured payout scheme minus mandatory 0.75% developer fee."
}
```

Supported public payout schemes may include:

```text
PPLNS
PPS
PROP
```

Beta can start with PPLNS if needed.

---

# Worker Object

```json
{
  "workerId": "btc-solo.worker1",
  "poolId": "btc-solo",
  "coin": "BTC",
  "walletAddress": "bc1...",
  "workerName": "worker1",
  "connected": true,
  "ipAddress": "192.168.1.210",
  "userAgent": "Antminer",
  "hashrate": {
    "current": "110 TH/s",
    "average10m": "108 TH/s",
    "average1h": "105 TH/s",
    "average24h": "102 TH/s"
  },
  "shares": {
    "valid": 12345,
    "invalid": 2,
    "stale": 1
  },
  "lastSeen": "2026-07-06T19:00:00-05:00"
}
```

---

# Block Object

```json
{
  "blockId": "btc-mainnet-850000",
  "poolId": "btc-solo",
  "coin": "BTC",
  "network": "mainnet",
  "height": 850000,
  "status": "pending",
  "hash": null,
  "reward": "3.125",
  "finder": "btc-solo.worker1",
  "foundAt": "2026-07-06T19:00:00-05:00",
  "confirmedAt": null
}
```

Block statuses:

```text
pending
confirmed
orphaned
rejected
paid
```

---

# Payment Object

```json
{
  "paymentId": "pay_001",
  "poolId": "btc-public",
  "coin": "BTC",
  "walletAddress": "bc1...",
  "amount": "0.00125",
  "txid": null,
  "status": "pending",
  "createdAt": "2026-07-06T19:00:00-05:00",
  "paidAt": null
}
```

Payment statuses:

```text
pending
processing
paid
failed
held
```

---

# Node Object

```json
{
  "nodeId": "btc-mainnet-node-1",
  "coin": "BTC",
  "network": "mainnet",
  "host": "192.168.1.156",
  "rpcPort": 8332,
  "rpcStatus": "connected",
  "syncStatus": "synced",
  "blockHeight": 850000,
  "headers": 850000,
  "verificationProgress": 1.0,
  "peers": 12,
  "walletEnabled": true,
  "lastChecked": "2026-07-06T19:00:00-05:00"
}
```

---

# Health Check Object

```json
{
  "overall": "healthy",
  "checks": [
    {
      "name": "miningcore-service",
      "status": "healthy",
      "message": "Service is running"
    },
    {
      "name": "postgresql",
      "status": "healthy",
      "message": "PostgreSQL is running"
    },
    {
      "name": "disk",
      "status": "healthy",
      "message": "Disk usage below threshold"
    },
    {
      "name": "btc-rpc",
      "status": "healthy",
      "message": "Bitcoin RPC reachable"
    }
  ]
}
```

Health statuses:

```text
healthy
warning
unhealthy
unknown
```

---

# Alerts

```json
{
  "alertId": "alert_001",
  "severity": "warning",
  "source": "pool",
  "poolId": "btc-solo",
  "message": "Stale shares above threshold",
  "createdAt": "2026-07-06T19:00:00-05:00",
  "resolved": false
}
```

Severities:

```text
info
warning
critical
```

---

# Events / Activity Feed

```json
{
  "eventId": "evt_001",
  "type": "pool.started",
  "source": "system",
  "message": "BTC solo pool started",
  "createdAt": "2026-07-06T19:00:00-05:00",
  "metadata": {
    "poolId": "btc-solo"
  }
}
```

Recommended event types:

```text
system.started
system.stopped
service.restarted
pool.created
pool.started
pool.stopped
pool.disabled
pool.enabled
worker.connected
worker.disconnected
block.found
block.confirmed
payment.created
payment.paid
node.connected
node.disconnected
health.warning
health.critical
nexus.registered
nexus.sync
update.available
security.tamper_detected
```

---

# Add Pool Request

Endpoint:

```text
POST /api/v1/pools
```

Example:

```json
{
  "coin": "BTC",
  "network": "mainnet",
  "mode": "solo",
  "poolId": "btc-solo",
  "name": "Bitcoin Solo Pool",
  "stratumPort": 3333,
  "node": {
    "host": "192.168.1.156",
    "rpcPort": 8332,
    "rpcUser": "btcuser",
    "rpcPassword": "secret"
  },
  "payout": {
    "scheme": "SOLO",
    "walletAddress": "bc1..."
  }
}
```

Expected response:

```json
{
  "success": true,
  "poolId": "btc-solo",
  "message": "Pool created and validated",
  "requiresRestart": true
}
```

---

# Nexus UI Mapping

## Command Center Dashboard

Use:

```text
GET /api/v1/status
GET /api/v1/alerts
GET /api/v1/events
```

## Mining Page

Use:

```text
GET /api/v1/pools
GET /api/v1/hashrate
GET /api/v1/workers
GET /api/v1/blocks
GET /api/v1/payments
```

## Infrastructure Map

Use:

```text
GET /api/v1/system
GET /api/v1/nodes
GET /api/v1/pools
GET /api/v1/workers
```

## Pool Detail Drawer

Use:

```text
GET /api/v1/pools/{poolId}
GET /api/v1/pools/{poolId}/workers
GET /api/v1/pools/{poolId}/blocks
GET /api/v1/pools/{poolId}/payments
GET /api/v1/pools/{poolId}/config
```

## Miner/Worker Drawer

Use:

```text
GET /api/v1/workers/{workerId}
GET /api/v1/workers/{workerId}/hashrate
GET /api/v1/workers/{workerId}/shares
```

## Node Drawer

Use:

```text
GET /api/v1/nodes/{nodeId}
GET /api/v1/nodes/{nodeId}/sync
GET /api/v1/nodes/{nodeId}/peers
GET /api/v1/nodes/{nodeId}/wallet
```

---

# Beta Implementation Priority

For beta, implement these first:

```text
GET /api/v1/status
GET /api/v1/health
GET /api/v1/system
GET /api/v1/pools
GET /api/v1/workers
GET /api/v1/blocks
GET /api/v1/payments
GET /api/v1/nodes
GET /api/v1/alerts
GET /api/v1/events
GET /api/v1/version
GET /api/v1/license
```

Management endpoints can follow after the UI has live read-only data.

---

# Notes for Nexus Command Center Thread

Nexus can start building UI immediately against mock data using this contract.

Use these assumptions:

- Seymour MiningCore Local Console/API default port is 8559.
- Every pool has a `mode`: `solo` or `public`.
- Every pool has a `coin`: initially `BTC` or `BCH`.
- Every pool has a mandatory `feePercent` of `0.75`.
- Nexus should display developer fee/license status but should not manage or hide it.
- Nexus should treat each Seymour MiningCore server as a managed mining node.
- Nexus should support adding more pools/coins later through the Pool Lifecycle API.
