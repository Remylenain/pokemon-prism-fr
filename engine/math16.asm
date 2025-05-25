_Multiply16::
	; calculates bc * de and stores the result in bcde (bc: high word, de: low word) and in hProduct
	; does not preserve af or hl
	xor a
	ld hl, hProduct
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	; fallthrough

_AddNTimes16::
	; calculates hProduct + bc * de, returns both in bcde (bc: high word, de: low word) and in hProduct
	; does not preserve af or hl; returns carry status for the addition
	ld hl, 0
	xor a ; zero, no carry
	push af
.loop
	srl d
	rr e
	jr nc, .next
	pop af
	ldh a, [hProduct + 3]
	add c
	ldh [hProduct + 3], a
	ldh a, [hProduct + 2]
	adc b
	ldh [hProduct + 2], a
	ldh a, [hProduct + 1]
	adc l
	ldh [hProduct + 1], a
	ldh a, [hProduct]
	adc h
	ldh [hProduct], a
	push af
.next
	sla c
	rl b
	rl l
	rl h
	ld a, e
	or d
	jr nz, .loop
	ld hl, hProduct
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	pop af
	ret

_Divide16::
	; calculates bc / de, stores quotient in de and remainder in bc
	; also stores quotient in hQuotient and remainder in hRemainder
	; does not preserve af or hl
	ld a, d
	and a
	jr z, .divisor_8_bit
	ld hl, 1
.initial_shift_loop
	bit 7, d
	jr nz, .main_division_loop
	sla e
	rl d
	sla l
	jr .initial_shift_loop
.main_division_loop
	ld a, c
	sub e
	ld a, b
	sbc d
	jr c, .remainder_smaller
	ld a, h
	add l
	ld h, a
	ld a, c
	sub e
	ld c, a
	ld a, b
	sbc d
	ld b, a
.remainder_smaller
	srl d
	rr e
	srl l
	jr nc, .main_division_loop
	ld e, h
	ld d, 0
	xor a
	ld hl, hDividend
	ld [hli], a
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], c
	ret
.divisor_8_bit
	ld a, e
	and a
	jr z, .division_by_zero
	ldh [hDivisor], a
	ld a, b
	ldh [hDividend], a
	ld a, c
	ldh [hDividend + 1], a
	ld b, 2
	predef Divide
	ld hl, hQuotient + 1
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld c, [hl]
	xor a
	ld [hli], a
	ld [hl], c
	ld b, 0
	ret

.division_by_zero
	ldh [hCrashSavedA], a
	ld a, 2
DivideByZero_Divide16::
	call Crash

DivideLong::
; divides 4-byte hDividend by 2-byte hDivisor
; stores quotient in 4-byte hLongQuotient (hDividend, hQuotient - 1, hProduct, etc) and remainder in 2-byte hRemainder
	push bc
	push de
	push hl
	ld hl, hDividend
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
	or l
	jp z, .division_by_zero
	push hl
	; clear quotient and remainder
	xor a
	ld hl, hLongQuotient
	rept 6
	ld [hli], a
	endr
	pop hl
	ld a, 32
	ldh [hLoopCounter], a
.loop
	sla e
	rl d
	rl c
	rl b
	ldh a, [hRemainder + 1]
	rla
	ldh [hRemainder + 1], a
	ldh a, [hRemainder]
	rla
	ldh [hRemainder], a
	jr c, .sub
	ldh a, [hRemainder + 1]
	sub l
	ldh a, [hRemainder]
	sbc h
	ccf
	jr nc, .done
.sub
	ldh a, [hRemainder + 1]
	sub l
	ldh [hRemainder + 1], a
	ldh a, [hRemainder]
	sbc h
	ldh [hRemainder], a
	scf
.done
	ldh a, [hLongQuotient + 3]
	rla
	ldh [hLongQuotient + 3], a
	ldh a, [hLongQuotient + 2]
	rla
	ldh [hLongQuotient + 2], a
	ldh a, [hLongQuotient + 1]
	rla
	ldh [hLongQuotient + 1], a
	ldh a, [hLongQuotient]
	rla
	ldh [hLongQuotient], a
	ldh a, [hLoopCounter]
	dec a
	ldh [hLoopCounter], a
	jr nz, .loop
	pop hl
	pop de
	pop bc
	ret
.division_by_zero
	ldh [hCrashSavedA], a
	ld a, 2
	pop hl
	pop de
	pop bc
DivideByZero_DivideLong::
	call Crash
