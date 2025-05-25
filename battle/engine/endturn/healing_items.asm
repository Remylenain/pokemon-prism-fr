EndTurn_HealingItems:
	call SetFastestTurn
	call .do_it
	call SwitchTurn
.do_it
	call UseHeldStatusHealingItem
	call UseConfusionHealingItem
	call GetOpponentItem
	ld a, b
	cp HELD_BERRY
	ret nz
	call SwitchTurn
	ld a, [hl]
	cp SITRUS_BERRY
	call z, GetQuarterMaxHP
	push bc
	call GetThirdMaxHP ; hl = max hp + 1, bc = max(1, (1/3) * ([max hp]))
	ld d, b
	ld e, c
	pop bc
	call SwitchTurn
	dec hl
	dec hl
	ld a, [hld]
	ld [wCurHPAnimOldHP], a
	ld a, [hli]
	ld [wCurHPAnimOldHP + 1], a
	cp d
	jr c, .go
	ret nz
	ld a, [hl]
	cp e
	jr z, .go
	ret nc
.go
	ld a, [hld]
	add c
	ld c, a
	ld a, [hli]
	adc 0
	ld b, a
	push hl
	inc hl
	inc hl
	ld a, [hld]
	cp c
	ld a, [hl]
	sbc b
	jr nc, .load_bc
	ld b, [hl]
	inc hl
	ld c, [hl]
.load_bc
	push bc
	ld a, c
	ld [wCurHPAnimNewHP], a
	ld a, b
	ld [wCurHPAnimNewHP + 1], a
	call ItemRecoveryAnim
	ldh a, [hBattleTurn]
	ld [wWhichHPBar], a
	and a
	hlcoord 0, 2
	jr z, .got_hp_bar_coords
	hlcoord 9, 9
.got_hp_bar_coords
	ld [wWhichHPBar], a
	predef AnimateHPBar
	pop bc
	pop hl
	ld [hl], c
	dec hl
	ld [hl], b
	jp UseOpponentItem
