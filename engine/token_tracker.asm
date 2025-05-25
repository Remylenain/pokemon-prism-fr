UseTokenTrackerItem:
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
	ld hl, GoldTokenEvents
	ld de, wTempTokenTrackerOverworldInventory
	ld a, (GoldTokenEventsEnd - GoldTokenEvents) / 2 - 1
	ld c, 1
	call .InitTempInventory
	ld a, b
	ld [wTokenTrackerOverworldTokensCount], a
	ld a, (BingoGoldTokenEventsEnd - BingoGoldTokenEvents) / 2 - 1
	call .InitTempInventory
	ld a, b
	ld [wTokenTrackerBingoTokensCount], a
	ld hl, FourGoldTokenEvents
	ld a, (FourGoldTokenEventsEnd - FourGoldTokenEvents) / 2 - 1
	call .InitTempInventory
	ld a, b
	add a
	add a
	ld [wTokenTrackerMersonTokensCount], a
	ld hl, wTokenTrackerOverworldTokensCount
	ld b, a
	ld a, [hli]
	add b
	add [hl]
	ld [wTotalTokensCount], a
	ld hl, .MenuHeader
	call CopyMenuHeader
	ld hl, wTokenTrackerPage
	xor a
	ld [hli], a
	ld bc, wTokenTrackerCursorStateEnd - wTokenTrackerCursorState
	call ByteFill
	call CopyMenuData2
	jr .main_loop_skipSFX
.main_loop
	ld de, SFX_SWITCH_POCKETS
	call PlaySFX
	call ClearWholeMenuBox
	call ApplyTilemap
.main_loop_skipSFX
	hlcoord 0, 0
	lb bc, 2, 18
	call TextBox
	ld a, [wTokenTrackerPage]
	ld bc, .TokenTrackerPageEntrySizeEnd - .TokenTrackerPages
	ld hl, .TokenTrackerPages
	rst AddNTimes
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	; de = pointer to title text
	ld a, [hli]
	push hl
	ld b, a
	; b = center spacing
	call .GetTokenCountAddressForPage
	ld a, [hl]
	and a
	jr nz, .dontPrintFiveQuestionMarks
	ld de, .QuestionMarks
	hlcoord 7, 0
	jr .gotCoords
.dontPrintFiveQuestionMarks
	ld a, b
	hlcoord 1, 0
	add l
	ld l, a
	adc h
	sub l
	ld h, a
.gotCoords
	call PlaceText
	ld de, .FoundTokensText
	hlcoord 1, 1
	call PlaceText
	pop hl
	ld a, [hl] ; total token count of page
	cp 10
	push hl
	hlcoord 11, 1
	jr nc, .gotSpacing
	inc hl
.gotSpacing
	push hl
	call .GetTokenCountAddressForPage
	ld d, h
	ld e, l
	pop hl
	push hl
	dec hl
	lb bc, 1, 2
	call PrintNum
	pop hl
	inc hl
	ld a, "/"
	ld [hli], a
	pop de
	ld a, [de]
	push de
	ld [wTokenTrackerPageTotal], a
	ld de, wTokenTrackerPageTotal
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNum
	ld de, .TotalTokensText
	hlcoord 1, 2
	call PlaceText
	ld de, wTotalTokensCount
	hlcoord 8, 2
	lb bc, 1, 3
	call PrintNum
	pop hl
	inc hl
	ld a, [hli]
	ld [wMenuData_ItemsPointerAddr], a
	ld a, [hl]
	ld [wMenuData_ItemsPointerAddr + 1], a
	ld hl, wTokenTrackerOverworldCursor
	ld a, [wTokenTrackerPage]
	add a
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	ld [wMenuCursorBuffer], a
	ld a, [hl]
	ld [wMenuScrollPosition], a
	push hl
	callba _InitScrollingMenu
	call ScrollingMenu_UpdatePalettes
	callba _ScrollingMenu
	pop hl
	ld a, [wMenuScrollPosition]
	ld [hld], a
	ld a, [wMenuCursorY]
	ld [hl], a
	ld hl, wTokenTrackerPage
	ld a, [wMenuJoypad]
	cp D_RIGHT
	jr nz, .notRight
	ld a, [hl]
	cp 2
	jr c, .noWraparound1
	ld [hl], -1
