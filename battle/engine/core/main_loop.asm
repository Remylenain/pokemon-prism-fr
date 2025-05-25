DoBattle:
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
	ld [wBattlePlayerAction], a
	ld [wBattleEnded], a
	ld [wSavedDamage], a
	ld [wSavedDamage + 1], a
	inc a
	ld [wBattleHasJustStarted], a
	ld hl, wOTPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
	ld d, BATTLEACTION_SWITCH1 - 1
.loop
	inc d
	ld a, [hli]
	or [hl]
	jr nz, .alive
	add hl, bc
	jr .loop

.alive
	ld a, d
	ld [wBattleAction], a
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .player_2

.not_linked
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	call EnemySwitch

.wild
	ld c, 40
	call DelayFrames

.player_2
	call LoadTileMapToTempTileMap
	call CheckPlayerPartyForFitPkmn
	ld a, d
	and a
	jp z, LostBattle
	call Call_LoadTempTileMapToTileMap
	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jp z, BattleMenu
	xor a
	ld [wCurPartyMon], a
.loop2
	call CheckIfCurPartyMonIsStillAlive
	jr nz, .alive2
	ld hl, wCurPartyMon
	inc [hl]
	jr .loop2

.alive2
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	inc a
	ld hl, wPartySpecies - 1
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wTempBattleMonSpecies], a

	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .skip_slide_out
	hlcoord 1, 5
	ld a, 9
	call SlideBattlePicOut
	call LoadTileMapToTempTileMap
.skip_slide_out
	call InitBattleMon
	call ResetBattleParticipants
	call ResetPlayerStatLevels
	call SendOutPkmnText
	call NewBattleMonStatus
	call BreakAttraction
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .regular_send_out
	call SendOutPlayerMon_PModeBattleStart
	jr .continue
.regular_send_out
	call SendOutPlayerMon
.continue
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	call SetPlayerTurn
	call SpikesDamage
	ld a, [wLinkMode]
	and a
	jr z, .do_turn
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .do_turn
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	call EnemySwitch
	call SetEnemyTurn
	call SpikesDamage

.do_turn
	xor a
	ld [wPlayerIsSwitching], a
	ld [wEnemyIsSwitching], a
	ld [wBattleHasJustStarted], a
	ld [wPlayerJustGotFrozen], a
	ld [wEnemyJustGotFrozen], a
	ld [wSavedDamage], a
	ld [wSavedDamage + 1], a
	dec a
	ld [wLastBallShakes], a
	call ResetDamage

	call AbilityOnMonEntrance
	call HandleBerserkGene
	call UpdateBattleMonInParty
	callba AIChooseMove

	call CheckPlayerLockedIn
	jr c, .skip_battle_menu
.battle_menu_loop
	call BattleMenu
	ret c
	ld a, [wBattleEnded]
	and a
	ret nz
	ld a, [wForcedSwitch] ; roared/whirlwinded/teleported
	and a
	ret nz
.skip_battle_menu
	call ParsePlayerAction
	jr nz, .battle_menu_loop

	call EnemyTriesToFlee
	ret c

	ld a, [wBattleTurns]
	cp 200
	jr nc, .too_long
	inc a
	ld [wBattleTurns], a
.too_long
	call DetermineMoveOrder
	call BattleTurn

	ld a, [wForcedSwitch]
	and a
	ret nz

	ld a, [wBattleEnded]
	and a
	ret nz
	call HandleEndTurnEffects
	ld a, [wBattleEnded]
	and a
	jr z, .do_turn
	ret

BattleTurn:
	jr c, .player_first

	call .check_flee
	call SetEnemyTurn
	ld a, 1
	ld [wEnemyGoesFirst], a
	callba AI_SwitchOrTryItem
	jr c, .switch_item
	call .do_enemy_turn
	ld a, [wForcedSwitch]
	and a
	ret nz
	call .handle_faint_player_first
.switch_item
	call RefreshBattleHuds
	call .do_player_turn
	ld a, [wForcedSwitch]
	and a
	ret nz
	call .handle_faint_enemy_first
	jr .refresh_huds_clear_action

.player_first
	xor a
	ld [wEnemyGoesFirst], a
	call SetEnemyTurn
	callba AI_SwitchOrTryItem
	push af
	call .do_player_turn
	pop bc
	ld a, [wForcedSwitch]
	and a
	ret nz
	call .handle_faint_enemy_first
	push bc
	call RefreshBattleHuds
	pop af
	jr c, .refresh_huds_clear_action
	call .check_flee
	call .do_enemy_turn
	call .handle_faint_player_first
.refresh_huds_clear_action
	call RefreshBattleHuds
	xor a
	ld [wBattlePlayerAction], a
	ret

.check_flee
	call LoadTileMapToTempTileMap
	call TryEnemyFlee
	ret nc
	pop af ;discard return pointer
	jp WildFled_EnemyFled_LinkBattleCanceled

.handle_faint_player_first
	call HasPlayerFainted
	jr z, .handle_player_faint
	call HasEnemyFainted
	ret nz
.handle_enemy_faint
	pop af ;discard return pointer
	jp HandleEnemyMonFaint

.handle_faint_enemy_first
	call HasEnemyFainted
	jr z, .handle_enemy_faint
	call HasPlayerFainted
	ret nz
.handle_player_faint
	pop af ;discard return pointer
	jp HandlePlayerMonFaint

.do_player_turn
	call SetPlayerTurn
	call .end_user_destiny_bond
	callba DoPlayerTurn
	jr .after_turn

.do_enemy_turn
	call SetEnemyTurn
	call .end_user_destiny_bond
	callba DoEnemyTurn

.after_turn
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	res SUBSTATUS_PROTECT, [hl]
	res SUBSTATUS_ENDURE, [hl]
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	res SUBSTATUS_GUARDING, [hl]
	ret

.end_user_destiny_bond
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	ret
