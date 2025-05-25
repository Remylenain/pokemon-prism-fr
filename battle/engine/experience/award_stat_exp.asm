GiveStatExperience:
	ld e, 1
	ld hl, MON_PKRUS
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .no_pokerus
	sla e
.no_pokerus
	ld hl, MON_ITEM
	add hl, bc
	ld a, [hl]
	cp MACHO_BRACE
	jr nz, .no_macho_brace
	sla e
.no_macho_brace
	CheckEngine ENGINE_HYPER_SHARE_ENABLED
	ld a, e
	jr nz, .divide_stat_exp_by_three
	add a, a
	add a, e
.divide_stat_exp_by_three
	ld [wStatEXPMultiplier], a
	ld hl, MON_STAT_EXP + 9
	add hl, bc
	push bc
	ld de, wEnemyMonBaseStats + 4
	ld a, 5
.stat_exp_loop
	push af
	ld a, [de]
	dec de
	ld c, a
	ld a, [wStatEXPMultiplier]
	ld b, 3
	call SimpleMultiplyDivide
	ld a, [hl]
	add a, c
	ld [hld], a
	ld a, [hl]
	adc b
	jr nc, .no_stat_exp_carry
	inc hl
	ld a, $ff
	ld [hld], a
.no_stat_exp_carry
	ld [hld], a
	pop af
	dec a
	jr nz, .stat_exp_loop
	pop bc
	ret
