Credits::
	ld a, b
	and $40
	ld [wJumptableIndex], a

	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)

	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites

	ld hl, wCreditsFaux2bpp
	ld c, $80

.load_loop
	xor a
	ld [hli], a
	dec a
	ld [hli], a
	dec c
	jr nz, .load_loop

	ld de, CreditsBorderGFX
	ld hl, vBGTiles tile $20
	lb bc, BANK(CreditsBorderGFX), $09
	call Request2bpp

	ld de, TheEndGFX
	ld hl, vBGTiles tile $40
	lb bc, BANK(TheEndGFX), $10
	call Request2bpp

	xor a
	ld [wCreditsBorderMon], a
	dec a
	ld [wCreditsBorderFrame], a

	call Credits_LoadBorderGFX
	ld e, l
	ld d, h
	ld hl, vBGTiles
	lb bc, BANK(CreditsMonsGFX), 16
	call Request2bpp

	call ConstructCreditsTilemap
	xor a
	ld [wCreditsLYOverride], a

	ld hl, wLYOverrides
	ld bc, $100
	xor a
	call ByteFill

	ld a, LOW(rSCX)
	ld [wLCDCPointer], a
	ld hl, rIE
	set LCD_STAT, [hl]
	call GetCreditsPalette
	call SetPalettes
	ldh a, [hVBlank]
	push af
	ld a, 5
	ldh [hVBlank], a
	xor a
	ldh [hBGMapMode], a
	ld [wCreditsPos], a
	ld [wCreditsPos + 1], a
	ld [wCreditsTimer], a
	inc a
	ldh [hInMenu], a
	jr .handle_execution_loop

.execution_loop
	call Credits_Jumptable
	call DelayFrame
.handle_execution_loop
	call Credits_HandleBButton
	call Credits_HandleAButton
	jr z, .execution_loop

	call ClearBGPalettes
	xor a
	ld [wLCDCPointer], a
	ldh [hBGMapAddress], a
	ld hl, rIE
	res LCD_STAT, [hl]
	pop af
	ldh [hVBlank], a
	pop af
	ldh [rSVBK], a
	ret

Credits_HandleAButton:
	ldh a, [hJoypadDown]
	and A_BUTTON
	ret z
	ld a, [wJumptableIndex]
	bit 7, a
	ret

Credits_HandleBButton:
	ldh a, [hJoypadDown]
	and B_BUTTON
	ret z
	ld a, [wJumptableIndex]
	bit 6, a
	ret z
	ld hl, wCreditsPos
	ld a, [hli]
	cp 13
	jr nc, .okay
	ld a, [hli]
	and a
	ret z
.okay
	ld hl, wCreditsTimer
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

Credits_Jumptable:
	ld a, [wJumptableIndex]
	and $f
	jumptable

	dw ParseCredits
	dw Credits_Next
	dw Credits_Next
	dw Credits_PrepBGMapUpdate
	dw Credits_UpdateGFXRequestPath
	dw Credits_RequestGFX
	dw Credits_LYOverride
	dw Credits_Next
	dw Credits_Next
	dw Credits_Next
	dw Credits_UpdateGFXRequestPath
	dw Credits_RequestGFX
	dw Credits_LoopBack

Credits_Next:
	ld hl, wJumptableIndex
	inc [hl]
	ret

Credits_LoopBack:
	ld hl, wJumptableIndex
	ld a, [hl]
	and $f0
	ld [hl], a
	ret

Credits_PrepBGMapUpdate:
	xor a
	ldh [hBGMapMode], a
	jp Credits_Next

Credits_UpdateGFXRequestPath:
	call Credits_LoadBorderGFX
	ld a, l
	ldh [hRequestedVTileSource], a
	ld a, h
	ldh [hRequestedVTileSource + 1], a
	ld a, LOW(vBGTiles)
	ldh [hRequestedVTileDest], a
	ld a, HIGH(vBGTiles)
	ldh [hRequestedVTileDest + 1], a
	; fallthrough

Credits_RequestGFX:
	xor a
	ldh [hBGMapMode], a
	ld a, 8
	ldh [hRequested2bpp], a
	jr Credits_Next

Credits_LYOverride:
	ldh a, [rLY]
	cp $30
	jr c, Credits_LYOverride
	ld a, [wCreditsLYOverride]
	sub 2
	ld [wCreditsLYOverride], a
	ld hl, wLYOverrides + $1f
	call .Fill
	ld hl, wLYOverrides + $87
	call .Fill
	jr Credits_Next

