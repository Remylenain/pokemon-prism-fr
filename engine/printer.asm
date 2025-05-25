InitializePrinterData:
	ld hl, wOverworldMap
	ld bc, $40c
	xor a
	ldh [rSB], a
	ldh [rSC], a
	ld [wPrinterDataJumptableIndex], a
	call ByteFill
	ld hl, wPrinterConnectionOpen
	set 0, [hl]
	ld a, [wGBPrinter]
	and 7
	ld c, a
	ld b, 0
	ld hl, .GBPrinterBrightnessConversionTable
	add hl, bc
	ld a, [hl]
	ld [wPrinterBrightness], a
	xor a
	ld [wJumptableIndex], a
	ret

.GBPrinterBrightnessConversionTable:
	db PRINT_LIGHTEST
	db PRINT_LIGHTER
	db PRINT_NORMAL
	db PRINT_DARKER
	db PRINT_DARKEST

PrinterFunctionJumptable:
	dw Printer_InitPrinterHandshake
	dw Printer_CheckConnectionStatus
	dw Printer_WaitSerial
	dw Printer_StartTransmittingTilemap
	dw Printer_TransmissionLoop
	dw Printer_WaitSerialAndLoopBack2
	dw Printer_EndTilemapTransmission
	dw Printer_TransmissionLoop
	dw Printer_WaitSerial
	dw Printer_SignalSendHeader
	dw Printer_TransmissionLoop
	dw Printer_WaitSerial
	dw Printer_WaitUntilFinished
	dw Printer_Quit
	dw Printer_IncrementJumptableIndex
	dw Printer_WaitSerial
	dw Printer_SignalLoopBack
	dw Printer_SetJumptableIndexToOne
	dw Printer_PrepareWaitLoopBack
	dw Printer_WaitLoopBack

Printer_TransmissionLoop:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f0
	jr z, .printer_OK
	ld a, 18
	ld [wJumptableIndex], a
	ret

.printer_OK
	ld a, [wPrinterStatusFlags]
	and 1
	jr nz, Printer_DecrementJumptableIndex
	; fallthrough

Printer_IncrementJumptableIndex:
	ld hl, wJumptableIndex
	inc [hl]
	ret

Printer_DecrementJumptableIndex:
	ld hl, wJumptableIndex
	dec [hl]
	ret

Printer_Quit:
	xor a
	ld [wPrinterStatusFlags], a
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

Printer_SetJumptableIndexToOne:
	ld a, 1
	ld [wJumptableIndex], a
	ret

Printer_InitPrinterHandshake:
	call Printer_ResetData
	ld hl, PrinterDataPacket_Handshake
	call Printer_CopyPacket
	xor a
	ld [wPrinterSendByteCounter], a
	ld [wPrinterSendByteCounter + 1], a
	ld a, [wPrinterQueueLength]
	ld [wPrinterRowIndex], a
	call Printer_IncrementJumptableIndex
	call Printer_WaitHandshake
	ld a, 1 ; checking
	ld [wPrinterStatus], a
	ret

Printer_StartTransmittingTilemap:
	call Printer_ResetData
	ld hl, wPrinterRowIndex
	ld a, [hl]
	and a
	jr z, Printer_EndTilemapTransmission
	ld hl, PrinterDataPacket_StartTransmission
	call Printer_CopyPacket
	call Printer_ConvertTwoRowsTo2bpp
	ld a, LOW(40 tiles)
	ld [wPrinterSendByteCounter], a
	ld a, HIGH(40 tiles)
	ld [wPrinterSendByteCounter + 1], a
	call Printer_ComputeChecksum
	call Printer_IncrementJumptableIndex
	call Printer_WaitHandshake
	ld a, 2 ; transmitting
	ld [wPrinterStatus], a
	ret

Printer_EndTilemapTransmission:
	ld a, 6
	ld [wJumptableIndex], a
	ld hl, PrinterDataPacket_NoTransmission
	call Printer_CopyPacket
	xor a
	ld [wPrinterSendByteCounter], a
	ld [wPrinterSendByteCounter + 1], a
	call Printer_IncrementJumptableIndex
	jp Printer_WaitHandshake

