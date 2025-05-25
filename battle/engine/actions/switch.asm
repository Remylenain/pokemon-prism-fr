ForceEnemySwitch:
	call ResetEnemyBattleVars
	ld a, [wEnemySwitchMonIndex]
	dec a
	ld b, a
	call LoadEnemyPkmnToSwitchTo
	call ClearEnemyMonBox
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call Function_SetEnemyPkmnAndSendOutAnimation
	call BreakAttraction
	jp ResetBattleParticipants

EnemySwitch_SetMode:
	call ResetEnemyBattleVars
	call CheckWhetherSwitchmonIsPredetermined
	call nc, FindPkmnInOTPartyToSwitchIntoBattle
	; 'b' contains the PartyNr of the Pkmn the AI will switch to
	call LoadEnemyPkmnToSwitchTo
	ld a, 1
	ld [wEnemyIsSwitching], a
	call ClearEnemyMonBox
	call Function_BattleTextEnemySentOut
	jp Function_SetEnemyPkmnAndSendOutAnimation

EnemySwitch:
	call CheckWhetherToAskSwitch
	jr nc, EnemySwitch_SetMode
	; Shift Mode
	call ResetEnemyBattleVars
	call CheckWhetherSwitchmonIsPredetermined
	call nc, FindPkmnInOTPartyToSwitchIntoBattle
	; 'b' contains the PartyNr of the Pkmn the AI will switch to
	call LoadEnemyPkmnToSwitchTo
	call OfferSwitch
	push af
	call ClearEnemyMonBox
	call Function_BattleTextEnemySentOut
	call Function_SetEnemyPkmnAndSendOutAnimation
	pop af
	jp c, EnemyAbilityOnMonEntrance
	; If we're here, then we're switching too
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
	ld [wBattlePlayerAction], a
	inc a
	ld [wEnemyIsSwitching], a
	call LoadTileMapToTempTileMap
	; fallthrough

PlayerSwitch:
	ld a, 1
	ld [wPlayerIsSwitching], a
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	call LoadStandardMenuHeader
	call LinkBattleSendReceiveAction
	call CloseWindow

.not_linked
	call ParseEnemyAction
	ld a, [wLinkMode]
	and a
	jr nz, .linked

.switch
	call CheckPlayerNaturalCure
	call BattleMonEntrance
	call AbilityOnMonEntrance
	and a
	ret

.linked
	ld a, [wBattleAction]
	cp BATTLEACTION_STRUGGLE
	jr z, .switch
	cp BATTLEACTION_SKIPTURN
	jr z, .switch
	cp BATTLEACTION_SWITCH1
	jr c, .switch
	cp BATTLEACTION_FORFEIT
	jp z, WildFled_EnemyFled_LinkBattleCanceled
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player_1
	call BattleMonEntrance
	callba AI_Switch
	and a
	ret

.player_1
	callba AI_Switch
	call BattleMonEntrance
	and a
	ret

CheckWhetherSwitchmonIsPredetermined:
; Returns index of enemy switchmon in b (0-5).
; Sets carry if:
;     Link opponent is switching
;     Enemy is switching to Pokemon 1-5
;     Enemy is switching to Pokemon 0 at the very start of battle
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ld a, [wBattleAction]
	sub BATTLEACTION_SWITCH1
	ld b, a
	scf
	ret

.not_linked
	ld a, [wEnemySwitchMonIndex]
	and a
	jr z, .first_mon_to_be_sent_out

	dec a
	ld b, a
	scf
	ret

.first_mon_to_be_sent_out
	ld b, a
	ld a, [wBattleHasJustStarted]
	and a
	ret z
	scf
	ret

FindPkmnInOTPartyToSwitchIntoBattle:
	callba GetSwitchScores
	ld a, [wEnemySwitchMonParam]
	ld b, a
	ret

LoadEnemyPkmnToSwitchTo:
	; 'b' contains the PartyNr of the Pkmn the AI will switch to
	ld a, [wEnemyAbility]
	cp ABILITY_NATURAL_CURE
	jr nz, .no_heal
	push bc
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	call GetPartyLocation
	ld [hl], 0
	pop bc
.no_heal
	ld a, b
	ld [wCurPartyMon], a
	ld hl, wOTPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld a, [wCurPartyMon]
	inc a
	ld hl, wOTPartyCount
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wTempEnemyMonSpecies], a
	ld [wCurPartySpecies], a
	call LoadEnemyMon

	ld a, [wCurPartySpecies]
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wEnemyHPAtTimeOfPlayerSwitch], a
	ld a, [hl]
	ld [wEnemyHPAtTimeOfPlayerSwitch + 1], a
	ret

CheckWhetherToAskSwitch:
; Determine whether to bring up the shift dialogue.
;  c: Yes (SHIFT)
; nc: No  (SET)

	; Don't ask if this is the very start of the battle.
	ld a, [wBattleHasJustStarted]
	dec a
	ret z

	; Don't ask if you only have one party member.
	ld a, [wPartyCount]
	dec a
	ret z

	; Don't ask in a link battle.
	ld a, [wLinkMode]
	and a
	ret nz

	; Don't ask if you're on SET mode.
	ld a, [wOptions]
	bit BATTLE_SHIFT, a
	ret nz

	; Don't ask if your Pokemon fainted as well.
	ld a, [wCurPartyMon]
	push af
	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	callba CheckIfOnlyAliveMonIsCurPartyMon
	pop bc
	ld a, b
	ld [wCurPartyMon], a
	ccf
	ret

OfferSwitch:
	ld a, [wCurPartyMon]
	push af
	callba Battle_GetTrainerName
	ld hl, BattleText_EnemyIsAboutToUseWillPlayerChangePkmn
	call StdBattleTextBox
	lb bc, 1, 7
	call PlaceYesNoBox
	ld a, [wMenuCursorY]
	dec a
	jr nz, .said_no
	call SetUpBattlePartyMenu_NoLoop
	call PickSwitchMonInBattle
	jr c, .canceled_switch
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	pop af
	ld [wCurPartyMon], a
	xor a
	ld [wCurEnemyMove], a
	ld [wCurPlayerMove], a
	and a
	ret

.canceled_switch
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar

.said_no
	pop af
	ld [wCurPartyMon], a
	scf
	ret
