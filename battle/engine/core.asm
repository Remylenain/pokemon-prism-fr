BattleCore::

HandleEnemyMonFaint:
	call FaintEnemyPokemon
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	call z, FaintYourPokemon
	xor a
	ld [wWhichMonFaintedFirst], a
	call UpdateBattleStateAndExperienceAfterEnemyFaint
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	jp z, LostBattle

	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	call nz, UpdatePlayerHUD

	ld a, [wBattleMode]
	dec a
	jr nz, .trainer
	callba CheckPickup
	call .UpdateBGMapWithSecondDelay
	ld a, 1
	ld [wBattleEnded], a
	ret

.trainer
	call .UpdateBGMapWithSecondDelay
	call CheckEnemyTrainerDefeated
	jp z, WinTrainerBattle

	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .player_mon_not_fainted

	call AskUseNextPokemon
	jr nc, .dont_flee

	ld a, 1
	ld [wBattleEnded], a
	ret

.dont_flee
	call ForcePlayerMonChoice

	ld a, 1
	ld [wBattlePlayerAction], a
	call HandleEnemySwitch
	jp z, WildFled_EnemyFled_LinkBattleCanceled
	jr DoubleSwitch

.player_mon_not_fainted
	ld a, 1
	ld [wBattlePlayerAction], a
	call HandleEnemySwitch
	jp z, WildFled_EnemyFled_LinkBattleCanceled
	xor a
	ld [wBattlePlayerAction], a
	ret

.UpdateBGMapWithSecondDelay:
	ld a, 1
	ldh [hBGMapMode], a
	ld c, 60
	jp DelayFrames

DoubleSwitch:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player_1
	call ClearSprites
	hlcoord 0, 1
	lb bc, 3, 11
	call ClearBox
	call PlayerPartyMonEntrance
	ld a, 1
	call EnemyPartyMonEntrance
	jr .done

.player_1
	ld a, [wCurPartyMon]
	push af
	ld a, 1
	call EnemyPartyMonEntrance
	call ClearSprites
	call LoadTileMapToTempTileMap
	pop af
	ld [wCurPartyMon], a
	call PlayerPartyMonEntrance

.done
	xor a
	ld [wBattlePlayerAction], a
	ret

FaintYourPokemon:
	call StopDangerSound
	call WaitSFX
	ld a, $f0
	ld [wCryTracks], a
	ld a, [wBattleMonSpecies]
	call PlayFaintingCry
	call WaitSFX
	ld de, SFX_KINESIS
	call PlaySFX
	call PlayerMonFaintedAnimation
	ld de, SFX_FAINT
	call PlaySFX
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	ld hl, BattleText_PkmnFainted
	jp StdBattleTextBox

FaintEnemyPokemon:
	call WaitSFX
	ld a, $f
	ld [wCryTracks], a
	ld a, [wEnemyMonSpecies]
	call PlayFaintingCry
	call WaitSFX
	ld de, SFX_KINESIS
	call PlaySFX
	call EnemyMonFaintedAnimation
	ld de, SFX_FAINT
	call PlaySFX
	hlcoord 0, 1
	lb bc, 3, 11
	call ClearBox
	call GetEnemyFaintedText
	jp StdBattleTextBox

HandleEnemySwitch:
	ld hl, wEnemyHPPal
	ld e, HP_BAR_LENGTH_PX
	call UpdateHPPal
	call ApplyTilemapInVBlank
	callba EnemySwitch_TrainerHud
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	call LinkBattleSendReceiveAction
	ld a, [wBattleAction]
	cp BATTLEACTION_FORFEIT
	ret z

	call Call_LoadTempTileMapToTileMap

.not_linked
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	ld a, 1
	jr nz, .okay
	and a
	ret

.okay
	xor a
EnemyPartyMonEntrance:
	push af
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	pop af
	and a
	jr nz, .set
	call EnemySwitch
	jr .done_switch

.set
	call EnemySwitch_SetMode
.done_switch
	call ResetBattleParticipants
	call SetEnemyTurn
	call SpikesDamage
	call EnemyAbilityOnMonEntrance
	xor a
	ld [wEnemyMoveStruct + MOVE_ANIM], a
	ld [wBattlePlayerAction], a
	inc a
	ret

PlayVictoryMusic:
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, MUSIC_WILD_VICTORY
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer_victory
	push de
	call IsAnyMonHoldingExpShare
	pop de
	jr nz, .play_music
	ld a, [wBattleParticipantsNotFainted]
	and a
	jr z, .lost
	jr .play_music

.trainer_victory
	ld de, MUSIC_GYM_VICTORY
	call IsJohtoGymLeader
	jr c, .play_music
	ld de, MUSIC_TRAINER_VICTORY

.play_music
	call PlayMusic

.lost
	pop de
	ret

HandlePlayerMonFaint:
	call FaintYourPokemon
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	call z, FaintEnemyPokemon
	ld a, 1
	ld [wWhichMonFaintedFirst], a
	call PlayerMonFaintHappinessMod
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	jp z, LostBattle
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .notfainted
	call UpdateBattleStateAndExperienceAfterEnemyFaint
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer
	ld a, 1
	ld [wBattleEnded], a
	ret

.trainer
	call CheckEnemyTrainerDefeated
	jp z, WinTrainerBattle

.notfainted
	call AskUseNextPokemon
	jr nc, .switch
	ld a, 1
	ld [wBattleEnded], a
	ret