.Fill
	ld c, 8
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

ParseCredits:
	ld hl, wJumptableIndex
	bit 7, [hl]
	jr nz, Credits_Next

; Wait until the timer has run out to parse the next command.
	ld hl, wCreditsTimer
	ld a, [hl]
	and a
	jr z, .parse

; One tick has passed.
	dec [hl]
	jr Credits_Next

.parse
; First, let's clear the current text display,
; starting from line 5.
	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 5
	ld bc, 20 * 12
	ld a, " "
	call ByteFill

; Then read the script.

.loop
	call .get

; Commands:
	cp CREDITS_END
	jr z, .end
	cp CREDITS_WAIT
	jr z, .wait
	cp CREDITS_SCENE
	jr z, .scene
	cp CREDITS_CLEAR
	jr z, .clear
	cp CREDITS_MUSIC
	jr z, .music
	cp CREDITS_WAIT2
	jr z, .wait2
	cp CREDITS_THEEND
	jr z, .theend

; If it's not a command, it's a string identifier.

	push af
	ld e, a
	ld d, 0
	ld hl, CreditsStrings
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop af
	hlcoord 1, 6
; Print strings spaced every two lines.
	call .get
	ld bc, 20 * 2
	rst AddNTimes
	call PlaceText
	jr .loop

.theend
; Display "The End" graphic.
	call Credits_TheEnd
	jr .loop

.scene
; Update the scene number and corresponding palette.
	call .get
	ld [wCreditsBorderMon], a ; scene
	xor a
	ld [wCreditsBorderFrame], a ; frame
	call GetCreditsPalette
	call SetPalettes ; update hw pal registers
	jr .loop

.clear
; Clear the banner.
	ld a, $ff
	ld [wCreditsBorderFrame], a ; frame
	jr .loop

.music
; Play the credits music.
	ld de, MUSIC_CREDITS
	push de
IF MUSIC_CREDITS > $ff
	ld de, MUSIC_NONE
ELSE
	ld e, d
ENDC
	call PlayMusic
	call DelayFrame
	pop de
	call PlayMusic
	jr .loop

.wait2
; Wait for some amount of ticks.
	call .get
	ld [wCreditsTimer], a
	jr .done

.wait
; Wait for some amount of ticks, and do something else.
	call .get
	ld [wCreditsTimer], a

	xor a
	ldh [hBGMapHalf], a
	inc a
	ldh [hBGMapMode], a

.done
	jp Credits_Next

.end
; Stop execution.
	ld hl, wJumptableIndex
	set 7, [hl]
	ld a, 32
	ld [wMusicFade], a
	ld a, LOW(MUSIC_POST_CREDITS)
	ld [wMusicFadeID], a
	ld a, HIGH(MUSIC_POST_CREDITS)
	ld [wMusicFadeIDHi], a
	ret

.get
; Get byte wCreditsPos from CreditsScript
	push hl
	push de
	ld hl, wCreditsPos
	push hl
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, CreditsScript
	add hl, de

	ld a, [hl]
	pop hl
	inc [hl]
	jr nz, .no_carry_on_increment
	inc hl
	inc [hl]
.no_carry_on_increment
	pop de
	pop hl
	ret

ConstructCreditsTilemap:
	xor a
	ldh [hBGMapMode], a
	ld a, 12
	ldh [hBGMapAddress], a

	ld a, $28
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill

	ld a, $7f
	hlcoord 0, 4
	ld bc, (SCREEN_HEIGHT - 4) * SCREEN_WIDTH
	call ByteFill

	hlcoord 0, 4
	ld a, $24
	call DrawCreditsBorder

	hlcoord 0, 17
	ld a, $20
	call DrawCreditsBorder

	hlcoord 0, 0, wAttrMap
	ld bc, 4 * SCREEN_WIDTH
	xor a
	call ByteFill

	hlcoord 0, 4, wAttrMap
	ld bc, SCREEN_WIDTH
	ld a, 1
	call ByteFill

	hlcoord 0, 5, wAttrMap
	ld bc, 12 * SCREEN_WIDTH
	ld a, 2
	call ByteFill

	hlcoord 0, 17, wAttrMap
	ld bc, SCREEN_WIDTH
	ld a, 1
	call ByteFill

	call ApplyAttrAndTilemapInVBlank
	xor a
	ldh [hBGMapMode], a
	ldh [hBGMapAddress], a
	hlcoord 0, 0

	ld b, 5
