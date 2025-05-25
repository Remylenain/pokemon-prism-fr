BattleCommand_ParalyzeTarget:
	call CheckSubstituteOpp
	ret nz
	; fallthrough
BattleCommand_ParalyzeTarget_IgnoreSub:
	xor a
	ld [wNumHits], a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [wTypeModifier]
	add a, a
	ret z
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_PARALYZE
	ret z
	call GetTargetAbility
	cp ABILITY_LIMBER
	ret z
	call LeafGuardActive
	ret z
.not_leaf_guard
	ld a, [wEffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	ld hl, wBattleMonType
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_types
	ld hl, wEnemyMonType
.got_types
	ld a, [hli]
	cp ELECTRIC
	ret z
	ld a, [hl]
	cp ELECTRIC
	ret z
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	callba ApplyPrzEffectOnSpeed
	ld de, ANIM_PAR
	call PlayOpponentBattleAnim
	call RefreshBattleHuds
	call PrintParalyze
	jp BattleCommand_Synchronize

BattleCommand_Paralyze:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	bit PAR, a
	jr nz, .paralyzed
	ld a, [wTypeModifier]
	and $7f
	jr z, .didnt_affect
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_PARALYZE
	jr nz, .no_item_protection
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	call AnimateFailedMove
	ld hl, ProtectedByText
	jp StdBattleTextBox

.no_item_protection
	call GetTargetAbility
	cp ABILITY_LIMBER
	jr z, .failed_zero
	call LeafGuardActive
	jr z, .failed_zero
.not_leaf_guard
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	jr nz, .failed_non_zero
	ld a, [wAttackMissed]
	and a
	call z, CheckSubstituteOpp
.failed_non_zero
	jp nz, PrintDidntAffectWithMoveAnimDelay
	ld hl, wBattleMonType
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_types
	ld hl, wEnemyMonType
.got_types
	ld a, [hli]
	cp ELECTRIC
	jr z, .failed_zero
	ld a, [hl]
	cp ELECTRIC
.failed_zero
	jp z, PrintDidntAffectWithMoveAnimDelay
	ld c, 30
	call DelayFrames
	call AnimateCurrentMove
	ld a, 1
	ldh [hBGMapMode], a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	callba ApplyPrzEffectOnSpeed
	call UpdateBattleHuds
	call PrintParalyze
	jp BattleCommand_Synchronize

.paralyzed
	call AnimateFailedMove
	ld hl, AlreadyParalyzedText
	jp StdBattleTextBox

.didnt_affect
	call AnimateFailedMove
	jp PrintDoesntAffect

PrintParalyze:
; 'paralyzed! maybe it can't attack!'
	ld a, [wMoveIsAnAbility]
	and a
	ld hl, ParalyzedText
	jp z, StdBattleTextBox
	ld hl, PrzAbilityText
	jp StdBattleTextBox
