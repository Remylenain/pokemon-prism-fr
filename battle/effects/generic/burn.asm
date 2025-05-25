BattleCommand_BurnTarget:
	call CheckSubstituteOpp
	ret nz
	; fallthrough
BattleCommand_BurnTarget_IgnoreSub:
	xor a
	ld [wNumHits], a
	ld a, [wTypeModifier]
	add a, a
	ret z
	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wBattleMonType1
.ok
	ld a, [hli]
	cp FIRE ; Don't burn a Fire-type
	ret z
	ld a, [hl]
	cp FIRE ; Don't burn a Fire-type
	ret z
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_BURN
	ret z
	call GetTargetAbility
	cp ABILITY_WATER_VEIL
	ret z
	call LeafGuardActive
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld a, [hl]
	and a
	ret nz
	set BRN, [hl]
	call UpdateOpponentInParty
	callba ApplyBrnEffectOnAttack
	ld de, ANIM_BRN
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasBurnedText
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .print
	ld hl, AbilityBurnedText
.print
	call StdBattleTextBox
	jpba UseHeldStatusHealingItem
