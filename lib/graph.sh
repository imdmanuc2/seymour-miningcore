#!/usr/bin/env bash
set -euo pipefail

smc_graph() {
  local hostname ip pools_json nodes_json edges_json

  hostname="$(hostname)"
  ip="$(primary_ip)"

  pools_json="$(pool_repo_list | jq -c '.pools')"

  nodes_json="$(echo "$pools_json" | jq -c --arg hostname "$hostname" --arg ip "$ip" '
    [
      {
        id: ("server-" + $hostname),
        type: "server",
        label: $hostname,
        metadata: {
          ip: $ip,
          role: "seymour-miningcore-node"
        }
      }
    ]
    +
    map({
      id: ("pool-" + .poolId),
      type: "pool",
      label: .name,
      metadata: {
        poolId: .poolId,
        coin: .coin,
        network: .network,
        mode: .mode,
        enabled: .enabled,
        stratumPort: .stratumPort,
        apiPort: .apiPort,
        payoutScheme: .payoutScheme,
        feePercent: .feePercent
      }
    })
    +
    map({
      id: ("rpc-" + .poolId),
      type: "coin-node-rpc",
      label: (.coin + " RPC"),
      metadata: {
        poolId: .poolId,
        coin: .coin,
        rpcHost: .rpcHost,
        rpcPort: .rpcPort
      }
    })
  ')"

  edges_json="$(echo "$pools_json" | jq -c --arg hostname "$hostname" '
    map({
      source: ("server-" + $hostname),
      target: ("pool-" + .poolId),
      type: "HOSTS"
    })
    +
    map({
      source: ("pool-" + .poolId),
      target: ("rpc-" + .poolId),
      type: "USES_RPC"
    })
  ')"

  cat <<JSON
{
  "graphVersion": "v1",
  "source": "seymour-miningcore",
  "nodes": ${nodes_json},
  "edges": ${edges_json}
}
JSON
}
