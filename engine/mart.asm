	const_def
	const MARTTEXT_HOW_MANY
	const MARTTEXT_COSTS_THIS_MUCH
	const MARTTEXT_NOT_ENOUGH_MONEY
	const MARTTEXT_BAG_FULL
	const MARTTEXT_HERE_YOU_GO
	const MARTTEXT_SOLD_OUT

OpenMartDialog::
	push de
	call GetMart
	ld a, c
	ld [wEngineBuffer1], a
	call LoadMartPointer
	ld a, [wEngineBuffer1]
	pop de
	jumptable
.dialogs
	dw MartDialog
	dw HerbShop
	dw BargainShop
	dw Pharmacist
	dw RooftopSale
	dw BattleTowerExchangeCorner
	dw BattleArcadeExchangeCorner
	dw GoldTokenExchangeMart

MartDialog:
	xor a
	ld [wEngineBuffer1], a
	ld [wEngineBuffer5], a
	ld [wCurMartIsBTOrArcade], a
	jp StandardMart

HerbShop:
	xor a
	ld [wCurMartIsBTOrArcade], a
	call FarReadMart
	call LoadStandardMenuHeader
	ld hl, .intro
	call MartTextBox
	call BuyMenu
	ld hl, .outro
	jp MartTextBox

.intro
	ctxt "Hello, dear."

	para "I sell inexpensive"
	line "herbal medicine."

	para "They're good, but a"
	line "trifle bitter."

	para "Your #mon may"
	line "not like them."

	para "Hehehehe<...>"
	done

.outro
	ctxt "Come again, dear."
	line "Hehehehe<...>"
	done

BargainShop:
	xor a
	ld [wCurMartIsBTOrArcade], a
	ld b, BANK(BargainShopData)
	ld de, BargainShopData
	call LoadMartPointer
	call ReadMart
	call LoadStandardMenuHeader
	ld hl, .intro
	call MartTextBox
	call BuyMenu
	ld hl, wBargainShopFlags
	ld a, [hli]
	or [hl]
	jr z, .skip_set
	ld hl, wDailyFlags
	set 6, [hl]
.skip_set
	ld hl, .outro
	jp MartTextBox

.intro
	ctxt "Hiya! Care to see"
	line "some bargains?"

	para "I sell rare items"
	line "that nobody else"
	para "carries--but only"
	line "one of each item."
	done

.outro
	ctxt "Come by again"
	line "sometime."
	done

Pharmacist:
	xor a
	ld [wCurMartIsBTOrArcade], a
	call FarReadMart
	call LoadStandardMenuHeader
	ld hl, .intro
	call MartTextBox
	call BuyMenu
	ld hl, .outro
	jp MartTextBox

.intro
	ctxt "What's up? Need"
	line "some medicine?"
	done

.outro
	ctxt "All right."
	line "See you around."
	done

RooftopSale:
	xor a
	ld [wCurMartIsBTOrArcade], a
	ld b, BANK(RooftopSaleData1)
	ld de, RooftopSaleData1
	ld hl, wStatusFlags
	bit 6, [hl] ; hall of fame
	jr z, .ok
	ld b, BANK(RooftopSaleData2)
	ld de, RooftopSaleData2

.ok
	call LoadMartPointer
	call ReadMart
	call LoadStandardMenuHeader
	ld hl, Text_Mart_Intro
	call MartTextBox
	call BuyMenu
	ld hl, Text_Mart_ComeAgain
	jp MartTextBox

RooftopSaleData1:
	db 5
	dbw POKE_BALL,     150
	dbw GREAT_BALL,    500
	dbw SUPER_POTION,  500
	dbw FULL_HEAL,     500
	dbw REVIVE,       1200
	db -1
RooftopSaleData2:
	db 5
	dbw HYPER_POTION, 1000
	dbw FULL_RESTORE, 2000
	dbw FULL_HEAL,     500
	dbw ULTRA_BALL,   1000
	dbw PROTEIN,      7800
	db -1

Text_BattleTowerExchange_Intro:
	ctxt "Welcome!"

	para "You can exchange"
	line "your Battle Points"
	para "over here for some"
	line "fabulous prizes!"

	para "Which one would"
	line "you like?"
	done

Text_BattleArcadeExchange_Intro:
	ctxt "Welcome!"

	para "We can redeem your"
	line "Arcade Tickets"
	cont "for prizes here!"

	para "Which one would"
	line "you like?"
	done

BattleTowerExchangeCorner:
	ld a, 1
	ld [wCurMartIsBTOrArcade], a
	call FarReadBattleTowerArcadeMart
	call LoadStandardMenuHeader
	ld hl, Text_BattleTowerExchange_Intro
	call MartTextBox
	call BattleTowerBuyMenu
	jr BattleTowerArcade_PrintOutroText