.switch
	call ForcePlayerMonChoice
	ld a, c
	and a
	ret nz
	ld a, 1
	ld [wBattlePlayerAction], a
	call HandleEnemySwitch
	jp z, WildFled_EnemyFled_LinkBattleCanceled
	jp DoubleSwitch

PlayerMonFaintHappinessMod:
	ld a, [wCurBattleMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, RESET_FLAG
	predef FlagAction
	ld hl, wEnemySubStatus3
	res SUBSTATUS_IN_LOOP, [hl]
	xor a
	ld [wLowHealthAlarm], a
	ld hl, wPlayerDamageTaken
	ld [hli], a
	ld [hl], a
	ld [wBattleMonStatus], a
	call UpdateBattleMonInParty
	ld c, HAPPINESS_FAINTED
	; If TheirLevel > (YourLevel + 30), use a different parameter
	ld a, [wBattleMonLevel]
	add 30
	ld b, a
	ld a, [wEnemyMonLevel]
	cp b
	jr c, .got_param
	ld c, HAPPINESS_BEATENBYSTRONGFOE

.got_param
	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	callba ChangeHappiness
	ld a, [wBattleResult]
	and %11000000
	inc a
	ld [wBattleResult], a
	ld a, [wWhichMonFaintedFirst]
	and a
	ret

AskUseNextPokemon:
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
; We don't need to be here if we're in a Trainer battle,
; as that decision is made for us.
	ld a, [wBattleMode]
	and a
	dec a
	ret nz

	ld hl, BattleText_UseNextMon
	call StdBattleTextBox
	lb bc, 1, 7
	call PlaceYesNoBox
	ret nc ;selected "yes"
	ld hl, wPartyMon1Speed
	ld de, wEnemyMonSpeed
	jp TryToRunAwayFromBattle

ForcePlayerMonChoice:
	call EmptyBattleTextBox
	call LoadStandardMenuHeader
	call SetUpBattlePartyMenu_NoLoop
	call ForcePickPartyMonInBattle
	ld a, [wLinkMode]
	and a
	jr z, .skip_link
	ld a, 1
	ld [wBattlePlayerAction], a
	call LinkBattleSendReceiveAction

.skip_link
	xor a
	ld [wBattlePlayerAction], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .send_out_pokemon

	call ClearSprites
	call ClearBGPalettes
	call _LoadHPBar
	call ExitMenu
	call LoadTileMapToTempTileMap
	call ApplyTilemapInVBlank
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	xor a
	ld c, a
	ret

.send_out_pokemon
	call ClearSprites
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	call CloseWindow
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	call PlayerAbilityOnMonEntrance
	ld a, 1
	and a
	ld c, a
	ret

PlayerPartyMonEntrance:
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	jp PlayerAbilityOnMonEntrance

SlideBattlePicOut:
	ldh [hMapObjectIndexBuffer], a
	ld c, a
.loop
	push bc
	push hl
	ld b, 7
.loop2
	push hl
	call .DoFrame
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .loop2
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

.DoFrame
	ldh a, [hMapObjectIndexBuffer]
	ld c, a
	cp 8
	jr nz, .back
.forward
	ld a, [hli]
	ld [hld], a
	dec hl
	dec c
	jr nz, .forward
	ret

.back
	ld a, [hld]
	ld [hli], a
	inc hl
	dec c
	jr nz, .back
	ret

ResetEnemyBattleVars:
; and draw empty TextBox
	xor a
	ld [wLastEnemyCounterMove], a
	ld [wLastPlayerCounterMove], a
	ld [wLastEnemyMove], a
	ld [wCurEnemyMove], a
	dec a
	ld [wEnemyItemState], a
	xor a
	ld [wPlayerWrapCount], a
	hlcoord 18, 0
	ld a, 8
	call SlideBattlePicOut
	call EmptyBattleTextBox
	jp LoadStandardMenuHeader

ResetBattleParticipants:
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
AddBattleParticipant:
	ld a, [wCurBattleMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, SET_FLAG
	push bc
	predef FlagAction
	pop bc
	ld hl, wBattleParticipantsIncludingFainted
	predef_jump FlagAction

ClearEnemyMonBox:
	xor a
	ldh [hBGMapMode], a
	call ExitMenu
	call ClearSprites
	hlcoord 0, 1
	lb bc, 3, 11
	call ClearBox
	call ApplyTilemapInVBlank
	jp FinishBattleAnim

Function_SetEnemyPkmnAndSendOutAnimation:
	ld a, [wTempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld a, OTPARTYMON
	ld [wMonType], a
	predef CopyPkmnToTempMon
	call GetMonFrontpic

	xor a
	ld [wNumHits], a
	ld [wBattleAnimParam], a
	call SetEnemyTurn
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

	call BattleCheckEnemyShininess
	jr nc, .not_shiny
	ld a, 1 ; shiny anim
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim
.not_shiny
	ld bc, wTempMonSpecies
	callba CheckFaintedFrzSlp
	jr c, .skip_cry
	hlcoord 12, 0
	lb de, 0, ANIM_MON_SLOW
	predef AnimateFrontpic
	jr .skip_cry

.cry_no_anim
	ld a, $f
	ld [wCryTracks], a
	ld a, [wTempEnemyMonSpecies]
	call PlayStereoCry

.skip_cry
	call UpdateEnemyHUD
	ld a, 1
	ldh [hBGMapMode], a
	ret

NewEnemyMonStatus:
	xor a
	ld [wLastEnemyCounterMove], a
	ld [wLastPlayerCounterMove], a
	ld [wLastEnemyMove], a
	ld hl, wEnemySubStatus1
rept 4
	ld [hli], a
endr
	ld [hl], a
	ld [wEnemyDisableCount], a
	ld [wEnemyFuryCutterCount], a
	ld [wEnemyProtectCount], a
	ld [wEnemyDisabledMove], a
	ld [wEnemyMinimized], a
	ld [wPlayerWrapCount], a
	ld [wEnemyWrapCount], a
	ld [wEnemyTurnsTaken], a
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_CANT_RUN, [hl]
	ret

ResetEnemyStatLevels:
	ld a, BASE_STAT_LEVEL
	ld b, NUM_LEVEL_STATS - 1
	ld hl, wEnemyStatLevels
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	jp ApplyEnemyMonRingEffect

InitBattleMon:
	ld a, 1
	ld [wPlayerJustSentMonOut], a
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld de, wBattleMonSpecies
	ld bc, MON_ID
	rst CopyBytes
	ld bc, MON_DVS - MON_ID
	add hl, bc
	ld de, wBattleMonDVs
	ld bc, MON_PKRUS - MON_DVS
	rst CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, wBattleMonLevel
	ld bc, PARTYMON_STRUCT_LENGTH - MON_LEVEL
	rst CopyBytes
	ld a, [wBattleMonSpecies]
	ld [wTempBattleMonSpecies], a
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseType1]
	ld [wBattleMonType1], a
	ld a, [wBaseType2]
	ld [wBattleMonType2], a
	ld hl, wPartyMonNicknames
	ld a, [wCurBattleMon]
	call SkipNames
	ld de, wBattleMonNick
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld hl, wBattleMonAttack
	ld de, wPlayerStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes
	call CalcPlayerAbility
	call ApplyStatusEffectOnPlayerStats
	jpba BadgeStatBoosts

ResetPlayerStatLevels:
	ld a, BASE_STAT_LEVEL
	ld b, NUM_LEVEL_STATS - 1
	ld hl, wPlayerStatLevels
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	jp ApplyBattleMonRingEffect

ApplyHeldRingEffect::
	push hl
	ld hl, .StatRings
	ld e, 2
	call IsInArray
	jr nc, .nope
	inc hl
	ld a, [hl]
	swap a
	and $f
	ld c, a
	ld a, [hl]
	and $f
	ld e, a
	pop hl
	push hl
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp 13
	jr nc, .skip
	inc [hl]
.skip
	pop hl
	ld d, 0
	add hl, de
	ld a, [hl]
	cp 2
	ret c
	dec [hl]
	ret

.nope
	pop hl
	ret

.StatRings
MACRO statring
	db \1
	dn \2, \3
ENDM
	statring GRASS_RING,     SP_DEFENSE, DEFENSE
	statring FIRE_RING,      DEFENSE,    SP_DEFENSE
	statring WATER_RING,     ATTACK,     EVASION
	statring THUNDER_RING,   SP_ATTACK,  ACCURACY
	statring MOON_RING,      EVASION,    SPEED
	statring SHINY_RING,     ACCURACY,   EVASION
	statring DAWN_RING,      SPEED,      ACCURACY
	db $ff

InitEnemyMon:
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMon1Species
	call GetPartyLocation
	ld de, wEnemyMonSpecies
	ld bc, MON_ID
	rst CopyBytes
	ld bc, MON_DVS - MON_ID
	add hl, bc
	ld de, wEnemyMonDVs
	ld bc, MON_PKRUS - MON_DVS
	rst CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, wEnemyMonLevel
	ld bc, PARTYMON_STRUCT_LENGTH - MON_LEVEL
	rst CopyBytes
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wOTPartyMonNicknames
	ld a, [wCurPartyMon]
	call SkipNames
	ld de, wEnemyMonNick
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld hl, wEnemyMonAttack
	ld de, wEnemyStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes
	call CalcEnemyAbility
	call ApplyStatusEffectOnEnemyStats
	ld hl, wBaseType1
	ld de, wEnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, wBaseStats
	ld de, wEnemyMonBaseStats
	ld b, 5
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld a, [wCurPartyMon]
	ld [wCurOTMon], a
	ret

SwitchPlayerMon:
	call ClearSprites
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ret

SendOutPlayerMon_PModeBattleStart:
	call SendOutPlayerMon_InitVars
	jr SendOutPlayerMon_continue

SendOutPlayerMon:
	hlcoord 1, 5
	lb bc, 7, 8
	call ClearBox
	call ApplyTilemapInVBlank
	xor a
	ldh [hBGMapMode], a
	call GetMonBackpic
	call SendOutPlayerMon_InitVars
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim
SendOutPlayerMon_continue:
	call BattleCheckPlayerShininess
	jr nc, .notShiny
	ld a, 1
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim
.notShiny
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld b, h
	ld c, l
	callba CheckFaintedFrzSlp
	jr c, .statused
	ld a, $f0
	ld [wCryTracks], a
	ld a, [wCurPartySpecies]
	call PlayStereoCry

.statused
	call UpdatePlayerHUD
	ld a, 1
	ldh [hBGMapMode], a
	ret

SendOutPlayerMon_InitVars:
	xor a
	ldh [hGraphicStartTile], a
	ld [wd0d2], a
	ld [wCurMoveNum], a
	ld [wTypeModifier], a
	ld [wPlayerMoveStruct + MOVE_ANIM], a
	ld [wLastEnemyCounterMove], a
	ld [wLastPlayerCounterMove], a
	ld [wLastPlayerMove], a
	call CheckAmuletCoin
	call FinishBattleAnim
	xor a
	ld [wEnemyWrapCount], a
	call SetPlayerTurn
	xor a
	ld [wNumHits], a
	ld [wBattleAnimParam], a
	ret

NewBattleMonStatus:
	xor a
	ld [wLastEnemyCounterMove], a
	ld [wLastPlayerCounterMove], a
	ld [wLastPlayerMove], a
	ld hl, wPlayerSubStatus1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wPlayerUsedMoves
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wPlayerDisableCount], a
	ld [wPlayerFuryCutterCount], a
	ld [wPlayerProtectCount], a
	ld [wDisabledMove], a
	ld [wPlayerMinimized], a
	ld [wEnemyWrapCount], a
	ld [wPlayerWrapCount], a
	ld [wPlayerTurnsTaken], a
	ld hl, wEnemySubStatus5
	res SUBSTATUS_CANT_RUN, [hl]
	ret

PursuitSwitch:
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld b, a
	call GetMoveEffect
	ld a, b
	cp EFFECT_PURSUIT
	jr nz, .done

	ld a, [wCurBattleMon]
	push af

	ld hl, DoPlayerTurn
	ldh a, [hBattleTurn]
	and a
	jr z, .do_turn
	ld a, [wLastPlayerMon]
	ld [wCurBattleMon], a
	ld hl, DoEnemyTurn
.do_turn
	ld a, BANK(DoPlayerTurn)
	call FarCall_hl

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld a, $ff
	ld [hl], a

	pop af
	ld [wCurBattleMon], a

	ldh a, [hBattleTurn]
	and a
	jr z, .check_enemy_fainted

	ld a, [wLastPlayerMon]
	call UpdateBattleMon
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .done

	ld a, $f0
	ld [wCryTracks], a
	ld a, [wBattleMonSpecies]
	call PlayStereoCry
	ld a, [wLastPlayerMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, RESET_FLAG
	predef FlagAction
	call PlayerMonFaintedAnimation
	ld hl, BattleText_PkmnFainted
	jr .done_fainted

.check_enemy_fainted
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .done

	ld de, SFX_KINESIS
	call PlayWaitSFX
	ld de, SFX_FAINT
	call PlayWaitSFX
	call EnemyMonFaintedAnimation
	call GetEnemyFaintedText

.done_fainted
	call StdBattleTextBox
	scf
	ret

.done
	and a
	ret

RecallPlayerMon:
	ldh a, [hBattleTurn]
	push af
	xor a
	ldh [hBattleTurn], a
	ld [wNumHits], a
	ld de, ANIM_RETURN_MON
	call Call_PlayBattleAnim
	pop af
	ldh [hBattleTurn], a
	ret

UseOpponentItem:
	call RefreshBattleHuds
	call GetOpponentItem
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callba ConsumeHeldItem
	ld a, b
	ld hl, PowerHerbText
	cp HELD_POWER_HERB
	jr z, .okay
	ld a, [wStringBuffer1]
	ld hl, .Vowels
	call IsInSingularArray
	ld hl, RecoveredUsingText
	jr nc, .okay
	ld hl, RecoveredUsingText2
.okay
	call StdBattleTextBox
	call GetTargetAbility
	cp ABILITY_UNBURDEN
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	set SUBSTATUS_UNBURDEN, [hl]
	ret

.Vowels
	db "AEIOUaeiou"
	db -1

ItemRecoveryAnim:
	push hl
	push de
	push bc
	call EmptyBattleTextBox
	ld a, RECOVER
	ld [wFXAnimIDLo], a
	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [wFXAnimIDHi], a
	predef PlayBattleAnim
	call SwitchTurn
	pop bc
	pop de
	pop hl
	ret

UseHeldStatusHealingItem:
	call GetOpponentItem
	ld hl, .Statuses
.loop
	ld a, [hli]
	cp $ff
	ret z
	inc hl
	cp b
	jr nz, .loop
	dec hl
	ld b, [hl]
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and b
	ret z
	xor a
	ld [hl], a
	push bc
	call UpdateOpponentInParty
	pop bc
	ld a, BATTLE_VARS_SEMISTATUS_OPP
	call GetBattleVarAddr
	res SEMISTATUS_TOXIC, [hl]
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
	ld a, b
	cp ALL_STATUS
	jr nz, .skip_confuse
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]

.skip_confuse
	ld hl, CalcEnemyStats
	ldh a, [hBattleTurn]
	and a
	jr z, .got_pointer
	ld hl, CalcPlayerStats

.got_pointer
	call SwitchTurn
	ld a, BANK(CalcEnemyStats)
	call FarCall_hl
	call SwitchTurn
	call ItemRecoveryAnim
	call UseOpponentItem
	ld a, 1
	and a
	ret

.Statuses
	db HELD_HEAL_POISON, 1 << PSN
	db HELD_HEAL_FREEZE, 1 << FRZ
	db HELD_HEAL_BURN, 1 << BRN
	db HELD_HEAL_SLEEP, SLP
	db HELD_HEAL_PARALYZE, 1 << PAR
	db HELD_HEAL_STATUS, ALL_STATUS
	db $ff

UseConfusionHealingItem:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	ret z
	call GetOpponentItem
	ld a, b
	cp HELD_HEAL_CONFUSION
	jr z, .heal_status
	cp HELD_HEAL_STATUS
	ret nz

.heal_status
	ld a, [hl]
	ld [wd265], a
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]
	call GetItemName
	call ItemRecoveryAnim
	ld hl, BattleText_ItemHealedConfusion
	call StdBattleTextBox
	ldh a, [hBattleTurn]
	and a
	jr nz, .do_partymon
	call GetOTPartymonItem
	xor a
	ld [bc], a
	ld a, [wBattleMode]
	dec a
	ret z
	ld [hl], 0
	ret

