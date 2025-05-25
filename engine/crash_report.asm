; err codes
; 00 = rst 00
; 01 = rst 38
; 02 = division by zero
; 03 = invalid character
; 04 = text script runs asm code outside ROM
; 05 = code isn't running in ROM (under normal conditions) (PC >= $8000)
; 06 = stack underflow (SP >= $c100)
; 07 = stack overflow (SP < $c000)
; 08 = invalid build number (loaded a savestate from another build)
; 09 = invalid script command
; 10 = invalid command for cmdwitharrayargs
; 11 = script stack full
; 12 = invalid bankswitch byte
; 13 = no windows available for popping
; 14 = failed to restore party after Battle Tower
; 15 = tried looking up a null name
; 16 = invalid script command for script conditionals

RST_00_OP EQU $c7
RST_38_OP EQU $ff
CALL_NZ_OP EQU $c4
CALL_Z_OP EQU $cc
CALL_OP EQU $cd
CALL_NC_OP EQU $d4
CALL_C_OP EQU $dc

	const_def
	const CRASHPS_NEXTLINE
	const CRASHPS_PRINTRAM
	const CRASHPS_PRINTASMWORD
	const CRASHPS_PRINTASMBYTE
	const CRASHPS_PRINTASMLONG

NUM_CRASHPS_CMDS EQU const_value

crashnext EQUS "db $00, "

MACRO crashprintram
	db CRASHPS_PRINTRAM
	dw \1 ; pointer to bytes to print
	db \2 ; num bytes
ENDM

MACRO crashprintasmword
	db CRASHPS_PRINTASMWORD
	dw \1 ; pointer to asm function
ENDM

MACRO crashprintasmbyte
	db CRASHPS_PRINTASMBYTE
	dw \1 ; pointer to asm function
ENDM

MACRO crashprintasmlong
	db CRASHPS_PRINTASMLONG
	IF \1 != $ff
		db \1 + 1
	ELSE
		db $ff
	ENDC
	dw \2 ; pointer to asm function
ENDM

MACRO pnh
	and $f
	add "0"
	or $80
	ld [hli], a
ENDM

MACRO crashcoord
	coord \1, \2, \3, vCrashScreenTileMap
ENDM

_Crash::
	xor a
	ldh [rNR52], a
	ld de, CrashSparrowTile
	ld hl, vFontTiles + $5d0
	ld bc, CrashSparrowTileEnd - CrashSparrowTile
	call CrashCopy1bpp

	ld hl, vBGTiles + $7f0
	ld bc, 16
	xor a
	ldh [rSCX], a
	ldh [rSCY], a
	ldh [rIF], a
	ldh [rIE], a
	call ByteFill
	ld a, 144
	ldh [rWY], a
	ldh a, [rLCDC]
	and %01100010
	inc a ;sets lowest bit
	ldh [rLCDC], a

	crashcoord hl, 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, " "
	call ByteFill

	call PrintBasicCrashInfo
	ldh a, [hCrashRST]
	and $7f
	cp (CrashErrorCodeJumptableEnd - CrashErrorCodeJumptable) / 2
	jr c, .valid
	xor a
.valid
	add a
	ld e, a
	ld d, 0
	ld hl, CrashErrorCodeJumptable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call _hl_
	crashcoord hl, 0, 0
	ld de, vBGMap
	ld b, SCREEN_HEIGHT
.copyCrashTileMapOuterLoop
	ld c, SCREEN_WIDTH
.copyCrashTileMapInnerLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyCrashTileMapInnerLoop
	ld a, e
	add BG_MAP_WIDTH - SCREEN_WIDTH
	ld e, a
	adc d
	sub e
	ld d, a
	dec b
	jr nz, .copyCrashTileMapOuterLoop
	ld a, 1
	ldh [rVBK], a
	ld hl, vBGMap
	ld bc, 32 * 18
	xor a
	call ByteFill
	xor a
	ldh [rVBK], a
.DMGskip
	ld hl, $fe00
	ld de, 4
	ld c, 40
.sprloop
	ld [hl], d
	add hl, de
	dec c
	jr nz, .sprloop

	ld a, $80
	ldh [rBGPI], a
	ld a, $ff
	ldh [rBGPD], a
	ld a, $7f
	ldh [rBGPD], a
	ld a, $86
	ldh [rBGPI], a
	xor a
	ldh [rBGPD], a
	ldh [rBGPD], a
	ld a, $e4
	ldh [rBGP], a
	call EnableLCD
