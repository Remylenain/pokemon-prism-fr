Serial::
	push hl
	push de
	push bc
	push af

	ld a, [wPrinterConnectionOpen]
	bit 0, a
	jr nz, .printer

	ldh a, [hSerialConnectionStatus]
	inc a
	jr z, .connectionNotYetEstablished

	ldh a, [rSB]
	ldh [hSerialReceive], a

	ldh a, [hSerialSend]
	ldh [rSB], a

	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .done

; using external clock
	ld a, 0
	ldh [rSC], a ; pointless
	ld a, START_TRANSFER_EXTERNAL_CLOCK
	ldh [rSC], a
	jr .done

.connectionNotYetEstablished
	ldh a, [rSB]
	cp 1
	jr z, .continue
	cp USING_INTERNAL_CLOCK
	jr nz, .done

.continue
	ldh [hSerialReceive], a
	ldh [hSerialConnectionStatus], a
	cp USING_INTERNAL_CLOCK
	jr z, .usingInternalClock

; using external clock
	xor a
	ldh [rSB], a
	ld a, 3
	ldh [rDIV], a

.wait
	ldh a, [rDIV]
	bit 7, a
	jr nz, .wait

	ld a, 0
	ldh [rSC], a
	ld a, START_TRANSFER_EXTERNAL_CLOCK
	ldh [rSC], a
	jr .done

.printer
	call PrinterReceive
	jr .end

.usingInternalClock
	xor a
	ldh [rSB], a

.done
	ld a, 1
	ldh [hSerialReceivedNewData], a
	ld a, SERIAL_NO_DATA_BYTE
	ldh [hSerialSend], a

.end
	pop af
	pop bc
	pop de
	pop hl
	reti

; hl = send data
; de = receive data
; bc = length of data
Serial_ExchangeBytes::
	ld a, 1
	ldh [hSerialIgnoringInitialData], a
.loop
	ld a, [hl]
	ldh [hSerialSend], a
	call Serial_ExchangeByte
	push bc
	ld b, a
	inc hl
	ld a, 48
.wait
	dec a
	jr nz, .wait
	ldh a, [hSerialIgnoringInitialData]
	and a
	ld a, b
	pop bc
	jr z, .storeReceivedByte

	dec hl
	cp SERIAL_PREAMBLE_BYTE
	jr nz, .loop
	xor a
	ldh [hSerialIgnoringInitialData], a
	jr .loop

.storeReceivedByte
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

Serial_ExchangeByte::
	xor a
	ldh [hSerialReceivedNewData], a
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .loop
	ld a, 2
	ldh [rSC], a
	ld a, START_TRANSFER_INTERNAL_CLOCK
	ldh [rSC], a

.loop
	ldh a, [hSerialReceivedNewData]
	and a
	jr nz, .ok
	ldh a, [hSerialConnectionStatus]
	cp 1
	jr nz, .doNotIncrementTimeoutCounter
	call IsTimeoutCounterZero
	jr z, .doNotIncrementTimeoutCounter
	call .waitLoop15Iterations
	push hl
	ld hl, wLinkTimeoutFrames + 1
	inc [hl]
	jr nz, .noCarry
	dec hl
	inc [hl]

.noCarry
	pop hl
	call IsTimeoutCounterZero
	jr nz, .loop
	jp SetTimeoutCounterToFFFF

.doNotIncrementTimeoutCounter
	ldh a, [rIE]
	and (1 << SERIAL) | (1 << TIMER) | (1 << LCD_STAT) | (1 << VBLANK)
	cp (1 << SERIAL)
	jr nz, .loop
	ld a, [wcf5d]
	dec a
	ld [wcf5d], a
	jr nz, .loop
	ld a, [wcf5d + 1]
	dec a
	ld [wcf5d + 1], a
	jr nz, .loop
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .ok
	ld a, $ff
.wait
	dec a
	jr nz, .wait

.ok
	xor a
	ldh [hSerialReceivedNewData], a
	ldh a, [rIE]
	and (1 << SERIAL) | (1 << TIMER) | (1 << LCD_STAT) | (1 << VBLANK)
	sub (1 << SERIAL)
	jr nz, .skipReloadingTimeoutCounter2
	ld [wcf5d], a
	ld a, $50
	ld [wcf5d + 1], a