Printer_SignalSendHeader:
	call Printer_ResetData
	ld hl, PrinterDataPacket_RequestPrint
	call Printer_CopyPacket
	call Printer_StageHeaderForSending
	ld a, 4
	ld [wPrinterSendByteCounter], a
	xor a
	ld [wPrinterSendByteCounter + 1], a
	call Printer_ComputeChecksum
	call Printer_IncrementJumptableIndex
	call Printer_WaitHandshake
	ld a, 3 ; printing
	ld [wPrinterStatus], a
	ret

Printer_SignalLoopBack:
	call Printer_ResetData
	ld hl, PrinterDataPacket_Handshake
	call Printer_CopyPacket
	xor a
	ld [wPrinterSendByteCounter], a
	ld [wPrinterSendByteCounter + 1], a
	ld a, [wPrinterQueueLength]
	ld [wPrinterRowIndex], a
	call Printer_IncrementJumptableIndex
	jp Printer_WaitHandshake

Printer_WaitSerial:
	ld hl, wPrinterSerialFrameDelay
	inc [hl]
	ld a, [hl]
	cp 6
	ret c
	xor a
	ld [hl], a
	jp Printer_IncrementJumptableIndex

Printer_WaitSerialAndLoopBack2:
	ld hl, wPrinterSerialFrameDelay
	inc [hl]
	ld a, [hl]
	cp 6
	ret c
	xor a
	ld [hl], a
	ld hl, wPrinterRowIndex
	dec [hl]
	call Printer_DecrementJumptableIndex
	jp Printer_DecrementJumptableIndex

Printer_CheckConnectionStatus:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterHandshake]
	inc a
	jr nz, .printer_connected
	ld a, [wPrinterStatusFlags]
	inc a
	jr z, .printer_error

.printer_connected
	ld a, [wPrinterHandshake]
	cp $81
	jr nz, .printer_error
	ld a, [wPrinterStatusFlags]
	and a
	jr nz, .printer_error
	ld hl, wPrinterConnectionOpen
	set 1, [hl]
	ld a, 5
	ld [wHandshakeFrameDelay], a
	jp Printer_IncrementJumptableIndex

.printer_error
	ld a, $ff
	ld [wPrinterHandshake], a
	ld [wPrinterStatusFlags], a
	ld a, 14
	ld [wJumptableIndex], a
	ret

Printer_WaitUntilFinished:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f3
	ret nz
	jp Printer_IncrementJumptableIndex

Printer_PrepareWaitLoopBack:
	call Printer_IncrementJumptableIndex
	; fallthrough
Printer_WaitLoopBack:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterStatusFlags]
	and $f0
	ret nz
	xor a
	ld [wJumptableIndex], a
	ret

Printer_WaitHandshake:
	ld a, [wPrinterDataJumptableIndex]
	and a
	jr nz, Printer_WaitHandshake
	xor a
	ld [wPrinterSendByteOffset], a
	ld [wPrinterSendByteOffset + 1], a
	inc a
	ld [wPrinterDataJumptableIndex], a
	ldh [rSC], a
	ld a, $88
	ldh [rSB], a
	ld a, $81
	ldh [rSC], a
	ret

Printer_CopyPacket:
	ld de, wPrinterData
	ld bc, 6
	rst CopyBytes
	ret

Printer_ResetData:
	xor a
	ld hl, wPrinterData
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wPrinterSendByteCounter], a
	ld [wPrinterSendByteCounter + 1], a
	ld hl, wOverworldMap
	ld bc, $280
	jp ByteFill

Printer_ComputeChecksum:
	ld bc, 4
	ld h, b
	ld l, b
	ld de, wPrinterData
	call .calculate
	ld a, [wPrinterSendByteCounter]
	ld c, a
	ld a, [wPrinterSendByteCounter + 1]
	ld b, a
	ld de, wOverworldMap
	call .calculate
	ld a, l
	ld [wPrinterChecksum], a
	ld a, h
	ld [wPrinterChecksum + 1], a
	ret

