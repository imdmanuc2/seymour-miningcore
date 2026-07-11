#!/usr/bin/env bash
set -euo pipefail

developer_fee_policy_file() {
  echo "${ROOT_DIR}/config/product/developer-fees.json"
}

smc_developer_fee_status() {
  local file
  file="$(developer_fee_policy_file)"

  if [[ ! -f "$file" ]]; then
    jq -n '{
      valid: false,
      status: "missing",
      message: "Developer-fee policy is missing."
    }'
    return 1
  fi

  jq '{
    schemaVersion,
    policyId,
    required,
    defaultPercent,
    enabledCoins: [
      .coins
      | to_entries[]
      | select(.value.enabled == true)
      | {
          coin: .key,
          address: .value.address,
          addressType: .value.addressType,
          minimumPercent: .value.minimumPercent
        }
    ]
  }' "$file"
}

smc_developer_fee_get_address() {
  local coin="${1:-}"
  local file
  file="$(developer_fee_policy_file)"

  if [[ -z "$coin" ]]; then
    echo "Coin is required." >&2
    echo "Usage: smc developer-fee address <COIN>" >&2
    return 1
  fi

  coin="$(printf '%s' "$coin" | tr '[:lower:]' '[:upper:]')"

  if [[ ! -f "$file" ]]; then
    echo "Developer-fee policy is missing." >&2
    return 1
  fi

  local enabled address

  enabled="$(jq -r --arg coin "$coin" '.coins[$coin].enabled // false' "$file")"
  address="$(jq -r --arg coin "$coin" '.coins[$coin].address // empty' "$file")"

  if [[ "$enabled" != "true" ]]; then
    echo "Developer fee is not enabled for ${coin}." >&2
    return 1
  fi

  if [[ -z "$address" ]]; then
    echo "Developer-fee address is missing for ${coin}." >&2
    return 1
  fi

  printf '%s\n' "$address"
}

smc_developer_fee_get_percent() {
  local coin="${1:-}"
  local file
  file="$(developer_fee_policy_file)"

  coin="$(printf '%s' "$coin" | tr '[:lower:]' '[:upper:]')"

  jq -r \
    --arg coin "$coin" \
    '.coins[$coin].minimumPercent // .defaultPercent // 0.75' \
    "$file"
}

smc_developer_fee_validate() {
  local file
  file="$(developer_fee_policy_file)"

  if [[ ! -f "$file" ]]; then
    jq -n '{
      valid: false,
      status: "missing",
      errors: ["Developer-fee policy file is missing."]
    }'
    return 1
  fi

  jq '
    def enabled_coin_errors:
      [
        .coins
        | to_entries[]
        | select(.value.enabled == true)
        | if (.value.address == null or .value.address == "") then
            "\(.key): enabled coin has no developer-fee address"
          elif ((.value.minimumPercent // 0) < 0.75) then
            "\(.key): developer-fee percentage is below 0.75%"
          else
            empty
          end
      ];

    enabled_coin_errors as $errors
    | {
        valid: ($errors | length == 0),
        status: (
          if ($errors | length) == 0
          then "valid"
          else "invalid"
          end
        ),
        policyId: .policyId,
        required: .required,
        defaultPercent: .defaultPercent,
        errors: $errors
      }
  ' "$file"
}

smc_developer_fee_command() {
  local action="${1:-status}"

  case "$action" in
    status|show)
      smc_developer_fee_status
      ;;

    validate)
      smc_developer_fee_validate
      ;;

    address)
      smc_developer_fee_get_address "${2:-}"
      ;;

    percent)
      smc_developer_fee_get_percent "${2:-}"
      ;;

    *)
      echo "Unknown developer-fee command: ${action}" >&2
      echo "Usage: smc developer-fee <status|validate|address|percent> [COIN]" >&2
      return 1
      ;;
  esac
}
