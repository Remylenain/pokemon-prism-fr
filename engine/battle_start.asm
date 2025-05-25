Predef_StartBattle:
	call InitGFX
	ldh a, [rBGP]
	ld [wBGP], a
	ldh a, [rOBP0]
	ld [wOBP0], a
	ldh a, [rOBP1]
	ld [wOBP1], a
	call DelayFrame
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], 3
	jr .handleLoop

.loop
	jumptable FlashyTransitionJumptable
	call DelayFrame
.handleLoop
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop

	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)

	ld hl, wOriginalBGPals
	ld bc, 8 palettes
	xor a ; black
	call ByteFill

	pop af
	ldh [rSVBK], a

	ld a, %11111111
	ld [wBGP], a
	call DmgToCgbBGPals
	call DelayFrame
	xor a
	ld [wLCDCPointer], a
	ldh [hLYOverridesStart], a
	ldh [hLYOverridesEnd], a
	ldh [hSCY], a

	wbk BANK(wEnemyMon)
	ld hl, rIE
	res LCD_STAT, [hl]
	pop af
	ldh [hVBlank], a
	jp DelayFrame

InitGFX:
	callba AnchorBGMap
	call DelayFrame
	call FillOffscreenPortionOfBGMapWithTile60Attr0
	call UpdateSprites
	call DelayFrame
	call LoadTrainerBattlePokeballTiles
	ld b, 3
	call SafeCopyTilemapAtOnce
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	call DelayFrame
	xor a
	ldh [hBGMapMode], a
	ld hl, wJumptableIndex
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	jp WipeLYOverrides

FillOffscreenPortionOfBGMapWithTile60Attr0:
	lb de, 1, 0
	call .FillOffscreenPortionOfBGMap
	lb de, 0, "<BLACK>"
.FillOffscreenPortionOfBGMap:
	vbk d
	ld hl, vBGMap + SCREEN_WIDTH
	lb bc, %11, LOW(rSTAT)
	ld d, SCREEN_HEIGHT
.loop
	ldh a, [c]
	and b
	jr z, .loop
.waitHBlank
	ldh a, [c]
	and b
	jr nz, .waitHBlank
	ld a, e
	di
	rept BG_MAP_WIDTH - SCREEN_WIDTH
		ld [hli], a
	endr
	ei
	ld a, SCREEN_WIDTH
	add l
	ld l, a
	dec d
	jr nz, .loop
	ret

LoadTrainerBattlePokeballTiles:
; Load the tiles used in the Pokeball Graphic that fills the screen
; at the start of every Trainer battle.
	ld de, TrainerBattlePokeballTiles
	ld hl, vFontTiles tile $7e
	lb bc, BANK(TrainerBattlePokeballTiles), 2
	call Request2bpp

	ldh a, [rVBK]
	push af
	vbk BANK(vWalkingFrameTiles)

	ld de, TrainerBattlePokeballTiles
	ld hl, vWalkingFrameTiles tile $7e
	lb bc, BANK(TrainerBattlePokeballTiles), 2
	call Request2bpp

	pop af
	ldh [rVBK], a
	ret

TrainerBattlePokeballTiles:
INCBIN "gfx/overworld/trainer_battle_pokeball_tiles.2bpp"

