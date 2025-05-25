EvolvePokemon::
	ld hl, wEvolvableFlags
	xor a
	ld [hl], a
	ld a, [wCurPartyMon]
	ld c, a
	ld b, SET_FLAG
	predef FlagAction
EvolveAfterBattle::
	xor a
	ld [wMonTriedToEvolve], a
	dec a
	ld [wCurPartyMon], a
	push hl
	push bc
	push de
	ld hl, wPartyCount

	push hl

.master_loop
	ld hl, wCurPartyMon
	inc [hl]

	pop hl

	inc hl
	ld a, [hl]
	cp $ff
	jp z, .ReturnToMap

	ld [wEvolutionPrevSpecies], a

	push hl
	ld a, [wCurPartyMon]
	ld c, a
	ld hl, wEvolvableFlags
	ld b, CHECK_FLAG
	predef FlagAction
	ld a, c
	and a
	jr z, .master_loop

	ld a, [wEvolutionPrevSpecies]
	dec a
	ld b, 0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	push hl
	xor a
	ld [wMonType], a
	predef CopyPkmnToTempMon
	pop hl

.loop
	ld a, [hli]
	and a
	jr z, .master_loop

	ld b, a

	cp EVOLVE_TRADE
	jp z, .trade

	ld a, [wLinkMode]
	and a
	jp nz, .dont_evolve_2

	ld a, b
	cp EVOLVE_ITEM
	jp z, .item
	cp EVOLVE_ITEM_MALE
	jp z, .item_m
	cp EVOLVE_ITEM_FEMALE
	jp z, .item_f

	ld a, [wForceEvolution]
	and a
	jp nz, .dont_evolve_2

	call IsMonHoldingEverstone
	jp z, .dont_evolve_2

	ld a, b
	cp EVOLVE_HOLD_NIGHT
	jr z, .held_night
	cp EVOLVE_LEVEL
	jp z, .level
	cp EVOLVE_HAPPINESS
	jr z, .happiness
	cp EVOLVE_SYLVEON ; lol
	jp z, .sylveon
	cp EVOLVE_MAPGROUP
	jp z, .mapgroup
	cp EVOLVE_MOVE
	jp z, .move

; EVOLVE_STAT
	ld a, [wTempMonLevel]
	cp [hl]
	jp c, .dont_evolve_1

	push hl
	ld hl, wTempMonAttack
	ld de, wTempMonDefense
	ld c, 2
	call StringCmp
	ld a, ATK_EQ_DEF
	jr z, .got_tyrogue_evo
	; a = carry (wTempMonDefense < wTempMonAttack) ? ATK_GT_DEF : ATK_LT_DEF
	assert ATK_GT_DEF + 1 == ATK_LT_DEF
	sbc a
	add ATK_LT_DEF
.got_tyrogue_evo
	pop hl

	inc hl
	cp [hl]
	jp nz, .dont_evolve_2

	inc hl
	jp .proceed

.happiness
	ld a, [wTempMonHappiness]
	cp 220
	jp c, .dont_evolve_2

	ld a, [hli]
	cp TR_ANYTIME
	jr z, .proceed2
	cp TR_MORNDAY
	jr z, .happiness_daylight

; TR_NITE
	ld a, [wTimeOfDay]
	cp NITE
	jp nz, .dont_evolve_3
	jr .proceed2

.happiness_daylight
	ld a, [wTimeOfDay]
	cp NITE
	jp z, .dont_evolve_3
	jr .proceed2

.held_night
	ld a, [wTimeOfDay]
	cp NITE
	jp nz, .dont_evolve_2
	ld a, [hli]
	ld b, a
	jr .held_night_item_check

.trade
	ld a, [wLinkMode]
	and a
	jr nz, .trading
	ld a, [wCurItem]
	cp TRADE_STONE
	jp nz, .dont_evolve_2
	ld a, [wForceEvolution]
	and a
	jp z, .dont_evolve_2
	jp .no_everstone_check
.trading
	call IsMonHoldingEverstone
	jp z, .dont_evolve_2
