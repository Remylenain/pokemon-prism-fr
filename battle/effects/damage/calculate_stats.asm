CalcPlayerStats:
	ld hl, wPlayerAtkLevel
	ld de, wPlayerStats
	ld bc, wBattleMonAttack

	ld a, 5
	call CalcStats
	callba BadgeStatBoosts
	call SwitchTurn
	callba ApplyPrzEffectOnSpeed
	callba ApplyBrnEffectOnAttack
	jp SwitchTurn

CalcEnemyStats:
	ld hl, wEnemyAtkLevel
	ld de, wEnemyStats
	ld bc, wEnemyMonAttack

	ld a, 5
	call CalcStats
	call SwitchTurn
	callba ApplyPrzEffectOnSpeed
	callba ApplyBrnEffectOnAttack
	jp SwitchTurn

CalcStats:
.loop
	push af
	ld a, [hli]
	push hl
	push bc

	ld c, a
	dec c
	xor a
	ld b, a
	ld hl, .multipliers
	add hl, bc
	add hl, bc

	ldh [hMultiplicand], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	inc de

	ld a, [hli]
	ldh [hMultiplier], a
	predef Multiply

	ld a, [hl]
	ldh [hDivisor], a
	ld b, 4
	predef Divide

	ldh a, [hQuotient + 1]
	ld b, a
	ldh a, [hQuotient + 2]
	or b
	jr nz, .not_zero

	; purely a failsafe, as the lowest possible value this calculation would ever return is 1.25, floored to 1
	ld a, 1
	ldh [hQuotient + 2], a

.not_zero
	pop bc
	ldh a, [hQuotient + 1]
	ld [bc], a
	inc bc
	ldh a, [hQuotient + 2]
	ld [bc], a
	inc bc
	pop hl
	pop af
	dec a
	jr nz, .loop
	ret

.multipliers
	db 1, 4 ; 0.25x
	db 2, 7 ; 0.29x
	db 1, 3 ; 0.33x
	db 2, 5 ; 0.40x
	db 1, 2 ; 0.50x
	db 2, 3 ; 0.67x
	db 1, 1 ; 1.00x
	db 3, 2 ; 1.50x
	db 2, 1 ; 2.00x
	db 5, 2 ; 2.50x
	db 3, 1 ; 3.00x
	db 7, 2 ; 3.50x
	db 4, 1 ; 4.00x
