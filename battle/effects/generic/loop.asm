BattleCommand_StartLoop:
	ld hl, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyRolloutCount
.ok
	xor a
	ld [hl], a
	ret

BattleCommand_EndLoop:
; Loop back to the command before 'critical'.

	ld de, wPlayerRolloutCount
	ld bc, wPlayerDamageTaken
	ldh a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld de, wEnemyRolloutCount
	ld bc, wEnemyDamageTaken
.got_addrs

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_IN_LOOP, [hl]
	jp nz, .in_loop
	set SUBSTATUS_IN_LOOP, [hl]

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	ld a, [hl]
	cp EFFECT_TWINEEDLE
	jr z, .twineedle
	cp EFFECT_DOUBLE_HIT
	ld a, 1
	jr z, .double_hit
	ld a, [hl]

.resample
	call BattleRandom
	and 7
	cp 6
	jr nc, .resample
	and 3
	inc a
.double_hit
	ld [de], a
	inc a
	ld [bc], a
	jr .loop_back_to_critical

.twineedle
	ld a, 1
	jr .double_hit

.in_loop
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .loop_back_to_critical
.done_loop
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_IN_LOOP, [hl]

	ld hl, PlayerHitTimesText
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hit_n_times_text
	ld hl, EnemyHitTimesText
.got_hit_n_times_text

	push bc
	call StdBattleTextBox

	pop bc
	xor a
	ld [bc], a
	ret

; Loop back to the command before 'critical'.
.loop_back_to_critical
	ld hl, wBattleScriptBufferLoc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.not_critical
	ld a, [hld]
	cp critical_command
	jr nz, .not_critical
	inc hl
	ld a, h
	ld [wBattleScriptBufferLoc + 1], a
	ld a, l
	ld [wBattleScriptBufferLoc], a
	ret
