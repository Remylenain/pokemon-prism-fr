; Functions handling map objects.

GetSpritePalette::
	push hl
	push de
	push bc
	ld b, a

	callba GetSpriteHeaderFromFar

	ld a, h
	pop bc
	pop de
	pop hl
	ret

GetSpriteVTile::
	push hl
	push bc
	ld hl, wUsedSprites + 2
	ld c, SPRITE_GFX_LIST_CAPACITY - 1
	ld b, a
	ldh a, [hMapObjectIndexBuffer]
	and a
	jr z, .nope
	ld a, b
.loop
	cp [hl]
	jr z, .found
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ld a, [wUsedSprites + 1]
	scf
	jr .done

.nope
	ld a, [wUsedSprites + 1]
	jr .done

.found
	inc hl
	xor a
	ld a, [hl]

.done
	pop bc
	pop hl
	ret

DoesSpriteHaveFacings::
	push de
	push hl

	ld b, a
	callba _DoesSpriteHaveFacings
	ld c, a
	pop hl
	pop de
	ret

GetPlayerStandingTile::
	ld a, [wPlayerStandingTile]
	call GetTileCollision
	ld b, a
	ret

; If the player is currently on water, set the zero flag.
CheckOnWater::
	ld a, [wPlayerStandingTile]
	call GetTileCollision
	assert WATERTILE == 1
	dec a
	ret

GetTileCollision::
; Get the collision type of tile a.

	push hl

	ld h, HIGH(TileCollisionTable)
	ld l, a
	ld a, BANK(TileCollisionTable)
	call GetFarByte

	and $f ; lo nybble only

	pop hl
	ret

CheckGrassTile::
	ld d, a
	and $f0
	cp COLL_HIGH_NYBBLE_GRASS
	jr z, .ok
	cp COLL_HIGH_NYBBLE_WATER
	jr z, .ok
	scf
	ret

.ok
	ld a, d
	and 7
	ret z
	scf
	ret

CheckStandingOnEntrance::
	ld a, [wPlayerStandingTile]
	cp COLL_DOOR
	ret z
	cp COLL_STAIRCASE
	ret z
	cp COLL_CAVE
	ret

GetMapObject::
; Return the location of map object a in bc.
	ld hl, wMapObjects
	ld bc, OBJECT_LENGTH
	rst AddNTimes
	ld b, h
	ld c, l
	ret

CheckObjectVisibility::
; Sets carry if the object is not visible on the screen.
	ldh [hMapObjectIndexBuffer], a
	call GetMapObject
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	cp -1
	ccf
	ret c
	ldh [hObjectStructIndexBuffer], a
	call GetObjectStruct
	and a
	ret

_CopyObjectStruct::
	ldh [hMapObjectIndexBuffer], a
	add LOW(wObjectMasks)
	ld l, a
	adc HIGH(wObjectMasks)
	sub l
	ld h, a
	ld [hl], 0 ; unmasked

	ldh a, [hMapObjectIndexBuffer]
	call GetMapObject
	jpba CopyObjectStruct

ApplyDeletionToMapObject::
	ldh [hMapObjectIndexBuffer], a
	call GetMapObject
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	cp -1
	ret z ; already hidden
	ld [hl], -1
	push af
	call .CheckStopFollow
	pop af
	call GetObjectStruct
	jpba DeleteMapObject

.CheckStopFollow
	ld hl, wObjectFollow_Leader
	cp [hl]
	jr z, .ok
	ld hl, wObjectFollow_Follower
	cp [hl]
	ret nz
.ok
	callba StopFollow
	ld a, -1
	ld [wObjectFollow_Leader], a
	ld [wObjectFollow_Follower], a
	ret

DeleteObjectStruct::
	call ApplyDeletionToMapObject

MaskObject::
	ldh a, [hMapObjectIndexBuffer]
	add LOW(wObjectMasks)
	ld l, a
	adc HIGH(wObjectMasks)
	sub l
	ld h, a
	ld [hl], -1 ; masked
	ret

CopyPlayerObjectTemplate::
	push hl
	call GetMapObject
	ld d, b
	ld e, c
	ld a, -1
	ld [de], a
	inc de
	pop hl
	ld bc, OBJECT_LENGTH - 1
	rst CopyBytes
	ret

GetMovementData::
; Initialize the movement data for person c at b:hl
	ld a, b
	call StackCallInBankA
	; end of function

	ld a, c
LoadMovementDataPointer::
; Load the movement data pointer for person a.
	ld [wMovementPerson], a
	ldh a, [hROMBank]
	ld [wMovementDataPointer], a
	ld a, l
	ld [wMovementDataPointer + 1], a
	ld a, h
	ld [wMovementDataPointer + 2], a
	ld a, [wMovementPerson]
	call CheckObjectVisibility
	ret c

	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld [hl], SPRITEMOVEDATA_SCRIPTED

	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_00

	ld hl, wVramState
	set 7, [hl]
	and a
	ret

