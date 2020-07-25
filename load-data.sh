#!/usr/bin/env bash
set -e

REMOTE_FOLDER=${1:-master}
DATA_FOLDER=./data
DATA_FILE="${DATA_FOLDER}"/"${REMOTE_FOLDER}".tsv

aws s3 sync s3://tf-front-logs-production/"${REMOTE_FOLDER}"/ ./"${REMOTE_FOLDER}"

rm -rf "${DATA_FOLDER}" || true
mkdir -p "${DATA_FOLDER}" || true
cp -vR ./"${REMOTE_FOLDER}" "${DATA_FOLDER}"
gzip -vd "${DATA_FOLDER}"/"${REMOTE_FOLDER}"/*.gz

COLUMNS=(date time x-edge-location sc-bytes c-ip cs-method Host cs-uri-stem sc-status Referer User-Agent cs-uri-query Cookie x-edge-result-type x-edge-request-id x-host-header cs-protocol cs-bytes time-taken x-forwarded-for ssl-protocol ssl-cipher x-edge-response-result-type cs-protocol-version fle-status fle-encrypted-fields c-port time-to-first-byte x-edge-detailed-result-type sc-content-type sc-content-len sc-range-start)
LAST_COLUMN=sc-range-end
(printf '%s\t' "${COLUMNS[@]}"; echo "${LAST_COLUMN}";) > "${DATA_FILE}"
cat "${DATA_FOLDER}"/"${REMOTE_FOLDER}"/* | grep -v '^#' >> "${DATA_FILE}"

rm -rf "${DATA_FOLDER:?}"/"${REMOTE_FOLDER}"