GameCornerBlackjack::
	opentext
	special Special_DisplayCoinCaseBalance
	writetext BlackjackWelcome
	yesorno
	sif false
		closetextend
.choseplayblackjack
	writetext BetAmountText
	loadmenudata BlackjackBetMenu
	verticalmenu
	closewindow
	sif false
		closetextend
	callasm SetBetType
	callasm BlackjackPlaceBet
	sif =, 2
		jumptext BlackjackNotEnoughCoinsText
.blackjackprepare
	playsound SFX_TRANSACTION
	special Special_DisplayCoinCaseBalance
	waitsfx
	callasm BlackjackInit

.blackjackloop
	writetext BlackjackWhatToDo
	menuanonjumptable BlackjackMenu
	dw .blackjackloop
	dw .hit
	dw .stand
	dw .doubledown
	dw .yourhand
	dw .dealerhand

.yourhand
	callasm DisplayCards
	writetext DisplayCardHand
	waitbutton
	jump .blackjackloop

.dealerhand
	callasm DisplayDealerCards
	writetext BlackjackDealersHandText
	waitbutton
	jump .blackjackloop

.hit
	callasm BlackjackHit
	callasm CountPlayerCards
	writetext DisplayCount
	iffalse .blackjackloop
.playerbust
	writetext BlackjackBustedText
	playwaitsfx SFX_WRONG
	writetext CardGamePlayAgain
	yesorno
	iftrue .choseplayblackjack
	closetextend

.doubledown
	callasm BlackjackBetMain
	sif =, 2, then
		writetext CardGameNotEnoughCoinsText
		waitbutton
		jump .blackjackloop
	sendif
	playsound SFX_TRANSACTION
	special Special_DisplayCoinCaseBalance
	waitsfx
	callasm DoubleDown
	callasm BlackjackHit
	callasm CountPlayerCards
	writetext DisplayCount
	if_equal 1, .playerbust
.stand
	callasm BlackjackStand
	writetext DealerDisplaysWholeDeck
	callasm GetFullDealerHand
	writetext DisplayCardHand
	waitbutton
	writetext DisplayDealerCount
	callasm CheckIfDealerBusted
	if_equal 1, .dealerbusted
	callasm CountPlayerCards
	writetext DisplayCount
	callasm DetermineBlackjackWinner
	anonjumptable
	dw .lose
	dw .push
	dw .win

.lose
	writetext BadHandText
	playwaitsfx SFX_WRONG
	special Special_DisplayCoinCaseBalance
	waitbutton
	jump .blackjackaskplayagain

.dealerbusted
	writetext DealerBustedText
.win
	writetext YouWonText
	playwaitsfx SFX_DEX_FANFARE_170_199
	playsound SFX_TRANSACTION
	callasm BlackjackWonCoins
	special Special_DisplayCoinCaseBalance
	waitbutton
	jump .blackjackaskplayagain

.push
	writetext PushText
	playsound SFX_TRANSACTION
	callasm BlackjackPushCoins
	special Special_DisplayCoinCaseBalance
	waitbutton

.blackjackaskplayagain
	writetext CardGamePlayAgain
	yesorno
	iftrue .choseplayblackjack
	closetextend

DoubleDown:
	ld hl, wTempNumber + 1
	set 2, [hl]
	ret

BlackjackGetBetAmount:
	ld a, [wTempNumber + 1]
	and 3
	ld hl, .bets
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ret

.bets
	db 10, 25, 50, 100

BlackjackPlaceBet:
	ldh a, [hScriptVar]
	dec a
	ld [wTempNumber + 1], a
BlackjackBetMain:
	call BlackjackGetBetAmount
	ld c, a
	ldh [hMoneyTemp + 1], a
	xor a
	ld bc, hMoneyTemp
	ld [bc], a
	callba CheckCoins
	jr c, .not_enough_coins
	ld a, 1
	jr z, .load_and_take_coins
	xor a
.load_and_take_coins
	ldh [hScriptVar], a
	jpba TakeCoins

.not_enough_coins
	ld a, 2
	ldh [hScriptVar], a
	ret

BlackjackWonCoins:
	call BlackjackGetBetAmount
	add a, a
	jr BlackjackGiveCoins

BlackjackPushCoins:
	call BlackjackGetBetAmount
BlackjackGiveCoins:
	and a
	ld hl, wTempNumber + 1
	bit 2, [hl]
	jr z, .no_double_down
	add a, a
.no_double_down
	ldh [hMoneyTemp + 1], a
	sbc a
	and 1
	ld bc, hMoneyTemp
	ld [bc], a
	jpba GiveCoins

