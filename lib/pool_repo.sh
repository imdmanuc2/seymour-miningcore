#!/usr/bin/env bash
set -euo pipefail

pool_repo_dir() {
  echo "${ROOT_DIR}/config/pools"
}

pool_repo_removed_dir() {
  echo "${ROOT_DIR}/config/pools/removed"
}

pool_repo_file() {
  local pool_id="${1:-}"
  echo "$(pool_repo_dir)/${pool_id}.json"
}

pool_repo_exists() {
  local pool_id="${1:-}"
  [[ -f "$(pool_repo_file "$pool_id")" ]]
}

pool_repo_list() {
  local dir
  dir="$(pool_repo_dir)"
  mkdir -p "$dir"

  if ! ls "$dir"/*.json >/dev/null 2>&1; then
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
  }' "$dir"/*.json
}

pool_repo_archive() {
  local pool_id="${1:-}"
  local file removed_dir timestamp removed_file

  file="$(pool_repo_file "$pool_id")"
  removed_dir="$(pool_repo_removed_dir)"
  timestamp="$(date +%Y%m%d-%H%M%S)"

  if [[ ! -f "$file" ]]; then
    cat <<JSON
{
  "success": false,
  "message": "Pool not found.",
  "poolId": "${pool_id}"
}
JSON
    return 1
  fi

  mkdir -p "$removed_dir"
  removed_file="${removed_dir}/${pool_id}-${timestamp}.json"

  mv "$file" "$removed_file"

  cat <<JSON
{
  "success": true,
  "message": "Pool removed and backed up.",
  "poolId": "${pool_id}",
  "removedFile": "${removed_file}",
  "requiresRestart": true
}
JSON
}

pool_repo_save() {
  local pool_id="${1:-}"
  local source_file="${2:-}"
  local dest_file

  if [[ -z "$pool_id" || -z "$source_file" ]]; then
    echo "pool_repo_save requires pool_id and source_file" >&2
    return 1
  fi

  mkdir -p "$(pool_repo_dir)"
  dest_file="$(pool_repo_file "$pool_id")"

  cp "$source_file" "$dest_file"
  echo "$dest_file"
}