.calculate
	ld a, [de]
	inc de
	add a, l
	ld l, a
	adc h
	sub a, l
	ld h, a
	dec bc
	ld a, c
	or b
	jr nz, .calculate
	ret

Printer_StageHeaderForSending:
	ld a, 1
	ld [wOverworldMap], a
	ld a, [wcbfa]
	ld [wOverworldMap + 1], a
	ld a, %11100100
	ld [wOverworldMap + 2], a
	ld a, [wPrinterBrightness]
	ld [wOverworldMap + 3], a
	ret

Printer_ConvertTwoRowsTo2bpp:
	ld hl, wPrinterRowIndex
	ld a, [wPrinterQueueLength]
	sub [hl]
	ld hl, wPrinterTilemap
	ld bc, 2 * SCREEN_WIDTH
	rst AddNTimes
	ld e, l
	ld d, h
	ld hl, wOverworldMap
	; c is still 2 * SCREEN_WIDTH
.loop
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	sub 8
	and $f
	add a, $88
	ld d, a
	ld c, 1
	call Request2bppSameBank
	pop hl
	ld de, $10
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .loop
	ret

PrinterDataPacket_Handshake:
	db 1, 0, $00, 0
	dw 1
PrinterDataPacket_RequestPrint:
	db 2, 0, $04, 0
	dw 0
PrinterDataPacket_StartTransmission:
	db 4, 0, $80, 2
	dw 0
PrinterDataPacket_NoTransmission:
	db 4, 0, $00, 0
	dw 4

_PrinterReceive::
	ld a, [wPrinterDataJumptableIndex]
	jumptable

	dw GenericDummyFunction
	dw Printer_Send33
	dw Printer_SendPrinterDataByte1
	dw Printer_SendPrinterDataByte2
	dw Printer_SendPrinterDataByte3
	dw Printer_SendPrinterDataByte4
	dw Printer_SendNextByte
	dw Printer_SendPrinterDataChecksumLow
	dw Printer_SendPrinterDataChecksumHigh
	dw Printer_SendZero
	dw Printer_ReceiveHandshakeSendZero
	dw Printer_GetStatusAndStop
	dw Printer_Send33
	dw Printer_Send0F
	dw Printer_SendZero
	dw Printer_SendZero
	dw Printer_SendZero
	dw Printer_Send0F
	dw Printer_SendZero
	dw Printer_SendZero
	dw Printer_ReceiveHandshakeSendZero
	dw Printer_GetStatusAndStop
	dw Printer_Send33
	dw Printer_Send08
	dw Printer_SendZero
	dw Printer_SendZero
	dw Printer_SendZero
	dw Printer_Send08
	dw Printer_SendZero
	dw Printer_SendZero
	dw Printer_ReceiveHandshakeSendZero
	dw Printer_GetStatusAndStop

PrinterReceiveIncrementIndex:
	ld hl, wPrinterDataJumptableIndex
	inc [hl]
	ret

Printer_Send33:
	ld a, $33
	jr PrinterSendIncrement

Printer_SendPrinterDataByte1:
	ld a, [wPrinterData]
	jr PrinterSendIncrement

Printer_SendPrinterDataByte2:
	ld a, [wPrinterData + 1]
	jr PrinterSendIncrement

Printer_SendPrinterDataByte3:
	ld a, [wPrinterData + 2]
	jr PrinterSendIncrement

Printer_SendPrinterDataByte4:
	ld a, [wPrinterData + 3]
	jr PrinterSendIncrement

Printer_SendNextByte:
	ld hl, wPrinterSendByteCounter
	ld a, [hli]
	ld d, [hl]
	ld e, a
	or d
	jr z, .no_data
	dec de
	ld a, d
	ld [hld], a
	ld [hl], e
	ld hl, wPrinterSendByteOffset
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wOverworldMap
	add hl, de
	inc de
	ld a, e
	ld [wPrinterSendByteOffset], a
	ld a, d
	ld [wPrinterSendByteOffset + 1], a
	ld a, [hl]
	jr PrinterSendByte

