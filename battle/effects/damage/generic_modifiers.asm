DoubleDamage:
	ld hl, wCurDamageShiftCount
	inc [hl]
	jp SetDamageDirtyFlag

AddHalfDamage:
	ld hl, wCurDamageShiftCount
	dec [hl]
TripleDamageModifier:
	; also easy to repurpose as x1.5 and x0.75 by decrementing wCurDamageShiftCount before or after the call
	push hl
	push de
	push bc
	ld hl, wCurDamageModifierNumerator
	ld a, [hli]
	ld d, a
	ld e, 0
	ld a, [hli]
	push hl
	ld l, [hl]
	ld h, a
	ld b, h
	ld c, l
	sla c
	rl b
	rl e
	add hl, bc
	ld b, h
	ld a, l
	pop hl
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, e
	adc d
	add a, d
	add a, d
	ld [hl], a
	pop bc
	pop de
	jp SetDamageDirtyFlag_PushedHL

AddHalfMovePower:
	ld hl, wCurDamageMovePowerDenominator
	sla [hl]
TripleMovePower:
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push hl
	ld h, b
	ld l, c
	add hl, bc
	add hl, bc
	ld b, h
	ld a, l
	pop hl
	ld [hld], a
	ld [hl], b
	jp SetDamageDirtyFlag

IncrementDefenseMod:
	ld hl, wCurDamageFlags
	ld a, [hl]
	add a, 4
	or $40 ; instead of calling SetDamageDirtyFlag
	ld [hl], a
	ret
