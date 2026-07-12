#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

RUNTIME_DIR="/opt/seymour-miningcore/miningcore"
CONFIG_DIR="/etc/seymour-miningcore"
CONFIG_FILE="${CONFIG_DIR}/miningcore.json"
SERVICE_FILE="/etc/systemd/system/seymour-miningcore.service"
DOTNET="/opt/dotnet6/dotnet"

DB_CONFIG="${ROOT_DIR}/config/database/postgresql.json"
DB_SCHEMA="${ROOT_DIR}/src/Miningcore/Persistence/Postgres/Scripts/createdb.sql"
DB_APPENDIX="${ROOT_DIR}/src/Miningcore/Persistence/Postgres/Scripts/createdb_postgresql_11_appendix.sql"

SERVICE_USER="seymour-miningcore"
BTC_RPC_HOST="192.168.1.169"
BTC_RPC_PORT="8332"
STRATUM_PORT="3333"
API_PORT="4000"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script with sudo:"
  echo "sudo ./scripts/configure-btc-solo-runtime.sh"
  exit 1
fi

for required in "$DOTNET" "$RUNTIME_DIR/Miningcore.dll" "$DB_CONFIG" "$DB_SCHEMA"; do
  if [[ ! -e "$required" ]]; then
    echo "Missing required file: $required"
    exit 1
  fi
done

echo
echo "Seymour MiningCore BTC Solo Setup"
echo "---------------------------------"

read -r -p "Bitcoin RPC username: " BTC_RPC_USER
read -r -s -p "Bitcoin RPC password: " BTC_RPC_PASSWORD
echo
read -r -p "BTC pool payout address: " BTC_POOL_ADDRESS
DEV_FEE_ADDRESS="$("${ROOT_DIR}/bin/smc" developer-fee address BTC)"
DEV_FEE_PERCENT="$("${ROOT_DIR}/bin/smc" developer-fee percent BTC)"
echo "Seymour developer fee: ${DEV_FEE_PERCENT}%"
echo "Seymour BTC fee address: ${DEV_FEE_ADDRESS}"

for value_name in BTC_RPC_USER BTC_RPC_PASSWORD BTC_POOL_ADDRESS DEV_FEE_ADDRESS DEV_FEE_PERCENT; do
  if [[ -z "${!value_name}" ]]; then
    echo "Required value is empty: ${value_name}"
    exit 1
  fi
done

echo
echo "[*] Testing Bitcoin RPC authentication"

RPC_RESPONSE="$(
  curl --silent --show-error --fail \
    --user "${BTC_RPC_USER}:${BTC_RPC_PASSWORD}" \
    --data-binary \
      '{"jsonrpc":"1.0","id":"seymour-setup","method":"getblockchaininfo","params":[]}' \
    -H 'content-type:text/plain;' \
    "http://${BTC_RPC_HOST}:${BTC_RPC_PORT}/"
)"

RPC_CHAIN="$(jq -r '.result.chain // empty' <<<"$RPC_RESPONSE")"
RPC_IBD="$(jq -r '.result.initialblockdownload | tostring' <<<"$RPC_RESPONSE")"
RPC_ERROR="$(jq -r '.error // empty' <<<"$RPC_RESPONSE")"

if [[ "$RPC_CHAIN" != "main" || "$RPC_IBD" != "false" || -n "$RPC_ERROR" ]]; then
  echo "Bitcoin RPC validation failed."
  jq . <<<"$RPC_RESPONSE"
  exit 1
fi

echo "[✓] Bitcoin RPC is authenticated, synced, and on mainnet"

DB_HOST="$(jq -r '.host' "$DB_CONFIG")"
DB_PORT="$(jq -r '.port' "$DB_CONFIG")"
DB_NAME="$(jq -r '.database' "$DB_CONFIG")"
DB_USER="$(jq -r '.user' "$DB_CONFIG")"
DB_PASSWORD="$(jq -r '.password' "$DB_CONFIG")"

echo "[*] Initializing PostgreSQL schema"

TABLE_EXISTS="$(
  PGPASSWORD="$DB_PASSWORD" psql \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    -tAc "SELECT to_regclass('public.shares') IS NOT NULL;"
)"

if [[ "$TABLE_EXISTS" != "t" ]]; then
  PGPASSWORD="$DB_PASSWORD" psql \
    -v ON_ERROR_STOP=1 \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    -f "$DB_SCHEMA"

  if [[ -f "$DB_APPENDIX" ]]; then
    PGPASSWORD="$DB_PASSWORD" psql \
      -v ON_ERROR_STOP=1 \
      -h "$DB_HOST" \
      -p "$DB_PORT" \
      -U "$DB_USER" \
      -d "$DB_NAME" \
      -f "$DB_APPENDIX"
  fi

  echo "[✓] PostgreSQL schema created"
else
  echo "[✓] PostgreSQL schema already exists"
fi

echo "[*] Creating dedicated service account"

if ! id "$SERVICE_USER" >/dev/null 2>&1; then
  useradd \
    --system \
    --home-dir "$RUNTIME_DIR" \
    --shell /usr/sbin/nologin \
    "$SERVICE_USER"
fi

install -d -m 0750 -o root -g "$SERVICE_USER" "$CONFIG_DIR"
install -d -m 0750 -o "$SERVICE_USER" -g "$SERVICE_USER" \
  /var/lib/seymour-miningcore \
  /var/log/seymour-miningcore

echo "[*] Generating MiningCore runtime configuration"

