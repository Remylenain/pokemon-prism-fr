HasUserFainted:
	ldh a, [hBattleTurn]
	and a
	jr z, HasPlayerFainted
HasEnemyFainted:
	ld hl, wEnemyMonHP
	jr CheckIfHPIsZero

HasOpponentFainted:
	ldh a, [hBattleTurn]
	and a
	jr z, HasEnemyFainted
HasPlayerFainted:
	ld hl, wBattleMonHP
	; fallthrough

CheckIfHPIsZero:
	ld a, [hli]
	or [hl]
	ret

CheckFullHP:
; Returns z if HP is full
	push bc
	push de
	push hl
	ldh a, [hBattleTurn]
	and a
	ld de, wBattleMonHP
	ld hl, wBattleMonMaxHP
	jr z, .got_hp
	ld de, wEnemyMonHP
	ld hl, wEnemyMonMaxHP
.got_hp
	ld c, 2
	call StringCmp
	pop hl
	pop de
	pop bc
	ret

CheckUserHasEnoughHP:
	ld hl, wBattleMonHP + 1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonHP + 1
.ok
	ld a, c
	sub [hl]
	dec hl
	ld a, b
	sbc [hl]
	ret
