BattleCommand_SleepTarget:
	call CheckSubstituteOpp
	ld hl, ButItFailedText
	jp nz, FailSleepTarget
	; fallthrough
BattleCommand_SleepTarget_IgnoreSub:
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_SLEEP
	jr nz, .not_protected_by_item

	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, ProtectedByText
	jp FailSleepTarget

.not_protected_by_item
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld d, h
	ld e, l
	ld a, [de]
	and SLP
	ld hl, AlreadyAsleepText
	jr nz, FailSleepTarget

	ld a, [wAttackMissed]
	and a
	jp nz, PrintDidntAffectWithMoveAnimDelay

	ld hl, DidntAffect1Text
	ld a, [de]
	and a
	jr nz, FailSleepTarget

	call .GetTargetAbility
	ld hl, AbilityCantSleepText
	cp ABILITY_VITAL_SPIRIT
	jr z, FailSleepTarget
	cp ABILITY_INSOMNIA
	jr z, FailSleepTarget
	call LeafGuardActive
	jr z, FailSleepTarget

	push de
	call .GetUserAbility
	call AnimateCurrentMove
	ld de, ANIM_SLP
	call PlayOpponentBattleAnim
	ld b, 3

.random_loop
	call BattleRandom
	and b
	jr z, .random_loop ;1-3
	pop de
	inc a ;2-4
	ld [de], a
	call UpdateOpponentInParty
	call RefreshBattleHuds

	ld hl, FellAsleepText
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .print
	ld hl, AbilitySleepText
.print
	call StdBattleTextBox

	callba UseHeldStatusHealingItem

	jp z, OpponentCantMove
	ret

.GetUserAbility
	; used for Effect Spore
	call GetUserAbility_IgnoreMoldBreaker
	jr .GetAbility

.GetTargetAbility
	call GetTargetAbility
	and a
	ret z
.GetAbility
	ld b, a
	ld a, [wd265]
	push af
	ld a, b
	ld [wd265], a
	push bc
	push de
	call GetAbilityName
	pop de
	pop bc
	pop af
	ld [wd265], a
	ld a, b
	ret

FailSleepTarget:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	push hl
	call AnimateFailedMove
	pop hl
	jp StdBattleTextBox
