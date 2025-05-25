; Format:
; varblock1 X, Y, flag, false, true
; varblock2 X, Y, flag, flag, FF, FT, TF, TT
; varblock3 X, Y, flag, flag, flag, FFF, FFT, FTF, FTT, TFF, TFT, TTF, TTT
; varblock_multiple X, Y, (flag, value,)* else-value
; a value of $ff means do nothing
; flags are encoded little-endian; flags for varblock may have their upper bit set if inverted
; the else-value in varblock is followed by a -1 byte (the macro adds it automatically if the number of arguments is odd)

MACRO varblock1
	_varblock_coords 1, \1, \2
	if _NARG > 2
		dw \3
		rept _NARG - 3
			db \4
			shift
		endr
	endc
ENDM

MACRO varblock2
	_varblock_coords 2, \1, \2
	if _NARG < 4
		rept _NARG - 2
			dw \3
			shift
		endr
	else
		dw \3, \4
		rept _NARG - 4
			db \5
			shift
		endr
	endc
ENDM

MACRO varblock3
	_varblock_coords 3, \1, \2
	if _NARG < 5
		rept _NARG - 2
			dw \3
			shift
		endr
	else
		dw \3, \4, \5
		rept _NARG - 5
			db \6
			shift
		endr
	endc
ENDM

MACRO varblock_multiple
	_varblock_coords 0, \1, \2
	rept (_NARG >> 1) - 1
		shift 2
		dw \1
		db \2
	endr
	if (_NARG & 1)
		db \3
		db -1
	endc
ENDM

MACRO _varblock_coords
	; This macro is only meant to be used with the macros above. Do not use it on its own unless you know what you're doing.
	db ((\2) & $fe) | ((\1) & 1)
	db ((\3) & $fe) | (((\1) & 2) >> 1)
ENDM
