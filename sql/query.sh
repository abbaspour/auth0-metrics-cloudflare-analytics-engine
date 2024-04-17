#!/usr/bin/env bash

##########################################################################################
# Author: Amin Abbaspour
# Date: 2024-04-12
# License: MIT (https://github.com/abbaspour/auth0-metrics-cloudflare-analytics-engine/blob/master/LICENSE)
##########################################################################################

set -euo pipefail

readonly DIR=$(dirname "${BASH_SOURCE[0]}")

readonly TF_VARS='../tf/terraform.auto.tfvars'

readonly account_id=$(awk -F= '/^cloudflare_account_id/{print $2}' ${TF_VARS}  | tr -d ' "')

declare token=''

[[ -f "${DIR}/.env" ]] && . "${DIR}/.env"

function usage() {
    cat <<END >&2
USAGE: $0 [-e file] [-f sql] [-v|-h] 'SQL query'
        -e env        # env file
        -f file       # read SQL from file
        -h|?          # usage
        -v            # verbose

eg,
     $0 'SHOW TABLES'
END
    exit $1
}

declare query=''

while getopts "e:f:hv?" opt; do
    case ${opt} in
    e) source "${OPTARG}" ;;
    f) query=$(cat "${OPTARG}") ;;
    v) set -x ;;
    h | ?) usage 0 ;;
    *) usage 1 ;;
    esac
done

if [[ -z "${query}" ]]; then
  shift $((OPTIND-1))
  query="${@}"
fi

[[ -z "${query}" ]] && { echo >&2 "ERROR: no query"; exit 2;}

curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/${account_id}/analytics_engine/sql" \
  -H "Authorization: Bearer ${token}" \
  -d "${query}"