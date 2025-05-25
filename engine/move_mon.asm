TryAddMonToParty:
; Check if to copy wild Pkmn or generate new Pkmn
	; Whose is it?
	ld de, wPartyCount
	ld a, [wMonType]
	and $f
	jr z, .get_party_location ; PARTYMON
	ld de, wOTPartyCount

.get_party_location
	; Do we have room for it?
	ld a, [de]
	inc a
	cp PARTY_LENGTH + 1
	ret nc
	; Increase the party count
	ld [de], a
	ldh [hMoveMon], a ; HRAM backup
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	; Load the species of the Pokemon into the party list.
	; The terminator is usually here, but it'll be back.
	ld a, [wCurPartySpecies]
	ld [de], a
	; Load the terminator into the next slot.
	inc de
	ld a, -1
	ld [de], a
	; Now let's load the OT name.
	ld hl, wPartyMonOT
	ld a, [wMonType]
	and $f
	jr z, .load_OT_name
	ld hl, wOTPartyMonOT

.load_OT_name
	ldh a, [hMoveMon] ; Restore index from backup
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wPlayerName
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld a, [wMonType]
	and a
	jr nz, .skip_nickname
	ld a, [wCurPartySpecies]
	ld [wd265], a
	call GetPokemonName
	ld hl, wPartyMonNicknames
	ldh a, [hMoveMon]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

.skip_nickname
	ld hl, wPartyMon1Species
	ld a, [wMonType]
	and $f
	jr z, .initialize_stats
	ld hl, wOTPartyMon1Species

.initialize_stats
	ldh a, [hMoveMon]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld e, l
	ld d, h
	push hl
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseDexNo]
	ld [de], a
	inc de
	ld a, [wBattleMode]
	and a
	jr z, .skip_item ; a is already 0
	ld a, [wEnemyMonItem]

.skip_item
	ld [de], a
	inc de
	push de
	ld h, d
	ld l, e
	ld a, [wBattleMode]
	and a
	jr z, .randomly_generate_moves
	ld a, [wMonType]
	and a
	jr nz, .randomly_generate_moves
	ld de, wEnemyMonMoves
	rept NUM_MOVES - 1
		ld a, [de]
		inc de
		ld [hli], a
	endr
	ld a, [de]
	ld [hl], a
	jr .got_moves

.randomly_generate_moves
	xor a
	rept NUM_MOVES - 1
		ld [hli], a
	endr
	ld [hl], a
	ld [wFillMoves_IsPartyMon], a
	predef FillMoves

.got_moves
	pop de
	push de
	ld a, [wMonType]
	and $f
	call z, AddMovesObtained
	pop de
	inc de
	inc de
	inc de
	inc de

	ld a, [wPlayerID]
	ld [de], a
	inc de
	ld a, [wPlayerID + 1]
	ld [de], a
	inc de
	push de
	ld a, [wCurPartyLevel]
	ld d, a
	callba CalcExpAtLevel
	pop de
	ldh a, [hProduct + 1]
	ld [de], a
	inc de
	ldh a, [hProduct + 2]
	ld [de], a
	inc de
	ldh a, [hProduct + 3]
	ld [de], a
	inc de
	xor a
	ld b, 10
.loop
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	pop hl
	push hl
	ld a, [wMonType]
	and $f
	jr z, .generate_DVs
	push hl
	callba GetTrainerDVs
	pop hl
	jr .initialize_trainer_mon_stats

.generate_DVs
	ld a, [wCurPartySpecies]
	ld [wd265], a
	dec a
	push de
	call CheckCaughtMon
	ld a, [wd265]
	dec a
	call SetSeenAndCaughtMon
	pop de
	pop hl
	push hl
	ld a, [wBattleMode]
	and a
	jr nz, .copy_wild_mon_stats
	call Random
	ld b, a
	call Random
	ld c, a

.initialize_trainer_mon_stats
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	push hl
	push de
	inc hl
	inc hl
	call FillPP
	pop de
	pop hl
	rept 4
		inc de
	endr
	ld a, 70
	ld [de], a
	inc de
	xor a
	rept 3
		ld [de], a
		inc de
	endr
	ld a, [wCurPartyLevel]
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld bc, 10
	add hl, bc
	ld c, 1 ; b = 0 already
	ld a, c
	call CalcPkmnStatC
	ldh a, [hProduct + 2]
	ld [de], a
	inc de
	ldh a, [hProduct + 3]
	ld [de], a
	inc de
	jr .got_stats

