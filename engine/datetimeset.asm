CalendarTimeSet::
	ld b, 0
	jr CalendarTimeSetMain

CalendarTimeSetFromTimeMachine::
	ld b, 1
CalendarTimeSetMain::
	ldh a, [hInMenu]
	push af
	xor a
	ld [wSpriteUpdatesEnabled], a
	ld [wJumptableIndex], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [rSCX], a
	ldh [rSCY], a
	inc a
	ldh [hInMenu], a
	ld a, b
	ld [wIsTimeMachine], a
	push af
	call ClearScreen
	pop af
	and a
	ld hl, .intro_text
	call z, PrintCalendarTimeSetIntroText
.loop
	call CalendarTimeSet_JumpTable
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop
	call ClearTileMap
	callba ClearSpriteAnims
	pop af
	ldh [hInMenu], a
	ld a, [wCompletedDateTimeSet]
	and a
	ret z ; doubles as no carry
	scf
	ret

.intro_text
	ctxt "Please set the"
	line "year and date."
	sdone

CalendarTimeSet_JumpTable:
	call RunAnonymousJumptable

; functions
	dw CalendarTimeSet_Next
	dw CalendarTimeSet_InitGraphics
	dw CalendarTimeSet_SelectingMonthYear
	dw CalendarTimeSet_SelectingDay
	dw CalendarTimeSet_SelectingTime
	dw CalendarTimeSet_Confirm
	dw CalendarTimeSet_Quit

CalendarTimeSet_InitGraphics:
	xor a
	ldh [hBGMapMode], a
	call ClearTileMapNoDelay
	call CopyTilemapAtOnce
	call .InitGraphics
	ld a, 1
	ldh [hBGMapMode], a
	call CheckIfTimeMachine
	ret z
	ld hl, .time_machine_intro_text
	call PrintCalendarTimeSetIntroText
	ld c, 8
	jp DelayFrames

.time_machine_intro_text
	ctxt "Please select the"
	line "destination year"
	cont "and date."
	sdone

.InitGraphics:
	call LoadStandardFont
	call LoadFontsBattleExtra
	ld hl, vBGTiles
	ld de, CalendarNumbersGFX
	lb bc, BANK(CalendarNumbersGFX), 28
	call Request1bpp
	ld hl, vObjTiles
	ld de, CalendarCursorGFX
	lb bc, BANK(CalendarCursorGFX), 1
	call Request2bpp
	ld de, TimesetUpDownArrowGFX
	ld hl, vBGTiles tile $1c
	lb bc, BANK(TimesetUpDownArrowGFX), 2
	call Request1bpp

	; set default date and time (10:00 on the date of the build)
	ld hl, wInitMinuteBuffer
	xor a
	ld [hld], a
	ld a, 10
	ld [hld], a
	ld a, ST_DAY
	ld [hld], a
	ld a, ST_MONTH
	ld [hld], a
	ld [hl], ST_YEAR

	; load palettes
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	callba ApplyPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	call DelayFrame
CalendarTimeSet_Next:
	ld hl, wJumptableIndex
	inc [hl]
	ret

CalendarTimeSet_Prev:
	ld hl, wJumptableIndex
	dec [hl]
	ret

PrintCalendarTimeSetIntroText:
	push hl
	call ClearSprites
	call SpeechTextBox
	pop hl
	jp PrintText

CalendarTimeSet_SelectingMonthYear:
	; clear sprite anim struct for cursor
	callba ClearSpriteAnims
	call ClearSprites
	; init arrows at month selection
	call DrawMonth
	jr .handleLoop

.loop
	call z, DrawMonth
	call DelayFrame
.handleLoop
	call SelectingMonthYear_JoypadAction
	jr nc, .loop
	ret

SelectingMonthYear_JoypadAction:
	call GetJoypad
	ldh a, [hJoyPressed]
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit B_BUTTON_F, a
	jr nz, .b_button
	bit D_UP_F, a
	jr nz, .d_up
	bit D_DOWN_F, a
	jr nz, .d_down
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
.resetZeroFlag
	ld a, 1
	and a
	ret

.a_button
	call CalendarTimeSet_Next
	scf
	ret

