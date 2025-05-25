DebugMenu:
	xor a
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], 1
	call ClearBGPalettes
	ld hl, vFontTiles + ((DEBUG_FLAG_SET - $80) << 4)
	ld de, PlusSignTile
	lb bc, BANK(PlusSignTile), 1
	call Request1bpp
	ld bc, DebugMainMenu
	call DebugMenuLoad
.menu_main_loop
	ld a, [wDebugMenuFlags]
	bit 6, a
	jr nz, .exit_debug
	bit 7, a
	jr z, .menu_joypad_loop
	call DebugMenuRefresh
	jr nz, .menu_joypad_loop
	xor a
	jr .exit_debug
.menu_joypad_loop
	call .display_time
	call DelayFrame
	call JoyTextDelay
	ldh a, [hJoyPressed]
	call DebugMenuExecuteAction
	jr .menu_main_loop
.exit_debug
	and 7
	ld b, a
	pop af
	ldh [hInMenu], a
	wbk BANK(wPlayerName)
	ld a, b
	ret
.display_time
	ld hl, wDebugMenuCurrentMenu
	ld a, [hli]
	cp LOW(DebugMainMenu)
	ret nz
	ld a, [hl]
	cp HIGH(DebugMainMenu)
	ret nz
	ld hl, wGameTimeHours
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld de, 3600
	call Multiply16
	ld a, [hli]
	ld c, a
	ld a, [hli]
	push hl
	ld l, a
	ld h, 0
	ld b, h
	ld a, 60
	rst AddNTimes
	add hl, de
	ld a, h
	ldh [hProduct + 2], a
	ld a, l
	ldh [hProduct + 3], a
	jr nc, .no_carry
	ld hl, hProduct + 1
	inc [hl]
	jr nz, .no_carry
	dec hl
	inc [hl]
.no_carry
	ld a, 60
	ldh [hMultiplier], a
	callba Multiply
	ld hl, hProduct
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	pop hl
	ld a, [hl]
	add a, e
	ld e, a
	jr nc, .no_carry_2
	inc d
	jr nz, .no_carry_2
	inc c
	jr nz, .no_carry_2
	inc b
.no_carry_2
	callba FormatStopwatchCounter
	push bc
	push de
	ldh a, [hLongQuotient + 2]
	ld d, a
	ldh a, [hLongQuotient + 3]
	ld e, a
	ld bc, 0
	hlcoord 1, 16
	ld a, "I"
	ld [hli], a
	ld a, "G"
	ld [hli], a
	ld a, "T"
	ld [hli], a
	inc hl
	ld a, 5
	ldh [hDigitsFlags], a
	xor a
	ldh [hBGMapMode], a
	predef PrintBigNumber
	hlcoord 18, 16
	pop de
	ld a, e
	call .print_value
	ld [hl], "."
	dec hl
	ld a, d
	call .print_value
	ld [hl], ":"
	dec hl
	pop bc
	ld a, c
	call .print_value
	ld [hl], ":"
	ld a, 1
	ldh [hBGMapMode], a
	ret
.print_value
	ld c, 10
	call SimpleDivide
	add a, "0"
	ld [hld], a
	ld a, b
	add a, "0"
	ld [hld], a
	ret

DebugMenuRefresh:
	ld hl, wDebugMenuFlags
	res 7, [hl]
	ld hl, wDebugMenuNextMenu
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	ret z
	ld hl, wDebugMenuCurrentMenu
	ld a, c
	ld [hli], a
	ld [hl], b
	push bc
	call ClearBGPalettes
	hlcoord 0, 0
	lb bc, 1, 18
	call TextBox
	hlcoord 0, 3
	lb bc, 13, 18
	call TextBox
	pop bc
	ld hl, 8
	add hl, bc
	ld d, h
	ld e, l
	hlcoord 1, 1
	push bc
	call PlaceString
	pop bc
	ld hl, 2
	add hl, bc
	push bc
	xor a
	ld [wDebugMenuOptionCount], a
	ld [wDebugMenuCurrentOption], a
	ld a, [hli]
	ld c, a
	ld b, [hl]
.display_option
	ld h, b
	ld l, c
	ld a, [hli]
	ld e, a
	ld d, [hl]
	or d
	jr z, .options_done
	push bc
	ld hl, 6
	add hl, de
	ld d, h
	ld e, l
	hlcoord 2, 4
	ld bc, SCREEN_WIDTH
	ld a, [wDebugMenuOptionCount]
	rst AddNTimes
	call PlaceString
	pop bc
	inc bc
	inc bc
	ld hl, wDebugMenuOptionCount
	inc [hl]
	jr .display_option
