MapObjectMovementPattern:
	call ClearObjectStructField28
	call GetSpriteMovementFunction
	ld a, [hl]
	jumptable

.Pointers
	dw GenericDummyFunction          ; 00
	dw .RandomWalkY                  ; 01
	dw .RandomWalkX                  ; 02
	dw .RandomWalkXY                 ; 03
	dw .RandomSpin1                  ; 04
	dw .RandomSpin2                  ; 05
	dw .Standing                     ; 06
	dw .ObeyDPad                     ; 07
	dw .Movement08                   ; 08
	dw .Movement09                   ; 09
	dw _GetMovementPerson            ; 0a
	dw _GetMovementPerson            ; 0b
	dw _GetMovementPerson            ; 0c
	dw .ObeyDPad                     ; 0d
	dw _GetMovementPerson            ; 0e
	dw .Follow                       ; 0f
	dw .Script                       ; 10
	dw .Strength                     ; 11
	dw .FollowNotExact               ; 12
	dw .MovementShadow               ; 13
	dw .MovementEmote                ; 14
	dw .MovementBigStanding          ; 15
	dw .MovementBouncing             ; 16
	dw .MovementScreenShake          ; 17
	dw .MovementSpinClockwise        ; 18
	dw .MovementSpinCounterclockwise ; 19
	dw .MovementBoulderDust          ; 1a
	dw .MovementShakingGrass         ; 1b
	dw .MovementDeepSnow             ; 1c
	dw .MovementAlternate            ; 1d

.RandomWalkY
	call Random
	and 1
	jr .RandomWalkContinue

.RandomWalkX
	call Random
	and 1
	or 2
	jr .RandomWalkContinue

.RandomWalkXY
	call Random
	and 3
.RandomWalkContinue
	call InitStep
	call CanObjectMoveInDirection
	jr c, .NewDuration
	call UpdateTallGrassFlags
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_STEP
	ld hl, wCenteredObject
	ldh a, [hMapObjectIndexBuffer]
	cp [hl]
	jr z, .load_6
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_07
	ret

.load_6
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_PLAYER_WALK
	ret

.NewDuration
	call EndSpriteMovement
	call CopyCurCoordsToNextCoords
	jr .RandomStepDurationSlow

.RandomSpin1
	call Random
	and %00001100
	ld hl, OBJECT_FACING
	add hl, bc
	ld [hl], a
.RandomStepDurationSlow
	jp RandomStepDuration_Slow

.RandomSpin2
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	and %00001100
	ld d, a
	call Random
	and %00001100
	cp d
	jr nz, .keep
	xor %00001100
.keep
	ld [hl], a
	jp RandomStepDuration_Fast

.Standing
	call CopyCurCoordsToNextCoords
	call EndSpriteMovement
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_STAND
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_05
	ret

.ObeyDPad
	ld hl, GetNextPlayerMovement
.HandleMovementData
	jp HandleMovementData

.Movement08
	ld hl, GetNextBufferedMovement1
	jr .HandleMovementData

.Movement09
	ld hl, GetNextBufferedMovement2
	jr .HandleMovementData

.Follow
	ld hl, GetFollowerNextMovementByte
	jr .HandleMovementData

.Script
	ld hl, GetMovementByte
	jr .HandleMovementData

.Strength
	call MovementAnonymousJumptable
	dw .Strength_Start
	dw .Strength_Stop

.Strength_Start
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld a, [hl]
	cp COLL_HOLE
	jr z, .on_pit
	ld hl, OBJECT_FLAGS2
	add hl, bc
	bit 2, [hl]
	res 2, [hl]
	jr z, .Strength_Stop
	ld hl, OBJECT_RANGE
	add hl, bc
	ld a, [hl]
	and %00000011
	call InitStep
	call CanObjectMoveInDirection
	jr c, .ok2
	ld de, SFX_STRENGTH
	call PlaySFX
	call SpawnStrengthBoulderDust
	call UpdateTallGrassFlags
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_0F
	ret

.ok2
	call CopyCurCoordsToNextCoords
	jr .Strength_Stop

.on_pit
	call IncrementObjectMovementByteIndex
.Strength_Stop
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ret

.FollowNotExact
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld e, [hl]
	ld hl, OBJECT_RANGE
	add hl, bc
	ld a, [hl]
	push bc
	call GetObjectStruct
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .standing
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .equal
	; a = carry ? 2 : 3
	sbc a
	add 3
	jr .done

.equal
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp e
	jr z, .standing
	; a = carry ? 1 : 0
	sbc a
	and 1
