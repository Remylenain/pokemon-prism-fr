SECTION "Text 1", ROMX

FarText_BetHowManyCoins::
	ctxt "Bet how many"
	line "coins?"
	done

FarText_MonStatRose::
	ctxt "<STRBF1>'s"
	line "<STRBF2> rose."
	prompt

PlayWithThreeCoinsText::
	ctxt "Play with three"
	line "coins?"
	done

NotEnoughCoinsText::
	ctxt "Not enough coins…"
	prompt

ChooseACardText::
	ctxt "Choose a card."
	done

PlaceYourBetText::
	ctxt "Place your bet."
	done

PlayAgainText::
	ctxt "Want to play"
	line "again?"
	done

CardsShuffledText::
	ctxt "The cards have"
	line "been shuffled."
	prompt

Text_KnowsMove::
	ctxt "<STRBF1> knows"
	line "<STRBF2>."
	prompt

TradeBadMoveFriend::
	ctxt "Your friend is"
	line "trying to trade a"
	para "#mon that has a"
	line "move that doesn't"
	cont "appear in Prism."
	prompt

TradeBadMove::
	ctxt "You can't trade"
	line "your <STRBF1>"
	cont "with <STRBF2>."
	prompt

YouUsedYourLastItemText::
	ctxt "You used your last"
	line "<STRBF2>."
	prompt

PutFossilInCaseText_::
	ctxt "<PLAYER> put the"
	line "Fossil in the"
	cont "Fossil Case."
	done

NoRoomForFossilText_::
	ctxt "But the Fossil"
	line "Case is full<...>"
	done

NoFossilCaseText_::
	ctxt "But <PLAYER> doesn't"
	line "have a Fossil"
	cont "Case<...>"
	done

FruitBearingTreeText::
	ctxt "It's a fruit-"
	line "bearing tree."
	done

HeyItsFruitText::
	ctxt "Hey! It's"
	line "<STRBF3>!"
	done

ItsShinyApricornText::
	ctxt "Hey! This is a"
	line "shiny Apricorn!"
	done

ObtainedFruitText::
	ctxt "Obtained"
	line "<STRBF3>!"
	done

FruitPackIsFullText::
	ctxt "But the pack is"
	line "full…"
	done

NothingHereText::
	ctxt "There's nothing"
	line "here…"
	done

Text_RecoveredSomeHP::
	ctxt "<STRBF1>"
	line "recovered @"
	deciram wCurHPAnimDeltaHP, 2, 3
	text "HP!"
	done

Text_CuredOfPoison::
	ctxt "<STRBF1>'s"
	line "cured of poison."
	done

Text_RidOfParalysis::
	ctxt "<STRBF1>'s"
	line "rid of paralysis."
	done

Text_BurnWasHealed::
	ctxt "<STRBF1>'s"
	line "burn was healed."
	done

Text_Defrosted::
	ctxt "<STRBF1>"
	line "was defrosted."
	done

Text_WokeUp::
	ctxt "<STRBF1>"
	line "woke up."
	done

Text_HealthReturned::
	ctxt "<STRBF1>'s"
	line "health returned."
	done

Text_Revitalized::
	ctxt "<STRBF1>"
	line "is revitalized."
	done

Text_GrewToLevel::
	ctxt "<STRBF1> grew to"
	line "level @"
	deciram wCurPartyLevel, 1, 3
	text "!"
	done

Text_CameToItsSenses::
	ctxt "<STRBF1> came"
	line "to its senses."
	done

Text_BattleTowerSelect_IsThisOkay::
	ctxt "Is this okay?"
	done

Trade_WasSentToText::
	text_from_ram wPlayerTrademonSpeciesName
	ctxt " was"
	line "sent to @"
	text_from_ram wOTTrademonSenderName
	text "."
	done

Trade_BidsFarewellText::
	text_from_ram wOTTrademonSenderName
	ctxt " bids"
	line "farewell to"
	done

Trade_TakeGoodCareOfText::
	ctxt "Take good care of"
	line "@"
Trade_SpeciesText::
	text_from_ram wOTTrademonSpeciesName
	text "."
	done

Trade_ForPlayersMon::
	text "For @"
	text_from_ram wPlayerTrademonSenderName
	text "'s"
	line "@"
	text_from_ram wPlayerTrademonSpeciesName
	text ","
	done

Trade_OtherSends::
	text_from_ram wOTTrademonSenderName
	ctxt " sends"
	line "@"
	text_from_ram wOTTrademonSpeciesName
	text "."
	done

