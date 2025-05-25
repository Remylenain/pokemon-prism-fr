StartBattle:
; This check prevents you from entering a battle without any Pokemon.
; Those using walk-through-walls to bypass getting a Pokemon experience
; the effects of this check.
	call CancelMapSign
	ld a, [wPartyCount]
	and a
	ret z

	ld a, [wTimeOfDayPal]
	push af
	call BattleIntro
	ld c, STOPWATCH_BATTLE
	callba RestartStopwatch
	call DoBattle
	ld hl, wStopwatchControl
	res STOPWATCH_BATTLE, [hl]
	call ExitBattle
	pop af
	ld [wTimeOfDayPal], a
	call .update_battles_won_counter
	call .update_battles_total_time
	scf
	ret

.update_battles_won_counter
	ld a, [wBattleResult]
	and 15
	ret nz
	ld hl, wBattlesWonCounter
	inc [hl]
	ret nz
	rept 2
		inc hl
		inc [hl]
		ret nz
	endr
	ld a, $ff
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ret

.update_battles_total_time
	lb bc, STOPWATCH_READ_FORMATTED, STOPWATCH_BATTLE
	callba ReadStopwatch
	ld hl, wTotalBattleTime + 5
	ld a, [hl]
	add a, e
	cp 100
	jr c, .no_carry_hundredths
	sub 100
.no_carry_hundredths
	ccf
	ld [hld], a
	ld a, [hl]
	adc d
	cp 60
	jr c, .no_carry_seconds
	sub 60
.no_carry_seconds
	ccf
	ld [hld], a
	ld a, [hl]
	adc c
	cp 60
	jr c, .no_carry_minutes
	sub 60
.no_carry_minutes
	ccf
	ld [hld], a
	ldh a, [hLongQuotient + 3]
	adc [hl]
	ld [hld], a
	ldh a, [hLongQuotient + 2]
	adc [hl]
	ld [hld], a
	ret nc
	inc [hl]
	ret