.copy_wild_mon_stats
	ld a, [wEnemyMonDVs]
	ld [de], a
	inc de
	ld a, [wEnemyMonDVs + 1]
	ld [de], a
	inc de

	push hl
	ld hl, wEnemyMonPP
	ld b, NUM_MOVES
.wild_mon_PP_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .wild_mon_PP_loop
	pop hl

	ld a, BASE_HAPPINESS
	ld [de], a
	inc de
	xor a
	rept 3
		ld [de], a
		inc de
	endr
	ld a, [wCurPartyLevel]
	ld [de], a
	inc de
	ld hl, wEnemyMonStatus
	; Copy wEnemyMonStatus, wEnemyMonSemistatus, wEnemyMonHP
	rept 4
		ld a, [hli]
		ld [de], a
		inc de
	endr

.got_stats
	ld a, [wBattleMode]
	dec a
	jr nz, .generate_stats
	ld hl, wEnemyMonMaxHP
	ld bc, 2 * 6 ; MaxHP + 5 Stats
	rst CopyBytes
	pop hl
	jr .done_generating_stats

.generate_stats
	pop hl
	ld bc, MON_STAT_EXP - 1
	add hl, bc
	call CalcPkmnStats ; with b = 0, stat calculation ignores stat exp

.done_generating_stats
	ld a, [wMonType]
	and $f
	ld a, [wCurPartySpecies]
	scf ; When this function returns, the carry flag indicates success vs failure.
	ret

FillPP:
	push bc
	ld b, NUM_MOVES
.loop
	ld a, [hli]
	and a
	jr z, .next
	dec a
	push hl
	push de
	push bc
	ld hl, Moves
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld de, wStringBuffer1
	ld a, BANK(Moves)
	call FarCopyBytes
	pop bc
	pop de
	pop hl
	ld a, [wStringBuffer1 + MOVE_PP]

.next
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	pop bc
	ret

AddTempmonToParty:
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	scf
	ret z

	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartySpecies]
	ld [hli], a
	ld [hl], $ff

	ld hl, wPartyMon1Species
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld e, l
	ld d, h
	ld hl, wTempMonSpecies
	rst CopyBytes

	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wOTPartyMonOT
	ld a, [wCurPartyMon]
	call SkipNames
	ld bc, NAME_LENGTH
	rst CopyBytes

	ld hl, wPartyMonNicknames
	ld a, [wPartyCount]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wOTPartyMonNicknames
	ld a, [wCurPartyMon]
	call SkipNames
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndexBuffer], a
	cp EGG
	jr z, .egg
	dec a
	call SetSeenAndCaughtMon
	ld hl, wPartyMon1Happiness
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld [hl], BASE_HAPPINESS
	ld de, wTempMonMoves
	call AddMovesObtained
.egg
	ld a, [wCurPartySpecies]
	and a
	ret

SentGetPkmnIntoFromBox:
; Sents/Gets Pkmn into/from Box depending on Parameter
; wPokemonWithdrawDepositParameter == 0: get Pkmn into Party
; wPokemonWithdrawDepositParameter == 1: sent Pkmn into Box
; wPokemonWithdrawDepositParameter == 2: get Pkmn from DayCare
; wPokemonWithdrawDepositParameter == 3: put Pkmn into DayCare

	sbk BANK(sBoxCount)
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .check_party_full
	cp DAYCARE_WITHDRAW
	jr z, .check_party_full
	cp DAYCARE_DEPOSIT
	ld hl, wBreedMon1Species
	jr z, .breedmon

	; we want to sent a Pkmn into the Box
	; so check if there's enough space
	ld hl, sBoxCount
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .there_is_room
.no_room
	scls
	scf
	ret

.check_party_full
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr z, .no_room

.there_is_room
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wPokemonWithdrawDepositParameter]
	cp DAYCARE_WITHDRAW
	ld a, [wBreedMon1Species]
	jr z, .got_species
	ld a, [wCurPartySpecies]

.got_species
	ld [hli], a
	ld [hl], $ff
	ld a, [wPokemonWithdrawDepositParameter]
	dec a
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wPartyCount]
	jr nz, .found_room
	ld hl, sBoxMon1Species
	ld bc, BOXMON_STRUCT_LENGTH
	ld a, [sBoxCount]

