BattleCommand_DamageCalc:
; Prepare damage calculations. (Actual damage calculations will be done when GetCurrentDamage is called with the dirty flag set.)
; Return 1 if successful, else 0.

	call SetDamageDirtyFlag

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar

; Selfdestruct and Explosion double move power.
	cp EFFECT_EXPLOSION
	jr nz, .dont_explode

	ld hl, wCurDamageMovePowerNumerator + 1
	sla [hl]
	dec hl
	rl [hl]

.dont_explode
; Variable-hit moves and Conversion can have a power of 0.
	cp EFFECT_MULTI_HIT
	jr z, .skip_zero_damage_check
	cp EFFECT_CONVERSION
	jr z, .skip_zero_damage_check

; No damage if move power is 0.
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	or [hl]
	jp z, ZeroDamage

.skip_zero_damage_check
	; Item boosts
	call GetUserItem
	ld a, b
	and a
	ld hl, TypeBoostItems
	call nz, DamageCalc_CheckItem

	; Critical hits
	ld a, [wCriticalHitOrOHKO]
	ld hl, wCurDamageFlags
	res 4, [hl]
	res 5, [hl]
	and a
	jr z, .done

	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_SNIPER
	jr nz, .regular_criticals
	set 5, [hl] ; x2.25
	jr .done
.regular_criticals
	set 4, [hl] ; x1.5
.done
	ld a, 1
	and a
	ret
