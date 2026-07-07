#!/usr/bin/env bash
set -euo pipefail

smc_status() {
  local hostname os uptime_seconds disk_used memory_used ip os_support
  local miningcore_status postgres_status console_port_status

  hostname="$(hostname)"
  os="$(. /etc/os-release && echo "$PRETTY_NAME")"
  uptime_seconds="$(awk '{print int($1)}' /proc/uptime)"
  disk_used="$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')"
  memory_used="$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')"
  ip="$(primary_ip)"
  os_support="$(supported_os_status)"

  miningcore_status="$(service_status "${MININGCORE_SERVICE}")"
  postgres_status="$(service_status "postgresql")"
  console_port_status="$(port_status "${LOCAL_CONSOLE_PORT}")"
  pool_count="$(find "${ROOT_DIR}/config/pools" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l)"
  enabled_pools="$(jq -s '[.[] | select(.enabled == true)] | length' "${ROOT_DIR}"/config/pools/*.json 2>/dev/null || echo 0)"
  solo_pools="$(jq -s '[.[] | select(.mode == "solo")] | length' "${ROOT_DIR}"/config/pools/*.json 2>/dev/null || echo 0)"
  public_pools="$(jq -s '[.[] | select(.mode == "public")] | length' "${ROOT_DIR}"/config/pools/*.json 2>/dev/null || echo 0)"

  cat <<JSON
{
  "product": "${SMC_PRODUCT}",
  "role": "managed-mining-node",
  "version": "${SMC_VERSION}",
  "apiVersion": "v1",
  "status": "${miningcore_status}",
  "localConsoleUrl": "http://${ip}:${LOCAL_CONSOLE_PORT}",
  "developerFee": {
    "required": true,
    "percent": ${SMC_FEE_PERCENT},
    "status": "active"
  },
  "license": {
    "status": "draft",
    "type": "commercial-open-source",
    "tamperStatus": "unknown"
  },
  "nexus": {
    "connected": false,
    "commandCenterUrl": null,
    "lastSync": null
  },
  "system": {
    "hostname": "$(json_escape "$hostname")",
    "primaryIp": "${ip}",
    "os": "$(json_escape "$os")",
    "osSupport": "${os_support}",
    "cpuLoadPercent": 0,
    "memoryUsedPercent": ${memory_used},
    "diskUsedPercent": ${disk_used},
    "uptimeSeconds": ${uptime_seconds}
  },
  "services": {
    "miningcore": "${miningcore_status}",
    "postgresql": "${postgres_status}",
    "localConsolePort": "${console_port_status}"
  },
  "summary": {
    "poolCount": ${pool_count},
    "enabledPools": ${enabled_pools},
    "soloPools": ${solo_pools},
    "publicPools": ${public_pools},
    "connectedMiners": 0,
    "totalHashrate": "0 H/s",
    "blocksFound24h": 0,
    "pendingPayments": 0
  },
  "pools": [],
  "health": {
    "overall": "unknown",
    "checks": []
  }
}
JSON
}