.no_everstone_check

	ld a, [hli]
	ld b, a
	inc a
	jr z, .proceed2

	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	jp z, .dont_evolve_3

.held_night_item_check
	ld a, [wTempMonItem]
	cp b
	jp nz, .dont_evolve_3

	xor a
	ld [wTempMonItem], a
.proceed2
	jp .proceed

.sylveon
	push hl
	ld de, wTempMonStatExp
	ld hl, $10000 - SYLVEON_NEEDED_STATEXP
	assert SYLVEON_NEEDED_STATEXP <= $10000
	ld a, 5
.statExpCountLoop
	ldh [hLoopCounter], a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld c, a
	inc de
	add hl, bc
	jr c, .enoughStatExp
	ldh a, [hLoopCounter]
	dec a
	jr nz, .statExpCountLoop
.noFairyTypeMove
	pop hl
	jp .dont_evolve_3
.enoughStatExp
	ld de, wTempMonMoves
	ld c, NUM_MOVES
.checkFairyTypeMoveLoop
	ld a, [de]
	and a
	jr z, .noFairyTypeMove
	push bc
	inc de
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and $3f
	cp FAIRY_T
	pop bc
	jr z, .hasFairyTypeMove
	dec c
	jr nz, .checkFairyTypeMoveLoop
	jr .noFairyTypeMove
.hasFairyTypeMove
	pop hl
	jr .proceed

.mapgroup
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	ld d, 0
	jr .mapGroupHandleLoop
.mapGroupLoop
	cp b
	jr nz, .mapGroupFail
	ld a, c
	cp [hl]
	jr nz, .mapGroupFail
	ld d, 1
.mapGroupFail
	inc hl
.mapGroupHandleLoop
	ld a, [hli]
	cp -1
	jr nz, .mapGroupLoop
	ld a, d
	and a
	jp z, .dont_evolve_3
	jr .proceed

.move
	ld a, [hli]
	ld b, a
	ld de, wTempMonMoves
	ld c, NUM_MOVES
.checkMoveLoop
	ld a, [de]
	and a
	jr z, .moveNotFound
	inc de
	cp b
	jr z, .proceed
	dec c
	jr nz, .checkMoveLoop
.moveNotFound
	jp .dont_evolve_3

.item_f
	ld a, 3
	ld [wMonType], a
	push hl
	predef GetGender
	pop hl
	jr z, .item
.notMale
	jp .dont_evolve_2
.item_m
	ld a, 3
	ld [wMonType], a
	push hl
	predef GetGender
	pop hl
	jr z, .notMale
.item
	ld a, [hli]
	ld b, a
	ld a, [wCurItem]
	cp b
	jp nz, .dont_evolve_3

	ld a, [wForceEvolution]
	and a
	jp z, .dont_evolve_3
	ld a, [wLinkMode]
	and a
	jp nz, .dont_evolve_3
	jr .proceed

.level
	ld a, [hli]
	ld b, a
	ld a, [wTempMonLevel]
	cp b
	jp c, .dont_evolve_3

.proceed
	ld a, [wTempMonLevel]
	ld [wCurPartyLevel], a
	ld a, 1
	ld [wMonTriedToEvolve], a

	push hl

	ld a, [hl]
	ld [wEvolutionNewSpecies], a
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	call CopyName1
	ld hl, Text_WhatEvolving
	call PrintText

	ld c, 50
	call DelayFrames

	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 0
	lb bc, 12, 20
	call ClearBox

	ld a, 1
	ldh [hBGMapMode], a
	call ClearSprites

	callba EvolutionAnimation

	push af
	call ClearSprites
	pop af
	jr nc, .evolved
	ld hl, Text_StoppedEvolving
	call PrintText
	call ClearTileMap
	call WaitSFX
	ld de, MUSIC_NONE
	call PlayMusic
	pop hl
	jp .master_loop

