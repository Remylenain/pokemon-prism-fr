MapObjectActionPointers:
	dw SetFacingStanding,                SetFacingStanding         ; 00
	dw SetFacingStandAction,             SetFacingCurrent          ; 01 standing?
	dw SetFacingStepAction,              SetFacingCurrent          ; 02 walking?
	dw SetFacingStepAction,              SetFacingCurrent          ; 03 bumping?
	dw SetFacingCounterclockwiseSpin,    SetFacingCurrent          ; 04
	dw SetFacingCounterclockwiseSpin2,   SetFacingStanding         ; 05
	dw MapObjectAction_Fishing,          MapObjectAction_Fishing   ; 06
	dw SetFacingShadow,                  SetFacingStanding         ; 07
	dw SetFacingEmote,                   SetFacingEmote            ; 08
	dw SetFacingBigDollSym,              SetFacingBigDollSym       ; 09
	dw SetFacingBounce2,                 SetFacingCurrent          ; 0a
	dw SetFacingWeirdTree,               SetFacingCurrent          ; 0b
	dw SetFacingBigDollAsym,             SetFacingBigDollAsym      ; 0c
	dw SetFacingBigDoll,                 SetFacingBigDoll          ; 0d
	dw SetFacingBoulderDust,             SetFacingStanding         ; 0e
	dw SetFacingGrassShake,              SetFacingStanding         ; 0f
	dw SetFacingSkyfall,                 SetFacingCurrent          ; 10
	dw MapObjectAction_Running,          SetFacingCurrent          ; 11
	dw MapObjectAction_FieldMove,        MapObjectAction_FieldMove ; 12
	dw SetFacingGrassShake_Snow,         SetFacingStanding         ; 13
	dw SetFacingBounce,                  SetFacingFreezeBounce     ; 14

SetFacingCounterclockwiseSpin2:
	call CounterclockwiseSpinAction
SetFacingStanding:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], STANDING
	ret

SetFacingCurrent:
	call SidescrollGetSpriteDirection
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

SetFacingStandAction:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld a, [hl]
	and 1
	jr z, SetFacingCurrent
	; fallthrough

SetFacingStepAction:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit SLIDING, [hl]
	jr nz, SetFacingCurrent

	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	rrca
	rrca
	rrca
	and %11
	ld d, a
	call SidescrollGetSpriteDirection
	or d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

SetFacingSkyfall:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit SLIDING, [hl]
	jr nz, SetFacingCurrent

	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	add 2
	ld [hl], a

	rrca
	rrca
	rrca
	and %11
	ld d, a

	call GetSpriteDirection
	or d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

SetFacingCounterclockwiseSpin:
	call CounterclockwiseSpinAction
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

CounterclockwiseSpinAction:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	and %11110000
	ld e, a

	ld a, [hl]
	inc a
	and %00001111
	ld d, a
	cp 2
	jr c, .ok

	ld d, 0
	ld a, e
	add $10
	and %00110000
	ld e, a

.ok
	ld a, d
	or e
	ld [hl], a

	swap e
	ld d, 0
	ld hl, .Directions
	add hl, de
	ld a, [hl]
	ld hl, OBJECT_FACING
	add hl, bc
	ld [hl], a
	ret

.Directions
	db OW_DOWN, OW_RIGHT, OW_UP, OW_LEFT

MapObjectAction_Fishing:
	call GetSpriteDirection
	rrca
	rrca
	ld d, a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	cp 72
	; a = (carry (a < 72) ? FACING_20 : FACING_FISH_DOWN) + d
	sbc a
	and FACING_20 - FACING_FISH_DOWN
	add FACING_FISH_DOWN
	add d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

MapObjectAction_FieldMove:
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	cp 16
	; a = carry ? 1 : 0
	sbc a
	and 1
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

SetFacingShadow:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_SHADOW
	ret

SetFacingEmote:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_EMOTE
	ret

SetFacingBigDollSym:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_BIG_DOLL_SYM
	ret

SetFacingBounce2:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	inc a
	and %00011111
	ld [hl], a
	and %00010000
	jp z, SetFacingCurrent
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	set 0, [hl]
	ret

SetFacingWeirdTree:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	and %00011000
	rrca
	rrca
	rrca
	add $18
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

SetFacingBigDollAsym:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_BIG_DOLL_ASYM
	ret

SetFacingBigDoll:
	ld a, [wVariableSprites + SPRITE_BIG_DOLL - SPRITE_VARS]
	ld d, FACING_BIG_DOLL_SYM
	cp SPRITE_BIG_SNORLAX
	jr z, .ok
	cp SPRITE_BIG_LAPRAS
	jr z, .ok
	ld d, FACING_BIG_DOLL_ASYM

.ok
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], d
	ret

SetFacingBoulderDust:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]

	ld hl, OBJECT_FACING_STEP
	add hl, bc
	and %100
	ld a, FACING_BOULDER_DUST_1
	jr z, .ok
	inc a ; FACING_BOULDER_DUST_2
.ok
	ld [hl], a
	ret

SetFacingGrassShake:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	and %1000
	ld a, FACING_GRASS_1
	jr z, .ok
	inc a ; FACING_GRASS_2

.ok
	ld [hl], a
	ret

SetFacingGrassShake_Snow:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	and %1000
	ld a, FACING_SNOW1
	jr z, .ok
	inc a ; FACING_SNOW2

.ok
	ld [hl], a
	ret

MapObjectAction_Running:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit SLIDING, [hl]
	jp nz, SetFacingCurrent

	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	rrca
	rrca
	and %11
	ld d, a
	call SidescrollGetSpriteDirection
	or d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

SetFacingBounce:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	inc a
	and %00011111
	ld [hl], a
	and %00010000
	jr z, SetFacingFreezeBounce
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_STEP_DOWN_1
	ret

SetFacingFreezeBounce:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_STEP_DOWN_0
	ret
