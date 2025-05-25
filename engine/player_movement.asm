DoPlayerMovement::
	call .GetDPad
	ld a, movement_step_sleep_1
	ld [wMovementAnimation], a
	xor a
	ld [wd041], a
	call .TranslateIntoMovement
	ld c, a
	ld a, [wMovementAnimation]
	ld [wPlayerNextMovement], a
	ret

.GetDPad
	ldh a, [hJoyDown]
	ld [wCurInput], a

; Standing downhill instead moves down.

	ld hl, wBikeFlags
	bit 2, [hl] ; downhill
	ret z

	ld c, a
	and D_PAD
	ret nz

	ld a, c
	or D_DOWN
	ld [wCurInput], a
	ret

.TranslateIntoMovement
	ld a, [wPlayerState]
	and a ; PLAYER_NORMAL
	jr z, .Normal
	rlca ; PLAYER_BIKE
	jr c, .Normal
	rlca ; PLAYER_SLIP
	jr c, .Ice
	rlca ; PLAYER_SURF
	jr c, .Surf
	rlca ; PLAYER_SURF_PIKA
	jr c, .Surf

.Normal
	call .CheckForced
	call .GetAction
	call .CheckTile
	ret c
	call .CheckTurning
	ret c
	call .TryStep
	ret c
	call .TryJump
	ret c
	call .CheckWarp
	ret c
	jr .NotMoving

.Surf
	call .CheckForced
	call .GetAction
	call .CheckTile
	ret c
	call .CheckTurning
	ret c
	call .TrySurf
	ret c
	jr .NotMoving

.Ice
	call .CheckForced
	call .GetAction
	call .CheckTile
	ret c
	call .CheckTurning
	ret c
	call .TryStep
	ret c
	call .TryJump
	ret c
	call .CheckWarp
	ret c
	ld a, [wWalkingDirection]
	cp STANDING
	call nz, .BumpSound
	call .StandInPlace
	xor a
	ret

.NotMoving
	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .Standing

; Walking into an edge warp won't bump.
	ld a, [wEngineBuffer4]
	and a
	jr nz, .CantMove
	ld a, [wTileset]
	cp TILESET_SIDESCROLL
	jr nz, .notSidescroll
	ld a, [wWalkingTile]
	ld hl, .SidescrollFaceUpEmptyTiles
	call IsInSingularArray
	jr c, .Standing
.notSidescroll
	call .BumpSound
.CantMove
	call ._WalkInPlace
	xor a
	ret

.Standing
	call .StandInPlace
	xor a
	ret

.SidescrollFaceUpEmptyTiles
; todo: figure out if there are any tiles missing from here
	db $07
	db $15
	db $27
	db -1

.CheckTile
; Tiles such as waterfalls and warps move the player
; in a given direction, overriding input.

	ld a, [wPlayerStandingTile]
	ld c, a
	cp COLL_WHIRLPOOL
	jr nz, .not_whirlpool
	ld a, 3
	scf
	ret

.not_whirlpool
	and $f0
	cp COLL_HIGH_NYBBLE_WATERFALL
	jr z, .water
	cp COLL_HIGH_NYBBLE_WALK
	jr z, .land
	cp COLL_HIGH_NYBBLE_CURRENT
	jr z, .current
	cp COLL_HIGH_NYBBLE_WARPS
	jr z, .warps
	jr .no_walk

.water
	ld a, c
	and 3
	ld c, a
	ld b, 0
	ld hl, .water_table
	add hl, bc
	ld a, [hl]
	ld [wWalkingDirection], a
	jr .continue_walk

.water_table
	db RIGHT
	db LEFT
	db UP
	db DOWN

.current
.land
	ld a, c
	and 7
	ld c, a
	ld b, 0
	ld hl, .current_table
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .no_walk
	ld [wWalkingDirection], a
	jr .continue_walk

