BattleCommand_TypeMatchup:
; handles type matchup, STAB, and type-based badge bonuses and weather modifiers
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp STRUGGLE
	ret z
	cp FUTURE_SIGHT
	jr z, .future_sight

	ld hl, wBattleMonType1
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]

	ldh a, [hBattleTurn]
	and a
	jr z, .go

	push bc
	ld b, d
	ld c, e
	pop de
.go
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	and $3f
	ld [wTypeMatchup], a

	push de
	push bc
	callba DoWeatherModifiers
	pop bc
	pop de

.skip_weather_modifiers
	push de
	push bc
	callba DoBadgeTypeBoosts
	pop bc
	pop de

	ld a, [wTypeMatchup]
	cp b
	jr z, .stab
	cp c
	jr z, .stab

	jr .SkipStab

.future_sight
	ld a, PSYCHIC
	ld [wTypeMatchup], a
	ld hl, wEnemyMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld hl, wPlayerFutureSightLevel
	ldh a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wBattleMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld hl, wEnemyFutureSightLevel
.okay

	push de
	push hl
	callba DoBadgeTypeBoosts
	pop hl
	pop de

	bit 7, [hl]
	jr z, .SkipStab

.stab
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_ADAPTABILITY
	jr z, .double_damage
	cp ABILITY_NALJO_FURY
	jr z, .naljo_fury
.regular_stab
	call AddHalfDamage
	jr .done_stab
.double_damage
	ld hl, wCurDamageShiftCount
	inc [hl]
	call SetDamageDirtyFlag
.done_stab
	ld hl, wTypeModifier
	set 7, [hl]

.SkipStab
	call InAPinchBoost
	call GetAbilityDamageModifier
	jr nc, .SkipAbilityDamageModifier
	ld hl, wCurDamageShiftCount
	and a
	jr z, .no_effect_ability
	dec a
	jr z, .half_ability_damage
	; double damage
	inc [hl]
	jr .load_ability_damage

.no_effect_ability
	ld a, 4
	jr .no_effect_main
.no_effect
	xor a
.no_effect_main
	push af
	ld a, [wTypeModifier]
	and $80
	ld [wTypeModifier], a
	call ZeroDamage ; exits with a = 0
	ld [wTypeMatchup], a
	inc a
	ld [wAttackMissed], a
	pop af
	ld [wFailedMessage], a
	ret

.naljo_fury
	; always enable in link battles or battle tower/arcade battles
	ld a, [wInBattleTowerBattle]
	and 5
	ld hl, wLinkMode
	or [hl]
	jr nz, .naljo_stab
	push de
	callba RegionCheck
	ld a, e
	cp REGION_NALJO
	pop de
	jr nz, .regular_stab
.naljo_stab
	; wCurDamageModifierNumerator *= 5
	ld hl, wCurDamageModifierNumerator
	push hl
	ld a, [hli]
	ld b, [hl]
	inc hl
	ld c, [hl]
	ld h, b
	ld l, c
	add hl, hl
	adc a
	add hl, hl
	adc a
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	adc [hl]
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], c
	ld hl, wCurDamageShiftCount
	dec [hl]
	call SetDamageDirtyFlag
	jr .done_stab

.half_ability_damage
	dec [hl]
.load_ability_damage ;this doesn't "load" anything anymore, but the name is somewhat okay
	call SetDamageDirtyFlag
.SkipAbilityDamageModifier
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	ld b, a
	call GetTypeMatchupFromBitArray
	ld a, [wTypeMatchup]
	ld b, a
	push af
	ld a, [wTypeModifier]
	and $80
	or b
	ld [wTypeModifier], a
	pop af
	and a
	ret z
	cp 10
	jr c, .CheckTintedLens
	ret z
	call GetUserItem
	ld a, b
	cp HELD_SE_BOOST
	jr nz, .not_expert_belt
	ld a, c
	add a, 100
	ld [wCurDamageItemModifier], a
	call SetDamageDirtyFlag
.not_expert_belt
	call GetTargetAbility
	cp ABILITY_SOLID_ROCK
	ret nz
	; reducing damage by a quarter is equivalent to tripling it and quartering it
	ld hl, wCurDamageShiftCount
	dec [hl]
	dec [hl]
	jp TripleDamageModifier