.options_done
	hlcoord 1, 4
	ld [hl], DEBUG_CURSOR_RIGHT
	pop bc
	ld hl, 6
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	call nz, _hl_
	ld a, 1
	ldh [hBGMapMode], a
	call ApplyTilemapInVBlank
	ld hl, wDebugMenuFlags
	bit 5, [hl]
	res 5, [hl]
	jr nz, .noSGBLayout
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
.noSGBLayout
	call SetPalettes
	ld a, 1
	and a
	ret

DebugMenuExecuteAction:
	bit B_BUTTON_F, a
	jr nz, DebugMenuCancel
	bit START_F, a
	jp nz, DebugMenuExecuteDefault
	bit A_BUTTON_F, a
	ld de, 0
	jr nz, DebugMenuExecuteOption
	bit SELECT_F, a
	ld e, 4
	jr nz, DebugMenuExecuteOption
	ld b, a
	and D_UP | D_DOWN
	ld a, b
	jr z, .not_option_change
	bit D_UP_F, a
	scf
	jr z, DebugMenuChangeOption
	ccf
	jr DebugMenuChangeOption
.not_option_change
	and D_LEFT | D_RIGHT
	ret z
	bit D_LEFT_F, a
	scf
	jr z, .apply_cursors
	ccf
.apply_cursors
	push af
	call DebugMenuGetCurrentOptionPointer
	ld bc, 2
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .no_cursors
	pop af
	jp hl
.no_cursors
	pop af
	ret

DebugMenuCancel:
	xor a
	call DebugGetCurrentMenuPointer
	ld b, h
	ld c, l
DebugMenuLoad:
	; marks the menu in bc to be loaded next loop iteration
	ld hl, wDebugMenuNextMenu
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], $80
	ret

DebugMenuChangeOption:
	push af
	hlcoord 1, 4
	ld bc, SCREEN_WIDTH
	ld a, [wDebugMenuCurrentOption]
	rst AddNTimes
	ld [hl], " "
	pop af
	jr nc, .option_prev
	ld a, [wDebugMenuCurrentOption]
	ld hl, wDebugMenuOptionCount
	inc a
	cp [hl]
	jr c, .selected
	xor a
	jr .selected
.option_prev
	ld a, [wDebugMenuCurrentOption]
	and a
	jr z, .last_option
	dec a
	jr .selected
.last_option
	ld a, [wDebugMenuOptionCount]
	dec a
.selected
	ld [wDebugMenuCurrentOption], a
	hlcoord 1, 4
	ld bc, SCREEN_WIDTH
	rst AddNTimes
	ld [hl], DEBUG_CURSOR_RIGHT
	ret

DebugMenuExecuteOption:
	call DebugMenuGetCurrentOptionPointer
	add hl, de
	jp CallNonNullLocalPointer

DebugMenuExecuteDefault:
	ld a, 2
	call DebugGetCurrentMenuPointer
	ld a, h
	or l
	ret z
	jp hl

DebugCloseAllMenus:
	ld de, MENU_EXIT_ALL
	ld b, d
	ld c, d
DebugMenuExit:
	; exits with the mode in e, and loads d:bc into the queued script address if bc is nonzero
	ldh a, [rSVBK]
	push af
	wbk BANK(wQueuedScriptBank)
	ld a, b
	or c
	jr z, .no_queued_script
	ld hl, wQueuedScriptBank
	ld [hl], d
	ld hl, wQueuedScriptAddr
	ld a, c
	ld [hli], a
	ld [hl], b
.no_queued_script
	ld a, e
	and 7
	set 6, a
	ld [wDebugMenuFlags], a
	pop af
	ldh [rSVBK], a
	ret

DebugGetCurrentMenuPointer:
	ld hl, wDebugMenuCurrentMenu
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, b
	ld b, [hl]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

DebugMenuGetCurrentOptionPointer:
	ld a, 1
	call DebugGetCurrentMenuPointer
	ld b, h
	ld c, l
	ld hl, wDebugMenuCurrentOption
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

DebugMenuModifyByPowerOfTen:
	; bcde += 10^a * (-1)^(!carry)
	push bc
	ccf
	adc a
	add a, a
	add a, a
	cp 80
	ret nc
	ld c, a
	ld b, 0
	ld hl, .powers
	add hl, bc
	ld a, [hli]
	ld c, [hl]
	inc hl
	push hl
	ld l, a
	ld h, c
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr nc, .no_increment
	inc hl
.no_increment
	add hl, bc
	ld b, h
	ld c, l
	ret
.powers
_CURRENT = 1
	rept 10
		dw _CURRENT & $ffff
		dw _CURRENT >> 16
		dw -_CURRENT & $ffff
		dw (-_CURRENT) >> 16
