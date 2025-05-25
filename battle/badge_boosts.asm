BadgeStatBoosts:
; Raise the battle mon's stats depending on which badges have been obtained.

; Each badge raises a stat by 1/32. Stat boosts are additive.

	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wInBattleTowerBattle]
	and 5
	ret nz

; Assign them sequentially: attack, defense, speed, sp.atk, sp.def

	ld bc, 0
	ld d, b
	ld e, b
	ld h, b
	ld a, [wNaljoBadges]
	call .count_from_zero
	ld a, [wRijonBadges]
	call .count_from_three
	ld a, [wOtherBadges]
	and $f ;ignore any stray flags
	call .count_from_one
	push hl
	ld hl, wBattleMonAttack
	ld a, b
	call .increment_stat
	ld a, c
	call .increment_stat
	ld a, d
	call .increment_stat
	ld a, e
	call .increment_stat
	pop af
.increment_stat
	; increments stat in hl by a/32, returns with hl = hl + 2
	push bc
	push hl
	push af
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, 0
	pop af
	push bc
	and a
	jr z, .done_incrementing
.loop
	add hl, bc
	dec a
	jr nz, .loop
.done_incrementing
	add hl, hl
	add hl, hl
	add hl, hl
	ld c, h
	ld b, 0
	pop hl
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	pop bc
	ret

.count_from_zero
	srl a
	jr nc, .count_from_one
	inc b
.count_from_one
	srl a
	jr nc, .count_from_two
	inc c
.count_from_two
	srl a
	jr nc, .count_from_three
	inc d
.count_from_three
	srl a
	jr nc, .count_from_four
	inc e
.count_from_four
	srl a
	jr nc, .done_counting
	inc h
.done_counting
	and a
	jr nz, .count_from_zero
	ret
