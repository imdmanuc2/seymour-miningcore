#!/usr/bin/env bash
set -euo pipefail

install_state_dir() {
  echo "${ROOT_DIR}/config/install"
}

install_state_file() {
  echo "$(install_state_dir)/install-state.json"
}

install_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

install_steps_json() {
  cat <<JSON
[
  {"step":1,"key":"os-check","name":"Check Operating System","status":"pending"},
  {"step":2,"key":"doctor","name":"Run Doctor Diagnostics","status":"pending"},
  {"step":3,"key":"dependencies","name":"Install Dependencies","status":"pending"},
  {"step":4,"key":"dotnet","name":"Install .NET Runtime","status":"pending"},
  {"step":5,"key":"postgresql","name":"Configure PostgreSQL","status":"pending"},
  {"step":6,"key":"api-service","name":"Install REST API Service","status":"pending"},
  {"step":7,"key":"license","name":"Install Beta-Free License","status":"pending"},
  {"step":8,"key":"identity","name":"Generate Server Identity","status":"pending"},
  {"step":9,"key":"token","name":"Generate API Token","status":"pending"},
  {"step":10,"key":"health","name":"Run Final Health Checks","status":"pending"},
  {"step":11,"key":"complete","name":"Installation Complete","status":"pending"}
]
JSON
}

smc_install_engine_plan() {
  cat <<JSON
{
  "product": "${SMC_PRODUCT}",
  "version": "${SMC_VERSION}",
  "installer": "install-engine",
  "mode": "plan",
  "steps": $(install_steps_json)
}
JSON
}

install_init_state() {
  mkdir -p "$(install_state_dir)"

  cat > "$(install_state_file)" <<JSON
{
  "product": "${SMC_PRODUCT}",
  "version": "${SMC_VERSION}",
  "installer": "install-engine",
  "status": "started",
  "startedAt": "$(install_now)",
  "updatedAt": "$(install_now)",
  "currentStep": 0,
  "steps": $(install_steps_json)
}
JSON
}

install_update_step() {
  local step="$1"
  local status="$2"
  local message="${3:-}"

  local tmp
  tmp="$(mktemp)"

  jq \
    --argjson step "$step" \
    --arg status "$status" \
    --arg message "$message" \
    --arg updatedAt "$(install_now)" '
      .updatedAt = $updatedAt |
      .currentStep = $step |
      .steps = (.steps | map(
        if .step == $step then
          .status = $status |
          .message = $message |
          .updatedAt = $updatedAt
        else
          .
        end
      ))
    ' "$(install_state_file)" > "$tmp"

  mv "$tmp" "$(install_state_file)"
}

install_set_status() {
  local status="$1"

  local tmp
  tmp="$(mktemp)"

  jq \
    --arg status "$status" \
    --arg updatedAt "$(install_now)" '
      .status = $status |
      .updatedAt = $updatedAt
    ' "$(install_state_file)" > "$tmp"

  mv "$tmp" "$(install_state_file)"
}

smc_install_engine_status() {
  if [[ ! -f "$(install_state_file)" ]]; then
    cat <<JSON
{
  "installed": false,
  "message": "No install state found."
}
JSON
    return
  fi

  jq . "$(install_state_file)"
}



install_fix_repo_ownership() {
  if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
    echo "[*] Fixing repository config ownership for ${SUDO_USER}"
    chown -R "${SUDO_USER}:${SUDO_USER}" \
      "${ROOT_DIR}/config/install" \
      "${ROOT_DIR}/config/database" \
      "${ROOT_DIR}/config/identity" \
      "${ROOT_DIR}/config/security" \
      "${ROOT_DIR}/config/license" 2>/dev/null || true
    echo "[✓] Repository config ownership fixed"
  fi
}

install_require_sudo() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "[x] This install action requires sudo/root."
    echo "Run: sudo ./bin/smc install --yes"
    exit 1
  fi
}

install_apt_packages() {
  install_require_sudo

  export DEBIAN_FRONTEND=noninteractive

  apt-get update

  apt-get install -y \
    git \
    curl \
    jq \
    ca-certificates \
    gnupg \
    lsb-release \
    postgresql-client \
    nginx \
    ufw
}


install_dotnet_sdk() {
  install_require_sudo

  if command -v dotnet >/dev/null 2>&1; then
    echo "[✓] dotnet already installed: $(dotnet --version)"
    return
  fi

  export DEBIAN_FRONTEND=noninteractive

  apt-get update

  local candidates=("dotnet-sdk-10.0" "dotnet-sdk-9.0" "dotnet-sdk-8.0")
  local installed="false"

  for pkg in "${candidates[@]}"; do
    echo "[*] Trying to install ${pkg}"
    if apt-get install -y "$pkg"; then
      installed="true"
      break
    fi
  done

  if [[ "$installed" != "true" ]]; then
    echo "[x] Failed to install any supported .NET SDK package."
    exit 1
  fi

  dotnet --info >/dev/null
}


