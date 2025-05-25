_AnimateTileset::
; Iterate over a given pointer array of
; animation functions (one per frame).

; Typically in wra1, vra0

	ld a, [wTilesetAnim]
	ld e, a
	ld a, [wTilesetAnim + 1]
	ld d, a

	ldh a, [hTileAnimFrame]
	ld l, a
	inc a
	ldh [hTileAnimFrame], a

	ld h, 0
	add hl, hl
	add hl, hl
	add hl, de

; 2-byte parameter
; All functions take input de.
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

; Function address
	ld a, [hli]
	ld h, [hl]
	ld l, a

	jp hl

Tileset03Anim:
	dw vBGTiles tile $14, AnimateWaterTile
	dw vBGTiles tile $69, WriteTileToBuffer
	dw wTileAnimBuffer, ScrollTileDown
	dw vBGTiles tile $69, WriteTileToBuffer
	dw NULL, TileAnimationPalette
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $03, AnimateFlowerTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset00Anim:
Tileset02Anim:
Tileset34Anim:
Tileset35Anim:
	dw vBGTiles tile $14, AnimateWaterTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, TileAnimationPalette
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $03, AnimateFlowerTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset31Anim:
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $03, AnimateFlowerTile
	dw vBGTiles tile $14, AnimateWaterTile
	dw NULL, TileAnimationPalette
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset01Anim:
Tileset56Anim:
	dw vBGTiles tile $14, AnimateWaterTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, TileAnimationPalette
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $03, AnimateFlowerTile
	dw WhirlpoolFrames1, AnimateWhirlpoolTile
	dw WhirlpoolFrames2, AnimateWhirlpoolTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset08Anim:
Tileset28Anim:
Tileset44Anim:
	dw vBGTiles tile $14, AnimateWaterTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, TileAnimationPalette
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset45Anim:
Tileset55Anim:
	dw vBGTiles tile $06, AnimateTunodWaterTiles
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset14Anim:
	dw vBGTiles tile $38, SafariFountainAnim2
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $5b, SafariFountainAnim1
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset33Anim:
	dw vBGTiles tile $02, SafariFountainAnim2
	dw NULL, MagmaPaletteAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $03, SafariFountainAnim1
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset24Anim:
Tileset21Anim:
Tileset48Anim:
Tileset49Anim:
Tileset50Anim:
Tileset51Anim:
Tileset52Anim:
Tileset53Anim:
	dw vBGTiles tile $14, WriteTileToBuffer
	dw NULL, FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileRightLeft
	dw NULL, FlickeringCaveEntrancePalette
	dw vBGTiles tile $14, WriteTileFromBuffer
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, TileAnimationPalette
	dw NULL, FlickeringCaveEntrancePalette
	dw vBGTiles tile $40, WriteTileToBuffer
	dw NULL, FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileDown
	dw NULL, FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileDown
	dw NULL, FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileDown
	dw NULL, FlickeringCaveEntrancePalette
	dw vBGTiles tile $40, WriteTileFromBuffer
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, DoneTileAnimation

Tileset17Anim:
	dw vBGTiles tile $2e, AnimateMeterTile
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $2f, AnimateWaterTile
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $4f, AnimateLightWaterTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset19Anim:
	dw vBGTiles tile $13, AnimateLightWaterTile
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset42Anim:
	dw vBGTiles tile $14, AnimateWaterTile
	dw vBGTiles tile $02, WriteTileToBuffer
	dw wTileAnimBuffer, ScrollTileDown
	dw vBGTiles tile $02, WriteTileFromBuffer
	dw vBGTiles tile $03, WriteTileToBuffer
	dw wTileAnimBuffer, ScrollTileUp
	dw vBGTiles tile $03, WriteTileFromBuffer
	dw NULL, WaitTileAnimation
	dw vBGTiles tile $12, WriteTileToBuffer
	dw wTileAnimBuffer, ScrollTileLeft
	dw vBGTiles tile $12, WriteTileFromBuffer
	dw vBGTiles tile $13, WriteTileToBuffer
	dw wTileAnimBuffer, ScrollTileRight
	dw vBGTiles tile $13, WriteTileFromBuffer
	dw NULL, StandingTileFrame8
	dw NULL, DoneTileAnimation