.b_button
	call CheckIfTimeMachine
	jr z, .resetZeroFlag
	ld hl, .cancel_text
	call PrintText
	call YesNoBox
	jr c, .continueDateTimeSet
	call CalendarTimeSet_Quit
	xor a
	ld [wCompletedDateTimeSet], a
	scf
	ret
.continueDateTimeSet
	xor a
	ret
.d_up
	ld a, [wDatesetYear]
	cp 249
	jr c, .okay_up
	ld a, -1
.okay_up
	inc a
	ld [wDatesetYear], a
	xor a
	ret

.d_down
	ld a, [wDatesetYear]
	and a
	jr nz, .okay_down
	ld a, 250
.okay_down
	dec a
	ld [wDatesetYear], a
	xor a
	ret

.d_left
	ld a, [wDatesetMonth]
	and a
	jr nz, .okay_left
	call .d_down
	ld a, 12
.okay_left
	dec a
	jr .done_month

.d_right
	ld a, [wDatesetMonth]
	cp 11
	jr c, .okay_right
	call .d_up
	ld a, -1
.okay_right
	inc a
.done_month
	ld [wDatesetMonth], a
	xor a
	ret

.cancel_text
	ctxt "Cancel the Time"
	line "Machine?"
	done

CalendarTimeSet_SelectingDay:
	; clear arrows at month selection
	ld a, " "
	ldcoord_a 1, 2
	ldcoord_a 11, 2
	; init sprite anim struct for cursor
	depixel 7, 5
	ld a, SPRITE_ANIM_INDEX_CALENDAR_CURSOR
	call _InitSpriteAnimStruct
	hlcoord 10, 15
	ld de, .String
	call PlaceText
	jr .handleLoop

.loop
	callba PlaySpriteAnimationsAndDelayFrame
.handleLoop
	call SelectingDay_JoypadAction
	jr nc, .loop
	xor a
	ld [wSpriteAnim1Index], a
	ret

.String:
	ctxt "A: Confirm"
	next "B: Back"
	done

SelectingDay_JoypadAction:
	call GetJoypad
	ldh a, [hJoyPressed]
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit B_BUTTON_F, a
	jr nz, .b_button
	bit D_UP_F, a
	jr nz, .d_up
	bit D_DOWN_F, a
	jr nz, .d_down
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	and a
	ret

.a_button
	call CalendarTimeSet_Next
	scf
	ret

.b_button
	call CalendarTimeSet_Prev
	scf
	ret

.d_up
	ld a, [wDatesetDay]
	and a
	ret z
	sub 7
	jr nc, .done_up
	xor a
.done_up
	ld [wDatesetDay], a
	ret

.d_down
	ld a, [wDatesetMonthLength]
	dec a
	ld b, a
	ld a, [wDatesetDay]
	add 7
	cp b
	jr c, .okay_down
	ld a, b
.okay_down
	ld [wDatesetDay], a
	and a
	ret

.d_left
	ld a, [wDatesetDay]
	and a
	ret z
	dec a
	ld [wDatesetDay], a
	and a
	ret

.d_right
	ld a, [wDatesetMonthLength]
	ld b, a
	ld a, [wDatesetDay]
	inc a
	cp b
	jr nc, .okay_right
	ld [wDatesetDay], a
.okay_right
	and a
	ret

DrawMonth:
	xor a
	ldh [hBGMapMode], a
	call ClearTileMapNoDelay
	call .DrawMonth
	ld a, [wJumptableIndex]
	cp 2 ; hacky fix to clear arrows here
	jr z, .notRedrawingMonth1
	; clear arrows at month selection
	ld a, " "
	ldcoord_a 1, 2
	ldcoord_a 11, 2
.notRedrawingMonth1
	call CopyTilemapAtOnce
	ld a, 1
	ldh [hBGMapMode], a
	ret

.DrawMonth:
	ld a, [wDatesetDay]
	push af
	xor a
	ld [wDatesetDay], a
	call Dateset_GetWeekday
	ld [wWeekdayAtStartOfMonth], a

	ld a, [wDatesetMonth]
	ld bc, 10
	ld hl, MonthLengthAndNameData
	rst AddNTimes
	ld a, [hli]
	and a
	jr nz, .got_month_length
	ld a, [wDatesetYear]
	call IsLeapYear
	; a = carry ? 29 : 28
	ccf
	sbc a
	add 29