FlashyTransitionJumptable:
	dw StartTrainerBattle_DetermineWhichAnimation ; 00

	; Animation 1: cave
	dw StartTrainerBattle_LoadPokeBallGraphics ; 01
	dw StartTrainerBattle_SetUpBGMap ; 02
	dw StartTrainerBattle_Flash ; 03
	dw StartTrainerBattle_Flash ; 04
	dw StartTrainerBattle_Flash ; 05
	dw StartTrainerBattle_NextScene ; 06
	dw StartTrainerBattle_SetUpForWavyOutro ; 07
	dw StartTrainerBattle_SineWave ; 08

	; Animation 2: cave, stronger
	dw StartTrainerBattle_LoadPokeBallGraphics ; 09
	dw StartTrainerBattle_SetUpBGMap ; 0a
	dw StartTrainerBattle_Flash ; 0b
	dw StartTrainerBattle_Flash ; 0c
	dw StartTrainerBattle_Flash ; 0d
	dw StartTrainerBattle_NextScene ; 0e
	; There is no setup for this one
	dw StartTrainerBattle_ZoomToBlack ; 0f

	; Animation 3: no cave
	dw StartTrainerBattle_LoadPokeBallGraphics ; 10
	dw StartTrainerBattle_SetUpBGMap ; 11
	dw StartTrainerBattle_Flash ; 12
	dw StartTrainerBattle_Flash ; 13
	dw StartTrainerBattle_Flash ; 14
	dw StartTrainerBattle_NextScene ; 15
	dw StartTrainerBattle_SetUpForSpinOutro ; 16
	dw StartTrainerBattle_SpinToBlack ; 17

	; Animation 4: no cave, stronger
	dw StartTrainerBattle_LoadPokeBallGraphics ; 18
	dw StartTrainerBattle_SetUpBGMap ; 19
	dw StartTrainerBattle_Flash ; 1a
	dw StartTrainerBattle_Flash ; 1b
	dw StartTrainerBattle_Flash ; 1c
	dw StartTrainerBattle_NextScene ; 1d
	dw StartTrainerBattle_SetUpForRandomScatterOutro ; 1e
	dw StartTrainerBattle_SpeckleToBlack ; 1f

	; Animation 5: gym leader, elite four, or champion
	dw StartTrainerBattle_LoadPokeBallGraphics ; 20
	dw StartTrainerBattle_SetUpBGMap ; 21
	dw StartTrainerBattle_Flash ; 22
	dw StartTrainerBattle_Flash ; 23
	dw StartTrainerBattle_Flash ; 24
	dw StartTrainerBattle_NextScene ; 25
	dw StartTrainerBattle_SetUpForTrainerPortrait ; 26
	dw StartTrainerBattle_LoadTrainerPortrait ; 27
	dw StartTrainerBattle_FadeToWhite ; 28

	; All animations jump to here.
	dw StartTrainerBattle_Finish ; 29

StartTrainerBattle_DetermineWhichAnimation:
; The screen flashes a different number of
; times depending on the level of your lead
; Pokemon relative to the opponent's.
	ld a, [wOtherTrainerClass]
	and a
	jr z, .normal
	callba IsJohtoGymLeader
	jr nc, .normal
	ld a, $20
	ld [wJumptableIndex], a
	ret

.normal
	ld de, 0
	ld a, [wBattleMonLevel]
	add 3
	ld hl, wEnemyMonLevel
	cp [hl]
	jr nc, .not_stronger
	inc e
.not_stronger
	ld a, [wPermission]
	cp CAVE
	jr z, .cave
	cp PERM_5
	jr z, .cave
	cp DUNGEON
	jr z, .cave
	set 1, e
.cave
	ld hl, .StartingPoints
	add hl, de
	ld a, [hl]
	ld [wJumptableIndex], a
	ret

.StartingPoints
	db $01, $09
	db $10, $18

StartTrainerBattle_Finish:
	call ClearSprites
	ld a, $80
	ld [wJumptableIndex], a
	ret

StartTrainerBattle_SetUpBGMap:
	call StartTrainerBattle_NextScene
	xor a
	ld [wcf64], a
	ldh [hBGMapMode], a
	ret

StartTrainerBattle_Flash:
	ld a, [wTimeOfDayPalset]
	inc a ; dark cave
	jr z, .done
	ld c, 1 << 7 | 3
	call FadeBGToDarkestColor
	ld c, 1 << 7 | 3
	call FadeOutBGPals

.done
	xor a
	ld [wcf64], a
	; fallthrough

StartTrainerBattle_NextScene:
	ld hl, wJumptableIndex
	inc [hl]
	ret

StartTrainerBattle_SetUpForWavyOutro:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	wbk BANK(wLYOverrides)

	call StartTrainerBattle_NextScene

	ld a, LOW(rSCX)
	ld [wLCDCPointer], a
	xor a
	ldh [hLYOverridesStart], a
	ld a, $90
	ldh [hLYOverridesEnd], a
	xor a
	ld [wcf64], a
	ld [wcf65], a
	ld hl, rIE
	set LCD_STAT, [hl]
	ret

