BattleCommand_DamageStats:
	ldh a, [hBattleTurn]
	and a
	jp nz, EnemyAttackDamage
	; fallthrough

PlayerAttackDamage:
	; Load level, move power, attack and defense for the player attacking and the enemy defending.

	call ResetDamage
	call SetDamageDirtyFlag

	ld hl, wPlayerMoveStructPower
	ld a, [hli]
	and a
	jp z, ZeroDamage
	push hl
	ld hl, wCurDamageMovePowerNumerator
	ld [hl], 0
	inc hl
	ld [hli], a
	ld [hl], 1

	ld a, [wPlayerAbility]
	call AbilityBasePowerBoosts

	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FLASH_FIRE, a
	call nz, FlashFireBuff

	pop hl
	ld a, [hl]
	add a, a
	jp c, ZeroDamage
	add a, a
	jr c, .special

.physical
	ld hl, wEnemyMonDefense
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wEnemyScreens]
	bit SCREENS_REFLECT, a
	jr z, .no_physical_screen
	add hl, hl
.no_physical_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld hl, wBattleMonAttack
	call CheckCriticalDiscardStatBoosts
	jr c, .load_attack

	ld a, e
	and a
	jr z, .physicaldefokay
	push hl
	ld hl, wEnemyStats + DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.physicaldefokay
	ld a, d
	and a
	jr z, .load_attack
	ld hl, wPlayerStats + ATTACK * 2
.load_attack
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
	call PhysicalAbilityModifiers
	jr .done

.special
	ld hl, wEnemyMonSpclDef
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wEnemyScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .no_special_screen
	add hl, hl
.no_special_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld a, [wPlayerMoveStructAnimation]
	cp FUTURE_SIGHT
	ld hl, wPlayerFutureSightUsersSpAtk
	jr z, .got_sp_atk
	ld hl, wBattleMonSpclAtk
.got_sp_atk
	call CheckCriticalDiscardStatBoosts
	jr c, .load_sp_atk

	ld a, e
	and a
	jr z, .specialdefokay
	push hl
	ld hl, wEnemyStats + SP_DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.specialdefokay
	ld a, d
	and a
	jr z, .load_sp_atk
	ld hl, wPlayerStats + SP_ATTACK * 2

.load_sp_atk
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
	call RockBoostInSand
.done

	call CheckEviolite
	ld a, [wPlayerMoveStructAnimation]
	cp FUTURE_SIGHT
	ld a, [wBattleMonLevel]
	jr nz, .got_level
	ld a, [wPlayerFutureSightLevel]
	and $7f
.got_level
	ld [wCurDamageLevel], a
	call DittoMetalPowder

	ld a, 1
	and a
	ret

EnemyAttackDamage:
	; Load level, move power, attack and defense for the enemy attacking and the player defending.
	call ResetDamage
	call SetDamageDirtyFlag

	; No damage dealt with 0 power.
	ld hl, wEnemyMoveStructPower
	ld a, [hli] ; hl = wEnemyMoveStructType
	ld d, a
	and a
	jp z, ZeroDamage
	push hl
	ld hl, wCurDamageMovePowerNumerator
	ld [hl], 0
	inc hl
	ld [hli], a
	ld [hl], 1

	ld a, [wEnemyAbility]
	call AbilityBasePowerBoosts

	ld a, [wEnemySubStatus2]
	bit SUBSTATUS_FLASH_FIRE, a
	call nz, FlashFireBuff

	pop hl
	ld a, [hl]
	add a, a
	jp c, ZeroDamage
	add a, a
	jr c, .special

.physical
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wPlayerScreens]
	bit SCREENS_REFLECT, a
	jr z, .no_physical_screen
	add hl, hl
.no_physical_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld hl, wEnemyMonAttack

	call CheckCriticalDiscardStatBoosts
	jr c, .load_attack

	ld a, e
	and a
	jr z, .physicaldefokay
	push hl
	ld hl, wPlayerStats + DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.physicaldefokay
	ld a, d
	and a
	jr z, .load_attack
	ld hl, wEnemyStats + ATTACK * 2
.load_attack
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
	call PhysicalAbilityModifiers
	jr .done

.special
	ld hl, wBattleMonSpclDef
	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [wPlayerScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .no_special_screen
	add hl, hl
.no_special_screen
	ld a, h
	ld b, l
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b

	ld a, [wEnemyMoveStructAnimation]
	cp FUTURE_SIGHT
	ld hl, wEnemyFutureSightUsersSpAtk
	jr z, .got_sp_atk
	ld hl, wEnemyMonSpclAtk
.got_sp_atk
	call CheckCriticalDiscardStatBoosts
	jr c, .load_sp_atk

	ld a, e
	and a
	jr z, .specialdefokay
	push hl
	ld hl, wPlayerStats + SP_DEFENSE * 2
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageDefense
	ld [hli], a
	ld [hl], b
	pop hl
.specialdefokay
	ld a, d
	and a
	jr z, .load_sp_atk
	ld hl, wEnemyStats + SP_ATTACK * 2

.load_sp_atk
	ld a, [hli]
	ld b, [hl]
	ld hl, wCurDamageAttack
	ld [hli], a
	ld [hl], b
	call LightBallBoost
	call RockBoostInSand
.done

	call CheckEviolite
	ld a, [wEnemyMoveStructAnimation]
	cp FUTURE_SIGHT
	ld a, [wEnemyMonLevel]
	jr nz, .got_level
	ld a, [wEnemyFutureSightLevel]
	and $7f
.got_level
	ld [wCurDamageLevel], a
	call DittoMetalPowder

	ld a, 1
	and a
	ret