.CheckTintedLens
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_TINTED_LENS
	ret nz
	ld hl, wCurDamageShiftCount
	inc [hl]
	jp SetDamageDirtyFlag

BattleCheckTypeMatchup:
	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_enemy_type_pointer
	ld hl, wBattleMonType1
.got_enemy_type_pointer
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
CheckTypeMatchup:
	push af
	push hl
	call GetAbilityDamageModifier
	pop hl
	jr nc, .okay
	and a
	jr nz, .okay
	ld [wTypeMatchup], a
	pop af
	; Code above was slightly tweaked to make AI switch-out checks do the right thing.
	; Previously, this would at this point return a=0 and zero flag. Just in case a
	; routine relies on this (I couldn't find any), preserve this behaviour
	xor a
	ret

.okay
	pop af
	and $3f ; move type
	push hl
	push de
	push bc
	ld b, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call GetTypeMatchupFromBitArray
	pop bc
	pop de
	pop hl
	ret

GetTypeMatchupFromBitArray:
; attacking type b, defending types d, e
	ld a, 10
	ld [wTypeMatchup], a
	ld a, b
	push bc
	ld bc, MATCHUP_TABLE_WIDTH
	ld hl, TypeMatchup
	rst AddNTimes
	pop bc
	push hl
	push de
	push bc
	ld e, d
	call .GetMatchup
	pop bc
	pop de
	pop hl
	ret c
	ld a, d
	cp e
	ret z
.GetMatchup
	call .GetNonStandardTypeMatchup
	push de
	jr c, .got_bits
	ld a, e
	srl e
	srl e
	ld d, 0
	add hl, de
	ld e, [hl]
	and 3
	jr z, .got_bits
.bit_loop
	srl e
	srl e
	dec a
	jr nz, .bit_loop
.got_bits
	ld a, e
	pop de
	and 3
	call z, .ForesightCheck
	jr z, .immune
	cp NTL
	push af
	ld a, 10
	jr z, .got_damage_mod
	jr c, .not_very_effective
	add a
	jr .got_damage_mod

.not_very_effective
	rrca
.got_damage_mod
	ld b, a
	ld a, [wTypeModifier]
	and $80
	add b
	ld [wTypeModifier], a

	pop af
	ret z

	call SetDamageDirtyFlag ; it will be set by both branches
	ld hl, wCurDamageShiftCount
	jr c, .halve
	inc [hl]
	ld hl, wTypeMatchup
	sla [hl]
	and a
	ret

.halve
	dec [hl]
	ld hl, wTypeMatchup
	srl [hl]
	and a
	ret

.immune
	call ZeroDamage ; exits with a = 0
	ld [wTypeMatchup], a
	inc a
	ld [wAttackMissed], a
	ld a, [wTypeModifier]
	and $80
	ld [wTypeModifier], a
	scf
	ret

.ForesightCheck
	ld a, e
	cp GHOST
	jr nz, .not_foresight
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IDENTIFIED, a
	jr nz, .foresight
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_SCRAPPY
	jr nz, .not_foresight
.foresight
	ld a, NTL
	and a
	ret

.not_foresight
	xor a
	ret

.GetNonStandardTypeMatchup
	push hl
	push de
	push bc
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, .NonStandardTypeMatchups
	ld e, 3
	call IsInArray
	pop bc
	pop de
	jr nc, .standard
	inc hl
	ld a, [hli]
	cp e
	jr z, .nonstandard
	add a, a
	jr c, .nonstandard
.standard
	; carry is clear here
	pop hl
	ret

.nonstandard
	ld e, [hl]
	pop hl
	scf
	ret

.NonStandardTypeMatchups
	db STEEL_EATER,  STEEL,  SE_
	db BOIL,         WATER,  SE_
	db CRYSTAL_BOLT, GROUND, NTL
	db VOID_SPHERE,  $80,    NTL
	db GHOST_HAMMER, NORMAL, NTL
	db $ff

BattleCommand_ResetTypeMatchup:
; Reset the type matchup multiplier to 1.0, if the type matchup is not 0.
; If there is immunity in play, the move automatically misses.
	call BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	and a
	jr nz, .reset
	call ZeroDamage ; exits with a = 0
	ld [wTypeModifier], a
	inc a
	ld [wAttackMissed], a
	ret

.reset
	ld a, 10 ; 1.0
	ld [wTypeMatchup], a
	ret