.current_table
	db STANDING
	db RIGHT
	db LEFT
	db UP
	db DOWN
	db STANDING
	db STANDING
	db STANDING

.warps
	ld a, c
	cp COLL_DOOR
	jr z, .down
	cp COLL_STAIRCASE
	jr z, .down
	cp COLL_CAVE
	jr nz, .no_walk

.down
	ld a, DOWN
	ld [wWalkingDirection], a
	; fallthrough

.continue_walk
	ld a, STEP_WALK
	call .DoStep
	ld a, 5
	scf
	ret

.no_walk
.not_turning
.bump
	xor a
	ret

.CheckTurning
; If the player is turning, change direction first. This also lets
; the player change facing without moving by tapping a direction.

	call .CheckTurnStep
	jr z, .still_turning
	ld a, [wPlayerMovementDirection]
	and a
	jr nz, .not_turning
	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .not_turning

	ld e, a
	ld a, [wPlayerDirection]
	rrca
	rrca
	and 3
	cp e
	jr z, .not_turning

	ld a, STEP_TURN
	call .DoStep
.turning
	ld a, 2
	scf
	ret

.still_turning
	xor a
	scf
	ret

.TryStep

; Surfing actually calls .TrySurf directly instead of passing through here.
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .TrySurf
	cp PLAYER_SURF_PIKA
	jr z, .TrySurf

	call .CheckLandPerms
	jr c, .bump

	call .CheckNPC
	and a
	jr z, .bump
	cp 2
	jr z, .bump

	ld a, [wPlayerStandingTile]
	cp COLL_ICE
	jr z, .ice

; Downhill riding is slower when not moving down.
	call .BikeCheck
	jr nz, .walk

	ld hl, wBikeFlags
	bit 2, [hl] ; downhill
	jr z, .fast_z

	ld a, [wWalkingDirection]
	cp DOWN
.fast_z
	ld a, STEP_BIKE
	jr z, .step_and_carry
	assert STEP_BIKE - 1 == STEP_WALK
	dec a ; STEP_WALK
.step_and_carry
	call .DoStep
	scf
	ret

.walk
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .slow_walk
.maybe_run
	ld a, [wCurInput]
	and B_BUTTON
	jr nz, .run
.slow_walk
	ld a, STEP_WALK
	jr .step_and_carry

.ice
	ld a, STEP_ICE
	jr .step_and_carry

.run
	ld a, STEP_RUN
	call .DoStep
	push af
	ld a, [wWalkingDirection]
	cp STANDING
	call nz, CheckTrainerRun
	pop af
	scf
	ret

.TrySurf

	call .CheckSurfPerms
	ld [wd040], a
	jr c, .surf_bump

	call .CheckNPC
	ld [wd03f], a
	and a
	jr z, .surf_bump
	cp 2
	jr z, .surf_bump

	ld a, [wd040]
	and a
	jr z, .maybe_run

.ExitWater
	call .GetOutOfWater
	call PlayMapMusic
	ld a, STEP_WALK
	call .DoStep
	ld a, 6
	scf
	ret

.CheckTurnStep
	ld a, [wPlayerMovement]
	and $fc
	cp movement_turn_step_down
	ret nz
	ld a, [wPlayerMovement]
	and $3
	ld e, a
	ld a, [wWalkingDirection]
	cp e
	ret

.TryJump
	ld a, [wPlayerStandingTile]
	ld e, a
	and $f0
	cp COLL_HIGH_NYBBLE_LEDGES
	jr nz, .DontJump

	ld a, e
	and 7
	ld e, a
	ld d, 0
	ld hl, .JumpDirections
	add hl, de
	ld a, [wFacingDirection]
	and [hl]
	jr z, .DontJump

	ld de, SFX_JUMP_OVER_LEDGE
	call PlaySFX
	ld a, STEP_LEDGE
	call .DoStep
	ld a, 7
	scf
	ret

.surf_bump
.DontJump
.not_warp
	xor a
	ret