.found_room
	dec a ; wPartyCount - 1
	rst AddNTimes

.breedmon
	push hl
	ld e, l
	ld d, h
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	ld hl, sBoxMon1Species
	ld bc, BOXMON_STRUCT_LENGTH
	jr z, .got_address_and_offset
	cp DAYCARE_WITHDRAW
	ld hl, wBreedMon1Species
	jr z, .got_final_address
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH

.got_address_and_offset
	ld a, [wCurPartyMon]
	rst AddNTimes

.got_final_address
	ld bc, BOXMON_STRUCT_LENGTH
	rst CopyBytes
	ld a, [wPokemonWithdrawDepositParameter]
	cp DAYCARE_DEPOSIT
	ld de, wBreedMon1OT
	jr z, .got_OT_final_destination_address
	dec a
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	jr nz, .got_OT_destination_address_and_offset
	ld hl, sBoxMonOT
	ld a, [sBoxCount]

.got_OT_destination_address_and_offset
	dec a
	call SkipNames
	ld d, h
	ld e, l

.got_OT_final_destination_address
	ld hl, sBoxMonOT
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .got_OT_source_address_and_offset
	ld hl, wBreedMon1OT
	cp DAYCARE_WITHDRAW
	jr z, .got_OT_final_source_address
	ld hl, wPartyMonOT

.got_OT_source_address_and_offset
	ld a, [wCurPartyMon]
	call SkipNames

.got_OT_final_source_address
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld a, [wPokemonWithdrawDepositParameter]
	cp DAYCARE_DEPOSIT
	ld de, wBreedMon1Nick
	jr z, .got_nickname_final_destination_address
	dec a
	ld hl, wPartyMonNicknames
	ld a, [wPartyCount]
	jr nz, .got_nickname_destination_address_and_offset
	ld hl, sBoxMonNicknames
	ld a, [sBoxCount]

.got_nickname_destination_address_and_offset
	dec a
	call SkipNames
	ld d, h
	ld e, l

.got_nickname_final_destination_address
	ld hl, sBoxMonNicknames
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .got_nickname_source_address_and_offset
	ld hl, wBreedMon1Nick
	cp DAYCARE_WITHDRAW
	jr z, .got_nickname_final_source_address
	ld hl, wPartyMonNicknames

.got_nickname_source_address_and_offset
	ld a, [wCurPartyMon]
	call SkipNames

.got_nickname_final_source_address
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	pop hl

	ld a, [wPokemonWithdrawDepositParameter]
	cp PC_DEPOSIT
	jr z, .took_out_of_box
	cp DAYCARE_DEPOSIT
	jr z, .done

	push hl
	srl a
	add a, 2
	ld [wMonType], a
	predef CopyPkmnToTempMon
	callba CalcLevel
	ld a, d
	ld [wCurPartyLevel], a
	pop hl

	ld b, h
	ld c, l
	ld hl, MON_LEVEL
	add hl, bc
	ld [hl], a
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_STAT_EXP - 1
	add hl, bc

	push bc
	ld b, 1
	call CalcPkmnStats
	pop bc

	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr nz, .done
	ld hl, MON_STATUS
	add hl, bc
	xor a
	ld [hl], a
	ld hl, MON_HP
	add hl, bc
	ld d, h
	ld e, l
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	inc hl
	inc hl
	ld a, [hli]
	ld [de], a
	ld a, [hl]
	inc de
	ld [de], a
	jr .done

.egg
	xor a
	ld [de], a
	inc de
	ld [de], a
	jr .done

.took_out_of_box
	ld a, [sBoxCount]
	dec a
	ld b, a
	call RestorePPOfWithdrawnBoxMon
.done
	scls
	and a
	ret

RestorePPOfWithdrawnBoxMon:
	ld a, b
	ld hl, sBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
	rst AddNTimes
	ld b, h
	ld c, l
	ld hl, MON_PP
	add hl, bc
	push hl
	push bc
	ld de, wTempMonPP
	ld bc, NUM_MOVES
	rst CopyBytes
	pop bc
	ld hl, MON_MOVES
	add hl, bc
	push hl
	ld de, wTempMonMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	pop hl
	pop de

	ld a, [wMenuCursorY]
	push af
	ld a, [wMonType]
	push af
	ld b, 0
