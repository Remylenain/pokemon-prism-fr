IsInArray::
; Find value a for every e bytes in array hl.
; Return index in b and carry if found.

	ld b, 0
	ld d, b
	ld c, a
	jr .handleLoop

.loop
	inc b
	add hl, de
.handleLoop
	ld a, [hl]
	cp -1
	ret z ; saves 3 bytes over conditionally jumping to an `and a \ ret` here
	cp c
	jr nz, .loop
; in array
	scf
	ret

IsHMMove::
	ld hl, HMMoves
	; fallthrough

IsInSingularArray::
; Find value a in array hl
; Return index in b and carry if found
	ld b, l ; save original count in b
	ld d, $ff
	ld e, a
.loop
	ld a, [hli]
	cp d
	jr z, .notInArray
	cp e
	jr nz, .loop
; in array
	dec hl
	ld a, l
	sub b ; subtract the current offset with the original offset to get the index
	ld b, a
	scf
	ret

.notInArray
	and a
	ret

CountSetBits::
; Count the number of set bits in b bytes starting from hl.
; Return in a, c and [wd265].

	xor a
.next
	ld e, [hl]
	ld d, 8

.count
	srl e
	adc 0
	dec d
	jr nz, .count

	inc hl
	dec b
	jr nz, .next

	ld c, a
	ld [wd265], a
	ret