BattleArcadeExchangeCorner:
	ld a, 1
	ld [wCurMartIsBTOrArcade], a
	call FarReadBattleTowerArcadeMart
	call LoadStandardMenuHeader
	ld hl, Text_BattleArcadeExchange_Intro
	call MartTextBox
	call BattleArcadeBuyMenu
BattleTowerArcade_PrintOutroText:
	ld hl, .text
	jp MartTextBox

.text
	ctxt "Come again!"
	done

GoldTokenExchangeMart:
	xor a
	ld [wCurMartIsBTOrArcade], a
	push de
	call FarReadGoldTokenExchangeMart
	call LoadStandardMenuHeader
	pop de
	ld a, e
	cp JAERU_GOLD_TOKEN_MART
	ld hl, .text
	jr nz, .ok
	ld hl, .jaeru_text
.ok
	call MartTextBox
	call GoldTokenExchangeMartBuyMenu
	jr BattleTowerArcade_PrintOutroText

.text
	ctxt "Welcome!"

	para "You can exchange"
	line "Gold Tokens you"
	para "have found for"
	line "prizes."

	para "Which one do you"
	line "want?"
	done

.jaeru_text
	ctxt "Hello!"

	para "I have these rare"
	line "items that help"
	para "train your #mon"
	line "or boost your"
	para "#mon's stats in"
	line "battle."

	para "I'll let you have"
	line "any of these for 5"
	cont "Gold Tokens each!"

	para "Which one would"
	line "you like?"
	done

LoadMartPointer:
	ld a, b
	ld [wMartPointerBank], a
	ld a, e
	ld [wMartPointer], a
	ld a, d
	ld [wMartPointer + 1], a
	ld hl, wCurMart
	xor a
	ld bc, 16
	call ByteFill
	xor a
	ld [wEngineBuffer5], a
	ld [wBargainShopFlags], a
	ld [wFacingDirection], a
	ret

GetMart:
	ld b, BANK(DefaultMartItems)
	ld a, c
	cp MART_BATTLETOWER ; Battle Tower
	jr z, .battleTower
	cp MART_BATTLEARCADE
	jr z, .battleArcade
	cp MART_GOLDTOKEN
	push bc
	ld hl, Marts
	ld bc, DefaultMartItems
	ld d, (MartsEnd - Marts) / 2
	jr nz, .notGoldTokenMart
	ld hl, GoldTokenMarts
	ld bc, SpurgeMartGoldTokenExchange
	ld d, (GoldTokenMartsEnd - GoldTokenMarts) / 2
.notGoldTokenMart
	ld a, e
	cp d
	jr c, .IsAMart
	ld d, b
	ld e, c
	pop bc
	ret

.IsAMart
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop bc
	ret

.battleTower
	ld de, BattleTowerMart
	ret
.battleArcade
	ld de, BattleArcadePrizesAndCosts
	ret

StandardMart:
.loop
	ld a, [wEngineBuffer5]
	jumptable .MartFunctions
	ld [wEngineBuffer5], a
	cp $ff
	jr nz, .loop
	ret

.MartFunctions
	dw .HowMayIHelpYou
	dw .TopMenu
	dw .Buy
	dw .Sell
	dw .Quit
	dw .AnythingElse

.HowMayIHelpYou
	call LoadStandardMenuHeader
	ld hl, Text_Mart_Intro
	call PrintText
	ld a, 1 ; top menu
	ret

.TopMenu
	ld hl, MenuHeader_BuySell
	call CopyMenuHeader
	call VerticalMenu
	jr c, .quit
	ld a, [wMenuCursorY]
	inc a
	ret
.quit
	ld a, 4 ;  Come again!
	ret

.Buy
	call ExitMenu
	call FarReadMart
	call BuyMenu
	and a
	ld a, 5 ; Anything else?
	ret

.Sell
	call ExitMenu
	call SellMenu
	ld a, 5 ; Anything else?
	ret

.Quit
	call ExitMenu
	ld hl, Text_Mart_ComeAgain
	call MartTextBox
	ld a, $ff ; exit
	ret

.AnythingElse
	call LoadStandardMenuHeader
	ld hl, .anything_else_text
	call PrintText
	ld a, 1 ; top menu
	ret

.anything_else_text
	ctxt "Can I do anything"
	line "else for you?"
	done

FarReadMart:
	ld hl, wMartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wCurMart
.CopyMart
	call GetFarMartByte
	ld [de], a
	inc de
	cp -1
	jr nz, .CopyMart
	ld hl, wMartItem1BCD
	ld de, wCurMart + 1
	jr .handleLoop
