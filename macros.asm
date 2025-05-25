INCLUDE "macros/enum.asm"
INCLUDE "macros/basestats.asm"

INCLUDE "macros/event.asm"
INCLUDE "macros/sound.asm"
INCLUDE "macros/text.asm"
INCLUDE "macros/charmap.asm"
INCLUDE "macros/move_effect.asm"
INCLUDE "macros/move_anim.asm"
INCLUDE "macros/movement.asm"
INCLUDE "macros/map.asm"
INCLUDE "macros/predef.asm"
INCLUDE "macros/rst.asm"
INCLUDE "macros/trainer.asm"
INCLUDE "macros/trade_anim.asm"
INCLUDE "macros/pals.asm"
INCLUDE "macros/flag.asm"
INCLUDE "macros/lz.asm"
INCLUDE "macros/varblocks.asm"
INCLUDE "macros/debug_menu.asm"

MACRO RGB
	rept _NARG / 3
		dw ((\3) << 10) + ((\2) << 5) + (\1)
		shift 3
	endr
ENDM

percent EQUS "* $ff / 100"

MACRO dwb
	dw \1
	db \2
ENDM

MACRO dbw
	db \1
	dw \2
ENDM

MACRO dbbw
	db \1, \2
	dw \3
ENDM

MACRO dbww
	db \1
	dw \2, \3
ENDM

MACRO dbwww
	db \1
	dw \2, \3, \4
ENDM

MACRO dbnn
	db \1
	db ((\2) & $f) << 4 + ((\3) & $f)
ENDM

MACRO dn
	rept _NARG / 2
		db (\1) << 4 + (\2)
		shift 2
	endr
ENDM

MACRO dt ; three-byte (big-endian)
	rept _NARG
		db LOW((\1) >> 16), HIGH(\1), LOW(\1)
		shift
	endr
ENDM

MACRO dd ; four-byte (big-endian)
	rept _NARG
		db HIGH((\1) >> 16), LOW((\1) >> 16), HIGH(\1), LOW(\1)
		shift
	endr
ENDM

MACRO bigdw ; big-endian word
	rept _NARG
		db HIGH(\1), LOW(\1)
		shift
	endr
ENDM

MACRO dba ; dbw bank, address
	rept _NARG
		dbw BANK(\1), \1
		shift
	endr
ENDM

MACRO dab ; dwb address, bank
	rept _NARG
		dwb \1, BANK(\1)
		shift
	endr
ENDM

MACRO lb ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 + ((\3) & $ff)
ENDM

MACRO ln ; r, hi, lo
	ld \1, ((\2) & $f) << 4 + ((\3) & $f)
ENDM

MACRO exchange ; 16-bit reg, exchanges its 8-bit components
	push \1
	push \1
	inc sp
	pop \1
	inc sp
ENDM

bccoord equs "coord bc,"
decoord equs "coord de,"
hlcoord equs "coord hl,"

MACRO coord
; register, x, y[, origin]
	if _NARG < 4
	ld \1, wTileMap + SCREEN_WIDTH * (\3) + (\2)
	else
	ld \1, \4 + SCREEN_WIDTH * (\3) + (\2)
	endc
ENDM

MACRO dwcoord
	rept _NARG / 2
		dw wTileMap + SCREEN_WIDTH * (\2) + (\1)
		shift 2
	endr
ENDM

MACRO ldcoord_a
	if _NARG < 3
	ld [wTileMap + SCREEN_WIDTH * (\2) + (\1)], a
	else
	ld [\3 + SCREEN_WIDTH * (\2) + (\1)], a
	endc
ENDM

MACRO lda_coord
	if _NARG < 3
	ld a, [wTileMap + SCREEN_WIDTH * (\2) + (\1)]
	else
	ld a, [\3 + SCREEN_WIDTH * (\2) + (\1)]
	endc
ENDM

MACRO storecallloc
	call GetCallLocation
	dw \1
ENDM

; pic animations
MACRO frame
	db \1
