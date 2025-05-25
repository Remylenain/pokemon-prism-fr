BattleCommand_StatUpAnim:
	ld a, [wAttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	xor a
	jr BattleCommand_StatUpDownAnim

BattleCommand_StatDownAnim:
	ld a, [wAttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	ldh a, [hBattleTurn]
	and a
	ld a, BATTLEANIM_ENEMY_STAT_DOWN
	jr z, BattleCommand_StatUpDownAnim
	ld a, BATTLEANIM_WOBBLE
	; fallthrough

BattleCommand_StatUpDownAnim:
	ld [wNumHits], a
	xor a
	ld [wBattleAnimParam], a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	jp PlayFXAnimID

StatUpAnimation:
	ld hl, wPlayerMinimized
	ldh a, [hBattleTurn]
	and a
	jr z, .do_player
	ld hl, wEnemyMinimized
.do_player
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp MINIMIZE
	ret nz

	ld [hl], 1
	call CheckBattleScene
	ret nc

	xor a
	ldh [hBGMapMode], a
	call BattleCommand_LowerSubNoAnim
	jp BattleCommand_MoveDelay