.halt
	halt
	nop ; in case interrupts are disabled
	jr .halt

CrashCopy1bpp:
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, CrashCopy1bpp
	ret

CrashErrorCodeJumptable:
	dw CrashError_GenericRST
	dw CrashError_GenericRST
	dw CrashError_DivideByZero
	dw CrashError_InvalidChar
	dw CrashError_TextASMCallsRAM
	dw CrashError_VBlankCrashCommon
	dw CrashError_VBlankCrashCommon
	dw CrashError_VBlankCrashCommon
	dw CrashError_InvalidBuildNumber
	dw CrashError_InvalidScriptCommand
	dw CrashError_InvalidCmdWithArrayArgsCommand
	dw CrashError_ScriptStackFull
	dw CrashError_InvalidBankswitchBank
	dw CrashError_NoWindowsAvailableForPopping
	dw CrashError_InvalidBattleTowerPartyLength
	dw CrashError_NullName
	dw CrashError_InvalidScriptConditionalByte
CrashErrorCodeJumptableEnd:

CrashError_GenericRST:
; attributes:
; regs
; call location (bank:addr) (if stack wasn't in wram, ignore next attributes)
; actually called from location (as opposed to ret)
; if CL is unknown and stack is in RAM, then we were unable to trace the call function
; if CL is unknown and stack is in ROM, then we can't trace the call function as stack writes are ignored to ROM
	ld de, .RSTCrashInfo
	crashcoord hl, 10, 2
	jp CrashPlaceString

.RSTCrashInfo:
	db "CL:" ; Call Location
	crashprintram hROMBank, 1
	db ":"
	crashprintasmword .PrintCallAddress
	crashnext "from rst:" ; did we hit this error through an RST vector?
	crashprintasmword .PrintFromRST
	db "@"

.PrintCallAddress
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownCallAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec hl
	ld a, h
	cp HIGH(vObjTiles)
	jr c, .notVRAM
	cp HIGH(SRAM_Begin)
	jr nc, .notVRAM
; in vram
	ldh a, [hCrashRST]
	and a
	ld b, RST_38_OP ; assume we rst $38'd if crash op is 1
	jr nz, .assumeRST38
.notVRAM
	call CrashGetFarByteFromCrashBank ; check if the game crashed due to RST
	ld b, a
.assumeRST38
	ldh a, [hCrashRST]
	and $7f
	ld a, RST_00_OP
	jr z, .gotRSTOpcode
	ld a, RST_38_OP
.gotRSTOpcode
	cp b
	ld d, 1
	jr z, .calledFromRST
	dec d
	dec hl
	dec hl
	call CrashGetFarByteFromCrashBank ; if we didn't land into an RST, check if the address on the stack is a return address
	push hl
	ld b, a
	ld hl, .CallOpcodes
.checkIfCallOpcodeLoop
	ld a, [hli]
	and a
	jr z, .notCallOpcode
	cp b
	jr nz, .checkIfCallOpcodeLoop
	pop bc
	scf
	ret
.calledFromRST
	ld b, h
	ld c, l
	scf
	ret

.notCallOpcode
	pop hl

.unknownCallAddress
	ld bc, Crash_FourQuestionMarks
	and a
	ret

.CallOpcodes:
	db CALL_NZ_OP
	db CALL_Z_OP
	db CALL_OP
	db CALL_NC_OP
	db CALL_C_OP
	db 0

.PrintFromRST:
	and a
	dec d
	ld bc, .YString
	ret z
	inc bc
	inc bc
	ret

.YString:
	db "y@"
.NString:
	db "n@"

Crash_FourQuestionMarks:
	db "????@"

CrashError_DivideByZero:
	ld de, .DivideByZeroCrashInfo
	crashcoord hl, 9, 1
	jp CrashPlaceString

.DivideByZeroCrashInfo:
	db "BCL:" ; base call location, i.e. where the Crash call is
	crashprintram hROMBank, 1
	db ":"
	crashprintasmword .PrintBasicCallLocation
	crashnext "PCL:" ; parent call location, i.e. what called the divide function
	crashprintasmbyte .PrintParentCallBank
	db ":"
	crashprintasmword .PrintParentCallAddress
	crashnext "dividend:"
	crashnext ""
	crashprintasmlong $ff, .PrintDividend
	db "@"

.PrintBasicCallLocation
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownCallAddress
	ld a, [hli]
	ld b, [hl]
	ld c, a
	dec bc
	dec bc
	dec bc
	scf
	ret

.unknownCallAddress
	ld bc, Crash_FourQuestionMarks
	and a
	ret

.PrintParentCallBank:
	dec d
	jr nz, .unknownParentBank
	ld hl, .DivideCallAddresses
	ld e, 0
.getDivideAddressIndexLoop
	ld a, [hli]
	cp c
	jr nz, .noMatch
	ld a, b
	cp [hl]
	jr z, .foundAddress
.noMatch
	inc hl
	inc e
	ld a, e
	cp (.DivideCallAddressesEnd - .DivideCallAddresses) / 2
	jr c, .getDivideAddressIndexLoop
.unknownParentBank
	ld bc, CrashError_TwoQuestionMarksString
	ld d, 0
	and a
	ret
.foundAddress
	ld hl, .DivideCallTraceFunctions
	ld b, e
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	ld d, 1
	ret

.DivideCallAddresses:
	dw DivideByZero_Divide
	dw DivideByZero_DivideLong
	dw DivideByZero_Divide16
	dw DivideByZero_SimpleDivide
.DivideCallAddressesEnd:

.DivideCallTraceFunctions:
	dw .TracePredef
	dw .TracePredef
	dw .TraceDivide16
	dw .TraceSimpleDivide

.TracePredef:
	ld a, l
	add 5
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec hl
	dec hl
	scf
	ret

.TraceDivide16:
	ld a, l
	add 5
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, l
	add 4
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, e
	dec hl
	dec hl
	dec hl
	scf
	ret

.TraceSimpleDivide:
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hROMBank]
	ld c, a
	dec hl
	dec hl
	dec hl
	scf
	ret

