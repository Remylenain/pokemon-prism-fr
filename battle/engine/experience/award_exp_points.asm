GiveExperiencePoints:
; Give experience.
	xor a
	ld [wCurPartyMon], a
	ld bc, wPartyMon1Species

.loop
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .skip_mon ; fainted

	CheckEngine ENGINE_HYPER_SHARE_ENABLED
	jr nz, .hyper_share_enabled
	push bc
	ld hl, wBattleParticipantsNotFainted
	ld a, [wCurPartyMon]
	ld c, a
	ld b, CHECK_FLAG
	predef FlagAction
	pop bc
.skip_mon
	jp z, .next_mon
.hyper_share_enabled
	call GiveStatExperience
	; Now give experience, unless the Pokémon is level 100
	ld a, MON_LEVEL
	call GetPartyParam
	cp MAX_LEVEL
	jr z, .skip_mon
	xor a
	ldh [hMultiplicand], a
	ldh [hMultiplicand + 1], a
	ld a, [wEnemyMonBaseExp]
	ldh [hMultiplicand + 2], a
	ld a, [wEnemyMonLevel]
	ldh [hMultiplier], a
	push bc
	predef Multiply
	CheckEngine ENGINE_HYPER_SHARE_ENABLED
	ld a, 7
	jr z, .no_division_by_three
	ld a, 21
.no_division_by_three
	ldh [hDivisor], a
	ld b, 4
	predef Divide
; Boost Experience for traded Pokemon
	pop bc
	ld hl, MON_ID
	add hl, bc
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .boosted
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	ld a, 0
	jr z, .no_boost
.boosted
	call BoostExp
	ld a, 1
.no_boost
; Boost experience for a Trainer Battle
	ld [wStringBuffer2 + 2], a
	ld a, [wBattleMode]
	dec a
	call nz, BoostExp
; Boost experience for Lucky Egg
	push bc
	ld a, MON_ITEM
	call GetPartyParam
	cp LUCKY_EGG
	jr nz, .no_lucky_egg
	CheckEngine ENGINE_HYPER_SHARE_ENABLED
	call z, BoostExp
.no_lucky_egg
	ldh a, [hQuotient + 2]
	ld [wStringBuffer2 + 1], a
	ldh a, [hQuotient + 1]
	ld [wStringBuffer2], a
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	ld hl, Text_PkmnGainedExpPoint
	call BattleTextBox
	ld a, [wStringBuffer2 + 1]
	ldh [hQuotient + 2], a
	ld a, [wStringBuffer2]
	ldh [hQuotient + 1], a
	pop bc
	call AnimateExpBar
	push bc
	call LoadTileMapToTempTileMap
	pop bc
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	ld d, [hl]
	ldh a, [hQuotient + 2]
	add d
	ld [hld], a
	ld d, [hl]
	ldh a, [hQuotient + 1]
	adc d
	ld [hl], a
	jr nc, .no_exp_overflow
	dec hl
	inc [hl]
	jr nz, .no_exp_overflow ;in a sane world this jump will always happen
	dec a
	ld [hli], a
	ld [hli], a
	ld [hl], a
.no_exp_overflow
	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	push bc
	ld d, MAX_LEVEL
	callba CalcExpAtLevel
	pop bc
	ld hl, MON_EXP + 2
	add hl, bc
	push bc
	ldh a, [hQuotient]
	ld b, a
	ldh a, [hQuotient + 1]
	ld c, a
	ldh a, [hQuotient + 2]
	ld d, a
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .not_max_exp
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a
.not_max_exp
	assert PARTYMON == 0
	xor a
	ld [wMonType], a
	predef CopyPkmnToTempMon
	callba CalcLevel
	pop bc
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	cp MAX_LEVEL
	jp nc, .next_mon
	cp d
	jp z, .next_mon
; <NICKNAME> grew to level ##!
	ld [wTempLevel], a
	ld a, [wCurPartyLevel]
	push af
	push bc
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld [hl], d
	callba UpdatePkmnStats
	ld a, MON_HP
	call GetPartyParamLocation
	pop bc
	ld a, [wCurBattleMon]
	ld d, a
	ld a, [wCurPartyMon]
	cp d
	jr nz, .skip_animation
	ld de, wBattleMonHP
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, wBattleMonMaxHP
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH - MON_MAXHP
	rst CopyBytes
	pop bc
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	ld [wBattleMonLevel], a
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .transformed
	ld hl, MON_ATK
	add hl, bc
	ld de, wPlayerStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes
.transformed
	xor a
	ld [wd265], a
	call ApplyStatLevelMultiplierOnAllStats
	call ApplyStatusEffectOnPlayerStats
	callba BadgeStatBoosts
	call UpdatePlayerHUD
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	ld a, 1
	ldh [hBGMapMode], a

.skip_animation
	call LevelUpHappinessMod
	ld a, [wCurBattleMon]
	ld b, a
	ld a, [wCurPartyMon]
	cp b
	jr z, .skip_animation2
	ld de, SFX_HIT_END_OF_EXP_BAR
	call PlayWaitSFX
	ld hl, BattleText_StringBuffer1GrewToLevel
	call StdBattleTextBox
	ld de, SFX_DEX_FANFARE_50_79
	call PlayWaitSFX
	call LoadTileMapToTempTileMap

.skip_animation2
	xor a ; PARTYMON
	ld [wMonType], a
	predef CopyPkmnToTempMon
	hlcoord 9, 0
	lb bc, 10, 9
	call TextBox
	hlcoord 11, 1
	ld bc, 4
	predef PrintTempMonStats
	ld c, 30
	call DelayFrames
	call WaitPressAorB_BlinkCursor
	call Call_LoadTempTileMapToTileMap
	assert PARTYMON == 0
	xor a
	ld [wMonType], a
	ld a, [wCurSpecies]
	ld [wd265], a
	ld a, [wCurPartyLevel]
	push af
	ld c, a
	ld a, [wTempLevel]
	ld b, a

.level_loop
	inc b
	ld a, b
	ld [wCurPartyLevel], a
	push bc
	predef LearnLevelMoves
	pop bc
	ld a, b
	cp c
	jr nz, .level_loop
	pop af
	ld [wCurPartyLevel], a
	ld hl, wEvolvableFlags
	ld a, [wCurPartyMon]
	ld c, a
	ld b, SET_FLAG
	predef FlagAction
	pop af
	ld [wCurPartyLevel], a

.next_mon
	ld a, [wPartyCount]
	ld b, a
	ld a, [wCurPartyMon]
	inc a
	cp b
	jp z, ResetBattleParticipants
	ld [wCurPartyMon], a
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld b, h
	ld c, l
	jp .loop

LevelUpHappinessMod::
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1CaughtLocation
	call GetPartyLocation
	ld a, [hl]
	and $7f
	ld d, a
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocation
	cp d
	ld c, HAPPINESS_GAINLEVEL
	jr nz, .ok
	ld c, HAPPINESS_GAINLEVELATHOME
.ok
	jpba ChangeHappiness
