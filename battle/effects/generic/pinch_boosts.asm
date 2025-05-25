InAPinchBoost:
	call GetUserAbility_IgnoreMoldBreaker
	ld b, a
	ld hl, .abilities - 1
.loop
	inc hl
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr nz, .loop
	ld a, [wTypeMatchup]
	cp [hl]
	ret nz
	callba GetThirdMaxHP
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wEnemyMonHP
.okay
	ld a, [hli]
	cp b
	jr c, .add_half_damage
	ret nz
	ld a, [hl]
	cp c
	jr c, .add_half_damage
	ret nz
.add_half_damage
	jp AddHalfDamage

.abilities
	db ABILITY_OVERGROW, GRASS
	db ABILITY_BLAZE,    FIRE
	db ABILITY_TORRENT,  WATER
	db ABILITY_SWARM,    BUG
	db -1