.ReadMartItem
	push de
	call GetMartItemPrice
	pop de
.handleLoop
	ld a, [de]
	inc de
	cp -1
	jr nz, .ReadMartItem
	ret

FarReadBattleTowerArcadeMart:
	ld hl, wMartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wCurMart
	ld bc, wMartItem1BCD
	call GetFarMartByte
	ld [de], a
	inc de
	jr .handleLoop

.getPrice
	push de
	call GetFarMartByte
	push hl
	ld e, a
	ld d, 0
	and a
	jr nz, .notMysteryTicket
	ld de, 300
.notMysteryTicket
	ld h, b
	ld l, c
	call GetMartPrice
	ld b, h
	ld c, l
	pop hl
	pop de
.handleLoop
	call GetFarMartByte
	ld [de], a
	inc de
	cp -1
	jr nz, .getPrice
	ret

FarReadGoldTokenExchangeMart:
	ld hl, wMartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wCurMart
	ld bc, wMartItem1BCD
	call GetFarMartByte
	ld [de], a
	inc de
	jr .handleLoop

.getPrice
	push de
	call GetFarMartByte
	push hl
	ld e, a
	ld d, 0
	ld h, b
	ld l, c
	call GetMartPrice
	ld b, h
	ld c, l
	pop hl
	pop de
	inc hl
	inc hl
.handleLoop
	call GetFarMartByte
	ld [de], a
	inc de
	cp -1
	jr nz, .getPrice
	ret

GetMartItemPrice:
; Return the price of item a in BCD at hl and in tiles at wStringBuffer1.
	push hl
	ld [wCurItem], a
	callba GetItemPrice
	pop hl

GetMartPrice:
; Return price de in BCD at hl and in tiles at wStringBuffer1.
	push hl
	ld a, d
	ld [wStringBuffer2], a
	ld a, e
	ld [wStringBuffer2 + 1], a
	ld hl, wStringBuffer1
	ld de, wStringBuffer2
	lb bc, PRINTNUM_LEADINGZEROS | 2, 6 ; 6 digits
	call PrintNum
	pop hl

	ld de, wStringBuffer1
	ld c, 6 / 2 ; 6 digits
.loop
	call .CharToNybble
	swap a
	ld b, a
	call .CharToNybble
	or b
	ld [hli], a
	dec c
	jr nz, .loop
	ret

.CharToNybble
	ld a, [de]
	inc de
	sub "0"
	ret nc
	xor a
	ret

ReadMart:
; Load the mart pointer.  Mart data is local (no need for bank).
	ld hl, wMartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
; set hl to the first item
	inc hl
	ld bc, wMartItem1BCD
	ld de, wCurMart + 1
.loop
; copy the item to wCurMart + (ItemIndex)
	ld a, [hli]
	ld [de], a
	inc de
; -1 is the terminator
	inc a
	jr z, .done

	push de
; copy the price to de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
; convert the price to 3-byte BCD at [bc]
	push hl
	ld h, b
	ld l, c
	call GetMartPrice
	ld b, h
	ld c, l
	pop hl

	pop de
	jr .loop

.done
	pop hl
	ld a, [hl]
	ld [wCurMart], a
	ret

BargainShopData:
	db 5
	dbw NUGGET,     4500
	dbw PEARL,       650
	dbw BIG_PEARL,  3500
	dbw STARDUST,    900
	dbw STAR_PIECE, 4600
	db -1

BattleTowerBuyMenu:
	ld hl, BattleTowerBuyMenuLoop
	jr DoMartMenuLoop

BattleArcadeBuyMenu:
	ld hl, BattleArcadeBuyMenuLoop
	jr DoMartMenuLoop

GoldTokenExchangeMartBuyMenu:
	ld hl, GoldTokenExchangeMartBuyMenuLoop
	jr DoMartMenuLoop

BuyMenu:
	ld hl, BuyMenuLoop
DoMartMenuLoop:
	push hl
	call FadeToMenu
	callba BlankScreen
	xor a
	ld [wMartMenuScrollPosition], a
	inc a
	ld [wMartMenuCursorBuffer], a
	pop hl
.loop
	push hl
	call _hl_
	pop hl
	jr nc, .loop
	jp CloseSubmenu

LoadBuyMenuText:
; load text from a nested table
; which table is in wEngineBuffer1
; which entry is in register a
	push de
	push af
	call GetMartDialogGroup
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	pop de
	ret

MartAskPurchaseQuantity:
	call GetMartDialogGroup
	inc hl
	inc hl
	ld a, [hl]
	jumptable

	dw StandardMartAskPurchaseQuantity
	dw BargainShopAskPurchaseQuantity
	dw RooftopSaleAskPurchaseQuantity
	dw BattleTowerAskPurchaseQuantity
	dw BattleArcadeAskPurchaseQuantity
	dw GoldTokenExchangeMartAskPurchaseQuantity