.outer_loop
	push hl
	ld de, SCREEN_WIDTH - 3
	ld c, 4
	xor a
.inner_loop
rept 3
	ld [hli], a
	inc a
endr
	ld [hl], a
	inc a
	add hl, de
	dec c
	jr nz, .inner_loop
	pop hl
rept 4
	inc hl
endr
	dec b
	jr nz, .outer_loop
	jp ApplyAttrAndTilemapInVBlank

DrawCreditsBorder:
	ld c, SCREEN_WIDTH / 4
.loop
	push af
rept 3
	ld [hli], a
	inc a
endr
	ld [hli], a
	pop af
	dec c
	jr nz, .loop
	ret

GetCreditsPalette:
; Each set of palette data is 24 bytes long.
	ld a, [wCreditsBorderMon] ; scene
	and 3
	add a, a
	add a, a
	add a, a ; * 8
	ld e, a
	ld d, 0
	ld hl, CreditsPalettes
	add hl, de
	add hl, de
	add hl, de ; * 3

	push hl

; Update the first three colors in both palette buffers.
	push hl
	ld de, wOriginalBGPals
	ld bc, 24
	push bc
	rst CopyBytes

	pop bc
	pop hl
	ld de, wBGPals
	rst CopyBytes
	pop hl
	ret

CreditsPalettes:
; Pichu
	RGB 31, 00, 31
	RGB 31, 25, 00
	RGB 11, 14, 31
	RGB 07, 07, 07

	RGB 31, 05, 05
	RGB 11, 14, 31
	RGB 11, 14, 31
	RGB 31, 31, 31

	RGB 31, 05, 05
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31

; Smoochum
	RGB 31, 31, 31
	RGB 31, 27, 00
	RGB 26, 06, 31
	RGB 07, 07, 07

	RGB 03, 13, 31
	RGB 20, 00, 24
	RGB 26, 06, 31
	RGB 31, 31, 31

	RGB 03, 13, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31

; Ditto
	RGB 31, 31, 31
	RGB 23, 12, 28
	RGB 31, 22, 00
	RGB 07, 07, 07

	RGB 03, 20, 00
	RGB 31, 22, 00
	RGB 31, 22, 00
	RGB 31, 31, 31

	RGB 03, 20, 00
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31

; Igglybuff
	RGB 31, 31, 31
	RGB 31, 10, 31
	RGB 31, 00, 09
	RGB 07, 07, 07

	RGB 31, 14, 00
	RGB 31, 00, 09
	RGB 31, 00, 09
	RGB 31, 31, 31

	RGB 31, 14, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31

Credits_LoadBorderGFX:
	ld hl, wCreditsBorderFrame
	ld a, [hl]
	cp $ff
	jr z, .init

	and 3
	ld e, a
	inc a
	and 3
	ld [hl], a
	ld a, [wCreditsBorderMon]
	and 3
	add a
	add a
	add e
	add a
	ld e, a
	ld d, 0
	ld hl, .Frames
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

.init
	ld hl, wCreditsFaux2bpp
	ret

.Frames
	dw CreditsPichuGFX
	dw CreditsPichuGFX     + 16 tiles
	dw CreditsPichuGFX     + 32 tiles
	dw CreditsPichuGFX     + 48 tiles
	dw CreditsSmoochumGFX
	dw CreditsSmoochumGFX  + 16 tiles
	dw CreditsSmoochumGFX  + 32 tiles
	dw CreditsSmoochumGFX  + 48 tiles
	dw CreditsDittoGFX
	dw CreditsDittoGFX     + 16 tiles
	dw CreditsDittoGFX     + 32 tiles
	dw CreditsDittoGFX     + 48 tiles
	dw CreditsIgglybuffGFX
	dw CreditsIgglybuffGFX + 16 tiles
	dw CreditsIgglybuffGFX + 32 tiles
	dw CreditsIgglybuffGFX + 48 tiles

Credits_TheEnd:
	ld a, $40
	hlcoord 6, 9
	call .Load
	hlcoord 6, 10
.Load
	ld c, 8
.loop
	ld [hli], a
	inc a
	dec c
	jr nz, .loop
	ret

CreditsBorderGFX:    INCBIN "gfx/credits/border.2bpp"

