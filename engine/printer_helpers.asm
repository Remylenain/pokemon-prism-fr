PrintPage1:
	hlcoord 0, 0
	ld de, wPrinterTilemap
	ld bc, 17 * SCREEN_WIDTH
	rst CopyBytes
	hlcoord 17, 1, wPrinterTilemap
	ld a, $62
	ld [hli], a
	inc a
	ld [hl], a
	hlcoord 17, 2, wPrinterTilemap
	ld a, $64
	ld [hli], a
	inc a
	ld [hl], a
	hlcoord 1, 9, wPrinterTilemap
	ld a, " "
	ld [hli], a
	ld [hl], a
	hlcoord 1, 10, wPrinterTilemap
	ld a, $61
	ld [hli], a
	ld [hl], a
	hlcoord 2, 11, wPrinterTilemap
	lb bc, 5, 18
	call ClearBox
	ld a, [wd265]
	dec a
	call CheckCaughtMon
	push af
	ld a, [wd265]
	ld b, a
	ld c, 1 ; get page 1
	callba GetDexEntryPagePointer
	pop af
	ld a, b
	hlcoord 1, 11, wPrinterTilemap
	call nz, FarPlaceText
	hlcoord 19, 0, wPrinterTilemap
	ld [hl], $35
	ld de, SCREEN_WIDTH
	add hl, de
	ld b, $f
.column_loop
	ld [hl], $37
	add hl, de
	dec b
	jr nz, .column_loop
	ld [hl], $3a
	ret

PrintPage2:
	hlcoord 0, 0, wPrinterTilemap
	push hl
	ld bc, SCREEN_WIDTH * 8
	ld a, " "
	call ByteFill
	pop hl
	ld a, $36
	ld b, 6
	call .FillColumn
	hlcoord 19, 0, wPrinterTilemap
	ld a, $37
	ld b, 6
	call .FillColumn
	hlcoord 0, 6, wPrinterTilemap
	ld a, $38
	ld [hli], a
	inc a
	ld bc, SCREEN_WIDTH - 2
	call ByteFill
	ld a, $3a
	ld [hli], a
	ld bc, SCREEN_WIDTH
	ld a, $32
	call ByteFill
	ld a, [wd265]
	dec a
	call CheckCaughtMon
	push af
	ld a, [wd265]
	ld b, a
	ld c, 2 ; get page 2
	callba GetDexEntryPagePointer
	pop af
	hlcoord 1, 1, wPrinterTilemap
	ld a, b
	jp nz, FarPlaceText
	ret

.FillColumn
	push de
	ld de, SCREEN_WIDTH
.column_loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .column_loop
	pop de
	ret

GBPrinterStrings:
String_Printer_CheckingLink:
	text ""
	next " CHECKING LINK<...>"
String_Printer_Blank:
	done
String_Printer_Transmitting:
	ctxt ""
	next "  TRANSMITTING<...>"
	done
String_Printer_Printing:
	ctxt ""
	next "    PRINTING<...>"
	done
String_Printer_Error1:
	start_asm
	ld a, 1
	jr StringPrinterError
String_Printer_Error2:
	start_asm
	ld a, 2
	jr StringPrinterError
String_Printer_Error3:
	start_asm
	ld a, 3
	jr StringPrinterError
String_Printer_Error4:
	start_asm
	ld a, 4
StringPrinterError:
	ld [wTempNumber], a
	ld hl, .text
	ret
.text
	ctxt " Printer Error @"
	deciram wTempNumber, 1, 1
	ctxt ""
	next ""
	next "Check the Game Boy"
	next "Printer Manual."
	done

