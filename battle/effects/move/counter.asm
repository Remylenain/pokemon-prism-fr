BattleCommand_Counter:
	ld a, 1
	ld [wAttackMissed], a
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	ret z

	ld b, a
	callba GetMoveEffect
	ld a, b
	cp EFFECT_COUNTER
	ret z

	call BattleCommand_ResetTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ret z

	call CheckOpponentWentFirst
	ret z

	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	dec a
	ld de, wStringBuffer1
	call GetMoveData

	ld a, [wStringBuffer1 + 2]
	and a
	ret z

	ld a, [wStringBuffer1 + 3]
	and $c0
	ret nz

	; Saved last damage in wSavedDamage
	ld hl, wSavedDamage
	ld a, [hli]
	ld d, a
	or [hl]
	ret z

	ld e, [hl]
	ld hl, wCurDamageFlags
	ld a, $c0 ;fixed damage, dirty
	ld [hli], a
	; hl = wCurDamageFixedValue
	sla e
	rl d
	jr nc, .not_capped
	ld de, $ffff
.not_capped
	ld a, d
	ld [hli], a
	ld [hl], e
	xor a
	ld [wAttackMissed], a
	ret
