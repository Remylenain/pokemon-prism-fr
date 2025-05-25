___compressing_text = 0
___ct_bits = 0
___ct_length = 0
___ct_in_bytes = 0
___ct_out_bytes = 0

text   EQUS "\n___compressing_text = 0\n db" ; Start writing text.
scroll EQUS "dtxt \"<SCROLL>\"," ; Autoscroll to the next line (like cont, but no button press)
next   EQUS "dtxt \"<NEXT>\","   ; Move a line down.
line   EQUS "dtxt \"<LINE>\","   ; Start writing at the bottom line.
para   EQUS "dtxt \"<PARA>\","   ; Start a new paragraph.
cont   EQUS "dtxt \"<CONT>\","   ; Scroll to the next line.
sdone  EQUS "dtxt \"<SDONE>\""   ; Like done, but with a cursorless prompt
done   EQUS "dtxt \"<DONE>\""    ; End a text box.
prompt EQUS "dtxt \"<PROMPT>\""  ; Prompt the player to end a text box (initiating some other event).

nl     EQUS "dtxt \"<LNBRK>\","  ; Write text on the next line. Used outside of scripting.

MACRO dtxt
	if !___compressing_text
		db \#
	else
		rept _NARG
			DEF ___str EQUS \1

			rept $7fff_ffff
				; effectively `while STRLEN("{___str}")`
				if !STRLEN("{___str}")
					break
				endc
				DEF ___sub EQUS CHARSUB("{___str}", 1)
				REDEF ___str EQUS STRSUB("{___str}", STRLEN("{___sub}") + 1)
				___dchr "{___sub}"
				PURGE ___sub
			endr
			PURGE ___str
			shift
		endr
		if !___compressing_text && ___ct_length > 0
			db ___ct_bits << (8 - ___ct_length)
		endc
	endc
ENDM

MACRO ___dchr
	DEF ___chr = \1
	if ___chr < LEAST_CONTROL_CHAR
		fail "encountered {#02X:___chr} byte while processing"
	endc
	DEF ___ct_bits = (___ct_bits << ___huffman_length_{02X:___chr}) | ___huffman_data_{02X:___chr}
	DEF ___ct_length = ___ct_length + ___huffman_length_{02X:___chr}
	rept 3
		if ___ct_length >= 8
			db ___ct_bits >> (___ct_length - 8)
			DEF ___ct_length = ___ct_length - 8
			DEF ___ct_bits = ___ct_bits & ((1 << ___ct_length) - 1)
			DEF ___ct_out_bytes = ___ct_out_bytes + 1
		endc
	endr
	DEF ___ct_in_bytes = ___ct_in_bytes + 1
	if ___chr == "@" || ___chr == "<SDONE>" || ___chr == "<DONE>" || ___chr == "<PROMPT>"
		DEF ___compressing_text = 0
		assert ___ct_out_bytes <= ___ct_in_bytes, "ctxt should be text"
	endc
ENDM

	enum_start 0
	enum TX_RAM
MACRO text_from_ram
	db TX_RAM
	dw \1
ENDM

	enum START_ASM
MACRO start_asm
	db START_ASM
ENDM

	enum TX_NUM
MACRO deciram
	db TX_NUM
	dw \1 ; address
	dn ((\2) & $f), ((\3) & $f) ; bytes, digits
ENDM

	enum TX_COMPRESSED
MACRO ctxt
	db TX_COMPRESSED
___compressing_text = 1
___ct_bits = 0
___ct_length = 0
___ct_in_bytes = 0
___ct_out_bytes = 1 ; count the TX_COMPRESSED
	dtxt \#
ENDM

MACRO stxt
; `loadsignpost` expects compressed text, but some sign text
; (e.g. on Route 55) may warn that "ctxt can be text".
	assert "@" == $50 && ___huffman_data_50 == %011100110000
	db TX_COMPRESSED, %01110011, %0000_0000
	text \#
ENDM

MACRO text_far
	db HIGH(\1) - ($40 - (LEAST_CONTROL_CHAR - $40))
	db LOW(\1)
	db BANK(\1)
ENDM

MACRO text_jump
	db HIGH(\1) - ($40 - (LEAST_CONTROL_CHAR - $40))
	db LOW(\1)
	db BANK(\1) | $80
ENDM
