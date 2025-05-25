PlaceBallItemNameAndIcon::
	ld a, [wMenuSelection]
	cp $FF
	jr z, PlaceBallItemNameAndIcon_Cancel
	push bc
	call _PlaceBallItemNameAndIcon
	pop bc
	inc c
	ld a, b
	cp c
	jr z, UpdateFirstFiveOBPals
	ret

_PlaceBallItemNameAndIcon:
	push de
	ld a, [wMenuScrollPosition]
	ld b, a
	ld a, [wScrollingMenuCursorPosition]
	sub b
	swap a
	push af
	add a
	ld l, a
	ld h, $80
	callba BagMenu_GetBallGFX
	callba LoadBallPocketOAM
	pop af
	srl a
	add LOW(wOriginalOBJPals)
	ld e, a
	ld d, HIGH(wOriginalOBJPals)
	callba GetBallPackPal
	pop de
; fallthrough
PlaceMenuItemName::
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	pop hl
	jp PlaceString

PlaceBallItemNameAndIcon_Cancel:
	push de
	ld a, [wMenuScrollPosition]
	ld b, a
	ld a, [wScrollingMenuCursorPosition]
	sub b
	swap a
	ld l, a
	ld h, HIGH(wSprites)
	ld bc, $10
	xor a
	call ByteFill
	ld de, PlaceBallItemNameAndIcon_CancelString
	pop hl
	call PlaceString

; fallthrough
UpdateFirstFiveOBPals:
	ldh a, [rSVBK]
	push af
	wbk BANK(wOBPals)
	ld hl, wOriginalOBJPals
	ld de, wOBPals
	ld bc, 5 palettes
	rst CopyBytes
; now to update the first five palettes in hblank
	ld hl, wOBPals
	lb bc, 5, LOW(rOBPI)
	ld de, rSTAT
	ld a, $80
	ldh [c], a
	inc c
	di
.waitNoHBlankLoop
	ld a, [de]
	and 3
	jr z, .waitNoHBlankLoop
.waitHBlankLoop
	ld a, [de]
	and 3
	jr nz, .waitHBlankLoop
rept 1 palettes
	ld a, [hli]
	ldh [c], a
endr
	dec b
	jr nz, .waitNoHBlankLoop
	pop af
	ldh [rSVBK], a
	reti

PlaceBallItemNameAndIcon_CancelString:
	db "Cancel@"

PlaceMenuItemQuantity:
	push de
	ld a, [wMenuSelection]
	ld [wCurItem], a
	callba CheckItemPocket
	pop de
	ld a, [wItemAttributeParamBuffer]
	cp KEY_ITEM
	ret z
PlaceMenuItemQuantity_Force:
	ld hl, SCREEN_WIDTH + 1
	add hl, de
	ld a, "×"
	ld [hli], a
	ld de, wMenuSelectionQuantity
	lb bc, 1, 2
	jp PrintNum

PlaceBattlePointsTopRight:
	call InitBattleTowerArcadeGoldTokenTopRightBox
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, .BPString
	call PlaceString
	ld h, b
	ld l, c
	ld de, wBattlePoints
	lb bc, 2, 3
	call PrintNum
	jr PlaceItemQuantityTopLeft

.BPString:
	db "BP: @"

PlaceArcadeTicketsTopRight:
	call InitBattleTowerArcadeGoldTokenTopRightBox
	inc hl
	ld de, .TicketsString
	call PlaceText
	ld hl, wBattleArcadeTickets

	ld b, 0
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]

	ld a, 7
	ldh [hDigitsFlags], a
	coord hl, 12, 1
	predef PrintBigNumber
	jr PlaceItemQuantityTopLeft

.TicketsString:
	ctxt "Tickets"
	done

PlaceGoldTokensTopRight:
	call InitBattleTowerArcadeGoldTokenTopRightBox
	inc hl
	ld de, .TokensString
	call PlaceText
	ld b, GOLD_TOKEN
	ld hl, wNumItems
	callba GetAmountOfItemInList_ItemInB
	push de
	ld hl, sp + 0
	ld d, h
	ld e, l
	coord hl, 16, 1
	lb bc, 1, 3
	call PrintNum
	pop de
	jr PlaceItemQuantityTopLeft

.TokensString:
	ctxt "Tokens"
	done

InitBattleTowerArcadeGoldTokenTopRightBox:
	ld hl, MenuHeader_TopRightBox_SixDigits
	call CopyMenuHeader
	call MenuBox
	jp MenuBoxCoord2Tile

Mart_PlaceMoneyTopRight:
	call PlaceMoneyTopRight
	call PlaceItemQuantityTopLeft
	hlcoord 10, 0
	ld de, SCREEN_WIDTH
	ld [hl], "─"
	add hl, de
	ld [hl], " "
	add hl, de
	ld [hl], "─"
	ret

PlaceItemQuantityTopLeft:
	ld hl, MenuHeader_TopLeftBox
	call CopyMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 5
	add hl, de
	ld a, 5
.loop:
	dec a
	ld [hld], a
	jr nz, .loop
	ld hl, vBGTiles
	ld de, .InBagStr
	lb bc, 0, 5
	jp PlaceVWFString

.InBagStr db "Pack ×@"

PlaceMoneyTopRight:
	ld hl, MenuHeader_TopRightBox
	call CopyMenuHeader
	jr PlaceMoneyDataHeader

PlaceMoneyBottomLeft:
	ld hl, MenuHeader_BottomLeftBox
	call CopyMenuHeader
	jr PlaceMoneyDataHeader

PlaceMoneyAtTopLeftOfTextbox:
	ld hl, MenuHeader_TopRightBox
	lb de, 0, 11
	call OffsetMenuHeader

PlaceMoneyDataHeader:
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 7
	jp PrintNum

MenuHeader_TopRightBox_SixDigits:
	db $40 ; flags
	db 00, 11 ; start coords
	db 02, 19 ; end coords
	dw NULL
	db 1 ; default option

MenuHeader_TopRightBox:
	db $40 ; flags
	db 00, 10 ; start coords
	db 02, 19 ; end coords
	dw NULL
	db 1 ; default option

MenuHeader_BottomLeftBox:
	db $40 ; flags
	db 11, 00 ; start coords
	db 13, 09 ; end coords
	dw NULL
	db 1 ; default option

MenuHeader_TopLeftBox:
	db $40 ; flags
	db 00, 00 ; start coords
	db 02, 10 ; end coords
	dw NULL
	db 1 ; default option

Special_DisplayCoinCaseBalance:
	; Place a text box of size 1x7 at 11, 0.
	hlcoord 11, 0
	lb bc, 1, 7
	call TextBox
	hlcoord 12, 0
	ld de, CoinString
	call PlaceString
	ld de, wCoins
	lb bc, 2, 4
	hlcoord 13, 1
	jp PrintNum

Special_DisplayMoneyAndCoinBalance:
	hlcoord 5, 0
	lb bc, 3, 13
	call TextBox
	hlcoord 6, 1
	ld de, MoneyString
	call PlaceString
	hlcoord 11, 1
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 7
	call PrintNum
	hlcoord 6, 3
	ld de, CoinString
	call PlaceString
	hlcoord 15, 3
	ld de, wCoins
	lb bc, 2, 4
	jp PrintNum

MoneyString:
	db "Money@"
CoinString:
	db "Coin@"
