CanObjectMoveInDirection:
	ld hl, OBJECT_PALETTE
	add hl, bc
	bit 5, [hl]
	jr z, .not_bit_5

	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit 4, [hl] ; lost
	jr nz, .resume
	push hl
	push bc
	call IsNextTileSurfable
	pop bc
	pop hl
	ret c
	jr .resume

.not_bit_5
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit 4, [hl]
	jr nz, .resume
	push hl
	push bc
	call IsNextTileWalkable
	pop bc
	pop hl
	ret c

.resume
	bit 6, [hl]
	jr nz, .bit_6

	push hl
	push bc
	call WillPersonBumpIntoSomeoneElse
	pop bc
	pop hl
	ret c

.bit_6
	bit 5, [hl]
	jr nz, .bit_5
	push hl
	call HasPersonReachedMovementLimit
	pop hl
	ret c

	push hl
	call IsPersonMovingOffEdgeOfScreen
	pop hl
	ret c

.bit_5
	and a
	ret

IsNextTileWalkable:
	call IsCurrentTileWalkable
	ret c
	assert OBJECT_NEXT_MAP_Y == (OBJECT_NEXT_MAP_X + 1)
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld hl, OBJECT_PALETTE
	add hl, bc
	bit 7, [hl]
	jp nz, WillObjectCollide
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld a, [hl]
	ld d, a
	call GetTileCollision
	and a
	jr z, CheckNextTileAcceptableDirections
	scf
	ret

IsNextTileSurfable:
	call IsCurrentTileWalkable
	ret c
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld a, [hl]
	call GetTileCollision
	dec a
	jr z, CheckNextTileAcceptableDirections
	scf
	ret

CheckNextTileAcceptableDirections:
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld a, [hl]
	call GetTileAcceptableDirections
	ret nc
	push af
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	and 3
	ld e, a
	ld d, 0
	ld hl, .directions
	add hl, de
	pop af
	and [hl]
	ret z
	scf
	ret

.directions
	db 1 << DOWN, 1 << UP, 1 << RIGHT, 1 << LEFT

IsCurrentTileWalkable:
	ld hl, OBJECT_STANDING_TILE
	add hl, bc
	ld a, [hl]
	call GetTileAcceptableDirections
	ret nc
	push af
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	and 3
	ld e, a
	ld d, 0
	ld hl, .directions
	add hl, de
	pop af
	and [hl]
	ret z
	scf
	ret

.directions
	db 1 << UP, 1 << DOWN, 1 << LEFT, 1 << RIGHT

GetTileAcceptableDirections:
	ld d, a
	and $f0
	cp $b0
	jr z, .directional
	cp $c0
	jr z, .directional
	xor a
	ret

.directional
	ld a, d
	and 7
	ld e, a
	ld d, 0
	ld hl, .directions
	add hl, de
	ld a, [hl]
	scf
	ret

.directions
	db  1 << RIGHT
	db  1 << LEFT
	db  1 << DOWN
	db  1 << UP
	db (1 << RIGHT) | (1 << UP)
	db (1 << LEFT)  | (1 << UP)
	db (1 << RIGHT) | (1 << DOWN)
	db (1 << LEFT)  | (1 << DOWN)

WillObjectCollide:
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	and 3
	jr z, .down
	dec a
	jr z, .up
	dec a
	jr z, .left

.right
	inc d
.left
	push de
	inc e
	jr .done

.down
	inc e
.up
	push de
	inc d

.done
	call GetCoordTile
	call GetTileCollision
	pop de
	and a
	jr nz, .collides
	call GetCoordTile
	call GetTileCollision
	and a
	ret z

.collides
	scf
	ret

CheckFacingObject::
	call GetFacingTileCoord

; Double the distance for counter tiles.
	cp COLL_COUNTER
	jr nz, .not_counter_tile

	ld a, [wPlayerStandingMapX]
	sub d
	cpl
	inc a
	add d
	ld d, a

	ld a, [wPlayerStandingMapY]
	sub e
	cpl
	inc a
	add e
	ld e, a
.not_counter_tile

	xor a
	ldh [hMapObjectIndexBuffer], a
	call IsNPCAtCoord
	ret nc
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .standing
	xor a
	ret

.standing
	scf
	ret

WillPersonBumpIntoSomeoneElse:
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld e, [hl]
	; fallthrough

IsNPCAtCoord:
	ld bc, wObjectStructs
	xor a
.loop
	ldh [hObjectStructIndexBuffer], a
	call GetObjectSprite
	jr z, .next

	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit 7, [hl]
	jr nz, .next

	ld hl, OBJECT_PALETTE
	add hl, bc
	bit 7, [hl]
	jr z, .got

	call Function7171
	jr nc, .ok
	jr .ok2

.got
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .ok
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .ok

.ok2
	ldh a, [hMapObjectIndexBuffer]
	ld l, a
	ldh a, [hObjectStructIndexBuffer]
	cp l
	jr nz, .setcarry

.ok
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .next
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .next
	ldh a, [hMapObjectIndexBuffer]
	ld l, a
	ldh a, [hObjectStructIndexBuffer]
	cp l
	jr nz, .setcarry

.next
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ldh a, [hObjectStructIndexBuffer]
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	and a
	ret

.setcarry
	scf
	ret

HasPersonReachedMovementLimit:
	ld hl, OBJECT_RADIUS
	add hl, bc
	ld a, [hl]
	and a
	jr z, .nope
	and $f
	jr z, .check_y
	ld e, a
	ld d, a
	ld hl, OBJECT_INIT_X
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hl]
	add e
	ld e, a
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .yes
	cp e
	jr z, .yes

.check_y
	ld hl, OBJECT_RADIUS
	add hl, bc
	ld a, [hl]
	swap a
	and $f
	jr z, .nope
	ld e, a
	ld d, a
	ld hl, OBJECT_INIT_Y
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hl]
	add e
	ld e, a
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .yes
	cp e
	jr z, .yes

.nope
	xor a
	ret

.yes
	scf
	ret

IsPersonMovingOffEdgeOfScreen:
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [wXCoord]
	cp [hl]
	jr z, .check_y
	ccf
	ret c
	add 9
	cp [hl]
	ret c

.check_y
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [wYCoord]
	cp [hl]
	ret z
	ccf
	ret c
	add 8
	cp [hl]
	ret

Function7171:
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, d
	sub [hl]
	jr c, .nope
	cp 2
	jr nc, .nope
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, e
	sub [hl]
	jr c, .nope
	cp 2
	jr nc, .nope
	scf
	ret

.nope
	and a
	ret