.loop
	ld a, [hli]
	and a
	jr z, .done
	ld [wTempMonMoves], a
	ld a, BOXMON
	ld [wMonType], a
	ld a, b
	ld [wMenuCursorY], a
	push bc
	push hl
	push de
	callba GetMaxPPOfMove
	pop de
	pop hl
	ld a, [wd265]
	ld b, a
	ld a, [de]
	and %11000000
	add b
	ld [de], a
	pop bc
	inc de
	inc b
	ld a, b
	cp NUM_MOVES
	jr c, .loop

.done
	pop af
	ld [wMonType], a
	pop af
	ld [wMenuCursorY], a
	ret

RetrievePokemonFromDaycareMan:
	call GetBreedMon1LevelGrowth
	xor a
	jr RetrievePokemonFromDaycare

RetrievePokemonFromDaycareLady:
	call GetBreedMon2LevelGrowth
	ld a, 1
RetrievePokemonFromDaycare:
	ld [wPokemonWithdrawDepositParameter], a
	ld a, b
	ld [wd002], a
	ld a, e
	ld [wCurPartyLevel], a
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr c, .room_in_party
	scf
	ret

.room_in_party
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	ld a, [wBreedMon1Species]
	ld de, wBreedMon1Nick
	jr z, .okay
	ld a, [wBreedMon2Species]
	ld de, wBreedMon2Nick

.okay
	ld [hli], a
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	ld [hl], $ff
	ld hl, wPartyMonNicknames
	ld a, [wPartyCount]
	dec a
	call SkipNames
	push hl
	ld h, d
	ld l, e
	pop de
	rst CopyBytes
	push hl
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	pop hl
	rst CopyBytes
	push hl
	call FindEmptySpotInParty
	pop hl
	ld bc, BOXMON_STRUCT_LENGTH
	rst CopyBytes
	call GetBaseData
	call FindEmptySpotInParty
	ld b, d
	ld c, e
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [wCurPartyLevel]
	ld [hl], a
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	push bc
	ld b, 1
	call CalcPkmnStats
	ld hl, wPartyMon1Moves
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ld a, 1
	ld [wFillMoves_IsPartyMon], a
	predef FillMoves
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	callba HealPartyMon
	ld a, [wCurPartyLevel]
	ld d, a
	callba CalcExpAtLevel
	pop bc
	ld hl, MON_EXP
	add hl, bc
	ldh a, [hMultiplicand]
	ld [hli], a
	ldh a, [hMultiplicand + 1]
	ld [hli], a
	ldh a, [hMultiplicand + 2]
	ld [hl], a
	and a
	ret

GetBreedMon1LevelGrowth:
	ld de, wBreedMon1Level
	ld hl, wBreedMon1Stats
	jr GetBreedMonLevelGrowth

GetBreedMon2LevelGrowth:
	ld de, wBreedMon2Level
	ld hl, wBreedMon2Stats
GetBreedMonLevelGrowth:
	push de
	ld de, wTempMon
	ld bc, BOXMON_STRUCT_LENGTH
	rst CopyBytes
	callba CalcLevel
	pop hl
	ld b, [hl]
	ld a, d
	ld e, a
	sub b
	ld d, a
	ret

FindEmptySpotInParty:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ret

DepositMonWithDaycareMan:
	ld de, wBreedMon1Nick
	jr DepositMonInDaycare

DepositMonWithDaycareLady:
	ld de, wBreedMon2Nick
	; fallthrough

DepositMonInDaycare:
	call DepositBreedmon
	xor a
	ld [wPokemonWithdrawDepositParameter], a
	jp RemoveMonFromPartyOrBox

DepositBreedmon:
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call SkipNames
	rst CopyBytes
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	call SkipNames
	rst CopyBytes
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld bc, BOXMON_STRUCT_LENGTH
	jp CopyBytes

SentPkmnIntoBox:
; Sents the Pkmn into one of Bills Boxes
; the data comes mainly from 'wEnemyMon:'
	sbk BANK(sBoxCount)
	ld de, sBoxCount
	ld a, [de]
	cp MONS_PER_BOX
	jp nc, .full
	inc a
	ld [de], a

	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	ld c, a
