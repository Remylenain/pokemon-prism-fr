PrinterReceive::
; must be homecall
	ldh a, [hROMBank]
	push af
	rbk BANK(_PrinterReceive)
	call _PrinterReceive
	pop af
	jp Bankswitch

AskSerial::
; send out a handshake while serial int is off
	ld a, [wPrinterConnectionOpen]
	rra
	ret nc

	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz

; once every 6 frames
	ld hl, wHandshakeFrameDelay
	inc [hl]
	ld a, [hl]
	cp 6
	ret c

	xor a
	ld [hl], a

	ld a, 12
	ld [wPrinterDataJumptableIndex], a

; handshake
	ld a, $88
	ldh [rSB], a

; switch to internal clock
	ld a, %00000001
	ldh [rSC], a

; start transfer
	ld a, %10000001
	ldh [rSC], a

	ret
