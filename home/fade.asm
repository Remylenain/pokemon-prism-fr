; Functions to fade the screen in and out.

FadeBGToLightestColor::
	ld de, wBGPals
	ld h, d
	ld l, e
	ld b, %1
	jr FadeInPals

FadeBGToDarkestColor::
	ld de, wBGPals + 6
	ld hl, wBGPals
	ld b, %1
	jr FadeInPals

FadeOBJToWhite::
	ld hl, wOBPals
	ld de, WhitePal
	ld b, %10
	jr FadeInPals

FadeOBJToDarkestColor::
	ld de, wOBPals + 6
	ld hl, wOBPals
	ld b, %10
	jr FadeInPals

FadeToLightestColor::
	ld de, wBGPals
	ld h, d
	ld l, e
	jr FadeBothPalsCommon

FadeToDarkestColor::
	ld de, wBGPals + 6
	ld hl, wBGPals
	jr FadeBothPalsCommon

FadeToWhite::
	ld de, WhitePal
	ld hl, wBGPals
FadeBothPalsCommon:
	ld b, %11

FadeInPals::
; Smoothly fade in pals to the colour offset at hl
; lower 7 bits of c = delay time per frame
; if bit 7 is set, delay every c counts
	ldh a, [rSVBK]
	push af
	wbk BANK(wBGPals)
	ld a, c
	ldh [hBuffer], a
	ld a, b
	ld b, 0
	push hl
	ld hl, wBGPalsBuffer2
	rra
	push af
	call c, .CopyPalColourToBuffer
	pop af
	rra
	call c, .CopyPalColourToBuffer
	pop hl
	ldh a, [hBuffer]
	ld c, a
	ld de, wBGPalsBuffer2
	callba RelativeFade
	pop af
	ldh [rSVBK], a
	ret

.CopyPalColourToBuffer:
	push de
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	ld e, a
	ld d, c

	ld a, 8 * 4
	ld c, a
	add b
	ld b, a
.loop
	ld a, d
	ld [hli], a
	ld a, e
	res 7, a
	ld [hli], a
	dec c
	jr nz, .loop
	pop de
	bit 7, d
	jr z, .nextPal
	ld a, 8 palettes
	add e
	ld e, a
	ret nc
	inc d
	ret
.nextPal
	inc de
	inc de
	ret

FadeOutBGPals::
	ld b, 8 * 4
	ld hl, wBGPals
	ld de, wOriginalBGPals
	jr FadeOutPals_Common

FadeOutOBJPals::
	ld b, 8 * 4
	ld hl, wOBPals
	ld de, wOriginalOBJPals
	jr FadeOutPals_Common

FadeOutPals::
	ld b, 16 * 4
	ld hl, wBGPals
	ld de, wOriginalBGPals

FadeOutPals_Common::
; Rotate palettes to the left and fill with loaded colors from the right
; If we're already at the rightmost color, fill with the rightmost color
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	callba RelativeFade
	pop af
	ldh [rSVBK], a
	ret

WhitePal:
	RGB 31, 31, 31
	RGB 31, 31, 31
