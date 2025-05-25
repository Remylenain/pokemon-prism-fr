#!/bin/sh
# Usage: asm2bin.sh landmarks.asm landmarks.bin

TEMP_O=$(mktemp landmarks.o.XXX)

${RGBASM} -o "$TEMP_O" "$1"
${RGBLINK} -x -o "$2" "$TEMP_O"

rm -f "$TEMP_O"
