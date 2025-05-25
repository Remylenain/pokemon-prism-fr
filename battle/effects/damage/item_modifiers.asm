DamageCalc_CheckItem:
	; in: hl: table of held item effects that boost damage based on type, and matching types; b: held item effect; c: held item parameter

.loop
	ld a, [hli]
	cp $ff
	ret z

	; Item effect
	cp b
	ld a, [hli]
	jr nz, .loop

	; Type
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	push de
	ld d, a
	and $3f
	cp b
	ld a, d
	pop de
	jr z, .ok
	or $3f
	cp b
	ret nz
.ok
	; * 100 + item effect amount
	ld a, c
	add a, 100
	ld [wCurDamageItemModifier], a
	ret

TypeBoostItems:
	db HELD_NORMAL_BOOST,   NORMAL                ; Silk Scarf
	db HELD_FIGHTING_BOOST, FIGHTING              ; Blackbelt
	db HELD_FLYING_BOOST,   FLYING                ; Sharp Beak
	db HELD_POISON_BOOST,   POISON                ; Poison Barb
	db HELD_GROUND_BOOST,   GROUND                ; Soft Sand
	db HELD_ROCK_BOOST,     ROCK                  ; Hard Stone
	db HELD_BUG_BOOST,      BUG                   ; Silverpowder
	db HELD_GHOST_BOOST,    GHOST                 ; Spell Tag
	db HELD_FIRE_BOOST,     FIRE                  ; Charcoal
	db HELD_WATER_BOOST,    WATER                 ; Mystic Water
	db HELD_GRASS_BOOST,    GRASS                 ; Miracle Seed
	db HELD_ELECTRIC_BOOST, ELECTRIC              ; Magnet
	db HELD_PSYCHIC_BOOST,  PSYCHIC               ; Twistedspoon
	db HELD_ICE_BOOST,      ICE                   ; Nevermeltice
	db HELD_DRAGON_BOOST,   DRAGON                ; Dragon Scale
	db HELD_DARK_BOOST,     DARK                  ; Blackglasses
	db HELD_FAIRY_BOOST,    FAIRY                 ; Pink Bow
	db HELD_GAS_BOOST,      GAS                   ; Cigarette
	db HELD_SOUND_BOOST,    SOUND                 ; Megaphone
	db HELD_PHYSICAL_BOOST, (PHYSICAL << 6) | $3f ; Muscle Band
	db HELD_SPECIAL_BOOST,  (SPECIAL << 6) | $3f  ; Wise Glasses
	db $ff

LightBallBoost:
; If the attacking monster is Pikachu and it's
; holding a Light Ball, double the attack stat.
	ld a, MON_SPECIES
	call BattlePartyAttr

	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr z, .compare_species
	ld a, [wTempEnemyMonSpecies]
.compare_species
	cp PIKACHU
	ret nz

	call GetUserItem
	ld a, [hl]
	cp LIGHT_BALL
	ret nz

; Double the stat
	ld hl, wCurDamageAttack + 1
	sla [hl]
	dec hl
	rl [hl]
	jp SetDamageDirtyFlag

CheckEviolite:
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonItem
	jr z, .loaded_mon
	ld hl, wBattleMonItem
.loaded_mon
	ld a, [hld] ; species comes before item
	cp EVIOLITE
	ret nz
	ld a, [hl]
	callba CheckSpeciesEvolves
	ret z
	jp IncrementDefenseMod

DittoMetalPowder:
	ld a, MON_SPECIES
	call BattlePartyAttr
	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr nz, .check_ditto
	ld a, [wTempEnemyMonSpecies]

.check_ditto
	cp DITTO
	ret nz

	call GetOpponentItem
	ld a, [hl]
	cp METAL_POWDER
	ret nz

	ld hl, wCurDamageDefense + 1
	sla [hl]
	dec hl
	rl [hl]
	jp SetDamageDirtyFlag
