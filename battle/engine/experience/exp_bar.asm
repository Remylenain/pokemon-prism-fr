EXP_BAR_EMPTY_TILE EQU $55
EXP_BAR_FULL_TILE EQU EXP_BAR_EMPTY_TILE + 8
EXP_BAR_TILES EQU 9

CalcExpBar:
; Calculate the percent exp between this level and the next
; Level in b, experience in [de]
	push de
	ld d, b
	push de
	callba CalcExpAtLevel
	pop de
	ld hl, hProduct + 1
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld b, a
	ld c, [hl] ; ebc = lowest exp of current level
	inc d
	push de
	push bc
	callba CalcExpAtLevel ; [hProduct + 1] = lowest exp of next level
	pop bc
	pop de
	pop hl
	ld a, [hld]
	sub c
	ld d, a
	ld a, [hld]
	ld h, [hl]
	sbc b
	ld l, a
	ld a, h
	sbc e
	ld h, a ; hld = current exp - lowest exp of current level
	ldh a, [hProduct + 3]
	sub c
	ld c, a
	ldh a, [hProduct + 2]
	sbc b
	ld b, a
	ldh a, [hProduct + 1]
	sbc e
	ld e, a ; ebc = lowest exp of next level - lowest exp of current level
.halveloop
; shift hld and ebc until ebc is a 16-bit number
	ld a, e
	and a
	jr z, .done
	srl h
	rr l
	rr d
	srl e
	rr b
	rr c
	jr .halveloop
.done
	ld a, h
	ldh [hMultiplicand], a
	ld a, l
	ldh [hMultiplicand + 1], a
	ld a, d
	ldh [hMultiplicand + 2], a
	ld a, EXP_BAR_TILES * 8
	ldh [hMultiplier], a
	predef Multiply
	ld a, b
	ldh [hDivisor], a
	ld a, c
	ldh [hDivisor + 1], a
	predef DivideLong
	ldh a, [hLongQuotient + 3]
	ld b, a
	ret

FillInExpBar:
	push hl
	call CalcExpBar
	pop hl
	ld de, 8
	add hl, de
PlaceExpBar:
	; in: b: number of pixels (0..72), hl: last tile of exp bar
	ld c, EXP_BAR_TILES
.fill_full_tiles_loop
	ld a, b
	sub 8
	jr c, .found_partial_tile
	ld b, a
	ld a, EXP_BAR_FULL_TILE
	ld [hld], a
	dec c
	jr nz, .fill_full_tiles_loop
	ret

.found_partial_tile
	add a, EXP_BAR_FULL_TILE ;(a is a negative number right now)
.fill_empty_tiles_loop
	ld [hld], a
	ld a, EXP_BAR_EMPTY_TILE
	dec c
	jr nz, .fill_empty_tiles_loop
	ret
