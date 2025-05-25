OptionsMenu:
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], 1
	call ClearBGPalettes
	call InitializeOptions
	xor a
	ld [wOptionsCursorLocation], a
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes

.joypad_loop
	call JoyTextDelay
	ldh a, [hJoyPressed]
	and START | B_BUTTON
	jr nz, .ExitOptions
	call OptionsControl
	jr c, .dpad
	call GetOptionPointer
	jr c, .ExitOptions

.dpad
	call Options_UpdateCursorPosition
	call Delay2
	jr .joypad_loop

.ExitOptions
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	pop af
	ldh [hInMenu], a
	ret

GetOptionPointer:
	ld a, [wOptionsCursorLocation]
	cp 6
	ld hl, OptionsMenu_TurnPageOption
	jr z, .gotOption
	jr c, .notDoneOption
	ldh a, [hJoyPressed]
	and A_BUTTON
	ret z
	scf
	ret
.notDoneOption
	ld hl, OptionsMenu_Options
	ld bc, OptionsMenu_OptionEntrySizeEnd - OptionsMenu_Options
	rst AddNTimes
	ld bc, OptionsMenu_OptionPageEntrySizeEnd - OptionsMenu_Options
	ld a, [wOptionsCurPage]
	rst AddNTimes
.gotOption
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	and %11100000
	rra
	swap a
	ld c, a ; store bit in c
	ld a, h
	and %11111
	ld h, a
	ld de, wc000
	add hl, de
; hl = address of option, c = base bit of option
	pop de
	inc de
	inc de
	push de
	ld a, [de]
	ld e, a
	call DetermineBitmaskForA
	push bc
	ld a, [hl]
	call GetAbsoluteOptionValue
	push af
	and b
	ld d, a
	ldh a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .pressedLeft
	bit D_RIGHT_F, a
	jr nz, .pressedRight
; pressed none
	add sp, 4
	jr .printOptionValue
.pressedRight
	ld a, d
	cp e
	jr c, .increaseValue
	ld d, -1
.increaseValue
	inc d
	jr .storeValue
.pressedLeft
	ld a, d
	and a
	jr nz, .decreaseValue
	ld d, e
	inc d
.decreaseValue
	dec d
.storeValue
	pop af
	ld e, a
	pop bc
	ld a, b
	cpl
	ld b, a
; b = complemented bitmask
; c = base bit
; d = new option value
; e = stashed shifted old whole option byte
; hl = pointer to option byte
	ld a, e
	and b
	or d
	inc c
	jr .handleLoop
.loop
	rlca
.handleLoop
	dec c
	jr nz, .loop
	ld [hl], a
.printOptionValue
	pop hl
	inc hl
	inc hl
	inc hl
	push hl
	dec hl
	ld a, [hld]
	ld l, [hl]
	ld h, a
	bit 7, h
	res 7, h
	jr z, .notCustomPrintFunction
	call _hl_
	jr .runCallback
.notCustomPrintFunction
	ld a, d
	and a
	jr z, .firstString
	lb bc, "@", 0
.findStringLengthLoop
	inc c
	ld a, [hli]
	cp b
	jr nz, .findStringLengthLoop
	ld b, 0
	ld a, d
	dec a
	rst AddNTimes
.firstString
	ld d, h
	ld e, l
	call OptionsMenu_GetOptionStatusTilemapAddr
	call PlaceString
.runCallback
	pop hl
	jp CallLocalPointer

DetermineBitmaskForA:
; find a bitmask for the length value in a
; and return it in b
	and a
	ret z
	ld b, $ff
	jr .handleLoop
.loop
	srl b
.handleLoop
	add a
	jr nc, .loop
	ret

GetAbsoluteOptionValue:
	inc c
	jr .handleLoop
.loop
	rrca
.handleLoop
	dec c
	jr nz, .loop
	ret

LoadFontsExtraAndResetCarry:
	call LoadFontsExtra
OptionsMenu_ResetCarry:
	and a
	ret

