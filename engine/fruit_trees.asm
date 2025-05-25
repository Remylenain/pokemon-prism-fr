FruitTreeScript::
	callasm GetCurTreeFruit
	opentext
	copybytetovar wCurFruit
	itemtotext 0, 0
	farwritetext FruitBearingTreeText
	buttonsound
	callasm TryResetFruitTrees
	callasm CheckFruitTree
	sif false
		farjumptext NothingHereText
	sif =, 2, then
		farwritetext ItsShinyApricornText
		writebyte SHNYAPRICORN
		itemtotext 0, 0
	selse
		farwritetext HeyItsFruitText
		copybytetovar wCurFruit
	sendif
	giveitem ITEM_FROM_MEM
	buttonsound
	sif false
		farjumptext FruitPackIsFullText
	callasm GiveItemCheckPluralBuffer3
	farwritetext ObtainedFruitText
	callasm PickedFruitTree
	playwaitsfx SFX_ITEM
	itemnotify
	endtext

GetCurTreeFruit:
	ld a, [wCurFruitTree]
	dec a
	ld e, a
	ld d, 0
	ld hl, FruitTreeItems
	add hl, de
	ld a, [hl]
	ld [wCurFruit], a
	ret

CheckFruitTree:
	; 0 = empty, 1 = has fruit, 2 = shiny
	ld b, CHECK_FLAG
	call GetFruitTreeFlag
	ld hl, hScriptVar
	ld [hl], 0
	ld a, c
	and a
	ret nz
	inc [hl]
	ld a, [wCurFruitTree]
	ld c, a
	ld a, [wShinyTreeID]
	cp c
	ret nz
	dec a
	cp EndApricornTrees - FruitTreeItems
	ret nc
	inc [hl]
	ret

PickedFruitTree:
	ld b, SET_FLAG
GetFruitTreeFlag:
	push hl
	push de
	ld a, [wCurFruitTree]
	dec a
	ld c, a
	ld hl, wFruitTreeFlags
	predef FlagAction
	pop de
	pop hl
	ret

FruitTreeItems:
	db RED_APRICORN ;1
	db BLU_APRICORN ;2
	db YLW_APRICORN ;3
	db GRN_APRICORN ;4
	db WHT_APRICORN ;5
	db BLK_APRICORN ;6
	db PNK_APRICORN ;7
	db ORNGAPRICORN ;8
	db CYANAPRICORN ;9
	db PRPLAPRICORN ;10
	db GREYAPRICORN ;11
	db RED_APRICORN ;12
	db BLU_APRICORN ;13
	db YLW_APRICORN ;14
	db WHT_APRICORN ;15
	db BLK_APRICORN ;16
	db PNK_APRICORN ;17
	db ORNGAPRICORN ;18
EndApricornTrees:

	db CHESTO_BERRY ;19
	db LUM_BERRY ;20
	db SITRUS_BERRY ;21
	db ORAN_BERRY ;22
	db PECHA_BERRY ;22
	db LEPPA_BERRY ;24
	db CHERI_BERRY ;25
	db SITRUS_BERRY ;26
	db ASPEAR_BERRY ;27
	db PERSIM_BERRY ;28
	db RAWST_BERRY ;29

TryResetFruitTrees:
	ld hl, wDailyFlags
	bit 4, [hl]
	ret nz
ResetFruitTrees:
	xor a
	ld hl, wFruitTreeFlags
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wDailyFlags
	set 4, [hl]
	ld hl, wEventFlags + (EVENT_INITIALIZED_SHINY_TREES >> 3)
	bit EVENT_INITIALIZED_SHINY_TREES & 7, [hl]
	call z, InitializeShinyTreeRNG
	ldh a, [rSVBK]
	push af
	wbk BANK(wShinyTreeSeed)
	ld hl, wShinyTreeSeed
	callba StableRandom
	pop hl
	wbk h
	ld [wShinyTreeID], a
	ret

InitializeShinyTreeRNG:
	ld hl, wEventFlags + (EVENT_INITIALIZED_SHINY_TREES >> 3)
	set EVENT_INITIALIZED_SHINY_TREES & 7, [hl]
	ld a, BANK(wShinyTreeSeed)
	call StackCallInWRAMBankA
	; end of function

	ld hl, wShinyTreeSeed
	jpba Generate8ByteSeedWithMixing_DefaultValue