.no_data
	call PrinterReceiveIncrementIndex
	; fallthrough

Printer_SendPrinterDataChecksumLow:
	ld a, [wPrinterChecksum]
	jr PrinterSendIncrement

Printer_SendPrinterDataChecksumHigh:
	ld a, [wPrinterChecksum + 1]
	jr PrinterSendIncrement

Printer_ReceiveHandshakeSendZero:
	ldh a, [rSB]
	ld [wPrinterHandshake], a
Printer_SendZero:
	xor a
	jr PrinterSendIncrement

Printer_Send0F:
	ld a, $f
	jr PrinterSendIncrement

Printer_Send08:
	ld a, 8
PrinterSendIncrement:
	call PrinterSendByte
	jr PrinterReceiveIncrementIndex

PrinterSendByte:
	ldh [rSB], a
	ld a, 1
	ldh [rSC], a
	ld a, $81
	ldh [rSC], a
	ret

Printer_GetStatusAndStop:
	ldh a, [rSB]
	ld [wPrinterStatusFlags], a
	xor a
	ld [wPrinterDataJumptableIndex], a
	ret

Printer_ResetJoypadAndSendScreen:
	call Printer_ClearJoypad
	; fallthrough

Printer_SendScreen:
	call JoyTextDelay
	call Printer_CheckCancel
	ret c
	ld a, [wJumptableIndex]
	cp $80
	ret nc
	jumptable PrinterFunctionJumptable
	call CheckPrinterError
	call ShowPrinterStatus
	call DelayFrame
	jr Printer_SendScreen

ResetPrinterControlData:
	xor a
	ld [wPrinterConnectionOpen], a
	ld [wPrinterDataJumptableIndex], a
	ret

Printer_ExitAllMenus:
	call ReturnToMapFromSubmenu
	jp RestartMapMusic

PrintDexEntry:
	ld a, [wPrinterQueueLength]
	push af
	xor a
	ldh [hPrinter], a
	call PlayPrinterMusic
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, 9
	ldh [rIE], a
	call InitializePrinterData
	ld a, $10
	ld [wcbfa], a
	callba PrintPage1
	call ClearTileMap
	ld a, %11100100
	call DmgToCgbBGPals
	call DelayFrame
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], 4
	ld a, 8
	ld [wPrinterQueueLength], a
	call Printer_ClearJoypad
	call Printer_SendScreen
	jr c, .skip_second_page
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	xor a
	ldh [hBGMapMode], a
	call InitializePrinterData
	ld a, 3
	ld [wcbfa], a
	callba PrintPage2
	call Printer_ClearJoypad
	ld a, 4
	ld [wPrinterQueueLength], a
	call Printer_SendScreen

.skip_second_page
	pop af
	ldh [hVBlank], a
	call ResetPrinterControlData
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	call Printer_ExitAllMenus
	ld c, 8
.low_volume_wait
	call LowVolume
	call DelayFrame
	dec c
	jr nz, .low_volume_wait
	pop af
	ld [wPrinterQueueLength], a
	ret

PrintPCBox:
	ld a, [wPrinterQueueLength]
	push af
	ld a, 9
	ld [wPrinterQueueLength], a
	xor a
	ldh [hPrinter], a
	ld hl, wFinishedPrintingBox
	ld [hli], a
	; hl = wPrintedBoxAddress
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	; hl = wPrintedBoxBank
	ld a, b
	ld [hli], a
	; hl = wPrintedBoxNumber
	ld [hl], c
	call PlayPrinterMusic
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, 9
	ldh [rIE], a
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], 4

	ld a, $10
	ld [wcbfa], a
	ld hl, PrintPCBox_Page1
	call .print_page
	jr c, .cancel
	xor a
	ld [wcbfa], a
	ld hl, PrintPCBox_Page2
	call .clean_up_and_print
	jr c, .cancel
	xor a
	ld [wcbfa], a
	ld hl, PrintPCBox_Page3
	call .clean_up_and_print
	jr c, .cancel
	ld a, 3
	ld [wcbfa], a
	ld hl, PrintPCBox_Page4
	call .clean_up_and_print