StartTrainerBattle_SineWave:
	ld a, [wcf64]
	cp $60
	jr c, StartTrainerBattle_DoSineWave
	; fallthrough

StartTrainerBattle_EndScene:
	ld a, $29
	ld [wJumptableIndex], a
	ret

StartTrainerBattle_DoSineWave:
	ld hl, wcf65
	ld a, [hl]
	inc [hl]
	dec hl
	ld d, [hl]
	add [hl]
	ld [hl], a
	ld a, wLYOverridesEnd - wLYOverrides
	ld bc, wLYOverrides
	ld e, 0

.loop
	push af
	push de
	ld a, e
	call Sine
	ld [bc], a
	inc bc
	pop de
	ld a, e
	add a, 2
	ld e, a
	pop af
	dec a
	jr nz, .loop
	ret

StartTrainerBattle_SetUpForSpinOutro:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	wbk BANK(wLYOverrides)
	call StartTrainerBattle_NextScene
	xor a
	ld [wcf64], a
	ret

MACRO spintable_entry
	db \1
	dw .wedge\2
	dwcoord \3, \4
ENDM

; quadrants
	const_def
	const UPPER_LEFT
	const UPPER_RIGHT
	const LOWER_LEFT
	const LOWER_RIGHT

StartTrainerBattle_SpinToBlack:
	xor a
	ld d, a
	ldh [hBGMapMode], a
	ld a, [wcf64]
	ld e, a
	ld hl, .spintable
rept 5
	add hl, de
endr
	ld a, [hli]
	cp -1
	jr z, .end
	ld [wcf65], a
	call .load
	ld a, 1
	ldh [hBGMapMode], a
	call Delay2
	ld hl, wcf64
	inc [hl]
	ret

.end
	call ApplyTilemapInVBlank
	xor a
	ldh [hBGMapMode], a
	jr StartTrainerBattle_EndScene

.spintable
	spintable_entry UPPER_LEFT,  1,  1,  6
	spintable_entry UPPER_LEFT,  2,  0,  3
	spintable_entry UPPER_LEFT,  3,  1,  0
	spintable_entry UPPER_LEFT,  4,  5,  0
	spintable_entry UPPER_LEFT,  5,  9,  0
	spintable_entry UPPER_RIGHT, 5, 10,  0
	spintable_entry UPPER_RIGHT, 4, 14,  0
	spintable_entry UPPER_RIGHT, 3, 18,  0
	spintable_entry UPPER_RIGHT, 2, 19,  3
	spintable_entry UPPER_RIGHT, 1, 18,  6
	spintable_entry LOWER_RIGHT, 1, 18, 11
	spintable_entry LOWER_RIGHT, 2, 19, 14
	spintable_entry LOWER_RIGHT, 3, 18, 17
	spintable_entry LOWER_RIGHT, 4, 14, 17
	spintable_entry LOWER_RIGHT, 5, 10, 17
	spintable_entry LOWER_LEFT,  5,  9, 17
	spintable_entry LOWER_LEFT,  4,  5, 17
	spintable_entry LOWER_LEFT,  3,  1, 17
	spintable_entry LOWER_LEFT,  2,  0, 14
	spintable_entry LOWER_LEFT,  1,  1, 11
	db -1

.load
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	push hl
	ld a, [de]
	ld c, a
	inc de
.loop1
	ld [hl], $ff
	ld a, [wcf65]
	rra
	jr nc, .leftside
	inc hl
	jr .okay1
.leftside
	dec hl
.okay1
	dec c
	jr nz, .loop1
	pop hl
	ld a, [wcf65]
	bit 1, a
	ld bc, SCREEN_WIDTH
	jr z, .upper
	ld bc, -SCREEN_WIDTH
.upper
	add hl, bc
	ld a, [de]
	inc de
	cp -1
	ret z
	and a
	jr z, .loop
	ld c, a
.loop2
	ld a, [wcf65]
	rra
	jr nc, .leftside2
	dec hl
	jr .okay2
