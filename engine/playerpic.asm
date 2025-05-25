HOF_LoadTrainerFrontpic:
	call ApplyTilemapInVBlank
	xor a
	ldh [hBGMapMode], a
	call GetPlayerFrontpicAndTrainerClass
	call ApplyTilemapInVBlank
	ld a, 1
	ldh [hBGMapMode], a
	ret

DrawIntroPlayerPic:
; Draw the player pic at (6,4).
	call GetPlayerFrontpicAndTrainerClass

; Draw
	xor a
	ldh [hGraphicStartTile], a
	hlcoord 6, 4
	lb bc, 7, 7
	predef_jump PlaceGraphic

GetPlayerFrontpicAndTrainerClass:
	ld a, [wPlayerCharacteristics]
	ld hl, wTrainerClass
	bit 0, a
	ld [hl], CHRIS
	jr z, GetPlayerFrontpic
	ld [hl], KRIS

GetPlayerFrontpic:
	and $f
	cp 12
	jr nc, .palettePatroller

	ld hl, PlayerPics
	ld bc, 7 * 7 tiles
	rst AddNTimes
	ld d, h
	ld e, l
	ld b, BANK(PlayerPics)
.ready
	ld c, 7 * 7
	ld hl, vBGTiles
	jp Get2bpp

.palettePatroller
	ld b, BANK(PlayerPalettePatroller)
	ld de, PlayerPalettePatroller
	jr .ready

GetPlayerBackpic:
; Load the player character's backpic (6x6) into VRAM starting from vBGTiles tile $31.
	ld a, [wPlayerCharacteristics]
	and $f
	cp 12
	jr nc, .palettePatrollerBack

	ld bc, 6 * 6 tiles
	ld hl, PlayerBackpics
	rst AddNTimes
	ld d, h
	ld e, l
	lb bc, BANK(PlayerBackpics), 6 * 6
.ready
	ld hl, vBGTiles tile $31
	jp Get2bpp

.palettePatrollerBack
	lb bc, BANK(PlayerPalettePatrollerBack), 7 * 7
	ld de, PlayerPalettePatrollerBack
	jr .ready
