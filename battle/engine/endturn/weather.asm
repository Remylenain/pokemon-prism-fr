HandleWeather:
	call GetWeatherAfterAbilities
	jr nz, .weather_ok

	; Tick down weather as usual but be quiet about the effect fading.
	ld a, [wWeather]
	and a
	ret z
	ld hl, wWeatherCount
	dec [hl]
	ret nz
	ld [wWeather], a
	ret

.weather_ok
	call GetWeatherAfterAbilities
	and a
	ret z

	ld hl, wWeatherCount
	dec [hl]
	jp z, .ended

	ld hl, .WeatherMessages
	call .PrintWeatherMessage

	xor a
	ld [wNumHits], a
	call PlayWeatherAnimation

	; Now handle weather effects
	call SetFastestTurn
	call .effects
	call SwitchTurn

.effects
	call GetWeatherAfterAbilities
	cp WEATHER_SUN
	jr z, .check_sun_affected_ability
	cp WEATHER_RAIN
	jr z, .check_rain_affected_ability
	cp WEATHER_SANDSTORM
	jr z, .hail_sandstorm
	cp WEATHER_HAIL
	ret nz
.hail_sandstorm
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_UNDERGROUND, a
	ret nz

	ld a, [wWeather]
	cp WEATHER_HAIL
	jr nz, .sandstorm
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_ICE_BODY
	jr nz, .no_ability
	call CheckFullHP
	ret z
	call GetSixteenthMaxHP
	call RestoreUserHP
	ld hl, IceBodyText
	jr .battle_text_box

.check_sun_affected_ability
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_DRY_SKIN
	ret nz
	ld [wd265], a
	call GetAbilityName
	call GetEighthMaxHP
	call SubtractHPFromUser
	ld hl, AbilityHurtText
	jr .battle_text_box

.check_rain_affected_ability
	call CheckFullHP
	ret z
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_DRY_SKIN
	jr z, .DrySkinRain
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_RAIN_DISH
	ret nz
	ld [wd265], a
	call GetAbilityName
	call GetSixteenthMaxHP
	jr .restore_user_HP

.DrySkinRain
	ld [wd265], a
	call GetAbilityName
	call GetEighthMaxHP
.restore_user_HP
	call RestoreUserHP
	ld hl, AbilityRestoreHPText
.battle_text_box
	jp StdBattleTextBox

.sandstorm
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_SAND_VEIL
	ret z

.no_ability
	call GetUserItem
	ld a, b
	cp HELD_SAFE_GOGGLES
	ret z

	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonType1
.ok
	ld a, [wWeather]
	cp WEATHER_SANDSTORM
	jr z, .sandstorm_types
	ld a, [hli]
	cp ICE
	ret z
	ld a, [hl]
	cp ICE
	jr .check_and_damage

.sandstorm_types
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_SAND_VEIL
	ret z
	ld a, [hli]
	cp ROCK
	ret z
	cp GROUND
	ret z
	cp STEEL
	ret z

	ld a, [hl]
	cp ROCK
	ret z
	cp GROUND
	ret z
	cp STEEL
.check_and_damage
	ret z
	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld hl, SandstormHitsText
	ld a, [wWeather]
	cp WEATHER_SANDSTORM
	jr z, .got_anim
	ld hl, HailHitsText
.got_anim
	push hl

	ld a, 1
	ld [wNumHits], a
	ld a, 10
	ld [wTypeModifier], a
	ld de, ANIM_ENEMY_DAMAGE
	ldh a, [hBattleTurn]
	and a
	jr z, .animate_damage
	ld de, ANIM_PLAYER_DAMAGE
.animate_damage
	call Call_PlayBattleAnim

	call SwitchTurn
	call GetEighthMaxHP
	call SubtractHPFromUser

	pop hl
.battle_text_box_2
	jr .battle_text_box

.PrintWeatherMessage
	ld a, [wWeather]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .battle_text_box_2

.ended
	ld hl, .WeatherEndedMessages
	call .PrintWeatherMessage
	xor a
	ld [wWeather], a
	ret

.WeatherMessages
	dw BattleText_RainContinuesToFall
	dw BattleText_TheSunlightIsStrong
	dw BattleText_TheSandstormRages
	dw BattleText_HailContinuesToFall
.WeatherEndedMessages
	dw BattleText_TheRainStopped
	dw BattleText_TheSunlightFaded
	dw BattleText_TheSandstormSubsided
	dw BattleText_TheHailStopped

PlayWeatherAnimation:
	call CheckBattleScene
	ret c
	ld a, [wWeather]
	dec a
	ld e, a
	ld d, 0
	ld hl, .WeatherAnimations
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	jp Call_PlayBattleAnim

.WeatherAnimations
	dw RAIN_DANCE
	dw SUNNY_DAY
	dw ANIM_IN_SANDSTORM
	dw ANIM_IN_HAILSTORM