.JumpDirections
	db FACE_RIGHT
	db FACE_LEFT
	db FACE_UP
	db FACE_DOWN
	db FACE_RIGHT | FACE_DOWN
	db FACE_DOWN | FACE_LEFT
	db FACE_UP | FACE_RIGHT
	db FACE_UP | FACE_LEFT

.CheckWarp
	ld a, [wWalkingDirection]
	cp STANDING
	jr z, .not_warp
	ld e, a
	ld d, 0
	ld hl, .EdgeWarps
	add hl, de
	ld a, [wPlayerStandingTile]
	cp [hl]
	jr nz, .not_warp

	ld a, 1
	ld [wd041], a
	ld a, [wWalkingDirection]
	ld e, a
	ld a, [wPlayerDirection]
	rrca
	rrca
	and 3
	cp e
	jr nz, .not_warp
	call WarpCheck
	jr nc, .not_warp

	call .StandInPlace
	scf
	ld a, 1
	ret

.EdgeWarps
	db COLL_WARP_CARPET_DOWN
	db COLL_WARP_CARPET_UP
	db COLL_WARP_CARPET_LEFT
	db COLL_WARP_CARPET_RIGHT

.DoStep
	ld e, a
	ld d, 0
	ld hl, .Steps
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wWalkingDirection]
	ld e, a
	cp STANDING
	jp z, .StandInPlace
	add hl, de
	ld a, [hl]
	ld [wMovementAnimation], a
	ld hl, .InPlace
	add hl, de
	ld a, [hl]
	ld [wPlayerMovementDirection], a

	ld a, 4
	ret

.Steps
	dw .SlowStep
	dw .NormalStep
	dw .FastStep
	dw .JumpStep
	dw .SlideStep
	dw .TurningStep
	dw .BackJumpStep
	dw .InPlace
	dw .Run

.SlowStep
	slow_step_down
	slow_step_up
	slow_step_left
	slow_step_right
.NormalStep
	step_down
	step_up
	step_left
	step_right
.FastStep
	big_step_down
	big_step_up
	big_step_left
	big_step_right
.JumpStep
	jump_step_down
	jump_step_up
	jump_step_left
	jump_step_right
.SlideStep
	fast_slide_step_down
	fast_slide_step_up
	fast_slide_step_left
	fast_slide_step_right
.BackJumpStep
	jump_step_up
	jump_step_down
	jump_step_right
	jump_step_left
.TurningStep
	turn_step_down
	turn_step_up
	turn_step_left
	turn_step_right
.InPlace
	db $80 + movement_turn_head_down
	db $80 + movement_turn_head_up
	db $80 + movement_turn_head_left
	db $80 + movement_turn_head_right
.Run
	run_step_down
	run_step_up
	run_step_left
	run_step_right

.StandInPlace
	ld a, movement_step_sleep_1
.load_movement_animation
	ld [wMovementAnimation], a
	xor a
	ld [wPlayerMovementDirection], a
	ret

._WalkInPlace
	ld a, movement_step_bump
	jr .load_movement_animation

.CheckForced
; When sliding on ice, input is forced to remain in the same direction.

	call CheckStandingOnIce
	ret nc

	ld a, [wPlayerMovementDirection]
	and a
	ret z

	and 3
	ld e, a
	ld d, 0
	ld hl, .forced_dpad
	add hl, de
	ld a, [wCurInput]
	and BUTTONS
	or [hl]
	ld [wCurInput], a
	ret

.forced_dpad
	db D_DOWN, D_UP, D_LEFT, D_RIGHT

.GetAction
; Poll player input and update movement info.

	ld hl, .table
	ld de, .table2 - .table1
	ld a, [wCurInput]
	bit D_DOWN_F, a
	jr nz, .d_down
	bit D_UP_F, a
	jr nz, .d_up
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
; Standing
	jr .update

