; Trade struct
TRADE_DIALOG  EQU 0
TRADE_GIVEMON EQU 1
TRADE_GETMON  EQU 2
TRADE_NICK    EQU 3
TRADE_DVS     EQU 14
TRADE_ITEM    EQU 16
TRADE_OT_ID   EQU 17
TRADE_OT_NAME EQU 19
TRADE_GENDER  EQU 30
TRADE_PADDING EQU 31

; Trade dialogs
TRADE_INTRO    EQU 0
TRADE_CANCEL   EQU 1
TRADE_WRONG    EQU 2
TRADE_COMPLETE EQU 3
TRADE_AFTER    EQU 4

TRADE_EITHER_GENDER EQU 0
TRADE_MALE_ONLY     EQU 1
TRADE_FEMALE_ONLY   EQU 2

NPCTrade::
	ld a, e
	ld [wJumptableIndex], a
	call Trade_GetDialog
	ld b, CHECK_FLAG
	call TradeFlagAction
	ld a, TRADE_AFTER
	jr nz, .done

	ld a, TRADE_INTRO
	call PrintTradeText

	call YesNoBox
	ld a, TRADE_CANCEL
	jr c, .done

; Select givemon from party
	ld b, 6
	callba SelectTradeOrDaycareMon
	ld a, TRADE_CANCEL
	jr c, .done

	ld e, TRADE_GIVEMON
	call GetTradeAttribute
	ld a, [wCurPartySpecies]
	cp [hl]
	ld a, TRADE_WRONG
	jr nz, .done

	call CheckTradeGender
	ld a, TRADE_WRONG
	jr c, .done

	ld b, SET_FLAG
	call TradeFlagAction

	ld hl, ConnectLinkCableText
	call PrintText

	call DoNPCTrade
	call PushSoundstate
	call .TradeAnimation
	call GetTradeMonNames

	ld hl, TradedForText
	call PrintText

	call PopSoundstate

	ld a, TRADE_COMPLETE

.done
	jp PrintTradeText

.TradeAnimation
	call DisableSpriteUpdates
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	callba TradeAnimation
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	jp ReturnToMapWithSpeechTextbox

CheckTradeGender:
	xor a
	ld [wMonType], a

	ld e, TRADE_GENDER
	call GetTradeAttribute
	ld a, [hl]
	and a
	jr z, .matching
	cp 1
	jr z, .check_male

	callba GetGender
	jr nz, .not_matching
	jr .matching

.check_male
	callba GetGender
	jr z, .not_matching

.matching
	and a
	ret

.not_matching
	scf
	ret

TradeFlagAction:
	ld hl, wTradeFlags
	ld a, [wJumptableIndex]
	ld c, a
	predef FlagAction
	ld a, c
	and a
	ret

Trade_GetDialog:
	ld e, TRADE_DIALOG
	call GetTradeAttribute
	ld a, [hl]
	ld [wcf64], a
	ret

DoNPCTrade:
	ld e, TRADE_GIVEMON
	call GetTradeAttribute
	ld a, [hl]
	ld [wPlayerTrademonSpecies], a

	ld e, TRADE_GETMON
	call GetTradeAttribute
	ld a, [hl]
	ld [wOTTrademonSpecies], a

	ld a, [wPlayerTrademonSpecies]
	ld de, wPlayerTrademonSpeciesName
	call GetTradeMonName
	call CopyTradeName

	ld a, [wOTTrademonSpecies]
	ld de, wOTTrademonSpeciesName
	call GetTradeMonName
	call CopyTradeName

	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld de, wPlayerTrademonOTName
	call CopyTradeName

	ld hl, wPlayerName
	ld de, wPlayerTrademonSenderName
	call CopyTradeName

	ld hl, wPartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld de, wPlayerTrademonID
	call Trade_CopyTwoBytes

	ld hl, wPartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld de, wPlayerTrademonDVs
	call Trade_CopyTwoBytes

	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld b, h
	ld c, l
	callba GetCaughtGender
	ld a, c
	ld [wPlayerTrademonCaughtData], a

	ld e, TRADE_DIALOG
	call GetTradeAttribute
	ld a, [hl]
	cp 3
	; a = carry ? 1 : 2
	sbc a
	add 2
	ld [wOTTrademonCaughtData], a

	ld hl, wPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfCurrentPartymon
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld a, [wOTTrademonSpecies]
	ld [wCurPartySpecies], a
	xor a
	ld [wMonType], a
	ld [wPokemonWithdrawDepositParameter], a
	callba RemoveMonFromPartyOrBox
	predef TryAddMonToParty

	ld e, TRADE_DIALOG
	call GetTradeAttribute
	ld a, [hl]
	cp TRADE_COMPLETE
	ld b, RESET_FLAG
	jr c, .incomplete
	ld b, SET_FLAG
.incomplete
	callba SetGiftPartyMonCaughtData

	ld e, TRADE_NICK
	call GetTradeAttribute
	ld de, wOTTrademonNickname
	call CopyTradeName

	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonNickname
	call CopyTradeName

	ld e, TRADE_OT_NAME
	call GetTradeAttribute
	push hl
	ld de, wOTTrademonOTName
	call CopyTradeName
	pop hl
	ld de, wOTTrademonSenderName
	call CopyTradeName

	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonOTName
	call CopyTradeName

	ld e, TRADE_DVS
	call GetTradeAttribute
	ld de, wOTTrademonDVs
	call Trade_CopyTwoBytes

	ld hl, wPartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonDVs
	call Trade_CopyTwoBytes

	ld e, TRADE_OT_ID
	call GetTradeAttribute
	ld de, wOTTrademonID + 1
	call Trade_CopyTwoBytesReverseEndian

	ld hl, wPartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfLastPartymon
	ld hl, wOTTrademonID
	call Trade_CopyTwoBytes

	ld e, TRADE_ITEM
	call GetTradeAttribute
	push hl
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	call Trade_GetAttributeOfLastPartymon
	pop hl
	ld a, [hl]
	ld [de], a

	push hl
	push de
	push bc
	push af
	ld a, [wCurPartyMon]
	push af
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	callba ComputeNPCTrademonStats
	pop af
	ld [wCurPartyMon], a
	jp PopOffRegsAndReturn