.evolved
	ld hl, Text_CongratulationsYourPokemon
	call PrintText

	pop hl

	ld a, [hl]
	ld [wCurSpecies], a
	ld [wTempMonSpecies], a
	ld [wEvolutionNewSpecies], a
	ld [wd265], a
	call GetPokemonName

	push hl
	ld hl, Text_EvolvedIntoPKMN
	call PrintTextBoxText

	ld de, MUSIC_NONE
	call PlayMusic
	ld de, SFX_CAUGHT_MON
	call PlayWaitSFX

	ld c, 40
	call DelayFrames

	call ClearTileMap
	call UpdateSpeciesNameIfNotNicknamed
	call GetBaseData

	ld hl, wTempMonExp + 2
	ld de, wTempMonMaxHP
	ld b, 1
	predef CalcPkmnStats

	ld a, [wCurPartyMon]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld e, l
	ld d, h
	ld bc, MON_MAXHP
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wTempMonMaxHP + 1
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	ld hl, wTempMonHP + 1
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a

	ld hl, wTempMonSpecies
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes

	ld a, [wCurSpecies]
	ld [wd265], a
	xor a
	ld [wMonType], a
	call LearnLevelMoves
	ld a, [wd265]
	dec a
	call SetSeenAndCaughtMon

	ld a, [wd265]

	pop de
	pop hl
	ld a, [wTempMonSpecies]
	ld [hl], a
	push hl
	ld l, e
	ld h, d
	jp .master_loop

.dont_evolve_1
	inc hl
.dont_evolve_2
	inc hl
.dont_evolve_3
	inc hl
	jp .loop

.ReturnToMap
	pop de
	pop bc
	pop hl
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, [wBattleMode]
	and a
	ret nz
	ld a, [wMonTriedToEvolve]
	and a
	jp nz, RestartMapMusic
	ret

UpdateSpeciesNameIfNotNicknamed:
	ld a, [wCurSpecies]
	push af
	ld a, [wBaseDexNo]
	ld [wd265], a
	call GetPokemonName
	pop af
	ld [wCurSpecies], a
	ld hl, wStringBuffer1
	ld de, wStringBuffer2
.loop
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	ret nz
	cp "@"
	jr nz, .loop

	ld a, [wCurPartyMon]
	ld bc, PKMN_NAME_LENGTH
	ld hl, wPartyMonNicknames
	rst AddNTimes
	push hl
	ld a, [wCurSpecies]
	ld [wd265], a
	call GetPokemonName
	ld hl, wStringBuffer1
	pop de
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret

IsMonHoldingEverstone:
	push hl
	push bc
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [hl]
	cp EVERSTONE
	pop bc
	pop hl
	ret

Text_CongratulationsYourPokemon:
	; Congratulations! Your @ @
	text_jump Evolve_CongratulationsText

Text_EvolvedIntoPKMN:
	; evolved into @ !
	text_jump Evolve_IntoText

Text_StoppedEvolving:
	; Huh? @ stopped evolving!
	text_jump Evolve_Stopped

Text_WhatEvolving:
	; What? @ is evolving!
	text_jump Evolve_Evolving

LearnLevelMoves:
	ld a, [wd265]
	ld [wCurPartySpecies], a
	dec a
	ld b, 0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

.skip_evos
	ld a, [hli]
	and a
	jr nz, .skip_evos

.find_move
	ld a, [hli]
	and a
	jr z, .done

	ld b, a
	ld a, [wCurPartyLevel]
	cp b
	ld a, [hli]
	jr nz, .find_move

	push hl
	ld d, a
	ld hl, wPartyMon1Moves
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes

	ld b, NUM_MOVES
.check_move
	ld a, [hli]
	cp d
	jr z, .has_move
	dec b
	jr nz, .check_move
	jr .learn
.has_move

	pop hl
	jr .find_move

.learn
	ld a, d
	ld [wPutativeTMHMMove], a
	ld [wd265], a
	call GetMoveName
	call CopyName1
	predef LearnMove
	pop hl
	jr .find_move

.done
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ret

FillMoves:
; Fill in moves at de for wCurPartySpecies at wCurPartyLevel

	push hl
	push de
	push bc
	ld hl, EvosAttacksPointers
	ld b, 0
	ld a, [wCurPartySpecies]
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.GoToAttacks
	ld a, [hli]
	and a
	jr nz, .GoToAttacks
	jr .GetLevel