.got_month_length
	ld [wDatesetMonthLength], a
	push af
	decoord 2, 2
	ld bc, 9
	rst CopyBytes
	hlcoord 13, 2
	ld [hl], "2"
	inc hl
	ld de, wDatesetYear
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum

	ld a, [wDatesetMonthLength]
	ld c, a
.loop
	ld a, [wDatesetMonthLength]
	sub c
	push bc
	call .get_tile_coord
	pop bc
	dec c
	jr nz, .loop
	ld a, "◀"
	ldcoord_a 1, 2
	ld a, "▶"
	ldcoord_a 11, 2
	ld a, [wJumptableIndex]
	cp 2
	jr nz, .notRedrawingMonth2
	ld hl, .Sprites
	ld de, wSprites
	ld bc, 8
	rst CopyBytes
.notRedrawingMonth2
	hlcoord 10, 15
	ld de, .String
	call PlaceText

	pop bc
	pop af
	cp b
	jr c, .okay_month_length
	ld a, b
	dec a
.okay_month_length
	ld [wDatesetDay], a
	ret

.get_tile_coord
	push af
	inc a
	ld c, 10
	call SimpleDivide
	ld e, a
	ld a, b
	add 10
	ld d, a
	pop af
	ld b, a
	ld a, [wWeekdayAtStartOfMonth]
	add b
	ld c, 7
	call SimpleDivide
	push af
	ld a, b
	ld bc, 2 * SCREEN_WIDTH
	hlcoord 3, 4
	rst AddNTimes
	pop af
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], e
	ld bc, SCREEN_WIDTH - 1
	add hl, bc
	ld a, d
	add $e
	ld [hli], a
	ld a, e
	add $e
	ld [hl], a
	ret

.Sprites:
	db $1c, $90, $ee, (1 << OAM_Y_FLIP)
	db $24, $90, $ee, $00

.String:
	ctxt "A: Confirm"
	done

CopyMonthName:
	; in: a = month (0..11), hl = pointer
	; out: hl pointing to end
	push bc
	push de
	ld d, h
	ld e, l
	ld hl, MonthLengthAndNameData + 1
	ld bc, 10
	rst AddNTimes
	ld a, " "
	jr .handle_skip_spaces
.skip_spaces
	inc hl
.handle_skip_spaces
	cp [hl]
	jr z, .skip_spaces
.copy_loop
	ld a, [hli]
	cp $80
	jr c, .done
	ld [de], a
	inc de
	jr .copy_loop
.done
	ld h, d
	ld l, e
	pop de
	pop bc
	ret

MonthLengthAndNameData:
	db 31, " January "
	db 00, " February"
	db 31, "  March  "
	db 30, "  April  "
	db 31, "   May   "
	db 30, "  June   "
	db 31, "  July   "
	db 31, "  August "
	db 30, "September"
	db 31, " October "
	db 30, " November"
	db 31, " December"
	db 0 ;for CopyMonthName

CalendarNumbersGFX: INCBIN "gfx/datetime/calendar_numbers.1bpp"
CalendarCursorGFX:  INCBIN "gfx/datetime/calendar_cursor.2bpp"

UpdateCalendarCursor:
	push bc
	call GetCalendarDayRawCoords
	pop bc
	swap d
	swap e
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

GetCalendarDayRawCoords:
	ld a, [wDatesetDay]
	ld b, a
	ld a, [wWeekdayAtStartOfMonth]
	add b
	ld c, 7
	call SimpleDivide
	ld d, a
	ld e, b
	ret

Dateset_GetWeekday:
	ld a, [wDatesetMonth]
	inc a
	inc a
	ld b, a
	cp 4
	jr nc, .nosub
	add 12
	ld b, a
	scf
.nosub
	ld a, [wDatesetYear]
	sbc 0
	lb de, 99, 3
	jr c, .donevars
.mod100
	sub 100
	inc e
	jr nc, .mod100
	add 100
	ld d, a
.donevars
	ld a, b
	ld bc, 666 ; ⌈2.6*256⌉
	ld hl, 0
	rst AddNTimes
	ld a, [wDatesetDay]
	jp _GetWeekday ; the rest is the same as home one

