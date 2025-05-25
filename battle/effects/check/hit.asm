BattleCommand_CheckHit:
	call .DreamEater
	jr z, .Missed

	call .Protect
	jr nz, .Missed

	ld a, [wPlayerAbility]
	cp ABILITY_NO_GUARD
	ret z
	ld a, [wEnemyAbility]
	cp ABILITY_NO_GUARD
	ret z

	call .LockOn
	ret nz

	call .PoisonToxic
	ret z

	call .FlyDigMoves
	jr nz, .Missed

	call .WeatherSureHit
	ret z

	call .MinimizedSureHit
	ret z

	call .PerfectAccuracy
	ret z

	call .GetEffectiveAccuracy
	ret nc

	ld h, a
	call BattleRandomPercentage
	cp h
	ret c
	jr z, .check_accuracy_fraction
.Missed
	ld a, 1
	ld [wAttackMissed], a
	ret

.check_accuracy_fraction
	; generate a random number in [0, de) and award a hit if random < bc
	ld a, b
	or c
	jr z, .Missed
.shift_loop
	bit 7, d
	jr nz, .sample_fraction
	sla c
	rl b
	sla e
	rl d
	jr .shift_loop
.sample_fraction
	call BattleRandom
	ld l, a
	call BattleRandom
	ld h, a
	cp d
	jr c, .check_fraction
	jr nz, .sample_fraction
	ld a, l
	cp e
	jr nc, .sample_fraction
.check_fraction
	ld a, h
	cp b
	ret c
	jr nz, .Missed
	ld a, l
	cp c
	ret c
	jr .Missed

.DreamEater
; Return z if we're trying to eat the dream of
; a monster that isn't sleeping.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_DREAM_EATER
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and SLP
	ret

.Protect
; Return nz if the opponent is protected.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	ret z

	ld c, 40
	call DelayFrames

; 'protecting itself!'
	ld hl, ProtectingItselfText
	call StdBattleTextBox

	ld c, 40
	call DelayFrames
	jr .LockedOn

.LockOn
; Return nz if we are locked-on and aren't trying to use Earthquake,
; Bass Tremor or Magnitude on a monster that is flying. (Fissure too if re-added)
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_LOCK_ON, [hl]
	res SUBSTATUS_LOCK_ON, [hl]
	ret z

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_FLYING, a
	jr z, .LockedOn

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp EARTHQUAKE
	ret z
	cp MAGNITUDE
	ret z
	cp BASS_TREMOR
	ret z

.LockedOn
	ld a, 1
	and a
	ret

.PoisonToxic
; In newer generations, Toxic always hits if used by a Poison type
; Return z if this is the case
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_TOXIC
	ret nz
	ldh a, [hBattleTurn]
	and a
	ld de, wBattleMonType1
	jr z, .player_type
	ld de, wEnemyMonType1
.player_type
	ld a, [de]
	cp POISON
	ret z
	inc de
	ld a, [de]
	cp POISON
	ret

.FlyDigMoves
; Check for moves that can hit underground/flying opponents.
; Return z if the current move can hit the opponent.

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret z

	bit SUBSTATUS_FLYING, a
	jr z, .DigMoves

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp GUST
	ret z
	cp WHIRLWIND
	ret z
	cp THUNDER
	ret z
	cp TWISTER
	ret z
	cp STORM_FRONT
	ret z
	cp DUST_DEVIL
	ret

.DigMoves
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp EARTHQUAKE
	ret z
	cp MAGNITUDE
	ret z
	cp BASS_TREMOR
	ret

.WeatherSureHit
; Return z if the current move always hits in certain weather, and that weather is present.
	call GetWeatherAfterAbilities
	cp WEATHER_RAIN
	jr nz, .no_rain
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_THUNDER
	ret
.no_rain
	cp WEATHER_HAIL
	ret nz
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp BLIZZARD
	ret

.PerfectAccuracy
; Return z if move has Perfect accuracy
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ALWAYS_HIT
	ret z

	; Moves in newer generations that already have another effect
	cp EFFECT_WHIRLWIND
	ret z
	cp EFFECT_FORESIGHT
	ret z
	cp EFFECT_LOCK_ON
	ret z
	cp EFFECT_PAIN_SPLIT
	ret z
	cp EFFECT_CONVERSION2
	ret z

	; Struggle shares its move effect with other recoil moves
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp STRUGGLE
	ret

.MinimizedSureHit
; Stomp / Body Slam always hit minimized opponents
; Return z if this is the case
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_BODY_SLAM
	jr z, .minimize_check
	cp EFFECT_STOMP
	ret nz
.minimize_check
	ldh a, [hBattleTurn]
	and a
	ld a, [wEnemyMinimized]
	jr z, .player_attack
	ld a, [wPlayerMinimized]
.player_attack
	dec a
	ret

.GetEffectiveAccuracy
	; calculates the actual accuracy of the move, and stores it in the move struct
	; also returns a mixed number a bc/de, capped at 100 (100 0/1); carry is set if acc < 100%

	ldh a, [hBattleTurn]
	and a

	; load the user's accuracy into b and the opponent's evasion into c.
	ld de, wPlayerMoveStruct + MOVE_ACC
	ld a, [wPlayerAccLevel]
	ld b, a
	ld a, [wEnemyEvaLevel]
	jr z, .got_acc_eva
	ld de, wEnemyMoveStruct + MOVE_ACC
	ld a, [wEnemyAccLevel]
	ld b, a
	ld a, [wPlayerEvaLevel]
