BattleAnimFunction_ArcFromPlayerToEnemyAndDisappear:
	; if the object reached x = 136, we're done, make it vanish
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp 136
	jp nc, DeinitBattleAnimation
	; otherwise, shift it 2 to the right and 1 up
	add a, 2
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	; the effective position is shifted in the direction given by an angle which is tracked in 0F
	; the angle begins at 0 pointing towards the right and increases clockwise by 1/16 of the circle each iteration
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld a, [hl]
	rept 4
		inc [hl]
	endr
	ld d, 16
	push af
	push de
	call Sine
	; the Y offset is just 16 * sin(angle)...
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	call Cosine
	; ...but the X offset is divided by 16 (rounded towards minus infinity), giving it a radius of 1 in the X axis
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	sra a
	sra a
	sra a
	sra a
	ld [hl], a
	ret
