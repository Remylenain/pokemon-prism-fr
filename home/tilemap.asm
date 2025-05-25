ConsumeGenericDelay:
	ld a, [wGenericDelay]
	and a
	ret z
	ld c, a
	jp DelayFrames

PushWindow::
	jpba _PushWindow

ExitMenu::
	push af
	callba _ExitMenu
	pop af
	ret

InitVerticalMenuCursor::
	jpba _InitVerticalMenuCursor

CloseWindow::
	push af
	call ExitMenu
CloseWindow_AfterExitMenu::
	call ApplyTilemap
	call UpdateSprites
	pop af
	ret

RestoreTileBackup::
	call PushWindow_MenuBoxCoordToTile
	call .copy
	call PushWindow_MenuBoxCoordToAttr

.copy
	call GetTileBackupMenuBoxDims

.row
	push bc
	push hl

.col
	ld a, [de]
	ld [hli], a
	dec de
	dec c
	jr nz, .col

	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

GetTileBackupMenuBoxDims:
	call GetMenuBoxDims
	ld a, [wMenuFlags]
	bit 1, a
	jr z, .offsetOfOne
	inc b
	inc b
	inc c
	inc c
.offsetOfOne
	inc b
	inc c
	ret

PopWindow::
	ld b, $10
	ld de, wMenuFlags
.loop
	ld a, [hld]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

GetMenuBoxDims::
	ld a, [wMenuBorderTopCoord] ; top
	ld b, a
	ld a, [wMenuBorderBottomCoord] ; bottom
	sub b
	jr nc, .positive
	cpl
.positive
	ld b, a
	ld a, [wMenuBorderLeftCoord] ; left
	ld c, a
	ld a, [wMenuBorderRightCoord] ; right
	sub c
	ld c, a
	ret nc
	cpl
	ld c, a
	ret

CopyMenuData2::
	push hl
	push de
	push bc
	push af
	ld hl, wMenuDataPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMenuDataFlags
	ld bc, wMenuDataEnd - wMenuDataFlags
	rst CopyBytes
	jp PopOffRegsAndReturn

GetWindowStackTop::
	ld hl, wWindowStackPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

PlaceVerticalMenuItems::
	call CopyMenuData2
	ld a, [wMenuDataItems]
	and a
	jp z, SetUpVariableDataMenu
	ld hl, wMenuDataPointer
	ld a, [hli]
	ld d, [hl]
	ld e, a
	call GetMenuTextStartCoord
	call Coord2Tile ; hl now contains the tilemap address where we will start printing text.
	inc de
	ld a, [de] ; Number of items
	inc de
	ld b, a
.loop
	push bc
	call PlaceString
	inc de
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop

	ld a, [wMenuDataFlags]
	bit 4, a
	ret z

	call MenuBoxCoord2Tile
	ld a, [de]
	ld c, a
	inc de
	ld b, 0
	add hl, bc
	jp PlaceString

MenuBox::
	call MenuBoxCoord2Tile
	call GetMenuBoxDims
	dec b
	dec c
	jp TextBox

GetMenuTextStartCoord::
	ld a, [wMenuBorderTopCoord]
	ld b, a
	inc b
	ld a, [wMenuBorderLeftCoord]
	ld c, a
	inc c
; bit 6: if not set, leave extra room on top
	ld a, [wMenuDataFlags]
	bit 6, a
	jr nz, .bit_6_set
	inc b
.bit_6_set
; bit 7: if set, leave extra room on the left
	ld a, [wMenuDataFlags]
	bit 7, a
	ret z
	inc c
	ret

ClearMenuBoxInterior::
	call MenuBoxCoord2Tile
	ld bc, SCREEN_WIDTH + 1
	add hl, bc
	call GetMenuBoxDims
	dec b
	dec c
	jp ClearBox

ClearWholeMenuBox::
	call MenuBoxCoord2Tile
	call GetMenuBoxDims
	inc c
	inc b
	jp ClearBox

PushWindow_MenuBoxCoordToTile:
	coord bc, 0, 0
	jr PushWindow_MenuBoxCoordToAbsolute

PushWindow_MenuBoxCoordToAttr:
	coord bc, 0, 0, wAttrMap

; fallthrough
PushWindow_MenuBoxCoordToAbsolute:
	push bc
	call LoadMenuBoxCoords
	ld a, [wMenuFlags]
	bit 1, a
	jr z, .noDec
	dec b
	dec c
.noDec
	call Coord2Absolute
	pop bc
	add hl, bc
	ret

MenuBoxCoord2Tile::
	call LoadMenuBoxCoords
	; fallthrough

Coord2Tile::
; Return the address of wTileMap(c, b) in hl.
	call Coord2Absolute
	bccoord 0, 0
	add hl, bc
	ret

LoadMenuBoxCoords:
	ld a, [wMenuBorderLeftCoord]
	ld c, a
	ld a, [wMenuBorderTopCoord]
	ld b, a
	ret

MenuBoxCoord2Attr::
	call LoadMenuBoxCoords
	; fallthrough

Coord2Attr:
; Return the address of wAttrMap(c, b) in hl.
	call Coord2Absolute
	bccoord 0, 0, wAttrMap
	add hl, bc
	ret

Coord2Absolute:
; Returns the address of (c, b) as a linear tile value in hl.
	ld l, c
	ld h, 0
	ld c, b
	ld b, h
	ld a, SCREEN_WIDTH
	rst AddNTimes
	ret

LoadTileMapToTempTileMap::
; Load wTileMap into wTempTileMap
	ldh a, [rSVBK]
	push af
	wbk BANK(wTempTileMap)
	hlcoord 0, 0
	decoord 0, 0, wTempTileMap
	ld bc, wTileMapEnd - wTileMap
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	ret

Call_LoadTempTileMapToTileMap::
	xor a
	ldh [hBGMapMode], a
	call LoadTempTileMapToTileMap
	ld a, 1
	ldh [hBGMapMode], a
	ret

LoadTempTileMapToTileMap::
; Load wTempTileMap into wTileMap
	ldh a, [rSVBK]
	push af
	wbk BANK(wTempTileMap)
	hlcoord 0, 0, wTempTileMap
	decoord 0, 0
	ld bc, wTileMapEnd - wTileMap
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	ret
