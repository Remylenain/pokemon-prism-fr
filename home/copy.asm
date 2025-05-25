; Functions to copy data from ROM.

LoadFontsExtra::
	jpba LoadFrame

LoadFontsBattleExtra::
	jpba _LoadFontsBattleExtra

FarCopyFontToHL::
; Copy the entirety of Font to hl
; doubling each byte in the process.
	anonbankpush Font

	ld de, Font
	ld bc, FontEnd - Font
	inc b
	inc c
	jr .handleLoop

.loop
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

DecompressRequest2bpp::
; Decompress lz data from b:hl to scratch space at 6:d000, then copy c tiles to de.
	push de
	push bc
	call FarDecompressWRA6InB
	pop bc
	pop hl
	ld de, wDecompressScratch

; fallthrough
Request2bppInWRA6:
	ldh a, [hROMBank]
	ld b, a
	call RunFunctionInWRA6

Get2bpp::
	ldh a, [rLCDC]
	bit 7, a
	jr nz, Request2bpp

Copy2bpp::
; copy c 2bpp tiles from b:de to hl
; must be called in di/disable LCD!!!
	call StackCallInBankB
	; end of function

	call WriteVCopyRegistersToHRAM
	ld b, c
	jp _Serve2bppRequest

; fallthrough
Request2bpp::
; Load 2bpp at b:de to occupy c tiles of hl.
	call StackCallInBankB

Request2bppSameBank::
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a

	call WriteVCopyRegistersToHRAM
	ldh a, [rLY]
	cp $88
	jr c, .handleLoop
; fallthrough to vblank copy handler if LY is too high
.loop
	ldh a, [hTilesPerCycle]
	sub $10
	ldh [hTilesPerCycle], a
	jr c, .copyRemainingTilesAndExit
	jr nz, .copySixteenTilesAndContinue
.copyRemainingTilesAndExit
	add $10
	ldh [hRequested2bpp], a
	xor a
	ldh [hTilesPerCycle], a
	call DelayFrame
	ldh a, [hRequested2bpp]
	and a
	jr z, .clearTileCountAndFinish
.addUncopiedTilesToCount
	ld b, a
	ldh a, [hTilesPerCycle]
	add b
	ldh [hTilesPerCycle], a
	xor a
	ldh [hRequested2bpp], a
	jr .handleLoop
.clearTileCountAndFinish
	xor a
	ldh [hTilesPerCycle], a
	jr .done
.copySixteenTilesAndContinue
	ld a, $10
	ldh [hRequested2bpp], a
	call DelayFrame
	ldh a, [hRequested2bpp]
	and a
	jr nz, .addUncopiedTilesToCount
.handleLoop
	call HBlankCopy2bpp
	jr c, .loop
.done

	pop af
	ldh [hBGMapMode], a
	ret

Get1bpp::
	ldh a, [rLCDC]
	bit 7, a
	jr nz, Request1bpp

Copy1bpp::
; copy c 1bpp tiles from b:de to hl
	ld a, b
	call StackCallInBankA
	; end of function

	call WriteVCopyRegistersToHRAM
	ld b, c
	jp _Serve1bppRequest

Request1bpp::
; Load 1bpp at b:de to occupy c tiles of hl.
	call StackCallInBankB
	; end of function

	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a

	call WriteVCopyRegistersToHRAM
	ldh a, [rLY]
	cp $88
	jr c, .handleLoop
; fallthrough to vblank copy handler if LY is too high
.loop
	ldh a, [hTilesPerCycle]
	sub $10
	ldh [hTilesPerCycle], a
	jr c, .copyRemainingTilesAndExit
	jr nz, .copySixteenTilesAndContinue
.copyRemainingTilesAndExit
	add $10
	ldh [hRequested1bpp], a
	xor a
	ldh [hTilesPerCycle], a
	call DelayFrame
	ldh a, [hRequested1bpp]
	and a
	jr z, .clearTileCountAndFinish
.addUncopiedTilesToCount
	ld b, a
	ldh a, [hTilesPerCycle]
	add b
	ldh [hTilesPerCycle], a
	xor a
	ldh [hRequested1bpp], a
	jr .handleLoop

.clearTileCountAndFinish
	xor a
	ldh [hTilesPerCycle], a
	jr .done

.copySixteenTilesAndContinue
	ld a, $10
	ldh [hRequested1bpp], a
	call DelayFrame
	ldh a, [hRequested1bpp]
	and a
	jr nz, .addUncopiedTilesToCount
.handleLoop
	call HBlankCopy1bpp
	jr c, .loop
.done
	pop af
	ldh [hBGMapMode], a
	ret

HBlankCopy1bpp:
	di
	ld [hSPBuffer], sp
	ld hl, hRequestedVTileDest
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ld h, d
	ld l, e
	jr .innerLoop

.outerLoop
	ldh a, [rLY]
	cp $88
	jr nc, ContinueHBlankCopy
.innerLoop
	pop bc
	pop de
.waithblank2
	ldh a, [rSTAT]
	and 3
	jr z, .waithblank2
.waithblank
	ldh a, [rSTAT]
	and 3
	jr nz, .waithblank
	ld a, c
	ld [hli], a
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hli], a
	rept 2
	pop de
	ld a, e
	ld [hli], a
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hli], a
	endr
	ldh a, [hTilesPerCycle]
	dec a
	ldh [hTilesPerCycle], a
	jr nz, .outerLoop
	jr RestoreStackReti

