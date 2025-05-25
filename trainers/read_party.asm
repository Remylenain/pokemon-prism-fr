ReadTrainerParty:
	ld a, [wInBattleTowerBattle]
	and a
	ret nz

	ld a, [wLinkMode]
	and a
	ret nz

	ld hl, wOTPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, wOTPartyMons
	ld bc, wOTPartyMonsEnd - wOTPartyMons
	xor a
	call ByteFill

	ld a, [wOtherTrainerClass]
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wOtherTrainerID]
	ld b, a
	jr .handleLoop

.loop
	ld a, [hli]
	cp $ff
	jr nz, .loop
.handleLoop
	dec b
	jr nz, .loop
.skip_name
	ld a, [hli]
	cp "@"
	jr nz, .skip_name

	ld a, [hli]
	ld [wTempTrainerType], a
	call .ReadParty
	ld hl, hProduct
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, [wEnemyTrainerBaseReward]
	ld [hli], a
	ld a, [wCurPartyLevel]
	ld [hl], a
	predef Multiply
	ld hl, wBattleReward
	xor a
	ld [hli], a
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	ret

.ReadParty
	ld a, [hli]
	cp $ff
	ret z
	; level
	ld [wCurPartyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a

	ld a, OTPARTYMON
	ld [wMonType], a

	push hl
	predef TryAddMonToParty
	pop hl

	ld a, [wTempTrainerType]
	bit 1, a
	jr z, .skip_item

	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	pop hl

	ld a, [hli]
	ld [de], a

.skip_item
	ld a, [wTempTrainerType]
	bit 2, a
	jr z, .skip_nickname

	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMonNicknames
	call SkipNames
	pop de
	call PlaceString
	ld h, d
	ld l, e
	inc hl

.skip_nickname
	ld a, [wTempTrainerType]
	bit 0, a
	jr z, .ReadParty
	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	pop hl

	ld b, NUM_MOVES
.copy_moves
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_moves

	push hl

	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, MON_PP
	add hl, de

	push hl
	ld hl, MON_MOVES
	add hl, de
	pop de

	ld b, NUM_MOVES
.copy_pp
	ld a, [hli]
	and a
	jr z, .copied_pp

	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	pop hl

	ld [de], a
	inc de
	dec b
	jr nz, .copy_pp
.copied_pp

	pop hl
	jp .ReadParty

Battle_GetTrainerName::
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ld hl, wOTPlayerName
	jp nz, CopyTrainerName

	ld a, [wOtherTrainerID]
	ld b, a
	ld a, [wOtherTrainerClass]
	ld c, a

GetTrainerName::
	dec c
	push bc
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	jr .handleLoop
.skip
	ld a, [hli]
	cp $ff
	jr nz, .skip
.handleLoop
	dec b
	jr nz, .skip

CopyTrainerName:
	ld de, wStringBuffer1
	push de
	ld bc, NAME_LENGTH
	rst CopyBytes
	pop de
	ret
