DaycareStep::
	ld a, [wDaycareMan]
	rra
	jr nc, .daycare_lady
	ld a, [wBreedMon1Level]
	cp MAX_LEVEL
	jr nc, .daycare_lady
	ld hl, wBreedMon1Exp + 2
	inc [hl]
	jr nz, .daycare_lady
	dec hl
	inc [hl]
	jr nz, .daycare_lady
	dec hl
	inc [hl]
	ld a, $50 ;caps exp at $50ffff (5,308,415 points), as a safeguard
	cp [hl]
	jr nc, .daycare_lady
	ld [hl], a

.daycare_lady
	ld a, [wDaycareLady]
	rra
	jr nc, .check_egg
	ld a, [wBreedMon2Level]
	cp MAX_LEVEL
	jr nc, .check_egg
	ld hl, wBreedMon2Exp + 2
	inc [hl]
	jr nz, .check_egg
	dec hl
	inc [hl]
	jr nz, .check_egg
	dec hl
	inc [hl]
	ld a, $50 ;same as above
	cp [hl]
	jr nc, .check_egg
	ld [hl], a

.check_egg
	ld hl, wDaycareMan
	bit 5, [hl] ; egg
	ret z
	ld hl, wStepsToEgg
	dec [hl]
	ret nz

	call Random
	and $7f
	ld [hl], a
	callba CheckBreedmonCompatibility
	cp 230
	ld b, 32
	jr nc, .okay
	cp 170
	ld b, 16
	jr nc, .okay
	cp 110
	ld b, 12
	jr nc, .okay
	ld b, 4

.okay
	call RandomPercentage
	cp b
	ret nc
	ld hl, wDaycareMan
	res 5, [hl]
	set 6, [hl]
	ret
