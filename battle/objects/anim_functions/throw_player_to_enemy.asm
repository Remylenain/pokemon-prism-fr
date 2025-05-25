BattleAnimFunction_ThrowFromPlayerToEnemyAndDisappear:
	call BattleAnimFunction_ThrowFromPlayerToEnemy
	ret c
	jp DeinitBattleAnimation

BattleAnimFunction_ThrowFromPlayerToEnemy:
	; don't keep shifting the object to the right if it has already reached x = 136...
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp 136
	ret nc
	; ...otherwise, shift 2 to the right and 1 up
	add a, 2
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	; ...and adjust the Y offset one step further in a sine wave, creating a vertical arc
	ld hl, BATTLEANIMSTRUCT_0F
	add hl, bc
	ld a, [hl]
	dec [hl]
	ld hl, BATTLEANIMSTRUCT_PARAM
	add hl, bc
	ld d, [hl]
	call Sine
	ld hl, BATTLEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	; carry means no early exit
	scf
	ret
