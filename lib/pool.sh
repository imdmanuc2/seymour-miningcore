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
  local pool_dir="${ROOT_DIR}/config/pools"

  mkdir -p "$pool_dir"

  if ! ls "$pool_dir"/*.json >/dev/null 2>&1; then
    cat <<JSON
{
  "pools": []
}
JSON
    return
  fi

  jq -s '{
    pools: map({
      poolId: .poolId,
      name: .name,
      coin: .coin,
      network: .network,
      mode: .mode,
      enabled: .enabled,
      stratumPort: .stratum.port,
      apiPort: .api.port,
      payoutScheme: .payout.scheme,
      feePercent: .payout.feePercent,
      walletAddress: .wallet.address,
      rpcHost: .rpc.host,
      rpcPort: .rpc.port
    })
  }' "$pool_dir"/*.json
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

smc_pool_create() {
  local coin=""
  local mode=""
  local pool_id=""
  local name=""
  local rpc_host=""
  local rpc_port=""
  local rpc_user=""
  local rpc_password=""
  local wallet=""
  local stratum_port=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --coin)
        coin="${2:-}"
        shift 2
        ;;
      --mode)
        mode="${2:-}"
        shift 2
        ;;
      --pool-id)
        pool_id="${2:-}"
        shift 2
        ;;
      --name)
        name="${2:-}"
        shift 2
        ;;
      --rpc-host)
        rpc_host="${2:-}"
        shift 2
        ;;
      --rpc-port)
        rpc_port="${2:-}"
        shift 2
        ;;
      --rpc-user)
        rpc_user="${2:-}"
        shift 2
        ;;
      --rpc-password)
        rpc_password="${2:-}"
        shift 2
        ;;
      --wallet)
        wallet="${2:-}"
        shift 2
        ;;
      --stratum-port)
        stratum_port="${2:-}"
        shift 2
        ;;
      *)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    esac
  done

  if [[ -z "$coin" || -z "$mode" ]]; then
    echo "Usage: smc pool create --coin BTC --mode solo --pool-id btc-solo --wallet WALLET" >&2
    exit 1
  fi

  coin_lower="$(echo "$coin" | tr '[:upper:]' '[:lower:]')"
  mode_lower="$(echo "$mode" | tr '[:upper:]' '[:lower:]')"

  template="${ROOT_DIR}/templates/coins/${coin_lower}/${mode_lower}.json"

  if [[ ! -f "$template" ]]; then
    cat <<JSON
{
  "success": false,
  "message": "Template not found.",
  "template": "${template}"
}
JSON
    exit 1
  fi

  mkdir -p "${ROOT_DIR}/config/pools"

  if [[ -z "$pool_id" ]]; then
    pool_id="${coin_lower}-${mode_lower}"
  fi

  output="${ROOT_DIR}/config/pools/${pool_id}.json"

  if [[ -f "$output" ]]; then
    cat <<JSON
{
  "success": false,
  "message": "Pool already exists.",
  "poolId": "${pool_id}",
  "configFile": "${output}"
}
JSON
    exit 1
  fi

  tmp="$(mktemp)"
  cp "$template" "$tmp"

  jq_arg_string='.'

  jq_args=()

  jq_args+=(--arg poolId "$pool_id")
  jq_arg_string+=' | .poolId = $poolId'

  if [[ -n "$name" ]]; then
    jq_args+=(--arg name "$name")
    jq_arg_string+=' | .name = $name'
  fi

  if [[ -n "$rpc_host" ]]; then
    jq_args+=(--arg rpcHost "$rpc_host")
    jq_arg_string+=' | .rpc.host = $rpcHost'
  fi

  if [[ -n "$rpc_port" ]]; then
    jq_args+=(--argjson rpcPort "$rpc_port")
    jq_arg_string+=' | .rpc.port = $rpcPort'
  fi

  if [[ -n "$rpc_user" ]]; then
    jq_args+=(--arg rpcUser "$rpc_user")
    jq_arg_string+=' | .rpc.username = $rpcUser'
  fi

  if [[ -n "$rpc_password" ]]; then
    jq_args+=(--arg rpcPassword "$rpc_password")
    jq_arg_string+=' | .rpc.password = $rpcPassword'
  fi

  if [[ -n "$wallet" ]]; then
    jq_args+=(--arg wallet "$wallet")
    jq_arg_string+=' | .wallet.address = $wallet'
  fi

  if [[ -n "$stratum_port" ]]; then
    jq_args+=(--argjson stratumPort "$stratum_port")
    jq_arg_string+=' | .stratum.port = $stratumPort'
  fi

  jq "${jq_args[@]}" "$jq_arg_string" "$tmp" > "$output"
  rm -f "$tmp"

  if smc_pool_validate "$output" >/dev/null; then
    cat <<JSON
{
  "success": true,
  "message": "Pool created.",
  "poolId": "${pool_id}",
  "coin": "$(jq -r '.coin' "$output")",
  "mode": "$(jq -r '.mode' "$output")",
  "configFile": "${output}",
  "requiresRestart": true
}
JSON
  else
    rm -f "$output"
    cat <<JSON
{
  "success": false,
  "message": "Pool validation failed. Config was not saved.",
  "poolId": "${pool_id}"
}
JSON
    exit 1
  fi
}

smc_pool_set_enabled() {
  local pool_id="${1:-}"
  local enabled_value="${2:-}"

  if [[ -z "$pool_id" || -z "$enabled_value" ]]; then
    echo "Usage: smc pool enable <poolId> OR smc pool disable <poolId>" >&2
    exit 1
  fi

  local file="${ROOT_DIR}/config/pools/${pool_id}.json"

  if [[ ! -f "$file" ]]; then
    cat <<JSON
{
  "success": false,
  "message": "Pool not found.",
  "poolId": "${pool_id}"
}
JSON
    exit 1
  fi

  local tmp
  tmp="$(mktemp)"

  jq --argjson enabled "$enabled_value" '.enabled = $enabled' "$file" > "$tmp"
  mv "$tmp" "$file"

  cat <<JSON
{
  "success": true,
  "message": "Pool updated.",
  "poolId": "${pool_id}",
  "enabled": ${enabled_value},
  "configFile": "${file}",
  "requiresRestart": true
}
JSON
}