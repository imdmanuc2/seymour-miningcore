#!/usr/bin/env bash
set -euo pipefail

token_config_file() {
  echo "${ROOT_DIR}/config/security/api-token.json"
}

token_generate() {
  openssl rand -hex 32
}

smc_token_status() {
  local file
  file="$(token_config_file)"

  if [[ ! -f "$file" ]]; then
    cat <<JSON
{
  "enabled": false,
  "message": "No API token has been created."
}
JSON
    return
  fi

  jq '{
    enabled: true,
    tokenId: .tokenId,
    createdAt: .createdAt,
    rotatedAt: .rotatedAt,
    permissions: .permissions
  }' "$file"
}

smc_token_create() {
  local file token now
  file="$(token_config_file)"

  if [[ -f "$file" ]]; then
    cat <<JSON
{
  "success": false,
  "message": "API token already exists. Use smc token rotate to generate a new one."
}
JSON
    exit 1
  fi

  mkdir -p "$(dirname "$file")"
  token="$(token_generate)"
  now="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  cat > "$file" <<JSON
{
  "tokenId": "default",
  "token": "${token}",
  "createdAt": "${now}",
  "rotatedAt": null,
  "permissions": ["read"]
}
JSON

  chmod 600 "$file"

  cat <<JSON
{
  "success": true,
  "message": "API token created.",
  "tokenId": "default",
  "token": "${token}",
  "createdAt": "${now}",
  "permissions": ["read"],
  "warning": "Save this token now. It should be treated like a password."
}
JSON
}

smc_token_show() {
  local file
  file="$(token_config_file)"

  if [[ ! -f "$file" ]]; then
    cat <<JSON
{
  "success": false,
  "message": "No API token exists."
}
JSON
    exit 1
  fi

  jq '{
    tokenId: .tokenId,
    token: .token,
    createdAt: .createdAt,
    rotatedAt: .rotatedAt,
    permissions: .permissions
  }' "$file"
}

smc_token_rotate() {
  local file token now
  file="$(token_config_file)"

  if [[ ! -f "$file" ]]; then
    smc_token_create
    return
  fi

  token="$(token_generate)"
  now="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  tmp="$(mktemp)"
  jq --arg token "$token" --arg now "$now" '
    .token = $token |
    .rotatedAt = $now
  ' "$file" > "$tmp"
  mv "$tmp" "$file"
  chmod 600 "$file"

  cat <<JSON
{
  "success": true,
  "message": "API token rotated.",
  "tokenId": "default",
  "token": "${token}",
  "rotatedAt": "${now}",
  "warning": "Update Nexus Command Center with this new token."
}
JSON
}

smc_token_command() {
  local action="${1:-status}"

  case "$action" in
    status)
      smc_token_status
      ;;
    create)
      smc_token_create
      ;;
    show)
      smc_token_show
      ;;
    rotate)
      smc_token_rotate
      ;;
    *)
      echo "Unknown token command: $action" >&2
      echo "Usage: smc token <status|create|show|rotate>" >&2
      exit 1
      ;;
  esac
}