.PrintParentCallAddress:
	dec d
	jp nz, .unknownCallAddress
	inc d
	ld e, b
	ld b, h
	ld c, l
	scf
	ret

.PrintDividend:
	dec d
	jp nz, .unknownCallAddress
	call ._PrintDividend
	scf
	ret

._PrintDividend
	ld a, e
	and a
	ld e, 4
	ld bc, hDividend
	ret z
	dec a
	ret z
	dec a
	jr z, .divide16
	ld e, 1
	ld bc, wCrashStack - 7
	ret
.divide16
	ld hl, wCrashStack - 6
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld bc, wCrashPrintAsmRegBuffer + 4
	ld e, 2
	ret

CrashError_TwoQuestionMarksString:
	db "??@"

CrashError_InvalidChar:
	ld de, CrashError_InvalidCharCrashInfo1
	crashcoord hl, 8, 1
	call CrashPlaceString
	ld de, CrashError_InvalidCharCrashInfo2
	crashcoord hl, 9, 3
	call CrashPlaceString
	ld de, CrashError_InvalidCharCrashInfo3
	crashcoord hl, 10, 8
	jp CrashPlaceString

CrashError_InvalidCharCrashInfo1:
	db "PTCL:" ; PrintText Call Location (where the function was called from)
	crashprintram wPrintTextInitialBank, 1
	db ":"
	crashprintasmword .PrintPrintTextCallLocation
	crashnext "PSCL:" ; PlaceString Call Location
	crashprintram wPlaceStringInitialBank, 1
	db ":"
	crashprintasmword .PrintPlaceStringCallLocation
	db "@"

.PrintPrintTextCallLocation:
	ld hl, wPrintTextInitialSP
	jr .PrintCallLocationCommon

.PrintPlaceStringCallLocation:
	ld hl, wPlaceStringInitialSP

.PrintCallLocationCommon:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownCallLocation
	inc hl
	inc hl
	ld a, [hli]
	ld b, [hl]
	ld c, a
	dec bc
	dec bc
	dec bc
	scf
	ret

.unknownCallLocation
	ld bc, Crash_FourQuestionMarks
	and a
	ret

CrashError_InvalidCharCrashInfo2:
	db "PTS:" ; PrintText Source (original address of the text)
	crashprintram wPrintTextSavedSource, 2
	crashnext "PTD:" ; PrintText Destination (original tilemap destination of the text)
	crashprintram wPrintTextSavedDest, 2
	crashnext "PSS:" ; PlaceString Source
	crashprintram wPlaceStringSavedSource, 2
	crashnext "PSD:" ; PlaceString Destination
	crashprintram wPlaceStringSavedDest, 2
	db "@"

