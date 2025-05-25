BattleCommand_FrustrationPower:
	push bc
	ld hl, wBattleMonHappiness
	ldh a, [hBattleTurn]
	and a
	jr z, .got_happiness
	ld hl, wEnemyMonHappiness
.got_happiness
	ld a, [hl]
	cpl
	jr HappinessBasedPower

BattleCommand_HappinessPower:
; happinesspower
	push bc
	ld hl, wBattleMonHappiness
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonHappiness
.ok
	ld a, [hl]
	; fallthrough

HappinessBasedPower:
	; called with bc pushed
	and a
	jr z, .zero_power
	ld hl, wCurDamageMovePowerNumerator
	ld b, a
	xor a
	sla b
	rla
	ld [hli], a
	ld a, b
	ld [hli], a
	; hl = wCurDamageMovePowerDenominator
	ld [hl], 5
	call SetDamageDirtyFlag
	pop bc
	ret
.zero_power
	; if the move would have zero power, deal 1 damage without calculations
	ld hl, wCurDamageFlags
	ld [hl], $c0 ; fixed damage, dirty
	inc hl ; hl = wCurDamageFixedValue
	ld [hli], a ; a = 0
	ld [hl], 1
	pop bc
	ret
