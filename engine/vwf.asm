_PlaceVWFString:
; place vwf string of de to hl with options b
	call SetupVWFBitMask
.loop
	call PlaceVWFChar_BitmaskSetup
	ret c
	call z, Place1pxSpace
	jr .loop

_PlaceVWFChar:
	call SetupVWFBitMask
PlaceVWFChar_BitmaskSetup:
	ld a, [de]
	inc de
	cp "@"
	jr nz, .notterminator
	scf
	ret

.notterminator
	cp "<LNBRK>"
	jp z, PlaceVWFChar_NewTile
	cp "< >"
	jp z, .hairspace
	cp " "
	jp z, PlaceVWFSpace
	cp $80
	jp c, PlaceVWFChar_RetWithNZSet
	push de
	push hl
	cp "o" ; $ae, first in VWFPosList2
	ld d, 0
	jr nc, .secondlist
	ld hl, VWFPosList1
	sub $80
	ld e, a
	add hl, de
	ld a, [hli]
	push hl
	ld e, a
	ld hl, VWF1
	jr .done
.secondlist
	cp "<PK>" ; $e1, first in VWFPosList3
	jr nc, .thirdlist
	ld hl, VWFPosList2
	sub "o"
	ld e, a
	add hl, de
	ld a, [hli]
	push hl
	ld e, a
	ld hl, VWF2
	jr .done
.thirdlist
	ld hl, VWFPosList3
	sub "<PK>"
	ld e, a
	add hl, de
	ld a, [hli]
	push hl
	ld e, a
	ld hl, VWF3
.done
	add hl, de
	ld a, l
	ldh [hPrintNum1], a
	ld a, h
	ldh [hPrintNum2], a
	pop hl
	ld a, [hl]
	sub e
	jr z, .invalid_2
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
	bit 3, b
	jr nz, .twobpp
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
	jr .drawdone
.twobpp
	ld a, [hl]
	or c
	xor c
	ld [hli], a
	ld a, [hl]
	or c
	xor c
	ld [hl], a
	sla d
	jr nc, .white
	dec hl
	bit 4, b
	jr z, .skip1
	ld a, [hl]
	or c
	ld [hl], a
.skip1
	inc hl
	bit 5, b
	jr z, .white
	ld a, [hl]
	or c
	ld [hl], a
.white
	inc hl
	dec e
	jr nz, .twobpp
.drawdone
	pop hl
	pop de
	call ShiftVWFBitMask
	pop af
	dec a
	jr nz, .drawloop
	pop de
.hairspace
	xor a
	ret
.invalid_2
	pop hl
	pop de

PlaceVWFChar_RetWithNZSet:
	ld a, 1
	and a
	ret

PlaceVWFChar_NewTile::
	ld a, c
	cp $40
	jr nz, .newtileloop
	ld a, b
	and $f8
	ld b, a
	ld c, $80
.newtileloop
	ld a, c
	cp $80
	jr z, PlaceVWFChar_RetWithNZSet
	call Place1pxSpace
	jr .newtileloop

PlaceVWFSpace:
	ld a, 4
.spaceloop
	push af
	call Place1pxSpace
	pop af
	dec a
	jr nz, .spaceloop
	jr PlaceVWFChar_RetWithNZSet

SetupVWFBitMask:
	ld a, b
	and 7
	inc a
	ld c, 0
	scf
.loop
	rr c
	dec a
	jr nz, .loop
	ret

Place1pxSpace:
	push hl
	push de
	ld d, 8
.loop2
	ld a, [hl]
	or c
	xor c
	ld [hli], a
	bit 3, b
	jr z, .onebpp
	ld a, [hl]
	or c
	xor c
	ld [hli], a
.onebpp
	dec d
	jr nz, .loop2
	pop de
	pop hl

ShiftVWFBitMask:
	ld a, b
	inc b
	rrc c
	ret nc
	and $f8
	ld b, a
	push de
	ld de, 8
	add hl, de
	bit 3, b
	jr z, .onebpp
	add hl, de
.onebpp
	pop de
	ret

VWFPosList1:
	;   0    1    2    3    4    5    6    7    8    9    a    b    c    d    e    f
	db   0,   7,  14,  21,  28,  35,  42,  49,  56,  61,  68,  75,  81,  88,  95, 102 ;80
	db 109, 116, 123, 130, 137, 144, 151, 158, 165, 172, 179, 183, 187, 189, 191, 194 ;90
	db 197, 202, 207, 212, 217, 222, 226, 231, 235, 236, 239, 243, 244, 249, 254      ;a0

VWFPosList2:
	;   0    1    2    3    4    5    6    7    8    9    a    b    c    d    e    f
	db                                                                         0,   5 ;a0
	db  10,  15,  20,  25,  29,  34,  39,  46,  53,  57,  62,  62,  68,  75,  82,  89 ;b0
	db  95,  95,  95,  95,  95,  95,  95,  98, 101, 104, 107, 110, 113, 116, 119, 122 ;c0
	db 125, 132, 136, 144, 152, 160, 167, 174, 181, 189, 196, 203, 208, 213, 220, 227 ;d0
	db 234, 236                                                                       ;e0

VWFPosList3:
	;   0    1    2    3    4    5    6    7    8    9    a    b    c    d    e    f
	db        0,   7,  14,  20,  20,  20,  28,  32,  34,  41,  48,  55,  60,  65,  72 ;e0
	db  79,  84,  89,  97, 104, 106, 111, 118, 124, 131, 138, 145, 152, 159, 166, 173 ;f0
	db 180

VWF1: INCBIN "gfx/font/vwf_1.1bpp"
VWF2: INCBIN "gfx/font/vwf_2.1bpp"
VWF3: INCBIN "gfx/font/vwf_3.1bpp"
