# BCH Sync and Miner Status

When Seymour MiningCore starts before the Bitcoin Cash node is fully
synced, logs may show:

``` text
[bch] Daemon has downloaded 43.89% of blockchain from 8 peers
```

This is normal.

MiningCore can start and listen on the Stratum and API ports while the
BCH node is still downloading blocks. Mining should be considered ready
only after the BCH node reports:

``` json
"initialblockdownload": false
```

## Check BCH Node Sync

``` bash
docker exec retro-mike-bch-node_node_1 bitcoin-cli \
  -rpcuser=pooluser \
  -rpcpassword=poolpassword \
  -rpcport=9002 \
  getblockchaininfo
```

Watch these fields:

-   `blocks`
-   `headers`
-   `verificationprogress`
-   `initialblockdownload`

## Check MiningCore Ports

``` bash
ss -tulpn | grep -E "6001|4000"
```

Expected:

``` text
0.0.0.0:6001 LISTEN
0.0.0.0:4000 LISTEN
```

## Watch MiningCore Logs

``` bash
docker logs -f retro-mike-miningcore_server_1
```

Look for:

``` text
connected
authorized
share accepted
```

## Miner Configuration

``` text
Pool URL : stratum+tcp://YOUR_UMBREL_IP:6001
Worker   : BCH_WALLET.workername
Password : x
```

## Current Status

-   ARM64 Docker image: Working
-   Bitcoin Cash node integration: Working
-   PostgreSQL integration: Working
-   MiningCore starts successfully
-   Waiting for full BCH blockchain synchronization before validating
    live shares