.done
	ld d, a
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	and %00001100
	or d
	pop bc
	jp NormalStep

.standing
	pop bc
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_STAND
	ret

.MovementBigStanding
	call EndSpriteMovement
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_BIG_SNORLAX
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_04
	ret

.MovementBouncing
	call EndSpriteMovement
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_BOUNCE
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_04
	ret

.MovementAlternate:
	call EndSpriteMovement
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_ALTERNATE
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_04
	ret

.MovementSpinCounterclockwise
	call MovementAnonymousJumptable
	dw .MovementSpinInit
	dw .MovementSpinRepeat
	dw .MovementSpinTurnLeft

.MovementSpinClockwise
	call MovementAnonymousJumptable
	dw .MovementSpinInit
	dw .MovementSpinRepeat
	dw .MovementSpinTurnRight

.MovementSpinInit
	call EndSpriteMovement
	call IncrementObjectMovementByteIndex
.MovementSpinRepeat
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_STAND
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], $20
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_03
	jp IncrementObjectMovementByteIndex

.MovementSpinTurnLeft
	ld de, .DirectionData_Counterclockwise
	call .MovementSpinNextFacing
	jr .MovementSpinCounterclockwise

.DirectionData_Counterclockwise
	db OW_RIGHT, OW_LEFT, OW_DOWN, OW_UP

.MovementSpinTurnRight
	ld de, .DirectionData_Clockwise
	call .MovementSpinNextFacing
	jr .MovementSpinClockwise

.DirectionData_Clockwise
	db OW_LEFT, OW_RIGHT, OW_UP, OW_DOWN

.MovementSpinNextFacing
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	and %00001100
	rrca
	rrca
	push hl
	ld l, a
	ld h, 0
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	jp DecrementObjectMovementByteIndex

.MovementShadow
	call ._MovementShadow_Grass_Emote_BoulderDust
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_SHADOW
	ld hl, OBJECT_STEP_DURATION
	add hl, de
	ld a, [hl]
	inc a
	add a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, de
	ld a, [hl]
	and 3
	ld d, 1 * 8 + 6
	cp DOWN
	jr z, .ok_13
	cp UP
	jr z, .ok_13
	ld d, 1 * 8 + 4
.ok_13
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], d
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_TRACKING_OBJECT
	ret

.MovementEmote
	call EndSpriteMovement
	call ._MovementShadow_Grass_Emote_BoulderDust
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_EMOTE
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], -2 * 8
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_TRACKING_OBJECT
	ret

.MovementBoulderDust
	call EndSpriteMovement
	call ._MovementShadow_Grass_Emote_BoulderDust
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_BOULDER_DUST
	ld hl, OBJECT_STEP_DURATION
	add hl, de
	ld a, [hl]
	inc a
	add a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, de
	ld a, [hl]
	and %00000011
	ld e, a
	ld d, 0
	ld hl, .boulder_dust_coords
	add hl, de
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], d
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], e
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_TRACKING_OBJECT
	ret

.boulder_dust_coords
	;   x,  y
	db  0, -4
	db  0,  8
	db  6,  2
	db -6,  2

.MovementShakingGrass
	call EndSpriteMovement
	call ._MovementShadow_Grass_Emote_BoulderDust
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_GRASS_SHAKE
	ld hl, OBJECT_STEP_DURATION
	push hl
	add hl, de
	ld a, [hl]
	dec a
	pop hl
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_TRACKING_OBJECT
	ret

.MovementDeepSnow
	call EndSpriteMovement
	call ._MovementShadow_Grass_Emote_BoulderDust
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_SNOW
	ld hl, OBJECT_STEP_DURATION
	push hl
	add hl, de
	ld a, [hl]
	dec a
	pop hl
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_TRACKING_OBJECT
	ret

._MovementShadow_Grass_Emote_BoulderDust
	ld hl, OBJECT_RANGE
	add hl, bc
	ld a, [hl]
	push bc
	call GetObjectStruct
	ld d, b
	ld e, c
	pop bc
	ld hl, OBJECT_29
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

.MovementScreenShake
	call EndSpriteMovement
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_00
	ld hl, OBJECT_RANGE
	add hl, bc
	ld a, [hl]
	call ._MovementScreenShake
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], e
	ld hl, OBJECT_30
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_15
	ret

._MovementScreenShake
	ld d, a
	and %00111111
	ld e, a
	ld a, d
	rlca
	rlca
	and %00000011
	ld d, a
	inc d
	ld a, 1
.loop
	dec d
	ret z
	add a
	jr .loop
