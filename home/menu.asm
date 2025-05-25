Script_loadmenudata:
	call GetScriptHalfwordOrVar_HL
	ld a, [wScriptBank]
	call StackCallInBankA
	; end of function

	call LoadMenuHeader
	jp UpdateSprites

CopyMenuHeader::
	ld de, wMenuHeader
	ld bc, wMenuHeaderEnd - wMenuHeader
	rst CopyBytes
	ldh a, [hROMBank]
	ld [wMenuDataBank], a
	ret

MenuTextBox::
	push hl
	call LoadMenuTextBox
	pop hl
	jp PrintText

MenuTextBoxBackup::
	call MenuTextBox
	jp CloseWindow

LoadMenuTextBox::
	ld hl, MenuTextBoxDataHeader
	jr LoadMenuHeader

LoadStandardMenuHeader::
	ld hl, StandardMenuHeader
LoadMenuHeader::
	call CopyMenuHeader
	jp PushWindow

StandardMenuHeader:
	db $40 ; tile backup
	db 0, 0 ; start coords
	db 17, 19 ; end coords
	dw 0
	db 1 ; default option

MenuTextBoxDataHeader:
	db $40 ; tile backup
	db 12, 0 ; start coords
	db 17, 19 ; end coords
	dw vObjTiles
	db 0 ; default option

VerticalMenu::
	xor a
	ldh [hBGMapMode], a
	call MenuBox
	call UpdateSprites
	call PlaceVerticalMenuItems
	call ApplyTilemap
	ld a, [wMenuDataFlags]
	add a, a
	ccf
	ret c
	call InitVerticalMenuCursor
	call DoMenuJoypadLoop
	call MenuClickSound
	ld b, a
	ld a, [wMenuFlags]
	bit 2, a
	ld a, b
	jp nz, GetVariableDataMenuResult
	and 2
	ret z
	scf
	ret

GetMenu2::
	call LoadMenuHeader
	call VerticalMenu
	call CloseWindow
GetMenu2_AfterCloseWindow::
	ld a, [wMenuCursorY]
	ret

CopyNameFromMenu::
	push hl
	push bc
	push af
	ld hl, wMenuDataPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	pop af
	call GetNthString
	ld d, h
	ld e, l
	call CopyName1
	pop bc
	pop hl
	ret

PlaceGenericTwoOptionBox::
	call LoadMenuHeader
	jr InterpretTwoOptionMenu

YesNoBox::
	lb bc, SCREEN_WIDTH - 6, 7
	; fallthrough

PlaceYesNoBox::
; Return nc (yes) or c (no).
	push bc
	ld hl, YesNoMenuHeader
	call CopyMenuHeader
	pop bc
; This seems to be an overflow prevention, but
; it was coded wrong.
	ld a, b
	cp SCREEN_WIDTH - 6
	jr nz, .okay ; should this be "jr nc"?
	ld b, SCREEN_WIDTH - 6

.okay
	ld a, b
	ld [wMenuBorderLeftCoord], a
	add 5
	ld [wMenuBorderRightCoord], a
	ld a, c
	ld [wMenuBorderTopCoord], a
	add 4
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	; fallthrough

InterpretTwoOptionMenu::
	call VerticalMenu
	push af
	ld c, 15
	call DelayFrames
	call CloseWindow
InterpretTwoOptionMenu_AfterCloseWindow::
	pop af
	jr c, .no
	ld a, [wMenuCursorY]
	cp 2 ; no
	jr z, .no
	and a
	ret

.no
	ld a, 2
	ld [wMenuCursorY], a
	scf
	ret

YesNoMenuHeader::
	db $40 ; tile backup
	db 5, 10 ; start coords
	db 9, 15 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $c0 ; flags
	db 2
	db "Yes@"
	db "No@"

OffsetMenuHeader::
	call _OffsetMenuHeader
	jp PushWindow