Trade_WillTradeText::
	text_from_ram wOTTrademonSenderName
	ctxt " will"
	line "trade @"
	text_from_ram wOTTrademonSpeciesName
	done

Trade_ForOthersMon::
	text "for @"
	text_from_ram wPlayerTrademonSenderName
	text "'s"
	line "@"
	text_from_ram wPlayerTrademonSpeciesName
	text "."
	done

MapMysteryZoneText::
	ctxt "That's strange<...>"
	para "The map is only"
	line "displaying static."
	prompt

Text_Gained::
	ctxt "<STRBF1> gained"
	done

Text_ABoostedStringBuffer2ExpPoints::
	ctxt ""
	line "a boosted"
	cont "@"
	deciram wStringBuffer2, 2, 4
	ctxt " Exp. Points!"
	prompt

Text_StringBuffer2ExpPoints::
	text ""
	line "@"
	deciram wStringBuffer2, 2, 4
	ctxt " Exp. Points!"
	prompt

Text_GoPkmn::
	text "Go! "
	done

Text_DoItPkmn::
	ctxt "Do it! "
	done

Text_GoForItPkmn::
	ctxt "Go for it,"
	line ""
	done

Text_YourFoesWeakGetmPkmn::
	ctxt "Your foe's weak!"
	line "Get'm, "
	done

Text_BattleMonNick01::
	text "<BMON>!"
	done

Text_BattleMonNickComma::
	text "<BMON>,"
	done

Text_ThatsEnoughComeBack::
	ctxt " that's"
	line "enough! Come back!"
	done

Text_OKComeBack::
	ctxt " OK!"
	line "Come back!"
	done

Text_GoodComeBack::
	ctxt " good!"
	line "Come back!"
	done

Text_ComeBack::
	ctxt " come"
	line "back!"
	done

Text_BootedUpTM::
	ctxt "Booted up a TM."
	prompt

Text_BootedUpHM::
	ctxt "Booted up an HM."
	prompt

Text_AskTeachTM::
	ctxt "It contained"
	line "<STRBF2>."

	para "Teach <STRBF2>"
	line "to a #mon?"
	done

Text_NotCompatible::
	ctxt "<STRBF2> is"
	line "not compatible"
	cont "with <STRBF1>."

	para "It can't learn"
	line "<STRBF2>."
	prompt

_CantSurfSaxifrageText::
	ctxt "The water's moving"
	line "too fast to Surf!"
	done

_BadgeRequiredText::
	ctxt "Sorry! A new badge"
	line "is required."
	prompt

_CantUseFlyHere::
	ctxt "There's nowhere to"
	line "fly to!"
	prompt

_CantFlySaxifrage::
	ctxt "Saxifrage guards"
	line "forbid flying!"
	prompt

_CantFlyUndercover::
	ctxt "Not now! You're"
	line "on a mission!"
	prompt

_CantFlyParkChallenge::
	ctxt "You can't Fly while"
	line "in the challenge!"
	prompt

FieldMoveFailedText::
	ctxt "You can't use"
	line "that here."
	prompt

UsedCutText::
	ctxt "<STRBF2> used"
	line "Cut!"
	prompt

NothingToCutText::
	ctxt "There's nothing to"
	line "Cut here."
	prompt

UseFlashText::
	ctxt "A blinding Flash"
	line "lights the area!"
	prompt

Toss_TooImportant::
	ctxt "That's too impor-"
	line "tant to toss out!"
	prompt

SECTION "Text 2", ROMX

ElevatorText::
	ctxt "Which floor?"
	done

Text_RepelWoreOff::
	ctxt "Repel's effect"
	line "wore off."
	done

UseAnotherRepelText::
	ctxt ""
	para "Use another?"
	done

UseWhichRepelText::
	ctxt "Use which Repel?"
	done

Text_FoundHiddenItem::
	ctxt "<PLAYER> found"
	line "<STRBF3>!"
	done

Text_NoSpaceForHiddenItem::
	ctxt "But <PLAYER> has"
	line "no space left<...>"
	done

NoCoinsText::
	ctxt "You have no coins."
	prompt

NoCoinCaseText::
	ctxt "You don't have a"
	line "Coin Case."
	prompt

NPC_ConnectCableText::
	ctxt "OK, connect the"
	line "Game Link Cable."
	prompt

NPC_Traded::
	ctxt "<PLAYER> traded"
	line "<MINB> for"
	cont "<STRBF2>."
	done

