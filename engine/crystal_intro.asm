Copyright_GFPresents:
	ld de, MUSIC_NONE
	call PlayMusic
	call ClearBGPalettes
	call ClearTileMap
	ld a, HIGH(vBGMap)
	ldh [hBGMapAddress + 1], a
	xor a
	ldh [hBGMapAddress], a
	ldh [hJoyDown], a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	call ApplyTilemapInVBlank
	ld b, SCGB_SECOND_LOGO
	predef GetSGBLayout
	ld c, 10
	call DelayFrames
	xor a
	ldh [rBGP], a
	ldh a, [hCGB]
	cp GBC_BOOT_VALUE
	push af
	call nz, DisableLCD
	callba Copyright
	call EnableLCD
	pop af
	jr z, .gbc
	call DMGCompatBGMapTransfer
	ld a, 7
	ldh [hVBlank], a
	ld hl, DMGFadeFromWhiteTable
	call DMGFade
	call .CopyrightWait
	ld hl, DMGFadeToBlackTable
	call DMGFade
	call DelayFrame
	ld a, $ff
	ldh [rBGP], a
	jpba GBCOnlyScreen

.gbc
	call ApplyTilemapInVBlank
	ld c, 1
	call FadeOutBGPals
	call .CopyrightWait
	ld c, 1
	call FadeBGToLightestColor
	call ClearTileMap
	ld b, SCGB_SECOND_LOGO
	predef GetSGBLayout
	callba ApplyPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	call DelayFrame
	call GS_Copyright_Intro
	ret c
	ld b, SCGB_GAMEFREAK_LOGO
	predef GetSGBLayout
	call SetPalettes
	call .GetGFLogoGFX
	jr .handleLoop

.loop
	jumptable GameFreakPresentsJumptable
	callba PlaySpriteAnimations
	call DelayFrame
.handleLoop
	call JoyTextDelay
	ldh a, [hJoyLast]
	and BUTTONS
	jr nz, .pressed_button
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop
.finish
	call .StopGamefreakAnim
	and a
	ret

.pressed_button
	call .StopGamefreakAnim
	scf
	ret

.CopyrightWait
	ld c, 100
	jp DelayFrames

.GetGFLogoGFX
	ld de, GameFreakLogo
	ld hl, vBGTiles
	lb bc, BANK(GameFreakLogo), $1c
	call Get1bpp

	ld hl, IntroLogoGFX
	ld de, vObjTiles
	lb bc, BANK(IntroLogoGFX), $80
	call DecompressRequest2bpp
	ld hl, vFontTiles
	ld de, wDecompressScratch + $80 tiles
	ld c, $80
	call Request2bppInWRA6

	callba ClearSpriteAnims
	depixel 10, 11, 4, 0
	ld a, SPRITE_ANIM_INDEX_GAMEFREAK_LOGO
	call _InitSpriteAnimStruct
	ld hl, 7
	add hl, bc
	ld [hl], $a0
	ld hl, 12
	add hl, bc
	ld [hl], $60
	ld hl, 13
	add hl, bc
	ld [hl], $30
	xor a
	ld [wJumptableIndex], a
	ld [wIntroSceneFrameCounter], a
	ld [wcf65], a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, 1
	ldh [hBGMapMode], a
	ld a, $90
	ldh [hWY], a
	ld de, $e4e4
	jp DmgToCgbObjPals

.StopGamefreakAnim
	callba ClearSpriteAnims
	call ClearTileMap
	call ClearSprites
	ld c, 16
	jp DelayFrames

; Looks bad on emulator if the lcd lag is not emulated. Please enable blending or check on
; hardware before modifying.
DMGFade::
	ld b, 3
.loop
	ld c, 12
.loop2
	ld a, c
	cp 7
	jr nc, .skip
	rra
	jr nc, .skip
	inc hl
	ld a, [hld]
	jr .skip2
.skip
	ld a, [hl]
.skip2
	ldh [rBGP], a
	call DelayFrame
	dec c
	jr nz, .loop2
	inc hl
	dec b
	jr nz, .loop
	ret

MACRO bgp
	db \1 << 6 | \2 << 4 | \3 << 2 | \4
ENDM

DMGFadeToWhiteTable::
	bgp 3, 2, 1, 0
	bgp 2, 1, 0, 0
	bgp 1, 0, 0, 0
	bgp 0, 0, 0, 0

DMGFadeToBlackTable:
	bgp 0, 1, 2, 3
	bgp 1, 2, 3, 3
	bgp 2, 3, 3, 3
	bgp 3, 3, 3, 3

DMGFadeFromWhiteTable:
	bgp 0, 0, 0, 0
	bgp 0, 0, 0, 1
	bgp 0, 0, 1, 2
	bgp 0, 1, 2, 3

GameFreakPresentsJumptable:
	dw GenericDummyFunction
	dw PlaceGameFreakPresents_1
	dw PlaceGameFreakPresents_2
	dw PlaceGameFreakPresents_3

PlaceGameFreakPresents_AdvanceIndex:
	ld hl, wJumptableIndex
	inc [hl]
	ret