.leftside2
	inc hl
.okay2
	dec c
	jr nz, .loop2
	jr .loop

.wedge1: db 2, 3, 5, 4, 9, -1
.wedge2: db 1, 1, 2, 2, 4, 2, 4, 2, 3, -1
.wedge3: db 2, 1, 3, 1, 4, 1, 4, 1, 4, 1, 3, 1, 2, 1, 1, 1, 1, -1
.wedge4: db 4, 1, 4, 0, 3, 1, 3, 0, 2, 1, 2, 0, 1, -1
.wedge5: db 4, 0, 3, 0, 3, 0, 2, 0, 2, 0, 1, 0, 1, 0, 1, -1

StartTrainerBattle_SetUpForRandomScatterOutro:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	wbk BANK(wLYOverrides)
	call StartTrainerBattle_NextScene
	ld a, $10
	ld [wcf64], a
	ld a, 1
	ldh [hBGMapMode], a
	ret

StartTrainerBattle_SpeckleToBlack:
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ld c, 12
.loop
	push bc
	call .BlackOutRandomTile
	pop bc
	dec c
	jr nz, .loop
	ret

.done
	call ApplyTilemapInVBlank
	xor a
	ldh [hBGMapMode], a
	jp StartTrainerBattle_EndScene

.BlackOutRandomTile
.y_loop
	call Random
	cp SCREEN_HEIGHT
	jr nc, .y_loop
	ld b, a

.x_loop
	call Random
	cp SCREEN_WIDTH
	jr nc, .x_loop
	ld c, a

	hlcoord 0, -1
	ld de, SCREEN_WIDTH
	inc b

.row_loop
	add hl, de
	dec b
	jr nz, .row_loop
	add hl, bc

; If the tile has already been blacked out,
; sample a new tile
	ld a, [hl]
	cp $ff
	jr z, .y_loop
	ld [hl], $ff
	ret

MACRO waitHBlank
.waitNo\@
	ldh a, [rSTAT]
	and 3
	jr z, .waitNo\@
.wait\@
	ldh a, [rSTAT]
	and 3
	jr nz, .wait\@
ENDM

StartTrainerBattle_SetUpForTrainerPortrait:
	call ClearSprites
	ld a, [wOtherTrainerClass]
	ld [wTrainerClass], a

; gfx stuff starts here

	vbk BANK(vWalkingFrameTiles)
	ld de, vWalkingFrameTiles
	callba GetTrainerPic_NoWaitBGMap ; calls vbk BANK(vBGMap)

	xor a
	ldh [hBGMapMode], a
	vbk BANK(vWalkingFrameTiles)
	ld de, .VS_Graphic
	ld hl, vWalkingFrameTiles tile $40
	lb bc, BANK(StartTrainerBattle_LoadTrainerPortrait), $40
	call Get2bpp

; tilemap stuff starts here

	vbk BANK(vBGMap)
	hlbgcoord 20, 5
	ld bc, BG_MAP_WIDTH - 12
	lb de, 8, " "
.bgloop
	call .fill12
	dec d
	jr nz, .bgloop

	hlbgcoord 20, 5
	ld bc, BG_MAP_WIDTH - 7
	lb de, 7, $80
	di
.trainerpicloop
	push de
	bit 0, e
	jr nz, .skipwait
	waitHBlank
.skipwait
	ld a, e
	rept 6
	ld [hli], a
	add d
	endr
	ld [hli], a
	add hl, bc
	pop de
	inc e
	ld a, e
	cp $87
	jr nz, .trainerpicloop
	ei

	callba Battle_GetTrainerName
	ld hl, wStringBuffer1
	ld c, 12
.findterminatorloop
	ld a, [hli]
	cp "@"
	jr z, .fillterminator
	dec c
	jr nz, .findterminatorloop
	jr .skipterminatorloop
.fillterminator
	ld a, " "
	dec hl
.fillterminatorloop
	ld [hli], a
	dec c
	jr nz, .fillterminatorloop