SetBetType:
	ldh a, [hScriptVar]
	dec a
	ld [wTempNumber + 1], a
	ret

CheckIfDealerBusted:
	ld a, [wTempNumber]
	cp 22
	sbc a
	inc a
	ldh [hScriptVar], a
	ret

BlackjackStand:
.drawto17
	call BlackjackGetDealerCard
	jr nc, .drawto17
	ret

GetFullDealerHand:
	ld hl, wDealerCardHand
	jp DisplayCardsMain

BlackjackHit:
	xor a
	ldh [hScriptVar], a
	call BlackjackGetPlayerCard
	call CountPlayerCards
	cp 22
	jp c, BlackjackGetDealerCard
	ld a, 1
	ldh [hScriptVar], a
	ret

DetermineBlackjackWinner:
	ld a, [wTempNumber]
	ld b, a
	push bc
	call CountDealerCards
	pop bc
	ld a, [wTempNumber]  ;a: dealer b: yours
	cp b
	ld a, 1
	jr z, .load
	sbc a
	and 2
.load
	ldh [hScriptVar], a
	ret

BlackjackInit:
	call InitializeDeck
	call BlackjackGetPlayerCard
	call BlackjackGetPlayerCard
	call BlackjackGetDealerCard
	jp BlackjackGetDealerCardFaceDown

CountDealerCards:
	ld hl, wDealerCardHand
	jr CountCards

CountPlayerCards:
	ld hl, wYourCardHand
CountCards:
	ld c, 0 ;top bit: aces found, rest: total
.loop
	ld a, [hli]
	inc a
	jr z, .done
	and $f
	inc a
	cp 10 ;face card
	jr c, .addcard
	cp 14 ;ace
	ld a, 10
	jr nz, .addcard
	ld a, 1
	set 7, c
.addcard
	add a, c
	ld c, a
	jr .loop

.done
	ld a, c
	add a, a ;sets carry if there are aces, doubles the sum, and gets rid of the top bit
	jr nc, .load
	cp 12 * 2 ;check if the ace bonus will exceed 21
	jr nc, .load
	add a, 20
.load
	; note that carry is always clear here, and a is doubled
	rra
	ld [wTempNumber], a
	ret

BlackjackGetPlayerCard:
	ld hl, wYourCardHand
	lb bc, 0, 11
	jp GetCardFromDeck

BlackjackGetDealerCard:
	ld hl, wDealerCardHand
	call CountCards
	cp 17
	jr nc, .stand ;Stand on 17
	ld hl, wDealerCardHand
	lb bc, 1, 11
	call GetCardFromDeck
	xor a
	ret

.stand
	ld hl, DealerStandsText
	ld b, BANK(DealerStandsText)
	call MapTextbox
	call WaitButton
	scf
	ret

BlackjackGetDealerCardFaceDown:
	ld hl, wDealerCardHand
	lb bc, 2, 11
	jp GetCardFromDeck

BlackjackWelcome:
	ctxt "Welcome to"
	line "Blackjack!"

	para "Want to play?"
	done

BlackjackNotEnoughCoinsText:
	ctxt "You don't have"
	line "enough coins."
	done

DisplayCount:
	ctxt "Your total: @"
	deciram wTempNumber, 1, 0
	text ""
	sdone

DisplayDealerCount:
	ctxt "Dealer total: @"
	deciram wTempNumber, 1, 0
	text ""
	sdone

BlackjackBustedText:
	ctxt "You busted!"
	done

BlackjackWhatToDo:
	ctxt "What do you want"
	line "to do?"
	done

BlackjackDealersHandText:
	text "? <STRBF1>"
	done

DealerStandsText:
	ctxt "Dealer stands."
	done

PushText:
	ctxt "Push!"
	done

YouWonText:
	ctxt "You won!"
	done

DealerDisplaysWholeDeck:
	ctxt "Dealer reveals the"
	line "face down card."
	sdone

DealerBustedText:
	ctxt "The dealer busted!"
	sdone

BetAmountText:
	ctxt "How much do you"
	line "want to bet?"
	done

BlackjackMenu:
	db $40 ; flags
	db 0, 0 ; start coords
	db 11, 15 ; end coords
	dw .options
	db 1 ; default option

.options
	db $80
	db 5
	db "Hit@"
	db "Stand@"
	db "Double Down@"
	db "Your hand@"
	db "Dealer's hand@"

BlackjackBetMenu:
	db $40 ; flags
	db 0, 0 ; start coords
	db 9, 7 ; end coords
	dw .options
	db 1 ; default option

.options
	db $80
	db 4
	db "10@"
	db "25@"
	db "50@"
	db "100@"
