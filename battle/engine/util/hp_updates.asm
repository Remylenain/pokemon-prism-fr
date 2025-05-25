SubtractHPFromTarget:
	call SwitchTurn
	push bc
	call GetMaxHP
	pop bc
	call SubtractHP
	call UpdateHPBarBattleHuds
	jp SwitchTurn

SubtractHPFromUser:
; Subtract HP from Pkmn
	call SubtractHP
	jp UpdateHPBarBattleHuds

SubtractHP:
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonHP
.ok
	inc hl
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	sub c
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a
	ret nc

	ld a, [wCurHPAnimOldHP]
	ld c, a
	ld a, [wCurHPAnimOldHP + 1]
	ld b, a
	xor a
	ld [hli], a
	ld [hl], a
	ld [wCurHPAnimNewHP], a
	ld [wCurHPAnimNewHP + 1], a
	ret

RestoreUserHP:
	call SwitchTurn
	call RestoreOpponentHP
	jp SwitchTurn

RestoreOpponentHP:
	ld hl, wEnemyMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, RestoreHP
	ld hl, wBattleMonMaxHP
RestoreHP:
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP], a
	dec hl
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	add c
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	adc b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a

	ld a, [wCurHPAnimMaxHP]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [wCurHPAnimMaxHP + 1]
	ld b, a
	ld a, [hl]
	sbc b
	jr c, .maxed
	ld a, b
	ld [hli], a
	ld [wCurHPAnimNewHP + 1], a
	ld a, c
	ld [hl], a
	ld [wCurHPAnimNewHP], a
.maxed

	call SwitchTurn
	call UpdateHPBarBattleHuds
	jp SwitchTurn

UpdateHPBarBattleHuds:
	call UpdateHPBar
	jp UpdateBattleHuds

UpdateHPBar:
	hlcoord 9, 9
	ldh a, [hBattleTurn]
	and a
	ld a, 1
	jr z, .ok
	hlcoord 0, 2
	xor a
.ok
	push bc
	ld [wWhichHPBar], a
	predef AnimateHPBar
	pop bc
	ret
