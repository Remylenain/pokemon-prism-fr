PlaySpriteAnimationsAndDelayFrame:
	call PlaySpriteAnimations
	jp DelayFrame

PlaySpriteAnimations:
	push hl
	push de
	push bc
	push af

	xor a
	ld [wCurrSpriteOAMAddr], a
	call DoNextFrameForAllSprites

	jp PopOffRegsAndReturn

DoNextFrameForAllSprites:
	ld hl, wSpriteAnimationStructs
	ld e, 10 ; There are 10 structs here.

.loop
	ld a, [hl]
	and a
	jr z, .next ; This struct is deinitialized.
	ld c, l
	ld b, h
	push hl
	push de
	call DoAnimFrame ; Uses a massive dw
	call UpdateAnimFrame
	pop de
	pop hl
	ret c

.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop

	ld a, [wCurrSpriteOAMAddr]
	ld l, a
	ld h, HIGH(wSprites)

.loop2 ; Clear (wSprites + [wCurrSpriteOAMAddr] --> wSpritesEnd)
	ld a, l
	cp LOW(wSpritesEnd)
	ret nc
	xor a
	ld [hli], a
	jr .loop2

DoNextFrameForFirst16Sprites:
	ld hl, wSpriteAnimationStructs
	ld e, 10

.loop
	ld a, [hl]
	and a
	jr z, .next
	ld c, l
	ld b, h
	push hl
	push de
	call DoAnimFrame ; Uses a massive dw
	call UpdateAnimFrame
	pop de
	pop hl
	ret c

.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop

	ld a, [wCurrSpriteOAMAddr]
	ld l, a
	ld h, HIGH(wSprites + $40)

.clear_loop ; Clear (wSprites + [wCurrSpriteOAMAddr] --> wSprites + $40)
	ld a, l
	cp LOW(wSprites + 16 * 4)
	ret nc
	xor a
	ld [hli], a
	jr .clear_loop

InitSpriteAnimStruct_IDToBuffer:
	ld [wSpriteAnimIDBuffer], a
InitSpriteAnimStruct::
; Initialize animation a at pixel x=e, y=d
; Returns pointer to struct in bc.
; Up to 10 structs can be allocated.
	push de
	push af
	ld hl, wSpriteAnimationStructs
	ld e, 10
.loop
	ld a, [hl]
	and a
	jr z, .found
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
; We've reached the end.  There is no more room here.
; Return carry.
	pop af
	pop de
	scf
	ret

.found
; Copy the struct pointer to bc.
	ld c, l
	ld b, h
; Value [wSpriteAnimCount] is initially set to -1. Set it to
; the number of objects loaded into this array.
	ld hl, wSpriteAnimCount
	inc [hl]
	jr nz, .initialized
	inc [hl]

.initialized
; Get row a of SpriteAnimSeqData, copy the pointer into de
	pop af
	ld e, a
	ld d, 0
	ld hl, SpriteAnimSeqData
	add hl, de
	add hl, de
	add hl, de
	ld e, l
	ld d, h
; Set hl to the first field (field 0) in the current structure.
	ld hl, SPRITEANIMSTRUCT_INDEX
	add hl, bc
; Load the index.
	ld a, [wSpriteAnimCount]
	ld [hli], a
; Copy the table entry to the next two fields.
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
; Look up the third field from the table in the wSpriteAnimDict array (10x2).
; Take the value and load it in
	ld a, [de]
	call GetSpriteAnimVTile
	ld [hli], a
	pop de
; Set hl to field 4 (X coordinate).  Kinda pointless, because we're presumably already here.
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
; Load the original value of de into here.
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
; load 0 into the next four fields
	xor a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
; load -1 into the next field
	dec a
	ld [hli], a
; load 0 into the last five fields
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
; back up the address of the first field to wSpriteAnimAddrBackup
	ld a, c
	ld [wSpriteAnimAddrBackup], a
	ld a, b
	ld [wSpriteAnimAddrBackup + 1], a
	ret

DeinitializeSprite:
; Clear the index field of the struct in bc.
	ld hl, SPRITEANIMSTRUCT_INDEX
	add hl, bc
	ld [hl], 0
	ret

DeinitializeAllSprites:
; Clear the index field of every struct in the wSpriteAnimationStructs array.
	ld hl, wSpriteAnimationStructs
	ld bc, $10
	ld e, 10
	xor a