.skipReloadingTimeoutCounter2
	ldh a, [hSerialReceive]
	cp SERIAL_NO_DATA_BYTE
	ret nz
	call IsTimeoutCounterZero
	jr z, .done
	push hl
	ld hl, wLinkTimeoutFrames + 1
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, .noBorrow
	dec [hl]

.noBorrow
	pop hl
	call IsTimeoutCounterZero
	jr z, SetTimeoutCounterToFFFF

.done
	ldh a, [rIE]
and (1 << SERIAL) | (1 << TIMER) | (1 << LCD_STAT) | (1 << VBLANK)
	cp (1 << SERIAL)
	ld a, SERIAL_NO_DATA_BYTE
	ret z
	ld a, [hl]
	ldh [hSerialSend], a
	call DelayFrame
	jp Serial_ExchangeByte
.waitLoop15Iterations
	ld a, 15
.waitLoop
	dec a
	jr nz, .waitLoop
	ret

IsTimeoutCounterZero::
	push hl
	ld hl, wLinkTimeoutFrames
	ld a, [hli]
	or [hl]
	pop hl
	ret

; a is always 0 when this is called
SetTimeoutCounterToFFFF::
	dec a
	ld [wLinkTimeoutFrames], a
	ld [wLinkTimeoutFrames + 1], a
	ret

; This is used to exchange the button press and selected menu item on the link menu.
; The data is sent thrice and read twice to increase reliability.
Serial_ExchangeLinkMenuSelection::
	ld hl, wPlayerLinkAction
	ld de, wOtherPlayerLinkMode
	ld c, 2
	ld a, 1
	ldh [hSerialIgnoringInitialData], a
.loop
	call DelayFrame
	ld a, [hl]
	ldh [hSerialSend], a
	call Serial_ExchangeByte
	ld b, a
	inc hl
	ldh a, [hSerialIgnoringInitialData]
	and a
	ld a, 0
	ldh [hSerialIgnoringInitialData], a
	jr nz, .loop
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

Serial_PrintWaitingTextAndSyncAndExchangeNybble::
	call LoadTileMapToTempTileMap
	callba PlaceWaitingText
	call Serial_SyncAndExchangeNybble
	jp Call_LoadTempTileMapToTileMap

Serial_SyncAndExchangeNybble::
	ld a, $ff
	ld [wOtherPlayerLinkAction], a
.loop
	call LinkTransfer
	call DelayFrame
	call IsTimeoutCounterZero
	jr z, .check
	push hl
	ld hl, wLinkTimeoutFrames + 1
	dec [hl]
	jr nz, .skip
	dec hl
	dec [hl]
	jr nz, .skip
	pop hl
	xor a
	jp SetTimeoutCounterToFFFF

.skip
	pop hl

.check
	ld a, [wOtherPlayerLinkAction]
	inc a
	jr z, .loop

	ld b, 10
.receive
	call DelayFrame
	call LinkTransfer
	dec b
	jr nz, .receive

	ld b, 10
.acknowledge
	call DelayFrame
	call LinkDataReceived
	dec b
	jr nz, .acknowledge

	ld a, [wOtherPlayerLinkAction]
	ld [wOtherPlayerLinkMode], a
	ret

LinkTransfer::
	push bc
	ld b, SERIAL_TIMECAPSULE
	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	jr z, .got_high_nybble
	ld b, SERIAL_TIMECAPSULE
	jr c, .got_high_nybble
	cp LINK_TRADECENTER
	ld b, SERIAL_TRADECENTER
	jr z, .got_high_nybble
	ld b, SERIAL_BATTLE

.got_high_nybble
	call .Receive
	ld a, [wPlayerLinkAction]
	add b
	ldh [hSerialSend], a
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .internalClock
	ld a, 1
	ldh [rSC], a
	ld a, START_TRANSFER_INTERNAL_CLOCK
	ldh [rSC], a

.internalClock
	call .Receive
	pop bc
	ret

.Receive
	ldh a, [hSerialReceive]
	ld [wOtherPlayerLinkMode], a
	and $f0
	cp b
	ret nz
	xor a
	ldh [hSerialReceive], a
	ld a, [wOtherPlayerLinkMode]
	and $f
	ld [wOtherPlayerLinkAction], a
	ret

LinkDataReceived::
; Let the other system know that the data has been received.
	xor a
	ldh [hSerialSend], a
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	ret nz
	ld a, 1
	ldh [rSC], a
	ld a, START_TRANSFER_INTERNAL_CLOCK
	ldh [rSC], a
	ret
