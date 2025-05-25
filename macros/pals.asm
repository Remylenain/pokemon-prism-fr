MACRO tilepal
; vram bank, pals
x = \1 << 3
rept _NARG - 1
	db x | PAL_BG_\2
	shift
endr
ENDM

