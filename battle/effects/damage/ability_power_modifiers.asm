AbilityBasePowerBoosts:
	ld hl, .abilities
	ld e, 3
	call IsInArray
	jp c, CallLocalPointer_AfterIsInArray
	ret

.abilities
	dbw ABILITY_TECHNICIAN, .technician
	dbw ABILITY_RECKLESS,   .reckless
	dbw ABILITY_IRON_FIST,  .iron_fist
	dbw ABILITY_RIVALRY,    .rivalry
	dbw ABILITY_SHARPNESS,  .sharpness
	db $ff

.rivalry
	call CheckOppositeGender
	jr nc, .subtract_25_percent ; opposite gender: -25% power
	ret z ; genderless
	; same gender: +25% power
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push hl
	ld h, b
	ld l, c
	; x5
	add hl, hl
	add hl, hl
	add hl, bc
	ld a, l
	ld b, h
	pop hl
	ld [hld], a
	ld [hl], b
.quarter_move_power
	ld hl, wCurDamageMovePowerDenominator
	sla [hl]
	sla [hl]
	jp SetDamageDirtyFlag

.subtract_25_percent
	call TripleMovePower
	jr .quarter_move_power

.iron_fist
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, .punch_moves
	call IsInSingularArray
	jr c, .add_20_percent
	ret

.punch_moves
	db BULLET_PUNCH
	db DIZZY_PUNCH
	db DYNAMICPUNCH
	db FIRE_PUNCH
	db ICE_PUNCH
	db MACH_PUNCH
	db DRAIN_PUNCH
	db METEOR_MASH
	db THUNDERPUNCH
	db GHOST_HAMMER
	db -1

.sharpness
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, .sharp_moves
	call IsInSingularArray
	jr c, .add_50_percent
	ret

.sharp_moves
	db AERIAL_ACE
	db AIR_SLASH
	db CUT
	db FURY_CUTTER
	db NIGHT_SLASH
	db PSYCHO_CUT
	db RAZOR_LEAF
	db SLASH
	db X_SCISSOR

.technician
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	; hl = wCurDamageMovePowerDenominator
	ld e, [hl]
	ld d, 0
	call Divide16 ;no need to use Divide16 (as it will just call Divide), but it preloads the results into registers
	ld a, d
	and a
	ret nz
	ld a, e
	cp 60
	jr c, .add_50_percent
	ret nz
	ld a, c
	and a
	ret nz
.add_50_percent
	jp AddHalfMovePower

.reckless
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp STRUGGLE
	ret z
	cp HI_JUMP_KICK
	jr z, .add_20_percent
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_RECOIL_HIT
	jr z, .add_20_percent
	cp EFFECT_FLARE_BLITZ
	ret nz
.add_20_percent
	ld hl, wCurDamageMovePowerDenominator
	ld a, [hl]
	; x5
	add a, a
	add a, a
	add a, [hl]
	ld [hl], a
	dec hl ; hl = wCurDamageMovePowerNumerator + 1
	; x6 (double and then triple)
	sla [hl]
	dec hl
	rl [hl]
	jp TripleMovePower