.index_shifting_loop
	inc de
	ld a, [de]
	ld b, a
	ld a, c
	ld c, b
	ld [de], a
	inc a
	jr nz, .index_shifting_loop

	call GetBaseData
	call ShiftBoxMon

	ld hl, wPlayerName
	ld de, sBoxMonOT
	ld bc, NAME_LENGTH
	rst CopyBytes

	ld a, [wCurPartySpecies]
	ld [wd265], a
	call GetPokemonName

	ld de, sBoxMonNicknames
	ld hl, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

	ld hl, wEnemyMon
	ld de, sBoxMon1
	ld bc, 1 + 1 + NUM_MOVES ; species + item + moves
	rst CopyBytes

	ld hl, wPlayerID
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	push de
	ld a, [wCurPartyLevel]
	ld d, a
	callba CalcExpAtLevel
	pop de
	ldh a, [hProduct + 1]
	ld [de], a
	inc de
	ldh a, [hProduct + 2]
	ld [de], a
	inc de
	ldh a, [hProduct + 3]
	ld [de], a
	inc de

	; set stat exp to zero
	xor a
	ld b, 2 * 5
.stat_exp_loop
	ld [de], a
	inc de
	dec b
	jr nz, .stat_exp_loop

	ld hl, wEnemyMonDVs
	ld bc, 2 + NUM_MOVES ; DVs and PP ; wEnemyMonHappiness - wEnemyMonDVs
	rst CopyBytes

	ld h, d
	ld l, e
	ld a, BASE_HAPPINESS
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, [wCurPartyLevel]
	ld [hl], a
	ld a, [wCurPartySpecies]
	dec a
	call SetSeenAndCaughtMon

	ld hl, sBoxMon1Moves
	ld de, wTempMonMoves
	ld bc, NUM_MOVES
	rst CopyBytes

	ld hl, sBoxMon1PP
	ld de, wTempMonPP
	ld bc, NUM_MOVES
	rst CopyBytes

	ld b, 0
	call RestorePPOfWithdrawnBoxMon

	scls

	ld de, wEnemyMonMoves
	call AddMovesObtained
	scf
	ret

.full
	scls
	and a
	ret

ShiftBoxMon:
	ld hl, sBoxMonOT
	ld bc, NAME_LENGTH
	call .shift

	ld hl, sBoxMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call .shift

	ld hl, sBoxMons
	ld bc, BOXMON_STRUCT_LENGTH

.shift
	ld a, [sBoxCount]
	cp 2
	ret c

	push hl
	rst AddNTimes
	dec hl
	ld e, l
	ld d, h
	pop hl

	ld a, [sBoxCount]
	dec a
	rst AddNTimes
	dec hl

	push hl
	ld a, [sBoxCount]
	dec a
	ld hl, 0
	rst AddNTimes
	ld c, l
	ld b, h
	pop hl
.loop
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

GiveEgg::
	ld a, [wCurPartySpecies]
	push af
	callba GetEggSpecies
	ld a, [wCurPartySpecies]
	dec a

; TryAddMonToParty sets Seen and Caught flags
; when it is successful.  This routine will make
; sure that we aren't newly setting flags.
	push af
	call CheckCaughtMon
	pop af
	push bc
	call CheckSeenMon
	push bc

	call TryAddMonToParty

; If we haven't caught this Pokemon before receiving
; the Egg, reset the flag that was just set by
; TryAddMonToParty.
	pop bc
	ld a, c
	and a
	jr nz, .skip_caught_flag
	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	ld hl, wPokedexCaught
	ld b, RESET_FLAG
	predef FlagAction

.skip_caught_flag
; If we haven't seen this Pokemon before receiving
; the Egg, reset the flag that was just set by
; TryAddMonToParty.
	pop bc
	ld a, c
	and a
	jr nz, .skip_seen_flag
	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	ld hl, wPokedexSeen
	ld b, RESET_FLAG
	predef FlagAction

.skip_seen_flag
	pop af
	ld [wCurPartySpecies], a
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Species
	rst AddNTimes
	ld a, [wCurPartySpecies]
	ld [hl], a
	ld hl, wPartyCount
	ld a, [hl]
	ld b, 0
	ld c, a
	add hl, bc
	ld a, EGG
	ld [hl], a
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld de, .egg_string
	call CopyName2
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Happiness
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [wMonStatusFlags]
	bit 1, a
	ld a, 1
	jr nz, .got_init_happiness
	ld a, [wBaseEggSteps]

.got_init_happiness
	ld [hl], a
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	xor a
	ld [hli], a
	ld [hl], a
	and a
	ret

.egg_string
	db "Egg@"

