PrintHoursMins::
	; in: d: hours, e: minutes, bc: location to print
	; returns location after printing in bc
	ld h, b
	ld l, c
	ld c, 0
	ld a, [wOptions2]
	and 1 << 3
	jr z, .go
	ld c, "A"
	ld a, d
	cp 12
	jr c, .got_ampm
	sub 12
	ld c, "P"
.got_ampm
	ld d, a
	and a
	jr nz, .go
	ld d, 12
.go
	push bc
	ld a, d
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add a, "0"
	cp "0"
	jr nz, .not_zero
	ld a, " "
.not_zero
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	ld a, ":"
	ld [hli], a
	ld a, e
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add a, "0"
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	pop bc
	ld a, c
	and a
	jr z, .done
	ld [hl], " "
	inc hl
	ld [hli], a
	ld a, "M"
	ld [hli], a
.done
	ld b, h
	ld c, l
	ret