TIMESET_ORIGIN_X EQU 11
TIMESET_ORIGIN_Y EQU 9

CalendarTimeSet_SelectingTime:
	call GetCalendarDayRawCoords
	ld a, e
	cp 4 ; hardcode to hide cursor before message
	jr c, .cursor_hidden
	call ClearSprites
	call DelayFrame
.cursor_hidden
	call CheckIfTimeMachine
	ld hl, .set_time_text
	jr z, .message_selected
	ld hl, .set_time_machine_text
.message_selected
	call PrintTextNotInMenu
	call ClearSprites
	call ClearScreen
	ld c, 2
	call DelayFrames
	hlcoord TIMESET_ORIGIN_X - 1, TIMESET_ORIGIN_Y - 2
	lb bc, 3, 8
	call TextBox
	hlcoord 0, 10
	ld hl, .information_string
	call PrintTextNotInMenu
	xor a
	ld [wTimesetCursorPosition], a
.loop
	call UpdateTimesetTimeAndCursors
	call DelayFrame
	call HandleTimesetJoypad
	jr nc, .loop
	ret

.set_time_text
	ctxt "Please set the"
	line "time."
	prompt

.set_time_machine_text
	ctxt "Please set the"
	line "destination time."
	prompt

.information_string
	ctxt "Please set time."
	line "(SEL toggles 24hr)"
	done

PrintBufferTime:
	ld hl, wInitHourBuffer
	ld a, [hli]
	ld d, a
	ld e, [hl]
	jpba PrintHoursMins

UpdateTimesetTimeAndCursors:
	bccoord TIMESET_ORIGIN_X, TIMESET_ORIGIN_Y
	call PrintBufferTime
	ld a, [wOptions2]
	and 1 << 3
	jr nz, .keep_noon_reference ; AM = ante meridiem (before noon), PM = post meridiem (after noon). Hence, "noon reference".
	ld a, "-"
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
.keep_noon_reference
	ld a, " "
	hlcoord TIMESET_ORIGIN_X + 1, TIMESET_ORIGIN_Y - 1
	push hl
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hl], a
	hlcoord TIMESET_ORIGIN_X + 1, TIMESET_ORIGIN_Y + 1
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hl], a
	ld a, [wTimesetCursorPosition]
	add a, $ff
	adc 1 ; converts 0, 1, 2 into 0, 2, 3
	pop hl
	ld c, a
	ld b, 0
	add hl, bc
	ld [hl], $1c ;arrow up
	ld c, SCREEN_WIDTH * 2
	add hl, bc
	ld [hl], $1d ;arrow down
	ret

HandleTimesetJoypad:
	call GetJoypad
	ldh a, [hJoyPressed]
	and a ;clear carry
	bit B_BUTTON_F, a
	jr nz, .cancel
	bit A_BUTTON_F, a
	jr nz, .confirm
	bit D_LEFT_F, a
	jr nz, .left
	bit D_RIGHT_F, a
	jr nz, .right
	bit D_UP_F, a
	jr nz, .increment
	bit D_DOWN_F, a
	jr nz, .decrement
	bit SELECT_F, a
	ret z
	ld a, [wOptions2]
	xor 1 << 3
	ld [wOptions2], a
	ret

.confirm
	call CalendarTimeSet_Next
	scf
	jp PlayClickSFX

.cancel
	call CalendarTimeSet_Prev
	call PlayClickSFX
	call DrawMonth
	scf
	ret

.left
	ld hl, wTimesetCursorPosition
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	ld [hl], 2
	ret

.right
	ld hl, wTimesetCursorPosition
	inc [hl]
	ld a, [hl]
	cp 3
	ccf
	ret nc
	xor a
	ld [hl], a
	ret

.decrement
	ld a, [wTimesetCursorPosition]
	and a
	jr nz, .decrement_minutes
	ld hl, wInitHourBuffer
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	ld [hl], 23
	ret

.increment
	ld a, [wTimesetCursorPosition]
	and a
	jr nz, .increment_minutes
	ld hl, wInitHourBuffer
	inc [hl]
	ld a, [hl]
	cp 24
	ccf
	ret nc
	xor a
	ld [hl], a
	ret

