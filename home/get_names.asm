GetName::
; Return name wCurSpecies from name list wNamedObjectTypeBuffer in wStringBuffer1.
	ld a, [wCurSpecies]
	and a
	ld a, 15
	jp z, Crash
	push hl
	push de
	push bc
	call .GetName
	jp PopOffBCDEHLAndReturn

.GetName:
	ld a, [wNamedObjectTypeBuffer]
	cp PKMN_NAME
	jr z, GetName_GetPokemonName
	cp PARTY_OT_NAME
	ld hl, wPartyMonOT
	jr z, .OTName
	cp ENEMY_OT_NAME
	ld hl, wOTPartyMonOT
	jr nz, .notSpecialName
.OTName
	ld a, [wCurSpecies]
	dec a
	call SkipNames
	ld de, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret
.notSpecialName
	ld a, [wNamedObjectTypeBuffer]
	and a
	jr z, GetName_NoneName
	dec a
	ld e, a
	ld d, 0
	ld hl, NamesPointers
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	call StackCallInBankB
	; end of function

	ld a, [wCurSpecies]
GetNthStringBasedOnLengthDeltas:
	ld b, 0
	jr .handleLoop

.loop
	add hl, bc
.handleLoop
	ld c, [hl]
	dec a
	jr nz, .loop
	inc hl
	dec c
	ld de, wStringBuffer1
	rst CopyBytes
	ld a, "@"
	ld [de], a
	ret

GetName_GetPokemonName:
	ld a, [wCurSpecies]
	ld [wNamedObjectTypeBuffer], a

GetPokemonName::
	; copy name for species at [wd265] into wStringBuffer1
	anonbankpush PokemonNames
	; end of funciton

	push hl
	ld a, [wd265]
	assert (PKMN_NAME_LENGTH - 1) == 10
	; hl = a * 10
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add a, l
	ld l, a
	adc h
	sbc l
	ld h, a
	add hl, hl
	ld de, PokemonNames - (PKMN_NAME_LENGTH - 1)
	add hl, de
	ld de, wStringBuffer1
	push de
	ld bc, PKMN_NAME_LENGTH - 1
	rst CopyBytes
	; CopyBytes exits with hl and de pointing at the end of the buffers
	ld a, "@"
	ld [de], a
	pop de
	pop hl
	ret

GetName_NoneName:
	ld de, NoneString
	ld hl, wStringBuffer1
	jp CopyName2

NoneString:
	db "NONE@"

NamesPointers::
	dba PokemonNames
	dba MoveNames
	dba AbilityNames
	dba ItemNames
	dbw 0, wPartyMonOT
	dbw 0, wOTPartyMonOT
	dba TrainerClassNames

GetNthString::
; Return the address of the
; ath string starting from hl.

	and a
	ret z

	push bc
	ld b, a
	ld c, "@"
.readChar
	ld a, [hli]
	cp c
	jr nz, .readChar
	dec b
	jr nz, .readChar
	pop bc
	ret

GetBasePokemonName::
; Discards gender (Nidoran).

	push hl
	call GetPokemonName

	ld hl, wStringBuffer1
.loop
	ld a, [hl]
	cp "@"
	jr z, .quit
	cp "♂"
	jr z, .end
	cp "♀"
	jr z, .end
	inc hl
	jr .loop
.end
	ld [hl], "@"
.quit
	pop hl
	ret

GetAbilityName::
	ld a, [wd265]
	ld [wCurSpecies], a
	ld a, ABILITY_NAME
	ld [wNamedObjectTypeBuffer], a
	call GetName
GetAbilityName_AfterGetName::
	ld de, wStringBuffer1
	ret

GetItemName::
; Get name of item wNamedObjectIndexBuffer

	push hl
	push bc
	ld a, [wNamedObjectIndexBuffer]
	ld [wCurSpecies], a
	ld a, ITEM_NAME
	ld [wNamedObjectTypeBuffer], a
	call GetName
GetItemName_AfterGetName::
	ld de, wStringBuffer1
	pop bc
	pop hl
	ret

GetTMHMName::
; Get TM/HM name by item id wd265.

	push hl
	push de
	push bc
	ld a, [wd265]
	push af

; TM/HM prefix
	cp HM01
	push af
	jr c, .TM

	ld hl, .HMText
	ld bc, .HMTextEnd - .HMText
	jr .copyToStrBuffer

.TM:
	ld hl, .TMText
	ld bc, .TMTextEnd - .TMText

.copyToStrBuffer
	ld de, wStringBuffer1
	rst CopyBytes

; HM numbers start from 51, not 1
	pop af
	ld a, [wd265]
	jr c, .HM
	sub NUM_TMS
.HM

; Divide and mod by 10 to get the top and bottom digits respectively
	ld b, "0"
	jr .handleLoop
.mod10
	inc b
.handleLoop
	sub 10
	jr nc, .mod10
	add 10

	push af
	ld a, b
	ld [de], a
	inc de
	pop af

	ld b, "0"
	add b
	ld [de], a

; End the string
	inc de
	ld a, "@"
	ld [de], a

	pop af
	ld [wd265], a
	jp PopOffBCDEHLAndReturn

.TMText:
	db "TM"
.TMTextEnd:
	db "@"

.HMText:
	db "HM"
.HMTextEnd:
GenericDummyString::
	db "@"

IsHM::
	cp HM01
	jr c, .NotHM
	scf
	ret
.NotHM:
	and a
	ret

GetMoveName::
	push hl

	ld a, MOVE_NAME
	ld [wNamedObjectTypeBuffer], a

	ld a, [wNamedObjectIndexBuffer] ; move id
	ld [wCurSpecies], a

	call GetName
GetMoveName_AfterGetName::
	ld de, wStringBuffer1

	pop hl
	ret

GetTrainerClassName:
	push hl
	ld hl, wRivalName
	ld a, [wNamedObjectIndexBuffer]
	cp RIVAL1
	jr nz, .not_rival
	ld de, wStringBuffer1
	push de
	ld bc, NAME_LENGTH
	rst CopyBytes
	pop de
	pop hl
	ret

.not_rival
	ld [wCurSpecies], a
	ld a, TRAINER_NAME
	ld [wNamedObjectTypeBuffer], a
	call GetName
GetTrainerClassName_AfterGetName::
	ld de, wStringBuffer1
	pop hl
	ret
