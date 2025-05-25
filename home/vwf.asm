PlaceVWFString:
; place vwf string at de to hl with options b and tilecount c
; uses wDecompressScratch as scratch space
	call RunFunctionInWRA6

	bit 7, d
	jr nz, .sourceInRAM
	push hl
	ld hl, wDecompressScratch2
	call CopyName2
	pop hl
	ld de, wDecompressScratch2
.sourceInRAM
	push hl
	push bc
	ld a, h
	cp HIGH(SRAM_Begin)
	jr nc, .notInVRAM
	ld hl, wDecompressScratch
.notInVRAM
	ld a, c
	and a
	jr z, .skipBufferClear
	push bc
	push hl
	bit 3, b
	push af
	swap c
	ld a, $f
	and c
	ld b, a
	ld a, $f0
	and c
	ld c, a
	pop af
	jr nz, .is2bpp
	srl b
	rr c
.is2bpp
	xor a
	call ByteFill
	pop hl
	pop bc
.skipBufferClear
	callba _PlaceVWFString
	push hl
	ld hl, sp + 5
	ld a, [hld]
	cp HIGH(SRAM_Begin)
	jr nc, .done
	push bc
	ld d, a
	ld a, [hld]
	ld e, a
	ld a, [hld]
	ld b, a
	ld c, [hl]
	ld h, d
	ld l, e
	bit 3, b
	ld b, BANK(_PlaceVWFString)
	ld de, wDecompressScratch
	jr z, .get1bpp
	call Get2bpp
	jr .doneVCopy
.get1bpp
	call Get1bpp
.doneVCopy
	pop bc
.done
	pop hl
	add sp, 4
	ret
