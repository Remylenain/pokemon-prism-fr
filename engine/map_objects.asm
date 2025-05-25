DeleteMapObject::
	push bc
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	push af
	ld h, b
	ld l, c
	ld bc, OBJECT_STRUCT_LENGTH
	xor a
	call ByteFill
	pop af
	cp -1
	jr z, .ok
	bit 7, a
	jr nz, .ok
	call GetMapObject
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld [hl], -1
.ok
	pop bc
	ret

HandleCurNPCStep:
	call .CheckObjectStillVisible
	ret c
	call .HandleStepType
	jp .HandleObjectAction

.CheckObjectStillVisible
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res 6, [hl]
	ldh a, [hMapObjectIndexBuffer]
	and a
	jr nz, .notPlayer
; hardcode for crossing over connections
	ld a, [wYCoord]
	inc a
	ret z ;carry is clear here
	ld a, [wXCoord]
	inc a
	ret z
.notPlayer
	ld a, [wXCoord]
	ld e, a
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hl]
	inc a
	sub e
	jr c, .ok
	cp MAPOBJECT_SCREEN_WIDTH
	jr nc, .ok
	ld a, [wYCoord]
	ld e, a
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [hl]
	inc a
	sub e
	jr c, .ok
	cp MAPOBJECT_SCREEN_HEIGHT
	ccf
	ret nc

.ok
	ld hl, OBJECT_FLAGS2
	add hl, bc
	set 6, [hl]
	ld a, [wXCoord]
	ld e, a
	ld hl, OBJECT_INIT_X
	add hl, bc
	ld a, [hl]
	inc a
	sub e
	jr c, .ok2
	cp MAPOBJECT_SCREEN_WIDTH
	jr nc, .ok2
	ld a, [wYCoord]
	ld e, a
	ld hl, OBJECT_INIT_Y
	add hl, bc
	ld a, [hl]
	inc a
	sub e
	jr c, .ok2
	cp MAPOBJECT_SCREEN_HEIGHT
	ccf
	ret nc

.ok2
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit 1, [hl]
	jr nz, .yes
	call DeleteMapObject
	scf
	ret

.yes
	ld hl, OBJECT_FLAGS2
	add hl, bc
	set 6, [hl]
	and a
	ret

.HandleStepType
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld a, [hl]
	and a
	jr z, .null_step_type
	ld hl, OBJECT_FLAGS2
	add hl, bc
	bit OBJECT_DISABLE_STEP_TYPE, [hl]
	ret nz
	cp STEP_TYPE_SLEEP
	jr z, .map_object_movement_pattern
	jr .do_step_type

.null_step_type
	call ObjectMovementReset
	ld hl, OBJECT_FLAGS2
	add hl, bc
	bit OBJECT_DISABLE_STEP_TYPE, [hl]
	ret nz
.map_object_movement_pattern
	call MapObjectMovementPattern
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld a, [hl]
	and a
	ret z
	cp STEP_TYPE_SLEEP
	ret z
.do_step_type
	jumptable

; These pointers use OBJECT_STEP_TYPE.  See constants/sprite_constants.asm
	dw ObjectMovementReset ; 00
	dw MapObjectMovementPattern ; unused
	dw NPCStep ; 02 npc walk
	dw StepType03 ; 03
	dw StepType04 ; 04
	dw StepType05 ; 05
	dw PlayerStep ; 06 player walk
	dw StepType07 ; 07
	dw NPCJump ; 08 npc jump step
	dw PlayerJump ; 09 player jump step
	dw PlayerOrNPCTurnStep ; 0a half step
	dw StepTypeBump ; 0b
	dw TeleportFrom ; 0c teleport from
	dw TeleportTo ; 0d teleport to
	dw Skyfall ; 0e skyfall
	dw StepType0f ; 0f
	dw GotBiteStep ; 10
	dw RockSmashStep ; 11
	dw ReturnDigStep ; 12
	dw StepTypeTrackingObject ; 13
	dw StepType14 ; 14
	dw StepType15 ; 15
	dw StepType16 ; 16
	dw StepType17 ; 17
	dw StepType18 ; 18
	dw SkyfallTop ; 19
	dw FishingStep ; 1a

.HandleObjectAction
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit INVISIBLE, [hl]
	jr nz, HandleMapObjectAction_SetFacingStandingNonZero
	ld hl, OBJECT_FLAGS2
	add hl, bc
	bit 6, [hl]
	jr nz, HandleMapObjectAction_SetFacingStandingNonZero
	bit OBJECT_DISABLE_STEP_TYPE, [hl]
	jr nz, HandleMapObjectAction_SecondAnimationType
	ld de, MapObjectActionPointers
	jr HandleMapObjectAction_CallAction

HandleMapObjectAction_Stationary:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit INVISIBLE, [hl]
HandleMapObjectAction_SetFacingStandingNonZero:
	jp nz, SetFacingStanding
HandleMapObjectAction_SecondAnimationType:
	ld de, MapObjectActionPointers + 2
HandleMapObjectAction_CallAction:
	; call [4 * wObjectStructs[ObjInd, OBJECT_ACTION] + de]
	ld hl, OBJECT_ACTION
	add hl, bc
	ld a, [hl]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, de
	jp CallLocalPointer

CopyNextCoordsTileToStandingCoordsTile:
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_STANDING_TILE
	add hl, bc
	ld [hl], a
	jp SetTallGrassFlags