CrashError_InvalidCharCrashInfo3:
	db "char:" ; the character that caused the crash
	crashprintasmbyte .GetPrintedChar
	crashnext "src:" ; the current text source address
	crashprintram wCrashStack - 4, 2
	crashnext "dst:" ; the current destination tilemap
	crashprintram wCrashStack - 2, 2
	db "@"

.GetPrintedChar:
	ld a, [wCrashStack - 7]
	add LEAST_CONTROL_CHAR
	ld c, a
	scf
	ret

CrashError_TextASMCallsRAM:
	ld de, CrashError_InvalidCharCrashInfo1
	crashcoord hl, 8, 1
	call CrashPlaceString
	ld de, CrashError_InvalidCharCrashInfo2
	crashcoord hl, 9, 3
	call CrashPlaceString
	ld de, CrashError_TextASMCallsRAMCrashInfo3
	crashcoord hl, 10, 8
	jp CrashPlaceString

CrashError_TextASMCallsRAMCrashInfo3:
	db "src:" ; the current text source address
	crashprintram wCrashStack - 2, 2
	crashnext "dst:" ; the current destination tilemap
	crashprintram wCrashStack - 6, 2
	db "@"

CrashError_VBlankCrashCommon:
	ld de, .VBlankCrashCommonInfo
	crashcoord hl, 10, 1
	jp CrashPlaceString

.VBlankCrashCommonInfo:
	db "CL:" ; Call Location
	crashprintram hROMBank, 1
	db ":"
	crashprintasmword .PrintCallLocationAddr
	db "@"

.PrintCallLocationAddr:
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownCallLocation ; if we're not in RAM
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ld a, h
	cp HIGH(SRAM_Begin)
	jr c, .notSRAM
	ld a, c
	and b
	inc a
	jr z, .unknownCallLocation
.notSRAM
	scf
	ret
.unknownCallLocation
	ld bc, Crash_FourQuestionMarks
	and a
	ret

CrashError_InvalidBuildNumber:
	call CrashError_VBlankCrashCommon
	ld de, .InvalidBuildNumberCrashInfo
	crashcoord hl, 10, 2
	jp CrashPlaceString

.InvalidBuildNumberCrashInfo:
	db "Build "
	crashprintasmword .PrintOldBuildNumber
	db "@"

.PrintOldBuildNumber:
	ld a, [wBuildNumberCheck]
	ld b, a
	ld a, [wBuildNumberCheck + 1]
	ld c, a
	call .DivideByTen
	add "0"
	ld h, a
	call .DivideByTen
	add "0"
	ld l, a
	call .DivideByTen
	add "0"
	ld d, a
	call .DivideByTen
	add "0"
	ld e, a
	ld a, "@"
	ld [wInvalidBuildNumberTerminator], a
	ld bc, wCrashPrintAsmRegBuffer + 2
	and a
	ret

.DivideByTen:
; divides bc by 10, remainder in a
	push hl
	ld h, 0
	ld l, b
	call .divide
	ld b, l
	ld l, c
	call .divide
	ld c, l
	ld a, h
	pop hl
	ret

.divide
	push bc
	ld bc, 0
	srl h
	rr l
	rr c
	ld a, l
	and 15
	add a, c
	ld c, a
	ld a, l
	swap a
	and 15
	ld b, a
	add a, c
	ld c, a
	ld a, h
	swap a
	add a, h
	add a, b
	ld b, a
	add a, a
	add a, b
	ld l, a
	ld a, h
	add a, c
	rlca
	pop bc
	jr .handleLoop
.loop
	sub 10
	inc l
.handleLoop
	ld h, a
	cp 10
	jr nc, .loop
	ret

CrashError_InvalidScriptCommand:
	ld de, CrashError_InvalidScriptCommandCrashInfo1
	crashcoord hl, 8, 1
	call CrashPlaceString
	ld de, CrashError_InvalidScriptCommandCrashInfo2
	crashcoord hl, 10, 7
	jp CrashPlaceString

