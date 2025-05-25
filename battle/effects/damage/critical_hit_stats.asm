CheckCriticalDiscardStatBoosts:
; Return carry if non-critical
; d = 1: Attack is less than neutral
; e = 1: Defense is better than neutral

	ld a, [wCriticalHitOrOHKO]
	and a
	scf
	ret z

	push hl
	push bc
	ld de, 0
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wPlayerMoveStructType]
	bit 7, a
	jr nz, .done
	bit 6, a
; special
	ld a, [wPlayerSAtkLevel]
	ld b, a
	ld a, [wEnemySDefLevel]
	jr nz, .do_calculations
; physical
	ld a, [wPlayerAtkLevel]
	ld b, a
	ld a, [wEnemyDefLevel]
	jr .do_calculations

.enemy
	ld a, [wEnemyMoveStructType]
	bit 7, a
	jr nz, .done
	bit 6, a
; special
	ld a, [wEnemySAtkLevel]
	ld b, a
	ld a, [wPlayerSDefLevel]
	jr nz, .do_calculations
; physical
	ld a, [wEnemyAtkLevel]
	ld b, a
	ld a, [wPlayerDefLevel]
.do_calculations
	cp 8
	ccf
	rl e
	ld a, b
	cp 7
	rl d
.done
	pop bc
	pop hl
	and a
	ret
