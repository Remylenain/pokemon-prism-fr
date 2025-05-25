EnemyHurtItself:
	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, .did_no_damage

	ld a, c
	and a
	jr nz, .mimic_sub_check

	call CheckSubstituteOpp
	jp nz, SelfInflictDamageToSubstitute

.mimic_sub_check
	ld a, [hld]
	ld b, a
	ld a, [wEnemyMonHP + 1]
	ld [wCurHPAnimOldHP], a
	sub b
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld b, a
	ld a, [wEnemyMonHP]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [wEnemyMonHP], a
	jr nc, .mimic_faint

	ld a, [wCurHPAnimOldHP + 1]
	ld [hli], a
	ld a, [wCurHPAnimOldHP]
	ld [hl], a

	xor a
	ld hl, wEnemyMonHP
	ld [hli], a
	ld [hl], a

.mimic_faint
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wCurHPAnimNewHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimNewHP], a
	hlcoord 0, 2
	xor a
	ld [wWhichHPBar], a
	predef AnimateHPBar
.did_no_damage
	jp RefreshBattleHuds

PlayerHurtItself:
	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, .did_no_damage

	ld a, c
	and a
	jr nz, .mimic_sub_check

	call CheckSubstituteOpp
	jr nz, SelfInflictDamageToSubstitute
.mimic_sub_check
	ld a, [hld]
	ld b, a
	ld a, [wBattleMonHP + 1]
	ld [wCurHPAnimOldHP], a
	sub b
	ld [wBattleMonHP + 1], a
	ld [wCurHPAnimNewHP], a
	ld b, [hl]
	ld a, [wBattleMonHP]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [wBattleMonHP], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .mimic_faint

	ld a, [wCurHPAnimOldHP + 1]
	ld [hli], a
	ld a, [wCurHPAnimOldHP]
	ld [hl], a
	xor a

	ld hl, wBattleMonHP
	ld [hli], a
	ld [hl], a
	ld hl, wCurHPAnimNewHP
	ld [hli], a
	ld [hl], a

.mimic_faint
	ld hl, wBattleMonMaxHP
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	hlcoord 9, 9
	ld a, 1
	ld [wWhichHPBar], a
	predef AnimateHPBar
.did_no_damage
	jp RefreshBattleHuds

SelfInflictDamageToSubstitute:
	ld hl, SubTookDamageText
	call StdBattleTextBox

	ld de, wEnemySubstituteHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld de, wPlayerSubstituteHP
.got_hp

	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	and a
	jr nz, .broke

	ld a, [de]
	sub [hl]
	ld [de], a
	jr z, .broke
	jr nc, .done

.broke
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	res SUBSTATUS_SUBSTITUTE, [hl]

	ld hl, SubFadedText
	call StdBattleTextBox

	call SwitchTurn
	call BattleCommand_LowerSubNoAnim
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, AppearUserLowerSub
	call SwitchTurn

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	cp EFFECT_MULTI_HIT
	jr z, .ok
	cp EFFECT_DOUBLE_HIT
	jr z, .ok
	cp EFFECT_TWINEEDLE
	jr z, .ok
	xor a
	ld [hl], a
.ok
	call RefreshBattleHuds
.done
	jp ZeroDamage
