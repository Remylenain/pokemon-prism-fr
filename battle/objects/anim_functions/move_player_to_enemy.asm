BattleAnimFunction_MoveFromPlayerToEnemyByParam:
	call BattleAnim_AnonJumptable
	dw BattleAnimFunction_MoveFromPlayerToEnemyByParam_DoMove
	dw DeinitBattleAnimation

BattleAnimFunction_MoveFromPlayerToEnemyByParam_DoMove:
	; if x >= 132, do nothing and return no carry
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp 132
	ret nc
	; otherwise, load the param and shift coordinates
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld a, [hl]
	call BattleAnim_ShiftCoordsRightUpHalved
	scf
	ret

BattleAnimFunction_MoveFromPlayerToEnemyByParamAndDisappear:
	call BattleAnimFunction_MoveFromPlayerToEnemyByParam_DoMove
	jp nc, DeinitBattleAnimation
	ret
