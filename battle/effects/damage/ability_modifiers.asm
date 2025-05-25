PhysicalAbilityModifiers:
; Performs physical Attack/Defense modifiers based on Abilities
	call GetTargetAbility
	cp ABILITY_MARVEL_SCALE
	jr nz, .no_marvel_scale
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	call nz, IncrementDefenseMod
.no_marvel_scale

	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_GUTS
	jr z, .guts
	cp ABILITY_HUSTLE
	jr z, .hustle
	cp ABILITY_HUGE_POWER
	ret nz
	ld hl, wCurDamageAttack + 1
	sla [hl]
	dec hl
	rl [hl]
	jp SetDamageDirtyFlag

.guts
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	ret z
.hustle
	ld hl, wCurDamageFlags
	inc [hl]
	set 6, [hl] ;no point in calling SetDamageDirtyFlag when we can do this
	ret

RockBoostInSand:
; x1.5 SpDef modifier for Rock types in sandstorm
	call GetWeatherAfterAbilities
	cp WEATHER_SANDSTORM
	ret nz
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonType1
	jr z, .got_type
	ld hl, wBattleMonType1
.got_type
	ld a, [hli]
	cp ROCK
	jr z, .increment_defense_mod
	ld a, [hl]
	cp ROCK
	ret nz
.increment_defense_mod
	jp IncrementDefenseMod

FlashFireBuff:
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp FIRE
	jp z, AddHalfMovePower
	ret