.do_partymon
	call GetPartymonItem
	xor a
	ld [bc], a
	ld [hl], a
	ret

UpdateBattleHUDs:
	push hl
	push de
	push bc
	call DrawPlayerHUD
	ld hl, wPlayerHPPal
	call SetHPPal
	call CheckDanger
	call DrawEnemyHUD
	ld hl, wEnemyHPPal
	call SetHPPal
	pop bc
	pop de
	pop hl
	ret

UpdatePlayerHUD::
	push hl
	push de
	push bc
	call DrawPlayerHUD
	call UpdatePlayerHPPal
	call CheckDanger
	pop bc
	pop de
	pop hl
	ret

DrawPlayerHUD:
	xor a
	ldh [hBGMapMode], a

	; Clear the area
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	hlcoord 9, 11
	ld [hl], $74
	hlcoord 19, 10
	ld [hl], $73
	hlcoord 19, 11
	ld [hl], $5e

	hlcoord 18, 9
	ld [hl], $73 ; vertical bar
	call PrintPlayerHUD

	; HP bar
	hlcoord 9, 9
	ld b, 1
	xor a ; PARTYMON
	ld [wMonType], a
	predef DrawPlayerHP

	; Exp bar
	push de
	ld a, [wCurBattleMon]
	ld hl, wPartyMon1Exp + 2
	call GetPartyLocation
	ld d, h
	ld e, l

	hlcoord 10, 11
	ld a, [wTempMonLevel]
	ld b, a
	call FillInExpBar
	pop de
	ret