CopyCurCoordsToNextCoords:
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld [hl], a
	ret

UpdateTallGrassFlags:
	ld hl, OBJECT_FLAGS2
	add hl, bc
	bit 3, [hl] ; is current tile grass?
	ret z
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld a, [hl]

SetTallGrassFlags:
	cp COLL_SUPER_TALL_GRASS
	jr z, .set
	call CheckGrassTile
	jr nc, .set
	ld a, d
	cp COLL_SNOW
	jr nz, .reset
.set
	ld hl, OBJECT_FLAGS2
	add hl, bc
	set 3, [hl]
	ret

.reset
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res 3, [hl]
	ret

EndSpriteMovement:
	xor a
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a ; OBJECT_30
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ret

InitStep:
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit FIXED_FACING, [hl]
	jr nz, GetNextTile
	add a
	add a
	and %00001100
	call PlayerSidescrollMovingDownOnLadderCheck
	ld hl, OBJECT_FACING
	add hl, bc
	ld [hl], a
	; fallthrough
GetNextTile:
	call GetStepVector
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], a
	ld a, d
	call GetStepVectorSign
	ld hl, OBJECT_MAP_X
	add hl, bc
	add [hl]
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld [hl], a
	ld d, a
	ld a, e
	call GetStepVectorSign
	ld hl, OBJECT_MAP_Y
	add hl, bc
	add [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld [hl], a
	ld e, a
	push bc
	call GetCoordTile
	pop bc
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld [hl], a
	ret

PlayerSidescrollMovingDownOnLadderCheck:
	push de
	ld d, a
	call .PlayerSidescrollMovingDownOnLadderCheck
	ld a, d
	pop de
	ret nz
	ld a, OW_UP
	ret

.PlayerSidescrollMovingDownOnLadderCheck:
	cp OW_DOWN
	ret nz
	ld a, [wTileset]
	cp TILESET_SIDESCROLL
	ret nz
	ldh a, [hMapObjectIndexBuffer]
	and a
	ret nz
	ld a, [wTileDown]
	and a
	ret

AddStepVector:
	call GetStepVector
	jr nc, .okay
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	and 1
	jr nz, .okay
	ld d, a ;lb de, 0, 0
	ld e, a
.okay
	ld hl, OBJECT_SPRITE_X
	add hl, bc
	ld a, [hl]
	add d
	ld [hl], a
	ld hl, OBJECT_SPRITE_Y
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	ret

GetStepVector:
; Return (x, y, duration, speed) in (d, e, a, h).
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	and %00001111
	add a
	add a
	ld l, a
	ld h, 0
	ld de, StepVectors
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	push af
	push hl
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	cp (STEP_SLOW << 2 | RIGHT) + 1
	jr c, .slowStep
	pop hl
	pop af
	and a
	ret
.slowStep
	pop hl
	pop af
	scf
	ret

StepVectors:
; x,  y, duration, speed
	; slow
	db  0,  1, 32, 1
	db  0, -1, 32, 1
	db -1,  0, 32, 1
	db  1,  0, 32, 1
	; normal
	db  0,  1, 16, 1
	db  0, -1, 16, 1
	db -1,  0, 16, 1
	db  1,  0, 16, 1
	; fast
	db  0,  4,  4, 4
	db  0, -4,  4, 4
	db -4,  0,  4, 4
	db  4,  0,  4, 4
	; running shoes
	db  0,  2,  8, 2
	db  0, -2,  8, 2
	db -2,  0,  8, 2
	db  2,  0,  8, 2

GetStepVectorSign:
	add a
	ret z  ; 0 or 128
	ld a, 1
	ret nc ; 1 - 127
	ld a, -1
	ret    ; 129 - 255

UpdatePlayerStep:
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	and %00000011
	ld [wPlayerStepDirection], a
	call AddStepVector
	ld a, [wPlayerStepVectorX]
	add d
	ld [wPlayerStepVectorX], a
	ld a, [wPlayerStepVectorY]
	add e
	ld [wPlayerStepVectorY], a
	ld hl, wPlayerStepFlags
	set 5, [hl]
	ret

RestoreDefaultMovement:
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	cp -1
	jr z, .ok
	push bc
	call GetMapObject
	ld hl, MAPOBJECT_MOVEMENT
	add hl, bc
	ld a, [hl]
	pop bc
	ret

.ok
	ld a, SPRITEMOVEFN_STANDING
	ret

ClearObjectMovementByteIndex:
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	ld [hl], 0
	ret

IncrementObjectMovementByteIndex:
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	inc [hl]
	ret

DecrementObjectMovementByteIndex:
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	dec [hl]
	ret

MovementAnonymousJumptable:
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	ld a, [hl]
	jp Jumptable

ClearObjectStructField28:
	ld hl, OBJECT_28
	add hl, bc
	ld [hl], 0
	ret

IncrementObjectStructField28:
	ld hl, OBJECT_28
	add hl, bc
	inc [hl]
	ret

Object28AnonymousJumptable:
	ld hl, OBJECT_28
	add hl, bc
	ld a, [hl]
	jp Jumptable

GetValueObjectStructField28:
	ld hl, OBJECT_28
	add hl, bc
	ld a, [hl]
	ret

SetValueObjectStructField28:
	ld hl, OBJECT_28
	add hl, bc
	ld [hl], a
	ret

ObjectMovementReset:
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld e, [hl]
	push bc
	call GetCoordTile
	pop bc
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld [hl], a
	call CopyNextCoordsTileToStandingCoordsTile
	call EndSpriteMovement
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

RandomStepDuration_Slow:
	ld h, $fe
	jr SetRandomStepDuration

RandomStepDuration_Fast:
	ld h, $3e
SetRandomStepDuration:
	call Random
	and h
	jr z, SetRandomStepDuration
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_STAND
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_03
	ret

WaitStep_InPlace:
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

NPCJump:
	call Object28AnonymousJumptable
; anonymous dw
	dw .Jump
	dw .Land

.Jump
	call AddStepVector
	call UpdateJumpPosition
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call CopyNextCoordsTileToStandingCoordsTile
	call GetNextTile
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res 3, [hl]
	jp IncrementObjectStructField28

.Land
	call AddStepVector
	call UpdateJumpPosition
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call CopyNextCoordsTileToStandingCoordsTile
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

PlayerJump:
	call Object28AnonymousJumptable
; anonymous dw
	dw .initjump
	dw .stepjump
	dw .initland
	dw .stepland

.initjump
	ld hl, wPlayerStepFlags
	set 7, [hl]
	call IncrementObjectStructField28
.stepjump
	call UpdateJumpPosition
	call UpdatePlayerStep
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call CopyNextCoordsTileToStandingCoordsTile
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res 3, [hl]
	ld hl, wPlayerStepFlags
	set 6, [hl]
	set 4, [hl]
	jp IncrementObjectStructField28

.initland
	call GetNextTile
	ld hl, wPlayerStepFlags
	set 7, [hl]
	call IncrementObjectStructField28
.stepland
	call UpdateJumpPosition
	call UpdatePlayerStep
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, wPlayerStepFlags
	set 6, [hl]
	call CopyNextCoordsTileToStandingCoordsTile
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

TeleportFrom:
	call Object28AnonymousJumptable
; anonymous dw
	dw .InitSpin
	dw .DoSpin
	dw .InitSpinRise
	dw .DoSpinRise

.InitSpin
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 32
	call IncrementObjectStructField28
.DoSpin
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_SPIN
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	jp IncrementObjectStructField28

.InitSpinRise
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_31
	add hl, bc
	ld [hl], $20
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 32
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res 3, [hl]
	call IncrementObjectStructField28
.DoSpinRise
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_SPIN
	ld hl, OBJECT_31
	add hl, bc
	inc [hl]
	ld a, [hl]
	srl a
	ld d, $60
	call Sine
	ld a, h
	sub $60
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

TeleportTo:
	call Object28AnonymousJumptable
; anonymous dw
	dw .InitWait
	dw .DoWait
	dw .InitDescent
	dw .DoDescent
	dw .InitFinalSpin
	dw .DoFinalSpin
	dw .FinishStep

.InitWait
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_00
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 32
	jp IncrementObjectStructField28

.DoWait
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call IncrementObjectStructField28
.InitDescent
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_31
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 32
	jp IncrementObjectStructField28

.DoDescent
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_SPIN
	ld hl, OBJECT_31
	add hl, bc
	inc [hl]
	ld a, [hl]
	srl a
	ld d, $60
	call Sine
	ld a, h
	sub $60
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call IncrementObjectStructField28
.InitFinalSpin
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 32
	jp IncrementObjectStructField28

.DoFinalSpin
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_SPIN
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
.FinishStep
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

Skyfall:
	call Object28AnonymousJumptable
; anonymous dw
	dw .Init
	dw .Step
	dw .Fall
	dw .Finish

.Init
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_00
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 16
	call IncrementObjectStructField28
.Step
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_STEP
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_31
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 16
	call IncrementObjectStructField28
.Fall
	ld hl, OBJECT_31
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld d, $60
	call Sine
	ld a, h
	sub $60
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call IncrementObjectStructField28
.Finish
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

FishingStep:
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ret

.done
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ld hl, OBJECT_ACTION
	add hl, bc
	ld a, [hl]
	cp PERSON_ACTION_FISHING
	ret z
	ld [hl], PERSON_ACTION_STAND
	ret

GotBiteStep:
	call Object28AnonymousJumptable
; anonymous dw
	dw .Init
	dw .Run

.Init
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 8
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], 0
	call IncrementObjectStructField28
