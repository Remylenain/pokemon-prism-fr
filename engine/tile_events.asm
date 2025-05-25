CheckWarpCollision::
; Is this tile a warp?
	ld a, [wPlayerStandingTile]
	cp COLL_HOLE
	jr z, .warp
	and $f0
	cp COLL_HIGH_NYBBLE_WARPS
	jr z, .warp
	and a
	ret

.warp
	scf
	ret

CheckDirectionalWarp::
; If this is a directional warp, clear carry (press the designated button to warp).
; Else, set carry (immediate warp).
	ld a, [wPlayerStandingTile]
	cp COLL_WARP_CARPET_DOWN
	jr z, .directional
	cp COLL_WARP_CARPET_LEFT
	jr z, .directional
	cp COLL_WARP_CARPET_UP
	jr z, .directional
	cp COLL_WARP_CARPET_RIGHT
	jr z, .directional
	scf
	ret

.directional
	xor a
	ret

CheckWarpFacingDown:
	ld hl, .blocks
	ld a, [wPlayerStandingTile]
	jp IsInSingularArray

.blocks
	db COLL_DOOR
	db COLL_STAIRCASE
	db COLL_CAVE
	db COLL_WARP_PANEL
	db -1

CheckGrassCollision::
	ld a, [wPlayerStandingTile]
	ld hl, .blocks
	jp IsInSingularArray

.blocks
	db COLL_TALL_GRASS
	db COLL_SUPER_TALL_GRASS
	db COLL_SNOW
	db COLL_WATER
	db -1

CheckCutCollision:
	ld a, c
	ld hl, .blocks
	jp IsInSingularArray

.blocks
	db COLL_CUT_TREE
	db COLL_TALL_GRASS
	db COLL_SUPER_TALL_GRASS
	db -1
