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


smc_developer_fee_validate_runtime() {
  local coin="${1:-}"
  local config_file="${2:-}"
  local pool_id="${3:-}"
  local policy_file official_address official_percent result

  policy_file="$(developer_fee_policy_file)"

  if [[ -z "$coin" || -z "$config_file" || -z "$pool_id" ]]; then
    echo "Usage: smc developer-fee validate-runtime <COIN> <CONFIG_FILE> <POOL_ID>" >&2
    return 1
  fi

  coin="$(printf '%s' "$coin" | tr '[:lower:]' '[:upper:]')"

  if [[ ! -f "$policy_file" ]]; then
    jq -n '{
      valid: false,
      status: "policy-missing",
      errors: ["Developer-fee policy file is missing."]
    }'
    return 1
  fi

  if [[ ! -r "$config_file" ]]; then
    jq -n \
      --arg configFile "$config_file" \
      '{
        valid: false,
        status: "config-unreadable",
        configFile: $configFile,
        errors: ["Runtime configuration is missing or unreadable."]
      }'
    return 1
  fi

  if ! jq empty "$config_file" >/dev/null 2>&1; then
    jq -n \
      --arg configFile "$config_file" \
      '{
        valid: false,
        status: "config-invalid-json",
        configFile: $configFile,
        errors: ["Runtime configuration is not valid JSON."]
      }'
    return 1
  fi

  official_address="$(smc_developer_fee_get_address "$coin")" || return 1
  official_percent="$(smc_developer_fee_get_percent "$coin")" || return 1

  result="$(
    jq \
      --arg coin "$coin" \
      --arg poolId "$pool_id" \
      --arg officialAddress "$official_address" \
      --argjson officialPercent "$official_percent" \
      '
      (
        [.pools[]? | select(.id == $poolId)] | first
      ) as $pool

      | (
          if $pool == null then
            ["Pool \($poolId) was not found."]
          else
            []
            + (
                if ($pool.address // "") == "" then
                  ["Customer payout address is missing."]
                else
                  []
                end
              )
            + (
                if ($pool.address // "") == $officialAddress then
                  ["Customer payout address must not equal the Seymour developer-fee address."]
                else
                  []
                end
              )
            + (
                if (($pool.rewardRecipients // []) | length) == 0 then
                  ["Developer-fee recipient is missing."]
                else
                  []
                end
              )
            + (
                if any(
                  ($pool.rewardRecipients // [])[];
                  (.address == $officialAddress and
                   ((.percentage | tonumber) == $officialPercent))
                ) then
                  []
                else
                  ["Official Seymour developer-fee recipient or percentage does not match policy."]
                end
              )
          end
        ) as $errors

      | {
          valid: ($errors | length == 0),
          status: (
            if ($errors | length) == 0
            then "valid"
            else "invalid"
            end
          ),
          coin: $coin,
          poolId: $poolId,
          configFile: input_filename,
          expected: {
            address: $officialAddress,
            percentage: $officialPercent
          },
          actual: (
            if $pool == null then
              null
            else
              {
                customerAddress: ($pool.address // null),
                rewardRecipients: ($pool.rewardRecipients // [])
              }
            end
          ),
          errors: $errors
        }
      ' "$config_file"
  )"

  printf '%s\n' "$result"

  if [[ "$(jq -r '.valid' <<<"$result")" != "true" ]]; then
    return 1
  fi
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

    validate-runtime)
      smc_developer_fee_validate_runtime "${2:-}" "${3:-}" "${4:-}"
      ;;

    address)
      smc_developer_fee_get_address "${2:-}"
      ;;

    percent)
      smc_developer_fee_get_percent "${2:-}"
      ;;

    *)
      echo "Unknown developer-fee command: ${action}" >&2
      echo "Usage: smc developer-fee <status|validate|validate-runtime|address|percent> [arguments]" >&2
      return 1
      ;;
  esac
}