RemoveMonFromPartyOrBox::
	ld hl, wPartyCount

	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .okay

	sbk BANK(sBoxCount)
	ld hl, sBoxCount

.okay
	ld a, [hl]
	dec a
	ld [hli], a
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld e, l
	ld d, h
	inc de
.loop
	ld a, [de]
	inc de
	ld [hli], a
	inc a
	jr nz, .loop
	ld hl, wPartyMonOT
	ld d, PARTY_LENGTH - 1
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .party
	ld hl, sBoxMonOT
	ld d, MONS_PER_BOX - 1

.party
	; If this is the last mon in our party (box),
	; shift all the other mons up to close the gap.
	ld a, [wCurPartyMon]
	push af
	call SkipNames
	pop af
	cp d
	jr nz, .delete_inside
	ld [hl], -1
	jp CloseSRAM

.delete_inside
	; Shift the OT names
	ld d, h
	ld e, l
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld bc, wPartyMonNicknames
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .got_nickname_address
	ld bc, sBoxMonNicknames
.got_nickname_address
	call CopyDataUntil
	; Shift the struct
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .got_mon_struct_parameters
	ld hl, sBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
.got_mon_struct_parameters
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld d, h
	ld e, l
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .load_party_mon_OT
	ld bc, BOXMON_STRUCT_LENGTH
	add hl, bc
	ld bc, sBoxMonOT
	jr .copy

.load_party_mon_OT
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	ld bc, wPartyMonOT
.copy
	call CopyDataUntil
	; Shift the nicknames
	ld hl, wPartyMonNicknames
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .got_nicknames_for_shifting
	ld hl, sBoxMonNicknames
.got_nicknames_for_shifting
	ld bc, PKMN_NAME_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld d, h
	ld e, l
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld bc, wPartyMonNicknamesEnd
	ld a, [wPokemonWithdrawDepositParameter]
	and a
	jr z, .got_nicknames_end
	ld bc, sBoxMonNicknamesEnd
.got_nicknames_end
	call CopyDataUntil
	jp CloseSRAM

ComputeNPCTrademonStats:
	ld a, MON_LEVEL
	call GetPartyParam
	ld [wCurPartyLevel], a
	ld a, MON_SPECIES
	call GetPartyParam
	ld [wCurSpecies], a
	call GetBaseData
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld d, h
	ld e, l
	push de
	ld a, MON_STAT_EXP - 1
	call GetPartyParamLocation
	ld b, 1
	call CalcPkmnStats
	pop de
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret

UpdatePkmnStats_AllowReviving:
	scf
	jr UpdatePkmnStats_EntryPoint

UpdatePkmnStats:
; Recalculates the stats of wCurPartyMon and also updates current HP accordingly
	and a
UpdatePkmnStats_EntryPoint:
	push af
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurSpecies], a
	ld [wd265], a
	call GetBaseData
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld a, MON_MAXHP + 1
	call GetPartyParamLocation
	ld a, [hld]
	ld c, a
	ld b, [hl]
	push bc
	ld d, h
	ld e, l
	ld a, MON_STAT_EXP - 1
	call GetPartyParamLocation
	ld b, TRUE
	call CalcPkmnStats
	ld a, MON_HP
	call GetPartyParamLocation
	pop bc
	pop af
	jr c, .allow_revival
; Don't change the current HP if we're fainted
	ld a, [hli]
	or [hl]
	ret z
	dec hl
.allow_revival
; Update current HP
	inc hl
	inc hl
	inc hl
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hld]
	sbc b
	ld b, a
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	cp $80
	ld [hl], a
	jr nc, .set_hp_to_one ; Don't pull a Pomeg glitch (HP underflowed)

	; If our HP is 0 at this point, it was a result of a decrease. Set to 1 in that case
	inc hl
	or [hl]
	ret nz
	dec hl
.set_hp_to_one
	xor a
	ld [hli], a
	ld [hl], 1
	ret

CalcPkmnStats:
; Calculates all 6 Stats of a Pkmn
; b: Take into account stat EXP if TRUE
; 'c' counts from 1-6 and points with 'wBaseStats' to the base value
; hl is the path to the Stat EXP
; de is a pointer where the 6 stats are placed (should point at HP in the beginning)

	ld c, 0
.loop
	inc c
	call CalcPkmnStatC
	ldh a, [hMultiplicand + 1]
	ld [de], a
	inc de
	ldh a, [hMultiplicand + 2]
	ld [de], a
	inc de
	ld a, c
	cp STAT_SDEF
	jr nz, .loop
	ret

