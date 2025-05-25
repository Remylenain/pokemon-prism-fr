CheckPlayerAbilityPreventsEscaping:
	ld a, [wPlayerAbility]
	cp ABILITY_MAGNET_PULL
	jr z, CheckEnemyIsSteelTypeForMagnetPull
	xor ABILITY_ARENA_TRAP
	ret nz
	ld a, [wEnemyAbility]
	cp ABILITY_LEVITATE
	ret z
	ld hl, wEnemyMonType
	jr ArenaTrapTypeCheck

CheckEnemyAbilityPreventsEscaping:
	ld a, [wEnemyAbility]
	cp ABILITY_MAGNET_PULL
	jr z, CheckPlayerIsSteelTypeForMagnetPull
	xor ABILITY_ARENA_TRAP
	ret nz
	ld a, [wPlayerAbility]
	cp ABILITY_LEVITATE
	ret z
	ld hl, wBattleMonType
	; fallthrough
ArenaTrapTypeCheck:
	ld a, [hli]
	call .type_check
	ret z
	ld a, [hl]
.type_check
	cp FLYING
	ret z
	cp BIRD
	ret z
	cp GHOST
	ret z
	scf
	ret

CheckEnemyIsSteelTypeForMagnetPull:
	ld hl, wEnemyMonType
	jr CheckOpponentIsSteelTypeForMagnetPull

CheckPlayerIsSteelTypeForMagnetPull:
	ld hl, wBattleMonType
CheckOpponentIsSteelTypeForMagnetPull:
	ld a, [hli]
	cp STEEL
	jr z, .steel
	ld a, [hl]
	cp STEEL
	jr z, .steel
	and a
	ret

.steel
	scf
	ret