PlaceGameFreakPresents_1:
	ld hl, wcf65
	ld a, [hl]
	cp $20
	jr nc, .PlaceGameFreak
	inc [hl]
	ret

.PlaceGameFreak
	ld [hl], 0
	ld hl, .GAME_FREAK
	decoord 5, 10
	ld bc, .end - .GAME_FREAK
	rst CopyBytes
	call PlaceGameFreakPresents_AdvanceIndex
	ld de, SFX_GAME_FREAK_PRESENTS
	jp PlaySFX

.GAME_FREAK
	;  G  A  M  E   _  F  R  E  A  K
	db 0, 1, 2, 3, 13, 4, 5, 3, 1, 6
.end
	db "@"

PlaceGameFreakPresents_2:
	ld hl, wcf65
	ld a, [hl]
	cp $40
	jr nc, .place_presents
	inc [hl]
	ret

.place_presents
	ld [hl], 0
	ld hl, .presents
	decoord 7, 11
	ld bc, .end - .presents
	rst CopyBytes
	jp PlaceGameFreakPresents_AdvanceIndex

.presents
	db 7, 8, 9, 10, 11, 12
.end
	db "@"

PlaceGameFreakPresents_3:
	ld hl, wcf65
	ld a, [hl]
	cp $80
	jr nc, .finish
	inc [hl]
	ret

.finish
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

GameFreakLogoJumper:
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld a, [hl]
	jumptable

GameFreakLogoScenes:
	dw GameFreakLogoScene1
	dw GameFreakLogoScene2
	dw GameFreakLogoScene3
	dw GameFreakLogoScene4
	dw GenericDummyFunction

GameFreakLogoScene1:
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	inc [hl]
	ret

GameFreakLogoScene2:
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_e4747
	ld d, a
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	and $3f
	cp $20
	jr nc, .asm_e4723
	add $20
.asm_e4723
	call Sine
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	dec [hl]
	and $1f
	ret nz
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld a, [hl]
	sub $30
	ld [hl], a
	ld de, SFX_DITTO_BOUNCE
	jp PlaySFX

.asm_e4747
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	inc [hl]
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld [hl], 0
	ld de, SFX_DITTO_POP_UP
	jp PlaySFX

GameFreakLogoScene3:
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	cp $20
	jr nc, .asm_e4764
	inc [hl]
	ret

.asm_e4764
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	inc [hl]
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld [hl], 0
	ld de, SFX_DITTO_TRANSFORM
	jp PlaySFX

GameFreakLogoScene4:
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	cp $40
	jr z, .asm_e47a3
	inc [hl]
	srl a
	srl a
	ld e, a
	ld d, 0
	ld hl, GameFreakLogoPalettes
	add hl, de
	add hl, de
	ldh a, [rSVBK]
	push af
	wbk BANK(wOBPals)
	ld a, [hli]
	ld [wOBPals + 12], a
	ld a, [hli]
	ld [wOBPals + 13], a
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

.asm_e47a3
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	inc [hl]
	jp PlaceGameFreakPresents_AdvanceIndex

GameFreakLogoPalettes:
; Ditto's color as it turns into the Game Freak logo.
; Fade from pink to orange.
; One color per step.
	RGB 23, 12, 28
	RGB 23, 12, 27
	RGB 23, 13, 26
	RGB 23, 13, 24

	RGB 24, 14, 22
	RGB 24, 14, 20
	RGB 24, 15, 18
	RGB 24, 15, 16

	RGB 25, 16, 14
	RGB 25, 16, 12
	RGB 25, 17, 10
	RGB 25, 17, 08

	RGB 26, 18, 06
	RGB 26, 18, 04
	RGB 26, 19, 02
	RGB 26, 19, 00

GameFreakLogo: INCBIN "gfx/splash/logo.1bpp"