CrashError_InvalidScriptCommandCrashInfo1:
	db "scpt:" ; script
	crashprintasmbyte .PrintInitialScriptBank
	db ":"
	crashprintasmword .PrintInitialScriptPos
	crashnext "ljmp:" ; last destination address of script jump (anything that executes [Local]ScriptJump)
	crashprintram wLastScriptJumpDestBank, 1
	db ":"
	crashprintram wLastScriptJumpDestPos, 2
	crashnext "ljpp:" ; last source address of script jump (where the script was when executing a ScriptJump)
	crashprintram wLastScriptJumpSrcBank, 1
	db ":"
	crashprintram wLastScriptJumpSrcPos, 2
	crashnext "vars:" ; (script vars)
	crashprintram hScriptVar, 1
	db "│"
	crashprintram hScriptHalfwordVar, 2
	crashnext "b:" ; the invalid byte
	crashprintasmbyte .PrintOffendingByte
	db " m:" ; map
	crashprintram wMapGroup, 1
	db ","
	crashprintram wMapNumber, 1
	crashnext "lsdf:" ; script position of last sendif executed
	crashprintram wLastSEndIfBank, 1
	db ":"
	crashprintram wLastSEndIfPos, 2
	db "@"

.PrintInitialScriptBank:
	ld a, [wInitialScriptPos]
	cp LOW(wTemporaryScriptBuffer)
	jr nz, .notStd
	ld a, [wInitialScriptPos + 1]
	cp HIGH(wTemporaryScriptBuffer)
	jr nz, .notStd
	ld hl, wTemporaryScriptBuffer + 2
	ld a, [hli]
	cp jumpstd_command
	jr nz, .notStd
	ld e, [hl]
	ld d, 0
	ld hl, StdScripts
	add hl, de
	add hl, de
	add hl, de
	call .GetStdScriptByteAndIncrement
	ld c, a
	call .GetStdScriptByteAndIncrement
	ld d, a
	call .GetStdScriptByteAndIncrement
	ld h, a
	ld l, d
	scf
	ret

.notStd
	ld hl, wInitialScriptBank
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	scf
	ret

.GetStdScriptByteAndIncrement:
	ld a, BANK(StdScripts)
	call CrashGetFarByte
	inc hl
	ret

.PrintInitialScriptPos:
	ld b, h
	ld c, l
	scf
	ret

.PrintOffendingByte:
	ldh a, [hCrashRST]
	cp 9
	ld a, [wCrashStack - 7]
	jr z, .gotOffendingByte
	ldh a, [hCrashRST]
	cp 10
	ld a, [wScriptArrayCommandBuffer]
	jr z, .gotOffendingByte
	ld hl, wScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wScriptBank]
	call CrashGetFarByte
.gotOffendingByte
	ld c, a
	scf
	ret

CrashError_InvalidScriptCommandCrashInfo2:
	db "ps:" ; script pos of offending script byte
	crashprintram wScriptBank, 1
	db ":"
	crashprintasmword .PrintScriptPos
	crashnext "stk:" ; current script stack
	crashprintram wScriptStackSize, 1
	db "<DOWN>"
val = 0
; all five script stack addresses
	rept 5
	crashnext ("5" - val)
	db ":"
	crashprintram wScriptStack + (4 - val) * 3, 1 ; bank
	db ":"
	crashprintram wScriptStack + 1 + (4 - val) * 3, 2 ; addr
val = val + 1
	endr
	db "@"

.PrintScriptPos:
	ld a, [wScriptPos]
	ld c, a
	ld a, [wScriptPos + 1]
	ld b, a
	ldh a, [hCrashRST]
	cp 9
	jr z, .skipDec
	dec bc
	cp 10
	jr z, .skipDec
	dec bc
.skipDec
	dec bc
	scf
	ret

CrashError_InvalidCmdWithArrayArgsCommand:
	call CrashError_InvalidScriptCommand
	ld de, CrashError_InvalidCmdWithArrayArgsCommandCrashInfo
	crashcoord hl, 0, 7
	jp CrashPlaceString

CrashError_InvalidCmdWithArrayArgsCommandCrashInfo:
	db "a:" ; array data
	crashprintram wScriptArrayBank, 1
	db ":"
	crashprintram wScriptArrayAddress, 2
	crashnext "l:" ; byte size (length) of array entry
	crashprintram wScriptArrayEntrySize, 1
	db " e:" ; current entry index
	crashprintram wScriptArrayCurrentEntry, 1
	db "@"

CrashError_ScriptStackFull:
	call CrashError_InvalidScriptCommand
	ld de, .ScriptStackFullCrashInfo
	crashcoord hl, 0, 7
	jp CrashPlaceString

