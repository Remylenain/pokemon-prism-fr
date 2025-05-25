Pokepic::
	ld a, b
	and a
	jr z, .okay
	xor a
	ld hl, wTempMonDVs
	ld [hli], a
	ld [hl], a
.okay
	xor a
	ldh [hBGMapMode], a
	ld hl, PokepicMenuHeader
	call CopyMenuHeader
	call MenuBox
	call UpdateSprites
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld de, vFontTiles
	predef GetFrontpic
	ld a, [wMenuBorderTopCoord]
	inc a
	ld b, a
	ld a, [wMenuBorderLeftCoord]
	inc a
	ld c, a
	call Coord2Tile
	ld a, $80
	ldh [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	ldh a, [hVBlank]
	push af
	ld a, 2
	ldh [hVBlank], a
	ld b, SCGB_POKEPIC
	predef GetSGBLayout
	ld b, 1
	call SafeCopyTilemapAtOnce
	pop af
	ldh [hVBlank], a
	ret

ClosePokepic::
	ld b, SCGB_RAM
	predef GetSGBLayout
	xor a
	ldh [hBGMapMode], a
	call OverworldTextModeSwitch
	call ApplyTilemap
	call UpdateSprites
	jp LoadStandardFont

PokepicMenuHeader:
	db $40 ; flags
	db 04, 06 ; start coords
	db 12, 14 ; end coords
	dw NULL
	db 1 ; default option