_CURRENT = _CURRENT * 10
	endr

DebugFlagGridBase:
	; Function list (function in a):
	; 0: display status (hl: flag array, bc: flag offset, de: cursor position)
	; 1: cursor left (de: cursor position)
	; 2: cursor right (de: cursor position)
	; 3: toggle (hl: flag array, bc: flag offset, de: cursor position, [wDebugMenuCurrentOption]: selected option)
	; 4: display clear (d: first flag, e: last flag)
	; 5: show help text (no parameters)
	and a
	jr z, .display_status
	dec a
	jr z, .cursor_left
	dec a
	jr z, .cursor_right
	dec a
	jp z, .toggle
	dec a
	jp z, .display_clear
	dec a
	ret nz
; show_help
	hlcoord 1, 6
	ld de, .help_text
	jp PlaceText
.cursor_left
	ld a, [de]
	sub 1 ;sets all flags... unlike dec
	jr nc, .cursor_selected
	ld a, 11
	jr .cursor_selected
.cursor_right
	ld a, [de]
	inc a
	cp 12
	jr c, .cursor_selected
	xor a
.cursor_selected
	ld [de], a
	ret
.display_status
	push hl
	push bc
	ld a, [de]
	ld c, a
	push bc
	ld de, .header_line
	hlcoord 6, 4
	call PlaceString
	pop bc
	hlcoord 9, 4
	ld de, 0
	ld b, d
	ld a, 9
	cp c
	jr nc, .no_special_cursor
	ld de, -13
.no_special_cursor
	add hl, bc
	add hl, de
	ld [hl], DEBUG_CURSOR_DOWN
	pop bc
	ld a, c
	and 7
	rept 3
		sra b
		rr c
	endr
	pop hl
	add hl, bc
	ld e, a
	ld d, [hl]
	inc hl
	inc e
.skip_loop
	dec e
	jr z, .done_skipping
	srl d
	jr .skip_loop
.done_skipping
	xor 7
	inc a
	ld e, a
	ld c, 0
.display_loop
	ld a, 9
	cp c
	ret c
	push bc
	call .display_line
	pop bc
	inc c
	jr .display_loop
.display_line
	; c: current line, d: data, e: remaining bits, hl: reload address
	push hl
	ld b, 0
	push bc
	ld a, SCREEN_WIDTH
	hlcoord 2, 5
	rst AddNTimes
	pop bc
	ld a, "0"
	add a, c
	ld [hli], a
	ld a, "0"
	ld [hli], a
	ld a, ":"
	ld [hli], a
	rept 4
		inc hl
	endr
	pop bc
	ld a, 11
.flag_loop
	dec a
	jr z, .line_done
	bit 0, d
	ld [hl], DEBUG_FLAG_SET
	jr nz, .flag_printed
	ld [hl], DEBUG_FLAG_CLEAR
.flag_printed
	inc hl
	srl d
	dec e
	call z, .reload
	jr .flag_loop
.line_done
	ld h, b
	ld l, c
	ret
.reload
	push af
	ld a, [bc]
	inc bc
	ld d, a
	pop af
	ld e, 8
	ret
.toggle
	push hl
	push de
	ld h, b
	ld l, c
	ld a, [wDebugMenuCurrentOption]
	dec a
	ld bc, 10
	rst AddNTimes
	pop de
	ld a, [de]
	cp 10
	jr nc, .set_multiple
	add a, l
	ld e, a
	adc h
	sub e
	ld d, a
	pop hl
	ld b, 2
	push de
	push hl
	call BigFlagAction
	pop hl
	pop de
	ld a, $ff
	add a, c ;transfer flag into carry
	sbc a
	inc a
	ld b, a
	jp BigFlagAction
.set_multiple
	ld d, h
	ld e, l
	pop hl
	ld c, 10
	sub 11
	and 1
	ld b, a
.set_loop
	push hl
	push de
	push bc
	call BigFlagAction
	pop bc
	pop de
	pop hl
	inc de
	dec c
	jr nz, .set_loop
	ret
.display_clear
	ld a, 100
	cp e
	jr nc, .valid_last_flag
	ld e, 100
.valid_last_flag
	inc e
	xor a
	ld c, a
.clear_line_loop
	cp 100
	ret nc
	ld b, 0
	push af
	push bc
	hlcoord 9, 5
	ld a, SCREEN_WIDTH
	rst AddNTimes
	pop bc
	pop af
	ld b, -10
.clear_cell_loop
	cp d
	jr c, .clear_cell
	cp e
	jr c, .next_cell
.clear_cell
	ld [hl], " "