.ScriptStackFullCrashInfo:
	db "p:" ; pointer that was going to be on the stack
	crashprintram wCrashStack - 5, 1
	db ":"
	crashprintram wCrashStack - 4, 2
	db "@"

CrashError_InvalidBankswitchBank:
	ld de, .InvalidBankswitchBankCrashInfo
	crashcoord hl, 10, 1
	jp CrashPlaceString

.InvalidBankswitchBankCrashInfo:
	db "CL:" ; Call Location
	crashprintram hROMBank, 1
	db ":"
	crashprintasmword .PrintCallLocation
	crashnext "byte:" ; invalid byte
	crashprintasmbyte .PrintOffendingByte
	db "@"

.PrintCallLocation:
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownCallLocation
	ld a, [hli]
	ld b, [hl]
	ld c, a
	dec bc
	dec bc
	ld d, 1
	scf
	ret
.unknownCallLocation
	ld bc, Crash_FourQuestionMarks
	ld d, 0
	and a
	ret

.PrintOffendingByte
	dec d
	jr nz, .unknownByte
	inc bc
	ld h, b
	ld l, c
	call CrashGetFarByteFromCrashBank
	ld c, a
	scf
	ret

.unknownByte
	ld bc, CrashError_TwoQuestionMarksString
	and a
	ret

CrashError_NoWindowsAvailableForPopping:
	ld de, .NoWindowsAvailableForPoppingCrashInfo
	crashcoord hl, 9, 1
	jp CrashPlaceString

.NoWindowsAvailableForPoppingCrashInfo:
	db "stkptr:" ; window stack pointer
	crashprintram wWindowStackPointer, 2
	crashnext " CL:" ; call location
	crashprintasmbyte .PrintCallLocationBank
	db ":"
	crashprintasmword .PrintCallLocationAddr
	db "@"

.PrintCallLocationBank:
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownCallBank
	ld de, 5
	add hl, de
	ld c, [hl]
	ld d, 1
	scf
	ret
.unknownCallBank
	ld bc, CrashError_TwoQuestionMarksString
	ld d, 0
	and a
	ret

.PrintCallLocationAddr:
	dec d
	jr nz, .unknownCallLocation
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call .CheckCommonFunction
	jr nc, .gotParentFunction
	ld d, a
	call .RereadParentFunction
	bit 7, d
	jr z, .gotParentFunction
	call .CheckCommonFunction
	call c, .RereadParentFunction
.gotParentFunction
	dec bc
	dec bc
	dec bc
	scf
	ret

.RereadParentFunction:
	jr z, .skipInc
	inc hl
	inc hl
.skipInc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ret

.unknownCallLocation
	ld bc, Crash_FourQuestionMarks
	and a
	ret

.CheckCommonFunction
	push hl
	ld hl, .CommonExitMenuFunctions
	ld d, (.CommonExitMenuFunctionsEnd - .CommonExitMenuFunctions) / 3
.loop
	ld a, [hli]
	cp c
	jr nz, .notFound
	ld a, b
	cp [hl]
	jr z, .found
.notFound
	inc hl
	inc hl
	dec d
	jr nz, .loop
	pop hl
	and a
	ret

.found
	inc hl
	ld a, [hl]
	and a
	pop hl
	scf
	ret

.CommonExitMenuFunctions:
	dwb CloseWindow_AfterExitMenu, 1 << 7 | 1
	dwb CloseSubmenu_AfterExitMenu, 0
	dwb ExitAllMenus_AfterExitMenu, 0
	dwb InterpretTwoOptionMenu_AfterCloseWindow, 1
	dwb GetMenu2_AfterCloseWindow, 0
.CommonExitMenuFunctionsEnd:

CrashError_InvalidBattleTowerPartyLength:
	ld de, .InvalidBattleTowerPartyLengthCrashInfo
	crashcoord hl, 10, 1
	jp CrashPlaceString

.InvalidBattleTowerPartyLengthCrashInfo:
	db "len:"
	crashprintram wCrashStack - 7, 1
	db "@"

CrashError_NullName:
	ld de, .NullNameCrashInfo
	crashcoord hl, 10, 1
	jp CrashPlaceString