.noWraparound1
	inc [hl]
	jp .main_loop
.notRight
	cp D_LEFT
	jr nz, .notLeft
	ld a, [hl]
	and a
	jr nz, .noWraparound2
	ld [hl], 3
.noWraparound2
	dec [hl]
	jp .main_loop
.notLeft
	cp B_BUTTON
	jp nz, .main_loop_skipSFX
	pop af
	ldh [hInMenu], a
	ret

.GetTokenCountAddressForPage:
	ld a, [wTokenTrackerPage]
	ld hl, wTokenTrackerOverworldTokensCount
	add l
	ld l, a
	ret nc
	inc h
	ret

MACRO tokentrackerpage
	dw \1 ; pointer to title text
	db \2, \3 ; center spacing, found tokens offset
	dw \4 ; list pointer
ENDM

.TokenTrackerPages:
	tokentrackerpage .OverworldTokensText, 1, 65, wTempTokenTrackerOverworldInventory
.TokenTrackerPageEntrySizeEnd:
	tokentrackerpage .BingoTokensText, 3, 3, wTempTokenTrackerBingoInventory
	tokentrackerpage .MersonTokensText, 3, 32, wTempTokenTrackerMersonInventory

.TotalTokensText:
	ctxt "total:    /100"
	done

.FoundTokensText:
	ctxt "found:"
	done

.OverworldTokensText:
	ctxt "Overworld Tokens"
	done

.BingoTokensText:
	ctxt "Bingo Tokens"
	done

.MersonTokensText:
	ctxt "Merson Tokens"
	done

.QuestionMarks:
	text "?????"
	done

; Input:
;   hl = pointer to list of tokens
;   de = pointer to temp inventory in WRAM
;   c = landmark ID
;   a = token count - 1
; Output:
;   hl = pointer to first unused token from list
;   de = pointer to first unused inventory slot
;   c = first unused landmark ID
;   b = count of found tokens
.InitTempInventory:
	ld [de], a
	inc de
	ld b, 0
	inc a
.loop
	push af
	push de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push bc
	push hl
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop hl
	pop bc
	pop de
	ld a, 0
	jr z, .overworldGoldTokenNotFound
	ld a, c
	inc b
.overworldGoldTokenNotFound
	ld [de], a
	inc de
	inc c
	pop af
	dec a
	jr nz, .loop
	ret

.MenuHeader:
	db %01100000 ; flags
	db 04, 00 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default option

.MenuData
	db %00011100 ; flags
	db 7, $80 | SCREEN_WIDTH ; rows, quantity spacing
	db 1 ; num bytes per entry
	dbw 0, wTempTokenTrackerOverworldInventory
	dba .PrintTokenLandmark
	dba .PrintTokenNumber
	dba NULL

.PrintTokenLandmark
	push de
	ld a, [wMenuSelection]
	add a
	ld e, a
	ld d, 0
	ld hl, .GoldTokenMapNamePointerOrLandmark + 1
	add hl, de
	ld a, [hld]
	cp 3
	ld e, [hl]
	ld d, a
	jr nc, .gotMapName
	ld b, e
	cp 1
	ld de, .PhloxBingoCardString
	jr z, .getPhloxBingoCard
	cp 2
	jr nz, .getLandmarkName
	ld de, .MersonMilestoneString
.getPhloxBingoCard
	ld a, b
	push af
	call CopyName1
	pop af
	dec hl
	ld a, b
	ld [hli], a
	ld [hl], "@"
	ld de, wStringBuffer2
	jr .gotPhloxBingoCardName
.getLandmarkName
	ld e, b
	callba GetLandmarkName
	ld de, wStringBuffer1
.gotPhloxBingoCardName
	pop hl
	jp PlaceString
.gotMapName
	pop hl
	jp PlaceText

.MersonMilestoneString:
	db "Merson Milestone @"

.PhloxBingoCardString:
	db "Phlox Bingo Card @"

.PrintTokenNumber
	push de
	ld a, [wMenuScrollPosition]
	ld b, a
	ld a, [wScrollingMenuCursorPosition]
	sub b
	and a
	jr nz, .dontClearFirstTokenNumber
	coord hl, 1, 4
	lb bc, 1, 5
	call ClearBox