.got_acc_eva
	ld c, a

	; The attacker's Keen Eye or the opponent being identified (Foresight) will make
	; +x evasion be regarded as 0 (negative evasion is unchanged).
	call .IdentifiedMod
	call .KeenEyeMod

	; The way accuracy and evasion is combined
	; from generation III onwards is a bit unintuitive.
	; Instead of calcing them seperately, they
	; are both combined additively. For example,
	; acc-3 and eva+3 is 3/9, not 3/12. In addition,
	; the change is capped at -6 or +6
	ld a, 6
	add b
	sub c
	jr nc, .min_acc_ok
	xor a
.min_acc_ok
	cp 13
	jr c, .max_acc_ok
	ld a, 12
.max_acc_ok
	ld c, a

	; c = modifier numerator, b = modifier denominator
	ld hl, .AccProb
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld b, [hl]

	; Tangled Feet halves accuracy when confused
	call GetTargetAbility
	cp ABILITY_TANGLED_FEET
	jr nz, .no_halve
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	jr z, .no_halve
	sla b
.no_halve

	push de
	call GetTargetAbility
	ld d, a
	ld hl, .WeatherEvasionAbilities
.loop
	ld a, [hli]
	cp $ff
	jr z, .no_weather
	cp d
	jr z, .check_weather
	inc hl
	jr .loop

	; if true, accuracy is reduced by a 20%
.check_weather
	call GetWeatherAfterAbilities
	cp [hl]
	jr nz, .no_weather
	sla c
	sla c
	ld a, b
	add a, a
	add a, a
	add a, b
	ld b, a
.no_weather

	; at this point, the maximum values are c = 32, b = 80
	; but from now on they can overflow one byte, so we use two bytes instead
	; bc = numerator, de = denominator
	ld e, b
	ld d, 0
	ld b, d

	; if the opponent is holding BrightPowder, reduce accuracy by a 20%
	push bc
	push de
	call GetOpponentItem
	ld a, b
	pop de
	pop bc
	cp HELD_BRIGHTPOWDER
	call z, .subtract_20_percent_accuracy

	call GetUserAbility_IgnoreMoldBreaker
	call .handle_ability

	; finally, apply the actual accuracy to the long chain of modifiers we created
	xor a
	ld hl, hMultiplicand
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	pop bc
	ld a, [bc]
	push bc
	ld [hl], a
	predef Multiply
	ld a, d
	ld [hli], a
	ld [hl], e
	predef DivideLong

	; and ensure we don't get more than 100%. Note that this process sets carry only if acc < 100%
	ld hl, hLongQuotient + 1
	ld a, [hli]
	or [hl]
	jr nz, .overflow
	inc hl
	ld a, [hli]
	cp 100
	jr nc, .overflow
	ld b, [hl]
	inc hl
	ld c, [hl]
.finish_accuracy
	pop hl
	ld [hl], a
	ret

.overflow
	ld de, 1
	ld b, d
	ld c, d
	ld a, 100
	jr .finish_accuracy

.handle_ability
	cp ABILITY_HUSTLE ; -20% if attack is physical
	jr z, .hustle
	cp ABILITY_COMPOUNDEYES ; +30%
	ret nz
	ld h, b
	ld l, c
	add hl, hl
	add hl, hl
	push hl
	add hl, hl
	add hl, bc
	pop bc
	add hl, bc
	ld b, h
	ld c, l
	sla e
	rl d
	ld h, d
	ld l, e
	add hl, hl
	add hl, hl
	add hl, de
	ld d, h
	ld e, l
	ret
.hustle
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $c0
	ret nz
.subtract_20_percent_accuracy
	ld l, c
	ld h, b
	add hl, hl
	add hl, hl
	ld b, h
	ld c, l
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, de
	ld d, h
	ld e, l
	ret

.WeatherEvasionAbilities
	db ABILITY_SNOW_CLOAK, WEATHER_HAIL
	db ABILITY_SAND_VEIL,  WEATHER_SANDSTORM
	db $ff

.AccProb:
	db 1, 3 ;  33.3% -6
	db 3, 8 ;  37.5% -5
	db 3, 7 ;  42.9% -4
	db 1, 2 ;  50.0% -3
	db 3, 5 ;  60.0% -2
	db 3, 4 ;  75.0% -1
	db 1, 1 ; 100.0%  0
	db 4, 3 ; 133.3% +1
	db 5, 3 ; 166.7% +2
	db 2, 1 ; 200.0% +3
	db 7, 3 ; 233.3% +4
	db 8, 3 ; 266.7% +5
	db 3, 1 ; 300.0% +6

.IdentifiedMod
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IDENTIFIED, a
	ret z
	jr .ResetEvasionBoost
.KeenEyeMod
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_KEEN_EYE
	ret nz
.ResetEvasionBoost
	ld a, c
	cp 7
	ret c
	ld c, 7
	ret
