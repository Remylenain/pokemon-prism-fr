BattleCommand_GetMagnitude:
	call BattleRandomPercentage
	ld hl, .Magnitudes
.loop
	sub [hl]
	inc hl
	jr c, .ok
	inc hl
	inc hl
	jr .loop
.ok
	ld a, [hli]
	push hl
	ld hl, wCurDamageMovePowerNumerator
	ld [hl], 0
	inc hl
	ld [hli], a
	; hl = wCurDamageMovePowerDenominator
	ld [hl], 1
	pop hl
	ld a, [hl]
	ld [wTypeMatchup], a
	call BattleCommand_MoveDelay
	ld hl, MagnitudeText
	jp StdBattleTextBox

.Magnitudes
	;   %,  BP, magnitude
	db  5,  10,  4
	db 10,  30,  5
	db 20,  50,  6
	db 30,  70,  7
	db 20,  90,  8
	db 10, 110,  9
	db  5, 150, 10
