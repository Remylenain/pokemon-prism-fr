ParsePlayerAction:
	call CheckPlayerLockedIn
	jp c, .locked_in
	ld hl, wPlayerSubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	jr z, .not_encored
	ld a, [wLastPlayerMove]
	ld [wCurPlayerMove], a
	jr .encored

.not_encored
	ld a, [wBattlePlayerAction]
	cp 2
	jr z, .reset_rage
	and a
	jr nz, .locked_in
	xor a
	ld [wMoveSelectionMenuType], a
	assert POUND == 1
	inc a
	ld [wFXAnimIDLo], a
	call MoveSelectionScreen
	push af
	call Call_LoadTempTileMapToTileMap
	call UpdateBattleHuds
	ld a, [wCurPlayerMove]
	cp STRUGGLE
	call nz, PlayClickSFX
	ld a, 1
	ldh [hBGMapMode], a
	pop af
	ret nz

.encored
	call SetPlayerTurn
	callba UpdateMoveData
	xor a
	ld [wPlayerCharging], a
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_FURY_CUTTER
	jr z, .continue_fury_cutter
	xor a
	ld [wPlayerFuryCutterCount], a
.continue_fury_cutter
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_RAGE
	jr z, .continue_rage
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]
.continue_rage
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_PROTECT
	jr z, .continue_protect
	cp EFFECT_ENDURE
	jr z, .continue_protect
	xor a
	ld [wPlayerProtectCount], a
	jr .continue_protect
.locked_in
	xor a
	ld [wPlayerFuryCutterCount], a
	ld [wPlayerProtectCount], a
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]
.continue_protect
	call ParseEnemyAction
	xor a
	ret

.reset_rage
	xor a
	ld [wPlayerFuryCutterCount], a
	ld [wPlayerProtectCount], a
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]
	ret
