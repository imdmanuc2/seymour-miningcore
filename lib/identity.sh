#!/usr/bin/env bash
set -euo pipefail

identity_config_dir() {
  echo "${ROOT_DIR}/config/identity"
}

identity_config_file() {
  echo "$(identity_config_dir)/server-identity.json"
}

identity_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

identity_generate_id() {
  if command -v uuidgen >/dev/null 2>&1; then
    echo "SMC-$(uuidgen | tr '[:lower:]' '[:upper:]')"
  else
    echo "SMC-$(openssl rand -hex 16 | tr '[:lower:]' '[:upper:]')"
  fi
}

smc_identity_create() {
  local file server_id now hostname ip os

  file="$(identity_config_file)"

  if [[ -f "$file" ]]; then
    cat <<JSON
{
  "success": false,
  "message": "Server identity already exists.",
  "identityFile": "${file}"
}
JSON
    exit 1
  fi

  mkdir -p "$(identity_config_dir)"

  server_id="$(identity_generate_id)"
  now="$(identity_now)"
  hostname="$(hostname)"
  ip="$(primary_ip)"
  os="$(os_pretty_name)"

  cat > "$file" <<JSON
{
  "serverId": "${server_id}",
  "product": "${SMC_PRODUCT}",
  "version": "${SMC_VERSION}",
  "hostname": "${hostname}",
  "primaryIp": "${ip}",
  "os": "${os}",
  "createdAt": "${now}",
  "registration": {
    "status": "local",
    "nexusConnected": false,
    "commandCenterUrl": null,
    "lastSync": null
  }
}
JSON

  chmod 600 "$file"

  cat <<JSON
{
  "success": true,
  "message": "Server identity created.",
  "serverId": "${server_id}",
  "identityFile": "${file}"
}
JSON
}

smc_identity_show() {
  local file
  file="$(identity_config_file)"

  if [[ ! -f "$file" ]]; then
    cat <<JSON
{
  "exists": false,
  "message": "No server identity exists."
}
JSON
    return
  fi

  jq . "$file"
}

smc_identity_status() {
  local file
  file="$(identity_config_file)"

  if [[ ! -f "$file" ]]; then
    cat <<JSON
{
  "exists": false,
  "status": "missing",
  "message": "No server identity exists."
}
JSON
    return
  fi

  jq '{
    exists: true,
    status: "present",
    serverId: .serverId,
    hostname: .hostname,
    primaryIp: .primaryIp,
    createdAt: .createdAt,
    registration: .registration
  }' "$file"
}

smc_identity_command() {
  local action="${1:-status}"

  case "$action" in
    status)
      smc_identity_status
      ;;
    create)
      smc_identity_create
      ;;
    show)
      smc_identity_show
      ;;
    *)
      echo "Unknown identity command: $action" >&2
      echo "Usage: smc identity <status|create|show>" >&2
      exit 1
      ;;
  esac
}