.Run
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld a, [hl]
	xor 1
	ld [hl], a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

RockSmashStep:
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	and %00000001
	ld a, PERSON_ACTION_STAND
	jr z, .yes
	ld a, PERSON_ACTION_00
.yes
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], a
	jp WaitStep_InPlace

ReturnDigStep:
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	and %00000001
	ld a, PERSON_ACTION_SPIN
	jr z, .yes
	ld a, PERSON_ACTION_SPIN_FLICKER
.yes
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], a
	jp WaitStep_InPlace

StepType03:
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

StepType18:
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	jp DeleteMapObject

StepTypeBump:
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

StepType05:
	call Object28AnonymousJumptable
; anonymous dw
	dw .Reset
	dw StepType04

.Reset
	call RestoreDefaultMovement
	call GetInitialFacing
	ld hl, OBJECT_FACING
	add hl, bc
	ld [hl], a
	call IncrementObjectStructField28
StepType04:
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ret

NPCStep:
	call AddStepVector
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call CopyNextCoordsTileToStandingCoordsTile
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

StepType07:
	call AddStepVector
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call CopyNextCoordsTileToStandingCoordsTile
	jp RandomStepDuration_Slow

PlayerStep:
; AnimateStep?
	call Object28AnonymousJumptable
; anonymous dw
	dw .init
	dw .step

