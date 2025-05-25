SpurgeHidePokemon::
	ld de, wMisc
	ld bc, wPartyMon1
	ld h, 6
.loop
	push hl
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	cp MAX_LEVEL
	jr nc, .atMaxLevel
	ld [wTempMonLevel], a
	push de
	push bc
	call CalcExpToNextLevelPercent
	pop bc
	pop de
	ldh a, [hLongQuotient + 3]
	cpl
	jr .writePercent
.atMaxLevel
	call Random
.writePercent
	ld [de], a
	inc de
	ld a, PARTYMON_STRUCT_LENGTH
	add c
	ld c, a
	adc b
	sub c
	ld b, a
	pop hl
	ld a, 6
	sub h
	ld [de], a
	inc de
	dec h
	jr nz, .loop

	call SortPartyFromWeakestToStrongest
	call ReorganizeParty
	ld hl, wPartySpecies
	ld a, [hld]
	ld [wBackupSecondPartySpecies], a
	xor a
	ld [hli], a
	ld [hl], $ff
	ret

CalcExpToNextLevelPercent:
	ld hl, MON_EXP
	add hl, bc
	ld de, wTempMonExp
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	callba CalcExpToNextLevel
	ld a, [wTempMonLevel]
	ld d, a
	callba CalcExpAtLevel
	ld hl, wTotalExpToNextLevel + 2

	ldh a, [hQuotient + 2]
	ld b, a
	ld a, [hld]
	sub b
	ld e, a

	ldh a, [hQuotient + 1]
	ld b, a
	ld a, [hld]
	sbc b
	ld d, a

	ldh a, [hQuotient]
	ld b, a
	ld a, [hl]
	sbc b
	ld c, a
	jr z, .notFluctuatingL99
; scale both exp values by 2
; scale wTotalExpToNextLevel
	srl c
	rr d
	rr e
; scale wTotalExpToNextLevel
	ld hl, wExpToNextLevel
	srl [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
.notFluctuatingL99
	ld hl, wExpToNextLevel + 1
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	xor a
	ldh [hMultiplicand], a
	dec a
	ldh [hMultiplier], a
	predef Multiply
	ld a, d
	ldh [hDivisor], a
	ld a, e
	ldh [hDivisor + 1], a
	predef_jump DivideLong

SortPartyFromWeakestToStrongest:
	ld hl, wMisc
	ld c, 6
.loop1
	push hl
	push bc
	call .SortIteration
	pop bc
	pop hl
	jr c, .loop1
	ld hl, wWeakestToStrongestMonList + 2
	ld de, wMisc
	ld c, 6
.loop2
	ld a, [hli]
	ld [de], a
	inc hl
	inc hl
	inc de
	dec c
	jr nz, .loop2
	ret

.SortIteration:
; make sure the list of c items at hl is currently in descending order
; items: 16-bit big-endian value, 8-bit index
; swap the items and return carry if it's not in descending order
	ld de, 0
	ld b, -1
.loop
	ld a, [hli]
	cp d
	jr c, .swap
	jr nz, .replace_de
	ld a, [hl]
	cp e
	jr c, .swap
.replace_de
	dec hl
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld b, a
	dec c
	jr nz, .loop
	and a
	ret

.swap
	inc hl
	ld a, [hl]
	ld [hl], b
	ld b, a
	dec hl
	ld a, [hl]
	ld [hl], e
	ld e, a
	dec hl
	ld a, [hl]
	ld [hl], d
	ld d, a
	dec hl
	ld [hl], b
	dec hl
	ld [hl], e
	dec hl
	ld [hl], d
	scf
	ret

ReorganizeParty:
; copy species
; copy mon data
; copy ot name
; copy nickname
	xor a
.loop
	ldh [hMonToStore], a
	ld hl, wWeakestToStrongestMonList
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ldh [hMonToCopy], a

	add LOW(wPartySpecies)
	ld e, a
	adc HIGH(wPartySpecies)
	sub e
	ld d, a

	ld hl, wPartySpeciesMisc
	add hl, bc
	ld a, [de]
	ld [hl], a

	ld hl, wPartyMon1Misc
	ld de, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call .CopyPartymonDataToMisc

	ld hl, wPartyMonOTMisc
	ld de, wPartyMonOT
	ld bc, NAME_LENGTH
	push bc
	call .CopyPartymonDataToMisc
	pop bc

	ld hl, wPartyMonNicknamesMisc
	ld de, wPartyMonNicknames
	call .CopyPartymonDataToMisc

.handleLoop
	ldh a, [hMonToStore]
	inc a
	cp 6
	jr nz, .loop
	ld [wPartyCountMisc], a
	ld a, $ff
	ld [wPartyEndMisc], a
	ld hl, wPokemonDataMisc
	ld de, wPokemonData
	ld bc, wPokemonDataMiscEnd - wPokemonDataMisc
	rst CopyBytes
	ret

.CopyPartymonDataToMisc:
	ldh a, [hMonToStore]
	rst AddNTimes
	push hl
	ld h, d
	ld l, e
	ldh a, [hMonToCopy]
	rst AddNTimes
	pop de
	rst CopyBytes
	ret

UnhideParty::
	ld hl, wPartyCount
	ld c, [hl]
	ld b, 0
	ld a, 6
	ld [hli], a
	add hl, bc
	ld a, [wBackupSecondPartySpecies]
	ld [hl], a
	ld a, $ff
	ld [wPartyEnd], a
	ret