GetMartDialogGroup:
	ld a, [wEngineBuffer1]
	ld e, a
	ld d, 0
	ld hl, .tables
	add hl, de
	add hl, de
	add hl, de
	ret

.tables
	dwb .StandardMartPointers, 0
	dwb .HerbShopPointers, 0
	dwb .BargainShopPointers, 1
	dwb .PharmacyPointers, 0
	dwb .StandardMartPointers, 2
	dwb .BattleTowerPointers, 3
	dwb .BattleArcadePointers, 4
	dwb .GoldTokenExchangeMartPointers, 5

.StandardMartPointers
	dw Text_Mart_HowMany
	dw .will_be_money
	dw .not_enough_money
	dw .bag_full
	dw .here_you_go
	dw NULL

.HerbShopPointers
	dw Text_Mart_HowMany
	dw .will_be_money
	dw .dont_have_the_money
	dw .pack_full_dear
	dw .thanks_dear
	dw NULL

.BargainShopPointers
	dw NULL
	dw .costs_money
	dw .short_on_funds
	dw .pack_full
	dw .thanks
	dw .sold_out

.PharmacyPointers
	dw Text_Mart_HowMany
	dw .will_be_money
	dw .huh_not_enough_money
	dw .no_space
	dw .thanks_a_lot
	dw NULL

.BattleTowerPointers
	dw Text_Mart_HowMany
	dw .will_be_quantity_BP
	dw .not_enough_BP
	dw .bag_full
	dw .here_you_go
	dw NULL

.BattleArcadePointers
	dw Text_Mart_HowMany
	dw .will_be_quantity_tickets
	dw .not_enough_tickets
	dw .bag_full
	dw .here_you_go
	dw .already_bought_mystery_ticket

.GoldTokenExchangeMartPointers
	dw Text_Mart_HowMany
	dw .will_be_quantity_tokens
	dw .not_enough_tokens
	dw .bag_full
	dw .here_you_go
	dw .already_bought_item

.already_bought_item
	ctxt "Sorry, only one"
	line "<STRBF2> per"
	cont "person."
	done

.already_bought_mystery_ticket
	ctxt "Sorry, only one"
	line "Mystery Ticket per"
	cont "person."
	done

.bag_full
	ctxt "You can't carry"
	line "any more items."
	done

.costs_money
	text "<STRBF2> costs"
	line "¥@"
	deciram hMoneyTemp, 3, 7
	ctxt ". Want it?"
	done

.dont_have_the_money
	ctxt "Hehehe<...> You don't"
	line "have the money."
	done

.here_you_go
	ctxt "Here you are."
	line "Thank you!"
	done

.huh_not_enough_money
	ctxt "Huh? That's not"
	line "enough money."
	done

.no_space
	ctxt "You don't have any"
	line "more space."
	done

.not_enough_BP
	ctxt "You don't have"
	line "enough Battle"
	cont "Points."
	done

.not_enough_money
	ctxt "You don't have"
	line "enough money."
	done

.not_enough_tickets
	ctxt "You don't have"
	line "enough Arcade"
	cont "Tickets."
	done

.not_enough_tokens
	ctxt "You don't have"
	line "enough Gold"
	cont "Tokens."
	done

.pack_full
	ctxt "Uh-oh, your pack"
	line "is chock-full."
	done

.pack_full_dear
	ctxt "Oh? Your pack is"
	line "full, dear."
	done

.short_on_funds
	ctxt "Uh-oh, you're"
	line "short on funds."
	done

.sold_out
	ctxt "You bought that"
	line "already. I'm all"
	cont "sold out of it."
	done

.thanks
	ctxt "Thanks."
	done

.thanks_a_lot
	ctxt "Thanks a lot!"
	done

.thanks_dear
	ctxt "Thank you, dear."
	line "Hehehehe<...>"
	done

.will_be_money
	deciram wItemQuantityChangeBuffer, 1, 2
	ctxt " <STRBF2>(s)"
	line "will be ¥@"
	deciram hMoneyTemp, 3, 7
	text "."
	done

.will_be_quantity_BP
	ctxt "<STRBF2>"
	line "will be @"
	deciram hMoneyTemp, 3, 6
	ctxt " BP."
	done

.will_be_quantity_tickets
	ctxt "<STRBF2> will"
	line "be @"
	deciram hMoneyTemp, 3, 6
	ctxt " tickets."
	done

.will_be_quantity_tokens
	ctxt "<STRBF2> will"
	line "be @"
	deciram wItemQuantityChangeBuffer, 1, 0
	ctxt " tokens."
	done