; base bit, address, size, pointer to base option string, callback
MACRO option
	dw \1 << 13 | (\2 - $c000)
	db \3
	dw \4
	dw \5
ENDM

OptionsMenu_Options:
	option 0,             wOptions,        3, OptionsMenu_TextSpeedStrings, OptionsMenu_ResetCarry
OptionsMenu_OptionEntrySizeEnd:
	option BATTLE_SCENE,  wOptions,        1, OptionsMenu_OnOffStrings, OptionsMenu_ResetCarry
	option BATTLE_SHIFT,  wOptions,        1, OptionsMenu_ShiftSetStrings, OptionsMenu_ResetCarry
	option STEREO,        wOptions,        1, OptionsMenu_SoundModeStrings, OptionsMenu_ResetCarry
	option TURNING_SPEED, wOptions,        1, OptionsMenu_TurningSpeedStrings, OptionsMenu_ResetCarry
	option 0,             wTextBoxFrame,   8, 1 << 15 | OptionsMenu_PrintTextBoxFrameNumber, LoadFontsExtraAndResetCarry
OptionsMenu_OptionPageEntrySizeEnd:
	option 0,             wGBPrinter,      4, OptionsMenu_PrinterBrightnessStrings, OptionsMenu_ResetCarry
	option 0,             wOptions2,       3, OptionsMenu_HoldToMashStrings, OptionsMenu_ResetCarry
	option 2,             wOptions2,       1, OptionsMenu_PreferredUnitsStrings, OptionsMenu_ResetCarry
	option 3,             wOptions2,       1, OptionsMenu_TimeFormatStrings, OptionsMenu_ResetCarry

OptionsMenu_TurnPageOption:
	option 0,             wOptionsCurPage, 1, 1 << 15 | OptionsMenu_PrintPageNumber, RedrawOptions

OptionsMenu_TextSpeedStrings:
	db "Inst@"
	db "Fast@"
	db "Mid @"
	db "Slow@"

OptionsMenu_OnOffStrings:
	db "On @"
	db "Off@"

OptionsMenu_ShiftSetStrings:
	db "Shift@"
	db "Set  @"

OptionsMenu_SoundModeStrings:
	db "Mono  @"
	db "Stereo@"

OptionsMenu_TurningSpeedStrings:
	db "Slow@"
	db "Fast@"

OptionsMenu_PrinterBrightnessStrings:
	db "Lightest@"
	db "Lighter @"
	db "Normal  @"
	db "Darker  @"
	db "Darkest @"

OptionsMenu_HoldToMashStrings:
	db "None  @"
	db "Start @"
	db "A+B   @"
	db "A or B@"

OptionsMenu_PreferredUnitsStrings:
	db "Metric  @"
	db "Imperial@"

OptionsMenu_TimeFormatStrings:
	db "24-hour@"
	db "12-hour@"

OptionsMenu_PrintTextBoxFrameNumber:
	call OptionsMenu_GetOptionStatusTilemapAddr
	push de
	ld de, .TypeString
	call PlaceString
	inc bc
	pop af
	add "1"
	ld [bc], a ; should never return carry under normal circumstances
	ret

.TypeString:
	db "Type@"

OptionsMenu_PrintPageNumber:
	call OptionsMenu_GetOptionStatusTilemapAddr
	ld a, d
	add "1"
	ld [hl], a ; should never return carry under normal circumstances
	ret

OptionsMenu_GetOptionStatusTilemapAddr:
	ld a, [wOptionsCursorLocation]
	add a
	add 3
	ld b, a
	ld c, 11
	jp Coord2Tile

RedrawOptions:
	ldh a, [hJoyPressed]
	and D_LEFT | D_RIGHT
	ret z
	call _RedrawOptions
	and a
	ret

InitializeOptions:
	xor a
	ld [wOptionsCurPage], a
	ld [wOptionsCursorLocation], a

_RedrawOptions:
	ld a, [wOptionsCursorLocation]
	push af
	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 0
	lb bc, 16, 18
	call TextBox
	call GetOptionPageBaseData
	inc a
	coord hl, 2, 2
	push af
