EndTurn_LeppaBerry:
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	call GetUserItem
	ld a, b
	cp HELD_RESTORE_PP
	ret nz
	ld hl, wPartyMon1PP
	ld a, [wCurBattleMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, wPartyMon1Moves
	ld a, [wCurBattleMon]
	call GetPartyLocation
	ldh a, [hBattleTurn]
	and a
	jr z, .got_moves
	ld de, wWildMonPP
	ld hl, wWildMonMoves
	ld a, [wBattleMode]
	dec a
	jr z, .got_moves
	ld hl, wOTPartyMon1PP
	ld a, [wCurOTMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, wOTPartyMon1Moves
	ld a, [wCurOTMon]
	call GetPartyLocation

.got_moves
	ld c, 0
.loop
	ld a, [hl]
	and a
	ret z
	ld a, [de]
	and $3f
	jr z, .restore
	inc hl
	inc de
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .loop
	ret

.restore
	; lousy hack
	ld a, [hl]
	ld b, 5
	ld a, [de]
	add b
	ld [de], a
	push bc
	push bc
	ld a, [hl]
	ld [wd265], a
	ld de, wBattleMonMoves - 1
	ld hl, wBattleMonPP
	ldh a, [hBattleTurn]
	and a
	jr z, .player_pp
	ld de, wEnemyMonMoves - 1
	ld hl, wEnemyMonPP
.player_pp
	inc de
	pop bc
	ld b, 0
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	pop de
	pop bc

	ld a, [wd265]
	cp [hl]
	jr nz, .skip_checks
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerSubStatus5]
	jr z, .check_transform
	ld a, [wEnemySubStatus5]
.check_transform
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .skip_checks
	ld a, [de]
	add b
	ld [de], a
.skip_checks
	call GetUserItem
	ld a, [hl]
	ld [wd265], a
	xor a
	ld [hl], a
	call GetPartymonItem
	ldh a, [hBattleTurn]
	and a
	jr z, .consume_item
	ld a, [wBattleMode]
	dec a
	jr z, .skip_consumption
	call GetOTPartymonItem

.consume_item
	ld [hl], 0

.skip_consumption
	call GetItemName
	call SwitchTurn
	call ItemRecoveryAnim
	call SwitchTurn
	ld hl, BattleText_UserRecoveredPPUsing
	jp StdBattleTextBox