.init
	ld hl, wPlayerStepFlags
	set 7, [hl]
	call IncrementObjectStructField28
.step
	call UpdatePlayerStep
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, wPlayerStepFlags
	set 6, [hl]
	call CopyNextCoordsTileToStandingCoordsTile
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

PlayerOrNPCTurnStep:
	call Object28AnonymousJumptable
; anonymous dw
	dw .init1
	dw .step1
	dw .init2
	dw .step2

.init1
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	ld [hl], 2
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	call .GetTurningSpeed
	ld [hl], a
	call IncrementObjectStructField28
.step1
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	call IncrementObjectStructField28
.init2
	ld hl, OBJECT_29 ; new facing
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_FACING
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	call .GetTurningSpeed
	ld [hl], a
	call IncrementObjectStructField28
.step2
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

.GetTurningSpeed:
	ld a, [wOptions]
	bit TURNING_SPEED, a
	ld a, 4
	ret z
	ld a, 2
	ret

StepType0f:
	call AddStepVector
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	push bc
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld e, [hl]
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	ld b, a
	callba CopyDECoordsToMapObject
	pop bc
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res 2, [hl]
	call CopyNextCoordsTileToStandingCoordsTile
	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

StepTypeTrackingObject:
	ld hl, OBJECT_29
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, OBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .nope
	ld hl, OBJECT_SPRITE_X
	add hl, de
	ld a, [hl]
	ld hl, OBJECT_SPRITE_X
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_SPRITE_Y
	add hl, de
	ld a, [hl]
	ld hl, OBJECT_SPRITE_Y
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
.nope
	jp DeleteMapObject

StepType14:
StepType15:
	call Object28AnonymousJumptable
; anonymous dw
	dw .Init
	dw .Run

.Init
	xor a
	ld hl, OBJECT_29
	add hl, bc
	ld [hl], a
	call IncrementObjectStructField28
.Run
	ld hl, OBJECT_29
	add hl, bc
	ld d, [hl]
	ld a, [wPlayerStepVectorY]
	sub d
	ld [wPlayerStepVectorY], a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	jp z, DeleteMapObject
	ld a, [hl]
	call .GetSign
	ld hl, OBJECT_29
	add hl, bc
	ld [hl], a
	ld d, a
	ld a, [wPlayerStepVectorY]
	add d
	ld [wPlayerStepVectorY], a
	ret

.GetSign
	ld hl, OBJECT_30
	add hl, bc
	and %11
	ld a, [hl]
	ret z
	cpl
	inc a
	ret

StepType16:
	; clearly bugged, using code as data. Commenting out.
	;call Object28AnonymousJumptable
StepType17:
	; bugged as well, had a useless jumptable pointing right into the next function through all of its entries
	; fallthrough

SkyfallTop:
	call Object28AnonymousJumptable
; anonymous dw
	dw .Init
	dw .Run

.Init
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], PERSON_ACTION_SKYFALL
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld [hl], 16
	call IncrementObjectStructField28

.Run
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	dec [hl]
	ret nz
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], $60
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_SLEEP
	ret

UpdateJumpPosition:
	call GetStepVector
	ld a, h
	ld hl, OBJECT_31
	add hl, bc
	ld e, [hl]
	add e
	ld [hl], a
	srl e
	ld d, 0
	ld hl, .y
	add hl, de
	ld a, [hl]
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], a
	ret

.y
	db  -4,  -6,  -8, -10, -11, -12, -12, -12
	db -11, -10,  -9,  -8,  -6,  -4,   0,   0

GetNextPlayerMovement:
; copy [wPlayerNextMovement] to [wPlayerMovement]
	ld a, [wPlayerNextMovement]
	ld hl, wPlayerMovement
	ld [hl], a
; load [wPlayerNextMovement] with movement_step_sleep_1
	ld a, movement_step_sleep_1
	ld [wPlayerNextMovement], a
; recover the previous value of [wPlayerNextMovement]
	ld a, [hl]
	ret

GetMovementByte:
	ld hl, wMovementDataPointer
	jp _GetMovementByte

GetNextBufferedMovement1:
	ld hl, wMovementBuffer1
	jr GetNextBufferedMovement

GetNextBufferedMovement2:
	ld hl, wMovementBuffer2
GetNextBufferedMovement:
	push hl
	ld hl, OBJECT_MOVEMENT_BYTE_INDEX
	add hl, bc
	ld e, [hl]
	inc [hl]
	ld d, 0
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld a, [hl]
	ret

GetMovementPerson:
	ld a, [wMovementPerson]
	ret

_GetMovementPerson:
	ld hl, GetMovementPerson
	; fallthrough

HandleMovementData:
	ld a, l
	ld [wMovementPointer], a
	ld a, h
	ld [wMovementPointer + 1], a
.loop
	xor a
	ld [wMovementByteWasControlSwitch], a
	call JumpMovementPointer
	call DoMovementFunction
	ld a, [wMovementByteWasControlSwitch]
	and a
	jr nz, .loop
	ret

JumpMovementPointer:
	ld hl, wMovementPointer
	jp CallLocalPointer

ContinueReadingMovement:
	ld a, 1
	ld [wMovementByteWasControlSwitch], a
	ret

DoMovementFunction:
	push af
	call ApplyMovementToFollower
	pop af
	jumptable MovementPointers
	ret

