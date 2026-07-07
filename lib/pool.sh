#!/usr/bin/env bash
set -euo pipefail

smc_pool_template() {
  cat <<JSON
{
  "poolId": "",
  "name": "",
  "coin": "BTC",
  "network": "mainnet",
  "mode": "solo",
  "enabled": true,
  "stratum": {
    "host": "",
    "port": 3333,
    "tls": false
  },
  "api": {
    "enabled": true,
    "port": 4000
  },
  "rpc": {
    "host": "",
    "port": 8332,
    "username": "",
    "password": ""
  },
  "wallet": {
    "address": ""
  },
  "payout": {
    "scheme": "SOLO",
    "minimumPayment": "0.0001",
    "feePercent": 0.75
  }
}
JSON
}

smc_pool_list() {
  cat <<JSON
{
  "pools": []
}
JSON
}

smc_pool_validate() {
  local file="${1:-}"

  if [[ -z "$file" ]]; then
    echo "Usage: smc pool-validate <pool.json>" >&2
    echo "   or: smc pool validate <pool.json>" >&2
    exit 1
  fi

  if [[ ! -f "$file" ]]; then
    echo "ERROR: File not found: $file" >&2
    exit 1
  fi

  local required_fields=(
    ".poolId"
    ".coin"
    ".network"
    ".mode"
    ".rpc.host"
    ".rpc.port"
    ".wallet.address"
    ".payout.feePercent"
  )

  local valid=true
  local missing_json=""

  for field in "${required_fields[@]}"; do
    value="$(jq -r "$field // empty" "$file")"

    if [[ -z "$value" ]]; then
      valid=false
      echo "Missing: $field" >&2
      if [[ -z "$missing_json" ]]; then
        missing_json="\"$field\""
      else
        missing_json="${missing_json}, \"$field\""
      fi
    fi
  done

  if $valid; then
    cat <<JSON
{
  "valid": true,
  "message": "Pool configuration is valid.",
  "missing": []
}
JSON
  else
    cat <<JSON
{
  "valid": false,
  "message": "Pool configuration contains missing fields.",
  "missing": [${missing_json}]
}
JSON
    exit 1
  fi
}