.cancel
	pop af
	ldh [hVBlank], a
	call ResetPrinterControlData
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	call Printer_ExitAllMenus
	pop af
	ld [wPrinterQueueLength], a
	ret

.clean_up_and_print
	push hl
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	pop hl
.print_page
	xor a
	ldh [hBGMapMode], a
	call _hl_
	call Printer_PrepareTileMapForPrinting
	jp Printer_ResetJoypadAndSendScreen

PrintPartymon:
	ld a, [wPrinterQueueLength]
	push af
	xor a
	ldh [hPrinter], a
	call PlayPrinterMusic
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ldh [hBGMapMode], a
	ld a, 9
	ldh [rIE], a
	callba PrintMonInfo
	ld a, $10
	ld [wcbfa], a
	call Printer_PrepareTileMapForPrinting
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], 4
	ld a, 8
	ld [wPrinterQueueLength], a
	call Printer_ClearJoypad
	call Printer_SendScreen
	jr c, .cancel
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	xor a
	ldh [hBGMapMode], a
	callba PrintMonMovesAndStats
	ld a, 3
	ld [wcbfa], a
	call Printer_PrepareTileMapForPrinting
	ld a, 9
	ld [wPrinterQueueLength], a
	call Printer_ClearJoypad
	call Printer_SendScreen

.cancel
	pop af
	ldh [hVBlank], a
	call ResetPrinterControlData
	call CopyPrinterTilemapToTilemap
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	call Printer_ExitAllMenus
	pop af
	ld [wPrinterQueueLength], a
	ret

_PrintDiploma:
	ld a, [wPrinterQueueLength]
	push af
	callba ShowDiploma
	xor a
	ldh [hPrinter], a
	call PlayPrinterMusic
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, 9
	ldh [rIE], a
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], 4
	ld a, $10
	ld [wcbfa], a
	call Printer_PrepareTileMapForPrinting
	call Printer_ClearJoypad
	ld a, 9
	ld [wPrinterQueueLength], a
	call Printer_SendScreen
	jr c, .cancel
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	call LoadTileMapToTempTileMap
	xor a
	ldh [hBGMapMode], a
	callba PrintDiplomaPlayTimeAndSignature
	ld a, 3
	ld [wcbfa], a
	call Printer_PrepareTileMapForPrinting
	call Call_LoadTempTileMapToTileMap
	call Printer_ClearJoypad
	ld a, 9
	ld [wPrinterQueueLength], a
	call Printer_SendScreen

.cancel
	pop af
	ldh [hVBlank], a
	call ResetPrinterControlData
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	call Printer_ExitAllMenus
	pop af
	ld [wPrinterQueueLength], a
	ret

Printer_CheckCancel:
	ldh a, [hJoyDown]
	and B_BUTTON
	ret z
	ld a, [wca80]
	cp $c
	jr nz, .cancel
.wait_printer_ready_loop
	ld a, [wPrinterDataJumptableIndex]
	and a
	jr nz, .wait_printer_ready_loop
	ld a, 22
	ld [wPrinterDataJumptableIndex], a
	ld a, $88
	ldh [rSB], a
	ld a, 1
	ldh [rSC], a
	ld a, $81
	ldh [rSC], a
.wait_data_finished_sending_loop
	ld a, [wPrinterDataJumptableIndex]
	and a
	jr nz, .wait_data_finished_sending_loop

.cancel
	ld a, 1
	ldh [hPrinter], a
	scf
	ret

Printer_PrepareTileMapForPrinting:
	call InitializePrinterData
	coord hl, 0, 0
	ld de, wPrinterTilemap
Printer_DoCopyScreenTilemap:
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	rst CopyBytes
	ret