ApplyMovementToFollower:
	ld e, a
	ld a, [wObjectFollow_Follower]
	inc a
	ret z
	ld a, [wObjectFollow_Leader]
	ld d, a
	ldh a, [hMapObjectIndexBuffer]
	cp d
	ret nz
	ld a, e
	cp movement_step_sleep_1
	ret z
	cp movement_step_end
	ret z
	cp movement_step_stop
	ret z
	cp movement_step_bump
	ret z
	cp movement_turn_step_right + 1
	ret c
	push af
	ld hl, wFollowerMovementQueueLength
	inc [hl]
	ld e, [hl]
	ld d, 0
	ld hl, wFollowMovementQueue
	add hl, de
	pop af
	ld [hl], a
	ret

GetFollowerNextMovementByte:
	ld hl, wFollowerMovementQueueLength
	ld a, [hl]
	and a
	jr z, .done
	inc a
	jr z, .done
	dec [hl]
	ld e, a
	ld d, 0
	ld hl, wFollowMovementQueue
	add hl, de
	inc e
	ld a, -1
.loop
	ld d, [hl]
	ld [hld], a
	ld a, d
	dec e
	jr nz, .loop
	ret

.done
	call .CancelFollowIfLeaderMissing
	ret c
	ld a, movement_step_sleep_1
	ret

.CancelFollowIfLeaderMissing
	ld a, [wObjectFollow_Leader]
	cp -1
	jr z, .nope
	push bc
	call GetObjectStruct
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	pop bc
	and a
	jr z, .nope
	and a
	ret

.nope
	ld a, -1
	ld [wObjectFollow_Follower], a
	ld a, movement_step_end
	scf
	ret

SpawnShadow:
	push bc
	ld de, .ShadowObject
	call CopyTempObjectData
	call InitTempObject
	pop bc
	ret

.ShadowObject
	; vtile, palette, movement
	db $00, PAL_OW_SILVER, SPRITEMOVEDATA_SHADOW

SpawnStrengthBoulderDust:
	push bc
	ld de, .BoulderDustObject
	call CopyTempObjectData
	call InitTempObject
	pop bc
	ret

.BoulderDustObject
	db $00, PAL_OW_SILVER, SPRITEMOVEDATA_BOULDERDUST

SpawnEmote:
	ld a, [wPlayEmoteSFX]
	and a
	ld a, 0
	ld [wPlayEmoteSFX], a
	jr z, .skip
	ld a, [wEmoteSFX]
	ld e, a
	ld a, [wEmoteSFX + 1]
	ld d, a
	call WaitPlaySFX
.skip
	push bc
	ld de, .EmoteObject
	call CopyTempObjectData
	call InitTempObject
	pop bc
	ret

.EmoteObject
	db $00, PAL_OW_SILVER, SPRITEMOVEDATA_EMOTE

DeepSnow:
	push bc
	ld de, .SnowObject
	call CopyTempObjectData
	call InitTempObject
	pop bc
	ret

.SnowObject
	db $00, PAL_OW_SILVER, SPRITEMOVEDATA_SNOW

ShakeGrass:
	push bc
	ld de, .GrassShakeObject
	call CopyTempObjectData
	call InitTempObject
	pop bc
	ret

.GrassShakeObject
	db $00, PAL_OW_GREEN, SPRITEMOVEDATA_GRASS

ShakeScreen:
	push bc
	push af
	ld de, .ScreenShakeObject
	call CopyTempObjectData
	pop af
	ld [wTempObjectCopyRange], a
	call InitTempObject
	pop bc
	ret

.ScreenShakeObject
	db $00, PAL_OW_SILVER, SPRITEMOVEDATA_SCREENSHAKE

DespawnEmote:
	push bc
	ldh a, [hMapObjectIndexBuffer]
	ld c, a
	call .DeleteEmote
	pop bc
	ret

.DeleteEmote
	ld de, wObjectStructs
	ld a, NUM_OBJECT_STRUCTS
.loop
	push af
	ld hl, OBJECT_FLAGS1
	add hl, de
	bit EMOTE_OBJECT, [hl]
	jr z, .next
	ld hl, OBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
	push bc
	xor a
	ld bc, OBJECT_STRUCT_LENGTH
	call ByteFill
	pop bc
.next
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, de
	ld d, h
	ld e, l
	pop af
	dec a
	jr nz, .loop
	ret

InitTempObject:
	call FindFirstEmptyObjectStruct
	ret nc
	ld d, h
	ld e, l
	jpba CopyTempObjectToObjectStruct

CopyTempObjectData:
; load into wTempObjectCopy:
; -1, -1, [de], [de + 1], [de + 2], [hMapObjectIndexBuffer], [NextMapX], [NextMapY], -1
; This spawns the object at the same place as whichever object is loaded into bc.
	ld hl, wTempObjectCopyMapObjectIndex
	ld a, -1
	ld [hli], a
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ldh a, [hMapObjectIndexBuffer]
	ld [hli], a
	push hl
	assert OBJECT_NEXT_MAP_Y == (OBJECT_NEXT_MAP_X + 1)
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hli]
	ld e, [hl]
	pop hl
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], -1
	ret

UpdateMapObjectDataAndSprites::
	ld bc, wObjectStructs
	xor a
.loop
	ldh [hMapObjectIndexBuffer], a
	call GetObjectSprite
	call nz, UpdateCurObjectData
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ldh a, [hMapObjectIndexBuffer]
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	jp _UpdateSprites

