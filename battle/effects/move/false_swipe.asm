BattleCommand_FalseSwipe:
	ld hl, wEnemyMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wBattleMonHP
.got_hp
	call GetCurrentDamage
	ld de, wCurDamage
	ld c, 2
	push hl
	call StringCmp
	pop de
	jr c, .done
	ld hl, wCurDamageFixedValue
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	sub 1 ;sets carry appropriately
	ld [hl], a
	jr nc, .okay
	dec hl
	dec [hl]
.okay
	ld hl, wCurDamageFlags
	set 7, [hl] ;fixed damage
	set 6, [hl] ;dirty
	xor a
	ld [wCriticalHitOrOHKO], a
	scf
	ret

.done
	and a
	ret