GS_Copyright_Intro:
	ldh a, [hJoypadDown]
	ld b, a
	and A_BUTTON | START
	ret nz
	ld a, b
	cp B_BUTTON | D_UP | SELECT
	ret z
	ld hl, RdLogo
	ld de, vFontTiles
	lb bc, BANK(RdLogo), $40
	call DecompressRequest2bpp
	ld de, TextBoxSpaceGFX
	ld hl, vBGTiles tile $7f
	lb bc, BANK(TextBoxSpaceGFX), 1
	call Request2bpp
	ld a, $40
	ldh [hBGMapAddress], a
	ld a, $9a
	ldh [hBGMapAddress + 1], a
	ld a, 2
	ldh [hBGMapMode], a
	call Delay2
	ld a, 1
	ldh [hBGMapMode], a
	call Delay2
	xor a
	ldh [hBGMapAddress], a
	ld a, $98
	ldh [hBGMapAddress + 1], a
	ld a, $80
	ld de, SCREEN_WIDTH
	hlcoord 6, 2
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	hlcoord 4, 3
	rept 3
	ld [hli], a
	inc a
	endr
	hlcoord 3, 4
	lb bc, 1, 4
	call .drawgfx
	hlcoord 2, 5
	lb bc, 1, 4
	call .drawgfx
	hlcoord 1, 6
	lb bc, 1, 5
	call .drawgfx
	hlcoord 0, 7
	lb bc, 1, 5
	call .drawgfx
	hlcoord 6, 7
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	hlcoord 14, 7
	ld [hl], a
	inc a
	hlcoord 0, 8
	lb bc, 2, 19
	call .drawgfx
	hlcoord 1, 4, wAttrMap
	lb bc, 3, 6
	ld a, 2
	ldh [hBGMapMode], a
	dec a
	ldh [hCGBPalUpdate], a
	call FillBoxWithByte
	hlcoord 0, 8, wAttrMap
	lb bc, 2, 4
	inc a
	call FillBoxWithByte
	hlcoord 4, 7, wAttrMap
	lb bc, 3, 1
	inc a
	call FillBoxWithByte
	hlcoord 5, 7, wAttrMap
	lb bc, 3, 4
	inc a
	call FillBoxWithByte
	hlcoord 9, 7, wAttrMap
	lb bc, 3, 10
	inc a
	call FillBoxWithByte
	ldh a, [rSVBK]
	push af
	wbk BANK(wBGPals)
	ld hl, RdLogoPals
	ld de, wBGPals
	ld bc, 6 palettes
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	ld c, 3
	call DelayFrames
	ld a, 1
	ldh [hBGMapMode], a
	call Delay2
	xor a
	ldh [hBGMapMode], a
	ld [wcf64], a
	call Random
	ld [wcf66], a
	ld a, 3
	ld [wcf65], a
	ld a, 3
	ldh [hVBlank], a
	ld de, SFX_NSOMNIART_LOGO
	call PlaySFX
	wbk BANK(wLYOverrides)
	ld hl, wLYOverrides
	ld bc, wLYOverridesEnd - wLYOverrides
	xor a
	call ByteFill
	di
	ld hl, LCD_Logo
	ld de, wLCD
	ld bc, LCD_LogoEnd - LCD_Logo
	rst CopyBytes
	ei
	ld hl, rIE
	set LCD_STAT, [hl]
	ld bc, 333

.loop
	push bc
	ld a, [wcf65]
	dec a
	jr nz, .noadd
	ld a, [wcf64]
	inc a
	ld [wcf64], a
	ld a, 3
.noadd
	ld [wcf65], a
	ld a, [wcf64]
	cp 64
	jr nc, .notrick
	add 128
	call GetDemoSine
	sub 128
	srl a
	ld d, a
	srl a
	ld e, a
	ld a, [wcf66]
	add e
	ld [wcf66], a
	ld b, a
	ld hl, wLYOverrides
	ld e, 144
.loop2
	ld a, e
	add a
	add a
	add a
	add b
	call GetDemoSine
	push hl
	push bc
	ld c, a
	ld a, d
	bit 7, c
	ld hl, 0
	ld b, l
	jr z, .plus
	ld b, $ff
.plus
	rst AddNTimes
	ld a, h
	pop bc
	pop hl
	ld [hli], a
	dec e
	jr nz, .loop2
	jr .done

.notrick
	ld hl, rIE
	res LCD_STAT, [hl]
.done
	call DelayFrame
	call Joypad
	call JoyTextDelay
	ldh a, [hJoyLast]
	and BUTTONS
	jr nz, .pressed_button
	pop bc
	dec bc
	ld a, b
	or c
	jr nz, .loop
.deinit
	xor a
	ldh [hVBlank], a
	wbk BANK(wPlayerName)
	ld hl, rIE
	res LCD_STAT, [hl]
	call LoadLCDCode
	jp ClearTileMap

.pressed_button
	pop bc
	call .deinit
	scf
	ret

.drawgfx
	push bc
	push hl
.drawgfxx
	ld [hli], a
	inc a
	dec c
	jr nz, .drawgfxx
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .drawgfx
	ret

LCD_Logo:
	push af
	push hl
	ldh a, [rLY]
	ld l, a
	ld h, HIGH(wLYOverrides)
	ld a, [hl]
	ldh [rSCY], a
	pop hl
	pop af
	reti
LCD_LogoEnd:

RdLogo: INCBIN "gfx/splash/logo_new.2bpp.lz"

RdLogoPals:
	RGB 00, 00, 00
	RGB 22, 22, 22
	RGB 23, 23, 23
	RGB 30, 30, 30

	RGB 00, 00, 00
	RGB 25, 25, 25
	RGB 26, 26, 26
	RGB 28, 28, 28

	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 00, 00
	RGB 31, 12, 00

	RGB 00, 00, 00
	RGB 30, 30, 30
	RGB 31, 12, 00
	RGB 31, 28, 00

	RGB 00, 00, 00
	RGB 04, 31, 00
	RGB 00, 31, 30
	RGB 00, 01, 31

	RGB 00, 00, 00
	RGB 00, 01, 31
	RGB 30, 00, 31
	RGB 31, 31, 31

IntroLogoGFX: INCBIN "gfx/intro/logo.2bpp.lz"
