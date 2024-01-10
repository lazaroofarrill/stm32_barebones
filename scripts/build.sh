#!/bin/sh
#
cd $(dirname $0)

mkdir -p zig-out
cd zig-out
rm firmware*
zig build-exe -target thumb-freestanding -mcpu cortex_m4 --name firmware.elf --script ../memory.ld ../src/main.zig

arm-none-eabi-objcopy -O binary firmware.elf firmware.bin
