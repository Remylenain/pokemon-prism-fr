SetCaughtData:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
SetBoxmonOrEggmonCaughtData:
	ld a, [wTimeOfDay]
	inc a
	rrca
	rrca
	ld b, a
	ld a, [wCurPartyLevel]
	cp $40
	jr c, .level_okay
	ld a, $3f
.level_okay
	or b
	ld [hli], a
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocation
	ld b, a
	ld a, [wPlayerGender]
	and 1
	rrca
	or b
	ld [hl], a
	ret

SetBoxMonCaughtData:
	sbk BANK(sBoxMon1CaughtLevel)
	ld hl, sBoxMon1CaughtLevel
	call SetBoxmonOrEggmonCaughtData
	jp CloseSRAM

SetGiftBoxMonCaughtData:
	push bc
	sbk BANK(sBoxMon1CaughtLevel)
	ld hl, sBoxMon1CaughtLevel
	pop bc
	call SetGiftMonCaughtData
	jp CloseSRAM

SetGiftPartyMonCaughtData:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	push bc
	call GetPartyLocation
	pop bc
SetGiftMonCaughtData:
	xor a
	ld [hli], a
	ld a, $7e
	rrc b
	or b
	ld [hl], a
	ret

SetEggMonCaughtData:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
	ld a, [wCurPartyLevel]
	push af
	ld a, 1
	ld [wCurPartyLevel], a
	call SetBoxmonOrEggmonCaughtData
	pop af
	ld [wCurPartyLevel], a
	ret

GetCaughtGender:
	ld hl, MON_CAUGHTGENDER
	add hl, bc
	ld c, 0

	ld a, [hl]
	and $7f
	ret z
	cp $7f
	ret z

	inc c
	bit 7, [hl]
	ret z
	inc c
	ret
