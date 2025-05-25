EndTurn_FutureSight:
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	ld hl, wPlayerFutureSightCount
	ldh a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wEnemyFutureSightCount

.okay
	ld a, [hl]
	and a
	ret z
	dec a
	ld [hl], a
	cp 1
	ret nz

	ld hl, BattleText_TargetWasHitByFutureSight
	call StdBattleTextBox

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	push af
	ld a, FUTURE_SIGHT
	ld [hl], a

	callba UpdateMoveData
	xor a
	ld [wAttackMissed], a
	ld [wAlreadyDisobeyed], a
	ld a, 10
	ld [wTypeModifier], a
	callba DoMove
	call ResetDamage

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	pop af
	ld [hl], a

	call UpdateBattleMonInParty
	jp UpdateEnemyMonInParty
