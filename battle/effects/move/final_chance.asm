BattleCommand_FinalChance:
; finalchance

	ld hl, wPlayerSubStatus1
	ld de, wPlayerPerishCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld hl, wEnemySubStatus1
	ld de, wEnemyPerishCount
.got_addrs
	bit SUBSTATUS_PERISH, [hl]
	jr nz, .failed_non_zero
	inc hl
	bit SUBSTATUS_FINAL_CHANCE, [hl]
.failed_non_zero
	jp nz, FailedGeneric
	set SUBSTATUS_FINAL_CHANCE, [hl]
	dec hl
	set SUBSTATUS_PERISH, [hl]

	ld a, 4
	ld [de], a
	call AnimateCurrentMove
	ld hl, StartFinalChanceText
	jp StdBattleTextBox