CalcPkmnStatC:
; 'c' is 1-6 and points to the BaseStat
; 1: HP
; 2: Attack
; 3: Defense
; 4: Speed
; 5: SpAtk
; 6: SpDef
	push hl
	push de
	push bc
	ld d, b
	push hl
	ld hl, wBaseStats - 1 ; has to be decreased, because 'c' begins with 1
	ld b, 0
	add hl, bc
	ld e, [hl]
	pop hl
	push hl
	ld a, c
	cp STAT_SDEF
	jr nz, .not_spdef
	dec hl
	dec hl

.not_spdef
	sla c
	ld a, d
	and a
	jr z, .no_stat_exp
	add hl, bc
	push de
	ld a, [hld]
	ld e, a
	ld d, [hl]
	call GetSquareRoot
	pop de

.no_stat_exp
	srl c
	pop hl
	push bc
	ld bc, MON_DVS - MON_HP_EXP + 1
	add hl, bc
	pop bc
	ld a, c
	dec a
	jr z, .HP
	dec a
	jr z, .Attack
	dec a
	jr z, .Defense
	dec a
	jr z, .Speed
	; fallthrough

.Special
	inc hl
.Defense
	ld a, [hl]
	and $f
	jr .GotDV

.Speed
	inc hl
.Attack
	ld a, [hl]
	swap a
	and $f
	jr .GotDV

.HP
; DV_HP = (DV_ATK & 1) << 3 + (DV_DEF & 1) << 2 + (DV_SPD & 1) << 1 + (DV_SPC & 1)
	push bc
	ld a, [hl]
	and $10
	rrca
	ld b, a
	ld a, [hli]
	rra
	jr nc, .no_add_4
	set 2, b
.no_add_4
	bit 4, [hl]
	jr z, .no_add_2
	set 1, b
.no_add_2
	ld a, [hl]
	and 1
	add a, b
	pop bc
	; instead of adding the level later on, we add 50 to DVs for HP. Same effect, less overflow checking.
	add a, 50
	; fallthrough

.GotDV
	ld d, 0
	add a, e
	ld e, a
	adc d
	sub e
	ld d, a
	sla e
	rl d
	srl b
	srl b
	ld a, b
	add e
	jr nc, .no_overflow_after_adding_stat_exp
	inc d

.no_overflow_after_adding_stat_exp
	ldh [hMultiplicand + 2], a
	ld a, d
	ldh [hMultiplicand + 1], a
	xor a
	ldh [hMultiplicand], a
	ld a, [wCurPartyLevel]
	ldh [hMultiplier], a
	predef Multiply
	ld a, 100
	ldh [hDivisor], a
	ld b, 4
	predef Divide
	ld a, c
	cp STAT_HP
	ld a, 5
	jr nz, .not_hp
	add a, a
.not_hp
	ld b, a
	ldh a, [hQuotient + 2]
	add b
	ldh [hMultiplicand + 2], a
	jr nc, .no_overflow_after_adding_level_zero_stat
	ldh a, [hQuotient + 1]
	inc a
	ldh [hMultiplicand + 1], a

.no_overflow_after_adding_level_zero_stat
	ldh a, [hQuotient + 1]
	cp HIGH(1000)
	jr c, .stat_value_okay
	jr nz, .max_stat
	ldh a, [hQuotient + 2]
	cp LOW(1000)
	jr c, .stat_value_okay

.max_stat
	ld a, HIGH(999)
	ldh [hMultiplicand + 1], a
	ld a, LOW(999)
	ldh [hMultiplicand + 2], a

.stat_value_okay
	pop bc
	pop de
	pop hl
	ret

GivePoke::
	push de
	push bc
	xor a ; PARTYMON
	ld [wMonType], a
	call TryAddMonToParty
	jr nc, .failed
	ld hl, wPartyMonNicknames
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	call SkipNames
	ld d, h
	ld e, l
	pop bc
	ld a, b
	ld b, 0
	push bc
	push de
	push af
	ld a, [wCurItem]
	and a
	jr z, .done
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [wCurItem]
	ld [hl], a
	jr .done