BuyMenuLoop:
	ld de, MenuHeader_Buy
	ld hl, Mart_PlaceMoneyTopRight
	call DoBuyMenuLoop
	jp z, MartBuyMenuLoop_setCarry
	call MartAskPurchaseQuantity
	jr c, MartBuyMenuLoop_cancel
	and a
	jp z, BuyMenuLoop_InsufficientFunds
	call MartConfirmPurchase
	jr c, MartBuyMenuLoop_cancel
	ld de, wMoney
	ld bc, hMoneyTemp
	call CompareMoney
	jr c, BuyMenuLoop_InsufficientFunds
	ld hl, wNumItems
	call ReceiveItem
	jr nc, BuyMenuLoop_InsufficientBagSpace
	ld a, [wMartItemID]
	ld c, a
	ld b, SET_FLAG
	ld hl, wBargainShopFlags
	predef FlagAction
	call PlayTransactionSound
	ld de, wMoney
	ld bc, hMoneyTemp
	call TakeMoney
	jr PrintMartHereYouGoText

BattleTowerBuyMenuLoop:
	ld de, MenuHeader_BTBuy
	ld hl, PlaceBattlePointsTopRight
	call DoBuyMenuLoop
	jr z, MartBuyMenuLoop_setCarry
	call MartAskPurchaseQuantity
	jr c, MartBuyMenuLoop_cancel
	and a
	jr z, BuyMenuLoop_InsufficientFunds
	call MartConfirmPurchase
	jr c, MartBuyMenuLoop_cancel
	ld hl, wNumItems
	call ReceiveItem
	jr nc, BuyMenuLoop_InsufficientBagSpace
	call PlayTransactionSound
	ld bc, hMoneyTemp
	call TakeBattlePoints

PrintMartHereYouGoText:
	ld a, MARTTEXT_HERE_YOU_GO
	call LoadBuyMenuText
	ld a, 10
	ld [wGenericDelay], a
	call JoyWaitAorB
	call ConsumeGenericDelay

MartBuyMenuLoop_cancel:
	call SpeechTextBox
	and a
	ret

BuyMenuLoop_InsufficientBagSpace:
	ld a, MARTTEXT_BAG_FULL
	jr BuyMenuLoop_BuyMenuTextEntryPoint

MartBuyMenuLoop_setCarry:
	scf
	ret

BuyMenuLoop_AlreadyBoughtItem:
	ld a, MARTTEXT_SOLD_OUT
	jr BuyMenuLoop_BuyMenuTextEntryPoint

BuyMenuLoop_InsufficientFunds:
	ld a, MARTTEXT_NOT_ENOUGH_MONEY
BuyMenuLoop_BuyMenuTextEntryPoint:
	call LoadBuyMenuText
	call JoyWaitAorB
	and a
	ret

BattleArcadeBuyMenuLoop:
	ld de, MenuHeader_ArcadeBuy
	ld hl, PlaceArcadeTicketsTopRight
	call DoBuyMenuLoop
	jr z, MartBuyMenuLoop_setCarry
	call MartAskPurchaseQuantity
	jr c, MartBuyMenuLoop_cancel
	and a
	jr z, BuyMenuLoop_InsufficientFunds
	call MartConfirmPurchase
	jr c, MartBuyMenuLoop_cancel
	ld a, [wCurItem]
	cp MYSTERY_TCKT
	jr nz, .notMysteryTicket
	ld hl, wEventFlags + (EVENT_GET_MYSTERY_TICKET / 8)
	bit (EVENT_GET_MYSTERY_TICKET % 8), [hl]
	jr nz, BuyMenuLoop_AlreadyBoughtItem
.notMysteryTicket
	ld hl, wNumItems
	call ReceiveItem
	jr nc, BuyMenuLoop_InsufficientBagSpace
	ld a, [wCurItem]
	cp MYSTERY_TCKT
	jr nz, .notMysteryTicket2
	ld hl, wEventFlags + (EVENT_GET_MYSTERY_TICKET / 8)
	set (EVENT_GET_MYSTERY_TICKET % 8), [hl]
.notMysteryTicket2
	call PlayTransactionSound
	ldh a, [hMoneyTemp + 1]
	ld d, a
	ldh a, [hMoneyTemp + 2]
	ld e, a
	ld hl, wBattleArcadeTickets + 2
	ld a, [hl]
	sub e
	ld [hld], a
	ld a, [hl]
	sbc d
	ld [hld], a
	ld a, [hl]
	sbc 0
	ld [hl], a
	jp PrintMartHereYouGoText

