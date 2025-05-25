DisplayLinkRecord:
	sbk BANK(sLinkBattleStats)
	call ReadAndPrintLinkBattleRecord
	scls
	hlcoord 0, 0, wAttrMap
	xor a
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	call ApplyAttrAndTilemapInVBlank
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	ld c, 8
	call DelayFrames
	jp WaitPressAorB_BlinkCursor

ReadAndPrintLinkBattleRecord:
	call ClearTileMap
	call ClearSprites
	call .print_battle_record
	hlcoord 0, 8
	ld b, 5
	ld de, sLinkBattleRecord + 2
.loop
	push bc
	push hl
	push de
	ld a, [de]
	and a
	jr z, .print_dashes
	ld a, [wSavedAtLeastOnce]
	and a
	jr z, .print_dashes
	push hl
	push hl
	ld h, d
	ld l, e
	ld de, wBufferMonNick
	ld bc, 10
	rst CopyBytes
	ld a, "@"
	ld [de], a
	inc de
	ld bc, 6
	rst CopyBytes
	ld de, wBufferMonNick
	pop hl
	call PlaceString
	pop hl
	ld de, 26
	add hl, de
	push hl
	ld de, wBufferMonOT
	lb bc, 2, 4
	push bc
	call PrintNum
	pop bc
	pop hl
	ld de, 5
	add hl, de
	push hl
	ld de, wBufferMonOT + 2
	push bc
	call PrintNum
	pop bc
	pop hl
	ld de, 5
	add hl, de
	ld de, wBufferMonOT + 4
	call PrintNum
	jr .next
.print_dashes
	ld de, LinkBattleRecordDashesText
	call PlaceText
.next
	pop hl
	ld bc, 18
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

.print_battle_record
	hlcoord 1, 0
	ld de, LinkBattleRecordTitleText
	call PlaceText

	hlcoord 0, 6
	ld de, LinkBattleRecordHeadersText
	call PlaceText

	hlcoord 0, 2
	ld de, LinkBattleRecordTotalsText
	call PlaceText

	hlcoord 6, 4
	ld de, sLinkBattleWins
	call .print_zeros_if_no_savefile
	ret c

	lb bc, 2, 4
	push bc
	call PrintNum

	hlcoord 11, 4
	ld de, sLinkBattleLosses
	call .print_zeros_if_no_savefile

	pop bc
	push bc
	call PrintNum

	hlcoord 16, 4
	ld de, sLinkBattleDraws
	call .print_zeros_if_no_savefile

	pop bc
	jp PrintNum

.print_zeros_if_no_savefile
	ld a, [wSavedAtLeastOnce]
	and a
	ret nz
	ld de, LinkBattleRecordZeroScoresText
	jp PlaceText
