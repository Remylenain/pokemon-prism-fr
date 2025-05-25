DoStatUpCheck:
; Stat-up by opponent (Contrary/Swagger)
	call SwitchTurn
	call CheckSubstituteOpp
	jr z, .no_sub
	call SwitchTurn
	jr StatUpFailed
.no_sub
	call SwitchTurn
	; fallthrough
DoStatUp:
	call CheckIfStatCanBeRaised
	ld a, [wFailedMessage]
	and a
	ret nz
	jp StatUpAnimation

StatUpFailed:
	ld a, 1
	ld [wFailedMessage], a
	ret

CheckIfStatCanBeRaised:
	; confusingly-named function - if the stat can be raised, it will also raise it
	ld hl, wPlayerStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .got_stat_levels
	ld hl, wEnemyStatLevels
.got_stat_levels
	ld a, [wAttackMissed]
	and a
	jr nz, StatUpFailed
	ld a, [wEffectFailed]
	and a
	jr nz, StatUpFailed
	ld a, [wRaisedStat]
	and $f
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	inc b
	ld a, 13
	cp b
	jr c, .cant_raise_stat
	push bc
	ld a, [wRaisedStat]
	and $f0
	jr z, .got_num_stages
	swap a
	ld c, a
.stat_up_stage_loop
	inc b
	ld a, 13
	cp b
	jr c, .not_maxed
	dec c
	jr nz, .stat_up_stage_loop
	jr .got_num_stages

.not_maxed
	ld b, a
.got_num_stages
	ld [hl], b
	pop bc
	push hl
	ld a, c
	cp 5
	jr nc, .done_calcing_stats
	ld hl, wBattleMonStats
	ld de, wPlayerStats
	ldh a, [hBattleTurn]
	and a
	jr z, .got_stats_pointer
	ld hl, wEnemyMonStats
	ld de, wEnemyStats
.got_stats_pointer
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	pop bc
	ldh a, [hBattleTurn]
	and a
	jr z, .calc_player_stats
	call CalcEnemyStats
	jr .done_calcing_stats

.calc_player_stats
	call CalcPlayerStats
.done_calcing_stats
	pop hl
	xor a
	ld [wFailedMessage], a
	ret

.cant_raise_stat
	; fallthrough

StatUpDown_MistFail:
	ld a, 2
	ld [wFailedMessage], a
	dec a
	ld [wAttackMissed], a
	ret

StatDown_AbilityFail:
	ld a, 4
	ld [wFailedMessage], a
	ld a, 1
	ld [wAttackMissed], a
	ret

StatDownFailed:
	ld a, 1
	ld [wFailedMessage], a
	ld [wAttackMissed], a
	ret

DoStatDownCheck:
	; We need this to handle Curse/Contrary properly
	call CheckSubstituteOpp
	jr nz, StatDownFailed

	ld a, [wLoweredStat]
	and $f
	jr z, .hyper_cutter
	cp ACCURACY
	jr nz, .no_specific_stat
	call KeenEyeCheck
	jr .ability_check

.hyper_cutter
	call HyperCutterCheck
.ability_check
	jr z, StatDown_AbilityFail
.no_specific_stat
	call WhiteSmokeCheck
	jr z, StatDown_AbilityFail

	call CheckMist
	jr z, StatUpDown_MistFail
	; fallthrough

DoStatDown:
	ld a, [wAttackMissed]
	and a
	jr nz, StatDownFailed

	ld a, [wEffectFailed]
	and a
	jr nz, StatDownFailed

	ld hl, wEnemyStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .GetStatLevel
	ld hl, wPlayerStatLevels

.GetStatLevel
; Attempt to lower the stat.
	ld a, [wLoweredStat]
	and $f
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	dec b
	jr z, .CantLower

; Sharply lower the stat if applicable.
	ld a, [wLoweredStat]
	and $f0
	jr z, .DidntMiss
	swap a
.lower_loop
	dec b
	jr z, .min_stat
	dec a
	jr nz, .lower_loop
	jr .DidntMiss

.min_stat
	inc b
.DidntMiss

; Accuracy/Evasion reduction don't involve stats.
	ld [hl], b
	ld a, c
	cp ACCURACY
	jr nc, .Hit

	push hl
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyStats
	ldh a, [hBattleTurn]
	and a
	jr z, .do_enemy
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerStats
.do_enemy
	call TryLowerStat
	pop hl
	jr z, .CouldntLower

.Hit
	xor a
	ld [wFailedMessage], a
	ret

.CouldntLower
	inc [hl]
.CantLower
	ld a, 3
	ld [wFailedMessage], a
	ld a, 1
	ld [wAttackMissed], a
	ret

TryLowerStat:
; Lower stat c from stat struct hl (buffer de).

	push bc
	sla c
	ld b, 0
	add hl, bc
	; add de, c
	ld a, c
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	pop bc

; The lowest possible stat is 1.
	ld a, [hld]
	dec a
	jr nz, .not_min
	ld a, [hl]
	and a
	ret z

.not_min
	ldh a, [hBattleTurn]
	and a
	jr z, .Player

	call SwitchTurn
	call CalcPlayerStats
	call SwitchTurn
	jr .end

.Player
	call SwitchTurn
	call CalcEnemyStats
	call SwitchTurn
.end
	ld a, 1
	and a
	ret