GoldTokenExchangeMartBuyMenuLoop:
	ld de, GoldTokenExchangeMartMenuHeader
	ld hl, PlaceGoldTokensTopRight
	call DoBuyMenuLoop
	jr z, MartBuyMenuLoop_setCarry
	predef PartyMonItemName
	call MartAskPurchaseQuantity
	jr c, BuyMenuLoop_AlreadyBoughtItem
	and a
	jr z, BuyMenuLoop_InsufficientFunds
	call GoldTokenExchangeMartConfirmPurchase
	jp c, MartBuyMenuLoop_cancel
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	ld hl, wGoldTokenExchangeItemPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp nc, BuyMenuLoop_InsufficientBagSpace
	ld a, [hli]
	ld [wItemQuantityChangeBuffer], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld a, GOLD_TOKEN
	ld [wCurItem], a
	push hl
	ld hl, wNumItems
	call TossItem
	pop hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	or d
	jr z, .skipSettingBoughtItemFlag
	ld b, SET_FLAG
	predef EventFlagAction
.skipSettingBoughtItemFlag
	call PlayTransactionSound
	jp PrintMartHereYouGoText

DoBuyMenuLoop:
	push de
	ld a, BANK(Mart_PlaceMoneyTopRight)
	call FarCall_hl
	call UpdateSprites
	pop hl
	call CopyMenuHeader
	ld a, [wMartMenuCursorBuffer]
	ld [wMenuCursorBuffer], a
	ld a, [wMartMenuScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wMartMenuScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wMartMenuCursorBuffer], a
	call SpeechTextBox
	ld a, [wMenuJoypad]
	cp B_BUTTON
	ret

StandardMartAskPurchaseQuantity:
	callba GetItemPrice
	call Mart_GetNumberYouCanBuy
	and a
	ret z
	ld [wItemQuantityBuffer], a
	ld a, MARTTEXT_HOW_MANY
	call LoadBuyMenuText
	callba SelectQuantityToBuy
	call ExitMenu
	ld a, 1
	ret

MartConfirmPurchase:
	predef PartyMonItemName
GoldTokenExchangeMartConfirmPurchase:
	ld a, MARTTEXT_COSTS_THIS_MUCH
	call LoadBuyMenuText
	jp YesNoBox

GoldTokenExchangeMartAskPurchaseQuantity:
	ld de, GoldTokenExchangeMart_CheckGoldTokens
	ld b, 1
	jr GoldTokenExchangeMartAskPurchaseQuantity_EntryPoint

BattleTowerAskPurchaseQuantity:
	ld de, BattleTowerMart_CheckBattlePoints
	jr BattleTowerArcadeAskPurchaseQuantity

BattleArcadeAskPurchaseQuantity:
	ld de, BattleArcadeMart_CheckArcadeTickets
BattleTowerArcadeAskPurchaseQuantity:
	ld b, 0
	ld hl, BattleTowerArcadeAskPurchaseQuantity_Return
	push hl
GoldTokenExchangeMartAskPurchaseQuantity_EntryPoint: ; to enable token stacks, move this line up 2
	push de
	ld a, 1
	ld [wItemQuantityChangeBuffer], a

	ld hl, wMartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld a, [wMartItemID]
	dec b
	jr nz, .offsetOfTwo
	add a
.offsetOfTwo
	add a
	add l
	ld l, a
	ret nc
	inc h
	ret

BattleTowerArcadeAskPurchaseQuantity_Return:
	and a
	ret z
	ld [wItemQuantityBuffer], a
	ld a, d
	and a
	ld a, 1
	ret nz
	dec a ; MARTTEXT_HOW_MANY
	call LoadBuyMenuText
	callba SelectQuantityToBuy_CustomPrice
	call ExitMenu
	ld a, 1
	ret

GoldTokenExchangeMart_CheckGoldTokens:
	ld a, [wCurItem]
	ld b, a
	push bc
	ld a, l
	ld [wGoldTokenExchangeItemPointer], a
	ld a, h
	ld [wGoldTokenExchangeItemPointer + 1], a
	ld a, [hli]
	ld [wItemQuantityChangeBuffer], a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	or d
	jr z, .skipBoughtCheck
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld d, 1
	jr nz, .alreadyBought
.skipBoughtCheck
	ld a, GOLD_TOKEN
	ld [wCurItem], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld hl, wNumItems
	call TossItem
	ld hl, wNumItems
	call c, ReceiveItem ; receive item should always succeed if toss item succeeded
	ld d, 0
.alreadyBought
	pop bc
	ld a, b
	ld [wCurItem], a
	ccf
	ret

