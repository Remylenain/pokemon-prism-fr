; define engine flags
; location, bit
MACRO def_engine_flag
	const \1
\1_ADDRESS EQUS "\2"
\1_BIT EQU \3
ENDM

; define engine flags
; location, bit
MACRO engine_flag
	dwb \1_ADDRESS, 1 << \1_BIT
ENDM

;\1 = event index
MACRO CheckEngine
	ld a, [\1_ADDRESS]
	bit \1_BIT, a
ENDM

;\1 = event index
MACRO CheckEngineForceReuseA
	bit \1_BIT, a
ENDM

;\1 = event index
MACRO CheckEngineHL
	ld hl, \1_ADDRESS
	bit \1_BIT, [hl]
ENDM

;\1 = event index
MACRO CheckEngineForceReuseHL
	bit \1_BIT, [hl]
ENDM

;\1 = event index
MACRO CheckAndSetEngine
	ld hl, \1_ADDRESS
	bit \1_BIT, [hl]
	set \1_BIT, [hl]
ENDM

;\1 = event index
MACRO CheckAndResetEngine
	ld hl, \1_ADDRESS
	bit \1_BIT, [hl]
	res \1_BIT, [hl]
ENDM

;\1 = event index
MACRO CheckAndSetEngineA
	ld a, [\1_ADDRESS]
	bit \1_BIT, a
	set \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
MACRO CheckAndResetEngineA
	ld a, [\1_ADDRESS]
	bit \1_BIT, a
	res \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
MACRO CheckAndSetEngineForceReuseHL
	bit \1_BIT, [hl]
	set \1_BIT, [hl]
ENDM

;\1 = event index
MACRO CheckAndResetEngineForceReuseHL
	bit \1_BIT, [hl]
	res \1_BIT, [hl]
ENDM

;\1 = event index
MACRO CheckAndSetEngineForceReuseA
	bit \1_BIT, a
	set \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
MACRO CheckAndResetEngineForceReuseA
	bit \1_BIT, a
	res \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
MACRO SetEngine
	ld hl, \1_ADDRESS
	set \1_BIT, [hl]
ENDM

;\1 = event index
MACRO SetEngineForceReuseHL
	set \1_BIT, [hl]
ENDM

;\1 = event index
MACRO ResetEngine
	ld hl, \1_ADDRESS
	res \1_BIT, [hl]
ENDM

;\1 = event index
MACRO ResetEngineForceReuseHL
	res \1_BIT, [hl]
ENDM