PrintPlayerHUD:
	ld de, wBattleMonNick
	hlcoord 10, 7
	call PlaceString

	push bc

	ld a, [wCurBattleMon]
	ld hl, wPartyMon1DVs
	call GetPartyLocation
	ld de, wTempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, wBattleMonLevel
	ld de, wTempMonLevel
	ld bc, wBattleMonStatsEnd - wBattleMonLevel
	rst CopyBytes
	ld a, [wCurBattleMon]
	ld hl, wPartyMon1Species
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData

	pop hl
	dec hl

	ld a, BREEDMON
	ld [wMonType], a
	callba GetGender
	ld a, " "
	jr c, .got_gender_char
	ld a, "♂"
	jr nz, .got_gender_char
	ld a, "♀"

.got_gender_char
	hlcoord 14, 8
	ld [hl], a
; TODO: place status icon instead of text
	hlcoord 10, 8
	ld de, wBattleMonStatus
	predef PlaceNonFaintStatus
	hlcoord 16, 8
	ld a, [wBattleMonLevel]
	ld [wTempMonLevel], a
	jp PrintLevel

_UpdateBattleHuds::
	call UpdatePlayerHUD
	; fallthrough

UpdateEnemyHUD::
	push hl
	push de
	push bc
	call DrawEnemyHUD
	call UpdateEnemyHPPal
	pop bc
	pop de
	pop hl
	ret

