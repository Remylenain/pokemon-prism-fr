HealOTParty:
	ld hl, wOTPartySpecies
	jr HealParty_

HealParty:
	ld hl, wPartySpecies
HealParty_:
	xor a
	ld [wCurPartyMon], a
.loop
	ld a, [hli]
	cp -1
	ret z
	cp EGG
	jr z, .next

	push hl
	call HealPartyMon
	pop hl

.next
	ld a, [wCurPartyMon]
	inc a
	ld [wCurPartyMon], a
	jr .loop

HealPartyMon::
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld d, h
	ld e, l

	ld hl, MON_STATUS
	add hl, de
	xor a
	ld [hli], a
	ld [hl], a

	ld hl, MON_MAXHP
	add hl, de

	; bc = MON_HP
	ld b, h
	ld c, l
	dec bc
	dec bc

	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [bc], a

	jpba RestoreAllPP
