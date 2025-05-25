HBlankCopy2bpp::
	di
	ld [hSPBuffer], sp
	ld hl, hRequestedVTileDest
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a ; destination

	ld a, [hli] ; source
	ld h, [hl]
	ld l, a
	ld sp, hl ; set source to sp
	ld a, h ; save source high byte for later
	ld h, d ; exchange hl and de
	ld l, e
	; check if VRAM to VRAM copy
	sub $80
	cp $a0 - $80
	jr nc, .loop_no_check
	jp VRAMToVRAMCopy

.loop
	ldh a, [rLY]
	cp $88
	jp nc, ContinueHBlankCopy
.loop_no_check
	pop bc
	pop de
.wait_no_hblank_loop
	ldh a, [rSTAT]
	and 3
	jr z, .wait_no_hblank_loop
.wait_hblank_loop
	ldh a, [rSTAT]
	and 3
	jr nz, .wait_hblank_loop
; preloads r us
	ld a, c ; 1
	ld [hli], a ; 3
	ld a, b ; 4
	ld [hli], a ; 6
	ld a, e ; 7
	ld [hli], a ; 9
	ld a, d ; 10
	ld [hli], a ; 12
	rept 5
		pop de ; ...3
		ld a, e ; ...4
		ld [hli], a ; ...6
		ld a, d ; ...7
		ld [hli], a ; ...9
	endr ; 57 (12 + 9 * 5)
	pop de ; 60
	ld a, e ; 61
	ld [hli], a ; 63
	ld [hl], d ; 65
	inc hl
	ldh a, [hTilesPerCycle]
	dec a
	ldh [hTilesPerCycle], a
	jr nz, .loop
	jp RestoreStackReti

PlayFaintingCry::
	call PlayFaintingCry2
	jp WaitSFX

_bc_::
	push bc
	ret