DrawEnemyHUD:
	xor a
	ldh [hBGMapMode], a

	hlcoord 0, 1
	lb bc, 3, 11
	call ClearBox

	ld a, [wBattleMode]
	dec a
	jr nz, .skip
	ld a, [wTempEnemyMonSpecies]
	dec a
	call CheckCaughtMon
	jr z, .skip
	hlcoord 0, 3
	ld [hl], $5f

.skip
	ld a, [wTempEnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData
	ld de, wEnemyMonNick
	hlcoord 1, 1
	call PlaceString
	ld h, b
	ld l, c
	dec hl

	ld hl, wEnemyMonDVs
	ld de, wTempMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .ok
	ld hl, wEnemyBackupDVs
.ok
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld a, BREEDMON
	ld [wMonType], a
	callba GetGender
	ld a, " "
	jr c, .got_gender
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"

.got_gender
	hlcoord 5, 3
	ld [hl], a

; TODO: place status icon instead of text
	hlcoord 7, 3
	ld de, wEnemyMonStatus
	predef PlaceNonFaintStatus
	hlcoord 1, 3
	ld a, [wEnemyMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel

	ld hl, wEnemyMonHP
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hld]
	ldh [hMultiplicand + 2], a
	or [hl]
	jr nz, .not_fainted

	ld c, a
	ld e, a
	ld d, HP_BAR_LENGTH
	jr .draw_bar

.not_fainted
	xor a
	ldh [hMultiplicand], a
	ld a, HP_BAR_LENGTH_PX
	ldh [hMultiplier], a
	predef Multiply
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ldh [hDivisor], a
	ld a, [hl]
	ldh [hDivisor + 1], a
	predef DivideLong
	ldh a, [hLongQuotient + 3]
	ld e, a
	ld a, HP_BAR_LENGTH
	ld d, a
	ld c, a

.draw_bar
	xor a
	ld [wWhichHPBar], a
	hlcoord 0, 2
	ld b, 0
	jp DrawBattleHPBar

UpdatePlayerHPPal:
	ld hl, wPlayerHPPal
	jr UpdateHPPal

UpdateEnemyHPPal:
	ld hl, wEnemyHPPal
	; fallthrough

UpdateHPPal:
	ld b, [hl]
	call SetHPPal
	ld a, [hl]
	cp b
	ret z
	jp FinishBattleAnim

BattleMonEntrance:
	call WithdrawPkmnText

	ld c, 50
	call DelayFrames

	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]

	call SetEnemyTurn
	call PursuitSwitch
	call nc, RecallPlayerMon

	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	call PlayerAbilityOnMonEntrance
	ld a, 2
	ld [wMenuCursorY], a
	ret