FindFirstEmptyObjectStruct::
; Returns the index of the first empty object struct in A and its address in HL, then sets carry.
; If all object structs are occupied, A = 0 and Z is set.
; Preserves BC and DE.
	push bc
	push de
	ld hl, wObjectStructs
	ld de, OBJECT_STRUCT_LENGTH
	ld c, NUM_OBJECT_STRUCTS
.loop
	ld a, [hl]
	and a
	jr z, .break
	add hl, de
	dec c
	jr nz, .loop
	xor a
	jr .done

.break
	ld a, NUM_OBJECT_STRUCTS
	sub c
	scf

.done
	pop de
	pop bc
	ret

GetSpriteMovementFunction::
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld a, [hl]
	cp NUM_SPRITEMOVEDATA
	jr c, .ok
	xor a

.ok
	ld hl, SpriteMovementData
	ld e, a
	ld d, 0
	rept SPRITEMOVEDATA_FIELDS
		add hl, de
	endr
	ld a, [hl]
	ret

GetInitialFacing::
	push bc
	push de
	ld e, a
	ld d, 0
	ld hl, SpriteMovementData + 1 ; init facing
	rept SPRITEMOVEDATA_FIELDS
		add hl, de
	endr
	ld a, BANK(SpriteMovementData)
	call GetFarByte
	add a
	add a
	and $c
	pop de
	pop bc
	ret

CopySpriteMovementData::
	anonbankpush SpriteMovementData
	; end of function

	push bc

	ld hl, OBJECT_MOVEMENTTYPE
	add hl, de
	ld [hl], a

	push de
	ld e, a
	ld d, 0
	ld hl, SpriteMovementData + 1 ; init facing
	rept SPRITEMOVEDATA_FIELDS
		add hl, de
	endr
	ld b, h
	ld c, l
	pop de

	ld a, [bc]
	inc bc
	rlca
	rlca
	and %00001100
	ld hl, OBJECT_FACING
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_ACTION
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_FLAGS1
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_FLAGS2
	add hl, de
	ld [hl], a

	ld a, [bc]
	inc bc
	ld hl, OBJECT_PALETTE
	add hl, de
	ld [hl], a

	pop bc
	ret

_GetMovementByte::
; Switch to the movement data bank
	ld a, [hli]
	call StackCallInBankA
	; end of function

; Load the current script byte as given by OBJECT_MOVEMENT_BYTE_INDEX, and increment OBJECT_MOVEMENT_BYTE_INDEX
	ld a, [hli]
	ld d, [hl]
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	add [hl]
	ld e, a
	adc d
	sub e
	ld d, a
	inc [hl]
	ld a, [de]
	ret

SetVramState_Bit0::
	ld hl, wVramState
	set 0, [hl]
	ret

ResetVramState_Bit0::
	ld hl, wVramState
	res 0, [hl]
	ret

UpdateSprites::
	ld a, [wVramState]
	bit 0, a
	ret z

	jpba UpdateMapObjectDataAndSprites

GetObjectStruct::
	ld bc, OBJECT_STRUCT_LENGTH
	ld hl, wObjectStructs
	rst AddNTimes
	ld b, h
	ld c, l
	ret

GetObjectSprite::
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	and a
	ret

SetSpriteDirection::
	; preserves other flags
	push af
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	and %11110011
	ld e, a
	pop af
	and %00001100
	or e
	ld [hl], a
	ret

SpriteDirectionToMapMovement:
	call GetSpriteDirection
	rrca
	rrca
	add SPRITEMOVEDATA_STANDING_DOWN
	ret

SidescrollGetSpriteDirection::
GetSpriteDirection::
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	and %00001100
	ret

GetPlayerIcon:
	ld a, [wPlayerCharacteristics]
	call GetPlayerSpriteHeader
	ld h, d
	ld l, e
	ld a, b
	jp FarDecompressWRA6

GetPlayerSpriteHeader:
	and $f
	ld c, a
	ld b, 0
	ld hl, PlayerSprites
	add hl, bc
	ld b, [hl]
	jpba GetSpriteHeaderFromFar

PlayerSprites::
	db SPRITE_P0
	db SPRITE_P1
	db SPRITE_P2
	db SPRITE_P3
	db SPRITE_P4
	db SPRITE_P5
	db SPRITE_P6
	db SPRITE_P7
	db SPRITE_P8
	db SPRITE_P9
	db SPRITE_P10
	db SPRITE_P11
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_PALETTE_PATROLLER