.loop
	ld [hl], a
	add hl, bc
	dec e
	jr nz, .loop
	ret

UpdateAnimFrame:
	call InitSpriteAnimBuffer ; init WRAM
	call GetSpriteAnimFrame ; read from a memory array
	cp -3
	jr z, .done
	cp -4
	jr z, .delete
	call GetFrameOAMPointer
	; add byte to [wCurrAnimVTile]
	ld a, [wCurrAnimVTile]
	add [hl]
	ld [wCurrAnimVTile], a
	inc hl
	; load pointer into hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push bc
	ld a, [wCurrSpriteOAMAddr]
	ld e, a
	ld d, HIGH(wSprites)
	ld a, [hli]
	ld c, a ; number of objects
.loop
	; first byte: y (px)
	; [de] = [wCurrAnimYCoord] + [wCurrAnimYOffset] + [wGlobalAnimYOffset] + AddOrSubtractY([hl])
	ld a, [wCurrAnimYCoord]
	ld b, a
	ld a, [wCurrAnimYOffset]
	add b
	ld b, a
	ld a, [wGlobalAnimYOffset]
	add b
	ld b, a
	call AddOrSubtractY
	add b
	ld [de], a
	inc hl
	inc de
	; second byte: x (px)
	; [de] = [wCurrAnimXCoord] + [wCurrAnimXOffset] + [wGlobalAnimXOffset] + AddOrSubtractX([hl])
	ld a, [wCurrAnimXCoord]
	ld b, a
	ld a, [wCurrAnimXOffset]
	add b
	ld b, a
	ld a, [wGlobalAnimXOffset]
	add b
	ld b, a
	call AddOrSubtractX
	add b
	ld [de], a
	inc hl
	inc de
	; third byte: vtile
	; [de] = [wCurrAnimVTile] + [hl]
	ld a, [wCurrAnimVTile]
	add [hl]
	ld [de], a
	inc hl
	inc de
	; fourth byte: attributes
	; [de] = GetSpriteOAMAttr([hl])
	ld a, [hl]
	cp $ff
	jr z, .skipOAM
	call GetSpriteOAMAttr
	ld [de], a
.skipOAM
	inc hl
	inc de
	ld a, e
	ld [wCurrSpriteOAMAddr], a
	cp LOW(wSpritesEnd)
	jr nc, .reached_the_end
	dec c
	jr nz, .loop
	pop bc
	jr .done

.delete
	call DeinitializeSprite
.done
	and a
	ret

.reached_the_end
	pop bc
	scf
	ret

AddOrSubtractY:
	push hl
	ld a, [hl]
	ld hl, wCurrSpriteAddSubFlags
	bit OAM_Y_FLIP, [hl]
AddOrSubtractCoord_PushedHL:
	jr z, .ok
	; -(a + 8)
	cpl
	sub 7
.ok
	pop hl
	ret

AddOrSubtractX:
	push hl
	ld a, [hl]
	ld hl, wCurrSpriteAddSubFlags
	bit OAM_X_FLIP, [hl]
	jr AddOrSubtractCoord_PushedHL

GetSpriteOAMAttr:
	ld a, [wCurrSpriteAddSubFlags]
	ld b, a
	ld a, [hl]
	xor b
	and $e0
	ld b, a
	ld a, [hl]
	and $1f
	or b
	ret

InitSpriteAnimBuffer:
	xor a
	ld [wCurrSpriteAddSubFlags], a
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld a, [hli]
	ld [wCurrAnimVTile], a
	ld a, [hli]
	ld [wCurrAnimXCoord], a
	ld a, [hli]
	ld [wCurrAnimYCoord], a
	ld a, [hli]
	ld [wCurrAnimXOffset], a
	ld a, [hli]
	ld [wCurrAnimYOffset], a
	ret

GetSpriteAnimVTile:
; a = wSpriteAnimDict[a] if a in wSpriteAnimDict else 0
; VTiles offset
	push hl
	push bc
	ld hl, wSpriteAnimDict
	ld b, a
	ld c, 10
.loop
	ld a, [hli]
	cp b
	jr z, .ok
	inc hl
	dec c
	jr nz, .loop
	xor a
	jr .done

.ok
	ld a, [hl]

.done
	pop bc
	pop hl
	ret

_ReinitSpriteAnimFrame_IDToBuffer:
	ld [wSpriteAnimIDBuffer], a

