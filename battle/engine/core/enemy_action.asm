ParseEnemyAction:
	ld a, [wEnemyIsSwitching]
	and a
	ret nz
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
	ld a, [wBattlePlayerAction]
	and a
	call z, LinkBattleSendReceiveAction
	call Call_LoadTempTileMapToTileMap
	ld a, [wBattleAction]
	cp BATTLEACTION_STRUGGLE
	jp z, .struggle
	cp BATTLEACTION_SKIPTURN
	jp z, .set_current_move_to_skip
	cp BATTLEACTION_SWITCH1
	jp nc, ResetVarsForSubStatusRage
	ld [wCurEnemyMoveNum], a
	ld c, a
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_ROLLOUT, a
	jr nz, .skip_load
	ld a, [wEnemySubStatus3]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE ; | 1 << SUBSTATUS_BIDE
	jr nz, .skip_load

	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ld a, [wLastEnemyMove]
	jr nz, .load_current_move
	ld hl, wEnemyMonMoves
	ld b, 0
	add hl, bc
	ld a, [hl]
	jr .load_current_move

.not_linked
	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ld a, [wLastEnemyMove]
	jr nz, .load_current_move
	call CheckEnemyLockedIn
	jp nz, ResetVarsForSubStatusRage
	ld hl, wEnemyMonMoves - 1
	ld de, wEnemyMonPP - 1
	ld b, NUM_MOVES + 1
.check_available_move_loop
	inc hl
	inc de
	dec b
	jr z, .struggle
	ld a, [hl]
	and a
	jr z, .struggle
	ld a, [wEnemyDisabledMove]
	cp [hl]
	jr z, .check_available_move_loop
	ld a, [de]
	and $3f
	jr z, .check_available_move_loop
	ld a, [wBattleMode]
	dec a
	jr nz, .skip_load
	; wild mon - use a random move
.select_random_move_loop
	ld hl, wEnemyMonMoves
	call BattleRandom
	assert NUM_MOVES == 4
	and 3
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wEnemyDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .select_random_move_loop
	ld a, [hl]
	and a
	jr z, .select_random_move_loop
	ld hl, wEnemyMonPP
	add hl, bc
	ld b, a
	ld a, [hl]
	and $3f
	jr z, .select_random_move_loop
	ld a, c
	ld [wCurEnemyMoveNum], a
	ld a, b
.load_current_move
	ld [wCurEnemyMove], a
.skip_load
	call SetEnemyTurn
	callba UpdateMoveData
	call CheckEnemyLockedIn
	jr nz, .raging
	xor a
	ld [wEnemyCharging], a
.raging
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_FURY_CUTTER
	jr z, .fury_cutter
	xor a
	ld [wEnemyFuryCutterCount], a
.fury_cutter
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_RAGE
	jr z, .no_rage
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]
.no_rage
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_PROTECT
	ret z
	cp EFFECT_ENDURE
	ret z
	xor a
	ld [wEnemyProtectCount], a
	ret

.struggle
	ld a, STRUGGLE
	jr .load_current_move

.set_current_move_to_skip
	ld a, $ff
	jr .load_current_move