BattleStart_HideAllSpritesExceptBattleParticipants:
	; called at battle start
	call MaskAllObjectStructs ; clear sprites
	ld a, PLAYER
	call RespawnObject ; respawn player
	ld a, [wBattleScriptFlags]
	add a, a
	jr nc, .ok
	ldh a, [hLastTalked]
	and a
	call nz, RespawnObject ; respawn opponent
.ok
	jp _UpdateSprites

ReturnFromFly_SpawnOnlyPlayer:
	call MaskAllObjectStructs ; clear sprites
	ld a, PLAYER
	call RespawnObject ; respawn player
	jp _UpdateSprites

RespawnObject:
	ldh [hMapObjectIndexBuffer], a
	cp NUM_OBJECTS
	ret nc
	call GetMapObject
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	assert NUM_OBJECT_STRUCTS < $ff
	cp NUM_OBJECT_STRUCTS
	ret nc
	call GetObjectStruct
	call GetObjectSprite
	ret z
	call IsObjectOnScreen
	jr c, SetFacing_Standing
	call HandleMapObjectAction_Stationary
	xor a
	ret

MaskAllObjectStructs:
	xor a
	ld bc, wObjectStructs
.loop
	ldh [hMapObjectIndexBuffer], a
	call SetFacing_Standing
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ldh a, [hMapObjectIndexBuffer]
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	ret

UpdateCurObjectData:
	push bc
	call CheckCurSpriteCoveredByTextBox
	pop bc
	jr c, SetFacing_Standing
	call IsObjectOnScreen
	jr c, SetFacing_Standing
	push bc
	assert OBJECT_NEXT_MAP_Y == (OBJECT_NEXT_MAP_X + 1)
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld d, [hl]
	inc hl
	ld e, [hl]
	call GetCoordTile
	pop bc
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld [hl], a
	call UpdateTallGrassFlags
	call HandleMapObjectAction_Stationary
	xor a
	ret

SetFacing_Standing:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], STANDING
	scf
	ret

IsObjectOnScreen:
	assert OBJECT_NEXT_MAP_Y == (OBJECT_NEXT_MAP_X + 1)
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hli]
	ld d, a
	ld e, [hl]
	inc d
	inc e
	ld a, [wXCoord]
	cp d
	jr z, .equal_x
	ccf
	ret c
	add SCREEN_WIDTH / 2 + 1
	cp d
	ret c
.equal_x
	ld a, [wYCoord]
	cp e
	jr z, .equal_y
	ccf
	ret c
	add SCREEN_HEIGHT / 2 + 1
	cp e
	ret c
.equal_y
	xor a
	ret

CheckCurSpriteCoveredByTextBox:
; x coord
	ld a, [wMapObjectGlobalOffsetX]
	ld d, a
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_SPRITE_X
	add hl, bc
	add [hl]
	add d
	cp -2 * 8
	jr nc, .on_screen_horizontally
	cp SCREEN_WIDTH * 8
	ccf
	ret c
.on_screen_horizontally
	ld d, 2
	bit 2, a
	jr z, .got_X_pixel
	inc d
.got_X_pixel
	ld a, [hl]
	rrca
	rrca
	rrca
	and $1f
	cp SCREEN_WIDTH
	jr c, .got_X_coord
	sub $20
.got_X_coord
	ldh [hCurSpriteXCoord], a
; y coord
	ld a, [wMapObjectGlobalOffsetY]
	ld e, a
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_SPRITE_Y
	add hl, bc
	add [hl]
	add e
	cp -2 * 8
	jr nc, .on_screen_vertically
	cp SCREEN_HEIGHT * 8
	ccf
	ret c
.on_screen_vertically
	ld e, 2
	bit 2, a
	jr z, .got_Y_pixel
	inc e
.got_Y_pixel
	ld a, [hl]
	rrca
	rrca
	rrca
	and $1f
	cp SCREEN_HEIGHT
	jr c, .got_Y_coord
	sub $20
.got_Y_coord
	ldh [hCurSpriteYCoord], a
	ld hl, OBJECT_PALETTE
	add hl, bc
	bit OAM_PRIORITY, [hl]
	jr z, .no_priority
	inc d
	inc d
	inc e
	inc e
.no_priority
	ld a, d
	ldh [hCurSpriteXPixel], a
.vertical_loop
	ldh a, [hCurSpriteXPixel]
	ld d, a
	ldh a, [hUsedSpriteTile]
	add a, e
	dec a
	cp SCREEN_HEIGHT
	jr nc, .vertical_handle_loop
	ld b, a
.horizontal_loop
	ldh a, [hUsedSpriteIndex]
	add a, d
	dec a
	cp SCREEN_WIDTH
	jr nc, .horizontal_handle_loop
	ld c, a
	push bc
	call Coord2Tile
	pop bc
	ld a, [hl]
	cp LEAST_TEXT_CHAR
	ccf
	ret c
.horizontal_handle_loop
	dec d
	jr nz, .horizontal_loop
.vertical_handle_loop
	dec e
	jr nz, .vertical_loop
	and a
	ret

HandleNPCStep::
	call .ResetStepVector
	xor a
	ld bc, wObjectStructs
.loop
	ldh [hMapObjectIndexBuffer], a
	call GetObjectSprite
	call nz, HandleCurNPCStep
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ldh a, [hMapObjectIndexBuffer]
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	ret