Tileset27Anim:
	dw vBGTiles tile $14, WriteTileToBuffer
	dw NULL, FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileRightLeft
	dw NULL, FlickeringCaveEntrancePalette
	dw vBGTiles tile $14, WriteTileFromBuffer
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, TileAnimationPalette
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, WaitTileAnimation
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, WaitTileAnimation
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, WaitTileAnimation
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, WaitTileAnimation
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, WaitTileAnimation
	dw NULL, FlickeringCaveEntrancePalette
	dw NULL, DoneTileAnimation

Tileset30Anim:
Tileset04Anim:
Tileset05Anim:
Tileset06Anim:
Tileset07Anim:
Tileset10Anim:
Tileset11Anim:
Tileset12Anim:
Tileset13Anim:
Tileset16Anim:
Tileset18Anim:
Tileset20Anim:
Tileset22Anim:
Tileset26Anim:
Tileset32Anim:
Tileset36Anim:
Tileset37Anim:
Tileset38Anim:
Tileset39Anim:
Tileset40Anim:
Tileset41Anim:
Tileset43Anim:
Tileset46Anim:
Tileset25Anim:
Tileset15Anim:
Tileset29Anim:
Tileset23Anim:
Tileset09Anim:
Tileset47Anim:
Tileset54Anim:
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, WaitTileAnimation
	dw NULL, DoneTileAnimation

DoneTileAnimation:
; Reset the animation command loop.
	xor a
	ldh [hTileAnimFrame], a
	; fallthrough

WaitTileAnimation:
; Do nothing this frame.
	ret

StandingTileFrame8:
	ld a, [wTileAnimationTimer]
	inc a
	and 7
	ld [wTileAnimationTimer], a
	ret

ScrollTileRightLeft:
; Scroll right for 4 ticks, then left for 4 ticks.
	ld a, [wTileAnimationTimer]
	inc a
	and 7
	ld [wTileAnimationTimer], a
	and 4
	jr z, ScrollTileRight
	; fallthrough

ScrollTileLeft:
	ld h, d
	ld l, e
	ld c, 4
.loop
	rept 4
	ld a, [hl]
	rlca
	ld [hli], a
	endr
	dec c
	jr nz, .loop
	ret

ScrollTileRight:
	ld h, d
	ld l, e
	ld c, 4
.loop
	rept 4
	ld a, [hl]
	rrca
	ld [hli], a
	endr
	dec c
	jr nz, .loop
	ret

ScrollTileUpDown:
; Scroll up for 4 ticks, then down for 4 ticks.
	ld a, [wTileAnimationTimer]
	inc a
	and 7
	ld [wTileAnimationTimer], a
	and 4
	jr nz, ScrollTileDown
	; fallthrough

ScrollTileUp:
	ld h, d
	ld l, e
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld bc, $e
	add hl, bc
	ld a, 4
.loop
	ld c, [hl]
	ld [hl], e
	dec hl
	ld b, [hl]
	ld [hl], d
	dec hl
	ld e, [hl]
	ld [hl], c
	dec hl
	ld d, [hl]
	ld [hl], b
	dec hl
	dec a
	jr nz, .loop
	ret

ScrollTileDown:
	ld h, d
	ld l, e
	ld de, $e
	push hl
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	pop hl
	ld a, 4
.loop
	ld b, [hl]
	ld [hl], d
	inc hl
	ld c, [hl]
	ld [hl], e
	inc hl
	ld d, [hl]
	ld [hl], b
	inc hl
	ld e, [hl]
	ld [hl], c
	inc hl
	dec a
	jr nz, .loop
	ret

AnimateFountain:
	ld hl, .frames
	ld a, [wTileAnimationTimer]
	and 7
	add a
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp WriteTile

.frames
	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame1

.frame1 INCBIN "gfx/tilesets/fountain/1.2bpp"
.frame2 INCBIN "gfx/tilesets/fountain/2.2bpp"
.frame3 INCBIN "gfx/tilesets/fountain/3.2bpp"
.frame4 INCBIN "gfx/tilesets/fountain/4.2bpp"
.frame5 INCBIN "gfx/tilesets/fountain/5.2bpp"

AnimateWaterTile:
; Draw a water tile for the current frame in VRAM tile at de.
	ld a, [wTileAnimationTimer]

; 4 tile graphics, updated every other frame.
	and 3 << 1

; 2 x 8 = 16 bytes per tile
	add a
	add a
	add a

	add LOW(WaterTileFrames)
	ld l, a
	adc HIGH(WaterTileFrames)
	sub l
	ld h, a

	jp WriteTile