.decrement_minutes
	ld hl, wInitMinuteBuffer
	dec a
	jr nz, .decrement_one
	ld a, [hl]
	sub 10
	ld [hl], a
	ret nc
	sub -60 ;so it doesn't set carry
	ld [hl], a
	ret

.decrement_one
	call .get_last_digit
	dec [hl]
	and a
	ret nz
	ld a, [hl]
	add a, 10
	ld [hl], a
	and a
	ret

.increment_minutes
	ld hl, wInitMinuteBuffer
	dec a
	jr nz, .increment_one
	ld a, [hl]
	add a, 10
	ld [hl], a
	cp 60
	ccf
	ret nc
	sub 60 ;no carry
	ld [hl], a
	ret

.increment_one
	call .get_last_digit
	inc [hl]
	cp 9
	ccf
	ret nc
	ld a, [hl]
	sub 10 ;cannot set carry
	ld [hl], a
	ret

.get_last_digit
	ld a, [hl]
	ld c, 10
	jp SimpleDivide

PrintTextNotInMenu:
	ldh a, [hInMenu]
	push af
	xor a
	ldh [hInMenu], a
	call PrintText
	pop af
	ldh [hInMenu], a
	ret

TimesetUpDownArrowGFX: INCBIN "gfx/datetime/timeset_arrows.1bpp"

CalendarTimeSet_Confirm:
	call ClearSprites
	call ClearScreen
	ld c, 2
	call DelayFrames
	call GetConfirmDateAndTimeText
	call SpeechTextBox
	ld hl, AskDateTimeOkayText
	call PrintTextNotInMenu
	call YesNoBox
	jp c, CalendarTimeSet_Prev
	ld hl, wDatesetYear
	ld de, wCurYear
	ld bc, 3
	rst CopyBytes
	ld hl, wStringBuffer2
	ld a, [wCurDay]
	ld [hli], a
	ld a, [wInitHourBuffer]
	ld [hli], a
	ld a, [wInitMinuteBuffer]
	ld [hli], a
	xor a
	ld [hli], a
	inc a
	ld [wCompletedDateTimeSet], a
	ld a, [wCurMonth]
	ld [hli], a
	ld a, [wCurYear]
	ld [hl], a
	call InitTime
	SetEngine ENGINE_TIME_ENABLED
	callba InitializePokerusTimer

; fallthrough
CalendarTimeSet_Quit:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

GetConfirmDateAndTimeText:
	; writes to wStringBuffer3
	call Dateset_GetWeekday
	ld de, wStringBuffer3
	ld c, a
	callba PlaceWeekday
	ld h, d
	ld l, e
	ld a, " "
	ld [hli], a
	ld a, [wDatesetDay]
	inc a
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	call .place_digit_nonzero
	ld a, c
	call .place_digit
	ld a, " "
	ld [hli], a
	ld d, h
	ld e, l
	ld a, [wDatesetMonth]
	ld c, a
	callba PlaceMonthName
	ld h, d
	ld l, e
	ld a, " "
	ld [hli], a
	ld a, "2"
	ld [hli], a
	ld a, [wDatesetYear]
	ld c, 100
	call SimpleDivide
	push bc
	ld c, 10
	call SimpleDivide
	ld c, a
	pop af
	call .place_digit
	ld a, b
	call .place_digit
	ld a, c
	call .place_digit
	ld a, "<NEXT>"
	ld [hli], a
	ld b, h
	ld c, l
	call PrintBufferTime
	ld a, "@"
	ld [bc], a
	ret

.place_digit_nonzero
	and a
	jr nz, .place_digit
	ld a, " "
	ld [hli], a
	ret
.place_digit
	add a, "0"
	ld [hli], a
	ret

AskDateTimeOkayText:
	text "<STRBF3>@"
	start_asm
	call CheckIfTimeMachine
	ld hl, .confirm_text
	ret z
	ld hl, .travel_to_date_text
	ret

.confirm_text
	ctxt ""
	para "Is that correct?"
	done

.travel_to_date_text
	ctxt ""
	para "Travel to this"
	line "date?"
	done

CheckIfTimeMachine:
	ld a, [wIsTimeMachine]
	and a
	ret
