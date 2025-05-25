BattleAnim_ApplyAngularOffset_HorizontalFlattening:
	; in: d: radius, a: angle
	; the radius is quartered for the vertical offset
	push af
	push de
	call Sine
	sra a
	sra a
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	call Cosine
	ld hl, BATTLEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

BattleAnim_ShiftCoordsRightUpHalved:
	; shifts the coordinates by a to the right and by a/2 up
	and $f
	ld e, a
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	add a, [hl]
	ld [hl], a
	srl e
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	ret

BattleAnim_AnonJumptable:
	ld hl, BATTLEANIMSTRUCT_ANON_JT_INDEX
	add hl, bc
	ld a, [hl]
	jp Jumptable

BattleAnim_IncAnonJumptableIndex:
	ld hl, BATTLEANIMSTRUCT_ANON_JT_INDEX
	add hl, bc
	inc [hl]
	ret

BattleAnim_SetAnonJumptableIndexToOne:
	ld hl, BATTLEANIMSTRUCT_ANON_JT_INDEX
	add hl, bc
	ld [hl], 1
	ret