NPC_TradeIntro1::
	ctxt "I collect #mon."
	line "Do you have"
	cont "<STRBF1>?"

	para "Want to trade it"
	line "for my <STRBF2>?"
	done

NPC_TradeCancel1::
	ctxt "You don't want to"
	line "trade? Aww…"
	done

NPC_TradeWrong1::
	ctxt "Huh? That's not"
	line "<STRBF1>."
	cont "What a letdown…"
	done

NPC_TradeComplete1::
	ctxt "Yay! I got myself"
	line "<STRBF1>!"
	cont "Thanks!"
	done

NPC_TradeAfter1::
	ctxt "Hi, how's my old"
	line "<STRBF2> doing?"
	done

NPC_TradeIntro2::
	ctxt "Hi, I'm looking"
	line "for this #mon."

	para "If you have"
	line "<STRBF1>, would"
	para "you trade it for"
	line "my <STRBF2>?"
	done

NPC_TradeCancel2::
	ctxt "You don't have one?"

	para "Gee, that's really"
	line "disappointing<...>"
	done

NPC_TradeWrong2::
	ctxt "You don't have"
	line "<STRBF1>? That's"
	cont "too bad, then."
	done

NPC_TradeComplete2::
	ctxt "Great! Thank you!"

	para "I finally got"
	line "<STRBF1>."
	done

NPC_TradeAfter2::
	ctxt "Trading is so odd<...>"

	para "I still have a lot"
	line "to learn about it."
	done

_UsedSurfText::
	ctxt "<STRBF2> used"
	line "Surf!"
	done

_CantSurfText::
	ctxt "You can't use"
	line "Surf here."
	prompt

_AlreadySurfingText::
	ctxt "You're already"
	line "surfing."
	prompt

AskSurfText::
	ctxt "The water is calm."
	line "Want to Surf?"
	done

UsedDigText::
	ctxt "<STRBF2> used"
	line "Dig!"
	done

UsedRopeText::
	ctxt "<PLAYER> used an"
	line "Escape Rope."
	done

FailDigText::
	ctxt "You can't use"
	line "that here."
	done

FailTeleportText::
	ctxt "You can't use"
	line "that here."

	para ""
	done

StrengthText::
	ctxt "<STRBF1> can"
	line "move boulders."
	done

AskStrength::
	ctxt "A #mon may be"
	line "able to move this."

	para "Want to use"
	line "Strength?"
	done

AlreadyUsedStrength::
	ctxt "Boulders may now"
	line "be moved!"
	done

DontMeetStrengthRequirements::
	ctxt "A #mon may be"
	line "able to move this."
	done

_HeadbuttText::
	ctxt "<STRBF2> did a"
	line "Headbutt!"
	prompt

HeadbuttFailText::
	ctxt "Nope. Nothing…"
	done

AskHeadbutt::
	ctxt "A #mon could be"
	line "in this tree."

	para "Want to Headbutt"
	line "it?"
	done

RockSmashText::
	ctxt "<STRBF2> used"
	line "Rock Smash!"
	prompt

FarText_BreakableRock_NoHM::
	ctxt "Maybe a #mon"
	line "can break this."
	done

FarText_BreakableRock_HasHM::
	ctxt "This rock looks"
	line "breakable."

	para "Want to use"
	line "Rock Smash?"
	done

Fishing_Bite_Text::
	ctxt "Oh!"
	line "A bite!"
	prompt

Fishing_Nope_Text::
	ctxt "Not even a nibble!"
	prompt

Bike_CantGetOff_Text::
	ctxt "You can't dismount"
	line "here!"
	sdone

Bike_GotOn_Text::
	ctxt "<PLAYER> got on"
	line "the <STRBF2>."
	sdone

Bike_GotOff_Text::
	ctxt "<PLAYER> got off"
	line "the <STRBF2>."
	sdone

AskCutText::
	ctxt "Oh, this tree"
	line "can be cut!"

	para "Want to use Cut?"
	done

CantCutText::
	ctxt "Oh, this tree"
	line "can be cut!"
	done

WhiteoutText::
	ctxt "<PLAYER> is out of"
	line "useable #mon!"
	prompt

PaidToWinnerText::
	text "<PLAYER> paid"
	line "¥@"
	deciram hMoneyTemp, 3, 7
	ctxt " to the"
	cont "winner…"
	done

PanickedAndDroppedText::
	ctxt "<PLAYER> panicked"
	line "and dropped"
	cont "¥@"
	deciram hMoneyTemp, 3, 7
	text "…"
	done