PassedBattleMonEntrance:
	ld c, 50
	call DelayFrames

	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	xor a
	ld [wd265], a
	call ApplyStatLevelMultiplierOnAllStats
	call SendOutPlayerMon
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	jp PlayerAbilityOnMonEntrance

MoveInfoBox:
	xor a
	ldh [hBGMapMode], a

	hlcoord 0, 8
	lb bc, 3, 9
	call TextBox

	ld a, [wPlayerDisableCount]
	and a
	jr z, .not_disabled

	swap a
	and $f
	ld b, a
	ld a, [wMenuCursorY]
	cp b
	jr nz, .not_disabled

	hlcoord 1, 10
	ld de, BattleMoveDisabledText
	jp PlaceText

.not_disabled
	ld hl, wMenuCursorY
	dec [hl]
	call SetPlayerTurn
	ld hl, wBattleMonMoves
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurPlayerMove], a

	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	ld a, WILDMON
	ld [wMonType], a
	callba GetMaxPPOfMove

	ld hl, wMenuCursorY
	ld c, [hl]
	inc [hl]
	ld b, 0
	ld hl, wBattleMonPP
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wStringBuffer1], a
	call .PrintPP

	hlcoord 1, 9
	ld de, BattleMoveTypeText
	call PlaceText

	hlcoord 7, 11
	ld [hl], "/"

	callba UpdateMoveData
	ld a, [wPlayerMoveStruct + MOVE_ANIM]
	ld b, a
	hlcoord 2, 10
	predef_jump PrintMoveType

.PrintPP
	hlcoord 5, 11
	push hl
	ld de, wStringBuffer1
	lb bc, 1, 2
	call PrintNum
	pop hl
	inc hl
	inc hl
	ld [hl], "/"
	inc hl
	ld de, wNamedObjectIndexBuffer
	lb bc, 1, 2
	jp PrintNum

CheckPlayerHasUsableMoves:
	ld a, STRUGGLE
	ld [wCurPlayerMove], a
	ld a, [wPlayerDisableCount]
	and a
	ld hl, wBattleMonPP
	jr nz, .disabled

	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and $3f
	ret nz
	jr .force_struggle

.disabled
	swap a
	and $f
	ld b, a
	ld d, 5
	xor a
.loop
	dec d
	jr z, .done
	ld c, [hl]
	inc hl
	dec b
	jr z, .loop
	or c
	jr .loop

.done
	and a
	ret nz

.force_struggle
	ld hl, BattleText_PkmnHasNoMovesLeft
	call StdBattleTextBox
	ld c, 60
	call DelayFrames
	xor a
	ret

CheckSleepingTreeMon:
; Return carry if species is in the list
; for the current time of day

; Don't do anything if this isn't a tree encounter
	ld a, [wBattleType]
	cp BATTLETYPE_TREE
	jr nz, .NotSleeping

; Get list for the time of day
	ld hl, .Morn
	ld a, [wTimeOfDay]
	cp DAY
	jr c, .Check
	ld hl, .Day
	jr z, .Check
	ld hl, .Nite

.Check
	ld a, [wTempEnemyMonSpecies]
	call IsInSingularArray
; If it's a match, the opponent is asleep
	ret c

.NotSleeping
	and a
	ret

.Nite
	db CATERPIE
	db METAPOD
	db BUTTERFREE
	db EXEGGCUTE
	db SLOWPOKE
	db TAILLOW
	db -1 ; end

.Day
;	db VENONAT
	db SPINARAK
	db SLOWPOKE
	db -1 ; end

.Morn
;	db VENONAT
	db SPINARAK
	db SLOWPOKE
	db ARIADOS
	db -1 ; end

BattleWinSlideInEnemyTrainerFrontpic:
	xor a
	ld [wTempEnemyMonSpecies], a
	call FinishBattleAnim
	ld a, [wOtherTrainerClass]
	ld [wTrainerClass], a
	ld de, vBGTiles
	predef GetTrainerPic
	hlcoord 19, 0
	ld c, 0

.outer_loop
	inc c
	ld a, c
	cp 7
	ret z
	xor a
	ldh [hBGMapMode], a
	ldh [hBGMapHalf], a
	ld d, a
	push bc
	push hl

.inner_loop
	call .CopyColumn
	inc hl
	ld a, 7
	add d
	ld d, a
	dec c
	jr nz, .inner_loop

	ld a, 1
	ldh [hBGMapMode], a
	ld c, 3
	call DelayFrames
	pop hl
	pop bc
	dec hl
	jr .outer_loop

.CopyColumn
	push hl
	push de
	push bc
	ld e, 7

.loop
	ld [hl], d
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc d
	dec e
	jr nz, .loop

	pop bc
	pop de
	pop hl
	ret

Call_PlayBattleAnim_OnlyIfVisible:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret nz
	; fallthrough