.failed
	ld a, [wCurPartySpecies]
	ld [wTempEnemyMonSpecies], a
	callba LoadEnemyMon
	ld a, [wCurItem]
	ld [wEnemyMonItem], a
	call SentPkmnIntoBox
	jp nc, .FailedToGiveMon
	ld a, BOXMON
	ld [wMonType], a
	xor a
	ld [wCurPartyMon], a
	ld de, wMonOrItemNameBuffer
	pop bc
	ld a, b
	ld b, 1
	push bc
	push de
	push af
	ld a, [wCurItem]
	and a
	jr z, .done
	ld a, [wCurItem]
	ld [sBoxMon1Item], a

.done
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ld [wTempEnemyMonSpecies], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	pop af
	and a
	jr z, .wildmon
	pop de
	pop bc
	pop hl
	push bc
	push hl
	ld a, [wScriptBank]
	call GetFarHalfword
	ld bc, PKMN_NAME_LENGTH
	ld a, [wScriptBank]
	call FarCopyBytes
	pop hl
	inc hl
	inc hl
	ld a, [wScriptBank]
	call GetFarHalfword
	pop bc
	ld a, b
	and a
	push de
	push bc
	jr nz, .send_to_box

	push hl
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	call SkipNames
	ld d, h
	ld e, l
	pop hl
	call WriteNonstandardGiftMonOT
	ld a, [wScriptBank]
	call GetFarByte
	ld b, a
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	call WriteNonPlayerRandomID
	callba SetGiftPartyMonCaughtData
	jr .skip_nickname

.send_to_box
	sbk BANK(sBoxMonOT)
	ld de, sBoxMonOT
	call WriteNonstandardGiftMonOT
	ld a, [wScriptBank]
	call GetFarByte
	ld b, a
	ld hl, sBoxMon1ID
	call WriteNonPlayerRandomID
	scls
	callba SetGiftBoxMonCaughtData
	jr .skip_nickname

.wildmon
	pop de
	pop bc
	push bc
	push de
	ld a, b
	and a
	jr z, .party
	callba SetBoxMonCaughtData
	jr .set_caught_data

.party
	callba SetCaughtData
.set_caught_data
	ld a, BANK(GiveNicknameText)
	ld hl, GiveNicknameText
	call FarPrintText
	call YesNoBox
	pop de
	call nc, InitNickname

.skip_nickname
	pop bc
	pop de
	ld a, b
	and a
	ret z
	ld hl, TextJump_WasSentToBillsPC
	call PrintText
	sbk BANK(sBoxMonNicknames)
	ld hl, wMonOrItemNameBuffer
	ld de, sBoxMonNicknames
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	scls
	ld b, 1
	ret

.FailedToGiveMon
	pop bc
	pop de
	ld b, 2
	ret

WriteNonPlayerRandomID:
	push bc
	ld a, [wPlayerID]
	ld b, a
	ld a, [wPlayerID + 1]
	ld c, a
.loop
	call Random
	cp b
	jr z, .loop
	ldh a, [hRandomAdd]
	cp c
	jr z, .loop
	ld [hli], a
	ldh a, [hRandomSub]
	ld [hl], a
	pop bc
	ret

WriteNonstandardGiftMonOT:
	ld a, [wScriptBank]
	call GetFarByteAndIncrement
	ld [de], a
	inc de
	cp "@"
	jr nz, WriteNonstandardGiftMonOT
	ld a, "F"
	ld [de], a
	inc de
	ret

TextJump_WasSentToBillsPC:
	; was sent to BILL's PC.
	text_jump Text_WasSentToBillsPC

InitNickname:
	push de
	call LoadStandardMenuHeader
	call DisableSpriteUpdates
	pop de
	push de
	ld b, 0
	callba NamingScreen
	pop hl
	ld de, wStringBuffer1
	call InitName
	jp ExitAllMenus

AddMovesObtained:
	ld c, NUM_MOVES
.loop
	ld a, [de]
	and a
	ret z
	inc de
	push bc
	dec a
	ld c, a
	ld b, SET_FLAG
	ld hl, wMovesObtained
	predef FlagAction
	pop bc
	dec c
	jr nz, .loop
	ret

GetSquareRoot::
; calculate ceil(sqrt(de)), and return in b, properly adjusting for exact values & $FF limit
	ld h, d
	ld l, e
	ld de, 1
	ld b, d
.loop
	inc b
	ld a, b
	inc a
	ret z
	dec e
	dec de
	add hl, de
	ret nc
	ld a, h
	or l
	jr nz, .loop
	ret