_OffsetMenuHeader::
	push de
	call CopyMenuHeader
	pop de
	ld a, [wMenuBorderLeftCoord]
	ld h, a
	ld a, [wMenuBorderRightCoord]
	sub h
	ld h, a
	ld a, d
	ld [wMenuBorderLeftCoord], a
	add h
	ld [wMenuBorderRightCoord], a
	ld a, [wMenuBorderTopCoord]
	ld l, a
	ld a, [wMenuBorderBottomCoord]
	sub l
	ld l, a
	ld a, e
	ld [wMenuBorderTopCoord], a
	add l
	ld [wMenuBorderBottomCoord], a
	ret

DoNthMenu::
	call DrawVariableLengthMenuBox
	call MenuWriteText
	call InitMenuCursorAndButtonPermissions
	call GetStaticMenuJoypad
	call GetMenuJoypad
	jp MenuClickSound

SetUpMenu::
	call DrawVariableLengthMenuBox
	call MenuWriteText
	call InitMenuCursorAndButtonPermissions ; set up selection pointer
	ld hl, w2DMenuFlags1
	set 7, [hl]
	ret

DrawVariableLengthMenuBox::
	call CopyMenuData2
	call GetMenuIndexSet
	call AutomaticGetMenuBottomCoord
	jp MenuBox

SetUpVariableDataMenu:
	ld hl, wMenuFlags
	set 2, [hl]
	call AutomaticGetMenuBottomCoord

MenuWriteText::
	xor a
	ldh [hBGMapMode], a
	call GetMenuIndexSet ; sort out the text
	call RunMenuItemPrintingFunction ; actually write it
	call SafeUpdateSprites
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	call ApplyTilemap
	pop af
	ldh [hOAMUpdate], a
	ret

AutomaticGetMenuBottomCoord::
	ld a, [wMenuBorderLeftCoord]
	ld c, a
	ld a, [wMenuBorderRightCoord]
	sub c
	ld c, a
	ld a, [wMenuDataItems]
	add a
	inc a
	ld b, a
	ld a, [wMenuBorderTopCoord]
	add b
	ld [wMenuBorderBottomCoord], a
	ret

GetMenuIndexSet::
	ld hl, wMenuDataIndicesPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wWhichIndexSet]
	and a
	jr z, .skip
	ld b, a
	ld c, -1
.loop
	ld a, [hli]
	cp c
	jr nz, .loop
	dec b
	jr nz, .loop

.skip
	ld d, h
	ld e, l
	ld a, [hl]
	ld [wMenuDataItems], a
	ret

RunMenuItemPrintingFunction::
	call MenuBoxCoord2Tile
	ld bc, 2 * SCREEN_WIDTH + 2
	add hl, bc
.loop
	inc de
	ld a, [de]
	cp -1
	ret z
	ld [wMenuSelection], a
	push de
	push hl
	ld d, h
	ld e, l
	ld hl, wMenuDataDisplayFunctionPointer
	call CallLocalPointer
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop de
	jr .loop

InitMenuCursorAndButtonPermissions::
	call InitVerticalMenuCursor
	ld hl, wMenuJoypadFilter
	ld a, [wMenuDataFlags]
	bit 3, a
	jr z, .disallow_select
	set START_F, [hl]

.disallow_select
	ld a, [wMenuDataFlags]
	bit 2, a
	ret z
	set D_LEFT_F, [hl]
	set D_RIGHT_F, [hl]
	ret

ReadMenuJoypad::
	call DoMenuJoypadLoop
GetVariableDataMenuResult:
	ld hl, wMenuJoypadFilter
	and [hl]
	jr FilterMenuJoypad

GetStaticMenuJoypad::
	xor a
	ld [wMenuJoypad], a
	call DoMenuJoypadLoop
	; fallthrough

FilterMenuJoypad::
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit B_BUTTON_F, a
	jr nz, .b_start
	bit START_F, a
	jr nz, .b_start
	bit D_RIGHT_F, a
	jr nz, .d_right
	bit D_LEFT_F, a
	jr nz, .d_left
	xor a
	ld [wMenuJoypad], a
	jr .done

.d_right
	ld a, D_RIGHT
	ld [wMenuJoypad], a
	jr .done

.d_left
	ld a, D_LEFT
	ld [wMenuJoypad], a
	jr .done

.a_button
	ld a, A_BUTTON
	ld [wMenuJoypad], a

