#!/usr/bin/env bash

##########################################################################################
# Author: Amin Abbaspour
# Date: 2024-04-12
# License: MIT (https://github.com/abbaspour/okta-bash/blob/master/LICENSE)
##########################################################################################

set -euo pipefail

readonly DIR=$(dirname "${BASH_SOURCE[0]}")

readonly TF_VARS='../tf/terraform.auto.tfvars'

readonly account_id=$(awk -F= '/^cloudflare_account_id/{print $2}' ${TF_VARS}  | tr -d ' "')

declare token=''

[[ -f "${DIR}/.env" ]] && . "${DIR}/.env"

curl -X POST "https://api.cloudflare.com/client/v4/accounts/${account_id}/analytics_engine/sql" \
  -H "Authorization: Bearer ${token}" \
  -d "SHOW TABLES"