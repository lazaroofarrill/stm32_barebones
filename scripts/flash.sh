#!/bin/sh

dfu-util -a 0 -D ./zig-out/firmware.bin -s 0x08000000
