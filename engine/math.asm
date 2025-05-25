Multiply::
; Multiply hMultiplicand (3 bytes) by hMultiplier. Result in hProduct.
; All values are big endian.

; hMultiplier is one byte.
; performs dehl * a
	push hl
	push de
	push bc

	ldh a, [hMultiplicand]
	ld e, a
	ldh a, [hMultiplicand + 1]
	ld h, a
	ldh a, [hMultiplicand + 2]
	ld l, a

	xor a
	ld d, a
	ldh [hProduct], a
	ldh [hProduct + 1], a
	ldh [hProduct + 2], a
	ldh [hProduct + 3], a
	ldh a, [hMultiplier]
	and a
	jr z, .done
.loop
	rra
	jr nc, .next

	ld c, a ; store multiplier in c

	ldh a, [hProduct + 3]
	add l
	ldh [hProduct + 3], a
	ldh a, [hProduct + 2]
	adc h
	ldh [hProduct + 2], a
	ldh a, [hProduct + 1]
	adc e
	ldh [hProduct + 1], a
	ldh a, [hProduct]
	adc d
	ldh [hProduct], a

	ld a, c ; retrieve multiplier

.next
	add hl, hl
	rl e
	rl d
	and a
	jr nz, .loop
.done
	pop bc
	pop de
	pop hl
	ret

Divide::
; Divide hDividend length b (max 4 bytes) by hDivisor. Result in hQuotient.
; All values are big endian.
	ldh a, [hDivisor]
	and a
	jr z, .div0
	push hl
	push de
	push bc

	ldh a, [hDivisor]
	ld d, a
	ld c, LOW(hDividend)
	ld e, 0
	ld l, e
.byte_loop
	push bc
	ld b, 8
	ldh a, [c]
	ld h, a
	ld l, 0
.bit_loop
	sla h
	rl e
	ld a, e
	jr c, .carry
	cp d
	jr c, .skip
.carry
	sub d
	ld e, a
	inc l
.skip
	ld a, b
	cp 1
	jr z, .done
	sla l
	dec b
	jr .bit_loop
.done
	ld a, c
	add hMathBuffer - hDividend
	ld c, a
	ld a, l
	ldh [c], a
	pop bc
	inc c
	dec b
	jr nz, .byte_loop

	xor a
	ldh [hDividend], a
	ldh [hDividend + 1], a
	ldh [hDividend + 2], a
	ldh [hDividend + 3], a
	ld a, e
	ldh [hRemainder], a
	ld a, c
	sub LOW(hDividend)
	ld b, a
	ld a, c
	add hMathBuffer - hDividend - 1
	ld c, a
	ldh a, [c]
	ldh [hDividend + 3], a
	dec b
	jr z, .finished
	dec c
	ldh a, [c]
	ldh [hDividend + 2], a
	dec b
	jr z, .finished
	dec c
	ldh a, [c]
	ldh [hDividend + 1], a
	dec b
	jr z, .finished
	dec c
	ldh a, [c]
	ldh [hDividend], a
.finished
	pop bc
	pop de
	pop hl
	ret
.div0 ; OH SHI-
	di
	ldh [hCrashSavedA], a
	ld a, 2
DivideByZero_Divide::
	call Crash
