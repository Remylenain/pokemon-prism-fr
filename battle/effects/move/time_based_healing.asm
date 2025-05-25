BattleCommand_HealMorn:
	ld b, MORN
	jr BattleCommand_TimeBasedHealContinue

BattleCommand_HealDay:
	ld b, DAY
	jr BattleCommand_TimeBasedHealContinue

BattleCommand_HealNite:
	ld b, NITE
	; fallthrough

BattleCommand_TimeBasedHealContinue:
	; Time- and weather-sensitive heal.
	ld c, 1
	callba CheckFullHP
	jr z, .full

	; Don't factor in time of day in link battles.
	ld a, [wLinkMode]
	and a
	jr nz, .weather

	ld a, [wTimeOfDay]
	cp b
	jr nz, .weather
	inc c ; double

.weather
	call GetWeatherAfterAbilities
	and a
	jr z, .heal

	; x2 in sun, /2 in rain/sandstorm
	inc c
	cp WEATHER_SUN
	jr z, .heal
	dec c
	dec c

.heal
	ld b, 0
	ld hl, .multipliers
	add hl, bc
	add hl, bc

	ld a, BANK(GetMaxHP)
	call FarCall_Pointer

	call AnimateCurrentMove

	callba RestoreUserHP
	call UpdateUserInParty

	ld hl, RegainedHealthText
	jr .std_battle_text_box

.full
	call AnimateFailedMove

	ld hl, HPIsFullText
.std_battle_text_box
	jp StdBattleTextBox

.multipliers
	dw GetEighthMaxHP
	dw GetQuarterMaxHP
	dw GetHalfMaxHP
	dw GetMaxHP