PrintMonInfo:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	xor a
	ldh [hBGMapMode], a
	call LoadFontsBattleExtra

	ld de, PrinterHPIcon
	ld hl, vBGTiles tile $71
	lb bc, BANK(PrinterHPIcon), 1
	call Request1bpp

	ld de, PrinterLvIcon
	ld hl, vBGTiles tile $6e
	lb bc, BANK(PrinterLvIcon), 1
	call Request1bpp

	xor a
	ld [wMonType], a
	callba CopyPkmnToTempMon
	hlcoord 0, 7
	lb bc, 9, 18
	call TextBox
	hlcoord 8, 2
	ld a, [wTempMonLevel]
	call PrintFullLevel
	hlcoord 12, 2
	ld [hl], "◀" ; Filled left triangle
	inc hl
	ld de, wTempMonMaxHP
	lb bc, 2, 3
	call PrintNum
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ld [wCurSpecies], a
	ld hl, wPartyMonNicknames
	call FindCurrentPartyMonName
	hlcoord 8, 4
	call PlaceString
	hlcoord 9, 6
	ld [hl], "/"
	call GetPokemonName
	hlcoord 10, 6
	call PlaceString
	hlcoord 8, 0
	ld [hl], "№"
	inc hl
	ld [hl], "."
	inc hl
	ld de, wd265
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	hlcoord 1, 9
	ld de, .OT_string
	call PlaceString
	ld hl, wPartyMonOT
	call FindCurrentPartyMonName
	hlcoord 4, 9
	call PlaceString
	hlcoord 1, 11
	ld de, .id_no_string
	call PlaceString
	hlcoord 4, 11
	ld de, wTempMonID
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	hlcoord 1, 14
	ld de, .move_string
	call PlaceString
	hlcoord 7, 14
	ld a, [wTempMonMoves]
	call PrintMoveName
	call PrintMonGenderShininess
	ld hl, wBoxAlignment
	xor a
	ld [hl], a
	ld a, [wCurPartySpecies]
	inc [hl]
	hlcoord 0, 0
	call _PrepMonFrontpic
	call ApplyTilemapInVBlank
	ld b, SCGB_STATS_SCREEN_HP_PALS
	predef GetSGBLayout
	jp SetPalettes

.OT_string
	db "OT/@"

.move_string
	db "Move@"

.id_no_string
	db "<ID>№.@"

PrintMonMovesAndStats:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	xor a
	ldh [hBGMapMode], a
	call LoadFontsBattleExtra
	xor a
	ld [wMonType], a
	callba CopyPkmnToTempMon
	hlcoord 0, 0
	lb bc, 15, 18
	call TextBox
	ld bc, SCREEN_WIDTH
	decoord 0, 0
	hlcoord 0, 1
	rst CopyBytes
	hlcoord 7, 0
	ld a, [wTempMonMoves + 1]
	call PrintMoveName
	hlcoord 7, 2
	ld a, [wTempMonMoves + 2]
	call PrintMoveName
	hlcoord 7, 4
	ld a, [wTempMonMoves + 3]
	call PrintMoveName
	hlcoord 7, 7
	ld de, .stat_names
	call PlaceText
	hlcoord 16, 7
	ld de, wTempMonAttack
	call .PrintTempMonStats
	hlcoord 16, 9
	ld de, wTempMonDefense
	call .PrintTempMonStats
	hlcoord 16, 11
	ld de, wTempMonSpclAtk
	call .PrintTempMonStats
	hlcoord 16, 13
	ld de, wTempMonSpclDef
	call .PrintTempMonStats
	hlcoord 16, 15
	ld de, wTempMonSpeed
	call .PrintTempMonStats
	call ApplyTilemapInVBlank
	ld b, SCGB_STATS_SCREEN_HP_PALS
	predef GetSGBLayout
	jp SetPalettes

.PrintTempMonStats
	lb bc, 2, 3
	jp PrintNum

.stat_names
	ctxt "Attack"
	next "Defense"
	next "Sp. Atk"
	next "Sp. Def"
	next "Speed"
	done

FindCurrentPartyMonName:
	ld bc, NAME_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld e, l
	ld d, h
	ret

PrintMoveName:
	and a
	jr z, .no_move
	ld [wd265], a
	call GetMoveName
	jr .got_string
.no_move
	ld de, .no_move_string
.got_string
	jp PlaceString
.no_move_string
	db "------------@"

PrintMonGenderShininess:
	callba GetGender
	ld a, " "
	jr c, .got_gender
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"

.got_gender
	hlcoord 17, 2
	ld [hl], a
	ld bc, wTempMonDVs
	callba CheckShininess
	ret nc
	hlcoord 18, 2
	ld [hl], "<SHINY>"
	ret