.NullNameCrashInfo:
	db "type:" ; type of name
	crashprintram wNamedObjectTypeBuffer, 1
	crashnext "CL:" ; call location
	crashprintram hROMBank, 1
	db ":"
	crashprintasmword .PrintCallLocationAddr
	db "@"

.PrintCallLocationAddr:
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownCallLocation
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call .CheckCommonFunction
	jr nc, .gotParentFunction
	jr z, .noAdd
	add l
	ld l, a
	adc h
	sub l
.noAdd
	ld h, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.gotParentFunction
	dec bc
	dec bc
	dec bc
	scf
	ret

.unknownCallLocation
	ld bc, Crash_FourQuestionMarks
	and a
	ret

.CheckCommonFunction
	push hl
	ld hl, .CommonGetNameFunctions
	ld d, (.CommonGetNameFunctionsEnd - .CommonGetNameFunctions) / 3
.loop
	ld a, [hli]
	cp c
	jr nz, .notFound
	ld a, b
	cp [hl]
	jr z, .found
.notFound
	inc hl
	inc hl
	dec d
	jr nz, .loop
	pop hl
	and a
	ret

.found
	inc hl
	ld a, [hl]
	and a
	pop hl
	scf
	ret

.CommonGetNameFunctions:
	dwb GetAbilityName_AfterGetName, 0
	dwb GetItemName_AfterGetName, 4
	dwb GetMoveName_AfterGetName, 2
	dwb GetTrainerClassName_AfterGetName, 2
.CommonGetNameFunctionsEnd:

CrashError_InvalidScriptConditionalByte:
	call CrashError_InvalidScriptCommand
	ld de, .InvalidScriptConditionalByteInfo
	crashcoord hl, 0, 7
	jp CrashPlaceString

.InvalidScriptConditionalByteInfo:
	db "ifps:" ; script position of the last script conditional byte executed
	crashprintasmword .PrintScriptConditionalPos
	crashnext "iips:" ; script position of the outermost script conditional byte
	crashprintram wScriptConditionalInitialPos, 2
	crashnext "c:" ; the condition, from 0 to 6
	crashprintram wScriptConditionalCondition, 1
	db " r:" ; recursion/nested count
	crashprintram wScriptConditionalRecursionFlag, 1
	db "@"

.PrintScriptConditionalPos:
	ld a, [wScriptConditionalRecursionFlag]
	and a
	jr z, .isInitialPos
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	jr z, .unknownScriptConditionalPos
	ld a, l
	add 7
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	scf
	ret
.isInitialPos
	ld a, [wScriptConditionalInitialPos]
	ld c, a
	ld a, [wScriptConditionalInitialPos + 1]
	ld b, a
	scf
	ret

.unknownScriptConditionalPos
	ld bc, Crash_FourQuestionMarks
	and a
	ret

PrintBasicCrashInfo:
	ld de, .CrashInfoString
	crashcoord hl, 0, 0
	call CrashPlaceString
	ld de, CrashReportText
	ld hl, vBGTiles
	ld bc, CrashReportTextEnd - CrashReportText
	call CrashCopy1bpp
	crashcoord hl, 10, 14
	ld de, SCREEN_WIDTH - 10
	xor a
	ld b, 4
.printCrashReportTextOuterLoop
	ld c, 10
.printCrashReportTextInnerLoop
	ld [hli], a
	inc a
	dec c
	jr nz, .printCrashReportTextInnerLoop
	add hl, de
	dec b
	jr nz, .printCrashReportTextOuterLoop
	ret

.CrashInfoString:
	db "b"
	db "0" + BUILD_NUMBER / 1000
	db "0" + (BUILD_NUMBER / 100) % 10
	db "0" + (BUILD_NUMBER / 10) % 10
	db "0" + BUILD_NUMBER % 10
	db " err "
	crashprintasmbyte .PrintCrashRST
	db " emu:"
	crashprintasmbyte .PrintEmulatorRating
	crashnext "Bank:"
	crashprintram hROMBank, 1
	crashnext "AF:"
	crashprintram wCrashStack - 8, 2
	crashnext "BC:"
	crashprintram wCrashStack - 6, 2
	crashnext "DE:"
	crashprintram wCrashStack - 4, 2
	crashnext "HL:"
	crashprintram wCrashStack - 2, 2
	crashnext "SP:"
	crashprintram hCrashSP, 2
	db "<DOWN>"
	crashnext ""
	crashprintasmword .InitStackPrint
	db ":"
	crashprintasmword .PrintStackValue