BargainShopAskPurchaseQuantity:
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld a, [wMartItemID]
	ld c, a
	ld b, CHECK_FLAG
	ld hl, wBargainShopFlags
	predef FlagAction
	ld a, c
	and a
	jr nz, .SoldOut
	ld a, [wMartItemID]
	ld e, a
	ld d, 0
	ld hl, wMartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld a, [hli]
	ldh [hMoneyTemp + 2], a
	ld a, [hl]
	ldh [hMoneyTemp + 1], a
	xor a
	ldh [hMoneyTemp], a
	ld bc, hMoneyTemp
	ld de, wMoney
	callba CompareMoney
	jr c, .not_enough
	ld a, 1
	ret

.not_enough
	xor a
	ret

.SoldOut
	ld a, MARTTEXT_SOLD_OUT
	call LoadBuyMenuText
	call JoyWaitAorB
	scf
	ret

RooftopSaleAskPurchaseQuantity:
	call RooftopSale_GetSalePrice
	call Mart_GetNumberYouCanBuy
	and a
	ret z
	ld [wItemQuantityBuffer], a
	ld a, MARTTEXT_HOW_MANY
	call LoadBuyMenuText
	callba SelectQuantityToBuy_CustomPrice
	call ExitMenu
	ld a, 1
	ret

RooftopSale_GetSalePrice:
	ld a, [wMartItemID]
	ld e, a
	ld d, 0
	ld hl, wMartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

MenuHeader_Buy:
	db $40 ; flags
	db 03, 01 ; start coords
	db 11, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $30 ; pointers
	db 4, 8 + SCREEN_WIDTH ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wCurMart
	dba PlaceMenuItemName
	dba BuyMenu_PrintBCDPrice
	dba Mart_UpdateItemDescription

.PrintBCDPrices
	ld a, [wScrollingMenuCursorPosition]
	ld c, a
	ld b, 0
	ld hl, wMartItem1BCD
	add hl, bc
	add hl, bc
	add hl, bc
	push de
	ld d, h
	ld e, l
	pop hl
	ld c, PRINTNUM_LEADINGZEROS | PRINTNUM_MONEY | 3
	jp PrintBCDNumber

MenuHeader_BTBuy:
	db $40 ; flags
	db 03, 01 ; start coords
	db 11, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $30 ; pointers
	db 4, 8 + SCREEN_WIDTH ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wCurMart
	dba PlaceMenuItemName
	dba BattleTowerBuyMenu_PrintBCDPrice
	dba Mart_UpdateItemDescription

MenuHeader_ArcadeBuy:
	db $40 ; flags
	db 03, 01 ; start coords
	db 11, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $30 ; pointers
	db 4, 3 + SCREEN_WIDTH ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wCurMart
	dba PlaceMenuItemName
	dba ArcadeBuyMenu_PrintBCDPrice
	dba Mart_UpdateItemDescription

GoldTokenExchangeMartMenuHeader:
	db $40 ; flags
	db 03, 01 ; start coords
	db 11, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $30 ; pointers
	db 4, 4 + SCREEN_WIDTH ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wCurMart
	dba PlaceMenuItemName
	dba GoldTokenExchangeMartBuyMenu_PrintBCDPrice
	dba Mart_UpdateItemDescription

BattleTowerBuyMenu_PrintBCDPrice:
	ld bc, BPString
	jr PrintNonMoneyBCDPrice

ArcadeBuyMenu_PrintBCDPrice:
	ld bc, TicketsString
	jr PrintNonMoneyBCDPrice

GoldTokenExchangeMartBuyMenu_PrintBCDPrice:
	ld bc, TokensString

PrintNonMoneyBCDPrice:
	ld a, PRINTNUM_LEADINGZEROS | 3
	jr PrintBCDPrice

BuyMenu_PrintBCDPrice:
	ld bc, 0
	ld a, PRINTNUM_LEADINGZEROS | PRINTNUM_MONEY | 3

PrintBCDPrice:
	push bc
	push af
	ld a, [wScrollingMenuCursorPosition]
	ld c, a
	ld b, 0
	ld hl, wMartItem1BCD
	add hl, bc
	add hl, bc
	add hl, bc
	push de
	ld d, h
	ld e, l
	pop hl
	pop af
	ld c, a
	call PrintBCDNumber
	pop de
	ld a, d
	or e
	ret z
	jp PlaceText

BPString:
	text " BP"
	done

TicketsString:
	ctxt " tickets"
	done

TokensString:
	ctxt " tokens"
	done

SellMenu:
	call DisableSpriteUpdates
	callba DepositSellInitPackBuffers
.loop
	callba DepositSellPack
	ld a, [wcf66]
	and a
	jr z, .quit
	call .TryToSellItem
	jr .loop

.quit
	call ReturnToMapWithSpeechTextbox
	and a
	ret

