#!/usr/bin/env bash

##########################################################################################
# Author: Amin Abbaspour
# Date: 2024-04-12
# License: MIT (https://github.com/abbaspour/auth0-metrics-cloudflare-analytics-engine/blob/master/LICENSE)
##########################################################################################

set -euo pipefail

readonly DIR=$(dirname "${BASH_SOURCE[0]}")
declare token=''

[[ -f "${DIR}/.env" ]] && . "${DIR}/.env"

curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" -s \
     -H "Authorization: Bearer ${token}" \
     -H "Content-Type:application/json" | jq .