ClearBGPalettes::
	call ClearPalettes
	jr ApplyTilemapInVBlank

ApplyAttrAndTilemapInVBlank::
	ld a, 2
	ldh [hBGMapMode], a
	call Delay2

ApplyTilemapInVBlank::
; Tell VBlank to update BG Map
	ld a, 1
	ldh [hBGMapMode], a

; fallthrough
Delay2::
; delay 2 frames
	ld c, 2

DelayFrames::
; Wait c frames
	call DelayFrame
	dec c
	jr nz, DelayFrames
	ret

ApplyTilemap::
; Tell VBlank to update BG Map
	ld a, 1
	ldh [hBGMapMode], a
	ld a, [wSpriteUpdatesEnabled]
	and a
	ld b, 3
	jr nz, SafeCopyTilemapAtOnce
	ld b, 1 << 3 | 3

; fallthrough
SafeCopyTilemapAtOnce:
; copies the tile&attr map at once
; without any tearing
; input:
; b: 0 = no palette copy
;    1 = copy raw palettes
;    2 = set palettes and copy
;    3 = use whatever was in hCGBPalUpdate
; bit 2: if set, clear hOAMUpdate
; bit 3: if set, only update tilemap
	jpba _SafeCopyTilemapAtOnce

CopyTilemapAtOnce::
	jpba _CopyTilemapAtOnce

DelayFrame::
; Wait for one frame
	ldh a, [rLY]
	ldh [hDelayFrameLY], a
	ld a, 1
	ld [wVBlankOccurred], a

; Wait for the next VBlank, halting to conserve battery
.halt
	halt
	ld a, [wVBlankOccurred]
	and a
	jr nz, .halt
	ret