CopyPrinterTilemapToTilemap:
	ld hl, wPrinterTilemap
	coord de, 0, 0
	jr Printer_DoCopyScreenTilemap

Printer_ClearJoypad:
	xor a
	ldh [hJoyReleased], a
	ldh [hJoyPressed], a
	ldh [hJoyDown], a
	ldh [hJoyLast], a
	ret

PlayPrinterMusic:
	ld de, MUSIC_PRINTER
	jp PlayMusic2

CheckPrinterError:
	ld a, [wPrinterHandshake]
	inc a
	jr nz, .printer_connected
	ld a, [wPrinterStatusFlags]
	inc a
	jr z, .error_2

.printer_connected
	ld a, [wPrinterStatusFlags]
	and %11100000
	ret z ; no error

	add a, a
	jr c, .error_1
	add a, a
	ld a, 3
	adc a ; loads 6 (error 3) or 7 (error 4) depending on the carry flag
	jr .load_text_index

.error_1
	ld a, 4 ; error 1
	jr .load_text_index

.error_2
	ld a, 5 ; error 2

.load_text_index
	ld [wPrinterStatus], a
	ret

ShowPrinterStatus:
	ld a, [wPrinterStatus]
	and a
	ret z
	push af
	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 5
	lb bc, 10, 18
	call TextBox
	pop af
	add a, a
	ld e, a
	ld d, 0
	ld hl, PrinterStatusStringPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	hlcoord 1, 7
	ld a, BANK(GBPrinterStrings)
	call FarPlaceText
	hlcoord 2, 15
	ld de, .press_B_to_cancel
	call PlaceText
	xor a
	ld [wPrinterStatus], a
	inc a
	ldh [hBGMapMode], a
	ret

.press_B_to_cancel
	ctxt "Press B to Cancel"
	done

PrinterStatusStringPointers:
	dw String_Printer_Blank ; @
	dw String_Printer_CheckingLink
	dw String_Printer_Transmitting
	dw String_Printer_Printing
	dw String_Printer_Error1
	dw String_Printer_Error2
	dw String_Printer_Error3
	dw String_Printer_Error4

PrintPCBox_ClearScreenAndBoxList:
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	jp Printer_PlaceEmptyBoxSlotString

PrintPCBox_Page1:
	xor a
	ld [wPrintedBoxMon], a
	call PrintPCBox_ClearScreenAndBoxList
	hlcoord 0, 0
	ld bc, 9 * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call Printer_PlaceSideBorders
	call Printer_PlaceTopBorder
	hlcoord 4, 3
	ld de, .String_PokemonList
	call PlaceText
	ld a, [wPrintedBoxNumber]
	ld bc, BOX_NAME_LENGTH
	ld hl, wBoxNames
	rst AddNTimes
	ld d, h
	ld e, l
	hlcoord 6, 5
	call PlaceString
	ld a, 1
	call Printer_GetBoxMonSpecies
	hlcoord 2, 9
	ld c, 3
	jr Printer_PrintBoxListSegment

.String_PokemonList
	ctxt "#mon list"
	done

PrintPCBox_Page2:
	call PrintPCBox_ClearScreenAndBoxList
	call Printer_PlaceSideBorders
	lb bc, 4, 6
	jr Printer_PrintBoxPageContents

PrintPCBox_Page3:
	call PrintPCBox_ClearScreenAndBoxList
	call Printer_PlaceSideBorders
	lb bc, 10, 6
	jr Printer_PrintBoxPageContents

PrintPCBox_Page4:
	call PrintPCBox_ClearScreenAndBoxList
	hlcoord 1, 15
	lb bc, 2, 18
	call ClearBox
	call Printer_PlaceSideBorders
	call Printer_PlaceBottomBorders
	lb bc, 16, 5
	; fallthrough

Printer_PrintBoxPageContents:
	ld a, [wFinishedPrintingBox]
	and a
	ret nz
	ld a, b
	call Printer_GetBoxMonSpecies
	hlcoord 2, 0
	; fallthrough

