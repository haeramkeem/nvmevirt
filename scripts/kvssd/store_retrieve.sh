#!/bin/bash

set -e

DEV=/dev/nvme1n1

UUID=$(uuidgen)
KEY0=$(echo -n "${UUID}" | sed -E 's|(....)(....)(.*)|\1|g')
KEY1=$(echo -n "${UUID}" | sed -E 's|(....)(....)(.*)|\2|g')

KEY="${KEY0}${KEY1}"
KEY_LEN=$(echo -n "${KEY}" | wc -c)

VAL="${UUID}"
VAL_LEN=$(echo -n "${VAL}" | wc -c)

echo -n "${VAL}" | \
sudo nvme io-passthru ${DEV} \
--opcode="0x81" \
--cdw10="${VAL_LEN}" \
--cdw11="${KEY_LEN}" \
--cdw12="0x$(echo -n "${KEY0}" | rev | xxd -p)" \
--cdw13="0x$(echo -n "${KEY1}" | rev | xxd -p)" \
--namespace-id=1 \
--data-len="${VAL_LEN}" \
-svw

sudo nvme io-passthru ${DEV} \
--opcode="0x90" \
--cdw10="${VAL_LEN}" \
--cdw11="${KEY_LEN}" \
--cdw12="0x$(echo -n "${KEY0}" | rev | xxd -p)" \
--cdw13="0x$(echo -n "${KEY1}" | rev | xxd -p)" \
--namespace-id=1 \
--data-len="${VAL_LEN}" \
-svr
