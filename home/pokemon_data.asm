PrepMonFrontpic::
	ld a, 1
	ld [wBoxAlignment], a
	; fallthrough

_PrepMonFrontpic::
	ld a, [wCurPartySpecies]
	call IsAPokemon
	jr c, .not_pokemon

	push hl
	ld de, vBGTiles
	predef GetFrontpic
	pop hl
	xor a
	ldh [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	xor a
	ld [wBoxAlignment], a
	ret

.not_pokemon
	xor a
	ld [wBoxAlignment], a
	inc a
	ld [wCurPartySpecies], a
	ret

PrintLevel::
; Print wTempMonLevel at hl

	ld a, [wTempMonLevel]
	ld [hl], "<LV>"
	inc hl

; How many digits?
	ld c, 2
	cp 100
	jr c, PrintLevelNumber

; 3-digit numbers overwrite the :L.
	dec hl
	inc c
	jr PrintLevelNumber

PrintFullLevel::
; Print :L and all 3 digits
	ld [hl], "<LV>"
	inc hl
	ld c, 3
PrintLevelNumber::
	ld [wd265], a
	ld de, wd265
	ld b, PRINTNUM_LEFTALIGN | 1
	jp PrintNum

GetBaseData::
	anonbankpush BaseData

	push hl
	push de
	push bc

; Egg doesn't have BaseData
	ld a, [wCurSpecies]
	cp EGG
	jr z, .egg

; Get BaseData
	dec a
	ld bc, BaseData1 - BaseData0
	ld hl, BaseData
	ld de, wCurBaseData
	call CopyNthStruct
	jr .end

.egg
; Sprite dimensions
	ld a, $55
	ld [wBasePicSize], a

.end
; Replace Pokedex # with species
	ld a, [wCurSpecies]
	ld [wBaseDexNo], a
	jp PopOffBCDEHLAndReturn

GetPartyParam::
	push hl
	call GetPartyParamLocation
	ld a, [hl]
ScriptStopASM::
	pop hl
	ret

GetPartyParamLocation::
; Get the location of parameter a from wCurPartyMon in hl
	push bc
	ld hl, wPartyMons
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartyMon]
	call GetPartyLocation
	pop bc
	ret

HMMoves:
	db CUT
	db FLY
	db SURF
	db STRENGTH
	db ROCK_SMASH
	db $ff