CreditsMonsGFX:
CreditsPichuGFX:     INCBIN "gfx/credits/pichu.2bpp"
CreditsSmoochumGFX:  INCBIN "gfx/credits/smoochum.2bpp"
CreditsDittoGFX:     INCBIN "gfx/credits/ditto.2bpp"
CreditsIgglybuffGFX: INCBIN "gfx/credits/igglybuff.2bpp"


CreditsScript:

; Clear the banner.
	db CREDITS_CLEAR

; Pokemon Crystal Version Staff
	db CREDITS_STAFF, 1

	db CREDITS_WAIT, 8

; Play the credits music.
	db CREDITS_MUSIC

	db CREDITS_WAIT2, 10

	db CREDITS_WAIT, 1

; Update the banner.
	db CREDITS_SCENE, 0 ;Pichu
	db CREDITS_INITIAL_1, 1
	db CREDITS_WAIT, 40

	db CREDITS_SCENE, 1 ;Smoochum
	db CREDITS_INITIAL_2, 1
	db CREDITS_WAIT, 40

	db CREDITS_SCENE, 2 ;Ditto
	db CREDITS_KBM_1, 1
	db CREDITS_WAIT, 25

	db CREDITS_KBM_2, 1
	db CREDITS_WAIT, 35

	db CREDITS_SCENE, 3 ;Igglybuff
	db CREDITS_ORIGINAL_DEVS_1, 1
	db CREDITS_WAIT, 25

	db CREDITS_ORIGINAL_DEVS_2, 1
	db CREDITS_WAIT, 35

	db CREDITS_SCENE, 0 ;Pichu
	db CREDITS_LEAKERS_1, 1
	db CREDITS_WAIT, 25

	db CREDITS_LEAKERS_2, 1
	db CREDITS_WAIT, 35

	db CREDITS_SCENE, 1 ;Smoochum
	db CREDITS_GAME_FREAK_1, 1
	db CREDITS_WAIT, 25

	db CREDITS_GAME_FREAK_2, 1
	db CREDITS_WAIT, 25

	db CREDITS_GAME_FREAK_3, 1
	db CREDITS_WAIT, 35

	db CREDITS_SCENE, 2 ;Ditto
	db CREDITS_YOU, 1
	db CREDITS_WAIT, 40

	db CREDITS_SCENE, 3 ;Igglybuff
	db CREDITS_CLOSING, 1
	db CREDITS_WAIT, 70

; Display "The End" graphic.
	db CREDITS_SCENE, 0 ;Pichu
	db CREDITS_THEEND

	db CREDITS_WAIT, 30

	db CREDITS_END

CreditsStrings:
	dw .Staff
	dw .initial_1
	dw .initial_2
	dw .kbm_1
	dw .kbm_2
	dw .original_devs_1
	dw .original_devs_2
	dw .leakers_1
	dw .leakers_2
	dw .game_freak_1
	dw .game_freak_2
	dw .game_freak_3
	dw .you
	dw .closing

.Staff
	ctxt "      #mon"
	next "       Prism"
	next "      Credits"
	done

.initial_1
	ctxt "Lots of people"
	next "did a lot of work."
	next "Mostly anonymous."
	done

.initial_2
	ctxt "But we'd rather use"
	next "these credits to"
	next "thank some people."
	done

.kbm_1
	ctxt "Thanks to"
	next "Koolboyman, for"
	next "having made the"
	done

.kbm_2
	ctxt "original version"
	next "of this game, wor-"
	next "king for 8 years."
	done

.original_devs_1
	ctxt "Thanks to the"
	next "original dev team,"
	next "who made this game"
	done

.original_devs_2
	ctxt "possible, and"
	next "almost finished"
	next "it."
	done

.leakers_1
	ctxt "To the leakers,"
	next "thanks to whom"
	next "everyone can still"
	done

.leakers_2
	ctxt "play the game, and"
	next "thanks to whom we"
	next "can develop on it."
	done

.game_freak_1
	ctxt "And thanks to Game"
	next "Freak and their"
	next "associates, for"
	done

.game_freak_2
	ctxt "creating this"
	next "amazing franchise"
	next "that started it"
	done

.game_freak_3
	ctxt "all."
	next "Please buy their"
	next "great games."
	done

.you
	ctxt "Finally, thank you"
	next "for playing this"
	next "game!"
	done

.closing
	ctxt "Congratulations on"
	next "your victory!"
	next "-RainbowDevs, 2017"
	done
