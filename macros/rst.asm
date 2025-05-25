MACRO callba ; bank, address
	rst FarCall
	dbw BANK(\1), \1
	ENDM

MACRO jpba
	rst FarCall
	dbw BANK(\1) | $80, \1
	ENDM

MACRO jumptable
	rst JumpTable
	if _NARG > 0
	dw \1 | $8000
	endc
	ENDM

MACRO bankpushcall
	rst FarCall
	db BANK(\1)
	dw \2
	ENDM

MACRO bankpushjp
	rst FarCall
	db BANK(\1) | $80
	dw \2
	ENDM

MACRO anonbankpush
	rst FarCall
	db BANK(\1) | $80
	dw .anonPtr\@
.anonPtr\@
	ENDM

MACRO rbk ;ROM bank switch
	_bankswitch_macro \1, $00, $e0, $7f
ENDM

MACRO wbk ;WRAM bank switch
	_bankswitch_macro \1, $90, $f0, $07, rSVBK
ENDM

MACRO vbk ;VRAM bank switch
	_bankswitch_macro \1, $98, $f8, $01, rVBK
ENDM

MACRO sbk ;SRAM bank switch
	_bankswitch_macro \1, $80, $e8, $0f
ENDM

MACRO scls ;SRAM close
	rst GenericBankswitch
	db $9a
ENDM

MACRO _bankswitch_macro
	; THIS IS NOT THE MACRO YOU WANT TO USE. It starts with an underscore for a reason. Use the macros defined above.
	; user-supplied argument, offset for immediate banks, offset for register banks, bitmask for immediate banks, register if register is A (optional)
	IF !STRCMP(STRLWR("\1"), "b")
		rst GenericBankswitch
		db \3
	ELIF !STRCMP(STRLWR("\1"), "c")
		rst GenericBankswitch
		db \3 + 1
	ELIF !STRCMP(STRLWR("\1"), "d")
		rst GenericBankswitch
		db \3 + 2
	ELIF !STRCMP(STRLWR("\1"), "e")
		rst GenericBankswitch
		db \3 + 3
	ELIF !STRCMP(STRLWR("\1"), "h")
		rst GenericBankswitch
		db \3 + 4
	ELIF !STRCMP(STRLWR("\1"), "l")
		rst GenericBankswitch
		db \3 + 5
	ELIF !STRCMP(STRLWR("\1"), "a")
		IF _NARG > 4
			ldh [\5], a
		ELSE
			rst GenericBankswitch
			db \3 + 7
		ENDC
	ELIF !STRCMP(STRLWR("\1"), "[hl]")
		rst GenericBankswitch
		db \3 + 6
	ELSE
		rst GenericBankswitch
		db \2 + ((\1) & \4)
	ENDC
ENDM