.d_down 	add hl, de
.d_up   	add hl, de
.d_left 	add hl, de
.d_right	add hl, de

.update
	ld a, [hli]
	ld [wWalkingDirection], a
	ld a, [hli]
	ld [wFacingDirection], a
	ld a, [hli]
	ld [wWalkingX], a
	ld a, [hli]
	ld [wWalkingY], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	ld [wWalkingTile], a
	ret

.table
; struct:
;	walk direction
;	facing
;	x movement
;	y movement
;	tile collision pointer
.table1
	db STANDING, FACE_CURRENT, 0, 0
	dw wPlayerStandingTile
.table2
	db RIGHT, FACE_RIGHT,  1,  0
	dw wTileRight
	db LEFT,  FACE_LEFT,  -1,  0
	dw wTileLeft
	db UP,    FACE_UP,     0, -1
	dw wTileUp
	db DOWN,  FACE_DOWN,   0,  1
	dw wTileDown

.CheckNPC
; Returns 0 if there is an NPC in front that you can't move
; Returns 1 if there is no NPC in front
; Returns 2 if there is a movable NPC in front
	ld a, 0
	ldh [hMapObjectIndexBuffer], a
; Load the next X coordinate into d
	ld a, [wPlayerStandingMapX]
	ld d, a
	ld a, [wWalkingX]
	add d
	ld d, a
; Load the next Y coordinate into e
	ld a, [wPlayerStandingMapY]
	ld e, a
	ld a, [wWalkingY]
	add e
	ld e, a
; Find an object struct with coordinates equal to d,e
	ld bc, wObjectStructs ; redundant
	callba IsNPCAtCoord
	jr nc, .is_npc
	call .CheckStrengthBoulder
	jr c, .no_bump

.not_boulder
	xor a
	ret

.is_npc
	ld a, 1
	ret

.no_bump
	ld a, 2
	ret

.CheckStrengthBoulder

	ld hl, wBikeFlags
	bit 0, [hl] ; using strength
	jr z, .not_boulder

	ld hl, OBJECT_DIRECTION_WALKING
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr nz, .not_boulder

	ld hl, OBJECT_PALETTE
	add hl, bc
	bit 6, [hl]
	jr z, .not_boulder

	ld hl, OBJECT_FLAGS2
	add hl, bc
	set 2, [hl]

	ld a, [wWalkingDirection]
	ld d, a
	ld hl, OBJECT_RANGE
	add hl, bc
	ld a, [hl]
	and $fc
	or d
	ld [hl], a

.NotWalkable
.NotSurfable
.Neither
	scf
	ret

.CheckLandPerms
; Return 0 if walking onto land and tile permissions allow it.
; Otherwise, return carry.

	ld a, [wTilePermissions]
	ld d, a
	ld a, [wFacingDirection]
	and d
	jr nz, .NotWalkable

	ld a, [wWalkingTile]
	call .CheckWalkable
	jr c, .NotWalkable

.Water
	xor a
	ret

.CheckSurfPerms
; Return 0 if moving in water, or 1 if moving onto land.
; Otherwise, return carry.

	ld a, [wTilePermissions]
	ld d, a
	ld a, [wFacingDirection]
	and d
	jr nz, .NotSurfable

	ld a, [wWalkingTile]
	call .CheckSurfable
	jr c, .NotSurfable

	and a
	ret

.BikeCheck
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	ret z
	cp PLAYER_SLIP
	ret

.CheckWalkable
; Return 0 if tile a is land. Otherwise, return carry.

	call GetTileCollision
	assert LANDTILE == 0
	and a
	ret z
	scf
	ret

.CheckSurfable
; Return 0 if tile a is water, or 1 if land.
; Otherwise, return carry.

	call GetTileCollision
	cp WATERTILE
	jr z, .Water

; Can walk back onto land from water.
	assert LANDTILE == 0
	and a
	jr nz, .Neither
	ld a, 1
	and a
	ret

