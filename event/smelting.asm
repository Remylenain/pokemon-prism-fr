SmeltingScript::
	scall .SmeltingScript
	return_if_callback_else_end

.SmeltingScript:
	opentext
	checkitem ORE
	iffalse .noore
	checkitem COAL
	iftrue .coalandore

.smeltore
	checkitem ORE_CASE
	sif false
		jumptext SmeltingNeedOreCaseForOresText
	killsfx
	playwaitsfx SFX_BURN
	takeitem ORE

	variablestablerandom VSR_SMELTINGORE, 100
	addvar 1
	copyvartobyte wScriptBuffer
	copybytetovar wSmeltingLevel
	addvar 101
	divideby 2
	comparevartobyte wScriptBuffer
	sif =, 1, then
		writebyte $ff
	selse
		writebyte 0
		jump .handleLoop
.loop
		popvar
		addvar 1
.handleLoop
		pushvar
		loadarray OrePercentChances, 2
		readarray 0
		comparevartobyte wScriptBuffer
		if_equal 1, .loop
		popvar
		readarray 1
		getnthstring OreNames, 0
	sendif

	writehalfword FailedSmeltText
	if_equal $ff, .smeltingFinish
	addhalfwordtovar wOreCaseInventory
	writebyte 99
	comparevartobyte -1
	sif true, then
		giveitem ORE
		jumptext NotEnoughSpaceInOreCaseText
	selse
		copyhalfwordvartovar
		addvar 1
		copyvartohalfwordvar
	sendif
	writehalfword GotOreText
.smeltingFinish
	writetext -1
.giveSmeltingEXP
	writebyte 1
	givecraftingEXP CRAFT_SMELTING
.closetextend
	closetextend

.coalandore
	writetext ChooseSmeltText

	menuanonjumptable WhichToSmelt
	dw .closetextend
	dw .smeltore
	dw .smeltcoal
	dw .closetextend

.noore
	checkitem COAL
	sif false
		jumptext NoOreText
.smeltcoal
	checkitem SOOT_SACK
	sif false
		jumptext NoSootSackText

	killsfx
	playwaitsfx SFX_BURN
	takeitem COAL, 1
	copybytetovar wSmeltingLevel
	addvar 10
	variablestablerandom VSR_SMELTINGCOAL, -1
	addvar 10
	copyvartobyte hMoneyTemp + 1
	loadvar hMoneyTemp, 0
	scriptstartasm
	ld bc, hMoneyTemp
	callba GiveAsh
	scriptstopasm
	writetext CollectedAshText
	jump .giveSmeltingEXP

WhichToSmelt:
	db $40 ; flags
	db 04, 00 ; start coords
	db 11, 9 ; end coords
	dw .MenuDataSmelt
	db 1 ; default option

.MenuDataSmelt:
	db $80 ; flags
	db 3 ; items
	db "Ore@"
	db "Coal@"
	db "Cancel@"

ChooseSmeltText::
	ctxt "Which would you"
	line "like to smelt?"
	done

FailedSmeltText::
	ctxt "You failed at"
	line "smelting this ore."
	sdone

NotEnoughSpaceInOreCaseText::
	ctxt "You smelted a"
	line "<STRBF1> Ore."

	para "The Ore Case can't"
	line "hold any more of"
	cont "this Ore<...>"
	sdone

GotOreText::
	ctxt "You smelted a"
	line "<STRBF1> Ore!"

	para "The <STRBF1>"
	line "Ore was put in the"
	cont "Ore Case."
	sdone

GotCoinsWorthText::
	ctxt "Got coins worth"
	line "¥@"
	deciram wTempNumber, 2, 0
	text "!"
	sdone

NoOreText::
	ctxt "You need Ore or"
	line "Coal to smelt."
	done

SmeltingNeedOreCaseForOresText::
	ctxt "You can't hold onto"
	line "smelted ores"
	para "without an Ore"
	line "Case."
	done

CollectedAshText::
	ctxt "You were able to"
	line "collect @"
	deciram hMoneyTemp, 2, 0
	ctxt " ash!"
	sdone

NoSootSackText:
	ctxt "You can't hold onto"
	line "ash without a Soot"
	cont "Sack."
	done

GetOreName::
; get the ore name in a and copy to wStringBuffer2
	ld hl, OreNames
	call GetNthString
	ld d, h
	ld e, l
	call CopyName1
	ld de, wStringBuffer2
	ret

OreNames:
	db "Zinc@" ;10
	db "Copper@" ;25
	db "Lead@" ;50
	db "Iron@" ;200
	db "Bronze@" ;500
	db "Silver@" ;1000
	db "Ruthenium@" ;3500
	db "Gold@" ;5000
	db "Cobalt@" ;7500
	db "Prism@" ;10000

