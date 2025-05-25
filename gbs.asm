DEF LOAD_ADDRESS EQU $3F30

; remapped RSTs
DEF JumpTable EQU $00
DEF FarCall   EQU $30
EXPORT JumpTable, FarCall

INCLUDE "includes.asm"

SECTION "GBS Header", ROM0[LOAD_ADDRESS - $70]
	newcharmap header
	db "GBS"         ;signature
	db 1             ;version
	db NUM_MUSIC - 1 ;number of songs
	db 1             ;first song
	dw LOAD_ADDRESS  ;load address
	dw GBS_Init      ;init address
	dw GBS_Play      ;play address
	dw wStack        ;stack pointer
	db 0             ;rTMA
	db 0             ;rTAC
GBS_TitleText:
	db "Pokemon Prism (v{d:VERSION_MAJOR}.{02d:VERSION_MINOR}.{04d:BUILD_NUMBER})"
	ds GBS_TitleText - @ + 32
GBS_AuthorText:
	db ""
	ds GBS_AuthorText - @ + 32
GBS_CopyrightText:
	db "20{02d:ST_YEAR} RainbowDevs 2001 Nintendo"
	ds GBS_CopyrightText - @ + 32

SECTION "GBS home bank", ROM0[LOAD_ADDRESS]

	assert @ == (LOAD_ADDRESS + JumpTable)
	assert @ == Jumptable
INCLUDE "home/jumptable.asm"

GBS_Init:
	inc a
	ld e, a
	ld d, 0
	ld a, 1 << VBLANK
	ldh [rIE], a
	ld a, 1 << 5 ; stereo on
	ld [wOptions], a
	ei
	call TurnSoundOff
	jr PlayMusic

	assert @ == (LOAD_ADDRESS + FarCall)
	assert @ == StackFarCall
INCLUDE "home/farcall.asm"

INCLUDE "home/audio.asm"

GBS_Play:
	call UpdateSound
	reti

GetFarByte::
	call StackCallInBankA
	ld a, [hl]
GenericDummyFunction::
	ret

ByteFill::
; fill bc bytes with the value of a, starting at hl
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .HandleLoop
.PutByte
	ld [hli], a
.HandleLoop
	dec c
	jr nz, .PutByte
	dec b
	jr nz, .PutByte
	ret
