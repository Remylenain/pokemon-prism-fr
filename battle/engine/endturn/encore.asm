EndTurn_Encore:
	call CheckSpeed
	jr z, .player_first

	call .do_enemy
.do_player
	ld hl, wPlayerSubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ret z
	ld a, [wPlayerEncoreCount]
	dec a
	ld [wPlayerEncoreCount], a
	jr z, .end_player_encore
	ld hl, wBattleMonPP
	ld a, [wCurMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and $3f
	ret nz

.end_player_encore
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_ENCORED, [hl]
	call SetEnemyTurn
	ld hl, BattleText_TargetsEncoreEnded
	jp StdBattleTextBox

.player_first
	call .do_player
.do_enemy
	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ret z
	ld a, [wEnemyEncoreCount]
	dec a
	ld [wEnemyEncoreCount], a
	jr z, .end_enemy_encore
	ld hl, wEnemyMonPP
	ld a, [wCurEnemyMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and $3f
	ret nz

.end_enemy_encore
	ld hl, wEnemySubStatus5
	res SUBSTATUS_ENCORED, [hl]
	call SetPlayerTurn
	ld hl, BattleText_TargetsEncoreEnded
	jp StdBattleTextBox