OrePercentChances: ;Reveal a new ore every X
	;ALL LEVELS
	db 11,  ORE_ZINC ;11%
	db 22,  ORE_COPPER ;11%
	db 32,  ORE_LEAD ;10%
	db 42,  ORE_IRON ;10%
	db 52,  ORE_BRONZE ;10%
	;LEVEL 4
	db 55,  ORE_SILVER ;3%
	db 56,  ORE_LEAD ;1%
	;LEVEL 12
	db 58,  ORE_RUTHENIUM  ;2%
	db 59,  ORE_COPPER  ;1%
	db 60,  ORE_BRONZE  ;1%
	;LEVEL 20
	db 62,  ORE_GOLD  ;2%
	db 63,  ORE_LEAD  ;1%
	db 65,  ORE_ZINC  ;2%
	;LEVEL 30
	db 67,  ORE_COBALT  ;2%
	db 69,  ORE_COPPER  ;2%
	db 71,  ORE_LEAD  ;2%
	db 73,  ORE_IRON  ;2%
	db 74,  ORE_RUTHENIUM  ;1%
	db 75,  ORE_GOLD  ;1%
	;LEVEL 50
	db 76,  ORE_PRISM  ;1%
	db 77,  ORE_ZINC  ;1%
	db 78,  ORE_COPPER  ;1%
	db 79,  ORE_LEAD  ;1%
	db 80,  ORE_IRON  ;1%
	db 81,  ORE_BRONZE  ;1%
	db 85,  ORE_SILVER  ;4%
	db 87,  ORE_RUTHENIUM  ;2%
	db 88,  ORE_GOLD  ;1%
	db 89,  ORE_COBALT  ;1%
	db 91,  ORE_ZINC  ;2%
	db 93,  ORE_RUTHENIUM  ;2%
	db 94,  ORE_SILVER  ;1%
	db 96,  ORE_GOLD  ;2%
	db 98,  ORE_SILVER  ;2%
	db 99,  ORE_RUTHENIUM  ;1%
	db 100, ORE_COBALT ;1%

;Zinc: 16%
;Copper: 15%
;Lead: 14%
;Iron: 13%
;Bronze: 12%
;Silver: 11%
;Ruthenium: 8%
;Gold: 6%
;Cobalt: 4%
;Prism: 1%

OpenOreCaseMenu:
	ld a, [wUsingItemWithSelect]
	and a
	jr nz, .fromSelect
	ld c, 1 << 7 | 3
	call FadeToWhite
.fromSelect
	call ClearScreen
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	ldh a, [hInMenu]
	push af
	ld a, 1
	ldh [hInMenu], a
	ld de, wOreCaseInventory
	ld hl, wTempOreCaseInventory + 1
	lb bc, 0, 10
.copyAndPadOreCaseInventoryLoop
	ld a, [de]
	inc de
	and a
	jr z, .oreNonExistant
	push af
	ld a, 10
	sub c
	ld [hli], a
	pop af
	ld [hli], a
	inc b
.oreNonExistant
	dec c
	jr nz, .copyAndPadOreCaseInventoryLoop
	ld [hl], $ff
	ld a, b
	ld [wTempOreCaseInventory], a
	call CalculateTotalWorthOfOres
	ld hl, OreCase_MenuHeader
	call CopyMenuHeader
	call InitScrollingMenu
	xor a
	ld [wMenuScrollPosition], a
	inc a
	ld [wMenuCursorBuffer], a
	call ScrollingMenu
	pop af
	ldh [hInMenu], a
	ret

OreCase_MenuHeader:
	db %1100000 ; flags
	db 01, 02 ; start coords
	db 09, 17 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db %110000 ; flags
	db 4, SCREEN_WIDTH + 11 ; rows, quantity spacing
	db 2 ; num bytes per entry
	dbw 0, wTempOreCaseInventory
	dba .PrintOreName
	dba .PrintOreQuantity
	dba .PrintOreCost

.PrintOreName:
	push de
	ld a, [wMenuSelection]
	call GetOreName
	pop hl
	call PlaceString
	ld h, b
	ld l, c
	ld a, " "
	ld [hli], a
	ld de, .OreString
	jp PlaceString

.OreString:
	db "Ore@"

.PrintOreQuantity
	ld h, d
	ld l, e
	ld a, "×"
	ld [hli], a
	ld de, wMenuSelectionQuantity
	lb bc, 1, 2
	jp PrintNum

.PrintOreCost
	call SpeechTextBox
	ld a, [wMenuSelection]
	cp -1
	jr z, .printTotal
	ld hl, OrePrices
	add a
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	ld [wTempNumber + 1], a
	ld a, [hl]
	ld [wTempNumber], a
	coord hl, 1, 14
	ld de, .WorthString
	call PlaceText
	ld hl, wTempNumber
	push hl
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	xor a
	ldh [hMultiplicand], a
	ld a, [wMenuSelectionQuantity]
	ldh [hMultiplier], a
	predef Multiply
	pop hl
	ldh a, [hProduct + 1]
	ld [hli], a
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	ld de, .NetWorthString
	coord hl, 1, 16
	jp PlaceText
.printTotal
	ld de, .TotalString
	coord hl, 1, 14
	jp PlaceText

.WorthString:
	ctxt "Worth: ¥@"
	deciram wTempNumber, 2, 5
	db "@"

.NetWorthString:
	ctxt "Net Worth: ¥@"
	deciram wTempNumber, 3, 6
	db "@"

.TotalString:
	ctxt "Total: ¥@"
	deciram wTotalOrePrices, 3, 7
	db "@"

OrePrices:
	dw 10
	dw 25
	dw 50
	dw 200
	dw 500
	dw 1000
	dw 3500
	dw 5000
	dw 7500
	dw 10000

CalculateTotalWorthOfOres::
	ld hl, wTotalOrePrices
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld de, wOreCaseInventory
	ld hl, OrePrices
	lb bc, 0, NUM_ORES
.loop
	ld a, [de]
	inc de
	and a
	jr z, .noneOfOre
	ld b, 1
	ldh [hMultiplier], a
	ld a, [hli]
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	xor a
	ldh [hMultiplicand], a
	predef Multiply
	push hl
	ld hl, wTotalOrePrices + 2
	ldh a, [hProduct + 3]
	add [hl]
	ld [hld], a
	ldh a, [hProduct + 2]
	adc [hl]
	ld [hld], a
	ldh a, [hProduct + 1]
	adc [hl]
	ld [hl], a
	pop hl
	jr .finishLoop
.noneOfOre
	inc hl
	inc hl
.finishLoop
	dec c
	jr nz, .loop
	ld a, b
	ret