FinishWhiteOutText::
	text ""
	para "<......> <......> <......>"
	line "<......> <......> <......>"

	para "<PLAYER> whited"
	line "out!"
	sdone

SweetScentText::
	ctxt "<STRBF3> used"
	line "Sweet Scent!"
	sdone

SweetScentNothingHere::
	ctxt "Looks like there's"
	line "nothing here<...>"
	done

SacredAshText::
	ctxt "<PLAYER>'s #mon"
	line "were all healed!"
	done

Text_AnEGGCantHoldAnItem::
	ctxt "An Egg can't hold"
	line "an item."
	prompt

Pack_NoItems::
	ctxt "No items."
	done

Pack_AskTossQty::
	ctxt "Throw away how"
	line "many?"
	done

Pack_ConfirmToss::
	ctxt "Throw away @"
	deciram wItemQuantityChangeBuffer, 1, 2
	text ""
	line "<STRBF2>(s)?"
	done

Pack_Tossed::
	ctxt "Threw away"
	line "<STRBF2>(s)."
	prompt

Text_YouDontHaveAPkmn::
	ctxt "You don't have a"
	line "#mon!"
	prompt

Pack_RegisteredItem::
	ctxt "Registered the"
	line "<STRBF2>."
	prompt

Pack_CantRegister::
	ctxt "You can't register"
	line "that item."
	prompt

Pack_MoveWhere::
	ctxt "Where should this"
	line "be moved to?"
	done

Text_YouCantUseItInABattle::
	ctxt "You can't use it"
	line "in a battle."
	prompt

Battle_UsersStatText::
	text "<USER>'s"
	line "<STRBF2>"
	done

Battle_WayUpText::
	ctxt ""
	cont "rose sharply!"
	prompt

Text_RoseDrastically::
	ctxt ""
	cont "rose drastically!"
	prompt

Battle_RoseText::
	ctxt " rose!"
	prompt

Battle_TargetsStatText::
	text "<TARGET>'s"
	line "<STRBF2>"
	done

Battle_HarshlyFellText::
	ctxt ""
	cont "harshly fell!"
	prompt

Text_SeverelyFell::
	ctxt ""
	cont "severely fell!"
	prompt

Battle_FellText::
	ctxt " fell!"
	prompt

Battle_UserText::
	text "<USER>"
	done

Battle_SolarbeamText::
	ctxt ""
	line "took in sunlight!"
	prompt

Battle_SkullBashText::
	ctxt ""
	line "lowered its head!"
	prompt

Battle_SkyAttackText::
	ctxt ""
	line "is glowing!"
	prompt

Battle_FlyText::
	ctxt ""
	line "flew up high!"
	prompt

Battle_DigText::
	ctxt ""
	line "dug a hole!"
	prompt

_ActorNameText::
	ctxt "<USER>"
	line "used "
	done

_UsedInsteadText::
	ctxt "instead,"
	cont "@"
_MoveNameText::
	text "<STRBF2>!"
	done

Text_WasSentToBillsPC::
	ctxt "<STRBF1> was"
	line "sent to Bill's PC."
	prompt

BillsPC_GottaHaveMon::
	ctxt "You gotta have"
	line "#mon to call!"
	prompt

BillsPC_What::
	text "What?"
	done

GiveNicknameText::
	ctxt "Give a nickname to"
	line "the <STRBF1> you"
	cont "received?"
	done

PC_TurnedOnText::
	ctxt "<PLAYER> turned on"
	line "the PC."
	prompt

PC_WhatToDoText::
	ctxt "What do you want"
	line "to do?"
	done

_KrissPCHowManyWithdrawText::
	ctxt "How many do you"
	line "want to withdraw?"
	done

_KrissPCWithdrewItemsText::
	ctxt "Withdrew @"
	deciram wItemQuantityChangeBuffer, 1, 2
	text ""
	line "<STRBF2>(s)."
	prompt

_KrissPCNoRoomWithdrawText::
	ctxt "There's no room"
	line "for more items."
	prompt

PC_NoItemsText::
	ctxt "No items here!"
	prompt

_KrissPCHowManyDepositText::
	ctxt "How many do you"
	line "want to deposit?"
	done

_KrissPCDepositItemsText::
	ctxt "Deposited @"
	deciram wItemQuantityChangeBuffer, 1, 2
	text ""
	line "<STRBF2>(s)."
	prompt

_KrissPCNoRoomDepositText::
	ctxt "There's no room to"
	line "store items."
	prompt

