Cosine::
; Return d * cos(a) in hl
	add $10 ; 90 degrees

Sine::
; Return d * sin(a) in hl
; a is a signed 6-bit value.
	ld e, a
	jpba _Sine

GetDemoSine::
	push hl
	ld l, a
	ld h, HIGH(DemoSine)
	ldh a, [hROMBank]
	ldh [hBuffer], a
	ld a, BANK(DemoSine)
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	ld l, [hl]
	ldh a, [hBuffer]
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	ld a, l
	pop hl
	ret
