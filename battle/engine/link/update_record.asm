AddLastLinkBattleToLinkRecord:
	ld hl, wOTPlayerID
	ld de, wStringBuffer1
	ld bc, 2
	rst CopyBytes
	ld hl, wOTPlayerName
	ld bc, NAME_LENGTH - 1
	rst CopyBytes
	ld hl, sLinkBattleStats - (sLinkBattleRecord1Wins - sLinkBattleRecord1)
	call .store_result
	ld hl, sLinkBattleRecord
	ld d, 5
.find_battle_record_loop
	push hl
	inc hl
	inc hl
	ld a, [hld]
	dec hl
	and a
	jr z, .create_new_battle_record
	push de
	ld c, sLinkBattleRecord1Wins - sLinkBattleRecord1
	ld de, wStringBuffer1
	call StringCmp
	pop de
	pop hl
	jr z, .found_battle_record
	ld bc, sLinkBattleRecord2 - sLinkBattleRecord1
	add hl, bc
	dec d
	jr nz, .find_battle_record_loop
	; nothing matches; just overwrite the last record
	ld bc, -(sLinkBattleRecord2 - sLinkBattleRecord1)
	add hl, bc
	push hl
.create_new_battle_record
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	ld bc, 12
	rst CopyBytes
	ld b, 6
	xor a
.clear_record_loop
	ld [de], a
	inc de
	dec b
	jr nz, .clear_record_loop
	pop hl

.found_battle_record
	call .store_result

	; calculate the total battles for each battle record...
	ld b, 5
	ld hl, sLinkBattleRecord2 - 1 ;last byte of sLinkBattleRecord1
	ld de, wd002
.total_battles_per_record_loop
	push bc
	push de
	push hl
	call .add_total_battles
	pop hl
	ld a, e
	pop de
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	ld bc, sLinkBattleRecord2 - sLinkBattleRecord1
	add hl, bc
	pop bc
	dec b
	jr nz, .total_battles_per_record_loop

	; ...and ensure they are still in descending order of totals. (Since only one record was modified, only one pair may need swapping.)
	lb bc, 0, 1
.order_checking_loop
	ld a, b
	add b
	add b
	ld e, a
	ld d, 0
	ld hl, wd002
	add hl, de
	push hl
	ld a, c
	add c
	add c
	ld e, a
	ld hl, wd002
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push bc
	ld c, 3
	call StringCmp
	pop bc
	jr z, .equal
	jr nc, .swap_records
.equal
	inc c
	ld a, c
	cp 5
	jr nz, .order_checking_loop
	inc b
	ld c, b
	inc c
	ld a, b
	cp 4
	jr nz, .order_checking_loop
	ret

.swap_records
	push bc
	ld a, b
	ld bc, sLinkBattleRecord2 - sLinkBattleRecord1
	ld hl, sLinkBattleRecord
	push bc
	rst AddNTimes
	pop bc
	push hl
	ld de, wd002
	rst CopyBytes
	pop hl
	pop bc
	push hl
	ld a, c
	ld bc, sLinkBattleRecord2 - sLinkBattleRecord1
	ld hl, sLinkBattleRecord
	push bc
	rst AddNTimes
	pop bc
	pop de
	push hl
	rst CopyBytes
	ld hl, wd002
	ld bc, sLinkBattleRecord2 - sLinkBattleRecord1
	pop de
	rst CopyBytes
	ret

.add_total_battles
	; adds wins, losses and draws
	; in: hl = pointer to last byte of record
	; out: ebc = grand total
	; this function accounts for 16-bit overflow, and thus returns in three registers, despite the max legitimate result is 9,999 * 3 = 29,997 ($752d)
	ld e, 0
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [hld]
	add a, c
	ld c, a
	ld a, [hld]
	adc b
	ld b, a
	rl e
	ld a, [hld]
	add a, c
	ld c, a
	ld a, [hl]
	adc b
	ld b, a
	ret nc
	inc e
	ret

.store_result
	ld a, [wBattleResult]
	and $f
	ld bc, sLinkBattleRecord1Wins - sLinkBattleRecord1
	jr z, .got_result_address
	dec a
	; assume that all of these offsets are positive and smaller than $100 (in practice they are very small)
	ld c, sLinkBattleRecord1Losses - sLinkBattleRecord1
	jr z, .got_result_address
	ld c, sLinkBattleRecord1Draws - sLinkBattleRecord1
.got_result_address
	add hl, bc
	ld a, [hli]
	cp HIGH(9999)
	jr c, .no_overflow
	ret nz
	ld a, [hl]
	cp LOW(9999)
	ret nc
.no_overflow
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret
