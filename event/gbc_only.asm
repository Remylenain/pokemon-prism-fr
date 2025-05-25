GBCOnlyScreen:
	ld de, MUSIC_NONE
	call PlayMusic

	call ClearTileMapNoDelay

	ld hl, GBCOnlyGFX
	call DecompressWRA6

	ld de, $d000
	ld hl, vBGTiles
	lb bc, BANK(GBCOnlyGFX), $71
	ld a, LOW(hRequested2bpp)
	call Get1or2bppDMG

	xor a
	ld de, .gfxposlentable
	call DrawGBCOnlyGFX

	call DrawGBCOnlyText
	ld de, $d800
	ld hl, vFontTiles
	lb bc, BANK(GBCOnlyGFX), $33
	ld a, LOW(hRequested1bpp)
	call Get1or2bppDMG

	ld a, $80
	ld de, .textposlentable
	call DrawGBCOnlyGFX

	xor a
	ldh [hVBlank], a
	call DMGCompatBGMapTransfer
	ld a, 7
	ldh [hVBlank], a
	call DelayFrame
	ld a, $1b
	ldh [rBGP], a
	ld b, 78

; better luck next time
.loop
	halt
	jr .loop

MACRO dwcoordb
	bigdw wTileMap + SCREEN_WIDTH * \2 + \1
	db \3
	ENDM

.gfxposlentable
	dwcoordb 10, 1,  2
	dwcoordb  1, 2, 18
	dwcoordb  1, 3, 18
	dwcoordb  1, 4, 18
	dwcoordb  2, 5, 17
	dwcoordb  2, 6,  8
	dwcoordb 12, 6,  6
	dwcoordb  3, 7, 15
	dwcoordb  5, 8, 11
	db -1

.textposlentable
	dwcoordb 8, 10,  4
	dwcoordb 2, 12, 17
	dwcoordb 1, 14, 18
	dwcoordb 4, 16, 12
	db -1

DrawGBCOnlyGFX:
	ld c, a
	ld a, [de]
	cp -1
	ret z
	inc de
	ld h, a
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld b, a
	ld a, c
.draw
	ld [hli], a
	inc a
	dec b
	jr nz, .draw
	jr DrawGBCOnlyGFX

DrawGBCOnlyText:
	lb bc, 0, $80
	ld de, .content
	ld hl, $d800
.loop
	call .char
	ret c
	jr nz, .loop
	callba Place1pxSpace
	jr .loop

.char
	ld a, [de]
	inc de
	cp -1
	jr nz, .notterminator
	scf
	ret
.notterminator
	cp -2
	jr z, .newtile
	push de
	push hl
	ld hl, .widthtable
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	push hl
	ld e, a
	ld hl, $d000 + $71 tiles
	add hl, de
	ld a, l
	ldh [hPrintNum1], a
	ld a, h
	ldh [hPrintNum2], a
	pop hl
	ld a, [hl]
	sub e
	pop hl
	push af
	ldh a, [hPrintNum1]
	ld e, a
	ldh a, [hPrintNum2]
	ld d, a
	pop af
.drawloop
	push af
	ld a, [de]
	inc de
	push de
	push hl
	ld d, a
	ld e, 8
.onebpp
	ld a, [hl]
	or c
	sla d
	jr c, .black
	xor c
.black
	ld [hli], a
	dec e
	jr nz, .onebpp
	pop hl
	pop de
	callba ShiftVWFBitMask
	pop af
	dec a
	jr nz, .drawloop
	pop de
	xor a
	ret

.newtile
	callba PlaceVWFChar_NewTile
	ld a, 1
	and a
	ret

.widthtable
	db  0, 4, 8,12,16,20,21,24, 26, 28     ; Whops!Ti g
	db 32,36,40,44,48,52,56,59, 63, 67     ; amekdnlyfr
	db 71,75,79,83,87,91,95,99,103,107,109 ; uwtGBCAvc.

.content
	db 0,1,2,2,3,4,5,-2                          ; Whoops!
	db 6,1,7,4,8,9,10,11,12,8,3,10,13,8,7,4,8    ; This game pak is
	db 14,12,4,7,9,15,12,14,8,2,15,16,17,-2      ; designed only
	db 8,18,2,19,8,20,4,12,8,21,7,22,1,8,22,1,12 ; for use with the
	db 8,23,10,11,12,8,24,2,17,8,25,2,16,2,19,-2 ; Game Boy Color
	db 10,15,14,8,23,10,11,12,8,24,2,17,8        ; and Game Boy
	db 26,14,27,10,15,28,12,29,-1                ; Advance.

; The last 7 tiles are VWF-packed 1bpp font
GBCOnlyGFX: INCBIN "gfx/crash/gbc_only.2bpp.lz"
