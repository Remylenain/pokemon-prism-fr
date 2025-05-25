SapHealth:
	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	srl a ;halve damage
	ldh [hDividend], a
	ld b, a
	ld a, [hl]
	rra
	ldh [hDividend + 1], a

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp DRAININGKISS
	ldh a, [hDividend + 1]
	jr nz, .not_kiss
	srl b
	rra
	ld hl, hDividend + 1
	add a, [hl]
	ldh [hDividend + 1], a
	ld a, b
	dec hl
	add a, [hl]
	ldh [hDividend], a
	ldh a, [hDividend + 1]
.not_kiss
	or b
	jr nz, .not_zero_recovery
	inc a
	ldh [hDividend + 1], a ;holds half of damage deal, min 1
.not_zero_recovery
	ld hl, wBattleMonHP
	ld de, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_HP_pointers
	ld hl, wEnemyMonHP
	ld de, wEnemyMonMaxHP
.got_HP_pointers
	ld bc, wCurHPAnimOldHP + 1
	ld a, [hli]
	ld [bc], a
	ld a, [hl]
	dec bc
	ld [bc], a ;place current HP in wCurHPAnimOldHP
	ld a, [de] ;place max hp into wCurHPAnimNewHP
	dec bc
	ld [bc], a
	inc de
	ld a, [de]
	dec bc
	ld [bc], a
	call GetTargetAbility
	cp ABILITY_LIQUID_OOZE
	push af
	jr z, .subtract
	ldh a, [hDividend + 1]
	ld b, [hl]
	add b
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ldh a, [hDividend]
	ld b, [hl]
	adc b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	jr c, .max_hp
	ld a, [hld]
	ld b, a
	ld a, [de]
	dec de
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	inc de
	sbc b
	jr nc, .updated_HP
.max_hp
	ld a, [de]
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	dec de
	ld a, [de]
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	inc de
	jr .updated_HP

.subtract
	ldh a, [hDividend + 1]
	ld b, a
	ld a, [hl]
	sub b
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ldh a, [hDividend]
	ld b, a
	ld a, [hl]
	sbc b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .updated_HP
	; RIP
	xor a
	ld [hld], a
	ld [hl], a
	ld [wCurHPAnimNewHP], a
	ld [wCurHPAnimNewHP + 1], a
.updated_HP
	ldh a, [hBattleTurn]
	and a
	hlcoord 9, 9
	ld a, 1
	jr z, .got_HP_bar
	hlcoord 0, 2
	xor a
.got_HP_bar
	ld [wWhichHPBar], a
	predef AnimateHPBar
	call RefreshBattleHuds
	call UpdateBattleMonInParty
	pop af ; restore the results from the Liquid Ooze check
	ret

BattleCommand_DrainTarget:
	ld hl, SuckedHealthText
	jr SapHealthAndPrintMessage

BattleCommand_EatDream:
	ld hl, DreamEatenText
	; fallthrough

SapHealthAndPrintMessage:
	push hl
	call SapHealth
	pop hl
	jr nz, .battle_text_box
	ld hl, LiquidOozeText
.battle_text_box
	jp StdBattleTextBox