jq -n \
  --arg dbHost "$DB_HOST" \
  --argjson dbPort "$DB_PORT" \
  --arg dbName "$DB_NAME" \
  --arg dbUser "$DB_USER" \
  --arg dbPassword "$DB_PASSWORD" \
  --arg rpcHost "$BTC_RPC_HOST" \
  --argjson rpcPort "$BTC_RPC_PORT" \
  --arg rpcUser "$BTC_RPC_USER" \
  --arg rpcPassword "$BTC_RPC_PASSWORD" \
  --arg poolAddress "$BTC_POOL_ADDRESS" \
  --arg devFeeAddress "$DEV_FEE_ADDRESS" \
  --argjson devFeePercent "$DEV_FEE_PERCENT" \
  --argjson stratumPort "$STRATUM_PORT" \
  --argjson apiPort "$API_PORT" \
  '{
    clusterName: "Seymour MiningCore",
    coinTemplates: ["coins.json"],

    logging: {
      level: "info",
      enableConsoleLog: true,
      enableConsoleColors: false,
      logFile: "miningcore.log",
      logBaseDirectory: "/var/log/seymour-miningcore",
      perPoolLogFile: false
    },

    banning: {
      manager: "Integrated",
      banOnJunkReceive: true,
      banOnInvalidShares: false
    },

    notifications: {
      enabled: false
    },

    persistence: {
      postgres: {
        host: $dbHost,
        port: $dbPort,
        user: $dbUser,
        password: $dbPassword,
        database: $dbName
      }
    },

    paymentProcessing: {
      enabled: true,
      interval: 600,
      shareRecoveryFile: "/var/lib/seymour-miningcore/recovered-shares.txt"
    },

    api: {
      enabled: true,
      listenAddress: "0.0.0.0",
      port: $apiPort
    },

    pools: [
      {
        id: "btc-solo",
        enabled: true,
        coin: "bitcoin",
        address: $poolAddress,

        rewardRecipients: [
          {
            address: $devFeeAddress,
            percentage: $devFeePercent
          }
        ],

        blockRefreshInterval: 500,
        jobRebroadcastTimeout: 10,
        clientConnectionTimeout: 600,

        banning: {
          enabled: true,
          time: 600,
          invalidPercent: 50,
          checkThreshold: 50
        },

        ports: {
          ($stratumPort | tostring): {
            listenAddress: "0.0.0.0",
            name: "BTC Solo ASIC Mining",
            difficulty: 1024,
            varDiff: {
              minDiff: 512,
              targetTime: 15,
              retargetTime: 90,
              variancePercent: 30
            }
          }
        },

        daemons: [
          {
            host: $rpcHost,
            port: $rpcPort,
            user: $rpcUser,
            password: $rpcPassword
          }
        ],

        paymentProcessing: {
          enabled: true,
          minimumPayment: 0.0001,
          payoutScheme: "SOLO"
        }
      }
    ]
  }' > "$CONFIG_FILE"

chown root:"$SERVICE_USER" "$CONFIG_FILE"
chmod 0640 "$CONFIG_FILE"

echo "[*] Verifying official Seymour developer-fee policy"

DEV_FEE_VALIDATION="$(
  "${ROOT_DIR}/bin/smc" developer-fee validate-runtime     BTC     "$CONFIG_FILE"     btc-solo
)" || {
  echo "Generated pool configuration failed developer-fee validation."
  printf '%s
' "$DEV_FEE_VALIDATION" | jq .
  exit 1
}

printf '%s
' "$DEV_FEE_VALIDATION" | jq .

echo "[✓] Official Seymour developer fee verified"

chown -R root:root "$RUNTIME_DIR"
chmod -R a+rX "$RUNTIME_DIR"

echo "[*] Validating MiningCore configuration"

cd "$RUNTIME_DIR"

if ! runuser -u "$SERVICE_USER" -- \
  "$DOTNET" "$RUNTIME_DIR/Miningcore.dll" \
  --config "$CONFIG_FILE" \
  --dumpconfig \
  >/tmp/seymour-miningcore-dumpconfig.log 2>&1; then

  echo "MiningCore rejected the generated configuration."
  tail -100 /tmp/seymour-miningcore-dumpconfig.log
  exit 1
fi

echo "[✓] MiningCore configuration validated"

echo "[*] Creating systemd service"

cat > "$SERVICE_FILE" <<UNIT
[Unit]
Description=Seymour MiningCore Mining Service
After=network-online.target postgresql.service
Wants=network-online.target
Requires=postgresql.service

[Service]
Type=simple
User=${SERVICE_USER}
Group=${SERVICE_USER}
WorkingDirectory=${RUNTIME_DIR}

ExecStart=${DOTNET} ${RUNTIME_DIR}/Miningcore.dll --config ${CONFIG_FILE}

Restart=on-failure
RestartSec=5
TimeoutStopSec=60

NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true

ReadWritePaths=/var/lib/seymour-miningcore
ReadWritePaths=/var/log/seymour-miningcore

Environment=DOTNET_CLI_TELEMETRY_OPTOUT=1
Environment=DOTNET_NOLOGO=1

[Install]
WantedBy=multi-user.target
UNIT

chmod 0644 "$SERVICE_FILE"

systemctl daemon-reload
systemctl enable seymour-miningcore
systemctl restart seymour-miningcore

sleep 5

if ! systemctl is-active --quiet seymour-miningcore; then
  echo "Seymour MiningCore failed to start."
  journalctl -u seymour-miningcore -n 100 --no-pager
  exit 1
fi

echo
echo "Seymour MiningCore is running."
echo
echo "Stratum: stratum+tcp://$(hostname -I | awk '{print $1}'):${STRATUM_PORT}"
echo "API:     http://$(hostname -I | awk '{print $1}'):${API_PORT}"
echo
