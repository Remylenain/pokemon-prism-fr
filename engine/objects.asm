LoadObjectMasks:
	ld hl, wObjectMasks
	xor a
	ld bc, NUM_OBJECTS
	call ByteFill
	ld bc, wMapObjects
	ld de, wObjectMasks
	xor a
.loop
	push af
	push bc
	push de
	call CheckObjectTime
	call nc, CheckObjectFlag
	sbc a
	pop de
	ld [de], a
	inc de
	pop bc
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	ret

CheckObjectFlag:
	ld hl, MAPOBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	sub 1 ; carry if zero
	ret c
	ld hl, MAPOBJECT_EVENT_FLAG
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	cp -1
	jr nz, .check
	ld a, e
	cp -2
	jr c, .check
	sub -1 ; carry if the value was -2, no carry if it was -1
	ret

.check
	ld b, d
	res 7, d
	call CheckEventFlag
	; after CheckEventFlag, a will be one of $00, $01, $02, $04, $08, $10, $20, $40, $80
	; after adding $7F, any non-zero value will have the top bit set
	; result: carry if not zero, inverted if the top bit of the flag number is set
	add a, $7f
	xor b
	add a, a
	ret

CheckObjectTime::
	; returns carry if the object should be hidden
	; if HOUR = TIMEOFDAY: object always appears
	; if HOUR = -1, TIMEOFDAY is a bitfield determining at which time the object appears
	; if HOUR < TIMEOFDAY: the object appears if the hour is between HOUR and TIMEOFDAY (inclusive)
	; otherwise: the object appears if the hour is >= HOUR or <= TIMEOFDAY (i.e., the range spans across midnight)
	assert MAPOBJECT_TIMEOFDAY == (MAPOBJECT_HOUR + 1)
	ld hl, MAPOBJECT_HOUR
	add hl, bc
	ld a, [hli]
	ld e, [hl]
	cp -1
	jr nz, .check_hour
	; in the common case of e = -1, all bits are set, so this check will pass anyway
	ld a, [wTimeOfDay]
	inc a
.bit_shift_loop
	srl e
	dec a
	jr nz, .bit_shift_loop
	; the last bit shifted will be the bitflag for the current time of day
	ccf
	ret

.check_hour
	ld d, a
	ld hl, hHours
	cp e
	ret z ; carry is already unset
	jr c, .check_start_before_end
	ld a, [hl]
	cp d
	ret nc
	cp e
	; clear carry if less than or equal
	ret z
	ccf
	ret

.check_start_before_end
	ld a, e
	cp [hl]
	ret c
	ld a, [hl]
	cp d
	ret
