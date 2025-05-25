BattleAnimFunction_RaiseByParam:
	; shift up by PARAM units, until the shift is 40; then vanish
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	and a
	jr z, .go
	cp -40
	jp c, DeinitBattleAnimation
.go
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	sub d
	ld [hl], a
	ret
