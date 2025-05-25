EvolutionAnimation:
	push hl
	push de
	push bc
	ld a, [wCurSpecies]
	ld d, a
	ldh a, [rOBP0]
	ld e, a
	push de
	ld a, [wBaseDexNo]
	push af

	call .EvolutionAnimation

	pop af
	ld [wBaseDexNo], a
	pop de
	ld a, e
	ldh [rOBP0], a
	ld a, d
	ld [wCurSpecies], a
	pop bc
	pop de
	pop hl

	ld a, [wEvolutionCanceled]
	and a
	ret z

	scf
	ret

.EvolutionAnimation
	ld a, $e4
	ldh [rOBP0], a

	ld de, MUSIC_NONE
	call PlayMusic

	callba ClearSpriteAnims

	ld de, .GFX
	ld hl, vObjTiles
	lb bc, BANK(.GFX), 8
	call Request2bpp

	xor a
	ld [wLowHealthAlarm], a
	call ApplyTilemapInVBlank
	xor a
	ld c, a
	ldh [hBGMapMode], a
	ld a, [wEvolutionPrevSpecies]
	ld [wPlayerHPPal], a
	call .GetSGBLayout
	ld a, [wEvolutionPrevSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	hlcoord 7, 2
	call PrepMonFrontpic

	ld de, vBGTiles
	ld hl, vBGTiles tile (7 * 7)
	ld bc, 7 * 7
	call Request2bpp

	ld a, 7 * 7
	call .ReplaceFrontpic
	ld a, [wEvolutionNewSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call .LoadFrontpic
	ld a, [wEvolutionPrevSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a

	ld a, 1
	ldh [hBGMapMode], a
	call .check_statused
	ld a, [wEvolutionPrevSpecies]
	call nc, PlayCry
	ld de, MUSIC_EVOLUTION
	call PlayMusic

	ld c, 80
	call DelayFrames

	ld c, 1
	call .GetSGBLayout
	call .AnimationSequence
	jr c, .cancel_evo

	ld a, -7 * 7
	call .ReplaceFrontpic
	xor a
	ld [wEvolutionCanceled], a
	ld c, a
	ld a, [wEvolutionNewSpecies]
	ld [wPlayerHPPal], a
	call .GetSGBLayout
	call .PlayEvolvedSFX
	callba ClearSpriteAnims
	call .check_statused
	ret c

	ld a, [wBoxAlignment]
	push af
	ld a, 1
	ld [wBoxAlignment], a
	ld a, [wCurPartySpecies]
	push af

	ld a, [wPlayerHPPal]
	ld [wCurPartySpecies], a
	hlcoord 7, 2
	lb de, 0, ANIM_MON_EVOLVE
	predef AnimateFrontpic

	pop af
	ld [wCurPartySpecies], a
	pop af
	ld [wBoxAlignment], a
	ret

.cancel_evo
	ld a, 1
	ld [wEvolutionCanceled], a

	ld a, [wEvolutionPrevSpecies]
	ld [wPlayerHPPal], a

	ld c, 0
	call .GetSGBLayout
	call .PlayEvolvedSFX
	callba ClearSpriteAnims
	call .check_statused
	ret c

	ld a, [wPlayerHPPal]
	jp PlayCry

.GetSGBLayout
	ld b, SCGB_EVOLUTION
	predef_jump GetSGBLayout

.LoadFrontpic
	call GetBaseData
	ld a, 1
	ld [wBoxAlignment], a
	ld de, vBGTiles
	predef GetAnimatedFrontpic
	xor a
	ld [wBoxAlignment], a
	ret

.AnimationSequence
	call ClearJoypad
	lb bc, 1, 2 * 7 ; flash b times, wait c frames in between
.animation_sequence_loop
	push bc
	call .WaitFrames_CheckPressedB
	pop bc
	ret c
	push bc
.flash_loop
	ld a, -7 * 7 ; new stage
	call .ReplaceFrontpic
	ld a, 7 * 7 ; previous stage
	call .ReplaceFrontpic
	dec b
	jr nz, .flash_loop
	pop bc
	inc b
	dec c
	dec c
	jr nz, .animation_sequence_loop
	and a
	ret

.ReplaceFrontpic
	ld [wEvolutionFrontpicTileOffset], a
	push bc
	xor a
	ldh [hBGMapMode], a
	hlcoord 7, 2
	lb bc, 7, 7
	ld de, SCREEN_WIDTH - 7
.frontpic_replacement_loop
	push bc
.frontpic_replacement_inner_loop
	ld a, [wEvolutionFrontpicTileOffset]
	add [hl]
	ld [hli], a
	dec c
	jr nz, .frontpic_replacement_inner_loop
	pop bc
	add hl, de
	dec b
	jr nz, .frontpic_replacement_loop
	ld a, 1
	ldh [hBGMapMode], a
	call ApplyTilemapInVBlank
	pop bc
	ret

.WaitFrames_CheckPressedB
	call DelayFrame
	push bc
	call JoyTextDelay
	ldh a, [hJoyDown]
	pop bc
	and B_BUTTON
	jr z, .no_B_press
	ld a, [wForceEvolution]
	cp 1
	ret c
.no_B_press
	dec c
	jr nz, .WaitFrames_CheckPressedB
	ret

.check_statused
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Species
	call GetPartyLocation
	ld b, h
	ld c, l
	jpba CheckFaintedFrzSlp

.PlayEvolvedSFX
	ld a, [wEvolutionCanceled]
	and a
	ret nz
	ld de, SFX_EVOLVED
	call PlaySFX
	ld hl, wJumptableIndex
	ld a, [hl]
	push af
	ld [hl], 0
.initial_balls_of_light_loop
	call .balls_of_light
	jr nc, .do_balls_of_light_animation
	call .AnimateBallsOfLight
	jr .initial_balls_of_light_loop
.do_balls_of_light_animation
	ld c, 32
.balls_of_light_animation_external_loop
	call .AnimateBallsOfLight
	dec c
	jr nz, .balls_of_light_animation_external_loop
	pop af
	ld [wJumptableIndex], a
	ret

.balls_of_light
	ld hl, wJumptableIndex
	ld a, [hl]
	cp 32
	ret nc
	ld d, a
	inc [hl]
	and 1
	jr nz, .done_balls
	ld e, a ; 0
	call .GenerateBallOfLight
	ld e, $10
	call .GenerateBallOfLight
.done_balls
	scf
	ret

.GenerateBallOfLight
	push de
	depixel 9, 11
	ld a, SPRITE_ANIM_INDEX_EVOLUTION_BALL_OF_LIGHT
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld a, [wJumptableIndex]
	and %1110
	add a, a
	pop de
	add e
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], 0
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld [hl], $10
	ret

.AnimateBallsOfLight
	push bc
	callba PlaySpriteAnimations
	; a = (([hVBlankCounter] + 4) / 2) % NUM_PALETTES
	ldh a, [hVBlankCounter]
	srl a
	inc a
	inc a
	and 7
	ld b, a
	ld hl, wSprites + 3 ; attributes
	ld c, 40
.balls_of_light_animation_loop
	ld a, [hl]
	or b
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .balls_of_light_animation_loop
	pop bc
	jp DelayFrame

.GFX
INCBIN "gfx/evo/bubble_large.2bpp"
INCBIN "gfx/evo/bubble.2bpp"
