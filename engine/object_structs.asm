CopyObjectStruct::
	ldh a, [hMapObjectIndexBuffer]
	add LOW(wObjectMasks)
	ld l, a
	adc HIGH(wObjectMasks)
	sub l
	ld h, a
	ld a, [hl]
	and a
	ret nz ; masked

	ld hl, wObjectStructs + OBJECT_STRUCT_LENGTH * 1
	ld a, 1
	ld de, OBJECT_STRUCT_LENGTH
.loop
	ldh [hObjectStructIndexBuffer], a
	ld a, [hl]
	and a
	jr z, .done
	add hl, de
	ldh a, [hObjectStructIndexBuffer]
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	scf
	ret ; overflow

.done
	ld d, h
	ld e, l
	call CopyMapObjectToObjectStruct
	ld hl, wVramState
	bit 7, [hl]
	ret z

	ld hl, OBJECT_FLAGS2
	add hl, de
	set 5, [hl]
	ret

CopyMapObjectToObjectStruct:
	call .CopyMapObjectToTempObject
	jp CopyTempObjectToObjectStruct

.CopyMapObjectToTempObject
	ldh a, [hObjectStructIndexBuffer]
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld [hl], a

	ldh a, [hMapObjectIndexBuffer]
	ld [wTempObjectCopyMapObjectIndex], a

	ld hl, MAPOBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	ld [wTempObjectCopySprite], a

	call GetSpriteVTile
	ld [wTempObjectCopySpriteVTile], a

	ld a, [hl]
	call GetSpritePalette
	ld [wTempObjectCopyPalette], a

	ld hl, MAPOBJECT_COLOR
	add hl, bc
	ld a, [hl]
	and $f0
	jr z, .skip_color_override
	swap a
	and 7 ; OAM_PALETTE
	ld [wTempObjectCopyPalette], a

.skip_color_override
	ld hl, MAPOBJECT_MOVEMENT
	add hl, bc
	ld a, [hl]
	ld [wTempObjectCopyMovement], a

	ld hl, MAPOBJECT_PARAMETER
	add hl, bc
	ld a, [hl]
	ld [wTempObjectCopyRange], a

	ld hl, MAPOBJECT_X_COORD
	add hl, bc
	ld a, [hl]
	ld [wTempObjectCopyX], a

	ld hl, MAPOBJECT_Y_COORD
	add hl, bc
	ld a, [hl]
	ld [wTempObjectCopyY], a

	ld hl, MAPOBJECT_RADIUS
	add hl, bc
	ld a, [hl]
	ld [wTempObjectCopyRadius], a
	ret

InitializeVisibleSprites:
	ld bc, wMapObjects + OBJECT_LENGTH
	ld a, 1
.loop
	ldh [hMapObjectIndexBuffer], a
	ld hl, MAPOBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next

	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	inc a
	jr nz, .next

	ld a, [wXCoord]
	ld d, a
	ld a, [wYCoord]
	ld e, a

	ld hl, MAPOBJECT_X_COORD
	add hl, bc
	ld a, [hl]
	inc a
	sub d
	jr c, .next

	cp MAPOBJECT_SCREEN_WIDTH
	jr nc, .next

	ld hl, MAPOBJECT_Y_COORD
	add hl, bc
	ld a, [hl]
	inc a
	sub e
	jr c, .next

	cp MAPOBJECT_SCREEN_HEIGHT
	jr nc, .next

	push bc
	call CopyObjectStruct
	pop bc
	ret c

.next
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ldh a, [hMapObjectIndexBuffer]
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	ret

CheckObjectEnteringVisibleRange::
	ld a, [wPlayerStepDirection]
	cp STANDING
	ret z
	jumptable

.dw
	dw .Down
	dw .Up
	dw .Left
	dw .Right

.Up
	ld a, [wYCoord]
	dec a
	jr .Vertical

.Down
	ld a, [wYCoord]
	add 9
.Vertical
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld bc, wMapObjects + OBJECT_LENGTH
	ld a, 1
