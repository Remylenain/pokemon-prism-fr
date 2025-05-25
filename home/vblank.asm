; VBlank is the interrupt responsible for updating VRAM.

; In Pokemon Crystal, VBlank has been hijacked to act as the
; main loop. After time-sensitive graphics operations have been
; performed, joypad input and sound functions are executed.

; This prevents the display and audio output from lagging.

VBlank::
	push hl
	push de
	push bc
	push af

	ldh [hVBlankSavedA], a

	ldh a, [hBuffer]
	push af

	ldh a, [hVBlank]
	cp 7
	jr z, .skipToGameTime

	ld a, h
	ldh [hCrashSavedHL], a
	ld a, l
	ldh [hCrashSavedHL + 1], a

	ld hl, sp + 0
	ld a, h
	cp HIGH(wStackBottom)
	jr c, .SPTooLow
	jr nz, .SPTooHigh

	ld hl, sp + 11
	ld a, [hl]
	inc a
	cp $81
	ld l, 5
	jr nc, .crash_screen

	ld hl, wBuildNumberCheck
	ld a, [hli]
	cp HIGH(BUILD_NUMBER)
	jr nz, .invalid_build_number
	ld a, [hl]
	cp LOW(BUILD_NUMBER)
	jr nz, .invalid_build_number

	ldh a, [hROMBank]
	ldh [hROMBankBackup], a

	ldh a, [hVBlank]
	and 7
	add a

	add LOW(.VBlanks)
	ld l, a
	adc HIGH(.VBlanks)
	sub l
	ld h, a

	ld a, [hli]
	ld h, [hl]
	ld l, a

	call _hl_

.doGameTime
	call GameTimer

	ld hl, wVBlankOccurred
	ld a, [hl]
	and a
	ld [hl], 0
	jr nz, .noVBlankLeak
	ld a, $ff
	ldh [hDelayFrameLY], a
.noVBlankLeak

	pop af
	ldh [hBuffer], a

	ldh a, [hROMBankBackup]
	call Bankswitch

	pop af
	pop bc
	pop de
	pop hl
	reti

.SPTooLow
	ld l, 7
	jr .crash_screen

.SPTooHigh
	ld l, 6
	jr .crash_screen

.skipToGameTime
	ldh a, [hROMBank]
	ldh [hROMBankBackup], a
	ldh a, [hRunPicAnim]
	and a
	jr z, .tryDoMapAnims
	dec a
	jr z, .doPokeAnim
	dec a
	jr z, .doGrowlOrRoarAnim
.tryDoMapAnims
	call AnimateTileset
	jr .doGameTime
.doGrowlOrRoarAnim
	ldh a, [rSVBK]
	push af
	ld a, 5
	ldh [rSVBK], a

	call ForcePushOAM

	ld a, BANK(CopyGrowlOrRoarPals)
	call Bankswitch

	ldh a, [hCGBPalUpdate]
	and a
	call nz, CopyGrowlOrRoarPals
	call RunOneFrameOfGrowlOrRoarAnim
	pop af
	ldh [rSVBK], a
	jr .doGameTime

.invalid_build_number
	ld l, 8
; fallthrough

.crash_screen
; unfortunately, flags aren't preserved
	ldh a, [hCrashSavedHL]
	ld h, a
	ld a, l
	ldh [hCrashSavedErrorCode], a
	ldh a, [hCrashSavedHL + 1]
	ld l, a ; retrieve hl while storing the crash error code in hCrashSavedErrorCodes
	ldh a, [hVBlankSavedA]
	ldh [hCrashSavedA], a
	add sp, 10
	ldh a, [hCrashSavedErrorCode]
	jp Crash
; crash ends here
.doPokeAnim
	call TransferAnimatingPicDuringHBlank
	ld a, BANK(SetUpPokeAnim)
	call Bankswitch
	call SetUpPokeAnim
	jr .doGameTime

.VBlanks
	dw VBlank0
	dw VBlank1
	dw VBlank2
	dw VBlank3
	dw VBlank4
	dw VBlank5
	dw VBlank6
	dw VBlank7

VBlank0::
; normal operation

; rng
; scx, scy, wy, wx
; bg map buffer
; palettes
; dma transfer
; bg map
; tiles
; oam
; joypad
; sound

	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a
	ldh a, [hWY]
	ldh [rWY], a
	ldh a, [hWX]
	ldh [rWX], a

	; There's only time to call one of these in one vblank.
	; Calls are in order of priority.

	call UpdateBGMapBuffer
	jr c, .done
	call UpdatePals
	jr c, .done
	call DMATransfer
	jr c, .done
	call UpdateBGMap

	; These have their own timing checks.

	call Serve2bppRequest
	call Serve1bppRequest
	call AnimateTileset

.done
	call PushOAM
	; vblank-sensitive operations are done

	; inc frame counter
	ld hl, hVBlankCounter
	inc [hl]

	; advance random variables
	call UpdateDividerCounters
	call AdvanceRNGState

	call Joypad

	ldh a, [hSeconds]
	ldh [hSecondsBackup], a
; fallthrough

VBlankUpdateSound::
; sound only
	ld a, BANK(_UpdateSound)
	call Bankswitch
	jp _UpdateSound

VBlank2::
	call AnimateTileset
	jr VBlankUpdateSound

VBlank6::
; palettes
; tiles
; dma transfer
; sound
	; inc frame counter
	ld hl, hVBlankCounter
	inc [hl]

	call UpdatePals
	jr c, VBlankUpdateSound

	call Serve2bppRequest
	call Serve1bppRequest
	call DMATransfer
	jr VBlankUpdateSound

VBlank4::
; bg map
; tiles
; oam
; joypad
; serial
; sound
	call UpdateBGMap
	call Serve2bppRequest
	call PushOAM
	call Joypad
	call AskSerial
	jr VBlankUpdateSound

VBlank1::
; exclusively for the title screen
; prevents rainbow flickering

; scx
; tiles
; oam
; sound / lcd stat
	ldh a, [hSCX]
	ldh [rSCX], a
	call Serve2bppRequest
	jr VBlank1EntryPoint

VBlank3::
; scx, scy
; palettes
; bg map
; tiles
; oam
; sound / lcd stat
	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a

	call UpdatePals
	jr c, VBlank1EntryPoint

	call UpdateBGMap
	call Serve2bppRequest
	call LYOverrideStackCopy

VBlank1EntryPoint:
	call PushOAM

	ei
	call VBlankUpdateSound
	ldh a, [hVBlank]
	dec a
	ret z
	di
	ret

VBlank7::
; special vblank routine
; copies tilemap in one frame without any tearing
; also updates oam, and pals if specified
	ld a, BANK(VBlankSafeCopyTilemapAtOnce)
	call Bankswitch
	jp VBlankSafeCopyTilemapAtOnce

VBlank5::
; scx
; palettes
; bg map
; tiles
; joypad
; sound
	ldh a, [hSCX]
	ldh [rSCX], a

	call UpdatePals
	jr c, .done

	call UpdateBGMap
	call Serve2bppRequest
.done
	call Joypad

	xor a
	ldh [rIF], a
	ldh a, [rIE]
	push af
	ld a, %10 ; lcd stat
	ldh [rIE], a
	; request lcd stat
	ldh [rIF], a

	ei
	call VBlankUpdateSound
	di

	xor a
	ldh [rIF], a
	; enable ints besides joypad
	pop af
	ldh [rIE], a
	ret
