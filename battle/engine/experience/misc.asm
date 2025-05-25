BoostExp:
; Multiply experience by 1.5x
	push bc
; load experience value
	ldh a, [hProduct + 2]
	ld b, a
	ldh a, [hProduct + 3]
	ld c, a
; halve it
	srl b
	rr c
; add it back to the whole exp value
	add c
	ldh [hProduct + 3], a
	ldh a, [hProduct + 2]
	adc b
	ldh [hProduct + 2], a
	pop bc
	ret

HalveExp:
	push bc
	ldh a, [hProduct + 2]
	ld b, a
	ldh a, [hProduct + 3]
	ld c, a
; halve it
	srl b
	rr c
; load it back as the whole exp value
	ld a, c
	ldh [hProduct + 3], a
	ld a, b
	ldh [hProduct + 2], a
	pop bc
	ret

Text_PkmnGainedExpPoint:
	text_far Text_Gained
	start_asm
	ld hl, .not_boosted_text
	ld a, [wStringBuffer2 + 2] ; IsTradedMon
	and a
	ret z
	ld hl, .boosted_text
	ret

.boosted_text
	text_jump Text_ABoostedStringBuffer2ExpPoints

.not_boosted_text
	text_jump Text_StringBuffer2ExpPoints
