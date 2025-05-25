BattleCommand_Burn:
; burn
	ld hl, DoesntAffectText
	ld a, [wTypeModifier]
	and $7f
	jr z, .failed

	call CheckIfTargetIsFireType
	jr z, .failed

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	ld b, a
	ld hl, AlreadyBurnedText
	and 1 << BRN
	jr nz, .failed

	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_BURN
	jr nz, .do_burn
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, ProtectedByText
.failed
	push hl
	callba AnimateFailedMove
	pop hl
	jp StdBattleTextBox

.do_burn
	ld hl, DidntAffect1Text
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	jr nz, .failed
	call CheckSubstituteOpp
	jr nz, .failed
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	call GetTargetAbility
	cp ABILITY_WATER_VEIL
	jr z, .failed
	callba LeafGuardActive
	jr z, .failed

	callba AnimateCurrentMove
	call BurnOpponent
	callba ApplyBrnEffectOnAttack
	call RefreshBattleHuds
	ld hl, WasBurnedText
	call StdBattleTextBox
	jpba BattleCommand_Synchronize

CheckIfTargetIsFireType:
	ld de, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wBattleMonType1
.ok
	ld a, [de]
	inc de
	cp FIRE
	ret z
	ld a, [de]
	cp FIRE
	ret

BurnOpponent:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set BRN, [hl]
	jp UpdateOpponentInParty