.TryToSellItem:
	call IsValidItemMenuType
	ret nc
	callba GetItemPrice
	ld a, d
	or e
	jr z, .cantsell
	callba _CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr z, .okay_to_sell
.cantsell
	ld hl, .error_text
	call PrintText
	and a
	ret

.error_text
	ctxt "Sorry, I can't buy"
	line "that from you."
	prompt

.okay_to_sell
	ld hl, Text_Mart_HowMany
	call PrintText
	callba PlaceMoneyAtTopLeftOfTextbox
	callba SelectQuantityToSell
	call ExitMenu
	jr c, .declined
	hlcoord 1, 14
	lb bc, 3, 18
	call ClearBox
	ld hl, .can_pay_amount_text
	call PrintTextBoxText
	call YesNoBox
	jr c, .declined
	ld de, wMoney
	ld bc, hMoneyTemp
	call GiveMoney
	ld a, [wMartItemID]
	ld hl, wNumItems
	call TossItem
	predef PartyMonItemName
	hlcoord 1, 14
	lb bc, 3, 18
	call ClearBox
	ld hl, .got_amount_for_items
	call PrintTextBoxText
	call PlayTransactionSound
	callba PlaceMoneyBottomLeft
	call JoyWaitAorB

.declined
	call ExitMenu
	and a
	ret

.can_pay_amount_text
	ctxt "I can pay you"
	line "¥@"
	deciram hMoneyTemp, 3, 7
	ctxt "."

	para "Is that OK?"
	done

.got_amount_for_items
	text "Got ¥@"
	deciram hMoneyTemp, 3, 7
	ctxt " for"
	line "<STRBF2>(s)."
	done

MenuHeader_BuySell:
	db $40 ; flags
	db 00, 00 ; start coords
	db 08, 07 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $80 ; strings
	db 3 ; items
	db "Buy@"
	db "Sell@"
	db "Quit@"

PlayTransactionSound:
	call WaitSFX
	ld de, SFX_TRANSACTION
	jp PlaySFX

MartTextBox:
	call MenuTextBox
	call JoyWaitAorB
	jp ExitMenu

BattleTowerMart_CheckBattlePoints:
	ld a, [hl]
	ld hl, wBattlePoints
	ld b, 2
	jr BattleTower_Arcade_GetMaxStackSize

BattleArcadeMart_CheckArcadeTickets:
	xor a
	ldh [hMoneyTemp], a
	ldh [hMoneyTemp + 1], a
	ld a, [hl]
	and a
	jr nz, .notMysteryTicket
	ld a, HIGH(300)
	ldh [hMoneyTemp + 1], a
	ld a, LOW(300)
	ldh [hMoneyTemp + 2], a
	ld de, wBattleArcadeTickets
	ld hl, hMoneyTemp
	ld c, 3
	call StringCmp
	ld a, 1
	sbc 0
	ret

.notMysteryTicket
	ld hl, wBattleArcadeTickets
	ld b, 3
BattleTower_Arcade_GetMaxStackSize:
	ldh [hDivisor], a
	ld e, a
	ld d, 0
	ld c, LOW(hDividend)
	push bc
.loop
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .loop
	pop bc
	predef Divide
	jr Mart_GetNumberYouCanBuy_ReturnHalfword

Mart_GetNumberYouCanBuy:
	ld a, d
	ldh [hDivisor], a
	or e
	jr z, Mart_GetNumberYouCanBuy_Return99 ;avoid div0 issues (not possible without hacking right now, but who knows?)
	ld a, e
	ldh [hDivisor + 1], a
	xor a
	ldh [hDividend], a
	ld hl, wMoney
	ld a, [hli]
	ldh [hDividend + 1], a
	ld a, [hli]
	ldh [hDividend + 2], a
	ld a, [hl]
	ldh [hDividend + 3], a
	predef DivideLong
	ldh a, [hLongQuotient + 1]
	and a
	jr nz, Mart_GetNumberYouCanBuy_Return99
Mart_GetNumberYouCanBuy_ReturnHalfword:
	ldh a, [hLongQuotient + 2]
	and a
	jr nz, Mart_GetNumberYouCanBuy_Return99
	ldh a, [hLongQuotient + 3]
	cp 99
	ret c
Mart_GetNumberYouCanBuy_Return99:
	ld a, 99
	ret

GetFarMartByte:
	ld a, [wMartPointerBank]
	jp GetFarByteAndIncrement

Text_Mart_Intro:
	ctxt "Welcome! How may I"
	line "help you?"
	done

Text_Mart_ComeAgain:
FarText_PleaseComeAgain::
	ctxt "Please come again!"
	done

Text_Mart_HowMany:
	ctxt "How many?"
	done
