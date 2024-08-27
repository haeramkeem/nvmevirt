#!/bin/bash

source $(cd $(dirname $0) && pwd)/config.env

DIRNAME=${NVMEV_DIRNAME?"error: Environment variable 'NVMEV_DIRNAME' not set."}
MEMMAP_START=${NVMEV_MEMMAP_START?"error: Environment variable 'NVMEV_MEMMAP_START' not set."}
MEMMAP_SIZE=${NVMEV_MEMMAP_SIZE?"error: Environment variable 'NVMEV_MEMMAP_SIZE' not set."}

cd $DIRNAME
make \
    && sudo cp ${DIRNAME}/nvmev.ko /lib/modules/$(uname -r)/misc/ \
    && sudo depmod -a \
    && sudo modprobe -r nvmev \
    && sleep 1 \
    && sudo modprobe nvmev memmap_start=${MEMMAP_START}G memmap_size=${MEMMAP_SIZE}G cpus=2,3