.dontClearFirstTokenNumber
	pop hl
	ld a, [wTokenTrackerPage]
	and a
	ld b, 1
	jr z, .gotStartingNumber
	dec a
	ld b, 66
	jr z, .gotStartingNumber
; doubles as entry point for Merson tokens
	ld a, [wScrollingMenuCursorPosition]
	add a
	add a
	add 69
	push af
	call .printSingleToken
	ld a, "-"
	ld [hli], a
	pop af
	add 3
	jr .printSingleToken

.gotStartingNumber
	ld a, [wScrollingMenuCursorPosition]
	add b
.printSingleToken
	ld de, hTemp
	ld [de], a
	cp 100
	jr nc, .noDecrement
	dec hl
.noDecrement
	lb bc, 1, 3
	jp PrintNum

.GoldTokenMapNamePointerOrLandmark:
	dw .QuestionMarks
	dw .CaperMartString
	dw .HappinessRaterString
	dw .HeathGymString
	dw LAUREL_CITY
	dw .ToreniaMartString
	dw ROUTE_68
	dw .Route69GateString
	dw ROUTE_70
	dw ROUTE_71_WEST
	dw ROUTE_72
	dw ROUTE_73
	dw ROUTE_74
	dw ROUTE_75
	dw ROUTE_76
	dw ROUTE_77
	dw ROUTE_79
	dw ROUTE_82
	dw ROUTE_83
	dw ROUTE_84
	dw ACQUA_MINES
	dw .LaurelForestHouseString
	dw .ClathriteB2FString
	dw .SeashoreGymString
	dw GRAVEL_TOWN
	dw MERSON_CITY
	dw HAYWARD_CITY
	dw .OwsauriGameCornerString
	dw MORAGA_TOWN
	dw JAERU_CITY
	dw BOTAN_CITY
	dw CASTRO_VALLEY
	dw CASTRO_MANSION
	dw EAGULOU_CITY
	dw RIJON_LEAGUE
	dw ROUTE_47
	dw ROUTE_48
	dw ROUTE_49
	dw ROUTE_50
	dw ROUTE_51
	dw ROUTE_52
	dw ROUTE_53
	dw ROUTE_54
	dw ROUTE_55
	dw ROUTE_56
	dw ROUTE_57
	dw ROUTE_58
	dw ROUTE_59
	dw ROUTE_60
	dw POWER_PLANT
	dw .Route61NorthGateString
	dw ROUTE_62
	dw ROUTE_63
	dw ROUTE_64
	dw ROUTE_65
	dw ROUTE_66
	dw ROUTE_67
	dw .MersonCaveB2FString
	dw .MtBoulderB1FString
	dw .SilkTunnelB5FString
	dw CASTRO_FOREST
	dw ILEX_FOREST
	dw .Route34GateString
	dw GOLDENROD_CITY
	dw GOLDENROD_CAPE
	dw TUNOD_WATERWAY
	db "1", 1
	db "2", 1
	db "3", 1
	db "1", 2
	db "2", 2
	db "3", 2
	db "4", 2
	db "5", 2
	db "6", 2
	db "7", 2
	db "8", 2

.CaperMartString
	ctxt "Caper Mart"
	done

.HappinessRaterString:
	ctxt "Happiness Rater"
	done

.HeathGymString:
	ctxt "Heath Gym"
	done

.ToreniaMartString:
	ctxt "Torenia Mart"
	done

.Route69GateString:
	ctxt "Route 69 Gate"
	done

.LaurelForestHouseString:
	ctxt "Laurel Forest House"
	done

.ClathriteB2FString:
	ctxt "Clathrite B2F"
	done

.SeashoreGymString:
	ctxt "Seashore Gym"
	done

.OwsauriGameCornerString:
	ctxt "Owsauri Game Corner"
	done

.Route61NorthGateString:
	ctxt "Route 61 North Gate"
	done

.MersonCaveB2FString:
	ctxt "Merson Cave B2F"
	done

.MtBoulderB1FString:
	ctxt "Mt. Boulder B1F"
	done

.SilkTunnelB5FString:
	ctxt "Silk Tunnel B5F"
	done

.Route34GateString:
	ctxt "Route 34 Gate"
	done