x = \2
IF _NARG > 2
rept _NARG - 2
x = x | (1 << (\3 + 1))
	shift
endr
endc
	db x
ENDM

MACRO setrepeat
	db $fe
	db \1
ENDM

MACRO dorepeat
	db $fd
	db \1
ENDM

MACRO endanim
	db $ff
ENDM

MACRO delanim
	db $fc
ENDM

MACRO dorestart
	db $fe
ENDM

MACRO sine_wave
; \1: amplitude

x = 0
	rept $20
	; Round up.
	dw (sin(x) + (sin(x) & $ff)) >> 8
x = x + (\1) * $4
	endr
ENDM

MACRO bcd
	rept _NARG
		dn ((\1) % 100) / 10, (\1) % 10
		shift
	endr
ENDM

tiles EQUS "* TILESIZE"
tile EQUS "+ TILESIZE *"

MACRO partymon
	db \1
	db \2
	db \3, \4, \5, \6
	dw \7
	dt \8
	bigdw \9, \<10>, \<11>, \<12>, \<13>
	db \<14>, \<15>
	db \<16>, \<17>, \<18>, \<19>
	db \<20>
	db \<21>, \<22>, \<23>
	db \<24>
	db \<25>, \<26>
	bigdw \<27>, \<28>, \<29>, \<30>, \<31>, \<32>, \<33>
	db \<34>
ENDM

palettes EQUS "* 8"

MACRO ldpixel
if _NARG >= 5
	lb \1, \2 * 8 + \4, \3 * 8 + \5
else
	lb \1, \2 * 8, \3 * 8
endc
ENDM

depixel EQUS "ldpixel de,"
bcpixel EQUS "ldpixel bc,"

MACRO dbpixel
if _NARG >= 4
	db \1 * 8 + \3, \2 * 8 + \4
else
	db \1 * 8, \2 * 8
endc
ENDM

MACRO bgcoord
IF _NARG >= 4
	ld \1, \3 * $20 + \2 + \4
ELSE
	ld \1, \3 * $20 + \2 + vBGMap
ENDC
ENDM

hlbgcoord EQUS "bgcoord hl,"
debgcoord EQUS "bgcoord de,"
bcbgcoord EQUS "bgcoord bc,"
bgrows EQUS "* $20"

palred EQUS "$0400 *"
palgreen EQUS "$0020 *"
palblue EQUS "$0001 *"

MACRO dsprite
; conditional segment is there because not every instance of
; this macro is directly OAM
if _NARG >= 7 ; y tile, y pxl, x tile, x pxl, vtile offset, flags, palette
	db LOW(\1 * 8) + \2, LOW(\3 * 8) + \4, \5, (\6 << 3) + (\7 & 7)
else
	db LOW(\1 * 8) + \2, LOW(\3 * 8) + \4, \5, \6
endc
ENDM

MACRO add_name
.name\@
	db .name\@end - .name\@
	db \1
.name\@end
ENDM

jr_abs EQUS "db $18, -1 - @ + "

MACRO type_matchup
x = 0
y = 0
rept _NARG
x = x + (\1 << y)
y = (y + 2) & 7
if y == 0
	db x
x = 0
endc
	shift
endr
if y != 0
	db x
endc
ENDM

MACRO list_item
.__item\1
if (_NARG > 1)
	db .__item\2 - .__item\1
endc
ENDM

current_list_item = 0

MACRO next_list_item
next_list_item_index = current_list_item + 1
	list_item {d:current_list_item}, {d:next_list_item_index}
current_list_item = next_list_item_index
ENDM

MACRO end_list_items
	list_item {d:current_list_item}
current_list_item = 0
ENDM

MACRO debug_mode_flag
	; This macro sets the carry flag depending on whether debug mode is on or off.
	; It takes up one byte either way, preventing address shifts between modes.
	if DEF(DEBUG_MODE)
		scf
	else
		and a
	endc
ENDM

MACRO define
; This macro imitates bspcomp's define keyword
if !DEF(\1)
\1 EQU \2
endc
ENDM
