#!/bin/sh

MEMMAP_START=$1
MEMMAP_SIZE=$2

sudo modprobe nvmev memmap_start=${MEMMAP_START}G memmap_size=${MEMMAP_SIZE}G cpus=0,1
