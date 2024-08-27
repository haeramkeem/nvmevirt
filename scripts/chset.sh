#!/bin/sh

source $(cd $(dirname $0) && pwd)/config.env

MEMMAP_START=${NVMEV_MEMMAP_START?"error: Environment variable 'NVMEV_MEMMAP_START' not set."}
MEMMAP_SIZE=${NVMEV_MEMMAP_SIZE?"error: Environment variable 'NVMEV_MEMMAP_SIZE' not set."}

sudo sed -Ei \
    's|^GRUB_CMDLINE_LINUX="(.*)"$|GRUB_CMDLINE_LINUX="memmap='$MEMMAP_SIZE'G\\\\\\$'$MEMMAP_START'G"|g' \
    /etc/default/grub

sudo update-grub

cat << EOF | sudo tee /etc/modules-load.d/nvmev.conf
nvmev
EOF

cat << EOF | sudo tee /etc/modprobe.d/nvmev.conf
options nvmev memmap_start=${MEMMAP_START}G memmap_size=${MEMMAP_SIZE}G cpus=0,1
EOF
