IsAnyMonHoldingExpShare:
	ld a, [wPartyCount]
	ld b, a
	ld hl, wPartyMon1
	ld c, 1
	ld d, 0
.set_bits_loop
	push hl
	push bc
	ld bc, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	pop bc
	pop hl
	jr z, .next

	push hl
	push bc
	ld bc, MON_ITEM
	add hl, bc
	pop bc
	ld a, [hl]
	pop hl

	cp EXP_SHARE
	jr nz, .next
	ld a, d
	or c
	ld d, a

.next
	sla c
	push de
	ld de, PARTYMON_STRUCT_LENGTH
	add hl, de
	pop de
	dec b
	jr nz, .set_bits_loop

	ld a, d
	ld e, 0
	ld b, PARTY_LENGTH
.count_bits_loop
	srl a
	jr nc, .okay
	inc e

.okay
	dec b
	jr nz, .count_bits_loop
	ld a, e
	and a
	ret
