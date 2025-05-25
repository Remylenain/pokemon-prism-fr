PlayStereoCry2::
; Don't wait for the cry to end.
; Used during pic animations.
	push af
	ld a, 1
	ld [wStereoPanningMask], a
	pop af
	jp _PlayCry

PlayFaintingCry2::
	push hl
	push de
	push bc

	call LoadCryHeader
	jr c, .ded
	ld hl, wCryPitch
	ld a, 90 percent
	call .Multiply
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 1]
	ld [hli], a

	ld a, 11 percent
	call .Multiply
	ldh a, [hProduct + 2]
	add [hl]
	ld [hli], a
	ldh a, [hProduct + 1]
	adc [hl]
	ld [hl], a

	callba _PlayCryHeader
	jr PlayCry_PopBCDEHLOff

.ded
	ld e, 1
	call PlayDEDCry
	jr PlayCry_PopBCDEHLOff

.Multiply
	ldh [hMultiplier], a
	ld a, [hli]
	ldh [hMultiplicand + 2], a
	ld a, [hld]
	ldh [hMultiplicand + 1], a
	xor a
	ldh [hMultiplicand], a
	ldh [hProduct], a
	predef_jump Multiply

PlayCry::
	call PlayCry2
	jp WaitSFX

PlayCry2::
; Don't wait for the cry to end.
	push af
	xor a
	ld [wStereoPanningMask], a
	ld [wCryTracks], a
	pop af

_PlayCry::
	push hl
	push de
	push bc

	call GetCryIndex
	call nc, PlayCryHeader
PlayCry_PopBCDEHLOff:
	jp PopOffBCDEHLAndReturn

LoadCryHeader::
; Load cry header bc.

	call GetCryIndex
	ret c

	anonbankpush CryHeaders
	; end of function

	ld a, [hli]
	cp $ff
	jr z, .ded
	ld d, 0
	ld e, a

	ld a, [hli]
	ld [wCryPitch], a
	ld a, [hli]
	ld [wCryPitch + 1], a
	ld a, [hli]
	ld [wCryLength], a
	ld a, [hl]
	ld [wCryLength + 1], a
	and a
	ret

.ded
	call LoadDEDCryHeader
	scf
	ret

GetCryIndex::
	and a
	jr z, .no
	cp EGG
	jr z, .no
	cp NUM_POKEMON + 1
	jr nc, .no

	dec a
	ld c, a
	ld b, 0
	ld hl, CryHeaders
	ld a, 5
	rst AddNTimes
	and a
	ret

.no
	scf
	ret