Call_PlayBattleAnim:
	ld a, e
	ld [wFXAnimIDLo], a
	ld a, d
	ld [wFXAnimIDHi], a
	or e
	ret z
	call ApplyTilemapInVBlank
	predef_jump PlayBattleAnim

FinishBattleAnim:
	push hl
	push de
	push bc
	push af
	ld b, SCGB_BATTLE_COLORS
	predef GetSGBLayout
	call SetPalettes
	call DelayFrame
	jp PopOffRegsAndReturn

UpdateBattleStateAndExperienceAfterEnemyFaint:
	call UpdateBattleMonInParty
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1HP
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a

.wild
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_IN_LOOP, [hl]
	xor a
	ld hl, wEnemyDamageTaken
	ld [hli], a
	ld [hl], a
	call NewEnemyMonStatus
	call BreakAttraction
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer

.wild2
	call StopDangerSound
	ld a, 1
	ld [wBattleLowHealthAlarm], a

.trainer
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .player_mon_did_not_faint
	ld a, [wWhichMonFaintedFirst]
	and a
	call z, PlayerMonFaintHappinessMod
.player_mon_did_not_faint
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	ret z
	ld a, [wBattleMode]
	dec a
	call z, PlayVictoryMusic
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	ld a, [wBattleResult]
	and $c0
	ld [wBattleResult], a

CatchPokemon_GiveExperience:
; Don't give experience if linked or in the Battle Tower.
	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wInBattleTowerBattle]
	and 5
	ret nz

	CheckEngine ENGINE_HYPER_SHARE_ENABLED
	jp nz, GiveExperiencePoints

	call IsAnyMonHoldingExpShare
	ld a, [wBattleParticipantsNotFainted]
	push af
	or d
	ld [wBattleParticipantsNotFainted], a
	call GiveExperiencePoints
	pop af
	ld [wBattleParticipantsNotFainted], a
	ret

GetMonBackpic:
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	ld hl, BattleAnimCmd_RaiseSub
	jr nz, GetBackpic_DoAnim ; substitute
	; fallthrough

DropPlayerSub:
	ld a, [wPlayerMinimized]
	and a
	ld hl, BattleAnimCmd_MinimizeOpp
	jr nz, GetBackpic_DoAnim
	ld a, [wCurPartySpecies]
	push af
	ld a, [wBattleMonSpecies]
	ld [wCurPartySpecies], a
	ld de, vBGTiles tile $31
	predef GetBackpic
	pop af
	ld [wCurPartySpecies], a
	ret

GetBackpic_DoAnim:
	ldh a, [hBattleTurn]
	push af
	xor a
	ldh [hBattleTurn], a
	ld a, BANK(BattleAnimCommands)
	call FarCall_hl
	pop af
	ldh [hBattleTurn], a
	ret

GetMonFrontpic:
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	ld hl, BattleAnimCmd_RaiseSub
	jr nz, GetFrontpic_DoAnim

DropEnemySub:
	ld a, [wEnemyMinimized]
	and a
	ld hl, BattleAnimCmd_MinimizeOpp
	jr nz, GetFrontpic_DoAnim

	ld a, [wCurPartySpecies]
	push af
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData
	ld de, vBGTiles
	predef GetAnimatedFrontpic
	pop af
	ld [wCurPartySpecies], a
	ret

GetFrontpic_DoAnim:
	ldh a, [hBattleTurn]
	push af
	call SetEnemyTurn
	ld a, BANK(BattleAnimCommands)
	call FarCall_hl
	pop af
	ldh [hBattleTurn], a
	ret

BattleIntro:
	call LoadTrainerOrWildMonPic
	xor a
	ld [wTempBattleMonSpecies], a
	ld [wd0d2], a
	ldh [hMapAnims], a
	callba DoBattleStartFunctions
	call InitEnemy
	call BackUpvBGAttrs
	ld b, SCGB_BATTLE_GRAYSCALE
	predef GetSGBLayout
	ld hl, rLCDC
	res 6, [hl]
	call InitBattleDisplay
	call BattleStartMessage
	ld hl, rLCDC
	set 6, [hl]
	xor a
	ldh [hBGMapMode], a
	call EmptyBattleTextBox
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	hlcoord 0, 1
	lb bc, 3, 11
	call ClearBox
	call ClearSprites
	ld a, [wBattleMode]
	cp WILD_BATTLE
	call z, UpdateEnemyHUD
	ld a, 1
	ldh [hBGMapMode], a
	ret

LoadTrainerOrWildMonPic:
	ld a, [wOtherTrainerClass]
	and a
	jr nz, .Trainer
	ld a, [wTempWildMonSpecies]
	ld [wCurPartySpecies], a

.Trainer
	ld [wTempEnemyMonSpecies], a
	ret

BackUpvBGAttrs:
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)
	ld hl, wDecompressScratch
	ld bc, $40 tiles ; vWindowAttrs - vBGAttrs
	ld a, 2
	call ByteFill
	ldh a, [rVBK]
	push af
	vbk BANK(vBGAttrs)
	ld de, wDecompressScratch
	hlbgcoord 0, 0 ; vBGAttrs
	lb bc, BANK(BackUpvBGAttrs), $40
	call Request2bpp
	pop af
	ldh [rVBK], a
	pop af
	ldh [rSVBK], a
	ret

InitEnemy:
	ld a, [wOtherTrainerClass]
	and a
	jr z, InitEnemyWildmon
	; fallthrough