.done
	call GetMenuIndexSet
	ld a, [wMenuCursorY]
	ld l, a
	ld h, 0
	add hl, de
	ld a, [hl]
	ld [wMenuSelection], a
	ld a, [wMenuCursorY]
	ld [wMenuCursorBuffer], a
	and a
	ret

.b_start
	ld a, B_BUTTON
	ld [wMenuJoypad], a
	ld a, -1
	ld [wMenuSelection], a
	scf
	ret

PlaceMenuStrings::
	push de
	ld hl, wMenuDataPointerTableAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMenuSelection]
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	jp PlaceString

PlaceNthMenuStrings::
	push de
	ld a, [wMenuSelection]
	call GetMenuDataPointerTableEntry
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	jp PlaceString

MenuJumptable::
	ld a, [wMenuSelection]
	call GetMenuDataPointerTableEntry
	jp CallLocalPointer

GetMenuDataPointerTableEntry::
	ld e, a
	ld d, 0
	ld hl, wMenuDataPointerTableAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ret

ClearWindowData::
	ld hl, wWindowStackPointer
	call .bytefill
	ld hl, wMenuHeader
	call .bytefill
	ld hl, wMenuDataFlags
	call .bytefill
	ld hl, w2DMenuCursorInitY
	call .bytefill

	ldh a, [rSVBK]
	push af
	wbk BANK(wWindowStackBottom)

	xor a
	ld hl, wWindowStackBottom
	ld [hld], a
	ld [hld], a
	ld a, l
	ld [wWindowStackPointer], a
	ld a, h
	ld [wWindowStackPointer + 1], a

	pop af
	ldh [rSVBK], a
	ret

.bytefill
	ld bc, 16
	xor a
	jp ByteFill

MenuClickSound::
	push af
	and A_BUTTON | B_BUTTON
	jr z, .nosound
	ld hl, wMenuFlags
	bit 3, [hl]
	call z, PlayClickSFX
.nosound
	pop af
	ret

PlayClickSFX::
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

MenuTextBoxWaitButton::
	call MenuTextBox
	call WaitButton
	jp ExitMenu

_2DMenu::
	ldh a, [hROMBank]
	ld [wMenuData_2DMenuItemStringsBank], a
	callba _2DMenu_
	ld a, [wMenuCursorBuffer]
	ret

SetMenuAttributes::
	push hl
	push bc
	ld hl, w2DMenuCursorInitY
	ld b, 8
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop
	ld a, 1
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop bc
	pop hl
	ret

ScrollingMenu::
	call CopyMenuData2
	anonbankpush _ScrollingMenu

	call _InitScrollingMenu
	call ScrollingMenu_UpdatePalettes
	call _ScrollingMenu
	ld a, [wMenuJoypad]
	ret

InitScrollingMenu::
	ld a, [wMenuBorderTopCoord]
	and a
	jr z, .skipDec1
	dec a
.skipDec1
	ld b, a
	ld a, [wMenuBorderBottomCoord]
	cp SCREEN_HEIGHT
	jr c, .validBorderBottom
	ld a, SCREEN_HEIGHT - 1
.validBorderBottom
	sub b
	ld d, a
	ld a, [wMenuBorderLeftCoord]
	and a
	jr z, .skipDec2
	dec a
.skipDec2
	ld c, a
	ld a, [wMenuBorderRightCoord]
	cp SCREEN_WIDTH
	jr c, .validBorderRight
	ld a, SCREEN_WIDTH - 1
.validBorderRight
	sub c
	ld e, a
	push de
	call Coord2Tile
	pop bc
	jp TextBox

DoMenuJoypadLoop::
	callba _DoMenuJoypadLoop

GetMenuJoypad::
	push bc
	push af
	ldh a, [hJoyPressed]
	and BUTTONS
	ld b, a
	ldh a, [hJoyLast]
	and D_PAD
	or b
	ld b, a
	pop af
	ld a, b
	pop bc
	ret

PlaceHollowCursor::
	ld hl, wCursorCurrentTile
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], "▷"
	ret

HideCursor::
	ld hl, wCursorCurrentTile
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], " "
	ret