.ResetStepVector
	xor a
	ld [wPlayerStepVectorX], a
	ld [wPlayerStepVectorY], a
	ld a, [wPlayerStepFlags]
	bit 6, a
	ld a, 0
	ld [wPlayerStepFlags], a
	ret nz
	dec a
	ld [wPlayerStepDirection], a
	ret

RefreshPlayerSprite:
	ld a, movement_step_sleep_1
	ld [wPlayerNextMovement], a
	ld [wPlayerMovement], a
	xor a
	ld [wPlayerMovementDirection], a
	ld [wPlayerObjectStepFrame], a
	call .TryResetPlayerAction
	callba CheckWarpFacingDown
	call c, SpawnInFacingDown
	ld hl, wPlayerSpriteSetupFlags
	bit 5, [hl]
	ret z
	ld a, [wPlayerSpriteSetupFlags]
	and 3
	add a, a
	add a, a
	jr ContinueSpawnFacing

.TryResetPlayerAction
	ld hl, wPlayerSpriteSetupFlags
	bit 7, [hl]
	ret z
	xor a
	ld [wPlayerAction], a
	ret

SpawnInFacingDown:
	xor a
	; fallthrough
ContinueSpawnFacing:
	ld bc, wPlayerStruct
	jp SetSpriteDirection

SetPlayerPalette:
	bit 7, d
	ret z
	ld a, d
	swap a
	and %00000111
	ld d, a
	ld bc, wPlayerStruct
	ld hl, OBJECT_PALETTE
	add hl, bc
	ld a, [hl]
	and %11111000
	or d
	ld [hl], a
	ret

StartFollow::
	push bc
	ld a, b
	call SetLeaderIfVisible
	pop bc
	ret c
	ld a, c
	call SetFollowerIfVisible
	jpba QueueFollowerFirstStep

SetLeaderIfVisible:
	call CheckObjectVisibility
	ret c
	ldh a, [hObjectStructIndexBuffer]
	ld [wObjectFollow_Leader], a
	ret

StopFollow::
	ld a, -1
	ld [wObjectFollow_Leader], a
	; fallthrough
ResetFollower:
	ld a, [wObjectFollow_Follower]
	cp -1
	ret z
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	cp -1
	jr z, .not_map_object
	push bc
	call GetMapObject
	ld hl, MAPOBJECT_MOVEMENT
	add hl, bc
	ld a, [hl]
	pop bc
	jr .finish

.not_map_object
	call SpriteDirectionToMapMovement
.finish
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_00
	ld a, -1
	ld [wObjectFollow_Follower], a
	ret

SetFollowerIfVisible:
	push af
	call ResetFollower
	pop af
	call CheckObjectVisibility
	ret c
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld [hl], SPRITEMOVEDATA_FOLLOWING
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_00
	ldh a, [hObjectStructIndexBuffer]
	ld [wObjectFollow_Follower], a
	ret

SetFlagsForMovement_1::
	ld a, c
	call CheckObjectVisibility
	ret c
	push bc
	ld bc, wObjectStructs
	xor a
.loop
	push af
	call GetObjectSprite
	jr z, .next
	ld hl, OBJECT_FLAGS2
	add hl, bc
	set OBJECT_DISABLE_STEP_TYPE, [hl]
.next
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop af
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	pop bc
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res OBJECT_DISABLE_STEP_TYPE, [hl]
	xor a
	ret

SetFlagsForMovement_2::
	ld a, [wObjectFollow_Leader]
	cp -1
	ret z
	push bc
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	pop bc
	cp c
	ret nz
	ld a, [wObjectFollow_Follower]
	cp -1
	ret z
	call GetObjectStruct
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res OBJECT_DISABLE_STEP_TYPE, [hl]
	ret

ReleaseAllMapObjects::
	push bc
	ld bc, wObjectStructs
	xor a
.loop
	push af
	call GetObjectSprite
	call nz, ReleaseCurMapObject
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop af
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	pop bc
	ret

ReleaseCurMapObject:
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res OBJECT_DISABLE_STEP_TYPE, [hl]
	ret

_UpdateSprites::
	ld a, [wVramState]
	rra
	ret nc
	xor a
	ldh [hUsedSpriteIndex], a
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	call InitSprites
	call .fill
	pop af
	ldh [hOAMUpdate], a
	ret

.fill
	ld a, [wVramState]
	bit 1, a
	ld b, LOW(wSpritesEnd)
	jr z, .ok
	ld b, 28 * 4
.ok
	ldh a, [hUsedSpriteIndex]
	cp b
	ret nc
	ld l, a
	ld h, HIGH(wSprites)
	ld de, 4
	ld a, b
	ld c, SCREEN_HEIGHT_PX + 16
.loop
	ld [hl], c
	add hl, de
	cp l
	jr nz, .loop
	ret

ReanchorOverworldSprites:
	push hl
	push de
	push bc
	ld a, [wMapObjectGlobalOffsetX]
	ld d, a
	ld a, [wMapObjectGlobalOffsetY]
	ld e, a
	ld bc, wObjectStructs
	ld a, NUM_OBJECT_STRUCTS
.loop
	push af
	call GetObjectSprite
	jr z, .skip
	ld hl, OBJECT_SPRITE_X
	add hl, bc
	ld a, [hl]
	add d
	ld [hl], a
	ld hl, OBJECT_SPRITE_Y
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
.skip
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop af
	dec a
	jr nz, .loop
	xor a
	ld [wMapObjectGlobalOffsetX], a
	ld [wMapObjectGlobalOffsetY], a
	pop bc
	pop de
	pop hl
	ret

