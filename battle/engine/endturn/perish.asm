EndTurn_PerishSong:
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	ld hl, wPlayerPerishCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_count
	ld hl, wEnemyPerishCount

.got_count
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVar
	bit SUBSTATUS_PERISH, a
	ret z
	dec [hl]
	ld a, [hl]
	ld [wd265], a
	push af

	ld hl, PerishCountText
	push hl
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	jr z, .pop
	pop hl
	ld hl, FinalChanceText
	jr .print

.pop
	pop hl
.print
	call StdBattleTextBox
	pop af
	jr z, .kill_mon

	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	ret z

	; Final Chance healing animation
	ld de, FINAL_CHANCE
	ld a, 1
	ld [wBattleAnimParam], a
	xor a
	ld [wNumHits], a
	call Call_PlayBattleAnim_OnlyIfVisible

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]
	ld a, BATTLE_VARS_SEMISTATUS
	call GetBattleVarAddr
	res SEMISTATUS_TOXIC, [hl]
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonHP
	ld de, wBattleMonStatus
	jr z, .okay
	ld hl, wEnemyMonHP
	ld de, wEnemyMonStatus
.okay
	xor a
	ld [de], a
	ld d, h
	ld e, l
	ld a, [hli]
	ld [wCurHPAnimOldHP + 1], a
	ld a, [hli]
	ld [wCurHPAnimOldHP], a
	ld a, [hli]
	ld [de], a
	inc de
	ld [wCurHPAnimMaxHP + 1], a
	ld [wCurHPAnimNewHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wCurHPAnimMaxHP], a
	ld [wCurHPAnimNewHP], a
	call UpdateHPBarBattleHuds
	call UpdateUserInParty
	ld hl, FinalChanceHealedText
	jp StdBattleTextBox

.kill_mon
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_PERISH, [hl]
	ldh a, [hBattleTurn]
	and a
	jr nz, .kill_enemy
	ld hl, wBattleMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wPartyMon1HP
	ld a, [wCurBattleMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret

.kill_enemy
	ld hl, wEnemyMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld a, [wBattleMode]
	dec a
	ret z
	ld hl, wOTPartyMon1HP
	ld a, [wCurOTMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret
