LoadLCDCode::
	di
	ld hl, LCDCode
	ld de, wLCD
	ld bc, LCDCodeEnd - LCDCode
	rst CopyBytes
	reti

LCDCode::
	push af
	ld a, [wLCDCPointer]
	and a
	jr z, .skip

; At this point it's assumed we're in WRAM bank 5!
	push hl
	ldh a, [rLY]
	ld l, a
	ld h, HIGH(wLYOverrides)
	ld a, [hl]
	db $e0 ;ldh [imm8], a
.pointer
	assert (.pointer - LCDCode) == 15 ;wLCDCPointer is wLCD + 15
	db $00 ;gets overwritten with wLCDCPointer
	pop hl
.skip
	pop af
	reti
LCDCodeEnd::

LCD_VSTrick::
	push af
	ld a, [wLYOverrides]
	ldh [rSCX], a
	pop af
	reti
LCD_VSTrickEnd::

LCD_LeaderPal::
	push af
	push hl
	ld a, $92
	ldh [rBGPI], a
	ld a, $82
	ldh [rOBPI], a
	ldh a, [hPalTrick]
	add LOW(wTrainerCardLeaderPals)
	ld l, a
	adc HIGH(wTrainerCardLeaderPals)
	sub l
	ld h, a
.waitnohb
	ldh a, [rSTAT]
	and 3
	jr z, .waitnohb
.waithb
	ldh a, [rSTAT]
	and 3
	jr nz, .waithb
	rept 4
	ld a, [hli]
	ldh [rBGPD], a
	endr
	xor a
	ldh [rBGPD], a
	ldh [rBGPD], a
	dec a
	ldh [rBGPD], a
	ldh [rBGPD], a
	ld a, l
	and $f
	jr nz, .waitnohb
	ld a, wTrainerCardBadgePals - wTrainerCardLeaderPals - 16
	add l
	ld l, a
	adc h
	sub l
	ld h, a
.waitnohb2
	ldh a, [rSTAT]
	and 3
	jr z, .waitnohb2
.waithb2
	ldh a, [rSTAT]
	and 3
	jr nz, .waithb2
	rept 4
	ld a, [hli]
	ldh [rOBPD], a
	endr
	xor a
	ldh [rOBPD], a
	ldh [rOBPD], a
	dec a
	ldh [rOBPD], a
	ldh [rOBPD], a
	ld a, l
	and $f
	jr nz, .waitnohb2
	ldh a, [hPalTrick]
	add 16
	ldh [hPalTrick], a
	ldh a, [rLYC]
	add 24
	ldh [rLYC], a
	cp 135
	jr nz, .done
	xor a
	ldh [hPalTrick], a
	ld a, 15
	ldh [rLYC], a
.done
	pop hl
	pop af
	reti

DisableLCD::
; Turn the LCD off

; Don't need to do anything if the LCD is already off
	ldh a, [rLCDC]
	bit 7, a ; lcd enable
	ret z

	xor a
	ldh [rIF], a
	ldh a, [rIE]
	ld b, a

; Disable VBlank
	res 0, a ; vblank
	ldh [rIE], a

.wait
; Wait until VBlank would normally happen
	ldh a, [rLY]
	cp $90
	jr c, .wait
	cp $99
	jr z, .wait

	ldh a, [rLCDC]
	and %01111111 ; lcd enable off
	ldh [rLCDC], a

	xor a
	ldh [rIF], a
	ld a, b
	ldh [rIE], a
	ret

EnableLCD::
	ldh a, [rLCDC]
	set 7, a ; lcd enable
	ldh [rLCDC], a
	ret
