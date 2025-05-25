BattleCommand_BatonPass:
	ldh a, [hBattleTurn]
	and a
	jr nz, .Enemy

; Need something to switch to
	call CheckAnyOtherAlivePartyMons
	jr z, .failed

	call UpdateBattleMonInParty
	call AnimateCurrentMove

	ld c, 50
	call DelayFrames

; Transition into switchmon menu
	call LoadStandardMenuHeader
	callba SetUpBattlePartyMenu_NoLoop

	callba ForcePickSwitchMonInBattle

; Return to battle scene
	call ClearPalettes
	callba LoadBattleFontsHPBar
	call CloseWindow
	call ClearSprites
	hlcoord 0, 0
	lb bc, 4, 11
	call ClearBox
	ld b, SCGB_BATTLE_COLORS
	predef GetSGBLayout
	call SetPalettes
	call BatonPass_LinkPlayerSwitch

	callba PassedBattleMonEntrance

	call ResetBatonPassStatus
	jp ApplyBattleMonRingEffect

.Enemy
; Wildmons don't have anything to switch to
	ld a, [wBattleMode]
	dec a ; WILDMON
	call nz, CheckAnyOtherAliveEnemyMons
.failed
	jp z, FailedGeneric

	call UpdateEnemyMonInParty
	call AnimateCurrentMove
	call BatonPass_LinkEnemySwitch

; Passed enemy PartyMon entrance
	xor a
	ld [wEnemySwitchMonIndex], a
	callba EnemySwitch_SetMode
	callba ResetBattleParticipants
	ld a, 1
	ld [wTypeMatchup], a
	callba ApplyStatLevelMultiplierOnAllStats

	callba SpikesDamage
	callba EnemyAbilityOnMonEntrance

	call ResetBatonPassStatus
	jp ApplyEnemyMonRingEffect

BatonPass_LinkPlayerSwitch:
	ld a, [wLinkMode]
	and a
	ret z

	ld a, 1
	ld [wBattlePlayerAction], a

	call LoadStandardMenuHeader
	callba _LinkBattleSendReceiveAction
	call CloseWindow

	xor a
	ld [wBattlePlayerAction], a
	ret

BatonPass_LinkEnemySwitch:
	ld a, [wLinkMode]
	and a
	ret z

	call LoadStandardMenuHeader
	callba _LinkBattleSendReceiveAction

	ld a, [wOTPartyCount]
	add BATTLEACTION_SWITCH1
	ld b, a
	ld a, [wBattleAction]
	cp BATTLEACTION_SWITCH1
	jr c, .baton_pass
	cp b
	jr c, .close_window

.baton_pass
	ld a, [wCurOTMon]
	add BATTLEACTION_SWITCH1
	ld [wBattleAction], a
.close_window
	jp CloseWindow

ResetBatonPassStatus:
; Reset status changes that aren't passed by Baton Pass.

	; Nightmare isn't passed.
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	jr nz, .ok

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
.ok

	; Disable isn't passed.
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	xor a
	ld [wEnemyDisableCount], a
	ld [wEnemyDisabledMove], a
	jr .done_disable
.player
	ld [wPlayerDisableCount], a
	ld [wDisabledMove], a
.done_disable

	; Attraction isn't passed.
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_IN_LOVE, [hl]

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_TRANSFORMED, [hl]
	res SUBSTATUS_ENCORED, [hl]

	; New mon hasn't used a move yet.
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ld [wPlayerWrapCount], a
	ld [wEnemyWrapCount], a
	ret
