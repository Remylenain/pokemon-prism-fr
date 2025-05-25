CopyPkmnToTempMon:
; gets the BaseData of a Pkmn
; and copys the PkmnStructure to wTempMon

	ld a, [wCurPartyMon]
	ld e, a
	call GetPkmnSpecies
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData

	ld a, [wMonType]
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	and a
	jr z, .copywholestruct
	ld hl, wOTPartyMon1Species
	cp OTPARTYMON
	jr z, .copywholestruct
	ld bc, BOXMON_STRUCT_LENGTH

	ld a, [wCurPartyMon]
	ld hl, sBoxMon1Species
	ld bc, BOXMON_STRUCT_LENGTH
	rst AddNTimes
	ld de, wTempMonSpecies
	sbk BANK(sBoxMon1Species)
	rst CopyBytes
	jp CloseSRAM

.copywholestruct
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld de, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	ret

CalcwBufferMonStats:
	ld bc, wBufferMon
	jr _TempMonStatsCalculation

CalcTempmonStats:
	ld bc, wTempMon
_TempMonStatsCalculation:
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	push bc
	ld b, $1
	predef CalcPkmnStats
	pop bc
	ld hl, MON_HP
	add hl, bc
	ld d, h
	ld e, l
	ld a, [wCurPartySpecies]
	cp EGG
	jr nz, .not_egg
	xor a
	ld [de], a
	inc de
	ld [de], a
	jr .zero_status

.not_egg
	push bc
	ld hl, MON_MAXHP
	add hl, bc
	ld bc, 2
	rst CopyBytes
	pop bc

.zero_status
	ld hl, MON_STATUS
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ret

GetPkmnSpecies:
; [wMonType] has the type of the Pkmn
; e = Nr. of Pkmn (i.e. [wCurPartyMon])

	ld a, [wMonType]
	and a ; PARTYMON
	jr z, .partymon
	dec a ; OTPARTYMON
	ld hl, wOTPartySpecies
	jr z, .done
	dec a ; BOXMON
	jr z, .boxmon
	dec a ; BREEDMON
	jr z, .breedmon
	; WILDMON

.partymon
	ld hl, wPartySpecies

.done
	ld d, 0
	add hl, de
	ld a, [hl]

.done2
	ld [wCurPartySpecies], a
	ret

.boxmon
	sbk BANK(sBoxSpecies)
	ld hl, sBoxSpecies
	call .done
	jp CloseSRAM

.breedmon
	ld a, [wBreedMon1Species]
	jr .done2
