ApplyStatusEffectOnPlayerStats:
	ld a, 1
	jr ApplyStatusEffectOnStats

ApplyStatusEffectOnEnemyStats:
	xor a
	; fallthrough

ApplyStatusEffectOnStats:
	ldh [hBattleTurn], a
	call ApplyPrzEffectOnSpeed
	; fallthrough

ApplyBrnEffectOnAttack:
; Guts ignore Burn penalties
	call GetTargetAbility
	cp ABILITY_GUTS
	ret z

	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonAttack
	ld a, [wEnemyMonStatus]
	jr z, .check_enemy
	ld hl, wBattleMonAttack
	ld a, [wBattleMonStatus]
.check_enemy
	and 1 << BRN
	ret z
	srl [hl]
	inc hl
	rr [hl]
	ret

ApplyPrzEffectOnSpeed:
	ldh a, [hBattleTurn]
	and a
	jr z, .enemy
	ld a, [wBattleMonStatus]
	and 1 << PAR
	ret z
	ld a, [wPlayerAbility]
	ld hl, wBattleMonSpeed + 1
.check_and_halve
	cp ABILITY_QUICK_FEET
	ret z
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .not_zero
	inc b
.not_zero
	ld [hl], b
	ret

.enemy
	ld a, [wEnemyMonStatus]
	and 1 << PAR
	ret z
	ld a, [wEnemyAbility]
	ld hl, wEnemyMonSpeed + 1
	jr .check_and_halve

ApplyStatLevelMultiplierOnAllStats:
	ld c, 0
.stat_loop
	call ApplyStatLevelMultiplier
	inc c
	ld a, c
	cp 5
	jr nz, .stat_loop
	ret

ApplyStatLevelMultiplier:
	push bc
	push bc
	ld a, [wd265]
	and a
	ld a, c
	ld hl, wBattleMonAttack
	ld de, wPlayerStats
	ld bc, wPlayerAtkLevel
	jr z, .got_pointers
	ld hl, wEnemyMonAttack
	ld de, wEnemyStats
	ld bc, wEnemyAtkLevel

.got_pointers
	add a, c
	ld c, a
	adc b
	sub c
	ld b, a
	ld a, [bc]
	pop bc
	ld b, a
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add a, e
	ld e, a
	adc d
	sub e
	ld d, a
	pop bc
	push hl
	ld hl, .stat_level_multipliers
	dec b
	sla b
	xor a
	ld c, b
	ld b, a
	add hl, bc
	ldh [hMultiplicand], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplier], a
	predef Multiply
	ld a, [hl]
	ldh [hDivisor], a
	ld b, 4
	predef Divide
	pop hl
	ldh a, [hQuotient + 1]
	ld [hli], a
	ld b, a
	ldh a, [hQuotient + 2]
	ld [hl], a
	or b
	jr nz, .not_zero
	inc [hl]
.not_zero
	pop bc
	ret

.stat_level_multipliers
	; numerator and denominator
	db 1, 4
	db 2, 7
	db 1, 3
	db 2, 5
	db 1, 2
	db 2, 3

	db 1, 1

	db 3, 2
	db 2, 1
	db 5, 2
	db 3, 1
	db 7, 2
	db 4, 1