.skipterminatorloop
	hlbgcoord 20, 12
	di
	ld [hSPBuffer], sp
	ld sp, wStringBuffer1
	pop bc
	pop de
	waitHBlank
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	rept 3
	pop de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	endr
	pop de
	ld a, e
	ld [hli], a
	ld [hl], d
	ld sp, hSPBuffer
	pop hl
	ld sp, hl
	ei

; attrmap stuff starts here

	vbk BANK(vBGAttrs)
	hlbgcoord 20, 5
	ld bc, BG_MAP_WIDTH - 12
	lb de, 7, $e
.bgattrloop
	call .fill12
	dec d
	jr nz, .bgattrloop
	ld e, 6
	call .fill12
	vbk BANK(vBGMap)

; palette stuff starts here

	ld e, 0
	callba LoadMonOrTrainerPals

	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	ld hl, .Palette
	ld de, wOBPals
	ld bc, 1 palettes
	rst CopyBytes
	ld hl, wOriginalBGPals
	ld de, wBGPals + 6 palettes
	ld bc, 1 palettes
	rst CopyBytes
	pop af
	ldh [rSVBK], a

	ld a, 1
	ldh [hCGBPalUpdate], a
	jp StartTrainerBattle_NextScene

.fill12
	di
	waitHBlank
	ld a, e
	rept 12
	ld [hli], a
	endr
	add hl, bc
	reti

.VS_Graphic: INCBIN "gfx/battle/vs_gfx.w64.interleave.2bpp"
.Palette:
	RGB 31, 31, 31
	RGB 08, 19, 28
	RGB 31, 06, 06
	RGB 00, 00, 00

VS_TIME                  EQU 255
VS_POS_X                 EQU 25
VS_POS_Y                 EQU 56
VS_SHAKE_RADIUS_INIT     EQU 20
VS_SHAKE_RADIUS          EQU 3
VS_SHAKE_RATE            EQU 2
VS_SCROLL_RATE           EQU 11

MACRO polarstruct
	db ATAN2(\1, \2) >> 8
	db \3 ; sqrt(\1 ** 2 + \2 ** 2) * 4
ENDM

VSInitPolarPos:
	polarstruct -24.0, -28.0, 148
	polarstruct -24.0, -20.0, 125
	polarstruct -24.0, -12.0, 107
	polarstruct -24.0,  -4.0,  97
	polarstruct -24.0,   4.0,  97
	polarstruct -24.0,  12.0, 107
	polarstruct -24.0,  20.0, 125
	polarstruct -24.0,  28.0, 148
	polarstruct  -8.0, -28.0, 116
	polarstruct  -8.0, -20.0,  86
	polarstruct  -8.0, -12.0,  58
	polarstruct  -8.0,  -4.0,  36
	polarstruct  -8.0,   4.0,  36
	polarstruct  -8.0,  12.0,  58
	polarstruct  -8.0,  20.0,  86
	polarstruct  -8.0,  28.0, 116
	polarstruct   8.0, -28.0, 116
	polarstruct   8.0, -20.0,  86
	polarstruct   8.0, -12.0,  58
	polarstruct   8.0,  -4.0,  36
	polarstruct   8.0,   4.0,  36
	polarstruct   8.0,  12.0,  58
	polarstruct   8.0,  20.0,  86
	polarstruct   8.0,  28.0, 116
	polarstruct  24.0, -28.0, 148
	polarstruct  24.0, -20.0, 125
	polarstruct  24.0, -12.0, 107
	polarstruct  24.0,  -4.0,  97
	polarstruct  24.0,   4.0,  97
	polarstruct  24.0,  12.0, 107
	polarstruct  24.0,  20.0, 125
	polarstruct  24.0,  28.0, 148

StartTrainerBattle_LoadTrainerPortrait:
	xor a
	ldh [rLYC], a
	ld hl, rLCDC
	set 2, [hl] ; 8x16 sprites
	wbk BANK(wLYOverrides)
	ld a, 5
	ldh [hBGMapMode], a
	dec a
	ldh [hBGMapHalf], a
	ld a, 10
	ldh [hTilesPerCycle], a
	ld a, 40
	ld [wcf64], a

; background swipe + imploding vs

	hlbgcoord 0, 4
	ld e, 20