_ReinitSpriteAnimFrame::
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], 0
	ld hl, SPRITEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], -1
	ret

GetSpriteAnimFrame:
.loop
	ld hl, SPRITEANIMSTRUCT_DURATION
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next_frame ; finished the current sequence
	dec [hl]
	call .GetPointer ; load pointer from SpriteAnimFrameData
	ld a, [hli]
	push af
	jr .okay

.next_frame
	ld hl, SPRITEANIMSTRUCT_FRAME
	add hl, bc
	inc [hl]
	call .GetPointer ; load pointer from SpriteAnimFrameData
	ld a, [hli]
	cp -2
	jr z, .restart
	cp -1
	jr z, .repeat_last

	push af
	ld a, [hl]
	push hl
	and $3f
	ld hl, SPRITEANIMSTRUCT_DURATIONOFFSET
	add hl, bc
	add [hl]
	ld hl, SPRITEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a
	pop hl
.okay
	ld a, [hl]
	and $c0
	srl a
	ld [wCurrSpriteAddSubFlags], a
	pop af
	ret

.repeat_last
	xor a
	ld hl, SPRITEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_FRAME
	add hl, bc
	dec [hl]
	dec [hl]
	jr .loop

.restart
	xor a
	ld hl, SPRITEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a

	dec a
	ld hl, SPRITEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], a
	jr .loop

.GetPointer
	; Get the data for the current frame for the current animation sequence

	; SpriteAnimFrameData[SpriteAnim[SPRITEANIMSTRUCT_FRAMESET_ID]][SpriteAnim[SPRITEANIMSTRUCT_FRAME]]
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, SpriteAnimFrameData
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, SPRITEANIMSTRUCT_FRAME
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, de
	ret

GetFrameOAMPointer:
; Load OAM data pointer
	ld e, a
	ld d, 0
	ld hl, SpriteAnimOAMData
	add hl, de
	add hl, de
	add hl, de
	ret

