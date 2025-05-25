_LoadTradeScreenBorder:
	ld de, LinkCommsBorderGFX
	ld hl, vBGTiles
	lb bc, BANK(LinkCommsBorderGFX), 70
	jp Get2bpp

LoadMobileLinkTradeFullscreenTilemap:
	ld hl, MobileLinkTradeFullscreenTilemap
	decoord 0, 0
	jp _Decompress

LoadCableLinkTradeFullscreenTilemap:
	call LoadMobileLinkTradeFullscreenTilemap
	hlcoord 3, 16
	ld a, $27
	ld c, 3
	call .load
	hlcoord 1, 17
	ld [hl], $0f
	inc hl
	ld c, 5
.load
	ld [hli], a
	inc a
	dec c
	jr nz, .load
	ret

LinkTextBox:
	ld h, d
	ld l, e
Predef_LinkTextbox:
	push bc
	push hl
	call .draw_border
	pop hl
	pop bc

	ld de, wAttrMap - wTileMap
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, 7
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .row
	ret

.draw_border
	push hl
	ld a, $30
	ld [hli], a
	inc a
	call .fill_row
	inc a
	ld [hl], a
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
.loop
	push hl
	ld a, $33
	ld [hli], a
	ld a, " "
	call .fill_row
	ld [hl], $34
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .loop

	ld a, $35
	ld [hli], a
	inc a
	call .fill_row
	ld [hl], $37
	ret

.fill_row
	ld d, c
.row_loop
	ld [hli], a
	dec d
	jr nz, .row_loop
	ret

InitTradeSpeciesList:
	call _LoadTradeScreenBorder
	call LoadCableLinkTradeFullscreenTilemap
	callba InitMG_Mobile_LinkTradePalMap
	callba PlaceTradePartnerNamesAndParty
	hlcoord 10, 17
	ld de, .cancel_text
	jp PlaceText

.cancel_text
	text "Cancel"
	done

LinkComms_LoadPleaseWaitTextboxBorderGFX:
	ld de, LinkCommsBorderGFX + $30 tiles
	ld hl, vBGTiles tile $76
	lb bc, BANK(LinkCommsBorderGFX), 8
	jp Get2bpp

Link_ShowWaitingAndSync:
	call LoadStandardMenuHeader
	call PlaceLinkWaitingMessage
	callba Serial_SyncAndExchangeNybble
	call ExitMenu
	jp ApplyAttrAndTilemapInVBlank

PlaceLinkWaitingMessage:
	hlcoord 4, 10
	lb bc, 1, 10
	predef Predef_LinkTextbox
	hlcoord 5, 11
	ld de, .Waiting
	call PlaceText
	call ApplyTilemapInVBlank
	call ApplyAttrAndTilemapInVBlank
	ld c, 50
	jp DelayFrames

.Waiting
	text "Waiting..!"
	done

LinkTradeMenu:
	call .MenuAction

.GetJoypad
	push bc
	push af
	ldh a, [hJoyLast]
	and D_PAD
	ld b, a
	ldh a, [hJoyPressed]
	and BUTTONS
	or b
	ld b, a
	pop af
	ld a, b
	pop bc
	ld d, a
	ret

.MenuAction
	ld hl, w2DMenuFlags2
	res 7, [hl]
	ldh a, [hBGMapMode]
	push af
	call .loop
	pop af
	ldh [hBGMapMode], a
	ret

.loop
	call .UpdateCursor
	call .UpdateBGMapAndOAM
	call .loop2
	ret nc
	callba _2DMenuInterpretJoypad
	ret c
	ld a, [w2DMenuFlags1]
	bit 7, a
	ret nz
	call .GetJoypad
	ld b, a
	ld a, [wMenuJoypadFilter]
	and b
	jr z, .loop
	ret

.UpdateBGMapAndOAM
	ldh a, [hOAMUpdate]
	push af
	ld a, $1
	ldh [hOAMUpdate], a
	call ApplyTilemapInVBlank
	pop af
	ldh [hOAMUpdate], a
	xor a
	ldh [hBGMapMode], a
	ret

.loop2
	call RTC
	call .TryAnims
	ret c
	ld a, [w2DMenuFlags1]
	bit 7, a
	jr z, .loop2
	and a
	ret

.UpdateCursor
	ld hl, wCursorCurrentTile
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	cp $1f
	jr nz, .not_currently_selected
	ld a, [wCursorOffCharacter]
	ld [hl], a
	push hl
	push bc
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld [hl], a
	pop bc
	pop hl

.not_currently_selected
	ld a, [w2DMenuCursorInitY]
	ld b, a
	ld a, [w2DMenuCursorInitX]
	ld c, a
	call Coord2Tile
	ld a, [w2DMenuCursorOffsets]
	swap a
	and $f
	ld c, a
	ld a, [wMenuCursorY]
	ld b, a
	xor a
	dec b
	jr z, .skip
.loop3
	add c
	dec b
	jr nz, .loop3

.skip
	ld c, SCREEN_WIDTH
	rst AddNTimes
	ld a, [w2DMenuCursorOffsets]
	and $f
	ld c, a
	ld a, [wMenuCursorX]
	ld b, a
	xor a
	dec b
	jr z, .skip2
.loop4
	add c
	dec b
	jr nz, .loop4

.skip2
	ld c, a
	add hl, bc
	ld a, [hl]
	cp $1f
	jr z, .cursor_already_there
	ld [wCursorOffCharacter], a
	ld [hl], $1f
	push hl
	push bc
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld [hl], $1f
	pop bc
	pop hl
.cursor_already_there
	ld a, l
	ld [wCursorCurrentTile], a
	ld a, h
	ld [wCursorCurrentTile + 1], a
	ret

.TryAnims
	ld a, [w2DMenuFlags1]
	bit 6, a
	jr z, .skip_anims
	callba PlaySpriteAnimationsAndDelayFrame
.skip_anims
	call JoyTextDelay
	call .GetJoypad
	add a, -1 ; set carry if nonzero
	ret

LinkCommsBorderGFX: INCBIN "gfx/trade/link_comms_border_tiles.2bpp"

MobileLinkTradeFullscreenTilemap:
	lzdata $3f, $40, $12, $13
	lzrepeat 15, $0d
	lzdata $15, $19, $45, $10
	lzrepeat 16, $04
	lzdata $11, $04
	lzcopy normal, 101, -20
	lzdata $16
	lzrepeat 16, $17
	lzdata $18, $04, $45
	lzcopy normal, 18, $0002
	lzcopy normal, 100, $0028
	lzdata $1a
	lzcopy normal, 19, -20
	lzdata $42, $43
	lzcopy normal, 18, $008e
	lzrepeat 2, $0f
	lzdata $2f, $24, $25, $26, $2f, $0f, $3e
	lzrepeat 10, $3f
	lzdata $40, $0f, $38, $39, $3a, $3b, $3c, $3d, $0f, $44
	lzrepeat 10, $04
	lzdata $45
	lzend
