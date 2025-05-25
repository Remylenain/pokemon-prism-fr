DetermineMoveOrder:
	ld a, [wLinkMode]
	and a
	jr z, .use_move
	ld a, [wBattleAction]
	cp BATTLEACTION_STRUGGLE
	jr z, .use_move
	cp BATTLEACTION_SKIPTURN
	jr z, .use_move
	sub BATTLEACTION_SWITCH1
	jr c, .use_move
	ld a, [wBattlePlayerAction]
	cp 2
	jr nz, .switch
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .player_2

	call BattleRandom
	add a, a
	ret

.player_2
	call BattleRandom
	add a, a
	ccf
	ret

.switch
	callba AI_Switch
.enemy_first
	and a
	ret

.use_move
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_GUARDING, a
	jr nz, .player_first
	ld a, [wBattlePlayerAction]
	and a
	jr nz, .player_first
	call CompareMovePriority
	ret c ;player_first
	jr nz, .enemy_first

.equal_priority
	call CheckSpeedWithQuickClaw
	jr nz, .enemy_first
.player_first
	scf
	ret

CompareMovePriority:
; Compare the priority of the player and enemy's moves.
; Return carry if the player goes first, or z if they match.
	ld a, [wPlayerAbility]
	cp ABILITY_STALL
	jr z, .player_stall
	ld a, [wEnemyAbility]
	cp ABILITY_STALL
	jr z, .enemy_stall
.compare_priorities
	ld a, [wCurPlayerMove]
	call GetMovePriority
	ld b, a
	push bc
	ld a, [wCurEnemyMove]
	call GetMovePriority
	pop bc
	cp b
	ret

.player_stall
	ld a, [wEnemyAbility]
	cp ABILITY_STALL
	jr z, .compare_priorities
	; Only player has Stall
	call .compare_priorities
	ret nz
	inc a
	ret

.enemy_stall
	; Only enemy has Stall
	call .compare_priorities
	ret nz
	scf
	ret

GetMovePriority:
; Return the priority (0-3) of move a.

	ld b, a

	call GetMoveEffect
	ld hl, .priorities
.loop
	ld a, [hli]
	cp b
	jr z, .done
	inc hl
	cp -1
	jr nz, .loop

	ld a, 1
	ret

.done
	ld a, [hl]
	ret

.priorities
	db EFFECT_PROTECT,      3
	db EFFECT_ENDURE,       3
	db EFFECT_PRIORITY_HIT, 2
	db EFFECT_WHIRLWIND,    0
	db EFFECT_COUNTER,      0
	db -1
