BattleCommand_ClearMissDamage:
	ld a, [wAttackMissed]
	and a
	ret z
	jp ZeroDamage

BattleCommand_CheckCharge:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_CHARGED, [hl]
	ret z
	res SUBSTATUS_CHARGED, [hl]
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	ld b, charge_command
	jpba SkipToBattleCommand

ClearLastMove:
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a

	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ret

CheckUserMove:
; Return z if the user has move a.
	ld b, a
	ld de, wBattleMonMoves
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wEnemyMonMoves
.ok
	ld c, NUM_MOVES
.loop
	ld a, [de]
	inc de
	cp b
	ret z

	dec c
	jr nz, .loop

	dec c ;sets c = $ff, and thus nz
	ret

ResetTurn_PowerHerb:
	; If already called from a seperate move, don't change charging.
	; Otherwise, mark as repeated due to Power Herb
	call CheckUserIsCharging
	ld a, 2
	jr z, _ResetTurn
	jr ResetTurn

UpdateMoveDataAndResetTurn:
	callba UpdateMoveData
	; fallthrough

ResetTurn:
	ld a, 1
	; fallthrough
_ResetTurn:
	push af
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerCharging
	jr z, .player
	ld hl, wEnemyCharging

.player
	pop af
	ld [hl], a
	xor a
	ld [wAlreadyDisobeyed], a
	callba DoMove
	jp EndMoveEffect