.initswipeloop
	push de
	push hl
	call .updatevs
	call StartTrainerBattle_UpdateScroll
	call DelayFrame
	pop hl
	push hl
	ld bc, (wTileMap + SCREEN_WIDTH * 4) - (vBGMap + BG_MAP_WIDTH * 4)
	add hl, bc
	ld bc, SCREEN_WIDTH
	lb de, "─", " "
	call .copy9nowait
	ld [hl], "─"
	ld bc, BG_MAP_WIDTH
	pop hl
	push hl
	lb de, "─", " "
	call .copy9
	ld [hl], "─"

; attr map time
	vbk BANK(vBGAttrs)
	pop hl
	push hl
	lb de, 6, 6
	call .copy9
	ld [hl], $46
	vbk BANK(vBGMap)
	ld hl, wcf64
	dec [hl]
	pop hl
	inc hl
	pop de
	dec e
	jr nz, .initswipeloop

; slide in trainer pic and name

	xor a
	ld hl, wcf66
	ld [hli], a
	ld [hl], a
	ld a, 40
	ldh [rLYC], a
	ld a, 1 << 6 ; LYC interrupt
	ldh [rSTAT], a
	di
	ld hl, LCD_VSTrick
	ld de, wLCD
	ld bc, LCD_VSTrickEnd - LCD_VSTrick
	rst CopyBytes
	ei
	ld hl, rIE
	set LCD_STAT, [hl]
	ld e, 20
.slideinloop
	push de
	ld hl, wcf66
	ld a, [hl]
	add 3
	ld [hli], a
	ld a, [hl]
	sub 8
	ld [hl], a
	call .updatevs
.notdoneyet
	call StartTrainerBattle_UpdateScroll
	jr nc, .notdoneyet
	pop de
	ld a, e
	dec a ; don't delay the last frame
	call nz, DelayFrame
	ld hl, wcf64
	dec [hl]
	dec e
	jr nz, .slideinloop

	ld a, VS_TIME
	ld [wcf64], a
	jp StartTrainerBattle_NextScene

.copy9
	waitHBlank
.copy9nowait
	ld [hl], d
	add hl, bc
	rept 8
	ld [hl], e
	add hl, bc
	endr
	ret

.calcimplode
	ld hl, wcf65
	call GetDemoSine
	bit 7, a
	ld [hl], 0
	jr z, .notminus
	inc [hl]
	cpl
.notminus
	ld hl, 0
	ld b, l
	rst AddNTimes
	ld c, h
	ld h, b
	ld l, b
	ld a, [wcf64]
	add 4
	rst AddNTimes
	rept 3
	srl h
	rr l
	endr
	ret

.updatevs
	ld c, 32
	ld hl, VSInitPolarPos
	ld de, wSprites
.vsupdateloop
	call StartTrainerBattle_UpdateScroll
	push bc
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld a, [wcf64]
	add a
	add a
	add b
	ld b, a
	push bc
	call .calcimplode
	ld a, h
	and a
	jr nz, .over1
	ld a, [wcf65]
	and a
	ld a, VS_POS_Y + 24
	jr nz, .sub1
	add l
	jr c, .over1
	jr .skip1
.sub1
	sub l
	jr nc, .skip1
.over1
	xor a
.skip1
	ld [de], a
	inc de
	pop bc
	ld a, b
	add 64 ; turn into cos
	call .calcimplode
	ld a, h
	and a
	jr nz, .over2
	ld a, [wcf65]
	and a
	ld a, VS_POS_X + 28
	jr nz, .sub2
	add l
	jr c, .over2
	jr .skip2
.sub2
	sub l
	jr nc, .skip2
.over2
	xor a
.skip2
	ld [de], a
	inc de
	pop hl
	pop bc
	ld a, $80
	sub c
	add a
	ld [de], a
	inc de
	ld a, 8
	ld [de], a
	inc de
	dec c
	jr nz, .vsupdateloop
	ret

StartTrainerBattle_UpdateScroll:
	ldh a, [rLYC]
	and a
	ret z
	ld b, a
	ldh a, [rLY]
	cp b
	jr nc, .scrolled