.loop_v
	ldh [hMapObjectIndexBuffer], a
	ld hl, MAPOBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next_v
	ld hl, MAPOBJECT_Y_COORD
	add hl, bc
	ld a, d
	cp [hl]
	jr nz, .next_v
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	inc a
	jr nz, .next_v
	ld hl, MAPOBJECT_X_COORD
	add hl, bc
	ld a, [hl]
	inc a
	sub e
	jr c, .next_v
	cp MAPOBJECT_SCREEN_WIDTH
	jr nc, .next_v
	push de
	push bc
	call CopyObjectStruct
	pop bc
	pop de

.next_v
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ldh a, [hMapObjectIndexBuffer]
	inc a
	cp NUM_OBJECTS
	jr nz, .loop_v
	ret

.Left
	ld a, [wXCoord]
	dec a
	jr .Horizontal

.Right
	ld a, [wXCoord]
	add 10
.Horizontal
	ld e, a
	ld a, [wYCoord]
	ld d, a
	ld bc, wMapObjects + OBJECT_LENGTH
	ld a, 1
.loop_h
	ldh [hMapObjectIndexBuffer], a
	ld hl, MAPOBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next_h
	ld hl, MAPOBJECT_X_COORD
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, .next_h
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	inc a
	jr nz, .next_h
	ld hl, MAPOBJECT_Y_COORD
	add hl, bc
	ld a, [hl]
	inc a
	sub d
	jr c, .next_h
	cp MAPOBJECT_SCREEN_HEIGHT
	jr nc, .next_h
	push de
	push bc
	call CopyObjectStruct
	pop bc
	pop de

.next_h
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ldh a, [hMapObjectIndexBuffer]
	inc a
	cp NUM_OBJECTS
	jr nz, .loop_h
	ret

CopyTempObjectToObjectStruct:
	ld a, [wTempObjectCopyMapObjectIndex]
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, de
	ld [hl], a

	ld a, [wTempObjectCopyMovement]
	call CopySpriteMovementData

	ld a, [wTempObjectCopyPalette]
	ld hl, OBJECT_PALETTE
	add hl, de
	or [hl]
	ld [hl], a

	ld a, [wTempObjectCopyY]
	call .InitYCoord

	ld a, [wTempObjectCopyX]
	call .InitXCoord

	ld a, [wTempObjectCopySprite]
	ld hl, OBJECT_SPRITE
	add hl, de
	ld [hl], a

	ld a, [wTempObjectCopySpriteVTile]
	ld hl, OBJECT_SPRITE_TILE
	add hl, de
	ld [hl], a

	ld hl, OBJECT_STEP_TYPE
	add hl, de
	ld [hl], STEP_TYPE_00

	ld hl, OBJECT_FACING_STEP
	add hl, de
	ld [hl], STANDING

	ld a, [wTempObjectCopyRadius]
	call .InitRadius

	ld a, [wTempObjectCopyRange]
	ld hl, OBJECT_RANGE
	add hl, de
	ld [hl], a

	and a
	ret

.InitYCoord
	ld hl, OBJECT_INIT_Y
	add hl, de
	ld [hl], a

	ld hl, OBJECT_NEXT_MAP_Y
	add hl, de
	ld [hl], a

	ld hl, wYCoord
	sub [hl]
	and $f
	swap a
	ld hl, wMapObjectGlobalOffsetY
	sub [hl]
	ld hl, OBJECT_SPRITE_Y
	add hl, de
	ld [hl], a
	ret

.InitXCoord
	ld hl, OBJECT_INIT_X
	add hl, de
	ld [hl], a
	ld hl, OBJECT_NEXT_MAP_X
	add hl, de
	ld [hl], a
	ld hl, wXCoord
	sub [hl]
	and $f
	swap a
	ld hl, wMapObjectGlobalOffsetX
	sub [hl]
	ld hl, OBJECT_SPRITE_X
	add hl, de
	ld [hl], a
	ret

.InitRadius
	; this function is meant to increment both nybbles separately
	; there are three simple ways of going around it
	; one is Game Freak's, which is to calculate each nybble separately and then OR them
	; another way is to increment, check the half-carry flag, and add $10 if not set
	; (if the half-carry flag is set, the upper nybble is already incremented by the carry)
	; and finally, this way, which works like the previous one, but checks for 0 in the lower nybble instead of reading the half-carry flag directly
	inc a
	ld h, a
	and $f
	ld a, h
	jr z, .radius_OK
	add a, $10
.radius_OK
	ld hl, OBJECT_RADIUS
	add hl, de
	ld [hl], a
	ret