SpriteAnimSeqData:
	; frameset sequence, tile
	db SPRITE_ANIM_FRAMESET_PARTY_MON, SPRITE_ANIM_SEQ_PARTY_MON, $00 ; 00
	db SPRITE_ANIM_FRAMESET_GS_TITLE_TRAIL, SPRITE_ANIM_SEQ_GS_TITLE_TRAIL, $00 ; 01
	db SPRITE_ANIM_FRAMESET_TEXT_ENTRY_CURSOR, SPRITE_ANIM_SEQ_NAMING_SCREEN_CURSOR, $05 ; 02 naming screen cursor
	db SPRITE_ANIM_FRAMESET_GAMEFREAK_LOGO, SPRITE_ANIM_SEQ_GAMEFREAK_LOGO, $00 ; 03
	db SPRITE_ANIM_FRAMESET_GS_INTRO_STAR, SPRITE_ANIM_SEQ_GS_INTRO_STAR, $06 ; 04
	db SPRITE_ANIM_FRAMESET_GS_INTRO_SPARKLE, SPRITE_ANIM_SEQ_GS_INTRO_SPARKLE, $06 ; 05
	db SPRITE_ANIM_FRAMESET_SLOT_GOLEM, SPRITE_ANIM_SEQ_SLOT_GOLEM, $07 ; 06 slots golem
	db SPRITE_ANIM_FRAMESET_SLOTS_CHANSEY, SPRITE_ANIM_SEQ_SLOTS_CHANSEY, $07 ; 07 slots chansey
	db SPRITE_ANIM_FRAMESET_SLOTS_EGG, SPRITE_ANIM_SEQ_SLOTS_EGG, $07 ; 08 slots egg
	; db SPRITE_ANIM_FRAMESET_TEXT_ENTRY_CURSOR, SPRITE_ANIM_SEQ_0C, $05 ; 09 mail composition cursor
	db SPRITE_ANIM_FRAMESET_WALK_CYCLE, SPRITE_ANIM_SEQ_NULL, $00 ; 0a walk cycle
	db SPRITE_ANIM_FRAMESET_STILL_CURSOR, SPRITE_ANIM_SEQ_0D, $08 ; 0b
	db SPRITE_ANIM_FRAMESET_STILL_CURSOR, SPRITE_ANIM_SEQ_MEMORY_GAME_CURSOR, $08 ; 0c
	db SPRITE_ANIM_FRAMESET_STILL_CURSOR, SPRITE_ANIM_SEQ_POKEGEAR_ARROW, $08 ; 0d
	db SPRITE_ANIM_FRAMESET_TRADE_POKE_BALL, SPRITE_ANIM_SEQ_TRADE_POKE_BALL, $00 ; 0e
	db SPRITE_ANIM_FRAMESET_TRADE_POOF, SPRITE_ANIM_SEQ_NULL, $00 ; 0f
	db SPRITE_ANIM_FRAMESET_TRADE_TUBE_BULGE, SPRITE_ANIM_SEQ_TRADE_TUBE_BULGE, $00 ; 10
	db SPRITE_ANIM_FRAMESET_TRADEMON_ICON, SPRITE_ANIM_SEQ_TRADEMON_IN_TUBE, $00 ; 11
	db SPRITE_ANIM_FRAMESET_TRADEMON_BUBBLE, SPRITE_ANIM_SEQ_TRADEMON_IN_TUBE, $00 ; 12
	db SPRITE_ANIM_FRAMESET_EVOLUTION_BALL_OF_LIGHT, SPRITE_ANIM_SEQ_REVEAL_NEW_MON, $00 ; 13
	db SPRITE_ANIM_FRAMESET_RADIO_TUNING_KNOB, SPRITE_ANIM_SEQ_RADIO_TUNING_KNOB, $00 ; 14 radio tuning knob
	db SPRITE_ANIM_FRAMESET_MAGNET_TRAIN_RED, SPRITE_ANIM_SEQ_NULL, $00 ; 15
	db SPRITE_ANIM_FRAMESET_LEAF, SPRITE_ANIM_SEQ_CUT_LEAVES, $00 ; 16 leaves when cutting down a tree
	db SPRITE_ANIM_FRAMESET_CUT_TREE, SPRITE_ANIM_SEQ_NULL, $00 ; 17 cut tree
	db SPRITE_ANIM_FRAMESET_LEAF, SPRITE_ANIM_SEQ_FLY_LEAF, $00 ; 18 flying leaves
	db SPRITE_ANIM_FRAMESET_EGG_CRACK, SPRITE_ANIM_SEQ_NULL, $00 ; 19
	db SPRITE_ANIM_FRAMESET_GS_INTRO_HO_OH, SPRITE_ANIM_SEQ_GS_INTRO_HO_OH, $00 ; 1a
	db SPRITE_ANIM_FRAMESET_HEADBUTT, SPRITE_ANIM_SEQ_NULL, $00 ; 1b headbutt
	db SPRITE_ANIM_FRAMESET_EGG_HATCH_1, SPRITE_ANIM_SEQ_REVEAL_NEW_MON, $00 ; 1c
	db SPRITE_ANIM_FRAMESET_EZCHAT_CURSOR_1, SPRITE_ANIM_SEQ_EZCHAT_CURSOR, $00 ; 1d
	db SPRITE_ANIM_FRAMESET_BLUE_WALK, SPRITE_ANIM_SEQ_NULL, $00 ; 1e walk cycle pal 1
	db SPRITE_ANIM_FRAMESET_MAGNET_TRAIN_BLUE, SPRITE_ANIM_SEQ_NULL, $00 ; 1f
	db SPRITE_ANIM_FRAMESET_MOBILE_TRADE_SENT_BALL, SPRITE_ANIM_SEQ_NULL, $00 ; 20
	db SPRITE_ANIM_FRAMESET_MOBILE_TRADE_OT_BALL, SPRITE_ANIM_SEQ_NULL, $00 ; 21
	db SPRITE_ANIM_FRAMESET_MOBILE_TRADE_CABLE_BULGE, SPRITE_ANIM_SEQ_NULL, $00 ; 22
	db SPRITE_ANIM_FRAMESET_MOBILE_TRADE_SENT_PULSE, SPRITE_ANIM_SEQ_MOBILE_TRADE_SENT_PULSE, $00 ; 23
	db SPRITE_ANIM_FRAMESET_MOBILE_TRADE_OT_PULSE, SPRITE_ANIM_SEQ_MOBILE_TRADE_OT_PULSE, $00 ; 24
	db SPRITE_ANIM_FRAMESET_MOBILE_TRADE_PING, SPRITE_ANIM_SEQ_NULL, $00 ; 25
	db SPRITE_ANIM_FRAMESET_INTRO_SUICUNE_1, SPRITE_ANIM_SEQ_INTRO_SUICUNE, $00 ; 26
	db SPRITE_ANIM_FRAMESET_INTRO_PICHU, SPRITE_ANIM_SEQ_INTRO_PICHU_WOOPER, $00 ; 27
	db SPRITE_ANIM_FRAMESET_INTRO_WOOPER, SPRITE_ANIM_SEQ_INTRO_PICHU_WOOPER, $00 ; 28
	db SPRITE_ANIM_FRAMESET_INTRO_UNOWN_1, SPRITE_ANIM_SEQ_INTRO_UNOWN, $00 ; 29 intro unown
	db SPRITE_ANIM_FRAMESET_INTRO_UNOWN_F_2, SPRITE_ANIM_SEQ_INTRO_UNOWN_F, $00 ; 2a
	db SPRITE_ANIM_FRAMESET_INTRO_SUICUNE_AWAY, SPRITE_ANIM_SEQ_INTRO_SUICUNE_AWAY, $00 ; 2b
	db SPRITE_ANIM_FRAMESET_CELEBI_LEFT, SPRITE_ANIM_SEQ_NULL, $00 ; 2c
	db SPRITE_ANIM_FRAMESET_CUSTOMIZATION_PLAYER, SPRITE_ANIM_SEQ_NULL, $00
	db SPRITE_ANIM_FRAMESET_PAL02_WALK, SPRITE_ANIM_SEQ_NULL, $00 ; 1e walk cycle pal 2
	db SPRITE_ANIM_FRAMESET_PAL03_WALK, SPRITE_ANIM_SEQ_NULL, $00 ; 1e walk cycle pal 3
	db SPRITE_ANIM_FRAMESET_PAL04_WALK, SPRITE_ANIM_SEQ_NULL, $00 ; 1e walk cycle pal 4
	db SPRITE_ANIM_FRAMESET_PAL05_WALK, SPRITE_ANIM_SEQ_NULL, $00 ; 1e walk cycle pal 5
	db SPRITE_ANIM_FRAMESET_PAL06_WALK, SPRITE_ANIM_SEQ_NULL, $00 ; 1e walk cycle pal 6
	db SPRITE_ANIM_FRAMESET_PAL07_WALK, SPRITE_ANIM_SEQ_NULL, $00 ; 1e walk cycle pal 7
	db SPRITE_ANIM_FRAMESET_SLIDER_CURSOR, SPRITE_ANIM_SEQ_SLIDER_CURSOR, $00
	db SPRITE_ANIM_FRAMESET_CALENDAR_CURSOR, SPRITE_ANIM_SEQ_CALENDAR_CURSOR, $00
	db SPRITE_ANIM_FRAMESET_00, SPRITE_ANIM_SEQ_NULL, $00