.BumpSound
	call CheckSFX
	ret c
	ld de, SFX_BUMP
	jp PlaySFX

.GetOutOfWater
	push bc
	xor a ; PLAYER_NORMAL
	ld [wPlayerState], a
	call ReplaceKrisSprite ; UpdateSprites
	pop bc
	ret

CheckStandingOnIce::
	ld a, [wPlayerMovementDirection]
	and a
	jr z, .not_ice
	cp $f0
	jr z, .not_ice
	ld a, [wPlayerStandingTile]
	cp COLL_ICE
	jr z, .yep
	ld a, [wPlayerState]
	cp PLAYER_SLIP
	jr nz, .not_ice

.yep
	scf
	ret

.not_ice
	and a
	ret

CheckTrainerRun:
; Check if any trainer on the map sees the player.

; Skip the player object.
	ld a, 1
	ld de, wMapObjects + OBJECT_LENGTH

.loop

; Have them face the player if the object:

	push af
	push de

; Has a sprite
	ld hl, MAPOBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

; Is a trainer
	ld hl, MAPOBJECT_COLOR
	add hl, de
	ld a, [hl]
	and $f
	cp PERSONTYPE_TRAINER
	jr z, .is_trainer
	cp PERSONTYPE_GENERICTRAINER
	jr nz, .next
.is_trainer

; Is visible on the map
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	inc a
	jr z, .next

; Spins around
	ld hl, MAPOBJECT_MOVEMENT
	add hl, de
	ld a, [hl]
	cp SPRITEMOVEDATA_SPINRANDOM_SLOW
	jr z, .spinner
	cp SPRITEMOVEDATA_SPINRANDOM_FAST
	jr z, .spinner
	cp SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE
	jr z, .spinner
	cp SPRITEMOVEDATA_SPINCLOCKWISE
	jr nz, .next

.spinner

; You're within their sight range
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	call GetObjectStruct
	call AnyFacingPlayerDistance_bc
	ld hl, MAPOBJECT_PARAMETER
	add hl, de
	ld a, [hl]
	cp c
	jr c, .next

; Get them to face you
	ld a, b
	push af
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	call GetObjectStruct
	pop af
	call SetSpriteDirection
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	cp $40
	jr nc, .next
	ld a, $40
	ld [hl], a

.next
	pop de
	ld hl, OBJECT_LENGTH
	add hl, de
	ld d, h
	ld e, l

	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	xor a
	ret

AnyFacingPlayerDistance_bc::
; Returns distance in c and direction in b.
	push de
	call .AnyFacingPlayerDistance
	ld b, d
	ld c, e
	pop de
	ret

.AnyFacingPlayerDistance
	ld hl, OBJECT_NEXT_MAP_X ; x
	add hl, bc
	ld d, [hl]

	ld hl, OBJECT_NEXT_MAP_Y ; y
	add hl, bc
	ld e, [hl]

	ldh a, [hJoypadDown]
	ld bc, 0
	bit D_DOWN_F, a
	jr nz, .down
	bit D_UP_F, a
	jr nz, .up
	bit D_LEFT_F, a
	jr nz, .left
	bit D_RIGHT_F, a
	jr nz, .right
.down
	inc b
	jr .got_vector
.up
	dec b
	jr .got_vector
.left
	dec c
	jr .got_vector
.right
	inc c
.got_vector

	ld a, [wPlayerStandingMapX]
	add c
	sub d
	ld l, OW_RIGHT
	jr nc, .check_y
	cpl
	inc a
	ld l, OW_LEFT
.check_y
	ld d, a
	ld a, [wPlayerStandingMapY]
	add b
	sub e
	ld h, OW_DOWN
	jr nc, .compare
	cpl
	inc a
	ld h, OW_UP
.compare
	cp d
	ld e, a
	ld a, d
	ld d, h
	ret nc
	ld e, a
	ld d, l
	ret
