GivePokerusAndConvertBerries:
	ld hl, wPartyMon1PokerusStatus
	ld a, [wPartyCount]
	ld b, a
	ld de, PARTYMON_STRUCT_LENGTH
; Check to see if any of your Pokemon already has Pokerus.
; If so, sample its spread through your party.
; This means that you cannot get Pokerus de novo while
; a party member has an active infection.
.loopMons
	ld a, [hl]
	and $f
	jr nz, .TrySpreadPokerus
	add hl, de
	dec b
	jr nz, .loopMons

; If we haven't been to Oxalis City at least once,
; prevent the contraction of Pokerus.
	ld hl, wVisitedSpawns
	bit 6, [hl]
	ret z
	call Random
	and a
	ret nz
	ldh a, [hRandomAdd]
	cp 3
	ret nc ;3/65536 chance (00 00, 00 01 or 00 02)
	ld a, [wPartyCount]
	ld b, a
.randomMonSelectLoop
	call Random
	and 7
	cp b
	jr nc, .randomMonSelectLoop
	ld hl, wPartyMon1PokerusStatus
	call GetPartyLocation ;get pokerus byte of random mon
	ld a, [hl]
	and $f0
	ret nz ; if it already has pokerus, do nothing
.sample_pokerus
	call Random
	and $f3
	inc a
	ld [hl], a
	and $f0
	jr z, .sample_pokerus
	ret

.TrySpreadPokerus
	call Random
	cp 1 + 33 percent
	ret nc ;1/3 chance

	ld a, [wPartyCount]
	cp 1
	ret z ;only one mon, nothing to do
	cp b
	jr z, .checkFollowingMonsLoop ;first mon, go forwards

	ld c, [hl]
	ld a, b
	cp 2
	jr c, .checkPreviousMonsLoop ;no more mons after this one, go backwards

	ldh a, [hRandomAdd]
	add a, a
	jr c, .checkPreviousMonsLoop ;random direction
.checkFollowingMonsLoop
	dec b
	add hl, de
	ld a, [hl]
	and a
	jr z, .infectMon
	ld c, a
	and $f
	ret z ;if mon has cured pokerus, stop searching
	dec b ;go on to next mon
	jr nz, .checkFollowingMonsLoop ;no more mons left
	ret

.checkPreviousMonsLoop
	ld a, [wPartyCount]
	cp b
	ret z ;no more mons
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, [hl]
	and a
	jr z, .infectMon
	ld c, a
	and $f
	ret z ;if mon has cured pokerus, stop searching
	inc b ;go on to next mon
	jr .checkPreviousMonsLoop

.infectMon
	ld a, c
	and $f0
	ld b, a
	swap a
	and 3
	inc a
	add a, b
	ld [hl], a
	ret

_ApplyPokerusTick:
	; decreases all pokemon's pokerus counter by b. if the lower nybble reaches zero, the pokerus is cured.
	ld hl, wPartyMon1PokerusStatus
	ld a, [wPartyCount]
	and a
	ret z ;make sure it's not wasting time on an empty party
	ld c, a
.loop
	ld a, [hl]
	and $f ;days remaining
	jr z, .next
	ld d, a
	xor [hl]
	ld [hl], a ;zero the days remaining bits
	ld a, b
	cp MAX_POKERUS_DAYS
	jr nc, .next
	ld a, [hl]
	swap a
	and 3
	inc a
	cp d
	jr c, .fix_days
	ld a, d ;reload the remaining days if they were valid
.fix_days
	sub b
	jr c, .next
	add a, [hl]
	ld [hl], a ;preserve the strain and add back the (new) days remaining bits
.next
	ld de, PARTYMON_STRUCT_LENGTH
	add hl, de
	dec c
	jr nz, .loop
	ret

CheckPokerus:
; Return carry if a monster in your party has Pokerus

; Get number of monsters to iterate over
	ld a, [wPartyCount]
	and a
	jr z, .NoPokerus
	ld b, a
; Check each monster in the party for Pokerus
	ld hl, wPartyMon1PokerusStatus
	ld de, PARTYMON_STRUCT_LENGTH
.Check
	ld a, [hl]
	and $f ; only the bottom nybble is used
	jr nz, .HasPokerus
; Next PartyMon
	add hl, de
	dec b
	jr nz, .Check
.NoPokerus
	and a
	ret

.HasPokerus
	scf
	ret