Printer_PrintBoxListSegment:
	ld a, [wPrintedBoxBank]
	sbk a
.loop
	ld a, c
	and a
	jr z, .exit
	dec c
	ld a, [de]
	cp $ff
	jr nz, .not_done
	ld a, 1
	ld [wFinishedPrintingBox], a
.exit
	jp CloseSRAM
.not_done
	ld [wd265], a
	ld [wCurPartySpecies], a
	push bc
	push hl
	push de
	push hl
	ld bc, 16
	ld a, " "
	call ByteFill
	pop hl
	push hl
	call GetBasePokemonName
	pop hl
	push hl
	call PlaceString
	ld a, [wCurPartySpecies]
	cp EGG
	pop hl
	jr z, .done_printing_mon
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	call Printer_GetMonGender
	ld bc, SCREEN_WIDTH - PKMN_NAME_LENGTH
	add hl, bc
	ld a, "/"
	ld [hli], a
	push hl
	ld c, 14
	ld a, " "
	call ByteFill
	pop hl
	push hl
	ld hl, wPrintedBoxAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, sBoxMonNicknames - sBox
	add hl, bc
	ld bc, PKMN_NAME_LENGTH
	ld a, [wPrintedBoxMon]
	rst AddNTimes
	ld e, l
	ld d, h
	pop hl
	push hl
	call PlaceString
	pop hl
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	push hl
	ld hl, wPrintedBoxAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, 2 + MONS_PER_BOX + MON_LEVEL
	add hl, bc
	ld c, BOXMON_STRUCT_LENGTH
	ld a, [wPrintedBoxMon]
	rst AddNTimes
	ld a, [hl]
	pop hl
	call PrintFullLevel
.done_printing_mon
	ld hl, wPrintedBoxMon
	inc [hl]
	pop de
	pop hl
	ld bc, 3 * SCREEN_WIDTH
	add hl, bc
	pop bc
	inc de
	jp .loop

Printer_GetMonGender:
	push hl
	ld hl, wPrintedBoxAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, 2 + MONS_PER_BOX + MON_DVS
	add hl, bc
	ld c, BOXMON_STRUCT_LENGTH
	ld a, [wPrintedBoxMon]
	rst AddNTimes
	ld de, wTempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, [wPrintedBoxMon]
	ld [wCurPartyMon], a
	ld a, BREEDMON ; loads DVs from wTempMonDVs
	ld [wMonType], a
	callba GetGender
	ld a, " "
	jr c, .got_gender_character
	ld a, "♂"
	jr nz, .got_gender_character
	ld a, "♀"
.got_gender_character
	pop hl
	ld [hli], a
	push af
	ld a, [wPrintedBoxBank]
	sbk a
	pop af
	ret

Printer_GetBoxMonSpecies:
	push hl
	ld e, a
	ld d, 0
	ld hl, wPrintedBoxAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ret

Printer_PlaceTopBorder:
	hlcoord 0, 0
	ld a, "┌"
	ld [hli], a
	ld a, "─"
	ld c, SCREEN_WIDTH - 2
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [hl], "┐"
	ret

Printer_PlaceSideBorders:
	hlcoord 0, 0
	ld de, SCREEN_WIDTH - 1
	ld c, SCREEN_HEIGHT
	ld a, "│"
.loop
	ld [hl], a
	add hl, de
	ld [hli], a
	dec c
	jr nz, .loop
	ret

Printer_PlaceBottomBorders:
	hlcoord 0, 17
	ld a, "└"
	ld [hli], a
	ld a, "─"
	ld c, SCREEN_WIDTH - 2
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [hl], "┘"
	ret

Printer_PlaceEmptyBoxSlotString:
	hlcoord 2, 0
	ld c, 6
.loop
	push bc
	push hl
	ld de, .two_spaces_six_dashes
	call PlaceText
	pop hl
	ld bc, 3 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

.two_spaces_six_dashes
	text "  ------"
	done
