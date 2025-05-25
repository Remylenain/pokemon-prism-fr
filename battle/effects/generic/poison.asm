BattleCommand_PoisonTarget:
	call CheckSubstituteOpp
	ret nz
BattleCommand_PoisonTarget_IgnoreSub:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [wTypeModifier]
	add a, a
	ret z
	call CanBePoisoned
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz

	call PoisonOpponent
	ld de, ANIM_PSN
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasPoisonedText
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .print
	ld hl, AbilityPoisonText
.print
	call StdBattleTextBox
	jp BattleCommand_Synchronize

BattleCommand_Poison:
	ld hl, DoesntAffectText
	ld a, [wTypeModifier]
	add a, a
	jr z, .failed

	call CanBePoisoned
	jr z, .failed

	call CheckSubstituteOpp
	jr nz, .failed
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	call .check_toxic
	jr z, .toxic

	call .apply_poison
	ld hl, WasPoisonedText
	jr .finished

.toxic
	set SEMISTATUS_TOXIC, [hl]
	xor a
	ld [de], a
	call .apply_poison

	ld hl, BadlyPoisonedText

.finished
	call StdBattleTextBox
	jp BattleCommand_Synchronize

.failed
	push hl
	call AnimateFailedMove
	pop hl
	jp StdBattleTextBox

.apply_poison
	call AnimateCurrentMove
	call PoisonOpponent
	jp RefreshBattleHuds

.check_toxic
	ld a, BATTLE_VARS_SEMISTATUS_OPP
	call GetBattleVarAddr
	ldh a, [hBattleTurn]
	and a
	ld de, wEnemyToxicCount
	jr z, .ok
	ld de, wPlayerToxicCount
.ok
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_TOXIC
	ret

CanBePoisoned:
; Returns z if protected. Use message in hl if applicable
; Doesn't check for Substitute (so PoisonTarget_IgnoreSub can use this)

	; Already statused
	ld hl, AlreadyPoisonedText
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	cp 1 << PSN
	ret z

	; Type immunities
	ld hl, DoesntAffectText
	ldh a, [hBattleTurn]
	and a
	ld de, wEnemyMonType1
	jr z, .got_type
	ld de, wBattleMonType1
.got_type
	ld a, [de]
	cp POISON
	ret z
	cp STEEL
	ret z

	inc de
	ld a, [de]
	cp POISON
	ret z
	cp STEEL
	ret z

	; Item
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_POISON
	jr nz, .not_protected_by_item
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, ProtectedByText
	xor a
	ret

.not_protected_by_item
	; Abilities
	ld hl, DidntAffect1Text
	call GetTargetAbility
	cp ABILITY_IMMUNITY
	ret z
	call LeafGuardActive
	ret z
	; Another status (besides poison). A bit redundant to get the opponent status twice,
	; but preserves appropriate message priorities
	; hl = DidntAffect1Text here
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	; this way, we return z if a is nonzero
	cp 1 ; set carry if a=0
	sbc a ; a=0, i.e. z, unless carry, then a=-1, i.e. nz
	ret

PoisonOpponent:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PSN, [hl]
	jp UpdateOpponentInParty
