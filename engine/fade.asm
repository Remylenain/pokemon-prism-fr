RelativeFade::
	ld a, b
	ld [wFadeColorsCount], a
	ldh [hLoopCounter], a
	ld a, 31
	bit 7, c
	res 7, c
	jr z, .regularDelay
	call SimpleDivide
	ld a, b
	jr .gotCount
.regularDelay
	call SimpleMultiply
.gotCount
	ld [wFadeCounter], a
	and a
	jp z, .division_by_zero
	push hl

; Unpack colors and calculate deltas
	ld a, LOW(wFadeTempColors)
	ldh [hPrintNum7], a
	ld a, HIGH(wFadeTempColors)
	ldh [hPrintNum8], a
.unpackLoop
	ld a, [hl]
	and $1f
	ld b, a
	ldh [hPrintNum1], a
	ld a, [de]
	and $1f
	sub b
	ldh [hPrintNum4], a
	ld a, [hli]
	ld c, a
	ld a, [hl]
	and 3
	rept 3
		sla c
		rla
	endr
	ld b, a
	ldh [hPrintNum2], a
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	and 3
	rept 3
		sla c
		rla
	endr
	sub b
	ldh [hPrintNum5], a
	ld a, [hli]
	srl a
	srl a
	and $1f
	ld b, a
	ldh [hPrintNum3], a
	ld a, [de]
	inc de
	srl a
	srl a
	and $1f
	sub b
	ldh [hPrintNum6], a

	push de
	push hl
	ldh a, [hPrintNum7]
	ld l, a
	ldh a, [hPrintNum8]
	ld h, a
	ld a, $80 ; rounding
	ld [hli], a
	ldh a, [hPrintNum1]
	ld [hli], a
	ld a, $80
	ld [hli], a
	ldh a, [hPrintNum2]
	ld [hli], a
	ld a, $80
	ld [hli], a
	ldh a, [hPrintNum3]
	ld [hli], a
	ld a, l
	ldh [hPrintNum7], a
	ld a, h
	ldh [hPrintNum8], a
	ld bc, wFadeDeltas - wFadeTempColors - 6
	add hl, bc
	ld a, [wFadeCounter]
	ld c, a
; Divide16 isn't an option here since it doesn't handle signed numbers
	ldh a, [hPrintNum4]
	call .divide
	ldh a, [hPrintNum5]
	call .divide
	ldh a, [hPrintNum6]
	call .divide
	pop hl
	pop de

	ldh a, [hLoopCounter]
	dec a
	ldh [hLoopCounter], a
	jp nz, .unpackLoop

	pop bc
.fadeLoop
	push bc
	ld de, wFadeTempColors
	ld hl, wFadeDeltas
	ld a, [wFadeColorsCount]
	ldh [hLoopCounter], a

.fadeLoop2
	push bc
	lb bc, 3, LOW(hPrintNum1)

.fadeLoop3
	ld a, [de]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [de]
	adc [hl]
	inc hl
	ld [de], a
	inc de
	ldh [c], a
	inc c
	dec b
	jr nz, .fadeLoop3

	ldh a, [hPrintNum3]
	rlca
	rlca
	ld b, a
	ldh a, [hPrintNum2]
	ld c, 0
	rept 3
		rra
		rr c
	endr
	or b
	ldh [hPrintNum2], a
	ldh a, [hPrintNum1]
	or c
	pop bc
	ld [bc], a
	inc bc
	ldh a, [hPrintNum2]
	ld [bc], a
	inc bc
	ldh a, [hLoopCounter]
	dec a
	ldh [hLoopCounter], a
	jr nz, .fadeLoop2

	pop bc
	ld a, 1
	ldh [hCGBPalUpdate], a
	call DelayFrame
	ld a, [wFadeCounter]
	dec a
	ld [wFadeCounter], a
	jr nz, .fadeLoop
	ret

.divide
; [hli] = (a << 8) / c
	push hl
	rlca
	rrca ; bit 7 -> carry
	ld l, a
	ld a, 0
	ld d, a
	ld e, a
	sbc a
	ld h, a
	ld b, 16

.divLoop
	sla l
	rla
	rl h
	rl e
	rl d
	bit 0, e
	jr nz, .neg
	sub c
	jr nc, .divDone
	dec h
	jr .divDone
.neg
	add c
	jr nc, .divDone
	inc h
.divDone
	dec b
	jr nz, .divLoop
	ld a, e
	cpl
	sub e
	ld e, a
	ld a, d
	cpl
	sbc d
	ld d, a
	bit 7, h
	jr z, .noRestore
	dec de
.noRestore
	pop hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ret

.division_by_zero
	ldh [hCrashSavedA], a
	ld a, 2
DivideByZero_RelativeFade::
	call Crash