PC_WhichPCText::
	ctxt "Access whose PC?"
	done

PC_BillsPCText::
	ctxt "Bill's PC"
	line "accessed."

	para "#mon Storage"
	line "System opened."
	prompt

PC_PlayerPCText::
	ctxt "Accessed own PC."

	para "Item Storage"
	line "System opened."
	prompt

_RateText::
	ctxt "<STRBF3> #mon seen"
	line "<STRBF4> #mon owned"
	done

TotalTokensText::
	ctxt "TokenTracker"
	done

FoundTokensText::
	ctxt "found @"
	deciram wTotalTokensCount, 1, 3
	text "/100"
	done

SlotMachine_StartText::
	ctxt "Start!"
	done

SlotMachine_NoCoins::
	ctxt "Not enough"
	line "coins."
	prompt

SlotMachine_OutOfCoins::
	ctxt "Darn<...> Ran out of"
	line "coins again<...>"
	done

SlotMachine_PlayAgain::
	ctxt "Play again?"
	done

SlotMachine_LinedUp::
	ctxt "lined up!"
	line "Won <STRBF2> coins!"
	done

SlotMachine_Darn::
	text "Darn!"
	done

ReceivedFossilText_::
	ctxt "<PLAYER> received"
	line "a Fossil!"
	done

Evolve_CongratulationsText::
	ctxt "Congratulations!"
	line "Your <STRBF2>"
	done

Evolve_IntoText::
	ctxt ""
	para "evolved into"
	line "<STRBF1>!"
	done

Evolve_Stopped::
	ctxt "Huh? <STRBF2>"
	line "stopped evolving!"
	prompt

Evolve_Evolving::
	ctxt "What? <STRBF2>"
	line "is evolving!"
	done

ItemStorageFullText::
	ctxt "Item storage space"
	line "full."
	prompt

HoldItem_TookText::
	ctxt "Took <STRBF1>"
	line "from <MINB>."
	prompt

HoldItem_AskSwitch::
	ctxt "<MINB> is"
	line "already holding"

	para "<STRBF1>."
	line "Switch items?"
	done

HoldItem_CantBeHeldText::
	ctxt "This item can't be"
	line "held."
	prompt

Text_NotEnoughHP::
	ctxt "Not enough HP!"
	prompt

Link_TooMuchTimeElapsedText::
	ctxt "Too much time has"
	line "elapsed. Please"
	cont "try again."
	prompt

Link_CantTradeLastMonText::
	ctxt "If you trade that"
	line "#mon, you won't"
	cont "be able to battle."
	prompt

Link_AbnormalText::
	ctxt "Your friend's"
	line "<STRBF1> appears"
	cont "to be abnormal!"
	prompt

Link_AskTrade::
	ctxt "Trade @"
	text_from_ram wd004
	ctxt ""
	line "for <STRBF1>?"
	done

_ObjectEventText::
	ctxt "Object event"
	done

_AddSignpostText::
	text "TBA."
	done

HoldItem_SwapText::
	ctxt "Took <MINB>'s"
	line "<STRBF1> and"

	para "made it hold"
	line "<STRBF2>."
	prompt

HoldItem_MadeHold::
	ctxt "Made <MINB>"
	line "hold <STRBF2>."
	prompt

MonIsntHoldingAnythingText::
	ctxt "<MINB> isn't"
	line "holding anything."
	prompt

ConfirmThrowAwayItemText::
	ctxt "Throw away"
	line "<STRBF2>?"
	done

ThrewAwaySingularItemText::
	ctxt "Threw away"
	line "<STRBF2>."
	prompt

Toss_AskHowMany::
	ctxt "Toss out how many"
	line "<STRBF2>(s)?"
	done

Toss_Confirm::
	ctxt "Throw away @"
	deciram wItemQuantityChangeBuffer, 1, 2
	text ""
	line "<STRBF2>(s)?"
	done

Text_Discarded::
	ctxt "Discarded"
	line "<STRBF1>(s)."
	prompt

MemoryGame_Yeah::
	ctxt " , yeah!"
	done

MemoryGame_Darn::
	ctxt "Darn…"
	done

PC_LinkClosedText::
	ctxt "…"
	line "Link closed…"
	done

Text_EnemyWithdrew::
	ctxt "<ENEMY>"
	line "withdrew"
	cont "<EMON>!"
	prompt

Text_EnemyUsedOn::
	ctxt "<ENEMY>"
	line "used <MINB>"
	cont "on <EMON>!"
	prompt