.printOptionLabelsLoop
	push af
	push hl
	call PlaceText
	ld d, h
	ld e, l
	pop hl
	push de
	ld bc, SCREEN_WIDTH
	add hl, bc
	call .PrintEightSpacesAndColonWithNewline
	ld h, b
	ld l, c
	pop de
	pop af
	dec a
	jr nz, .printOptionLabelsLoop
	ld de, .PageString
	coord hl, 2, 14
	call PlaceString
	call .PrintEightSpacesAndColonWithNewline
	ld h, b
	ld l, c
	ld de, .DoneString
	call PlaceString
	xor a
	ld [wOptionsCursorLocation], a
	pop af
	ld c, a
.printOptionStatusesLoop ; this next will display the settings of each option when the menu is opened
	push bc
	xor a
	ldh [hJoyPressed], a
	call GetOptionPointer
	pop bc
	ld hl, wOptionsCursorLocation
	inc [hl]
	dec c
	jr nz, .printOptionStatusesLoop
	xor a
	ldh [hJoyPressed], a
	ld [hl], 6
	call GetOptionPointer ; update page option
	pop af
	ld [wOptionsCursorLocation], a
	call Options_UpdateCursorPosition
	ld a, [wOptionsCurPage]
	and a ; hardcode for frame
	call nz, LoadFontsExtra
	jp ApplyTilemap

.PrintEightSpacesAndColonWithNewline:
	ld de, .EightSpacesAndColonStringWithNewline
	jp PlaceText

.EightSpacesAndColonStringWithNewline:
	ctxt "        :"
	nl   ""
	done

.PageString:
	db "Page"
	nl "@"

.DoneString:
	db "Done@"

GetOptionPageBaseData:
	ld a, [wOptionsCurPage]
	ld c, a
	ld b, 0
	ld hl, .OptionsPageDataPointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wOptionsNumOptions], a
	ld d, a ; page count
	ld a, [hli]
	ld e, a
	ld a, d
	ld d, [hl]
	ret

.OptionsPageDataPointers:
	dbw 5, .OptionsPage1
	dbw 3, .OptionsPage2

.OptionsPage1:
	ctxt "Text Speed"
	done
	ctxt "Battle Animations"
	done
	ctxt "Battle Style"
	done
	ctxt "Sound"
	done
	ctxt "Turning Speed"
	done
	ctxt "Text Frame"
	done

.OptionsPage2:
	ctxt "Printer Setting"
	done
	ctxt "Hold To Mash"
	done
	ctxt "Preferred Units"
	done
	ctxt "Time Format"
	done

OptionsControl:
	ld hl, wOptionsCursorLocation
	ldh a, [hJoyLast]
	cp D_DOWN
	jr z, .pressedDown
	cp D_UP
	jr z, .pressedUp
	and a
	ret
.pressedDown
	ld a, [hli]
	cp 7
	jr nz, .noWrapAround1
	dec hl
	xor a
	ld [hl], a
	scf
	ret
.noWrapAround1
	ld b, [hl]
	dec hl
	cp b ; b = number of options minus Done and Page on the screen
	jr nz, .regularIncrement
	ld [hl], 5 ; increment to Page
.regularIncrement
	inc [hl]
	scf
	ret
.pressedUp
	ld a, [hli]
	cp 6
	jr nz, .noWrapAround2
	ld a, [hld] ; copy the max amount minus Page and Done button
	ld [hl], a
	scf
	ret
.noWrapAround2
	and a
	dec hl
	jr nz, .regularDecrement
	ld [hl], 8
.regularDecrement
	dec [hl]
	scf
	ret

Options_UpdateCursorPosition:
	hlcoord 1, 2
	ld de, SCREEN_WIDTH * 2
	ld c, 8
.loop
	ld [hl], " "
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wOptionsCursorLocation]
	rst AddNTimes
	ld [hl], "▶"
	ret
