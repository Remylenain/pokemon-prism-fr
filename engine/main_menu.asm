MainMenu:
	xor a
	ld [wLinkSuppressTextScroll], a
	ldh [hMapAnims], a
	call ClearTileMap
	call LoadStandardFont
	call ClearWindowData
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	ld hl, wGameTimerPause
	res 0, [hl]
	ld a, [wSaveFileExists]
	ld [wWhichIndexSet], a
	and a
	jr z, .ok
	callba TryLoadSaveFile
	push af
	call ClearTileMap
	pop af
	ld a, 0
	jr c, .badSaveFile
	debug_mode_flag
	jr nc, .ok
	ld a, 2
.badSaveFile
	ld [wWhichIndexSet], a
.ok
	call MainMenu_PrintCurrentTimeAndDay
	call MainMenu_PrintVersion
	ld hl, .MenuHeader
	call LoadMenuHeader
	call MainMenuJoypadLoop
	call CloseWindow
	ret c
	call ClearTileMap
	call .DoMenuChoice
	jr MainMenu

.MenuHeader
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 16 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $80 ; flags
	db 0 ; items
	dw MainMenuItems
	dw PlaceMenuStrings
	dw .Strings

.Strings
	db "Continue@"
	db "New Game@"
	db "Options@"
	db "Debug options@"

.DoMenuChoice
	ld a, [wMenuSelection]
	and a
	jr z, .doContinue
	dec a
	jr z, .doNewGame
	dec a
	jr z, .doOptions
	jpba MainDebugOptions

.doOptions
	jpba OptionsMenu

.doContinue
	jpba Continue

.doNewGame
	jpba NewGame

CONTINUE       EQU 0
NEW_GAME       EQU 1
OPTION         EQU 2
DEBUG_OPTIONS  EQU 3

MainMenuItems:
.new_game
	db 2
	db NEW_GAME
	db OPTION
	db -1

.continue
	db 3
	db CONTINUE
	db NEW_GAME
	db OPTION
	db -1

.continue_debug
	db 4
	db CONTINUE
	db NEW_GAME
	db OPTION
	db DEBUG_OPTIONS
	db -1

MainMenuJoypadLoop:
	call SetUpMenu
.loop
	call MainMenu_PrintCurrentTimeAndDay
	ld a, [w2DMenuFlags1]
	set 5, a
	ld [w2DMenuFlags1], a
	call ReadMenuJoypad
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .b_button
	cp A_BUTTON
	jr nz, .loop
	call PlayClickSFX
	and a
	ret

.b_button
	scf
	ret

MainMenu_PrintVersion:
	ld de, .version_string
	hlcoord 2, 12
IF DEF(DEBUG_MODE)
	call PlaceText
ELSE
	jp PlaceText
ENDC
	hlcoord 8, 13
	ld de, .debug_build_string
	jp PlaceText
.version_string
	ctxt "version @"
	db "0" + VERSION_MAJOR
	db "."
	db "0" + VERSION_MINOR / 10
	db "0" + VERSION_MINOR % 10
	db "."
	db "0" + BUILD_NUMBER / 1000
	db "0" + BUILD_NUMBER % 1000 / 100
	db "0" + BUILD_NUMBER % 100 / 10
	db "0" + BUILD_NUMBER % 10
	db "@"
	done
.debug_build_string
	ctxt "debug build@"
	done

MainMenu_PrintCurrentTimeAndDay:
	ld a, [wSaveFileExists]
	and a
	ret z
	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 14
	lb bc, 2, 18
	call TextBox
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call .PlaceTime
	pop af
	ld [wOptions], a
	ld a, 1
	ldh [hBGMapMode], a
	ret

.PlaceTime
	ld a, [wSaveFileExists]
	and a
	ret z
	call CheckRTCStatus
	and $80
	jp nz, .PrintTimeNotSet
	call ForceUpdateTime
	call GetWeekday
	ld c, a
	decoord 1, 15
	call PlaceWeekday
	hlcoord 5, 15
	ld b, 1
	call MainMenu_PrintDate
	hlcoord 5, 16
	ldh a, [hHours]
	ld c, a
	ld b, 0
	ld a, [wOptions2]
	and 1 << 3
	jr z, .go
	ld b, "A"
	ld a, c
	cp 12
	jr c, .got_ampm
	sub 12
	ld b, "P"
.got_ampm
	ld c, a
	and a
	jr nz, .go
	ld c, 12
.go
	push bc
	ld a, c
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add a, "0"
	cp "0"
	jr nz, .hour_OK
	ld a, " "
.hour_OK
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	ld a, ":"
	ld [hli], a
	ld de, hMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	push bc
	call PrintNum
	ld a, ":"
	ld [hli], a
	ld de, hSeconds
	pop bc
	call PrintNum
	pop af
	and a
	ret z
	ld [hl], " "
	inc hl
	ld [hli], a
	ld [hl], "M"
	ret

.PrintTimeNotSet
	hlcoord 1, 15
	ld de, .TimeNotSet
	jp PlaceText

.TimeNotSet
	ctxt "Time not set"
	done

PlaceWeekday:
	; writes weekday c into de; returns de pointing to end
	ld b, 0
	ld hl, .Days
	add hl, bc
	add hl, bc
	add hl, bc
	ld bc, 3
	rst CopyBytes
	ret

.Days
	db "Sun"
	db "Mon"
	db "Tue"
	db "Wed"
	db "Thu"
	db "Fri"
	db "Sat"

MainMenu_PrintDate:
	push bc
	push hl
	ld a, [wCurDay]
	inc a
	ld de, wd265
	ld [de], a
	pop hl
	lb bc, 1, 2
	call PrintNum
	inc hl
	push hl

	ld a, [wCurMonth]
	ld c, a
	pop de
	call PlaceMonthName

	pop af
	and a
	ret z
	inc de
	ld h, d
	ld l, e
	ld [hl], "2"
	inc hl
	ld de, wCurYear
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	jp PrintNum

PlaceMonthName:
	; writes month name c into de; returns de pointing to end
	ld b, 0
	ld hl, .MonthStrings
	add hl, bc
	add hl, bc
	add hl, bc
	ld bc, 3
	rst CopyBytes
	ret

.MonthStrings
	db "Jan"
	db "Feb"
	db "Mar"
	db "Apr"
	db "May"
	db "Jun"
	db "Jul"
	db "Aug"
	db "Sep"
	db "Oct"
	db "Nov"
	db "Dec"
