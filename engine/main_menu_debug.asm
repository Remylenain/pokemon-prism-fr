MainDebugOptions:
	ld hl, .menu_data_header
	call LoadMenuHeader
	call VerticalMenu
	call CloseWindow
	ret c
	ld a, [wMenuCursorY]
	dec a
	jr z, ResetClock
	dec a
	jr z, DeleteSaveData
	dec a
	jr z, FixBuildNumber
	ret

.menu_data_header
	db $40 ;flags
	db 0, 0 ;initial y, x
	db 9, 19 ;final y, x
	dw .options
	db 4 ;default option
.options
	db $a0 ;flags
	db 4 ;option count
	db "Reset clock@"
	db "Erase saved data@"
	db "Fix build number@"
	db "Back@"

ResetClock:
	ld hl, ResetClockWarningText
	call MainDebugOptions_PlaceMessage_ClearBGMapMode
	call MainDebugOptions_DisplayButtonsAndWait
	ret nc
	sbk BANK(sRTCStatusFlags)
	ld hl, sRTCStatusFlags
	set 7, [hl]
	jr MainDebugOptions_DisplayDoneAndReboot

FixBuildNumber:
	ld hl, FixBuildNumberWarningText
	call MainDebugOptions_PlaceMessage_ClearBGMapMode
	call MainDebugOptions_DisplayButtonsAndWait
	ret nc
	sbk BANK(sBuildNumber)
	ld hl, sBuildNumber
	ld [hl], LOW(BUILD_NUMBER)
	inc hl
	ld [hl], HIGH(BUILD_NUMBER)
	jr MainDebugOptions_DisplayDoneAndReboot

DeleteSaveData:
	ld hl, wTextBoxFlags
	ld a, [hl]
	push af
	ld [hl], %10
	ld hl, DeleteSaveDataWarning1Text
	call MainDebugOptions_PlaceMessage
	call DeleteSaveData_ButtonSound
	ld de, DeleteSaveDataWarning2Text
	hlcoord 2, 7
	call PlaceText
	pop af
	ld [wTextBoxFlags], a
	ld c, 20
	call DelayFrames
	call MainDebugOptions_DisplayButtonsAndWait
	ret nc
	xor a
.loop
	push af
	sbk a
	ld hl, SRAM_Begin
	ld bc, SRAM_End - SRAM_Begin
	xor a
	call ByteFill
	pop af
	inc a
	cp 4
	jr c, .loop
MainDebugOptions_DisplayDoneAndReboot:
	scls
	hlcoord 0, 15
	ld bc, 2 * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	ld de, .text
	hlcoord 7, 16
	call PlaceText
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	ld c, 40
	call DelayFrames
	jp Init

.text
	text "Done!"
	done

MainDebugOptions_PlaceMessage_ClearBGMapMode:
	xor a
	ldh [hBGMapMode], a
MainDebugOptions_PlaceMessage:
	push hl
	call ClearTileMapNoDelay
	call Delay2
	hlcoord 1, 1
	pop de
	jp PlaceText

MainDebugOptions_DisplayButtonsAndWait:
	; returns carry if confirmed, or nc if nope
	ld de, .buttons
	hlcoord 2, 15
	call PlaceText
	call ApplyTilemap
.loop
	call DelayFrame
	call GetJoypad
	ldh a, [hJoyDown]
	bit B_BUTTON_F, a
	ret nz
	and A_BUTTON | SELECT
	cp A_BUTTON | SELECT
	jr nz, .loop
	scf
	ret

.buttons
	ctxt "A+SELECT: confirm"
	nl   " B: back to menu"
	done

DeleteSaveData_ButtonSound:
	call DelayFrame
	call .DeleteSaveData_BlinkCursor
	call CheckIfAOrBPressed
	jr z, DeleteSaveData_ButtonSound
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	jr .clearCursor

.DeleteSaveData_BlinkCursor:
	ldh a, [hVBlankCounter]
	bit 4, a
	ld a, "▼"
	jr nz, .cursorOn
.clearCursor
	ld a, " "
.cursorOn
	ldcoord_a 18, 06
	ret

ResetClockWarningText:
	ctxt " This will reset"
	nl   "the clock's current"
	nl   "  settings, and"
	nl   "prompt you to set"
	nl   "it again when you"
	nl   "  hit Continue."
	next "  Are you sure?"
	done

DeleteSaveDataWarning1Text:
	ctxt "Your current saved"
	nl   "   data will be"
	nl   " deleted forever."
	nl   "THIS ACTION CANNOT"
	nl   "    BE UNDONE."
	done

DeleteSaveDataWarning2Text:
	ctxt "Are you sure you"
	nl   "wish to continue?"
	done

FixBuildNumberWarningText:
	ctxt "     WARNING:"
	next "Skipping savefile"
	nl   "  migration can"
	nl   "   corrupt your"
	nl   "savefile in subtle"
	nl   "but game-breaking"
	nl   "      ways."
	next " Are you sure you"
	nl   " know what you're"
	nl   "      doing?"
	done
