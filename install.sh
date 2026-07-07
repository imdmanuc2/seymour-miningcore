#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SMC="${ROOT_DIR}/bin/smc"

INSTALL_MODE="interactive"
ASSUME_YES="false"

for arg in "$@"; do
  case "$arg" in
    --json)
      INSTALL_MODE="json"
      ;;
    --yes|-y)
      ASSUME_YES="true"
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

log() {
  if [[ "$INSTALL_MODE" != "json" ]]; then
    echo "$@"
  fi
}

fail_json() {
  local message="$1"
  cat <<JSON
{
  "product": "Seymour MiningCore",
  "installer": "install.sh",
  "success": false,
  "message": "${message}"
}
JSON
  exit 1
}

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    if [[ "$INSTALL_MODE" == "json" ]]; then
      fail_json "Run installer with sudo."
    fi
    echo "ERROR: Run with sudo."
    echo "Example: sudo ./install.sh"
    exit 1
  fi
}

detect_os() {
  if [[ ! -f /etc/os-release ]]; then
    fail_json "Cannot detect operating system."
  fi

  . /etc/os-release

  OS_ID="${ID}"
  OS_VERSION="${VERSION_ID:-unknown}"
  OS_NAME="${PRETTY_NAME}"
}

validate_os() {
  case "${OS_ID}:${OS_VERSION}" in
    ubuntu:24.04|debian:12|debian:13)
      OS_SUPPORT="supported"
      ;;
    *)
      OS_SUPPORT="dev-unsupported"
      ;;
  esac
}

confirm_license() {
  if [[ "$INSTALL_MODE" == "json" || "$ASSUME_YES" == "true" ]]; then
    return
  fi

  echo
  echo "Seymour MiningCore includes a mandatory 0.75% developer fee."
  echo "Use of this software requires acceptance of this fee."
  echo
  read -r -p "Continue? [y/N] " answer

  case "$answer" in
    y|Y|yes|YES)
      ;;
    *)
      echo "Install cancelled."
      exit 1
      ;;
  esac
}

main() {
  require_root
  detect_os
  validate_os

  log "----------------------------------------"
  log "Seymour MiningCore Installer"
  log "----------------------------------------"
  log "Detected OS: ${OS_NAME}"
  log "OS Support: ${OS_SUPPORT}"
  log "Mandatory Developer Fee: 0.75%"
  log

  confirm_license

  if [[ ! -x "$SMC" ]]; then
    fail_json "SMC CLI not found or not executable at ${SMC}"
  fi

  STATUS_JSON="$("$SMC" status)"

  if [[ "$INSTALL_MODE" == "json" ]]; then
    cat <<JSON
{
  "product": "Seymour MiningCore",
  "installer": "install.sh",
  "success": true,
  "status": "skeleton-ok",
  "message": "Installer framework is ready. Dependency installation comes next.",
  "os": {
    "name": "${OS_NAME}",
    "id": "${OS_ID}",
    "version": "${OS_VERSION}",
    "support": "${OS_SUPPORT}"
  },
  "developerFee": {
    "required": true,
    "percent": 0.75
  },
  "smcStatus": ${STATUS_JSON}
}
JSON
  else
    echo "Installer framework is ready."
    echo "Dependency installation comes next."
    echo
    echo "Current SMC status:"
    "$SMC" status
  fi
}

main