InitEnemyTrainer:
	ld [wTrainerClass], a
	xor a
	ld [wTempEnemyMonSpecies], a
	callba GetTrainerAttributes
	callba ReadTrainerParty

	ld a, [wTrainerClass]
	cp RIVAL1
	jr nz, .ok
	xor a
	ld [wOTPartyMon1Item], a
.ok

	ld de, vBGTiles
	predef GetTrainerPic
	xor a
	ldh [hGraphicStartTile], a
	dec a
	ld [wEnemyItemState], a
	hlcoord 12, 0
	lb bc, 7, 7
	predef PlaceGraphic
	ld a, -1
	ld [wCurOTMon], a
	ld a, TRAINER_BATTLE
	ld [wBattleMode], a

	call IsJohtoGymLeader
	ret nc
	xor a
	ld [wCurPartyMon], a
	ld a, [wPartyCount]
	ld b, a
.partyloop
	push bc
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	or [hl]
	jr z, .skipfaintedmon
	ld c, HAPPINESS_GYMBATTLE
	callba ChangeHappiness
.skipfaintedmon
	pop bc
	dec b
	ret z
	ld hl, wCurPartyMon
	inc [hl]
	jr .partyloop

InitEnemyWildmon:
	ld a, WILD_BATTLE
	ld [wBattleMode], a
	call LoadEnemyMon
	ld hl, wEnemyMonMoves
	ld de, wWildMonMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	ld hl, wEnemyMonPP
	ld de, wWildMonPP
	ld bc, NUM_MOVES
	rst CopyBytes
	ld a, [wCurPartySpecies]
	ld de, vBGTiles
	predef GetAnimatedFrontpic
	xor a
	ld [wTrainerClass], a
	ldh [hGraphicStartTile], a
	hlcoord 12, 0
	lb bc, 7, 7
	predef_jump PlaceGraphic

ShowLinkBattleParticipantsAfterEnd:
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	call GetPartyLocation
	ld a, [wEnemyMonStatus]
	ld [hl], a
	call ClearTileMap
	jpba _ShowLinkBattleParticipants

InitBattleDisplay:
	call .InitBackPic
	hlcoord 0, 12
	lb bc, 4, 18
	call TextBox
	hlcoord 1, 5
	lb bc, 3, 7
	call ClearBox
	call LoadStandardFont
	callba LoadBattleFontsHPBar
	call .BlankBGMap
	xor a
	ldh [hMapAnims], a
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	ldh [rWY], a
	call ApplyTilemapInVBlank
	xor a
	ldh [hBGMapMode], a
	callba BattleIntroSlidingPics
	ld a, 1
	ldh [hBGMapMode], a
	ld a, $31
	ldh [hGraphicStartTile], a
	hlcoord 2, 6
	lb bc, 6, 6
	predef PlaceGraphic
	xor a
	ldh [hWY], a
	ldh [rWY], a
	call ApplyTilemapInVBlank
	call HideSprites
	ld b, SCGB_BATTLE_COLORS
	predef GetSGBLayout
	call SetPalettes
	ld a, $90
	ldh [hWY], a
	xor a
	ldh [hSCX], a
	ret

.BlankBGMap
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)

	ld hl, wDecompressScratch
	ld bc, wBackupAttrMap - wDecompressScratch
	ld a, " "
	call ByteFill

	ld de, wDecompressScratch
	hlbgcoord 0, 0
	lb bc, BANK(InitBattleDisplay), $40
	call Request2bpp

	pop af
	ldh [rSVBK], a
	ret

.InitBackPic
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .playerBackpic

	ld hl, wPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH - 1
	ld bc, wPartySpecies
	jr .handle_loop
.loop
	add hl, de
	inc bc
.handle_loop
	ld a, [hli]
	or [hl]
	jr z, .loop
	ld de, wPartyMon1DVs - (wPartyMon1HP + 1)
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld hl, wBattleMonDVs
	ld [hli], a
	ld [hl], d
	ld a, [wCurPartySpecies]
	push af
	ld a, [bc]
	ld [wCurPartySpecies], a
	ld [wTempBattleMonSpecies], a
	ld de, vBGTiles tile $31
	predef GetBackpic
	pop af
	ld [wCurPartySpecies], a
	jr .continue

.playerBackpic
	callba GetPlayerBackpic
.continue
	ld hl, vObjTiles
	ld de, vBGTiles tile $31
	lb bc, BANK(InitBattleDisplay), 7 * 7
	call Get2bpp
	call .LoadTrainerBackpicAsOAM
	ld a, $31
	ldh [hGraphicStartTile], a
	hlcoord 2, 6
	lb bc, 6, 6
	predef_jump PlaceGraphic

.LoadTrainerBackpicAsOAM
	ld hl, wSprites
	xor a
	ldh [hMapObjectIndexBuffer], a
	ld b, 6
	ld e, 21 * 8
.outer_loop
	ld c, 3
	ld d, 8 * 8
.inner_loop
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ldh a, [hMapObjectIndexBuffer]
	ld [hli], a
	inc a
	ldh [hMapObjectIndexBuffer], a
	ld a, 1
	ld [hli], a
	ld a, d
	add a, 8
	ld d, a
	dec c
	jr nz, .inner_loop
	ldh a, [hMapObjectIndexBuffer]
	add a, 3
	ldh [hMapObjectIndexBuffer], a
	ld a, e
	add a, 8
	ld e, a
	dec b
	jr nz, .outer_loop
	ret
