SelectQuantityToToss:
	ld hl, TossItem_MenuHeader
	jr Toss_Sell_Loop

SelectQuantityToBuy:
	callba GetItemPrice
SelectQuantityToBuy_CustomPrice:
	ld hl, wCurItemPrice
	ld a, d
	ld [hli], a
	ld [hl], e
	ld hl, BuyItem_MenuHeader
	jr Toss_Sell_Loop

SelectQuantityToSell:
	callba GetItemPrice
	ld hl, wCurItemPrice
	ld a, d
	ld [hli], a
	ld [hl], e
	ld hl, SellItem_MenuHeader
	; fallthrough

Toss_Sell_Loop:
	call LoadMenuHeader
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ldh [hBGMapMode], a
.loop
	; update quantity display
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld [hl], "×"
	inc hl
	ld de, wItemQuantityChangeBuffer
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	push hl
	ld hl, wMenuDataPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .skip_money
	call _hl_
	ld hl, hMoneyTemp
	ldh a, [hProduct + 1]
	ld [hli], a
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	pop hl
	ld de, hMoneyTemp
	ld a, [wCurMartIsBTOrArcade]
	and a
	lb bc, PRINTNUM_MONEY | 3, 7
	jr z, .print
	ld b, 3
.print
	call PrintNum
	push hl
.skip_money
	pop hl

.joypad_loop
	call DelayFrame
	ldh a, [hInMenu]
	push af
	ld a, 1
	ldh [hInMenu], a
	call JoyTextDelay
	pop af
	ldh [hInMenu], a

	ldh a, [hJoyPressed]
	rrca
	ccf
	ret nc ; A

	rrca
	ret c ; B

	ld hl, wItemQuantityChangeBuffer

	ldh a, [hJoyLast]
	add a
	jr c, .down
	add a
	jr c, .up
	add a
	jr c, .left
	add a
	jr nc, .joypad_loop

.right
	ld a, [hl]
	add 10
	ld b, a
	ld a, [wItemQuantityBuffer]
	cp b
	jr c, .write_quantity
	ld a, b
.write_quantity
	ld [hl], a
.jump_loop
	jr .loop

.left
	ld a, [hl]
	sub 11
	inc a
	jr nc, .write_quantity
	ld a, 1
	jr .write_quantity

.down
	dec [hl]
	jr nz, .jump_loop
	ld a, [wItemQuantityBuffer]
	jr .write_quantity

.up
	inc [hl]
	ld a, [wItemQuantityBuffer]
	cp [hl]
	jr nc, .jump_loop
	ld a, 1
	jr .write_quantity

GetBuyPrice:
	xor a
	ldh [hMultiplicand + 0], a
	ld a, [wCurItemPrice]
	ldh [hMultiplicand + 1], a
	ld a, [wCurItemPrice + 1]
	ldh [hMultiplicand + 2], a
	ld a, [wItemQuantityChangeBuffer]
	ldh [hMultiplier], a
	predef_jump Multiply

GetSellPrice:
	call GetBuyPrice
	ld hl, hProduct + 1
	srl [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
	ret

TossItem_MenuHeader:
	db $40 ; flags
	db 09, 15 ; start coords
	db 11, 19 ; end coords
	dw NULL
	db 0 ; default option

BuyItem_MenuHeader:
	db $40 ; flags
	db 15, 07 ; start coords
	db 17, 19 ; end coords
	dw GetBuyPrice
	db -1 ; default option

SellItem_MenuHeader:
	db $40 ; flags
	db 15, 07 ; start coords
	db 17, 19 ; end coords
	dw GetSellPrice
	db 0 ; default option
