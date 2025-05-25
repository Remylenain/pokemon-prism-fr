EndTurn_Leftovers:
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	call GetUserItem
	ld a, b
	cp HELD_LEFTOVERS
	ret nz
	ld a, [hl]
	ld [wd265], a
	call GetItemName

	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP

.got_hp
; Don't restore if we're already at max HP
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	jr nz, .restore
	ld a, [hl]
	cp c
	ret z

.restore
	call GetSixteenthMaxHP
	call SwitchTurn
	call RestoreOpponentHP
	ld hl, BattleText_TargetRecoveredWithItem
	call StdBattleTextBox
	jp SwitchTurn