AnimateEndOfExpBar:
	ld de, EndOfExpBarGFX
	ld hl, vObjTiles tile $00
	lb bc, BANK(EndOfExpBarGFX), 1
	call Request2bpp
	ld c, 8
	ld d, 0
.loop
	push bc
	call .AnimateFrame
	call DelayFrame
	pop bc
	inc d
	inc d
	dec c
	jr nz, .loop
	jp ClearSprites

.AnimateFrame
	ld hl, wSprites
	ld c, 8
.anim_loop
	ld a, c
	and a
	ret z
	dec c
	ld a, c
; multiply by 8
	add a
	add a
	add a
	push af

	push de
	push hl
	call Sine
	pop hl
	pop de
	add 13 * 8
	ld [hli], a

	pop af
	push de
	push hl
	call Cosine
	pop hl
	pop de
	add 10 * 8 + 4
	ld [hli], a

	xor a
	ld [hli], a
	ld a, 6 ; OBJ 6
	ld [hli], a
	jr .anim_loop

EndOfExpBarGFX: INCBIN "gfx/battle/expbarend.2bpp"
SGBEndOfExpBarGFX: INCBIN "gfx/battle/expbarend_sgb.2bpp"

ClearSpriteAnims2:
	push hl
	push bc
	push af
	call ClearSpriteAnims
	pop af
	pop bc
	pop hl
	ret

ClearSpriteAnims:
	ld hl, wSpriteAnimDict
	ld bc, wSpriteAnimsEnd - wSpriteAnimDict
	xor a
	jp ByteFill
