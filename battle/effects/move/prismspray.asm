BattleCommand_PrismSpray:
; prismspray
	ld c, 40
	call DelayFrames

.rejection_sampling
	call GenerateRandomType
	cp PRISM_T
	jr z, .rejection_sampling
	ld b, a
	ld hl, wPlayerMoveStructType
	ldh a, [hBattleTurn]
	and a
	jr z, .got_addr
	ld hl, wEnemyMoveStructType
.got_addr
	ld a, b
	or SPECIAL << 6
	ld [hl], a
	ld [wd265], a
	predef GetTypeName
	ld hl, PrismSprayText
	jp StdBattleTextBox
