BattleCommand_ConfuseTarget:
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_CONFUSE
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	call SafeCheckSafeguard
	ret nz
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CONFUSED, [hl]
	ret nz

	call GetTargetAbility
	cp ABILITY_OWN_TEMPO
	jr nz, BattleCommand_FinishConfusingTarget
	ret

BattleCommand_Confuse:
	call GetOpponentItem
	ld a, b
	cp HELD_PREVENT_CONFUSE
	jr nz, .no_item_protection
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	call AnimateFailedMove
	ld hl, ProtectedByText
	jr .std_battle_text_box

.no_item_protection
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CONFUSED, [hl]
	jr z, .not_already_confused
	call AnimateFailedMove
	ld hl, AlreadyConfusedText
.std_battle_text_box
	jp StdBattleTextBox

.not_already_confused
	call CheckSubstituteOpp
	jr nz, .print_did_not_affect_message
	ld a, [wAttackMissed]
	and a
	jr nz, .print_did_not_affect_message

	call GetTargetAbility
	cp ABILITY_OWN_TEMPO
	jr nz, BattleCommand_FinishConfusingTarget

.print_did_not_affect_message
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_CONFUSE_HIT
	ret z
	cp EFFECT_SWAGGER
	ret z
	jp PrintDidntAffectWithMoveAnimDelay

BattleCommand_FinishConfusingTarget:
	ld bc, wEnemyConfuseCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_confuse_count
	ld bc, wPlayerConfuseCount

.got_confuse_count
	set SUBSTATUS_CONFUSED, [hl]
	call BattleRandom
	and 3
	add a, 2
	ld [bc], a

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_SWAGGER
	jr nz, .not_swagger

	; We still want to animate the move now if it didn't
	; successfully raise a stat earlier
	ld a, [wFailedMessage]
	and a
	call nz, AnimateCurrentMove
	jr .finished_animation

.not_swagger
	cp EFFECT_CONFUSE_HIT
	call nz, AnimateCurrentMove

.finished_animation
	ld de, ANIM_CONFUSED
	call PlayOpponentBattleAnim

	ld hl, BecameConfusedText
	call StdBattleTextBox

	call GetOpponentItem
	ld a, b
	cp HELD_HEAL_STATUS
	jr z, .heal_confusion
	cp HELD_HEAL_CONFUSION
	ret nz
.heal_confusion
	jpba UseConfusionHealingItem