InitSprites:
PRIORITY_LOW  EQU $10
PRIORITY_NORM EQU $20
PRIORITY_HIGH EQU $30
	call .DeterminePriorities
	ld c, PRIORITY_HIGH
	call .InitSpritesByPriority
	ld c, PRIORITY_NORM
	call .InitSpritesByPriority
	ld c, PRIORITY_LOW
	jp .InitSpritesByPriority

.DeterminePriorities
	xor a
	ld hl, wMovementPointer
	ld bc, NUM_OBJECT_STRUCTS
	call ByteFill
	ld d, 0
	ld bc, wObjectStructs
	ld hl, wMovementPointer
.loop
	push hl
	call GetObjectSprite
	jr z, .skip
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .skip
; Define the sprite priority.
	ld e, PRIORITY_LOW
	ld hl, OBJECT_FLAGS2
	add hl, bc
	bit OBJECT_PRIORITY_LOW, [hl]
	jr nz, .add
	ld e, PRIORITY_NORM
	bit OBJECT_PRIORITY_HIGH, [hl]
	jr z, .add
	ld e, PRIORITY_HIGH
	jr .add

.skip
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	jr .next

.add
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, d
	or e
	ld [hli], a
.next
	inc d
	ld a, d
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	ret

.InitSpritesByPriority
	ld hl, wMovementPointer
.next_sprite
	ld a, [hli]
	ld d, a
	and $f0
	ret z
	cp c
	jr nz, .next_sprite
	push bc
	push hl
	ld a, d
	and $f
	call .GetObjectStructPointer
	call .InitSprite
	pop hl
	pop bc
	jr .next_sprite

.InitSprite
	ld hl, OBJECT_SPRITE_TILE
	add hl, bc
	ld a, [hl]
	and %01111111
	ldh [hCurSpriteTile], a
	xor a
	bit 7, [hl]
	jr nz, .skip1
	or %00001000
.skip1
	ld hl, OBJECT_FLAGS2
	add hl, bc
	ld e, [hl]
	bit 7, e
	jr z, .skip2
	or %10000000
.skip2
	bit 4, e
	jr z, .skip3
	or %00010000
.skip3
	ld hl, OBJECT_PALETTE
	add hl, bc
	ld d, a
	ld a, [hl]
	and %00000111
	or d
	ld d, a
	xor a
	bit 3, e
	jr z, .skip4
	or %10000000
.skip4
	ldh [hCurSpriteOAMFlags], a
	ld hl, OBJECT_SPRITE_X
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	add [hl]
	add 8
	ld e, a
	ld a, [wMapObjectGlobalOffsetX]
	add e
	ldh [hCurSpriteXPixel], a
	ld hl, OBJECT_SPRITE_Y
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	add [hl]
	add 12
	ld e, a
	ld a, [wMapObjectGlobalOffsetY]
	add e
	ldh [hCurSpriteYPixel], a
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld a, [hl]
	cp STANDING
	jp z, .done
	cp NUM_FACINGS
	jp nc, .done
	ld l, a
	ld h, 0
	add hl, hl
	ld bc, Facings
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hUsedSpriteIndex]
	ld c, a
	ld b, HIGH(wSprites)
	ld a, [hli]
	ldh [hUsedSpriteTile], a
	add c
	cp LOW(wSpritesEnd)
	jr nc, .full
.addsprite
	ldh a, [hCurSpriteYPixel]
	add [hl]
	inc hl
	ld [bc], a
	inc c
	ldh a, [hCurSpriteXPixel]
	add [hl]
	inc hl
	ld [bc], a
	inc c
	ld e, [hl]
	inc hl
	ldh a, [hCurSpriteTile]
	bit 2, e
	jr z, .nope1
	xor a
.nope1
	add [hl]
	inc hl
	ld [bc], a
	inc c
	ld a, e
	bit 1, a
	jr z, .nope2
	ldh a, [hCurSpriteOAMFlags]
	or e
.nope2
	and %11110000
	or d
	ld [bc], a
	inc c
	ldh a, [hUsedSpriteTile]
	dec a
	ldh [hUsedSpriteTile], a
	jr nz, .addsprite
	ld a, c
	ldh [hUsedSpriteIndex], a
.done
	xor a
	ret

.full
	scf
	ret

.GetObjectStructPointer
	ld c, a
	ld b, 0
	ld hl, .Addresses
	add hl, bc
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ret

.Addresses
	dw wPlayerStruct
	dw wObject1Struct
	dw wObject2Struct
	dw wObject3Struct
	dw wObject4Struct
	dw wObject5Struct
	dw wObject6Struct
	dw wObject7Struct
	dw wObject8Struct
	dw wObject9Struct
	dw wObject10Struct
	dw wObject11Struct
	dw wObject12Struct

FreezeTrainerFacing:
	; Load map object pointer into bc
	ldh a, [hLastTalked]
	call GetMapObject
	; Save the map object pointer, and load the object struct pointer into bc
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	push bc
	call GetObjectStruct
	; Stop the spinning
	call SpriteDirectionToMapMovement
	ld hl, OBJECT_MOVEMENTTYPE
	add hl, bc
	ld [hl], a
	; Make sure the person don't start spinning again until the player reloads the map.
	pop bc
	ld hl, MAPOBJECT_MOVEMENT
	add hl, bc
	ld [hl], a
	ret