.NextMove
	pop de
.GetMove
	inc hl
.GetLevel
	ld a, [hli]
	and a
	jp z, .done
	ld b, a
	ld a, [wCurPartyLevel]
	cp b
	jp c, .done
	ld a, [wFillMoves_IsPartyMon]
	and a
	jr z, .CheckMove
	ld a, [wd002]
	cp b
	jr nc, .GetMove

.CheckMove
	push de
	ld c, NUM_MOVES
.CheckRepeat
	ld a, [de]
	inc de
	cp [hl]
	jr z, .NextMove
	dec c
	jr nz, .CheckRepeat
	pop de
	push de
	ld c, NUM_MOVES
.CheckSlot
	ld a, [de]
	and a
	jr z, .LearnMove
	inc de
	dec c
	jr nz, .CheckSlot
	pop de
	push de
	push hl
	ld h, d
	ld l, e
	call ShiftMoves
	ld a, [wFillMoves_IsPartyMon]
	and a
	jr z, .ShiftedMove
	push de
	ld bc, wPartyMon1PP - (wPartyMon1Moves + NUM_MOVES - 1)
	add hl, bc
	ld d, h
	ld e, l
	call ShiftMoves
	pop de

.ShiftedMove
	pop hl

.LearnMove
	ld a, [hl]
	ld [de], a
	ld a, [wFillMoves_IsPartyMon]
	and a
	jr z, .NextMove
	push hl
	ld a, [hl]
	ld hl, MON_PP - MON_MOVES
	add hl, de
	push hl
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop hl
	ld [hl], a
	pop hl
	jr .NextMove

.done
	pop bc
	pop de
	pop hl
	ret

ShiftMoves:
	ld c, NUM_MOVES - 1
.loop
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .loop
	ret

GetEggSpecies::
	call GetPreEvolution
	jr c, GetPreEvolution ; note: if nidoran lines are added back in, change this to call c

	; If Illumise, 50/50 chance of Volbeat vs Illumise
	ld a, [wCurPartySpecies]
	cp ILLUMISE
	jr z, .random
	cp VOLBEAT
	ret nz
.random
	call Random
	add a, a
	; a = carry ? VOLBEAT : ILLUMISE
	assert VOLBEAT == ILLUMISE - 1
	sbc a
	add ILLUMISE
	ld [wCurPartySpecies], a
	ret

GetPreEvolution:
; Find the first mon to evolve into wCurPartySpecies.

; Return carry and the new species in wCurPartySpecies
; if a pre-evolution is found.

	ld c, 0
.loop ; For each Pokemon...
	ld hl, EvosAttacksPointers
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop2 ; For each evolution...
	ld a, [hli]
	and a
	jr z, .no_evolve ; If we jump, this Pokemon does not evolve into wCurPartySpecies.
	cp EVOLVE_SYLVEON
	jr z, .noInc
	cp EVOLVE_MAPGROUP
	jr nz, .notMapGroup
	jr .handleLoop
.findTerminatorLoop
	inc hl
.handleLoop
	ld a, [hli]
	inc a
	jr nz, .findTerminatorLoop
	jr .noInc
.notMapGroup
	cp EVOLVE_STAT
	jr nz, .not_tyrogue
	inc hl
.not_tyrogue
	inc hl
.noInc
	ld a, [wCurPartySpecies]
	cp [hl]
	jr z, .found_preevo
	inc hl
	ld a, [hl]
	and a
	jr nz, .loop2

.no_evolve
	inc c
	ld a, c
	cp NUM_POKEMON
	jr c, .loop
	and a
	ret

.found_preevo
	inc c
	ld a, c
	ld [wCurPartySpecies], a
	scf
	ret

CheckSpeciesEvolves::
	; in: a = species index
	; out: no zero: species evolves, zero: species doesn't evolve (it is FE)
	push hl
	push bc
	ld hl, EvosAttacksPointers
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	pop hl
	and a
	ret