GetTradeAttribute:
	ld d, 0
	push de
	ld a, [wJumptableIndex]
	and $f
	swap a
	ld e, a
	ld d, 0
	ld hl, NPCTrades
	add hl, de
	add hl, de
	pop de
	add hl, de
	ret

Trade_GetAttributeOfCurrentPartymon:
	ld a, [wCurPartyMon]
	rst AddNTimes
	ret

Trade_GetAttributeOfLastPartymon:
	ld a, [wPartyCount]
	dec a
	rst AddNTimes
	ld e, l
	ld d, h
	ret

GetTradeMonName:
	push de
	ld [wd265], a
	call GetBasePokemonName
	ld hl, wStringBuffer1
	pop de
	ret

CopyTradeName:
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret

Trade_CopyTwoBytes:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

Trade_CopyTwoBytesReverseEndian:
	ld a, [hli]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	ret

GetTradeMonNames:
	ld e, TRADE_GETMON
	call GetTradeAttribute
	ld a, [hl]
	call GetTradeMonName

	ld de, wStringBuffer2
	call CopyTradeName

	ld e, TRADE_GIVEMON
	call GetTradeAttribute
	ld a, [hl]
	call GetTradeMonName

	ld de, wMonOrItemNameBuffer
	call CopyTradeName

	ld hl, wStringBuffer1
.loop
	ld a, [hli]
	cp "@"
	jr nz, .loop

	dec hl
	push hl
	ld e, TRADE_GENDER
	call GetTradeAttribute
	ld a, [hl]
	pop hl
	and a
	ret z

	cp 1
	ld a, "♂"
	jr z, .done
	ld a, "♀"
.done
	ld [hli], a
	ld [hl], "@"
	ret

NPCTrades:
MACRO npctrade
	db \1, \2, \3, \4 ; dialog set, requested mon, offered mon, nickname
	db \5, \6 ; dvs
	db \7 ; item
	dw \8 ; OT ID
	db \9, \<10>, 0 ; OT name, gender requested
ENDM


	npctrade 0, EXEGGCUTE,  DRIFLOON,   "Carl@@@@@@@", $96, $66, PERSIM_BERRY, 48926, "Johnny@@@@@", TRADE_EITHER_GENDER ; 0
	npctrade 1, TYROGUE,    CHINGLING,  "Chimer@@@@@", $96, $86, LEPPA_BERRY,  15616, "Chris@@@@@@", TRADE_EITHER_GENDER ; 1
	npctrade 0, SOLROCK,    LUNATONE,   "Lunala@@@@@", $00, $00, MOON_STONE,   11187, "Lana@@@@@@@", TRADE_EITHER_GENDER ; 2
	npctrade 0, GYARADOS,   RELICANTH,  "Canth@@@@@@", $00, $00, NO_ITEM,      23864, "Kelly@@@@@@", TRADE_EITHER_GENDER ; 3
	npctrade 0, MAGMAR,     ELECTABUZZ, "Oni@@@@@@@@", $00, $00, NO_ITEM,      26483, "Marcus@@@@@", TRADE_EITHER_GENDER ; 4

PrintTradeText:
	push af
	call GetTradeMonNames
	pop af
	ld bc, 2 * 2
	ld hl, TradeTexts
	rst AddNTimes
	ld a, [wcf64]
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

TradeTexts:
; intro
	dw TradeIntroText1
	dw TradeIntroText2

; cancel
	dw TradeCancelText1
	dw TradeCancelText2

; wrong mon
	dw TradeWrongText1
	dw TradeWrongText2

; completed
	dw TradeCompleteText1
	dw TradeCompleteText2

; after
	dw TradeAfterText1
	dw TradeAfterText2

ConnectLinkCableText:
	; OK, connect the Game Link Cable.
	text_jump NPC_ConnectCableText

TradedForText:
	; traded givemon for getmon
	text_far NPC_Traded
	start_asm
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, SFX_DEX_FANFARE_80_109
	call PlaySFX
	call WaitSFX
	ld hl, GenericDummyString
	ret

TradeIntroText1:
	; I collect #mon. Do you have @ ? Want to trade it for my @ ?
	text_jump NPC_TradeIntro1

TradeCancelText1:
	; You don't want to trade? Aww…
	text_jump NPC_TradeCancel1

TradeWrongText1:
	; Huh? That's not @ .  What a letdown…
	text_jump NPC_TradeWrong1

TradeCompleteText1:
	; Yay! I got myself @ ! Thanks!
	text_jump NPC_TradeComplete1

TradeAfterText1:
	; Hi, how's my old @  doing?
	text_jump NPC_TradeAfter1

TradeIntroText2:
	; Hi, I'm looking for this #mon. If you have @ , would you trade it for my @ ?
	text_jump NPC_TradeIntro2

TradeCancelText2:
	; You don't have one either? Gee, that's really disappointing…
	text_jump NPC_TradeCancel2

TradeWrongText2:
	; You don't have @ ? That's too bad, then.
	text_jump NPC_TradeWrong2

TradeCompleteText2:
	; Uh? What happened?
	text_jump NPC_TradeComplete2

TradeAfterText2:
	; Trading is so odd… I still have a lot to learn about it.
	text_jump NPC_TradeAfter2
