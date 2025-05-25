GetAbilityDamageModifier:
	call GetTargetAbility
	ld b, a
	ld hl, .AbilityTypeMatchups - 2
.next
	inc hl
	inc hl
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr nz, .next
	cp ABILITY_SOUNDPROOF
	jr nz, .not_soundproof
	call IsSoundBasedMove
	jr nc, .next
	jr .done
.not_soundproof
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp [hl]
	jr nz, .next
.done
	inc hl
	ld a, [hl]
	scf
	ret

.AbilityTypeMatchups:
	db ABILITY_LEVITATE,     GROUND,   0
	db ABILITY_SOUNDPROOF,   SOUND,    0
	db ABILITY_LIGHTNINGROD, ELECTRIC, 0
	db ABILITY_MOTOR_DRIVE,  ELECTRIC, 0
	db ABILITY_FLASH_FIRE,   FIRE,     0
	db ABILITY_VOLT_ABSORB,  ELECTRIC, 0
	db ABILITY_WATER_ABSORB, WATER,    0
	db ABILITY_HEATPROOF,    FIRE,     1
	db ABILITY_THICK_FAT,    FIRE,     1
	db ABILITY_THICK_FAT,    ICE,      1
	db $ff