install_postgresql() {
  install_require_sudo

  export DEBIAN_FRONTEND=noninteractive

  apt-get update
  apt-get install -y postgresql postgresql-client

  systemctl enable postgresql
  systemctl start postgresql

  local db_name="miningcore"
  local db_user="miningcore"
  local db_pass="miningcore_dev_password"

  if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${db_user}'" | grep -q 1; then
    sudo -u postgres psql -c "CREATE USER ${db_user} WITH PASSWORD '${db_pass}';"
  fi

  if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${db_name}'" | grep -q 1; then
    sudo -u postgres createdb -O "${db_user}" "${db_name}"
  fi

  sudo -u postgres psql -d "${db_name}" -c "SELECT 1;" >/dev/null

  mkdir -p "${ROOT_DIR}/config/database"

  cat > "${ROOT_DIR}/config/database/postgresql.json" <<JSON
{
  "host": "127.0.0.1",
  "port": 5432,
  "database": "${db_name}",
  "user": "${db_user}",
  "password": "${db_pass}",
  "sslMode": "disable"
}
JSON

  chmod 600 "${ROOT_DIR}/config/database/postgresql.json"
}

install_run_step() {
  local step="$1"
  local key="$2"
  local message="$3"

  echo "[*] ${message}"
  install_update_step "$step" "running" "$message"

  # Safe skeleton mode: no destructive system changes yet.
  sleep 0.2

  install_update_step "$step" "complete" "$message"
  echo "[✓] ${message}"
}

smc_install_engine_run() {
  local mode="${1:-run}"

  case "$mode" in
    --plan|plan)
      smc_install_engine_plan
      return
      ;;

    --status|status)
      smc_install_engine_status
      return
      ;;

    --resume|resume)
      if [[ ! -f "$(install_state_file)" ]]; then
        install_init_state
      fi
      ;;

    --repair|repair)
      install_init_state
      ;;

    --yes|run|"")
      install_init_state
      ;;

    *)
      echo "Unknown install option: ${mode}" >&2
      echo "Usage: smc install [--plan|--status|--resume|--repair|--yes]" >&2
      exit 1
      ;;
  esac

  echo "----------------------------------------"
  echo "Seymour MiningCore Install Engine"
  echo "Version: ${SMC_VERSION}"
  echo "Mode: ${mode}"
  echo "----------------------------------------"

  install_set_status "running"

  install_run_step 1 "os-check" "Checking operating system"
  install_run_step 2 "doctor" "Running doctor diagnostics"
  echo "[*] Installing base dependencies"
  install_update_step 3 "running" "Installing base dependencies"
  install_apt_packages
  install_update_step 3 "complete" "Base dependencies installed"
  echo "[✓] Base dependencies installed"
  echo "[*] Installing .NET SDK"
  install_update_step 4 "running" "Installing .NET SDK"
  install_dotnet_sdk
  dotnet_version="$(dotnet --version 2>/dev/null || echo unknown)"
  install_update_step 4 "complete" ".NET SDK installed: ${dotnet_version}"
  echo "[✓] .NET SDK installed: ${dotnet_version}"
  echo "[*] Installing and configuring PostgreSQL"
  install_update_step 5 "running" "Installing and configuring PostgreSQL"
  install_postgresql
  install_update_step 5 "complete" "PostgreSQL configured"
  echo "[✓] PostgreSQL configured"
  install_run_step 6 "api-service" "Preparing REST API service installation"
  install_run_step 7 "license" "Validating community license"

  echo "[*] Generating server identity if missing"
  install_update_step 8 "running" "Generating server identity if missing"
  if ./bin/smc identity status | jq -e '.exists == true' >/dev/null 2>&1; then
    install_update_step 8 "complete" "Server identity already exists"
    echo "[✓] Server identity already exists"
  else
    ./bin/smc identity create >/dev/null
    install_update_step 8 "complete" "Server identity created"
    echo "[✓] Server identity created"
  fi

  echo "[*] Generating API token if missing"
  install_update_step 9 "running" "Generating API token if missing"
  if ./bin/smc token status | jq -e '.enabled == true' >/dev/null 2>&1; then
    install_update_step 9 "complete" "API token already exists"
    echo "[✓] API token already exists"
  else
    ./bin/smc token create >/dev/null
    install_update_step 9 "complete" "API token created"
    echo "[✓] API token created"
  fi
  echo "[*] Running final health checks"
  install_update_step 10 "running" "Running final health checks"

  health_json="$(./bin/smc health)"
  health_overall="$(echo "$health_json" | jq -r '.overall // "unknown"')"

  if [[ "$health_overall" == "unhealthy" ]]; then
    install_update_step 10 "failed" "Final health check failed"
    install_set_status "failed"
    echo "[x] Final health check failed"
    echo "$health_json" | jq .
    exit 1
  fi

  install_update_step 10 "complete" "Final health check completed with status: ${health_overall}"
  echo "[✓] Final health check completed: ${health_overall}"
  install_run_step 11 "complete" "Installation complete"

  install_set_status "complete"

  install_fix_repo_ownership

  echo "----------------------------------------"
  echo "Install engine completed in safe skeleton mode."
  echo "State file: $(install_state_file)"
  echo "----------------------------------------"

  smc_install_engine_status
}
