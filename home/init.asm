Reset::
	di
	call TurnSoundOff
	xor a
	ldh [hMapAnims], a
	call ClearPalettes
	xor a
	ldh [rIF], a
	ld a, 1 ; VBlank int
	ldh [rIE], a
	ei

	; disable joypad
	ld hl, wDisableJoypad
	set 7, [hl]

	ld c, 32
	call DelayFrames
	; fallthrough

Init::
	di
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ldh [rRP], a
	ldh [rSCX], a
	ldh [rSCY], a
	ldh [rSB], a
	ldh [rSC], a
	ldh [rWX], a
	ldh [rWY], a
	ldh [rTMA], a
	ldh [rTAC], a
	ld [$d000], a

	ld a, (1 << rTAC_ON) | rTAC_65536_HZ ; Start timer at 262144Hz
	ldh [rTAC], a

; Clear WRAM bank 0
	xor a
	ld hl, $c000
	ld bc, $d000 - $c000
.byteFill
	ld [hli], a
	dec c
	jr nz, .byteFill
	dec b
	jr nz, .byteFill

	ld sp, wStack

; Clear HRAM
	ldh a, [hCGB]
	push af
	xor a
	ld hl, $ff80
	ld bc, $7f
	call ByteFill
	pop af
	ldh [hCGB], a

	and a
	jr nz, .cgb
; In DMG, Nintendo logo still persists after booting, so we need to fade that out
	ld a, 7
	ldh [hVBlank], a
	ld a, 1 << VBLANK
	ldh [rIE], a
	ei
	ld hl, DMGFadeToWhiteTable
	callba DMGFade
	di
	xor a
	ldh [hVBlank], a
	ldh [rIF], a
	ldh [rIE], a
.cgb
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a

.wait
	ldh a, [rLY]
	cp 145
	jr nz, .wait

	xor a
	ldh [rLCDC], a

	call ClearWRAM
	call ClearVRAM
	call ClearSprites

	; load the current build number to WRAM, in a place that should not be modified, ever
	ld hl, wBuildNumberCheck
	ld a, HIGH(BUILD_NUMBER)
	ld [hli], a
	ld [hl], LOW(BUILD_NUMBER)

	; quickly initialize and randomize the RNG state
	sbk BANK(sRNGState)
	ld hl, sRNGState
	push hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	or b
	ld b, a
	ld a, [hli]
	or b
	or [hl]
	pop hl
	jr nz, .saved_RNG_OK
	push hl
	ld a, 251
	ld [hli], a
	ld a, 241
	ld [hli], a
	ld a, 41
	ld [hli], a
	ld [hl], 101
	pop hl
.saved_RNG_OK
	ld de, wRNGState
	ld bc, 4
	push hl
	push de
	push bc
	rst CopyBytes
	call Random
	pop bc
	pop hl
	pop de
	rst CopyBytes
	scls

	callba LoadPushOAM

	xor a
	ldh [hMapAnims], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [rJOYP], a

	ld a, 8 ; HBlank int enable
	ldh [rSTAT], a

	ld a, $90
	ldh [hWY], a
	ldh [rWY], a

	ld a, 7
	ldh [hWX], a
	ldh [rWX], a

	ld a, %11100011
	; LCD on
	; Win tilemap 1
	; Win on
	; BG/Win tiledata 0
	; BG Tilemap 0
	; OBJ 8x8
	; OBJ on
	; BG on
	ldh [rLCDC], a

	ld a, CONNECTION_NOT_ESTABLISHED
	ldh [hSerialConnectionStatus], a

	ld a, HIGH(vWindowMap)
	ldh [hBGMapAddress + 1], a
	xor a ; LOW(vWindowMap)
	ldh [hBGMapAddress], a

	callba StartClock

	xor a
	ld [MBC3LatchClock], a
	ld [MBC3SRamEnable], a

	ldh a, [hCGB]
	cp GBC_BOOT_VALUE
	jr nz, .speed_ok

	ld hl, rKEY1
	bit 7, [hl]
	jr nz, .speed_ok ; don't switch back after soft reset

	set 0, [hl]
	ld a, $30
	ldh [rJOYP], a
	stop ; rgbasm adds a nop after this instruction by default
.speed_ok

	xor a
	ldh [rIF], a
	ld a, 1 << VBLANK | 1 << SERIAL ; VBlank, LCDStat, Timer, Serial interrupts
	ldh [rIE], a
	call LoadLCDCode
	ei

	call DelayFrame

	call TurnSoundOff
	xor a
	ld [wMapMusic], a
	jpba GameInit

ClearVRAM::
; Wipe VRAM banks 0 and 1

	vbk BANK(vStandingFrameTiles)
	call .clear

	vbk BANK(vObjTiles)
.clear
	ld hl, vObjTiles
	ld bc, VRAM_End - vObjTiles
	xor a
	jp ByteFill

ClearWRAM::
; Wipe swappable WRAM banks (1-7)
	ld d, 7 ; count backwards from bank 7
.loop
	wbk d
	xor a
	ld hl, $d000
	ld bc, $1000
	call ByteFill
	dec d
	jr nz, .loop
	ret