.retnocarry
	xor a
	ret
.scrolled
	cp 40 ; start of trainer pic
	jr nc, .gt40
	ld a, 40
	ldh [rLYC], a
	ld a, [wcf66]
	ld [wLYOverrides], a
	jr .retnocarry
.gt40
	cp 96 ; start of trainer name
	jr nc, .gt96
	ld a, 96
	ldh [rLYC], a
	ld a, [wcf67]
	ld [wLYOverrides], a
	jr .retnocarry
.gt96
	cp 104 ; end of trick
	jr nc, .gt104
	ld a, 104
	ldh [rLYC], a
	xor a
	ld [wLYOverrides], a
	jr .retnocarry
.gt104
	xor a
	ld [wLYOverrides], a
	inc a
	ldh [rLYC], a
	scf
	ret

StartTrainerBattle_LoadPokeBallGraphics:
	ld a, [wOtherTrainerClass]
	and a
	jp z, StartTrainerBattle_NextScene ; don't need to be here if wild

	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	inc b
	inc c
	jr .handleLoop

.loop
; set all pals to 7
	ld a, [hl]
	or %00000111
	ld [hli], a
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop

	ld de, PokeBallTransition
	hlcoord 2, 1

	ld b, SCREEN_WIDTH - 4
.loop2
	push hl
	ld c, 2
.loop3
	push hl
	ld a, [de]
	inc de
.loop4
; Loading is done bit by bit
	and a
	jr z, .done
	add a, a
	jr nc, .no_load
	ld [hl], $fe
.no_load
	inc hl
	jr .loop4

.done
	pop hl
	push bc
	ld bc, (SCREEN_WIDTH - 4) / 2
	add hl, bc
	pop bc
	dec c
	jr nz, .loop3

	pop hl
	push bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop2

	ld hl, .daypals
	ld a, [wTimeOfDayPal]
	and (1 << 2) - 1
	cp 3
	jr nz, .daytime
	ld hl, .nightpals
.daytime
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	call .copypals
	push hl
	ld de, wOriginalBGPals + 7 palettes
	ld bc, 1 palettes
	rst CopyBytes
	pop hl
	ld de, wBGPals + 7 palettes
	ld bc, 1 palettes
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	call DelayFrame
	call CopyTilemapAtOnce
	jp StartTrainerBattle_NextScene

.copypals
	ld de, wOriginalBGPals + 7 palettes
	call .copy
	ld de, wBGPals + 7 palettes

.copy
	push hl
	ld bc, 1 palettes
	rst CopyBytes
	pop hl
	ret

.daypals
	RGB 31, 18, 29
	RGB 31, 11, 15
	RGB 31, 05, 05
	RGB 07, 07, 07

.nightpals
	RGB 31, 18, 29
	RGB 31, 05, 05
	RGB 31, 05, 05
	RGB 31, 05, 05

PokeBallTransition:
	db %00000011, %11000000
	db %00001111, %11110000
	db %00111100, %00111100
	db %00110000, %00001100
	db %01100000, %00000110
	db %01100011, %11000110
	db %11000110, %01100011
	db %11111100, %00111111
	db %11111100, %00111111
	db %11000110, %01100011
	db %01100011, %11000110
	db %01100000, %00000110
	db %00110000, %00001100
	db %00111100, %00111100
	db %00001111, %11110000
	db %00000011, %11000000

WipeLYOverrides:
	ldh a, [rSVBK]
	push af
	wbk BANK(wLYOverrides)

	ld hl, wLYOverrides
	call .wipe
	ld hl, wLYOverridesBackup
	call .wipe

	pop af
	ldh [rSVBK], a
	ret

.wipe
	xor a
	ld c, SCREEN_HEIGHT_PX
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

MACRO zoombox
; width, height, start y, start x
	db \1, \2
	dwcoord \3, \4
ENDM

