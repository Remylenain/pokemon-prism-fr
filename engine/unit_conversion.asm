ConvertDecimetersToFeetAndInches::
	; in: de: length in decimeters
	; out: d: feet, e: inches
	; for the record, 1" = 0.0254m, 1' = 12" = 0.3048m
	; the maximum acceptable value for de is 780, which converts to 255' 11"; returns carry if exceeded
	push bc
	push hl
	ld bc, 1000
	call Multiply16
	ld a, 127
	ldh [hDivisor], a
	ld b, 4
	predef Divide
	ld hl, hQuotient + 2
	bit 0, [hl]
	jr z, .quotient_OK
	inc [hl]
	rept 2
		jr nz, .quotient_OK
		dec hl
		inc [hl]
	endr
.quotient_OK
	ld a, 24
	ldh [hDivisor], a
	ld b, 4
	predef Divide
	ld hl, hQuotient
	ld a, [hli]
	or [hl]
	pop hl
	pop bc
	lb de, 255, 11
	add a, d ;sets carry iif a != 0
	ret c
	ldh a, [hQuotient + 2]
	ld d, a
	ldh a, [hRemainder]
	rra ;both carry and this value's last bit must be clear here, since the dividend was even
	ld e, a
	ret

ConvertKilogramsToPounds::
	; in: de: kilograms
	; out: de: pounds
	; this function is obviously equally good for converting tenths of kilograms into tenths of pounds
	; note that the pound avoirdupois is defined as 1 lb = 0.45359237 kg exactly. This value is just slightly annoying.
	; to get around this, we note that 45359237 = 6073 * 7469
	; returns carry if it overflows
	push bc
	push hl
	ld bc, 20000
	call Multiply16
	push bc
	ld bc, 10000
	call Multiply16
	ld hl, hProduct
	xor a
	ld [hli], a
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], c
	pop bc
	push de
	ld de, 10000
	call AddNTimes16
	ld a, HIGH(7469)
	ldh [hDivisor], a
	ld a, LOW(7469)
	ldh [hDivisor + 1], a
	predef DivideLong
	; note that it's impossible to get a result longer than 4 bytes here
	ld hl, hLongQuotient + 2
	pop de
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ld hl, hDividend + 1
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, HIGH(7469)
	ld [hli], a
	ld [hl], LOW(7469)
	predef DivideLong
	ld hl, hDividend
	ld a, b
	ld [hli], a
	ld [hl], c
	ld a, HIGH(6073)
	ldh [hDivisor], a
	ld a, LOW(6073)
	ldh [hDivisor + 1], a
	predef DivideLong
	; note that it's impossible to get a result longer than 3 bytes here
	ld hl, hLongQuotient + 3
	ld a, [hld]
	ld e, a
	ld a, [hld]
	ld d, a
	srl [hl]
	pop hl
	pop bc
	jr nz, .error
	rr d
	rr e
	ret nc
	inc de
	and a
	ret

.error
	ld de, $ffff
	scf
	ret
