DisappearUser:
	xor a
	ldh [hBGMapMode], a
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	call GetEnemyFrontpicCoords
	jr .okay
.player
	call GetPlayerBackpicCoords
.okay
	call ClearBox
	jr FinishAppearDisappearUser

AppearUser:
	xor a
	ldh [hBGMapMode], a
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	call GetEnemyFrontpicCoords
	xor a
	jr .okay
.player
	call GetPlayerBackpicCoords
	ld a, $31
.okay
	ldh [hGraphicStartTile], a
	predef PlaceGraphic
FinishAppearDisappearUser:
	ld a, 1
	ldh [hBGMapMode], a
	ret

GetEnemyFrontpicCoords:
	hlcoord 12, 0
	lb bc, 7, 7
	ret

GetPlayerBackpicCoords:
	hlcoord 2, 6
	lb bc, 6, 6
	ret

DoWeatherModifiers:
	ld de, .WeatherTypeModifiers
	call GetWeatherAfterAbilities
	ld b, a
	ld a, [wd265] ; move type
	ld c, a

.CheckWeatherType
	ld a, [de]
	inc de
	cp $ff
	jr z, .done_weather_types

	cp b
	jr nz, .NextWeatherType

	ld a, [de]
	cp c
	jr z, .ApplyModifier

.NextWeatherType
	inc de
	inc de
	jr .CheckWeatherType

.done_weather_types
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_SOLARBEAM
	ret nz
	ld a, b
	and a
	ret z
	cp WEATHER_SUN
	jr nz, .halve_damage
	ret

.ApplyModifier
	ld hl, wCurDamageModifierNumerator
	ld a, [hli]
	ldh [hMultiplicand], a
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	inc de
	ld a, [de]
	ldh [hMultiplier], a
	predef Multiply
	ldh a, [hProduct + 3]
	ld [hld], a
	ldh a, [hProduct + 2]
	ld [hld], a
	ldh a, [hProduct + 1]
	ld [hl], a

.halve_damage
	ld hl, wCurDamageShiftCount
	dec [hl]

	jp SetDamageDirtyFlag

.WeatherTypeModifiers
	db WEATHER_RAIN, WATER, 3
	db WEATHER_RAIN, FIRE,  1
	db WEATHER_SUN,  FIRE,  3
	db WEATHER_SUN,  WATER, 1
	db $ff

DoBadgeTypeBoosts:
	; unlike the original (designed to operate on the insane "hold damage variables in all the registers" setup), this function clobbers all registers
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, [wInBattleTowerBattle]
	and 5
	ret nz
	ldh a, [hBattleTurn]
	and a
	ret nz

	ld hl, .badge_types

	ld c, 0
	ld a, [wNaljoBadges]
	call .count_badges
	ld a, [wRijonBadges]
	call .count_badges
	ld a, [wOtherBadges]
	call .count_badges

	ld a, c
	and a
	ret z

	; we have some badges that apply; flat +1% per badge
	add a, 100
	ldh [hMultiplier], a
	ld hl, wCurDamageModifierNumerator
	ld a, [hli]
	ldh [hMultiplicand], a
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	predef Multiply
	ldh a, [hProduct + 3]
	ld [hld], a
	ldh a, [hProduct + 2]
	ld [hld], a
	ldh a, [hProduct + 1]
	ld [hl], a
	; we multiply the denominator by 25...
	ld hl, wCurDamageModifierDenominator
	ld a, [hli]
	push hl
	ld l, [hl]
	ld h, a
	ld b, h
	ld c, l
	add hl, hl
	add hl, hl
	add hl, bc
	ld b, h
	ld c, l
	add hl, hl
	add hl, hl
	add hl, bc
	ld b, h
	ld a, l
	pop hl
	ld [hld], a
	ld [hl], b
	; ...and shift the damage twice to the right. 1/25 * 2^(-2) = 1/100, which is what we want here
	ld hl, wCurDamageShiftCount
	dec [hl]
	dec [hl]
	jp SetDamageDirtyFlag

.count_badges
	ld b, a
	ld e, 8
.next_badge
	call .check_badge
	dec e
	jr nz, .next_badge
	ret

.check_badge
	ld a, [hl]
	inc a
	jr z, .no_more_badges
	srl b
	jr nc, .done_badge
.got_badge
	ld a, [wd265] ; move type
	cp [hl]
	jr nz, .done_badge
	inc c
.done_badge
	inc hl
	ret
.no_more_badges
	add sp, 2 ; skip the .count_badges function and return to its caller
	ret

.badge_types
	db FIRE
	db GRASS
	db FAIRY_T
	db DARK
	db FIGHTING
	db GAS
	db SOUND
	db PRISM_T

	db WATER
	db ICE
	db GRASS
	db ELECTRIC
	db FIGHTING
	db PSYCHIC
	db NORMAL
	db GROUND

	db BUG
	db NORMAL
	db PSYCHIC
	db FIRE
	db $ff