StartTrainerBattle_FadeToWhite:
	ld a, [wcf64]
	cp VS_TIME
	jr z, .first_frame
	cp 65
	call c, .fade2white
	ld hl, wcf68
	dec [hl]
	jr nz, .skipshake
	ld a, VS_SHAKE_RATE
	ld [hl], a
	call Random
	ld c, a
	call GetDemoSine
	bit 7, a
	ld b, 0
	jr z, .notminus
	ld b, $ff
.notminus
	ld c, a
	ld a, [wcf65]
	ld hl, 0
	rst AddNTimes
	ld a, VS_POS_Y
	add h
	ld d, a
	ld a, c
	add 64 ; turn into cos
	call GetDemoSine
	bit 7, a
	ld b, 0
	jr z, .notminus2
	ld b, $ff
.notminus2
	ld c, a
	ld a, [wcf65]
	ld hl, 0
	rst AddNTimes
	ld a, VS_POS_X
	add h
	ld e, a
	call .position_vs
	ld a, [wcf65]
	cp VS_SHAKE_RADIUS
	jr z, .skipshake
	dec a
	ld [wcf65], a
.skipshake
	ld hl, wcf69
	dec [hl]
	jr nz, .notdoneyet
	ld a, VS_SCROLL_RATE
	ld [hl], a
	ld hl, wcf66
	inc [hl]
	inc hl
	dec [hl]
	jr .notdoneyet
.first_frame
	ld a, 1
	ld [wcf68], a
	ld a, VS_SCROLL_RATE
	ld [wcf69], a
	ld a, VS_SHAKE_RADIUS_INIT
	ld [wcf65], a
	lb de, VS_POS_Y, VS_POS_X
	call .position_vs
.notdoneyet
	call StartTrainerBattle_UpdateScroll
	jr nc, .notdoneyet
	ld hl, wcf64
	dec [hl]
	ret nz

	ld hl, rLCDC
	res 2, [hl] ; 8x8 sprites
	xor a
	ldh [rLYC], a
	ld a, 1 << 3 ; HBlank interrupt
	ldh [rSTAT], a
	ld c, 15
	call DelayFrames
	ld a, $29
	ld [wJumptableIndex], a
	jp LoadLCDCode

.fade2white
	rra
	ld hl, wBGPals
	jr nc, .bgp
	ld hl, wOBPals
	ld a, 1
	ldh [hCGBPalUpdate], a
.bgp
	ld d, 32
.loop2
	call StartTrainerBattle_UpdateScroll
	ld a, [hl]
	and $1f
	cp $1f
	jr z, .skip
	inc a
.skip
	ld c, a
	inc hl
	ld a, [hld]
	and 3
	ld b, a
	ld a, [hl]
	and $e0
	or b
	cp $e3
	jr z, .skip2
	and $e0
	add $20
	jr nc, .skip2
	inc b
.skip2
	or c
	ld [hli], a
	ld a, [hl]
	and $7c
	cp $7c
	jr z, .skip3
	add 4
.skip3
	or b
	ld [hli], a
	dec d
	jr nz, .loop2
	ret

.position_vs
	call StartTrainerBattle_UpdateScroll
	ld hl, wSprites
	ld b, 4
.ploop
	push de
	ld c, 8
.ploop2
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	inc hl
	inc hl
	ld a, e
	add 8
	ld e, a
	dec c
	jr nz, .ploop2
	pop de
	ld a, d
	add 16
	ld d, a
	dec b
	jr nz, .ploop
	ret

StartTrainerBattle_ZoomToBlack:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	ld de, .boxes
	jr .handleLoop
.loop
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	xor a
	ldh [hBGMapMode], a
	dec a
	call FillBoxWithByte
	call ApplyTilemapInVBlank
.handleLoop
	ld a, [de]
	cp -1
	jr nz, .loop
	jp StartTrainerBattle_EndScene

.boxes
	zoombox  4,  2,  8, 8
	zoombox  6,  4,  7, 7
	zoombox  8,  6,  6, 6
	zoombox 10,  8,  5, 5
	zoombox 12, 10,  4, 4
	zoombox 14, 12,  3, 3
	zoombox 16, 14,  2, 2
	zoombox 18, 16,  1, 1
	zoombox 20, 18,  0, 0
	db -1

.Copy
	ld a, $ff
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret
