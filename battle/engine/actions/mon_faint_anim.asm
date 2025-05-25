EnemyMonFaintedAnimation:
	hlcoord 12, 5
	decoord 12, 6
	jr MonFaintedAnimation

PlayerMonFaintedAnimation:
	hlcoord 1, 10
	decoord 1, 11
	; fallthrough

MonFaintedAnimation:
; disable joypad
	push hl
	ld hl, wDisableJoypad
	set 6, [hl]
	pop hl
	ld b, 7

.outer_loop
	push bc
	push de
	push hl
	ld b, 6

.inner_loop
	push bc
	push hl
	push de
	ld bc, 7
	rst CopyBytes
	pop de
	pop hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec b
	jr nz, .inner_loop

	ld bc, 20
	add hl, bc
	ld de, BattleSevenSpacesText
	call PlaceText
	call Delay2
	pop hl
	pop de
	pop bc
	dec b
	jr nz, .outer_loop

	ld hl, wDisableJoypad
	res 6, [hl]
	ret
