#!/bin/sh
# Usage: coll2bin.sh collision.asm collision.bin

TEMP_ASM=$(mktemp collision.asm.XXX)

printf '\tinclude "constants/collision_constants.asm"\n\n' > "$TEMP_ASM"
sed -E -e 's/tilecoll/db/g' -e 's/([A-Z0-9_]+)/COLL_\1/g' < "$1" >> "$TEMP_ASM"

${BSPCOMP} "$TEMP_ASM" "$2"

rm -f "$TEMP_ASM"