.next_cell
	inc hl
	inc a
	inc b
	jr nz, .clear_cell_loop
	inc c
	jr .clear_line_loop
.header_line db DEBUG_FLAG_SET, DEBUG_FLAG_CLEAR, " 0123456789@"
.help_text
	ctxt "U/D: select row"
	nl   "L/R: select column"
	nl   "A: toggle flag"
	nl   "START: save"
	nl   "SELECT: reload"
	nl   "B: cancel"
	nl   "The two leftmost"
	nl   "columns change the"
	nl   "whole row at once."
	nl   DEBUG_FLAG_SET,   ": flag set (1)"
	nl   DEBUG_FLAG_CLEAR, ": flag clear (0)"
	done

DebugMenuChangeStep:
	; changes the step value in [hl], rotating 1, 4, 10, 25
	ld a, [hl]
	cp 4
	jr nc, .step_over_1
	ld a, 4
	jr .step_chosen
.step_over_1
	cp 10
	jr nc, .step_over_4
	ld a, 10
	jr .step_chosen
.step_over_4
	cp 25
	; a = carry ? 25 [4 < step <= 10] : 1 [10 < step]
	sbc a
	and 25 - 1
	add 1
.step_chosen
	ld [hl], a
	ret

DebugMenuChangeValue:
	; changes the value in [hl] by an increment/decrement of [de] according to carry
	ld a, [de]
	jr c, .ok
	cpl
	inc a
.ok
	add a, [hl]
	ld [hl], a
	ret

DebugMenuChangeValueLimited:
	; changes the value in [hl] by [de], requiring b <= value <= c
	push af
	push bc
	push hl
	call DebugMenuChangeValue
	pop hl
	pop bc
	ld a, c
	sub b
	inc a
	ld e, a
	pop af
	ld a, [hl]
	jr c, .check_valid_add
.check_valid_sub
	ld d, c
	inc d
	cp d
	jr nc, .underflow
	cp b
	jr c, .underflow
	jr .done
.check_valid_add
	ld d, c
	inc d
	cp d
	jr nc, .overflow
	cp b
	jr c, .underflow
.done
	ld [hl], a
	ret
.overflow
	sub e
	jr .check_valid_add
.underflow
	add a, e
	jr .check_valid_sub

DebugPrintPokemonName:
	ld bc, GetPokemonName
	jr DebugPrintPokemonOrItemName

DebugPrintItemName:
	ld bc, GetItemName
	jr DebugPrintPokemonOrItemName

DebugPrintTrainerClassName:
	ld bc, GetTrainerClassName
DebugPrintPokemonOrItemName:
	push bc
	ld a, [de]
	ld bc, 0
	ld d, b
	ld [wd265], a
	ld e, a
	ld a, 3
	push hl
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	pop hl
	ld de, 4
	add hl, de
	push hl
	ld de, DebugMenuClearString12
	call PlaceString
	pop hl
	pop bc
	ld a, [wd265]
	inc a
	jr z, .invalid_item
	dec a
	jr z, .no_item
	call _bc_
	ld de, wStringBuffer1
	jr .got_item

.invalid_item
	ld de, .invalid_string
	jr .got_item

.no_item
	ld de, .none_string
.got_item
	jp PlaceString

.none_string
	db "(none)@"
.invalid_string
	db "(invalid)@"

DebugMenuChangeHexValue:
	;change 16-bit value bc by d << (4 * e), direction of change given by carry (c: +, nc: -)
	;requires d < 16, e < 4; preserves hl
	ld a, e
	ld e, 0
	push af
	rra
	jr nc, .no_swap
	swap d
.no_swap
	rra
	jr c, .no_change_byte
	ld e, d
	ld d, 0
.no_change_byte
	pop af
	jr c, .not_negative
	ld a, d
	cpl
	ld d, a
	ld a, e
	cpl
	ld e, a
	inc de
.not_negative
	ld a, c
	add a, e
	ld c, a
	ld a, b
	adc d
	ld b, a
	ret

DebugMenuPrintHexValue:
	;prints the value at a in the coordinates specified by hl
	;exits with hl pointing to the end of the value, af destroyed, rest unchanged
	push af
	swap a
	and 15
	add a, "0"
	set 7, a
	ld [hli], a
	pop af
	and 15
	add a, "0"
	set 7, a
	ld [hli], a
	ret

DebugMenuInfoString:
	ctxt "L/R: change by"
	nl   "SEL: change step"
	nl   "START: confirm"
	done

DebugMenuClearString12: db "    "
DebugMenuClearString8: db " "
DebugMenuClearString7: db "  "
DebugMenuClearString5: db " "
DebugMenuClearString4: db "    @"
