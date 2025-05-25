BattleCommand_HiddenPower:
	ld a, [wAttackMissed]
	and a
	ret nz
	; used by AI to avoid attackmiss check -- don't remove
HiddenPowerDamage:
; Override Hidden Power's type and power based on the user's DVs.

	ld hl, wBattleMonDVs
	ldh a, [hBattleTurn]
	and a
	jr z, .got_dvs
	ld hl, wEnemyMonDVs
.got_dvs

; Type:

	; Def & 3
	ld a, [hl]
	and 3
	ld b, a

	; + (Atk & 3) << 2
	ld a, [hl]
	and 3 << 4
	rrca
	rrca
	or b

	add a, LOW(.types)
	ld l, a
	adc HIGH(.types)
	sub a, l
	ld h, a

	ld a, [hl]
; Overwrite the current move type.
	push af
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	pop af
	or SPECIAL << 6
	ld [hl], a
	ret

.types
	db FIGHTING
	db FLYING
	db POISON
	db GROUND
	db ROCK
	db BUG
	db GHOST
	db STEEL
	db FIRE
	db WATER
	db GRASS
	db ELECTRIC
	db PSYCHIC
	db ICE
	db DRAGON
	db DARK
