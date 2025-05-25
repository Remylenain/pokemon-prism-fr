HandleLinkBattleResult:
	call DetermineLinkBattleResult

	ld a, [wBattleResult]
	and $f
	ld de, LinkBattleResultWinText
	jr z, .store_result
	dec a
	ld de, LinkBattleResultLoseText
	jr z, .store_result
	ld de, LinkBattleResultDrawText
.store_result
	hlcoord 6, 8
	call PlaceText
	ld c, 200
	call DelayFrames

	sbk BANK(sLinkBattleStats)

	call AddLastLinkBattleToLinkRecord
	call ReadAndPrintLinkBattleRecord

	scls
	call WaitPressAorB_BlinkCursor
	jp ClearTileMap

DetermineLinkBattleResult:
	callba UpdateEnemyMonInParty
	ld hl, wPartyMon1HP
	call .count_fainted_mons
	push bc
	ld hl, wOTPartyMon1HP
	call .count_fainted_mons
	ld a, c
	pop bc
	cp c
	jr c, .defeat
	jr nz, .victory
	; both players have the same number of fainted mons
	call .check_partial_health_mons
	jr z, .drawn
	dec e
	jr z, .victory
	dec e
	jr z, .defeat
	ld hl, wPartyMon1HP
	call .calculate_remaining_HP_fraction
	push de
	ld hl, wOTPartyMon1HP
	call .calculate_remaining_HP_fraction
	pop hl
	ld a, d
	cp h
	jr c, .victory
	jr nz, .defeat
	ld a, e
	cp l
	jr z, .drawn
	jr nc, .defeat

.victory
	xor a
	jr .set_battle_result

.defeat
	ld a, 1
	jr .set_battle_result

.drawn
	ld a, 2
.set_battle_result
	ld hl, wBattleResult
	add a, [hl]
	ld [hl], a
	ret

.count_fainted_mons
	lb bc, 3, 0
	ld de, PARTYMON_STRUCT_LENGTH - 1
.loop
	ld a, [hli]
	or [hl]
	jr nz, .not_fainted
	inc c
.not_fainted
	add hl, de
	dec b
	jr nz, .loop
	ret

.calculate_remaining_HP_fraction
	; normalizes all remaining HP counts to a xxxx/8192 value and adds them up
	ld de, 0
	ld c, 3
.remaining_HP_fraction_loop
	ld a, [hli]
	or [hl]
	jr z, .next
	dec hl
	push de
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	xor a
	ldh [hDividend + 3], a
	ld b, 3
.shifting_loop
	srl d
	rr e
	rra
	dec b
	jr nz, .shifting_loop
	add a, $10 ;round to nearest
	ldh [hDividend + 2], a
	ld a, e
	ldh [hDividend + 1], a
	ld a, d
	pop de
	ldh [hDividend], a
	ld a, [hli]
	ldh [hDivisor], a
	ld a, [hld]
	ldh [hDivisor + 1], a
	predef DivideLong
	ldh a, [hLongQuotient + 3]
	add a, e
	ld e, a
	ldh a, [hLongQuotient + 2]
	adc d
	ld d, a
	dec hl
.next
	push de
	ld de, PARTYMON_STRUCT_LENGTH - 1
	add hl, de
	pop de
	dec c
	jr nz, .remaining_HP_fraction_loop
	ret

.check_partial_health_mons
	; out: e+f: comparison result (does either player have partial health mons?)
	; z: neither player, nz: 0: both players, 1: only opponent, 2: only player
	ld hl, wPartyMon1HP
	call .check_fainted_or_full_health
	jr nz, .check_both_sides ; we have a pokemon that's neither fainted nor at full health
	ld hl, wOTPartyMon1HP
	call .check_fainted_or_full_health
	ld e, 1
	ret
.check_both_sides
	ld hl, wOTPartyMon1HP
	call .check_fainted_or_full_health
	ld e, 0
	ret nz ; we both have pokemon that are neither fainted nor at full health
	inc e
	inc e
	ret

.check_fainted_or_full_health
	ld d, 3
.fainted_or_full_health_loop
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	or b
	jr z, .fainted_or_full_health
	ld a, [hli]
	cp b
	ret nz
	ld a, [hld]
	cp c
	ret nz
.fainted_or_full_health
	push de
	ld de, PARTYMON_STRUCT_LENGTH - 2
	add hl, de
	pop de
	dec d
	jr nz, .fainted_or_full_health_loop
	ret