WaterTileFrames: INCBIN "gfx/tilesets/animations/water.2bpp"

AnimateLightWaterTile:
; Draw a light water tile for the current frame in VRAM tile at de.
	ld a, [wTileAnimationTimer]

; 4 tile graphics, updated every other frame.
	and 3 << 1

; 2 x 8 = 16 bytes per tile
	add a
	add a
	add a

	add LOW(LightWaterTileFrames)
	ld l, a
	adc HIGH(LightWaterTileFrames)
	sub l
	ld h, a

	jp WriteTile

LightWaterTileFrames: INCBIN "gfx/tilesets/animations/light_water.2bpp"

AnimateTunodWaterTiles:
; Draw four Tunod water tiles for the current frame in VRAM tile at de.
	ld a, [wTileAnimationTimer]

; 8 graphics, updated every frame
	and %111 ; 8 frames

; 16 bytes per tile x 4 tiles per frame
	rrca
	rrca
	ld b, a
	and %11000000
	ld c, a
	ld a, b
	and %00000001
	ld b, a

	ld hl, TunodWaterTileFrames
	add hl, bc

	jp WriteFourTiles

TunodWaterTileFrames: INCBIN "gfx/tilesets/animations/tunod-water.2bpp"

AnimateMeterTile:
; Draw a meter tile for the current frame in VRAM tile at de.
	ld a, [wTileAnimationTimer]

; 4 tile graphics, updated every other frame.
	and 3 << 1

; 2 x 8 = 16 bytes per tile
	add a
	add a
	add a

	add LOW(MeterTileFrames)
	ld l, a
	adc HIGH(MeterTileFrames)
	sub l
	ld h, a

	jp WriteTile

MeterTileFrames: INCBIN "gfx/tilesets/animations/meter.2bpp"

AnimateFlowerTile:
; No parameters.

; Alternate tile graphic every other frame
	ld a, [wTileAnimationTimer]
	and 1 << 1
	inc a
	swap a ; << 4 (16 bytes)

	add LOW(FlowerTileFrames)
	ld l, a
	adc HIGH(FlowerTileFrames)
	sub l
	ld h, a

	jp WriteTile

FlowerTileFrames:
	INCBIN "gfx/tilesets/flower/dmg_1.2bpp"
	INCBIN "gfx/tilesets/flower/cgb_1.2bpp"
	INCBIN "gfx/tilesets/flower/dmg_2.2bpp"
	INCBIN "gfx/tilesets/flower/cgb_2.2bpp"

SafariFountainAnim1:
; Splash in the bottom-right corner of the fountain.
	ld a, [wTileAnimationTimer]

; 4 tile graphics, updated every other frame.
	and 3 << 1
	srl a
	inc a
	inc a
	and 3
	swap a ; << 4 (16 bytes)

	add LOW(SafariFountainFrames)
	ld l, a
	adc HIGH(SafariFountainFrames)
	sub l
	ld h, a

	jp WriteTile

SafariFountainAnim2:
; Splash in the top-left corner of the fountain.
	ld a, [wTileAnimationTimer]

; 4 tile graphics, updated every other frame.
	and 3 << 1

; 2 x 8 = 16 bytes per tile
	add a
	add a
	add a

	add LOW(SafariFountainFrames)
	ld l, a
	adc HIGH(SafariFountainFrames)
	sub l
	ld h, a

	jp WriteTile

SafariFountainFrames:
	INCBIN "gfx/tilesets/safari/1.2bpp"
	INCBIN "gfx/tilesets/safari/2.2bpp"
	INCBIN "gfx/tilesets/safari/3.2bpp"
	INCBIN "gfx/tilesets/safari/4.2bpp"

StandingTileFrame:
	ld hl, wTileAnimationTimer
	inc [hl]
	ret

AnimateWhirlpoolTile:
; Update whirlpool tile using struct at de.

; Struct:
; 	VRAM address
; 	Address of the first tile

; Only does one of 4 tiles at a time.

; de = VRAM address
	ld h, d
	ld l, e
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
; Tile address is now at hl.

; Get the tile for this frame.
	ld a, [wTileAnimationTimer]
	and %11 ; 4 frames x2
	swap a  ; * 16 bytes per tile

	add [hl]
	inc hl
	ld h, [hl]
	ld l, a
	jp nc, WriteTile
	inc h
	jp WriteTile

WriteTileFromBuffer_Bank1: ; unused
	call SafeStackCallInVBK1
WriteTileFromBuffer:
; Write tiledata at wTileAnimBuffer to de.
	ld hl, wTileAnimBuffer
	jp WriteTile

WriteTileToBuffer_Bank1: ; unused
	call SafeStackCallInVBK1
WriteTileToBuffer:
; Write tiledata de to wTileAnimBuffer.
	ld h, d
	ld l, e

	ld de, wTileAnimBuffer
	jp WriteTile

WriteFourTiles:
rept 16
	ld a, [hli]
	ld [de], a
	inc e
endr
; fallthrough
WriteThreeTiles:
rept 16
	ld a, [hli]
	ld [de], a
	inc e
endr
; fallthrough
WriteTwoTiles:
rept 16
	ld a, [hli]
	ld [de], a
	inc e
endr
; fallthrough
WriteTile:
; Write one 8x8 tile ($10 bytes) from hl to de.
; double speed allows us to do a simple unrolled 16 byte copy
; abusing inc e for speed
rept 15
	ld a, [hli]
	ld [de], a
	inc e
endr
	ld a, [hl]
	ld [de], a
	ret

TileAnimationPalette:
; Transition between color values 0-2 for color 0 in palette 3.

; We don't want to mess with non-standard palettes.
	ldh a, [rBGP] ; BGP
	cp %11100100
	ret nz

; Only update on even frames.
	ld a, [wTileAnimationTimer]
	ld e, a
	rra ; odd
	ret c

; Ready for BGPD input...
	ld a, $80 | (3 palettes)
	ldh [rBGPI], a

	ld a, BANK(wOriginalBGPals)
	call SafeStackCallInWramBankA

; Update color 0 in order 0 1 2 1

	ld a, e
	and %110 ; frames 0 2 4 6
	ld hl, wOriginalBGPals + 3 palettes
	jr z, ApplyTilesetAnimation_SingleColor
	and 2
	xor 2
	add 2
	add l
	ld l, a
	jr ApplyTilesetAnimation_SingleColor

MagmaPaletteAnimation:
; We don't want to mess with non-standard palettes.
	ldh a, [rBGP]
	cp %11100100
	ret nz

	ld a, BANK(wOriginalBGPals)
	call SafeStackCallInWramBankA

; Ready for BGPD input...
	ld a, $80 | (1 palettes + 4) ; auto-increment, pal 1 color 2
	ldh [rBGPI], a
	ld a, [wTileAnimationTimer]
	ld c, a
	cp 5
	jr c, .skip
	ld a, 8
	sub c
	ld c, a
.skip
	ld b, 0
	ld hl, .colors
	add hl, bc
	add hl, bc
	push hl
	call ApplyTilesetAnimation_SingleColor
	pop hl
	ld a, [hli]
	ld [wOriginalBGPals + 1 palettes + 4], a
	ld a, [hl]
	ld [wOriginalBGPals + 1 palettes + 5], a
	ret

.colors
	RGB 18, 04, 00
	RGB 19, 04, 00
	RGB 22, 04, 00
	RGB 25, 05, 00
	RGB 26, 05, 00

FlickeringCaveEntrancePalette:
; We don't want to mess with non-standard palettes.
	ldh a, [rBGP]
	cp %11100100
	ret nz
; We only want to be here if we're in a dark cave.
	ld a, [wTimeOfDayPalset]
	cp $ff ; 3,3,3,3
	ret nz

	ld a, BANK(wOriginalBGPals)
	call SafeStackCallInWramBankA
; Ready for BGPD input...
	ld a, $80 | (4 palettes) ; auto-increment, index $20 (pal 4 color 0)
	ldh [rBGPI], a
	ldh a, [hVBlankCounter]
	and %00000010
	add 4 palettes
	ld l, a
	ld h, wOriginalBGPals >> 8
ApplyTilesetAnimation_SingleColor:
	ld a, [hli]
	ldh [rBGPD], a
	ld a, [hli]
	ldh [rBGPD], a
	ret

WhirlpoolFrames1: dw vBGTiles tile $20, WhirlpoolTiles1
WhirlpoolFrames2: dw vBGTiles tile $35, WhirlpoolTiles2

WhirlpoolTiles1: INCBIN "gfx/tilesets/whirlpool/1.2bpp"
WhirlpoolTiles2: INCBIN "gfx/tilesets/whirlpool/2.2bpp"