ContinueHBlankCopy:
	ld [hRequestedVTileSource], sp
	ld sp, hl
	ld [hRequestedVTileDest], sp
	scf
RestoreStackReti:
	ld sp, hSPBuffer
	pop hl
	ld sp, hl
	reti

WriteVCopyRegistersToHRAM:
	ld a, e
	ldh [hRequestedVTileSource], a
	ld a, d
	ldh [hRequestedVTileSource + 1], a
	ld a, l
	ldh [hRequestedVTileDest], a
	ld a, h
	ldh [hRequestedVTileDest + 1], a
	ld a, c
	ldh [hTilesPerCycle], a
	ret

VRAMToVRAMCopy::
	lb bc, %11, LOW(rSTAT) ; predefine bitmask and rSTAT source for speed and size
	jr .wait_no_hblank_loop
.loop
	ldh a, [rLY]
	cp $88
	jr nc, ContinueHBlankCopy
.wait_no_hblank_loop
	ldh a, [c]
	and b
	jr z, .wait_no_hblank_loop
.wait_hblank_loop
	ldh a, [c]
	and b
	jr nz, .wait_hblank_loop
	rept 7
		pop de
		ld a, e
		ld [hli], a
		ld a, d
		ld [hli], a
	endr
	pop de
	ld a, e
	ld [hli], a
	ld [hl], d
	inc hl
	ld a, l
	and $f
	jr nz, .wait_no_hblank_loop
	ldh a, [hTilesPerCycle]
	dec a
	ldh [hTilesPerCycle], a
	jr nz, .loop
	jp RestoreStackReti

Get1or2bppDMG:
	ldh [hFarCallSavedA], a
	call StackCallInBankB
	; end of function

	ld b, a
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	ldh a, [hVBlank]
	push af
	ld a, 6
	ldh [hVBlank], a
	call WriteVCopyRegistersToHRAM
	ld c, b
.loop
	ldh a, [hTilesPerCycle]
	sub 8
	ldh [hTilesPerCycle], a
	jr c, .copyRemainingTilesAndExit
	jr nz, .copyEightTilesAndContinue
.copyRemainingTilesAndExit
	add 8
	ldh [c], a
	xor a
	ldh [hTilesPerCycle], a
	call DelayFrame
	ldh a, [c]
	and a
	jr z, .clearTileCountAndFinish
.addUncopiedTilesToCount
	ld b, a
	ldh a, [hTilesPerCycle]
	add b
	ldh [hTilesPerCycle], a
	jr .loop
.clearTileCountAndFinish
	xor a
	ldh [hTilesPerCycle], a
	jr .done
.copyEightTilesAndContinue
	ld a, 8
	ldh [c], a
	call DelayFrame
	ldh a, [c]
	and a
	jr nz, .addUncopiedTilesToCount
	jr .loop
.done
	pop af
	ldh [hVBlank], a
	pop af
	ldh [hBGMapMode], a
	ret

CopyDataUntil::
; Copy hl to de until hl == bc

; In other words, the source data is
; from hl up to but not including bc,
; and the destination is de.
	ld a, c
	sub l
	ld c, a
	ld a, b
	sbc h
	ld b, a
	inc bc
	jr _CopyBytes

CopyNthStruct::
	rst AddNTimes
	jr _CopyBytes

FarCopyBytes::
; copy bc bytes from a:hl to de
	call StackCallInBankA

; fallthrough
_CopyBytes::
; copy bc bytes from hl to de
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .handleLoop
.loop
	ld a, [hli]
	ld [de], a
	inc de
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

ByteFill::
; fill bc bytes with the value of a, starting at hl
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .HandleLoop
.PutByte
	ld [hli], a
.HandleLoop
	dec c
	jr nz, .PutByte
	dec b
	jr nz, .PutByte
	ret

GetFarByteDE::
	push hl
	ld h, d
	ld l, e
	call GetFarByte
	pop hl
	ret

GetFarByteHalfword::
	call StackCallInBankA
	; end of function

	ld a, [hli]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ret

GetFarHalfword::
	call StackCallInBankA
	; end of function
.read
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

GetFarWRAMWord::
	call StackCallInWRAMBankA
	; jumps to the function above with a temporary bank switch
	jr GetFarHalfword.read

DoubleFarCopyWRAM::
; low nybble of a: source bank
; high nybble of a: dest bank
; hl: source addr
; de: dest addr
; bc: copy size
	ldh [hBuffer], a
	and $f
	ldh [hBuffer2], a
	ldh a, [hBuffer]
	swap a
	and $f
	ldh [hBuffer3], a
; hBuffer2 = source
; hBuffer3 = dest

	ldh a, [rSVBK]
	push af
	inc b
	inc c
	dec c
	jr nz, .noDecB
	dec b
.noDecB
	ld a, b
	ldh [hLoopCounter], a
.loop
	ldh a, [hBuffer2]
	ldh [rSVBK], a
	ld a, [hli]
	ld b, a
	ldh a, [hBuffer3]
	ldh [rSVBK], a
	ld a, b
	ld [de], a
	inc de
.handleLoop
	dec c
	jr nz, .loop
	ldh a, [hLoopCounter]
	dec a
	ldh [hLoopCounter], a
	jr nz, .loop

	pop af
	ldh [rSVBK], a
	ret