val = 0
	rept 10
	crashnext ""
	crashprintasmword .PrintStackAddr
	IF val != 7
		db ":"
	ELSE
		db "▶"
	ENDC
	crashprintasmword .PrintStackValue
val = val + 1
	endr
	db "@"

.PrintCrashRST:
	ldh a, [hCrashRST]
	ld c, 10
	call SimpleDivide
	add "0"
	ld l, a
	ld a, b
	call SimpleDivide
	add "0"
	ld d, a
	ld a, b
	call SimpleDivide
	add "0"
	ld e, a
	ld h, "@"
	ld bc, wCrashPrintAsmRegBuffer + 2
	and a ; clear carry, use printString
	ret

.PrintEmulatorRating:
	call CheckEmulator
	ld c, a
	scf
	ret

.InitStackPrint:
	ld hl, hCrashSP
	ld a, [hli]
	ld h, [hl]
	add 2 * 8
	ld l, a
	adc h
	sub l
	ld h, a
.PrintStackAddr
	ld b, h
	ld c, l
	scf
	ret

.PrintStackValue:
	inc hl
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	dec hl
	scf
	ret

CrashPlaceString:
	push bc
	push hl
	jr .handleLoop
.loop
	cp NUM_CRASHPS_CMDS
	jr nc, .placeChar
	and a
	jr z, .crashNextLine
	push hl
	dec a
	ld hl, .CrashPlaceStringCommands
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	call _bc_
	jr .handleLoop

.crashNextLine
	pop hl
	ld a, SCREEN_WIDTH
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	push hl
	jr .handleLoop
.placeChar
	ld [hli], a
.handleLoop
	ld a, [de]
	inc de
	cp "@"
	jr nz, .loop
	pop bc
	pop bc
	ret

.CrashPlaceStringCommands:
	dw CrashPlaceString_PrintRAM
	dw CrashPlaceString_PrintASMWord
	dw CrashPlaceString_PrintASMByte
	dw CrashPlaceString_PrintASMLong

CrashPlaceString_PrintRAM:
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	inc de
	push de
	ld d, b
	ld e, c
	ld c, a
	call .printRAMLoop
	pop de
	ret

.printRAMLoop
	dec c
	jr z, .printByte
	inc de
	call .printByte
	dec de
	call .printByte
	inc de
	inc de
	dec c
	jr nz, .printRAMLoop
	ret

.printByte
	ld a, [de]
	swap a
	pnh
	ld a, [de]
	pnh
	ret

CrashPlaceString_PrintASMLong:
	ld a, [de]
	inc de
	jr CrashPlaceString_PrintASM

CrashPlaceString_PrintASMWord:
	ld a, 1
	jr CrashPlaceString_PrintASM

CrashPlaceString_PrintASMByte:
	xor a
CrashPlaceString_PrintASM:
	push af
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	push de
	push hl
	call .CallASMFunction
	ld a, h
	ld [wCrashPrintAsmRegBuffer + 5], a
	ld a, l
	ld [wCrashPrintAsmRegBuffer + 4], a
	ld hl, wCrashPrintAsmRegBuffer
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d
	pop hl
	pop de
	jr nc, .printString
	pop af
	and a
	jr z, .printByte
	dec a
	jr nz, .printLong
	ld a, b
	swap a
	pnh
	ld a, b
	pnh
.printByte
	ld a, c
	swap a
	pnh
	ld a, c
	pnh
	ret

.printLong
	cp $fe
	jr nz, .notVariableLength
	ld a, [wCrashPrintAsmRegBuffer + 2] ; value of e
.notVariableLength
	push de
	ld d, a
.printLongLoop
	ld a, [bc]
	swap a
	pnh
	ld a, [bc]
	pnh
	inc bc
	dec d
	jr nz, .printLongLoop
	pop de
	ret

.printString
	pop af
	jr .handleLoop
.printStringLoop
	ld [hli], a
.handleLoop
	ld a, [bc]
	inc bc
	cp "@"
	jr nz, .printStringLoop
	ret

.CallASMFunction
	push bc
	ld hl, wCrashPrintAsmRegBuffer
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

CrashSparrowTile: INCBIN "gfx/crash/sparrow.1bpp"
CrashSparrowTileEnd:

CrashReportText: INCBIN "gfx/crash/crash_report.1bpp"
CrashReportTextEnd:
