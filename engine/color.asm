PALPACKET_LENGTH EQU $10

SHINY_ATK_BIT EQU 5
SHINY_DEF_VAL EQU 10
SHINY_SPD_VAL EQU 10
SHINY_SPC_VAL EQU 10

CheckShininess::
; Check if a mon is shiny by DVs at bc.
; Return carry if shiny.

	ld l, c
	ld h, b
CheckShininessHL::
; Attack and Defense
	ld a, [hli]
	and 1 << SHINY_ATK_BIT | $f
	jr z, .NotShiny
	cp 1 << SHINY_ATK_BIT | SHINY_DEF_VAL
	jr nz, .NotShiny

; Speed and Special
	ld a, [hl]
	cp SHINY_SPD_VAL << 4 | SHINY_SPC_VAL
	jr nz, .NotShiny

.Shiny
	scf
	ret

.NotShiny
	and a
	ret

InitPartyMenuPalettes:
	ld hl, PalPacket_9c56 + 1
	call CopyFourPalettes
	call InitPartyMenuOBPals
	jp WipeAttrMap

ApplyMonOrTrainerPals:
	call LoadMonOrTrainerPals
	call WipeAttrMap
ApplyAttrMapAndPals:
	call ApplyAttrMap
ApplyPals:
	ld hl, wOriginalBGPals
	ld de, wBGPals
	ld bc, 16 palettes
	ld a, BANK(wBGPals)
	jp FarCopyWRAM

ApplyAttrMap:
	ldh a, [rLCDC]
	bit 7, a
	jr z, .UpdateVBank1
	ldh a, [hVBlank]
	cp 2
	ret z
	ldh a, [hBGMapMode]
	push af
	ld a, 2
	ldh [hBGMapMode], a
	call Delay2
	pop af
	ldh [hBGMapMode], a
	ret

.UpdateVBank1
	hlcoord 0, 0, wAttrMap
	debgcoord 0, 0
	ld b, SCREEN_HEIGHT
	vbk BANK(vBGAttrs)
.row
	ld c, SCREEN_WIDTH
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .col
	ld a, BG_MAP_WIDTH - SCREEN_WIDTH
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	dec b
	jr nz, .row
	vbk BANK(vBGMap)
	ret

LoadMonOrTrainerPals:
	ld a, e
	and a
	jr z, .get_trainer
	ld a, [wCurPartySpecies]
	call GetMonPalettePointer
	jr .load_palettes

.get_trainer
	ld a, [wTrainerClass]
	call GetTrainerPalettePointer
.load_palettes
	ld de, wOriginalBGPals
	jp LoadPalette_White_Col1_Col2_Black

ApplyHPBarPals:
	ld a, [wWhichHPBar]
	cp 3
	ret nc
	jumptable
	dw .Enemy
	dw .Player
	dw .PartyMenu

.Enemy
	ld de, wBGPals + 2 palettes + 2
	jr .continue_battle

.Player
	ld de, wBGPals + 3 palettes + 2
.continue_battle
	ld l, c
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	ld bc, 4
	ld a, 5
	call FarCopyWRAM
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

.PartyMenu
	ld e, c
	inc e
	hlcoord 11, 1, wAttrMap
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	lb bc, 2, 8
	ld a, e
	jp FillBoxWithByte

LoadStatsScreenPals:
	ld hl, StatsScreenPals
	ld b, 0
	dec c
	add hl, bc
	add hl, bc
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	ld a, [hli]
	ld [wOriginalBGPals], a
	ld [wOriginalBGPals + 8 * 2], a
	ld [wOriginalBGPals + 8 * 7 + 2], a
	ld a, [hl]
	ld [wOriginalBGPals + 1], a
	ld [wOriginalBGPals + 8 * 2 + 1], a
	ld [wOriginalBGPals + 8 * 7 + 3], a
	pop af
	ldh [rSVBK], a
	call ApplyAttrMapAndPals
	ld a, 1
	ret

INCLUDE "engine/cgb.asm"

CopyFourPalettes:
	ld de, wOriginalBGPals
	ld c, 4
CopyPalettes:
	push bc
	ld a, [hli]
	push hl
	call GetPredefPal
	call LoadHLPaletteIntoDE
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, CopyPalettes
	ret

GetPredefPal:
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, Palettes_9df6
	add hl, bc
	ret

LoadHLPaletteIntoDE:
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	ld c, 8
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

LoadPalette_White_Col1_Col2_Black:
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)

	ld a, LOW($7fff)
	ld [de], a
	inc de
	ld a, HIGH($7fff)
	ld [de], a
	inc de

	ld c, 2 * 2
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop

	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de

	pop af
	ldh [rSVBK], a
	ret

ResetPals:
	push hl
	push de
	push bc
	push af
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	ld hl, wOriginalBGPals
	ld c, 8
.loop
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	jp PopOffRegsAndReturn

WipeAttrMap:
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	jp ByteFill

CGB_ApplyPartyMenuHPPals: ;CGB layout $fc
	ld hl, wHPPals
	ld a, [wSGBPals]
	ld e, a
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	inc a
	ld e, a
	hlcoord 10, 2, wAttrMap
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wSGBPals]
	rst AddNTimes
	lb bc, 2, 9
	ld a, e
	jp FillBoxWithByte

InitPartyMenuOBPals:
	ld hl, Palettes_Pokemon_Menu
	ld de, wOriginalOBJPals
	ld bc, 8 palettes
	ld a, 5
	jp FarCopyWRAM

GetBattlemonBackpicPalettePointer:
	push de
	callba GetPartyMonDVs
	ld c, l
	ld b, h
	ld a, [wTempBattleMonSpecies]
	call GetPlayerOrMonPalettePointer
	pop de
	ret

GetEnemyFrontpicPalettePointer:
	push de
	callba GetEnemyMonDVs
	ld c, l
	ld b, h
	ld a, [wTempEnemyMonSpecies]
	call GetFrontpicPalettePointer
	pop de
	ret

GetPlayerOrMonPalettePointer:
	and a
	jp nz, GetMonNormalOrShinyPalettePointer
GetPlayerPalettePointer:
	ld a, [wPlayerSpriteSetupFlags]
	bit 2, a
	ld hl, CharPalette
	ret nz
	push de
	CheckEngine ENGINE_POKEMON_MODE
	ld a, [wPlayerCharacteristics]
	jr z, .okay
	ld a, [wTempPlayerCustSelection]
.okay
	swap a
	and 7
	ld l, a
	ld h, 0
	add hl, hl
	ld de, RacePalettes
	add hl, de
	ld de, wBattlePlayerSkinTone
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld hl, wPlayerClothesPalette
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .okay2
	ld hl, wTempPlayerClothesPalette
.okay2
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop de
	ld hl, wBattlePlayerSkinTone
	ret

GetFrontpicPalettePointer:
	and a
	jp nz, GetMonNormalOrShinyPalettePointer
	ld a, [wTrainerClass]
	and a
	jr z, GetPlayerPalettePointer
GetTrainerPalettePointer:
	cp PATROLLER
	jr z, GetPalletPatrollerPointer
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, TrainerPalettes
	add hl, bc
	ret

GetPalletPatrollerPointer:
	ld a, [wOtherTrainerID]
	dec a
	ld e, a
	ld d, 0
	ld hl, .WhichPatroller
	add hl, de
	ld a, [hl]
	add a
	add a
	ld e, a ; d is still 0
	ld hl, .WhichPalette
	add hl, de
	ret
.WhichPatroller
	db 0, 0 ; Black
	db 1, 1, 1 ; Yellow
	db 2, 2, 2 ; Pink
	db 3, 3, 3 ; Blue
	db 4, 4, 4 ; Green
	db 5, 5 ; Red
	db 1 ; Yellow
	db 4 ; Green
	db 3 ; Blue
	db 2 ; Pink

.WhichPalette: INCLUDE "gfx/trainers/palettepatrollers.pal"

Palettes_979c:
	RGB 31, 31, 31
	RGB 25, 25, 25
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 08, 12, 31
	RGB 01, 04, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 18, 07
	RGB 20, 15, 03
	RGB 00, 00, 00

GetMonPalettePointer:
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, PokemonPalettes
	add hl, bc
	ret

GetMonNormalOrShinyPalettePointer:
	push bc
	call GetMonPalettePointer
	pop bc
	push hl
	call CheckShininess
	pop hl
	ret nc
	inc hl
	inc hl
	inc hl
	inc hl
	ret

ClearBytes:
; clear bc bytes of data starting from de
	push hl
	ld h, d
	ld l, e
	xor a
	call ByteFill
	ld d, h
	ld e, l
	pop hl
	ret

DrawDefaultTiles:
; Draw 240 tiles (2/3 of the screen) from tiles in VRAM
	hlbgcoord 0, 0 ; BG Map 0
	ld de, BG_MAP_WIDTH - SCREEN_WIDTH
	ld a, $80 ; starting tile
	ld c, 12 + 1
.line
	ld b, 20
.tile
	ld [hli], a
	inc a
	dec b
	jr nz, .tile
; next line
	add hl, de
	dec c
	jr nz, .line
	ret

PalPacket_9ba6:	db $2b, $00, $24, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9bc6:	db $4c, $00, $4c, $00, $4c, $00, $4c, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c36:	db $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c46:	db $39, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c56:	db $2e, $00, $2f, $00, $30, $00, $31, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c66:	db $1a, $00, $1a, $00, $1a, $00, $1a, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9ca6:	db $33, $00, $34, $00, $1b, $00, $1f, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9cb6:	db $1b, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9cc6:	db $1c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Palettes_9df6:
	RGB 31, 31, 31
	RGB 22, 25, 19
	RGB 16, 21, 30
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 27, 28, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 28, 19
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 24, 24
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 23, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 21, 27
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 24, 16
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 25, 30, 26
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 25, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 19
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 26, 19
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 27, 28, 27
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 30, 23
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 29, 24, 29
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 23, 29
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 25, 23, 20
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 29, 26, 18
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 21, 18
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 25, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 22, 21, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 22, 25, 21
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 22
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 20
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 26, 26
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 14, 09
	RGB 15, 20, 20
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 28, 22
	RGB 15, 20, 20
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 07, 07
	RGB 02, 03, 03
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 17
	RGB 16, 14, 19
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 18, 20, 27
	RGB 11, 15, 23
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 10
	RGB 26, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 25, 29
	RGB 14, 19, 25
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 27, 22, 24
	RGB 21, 15, 23
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 28, 20, 15
	RGB 21, 14, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 20, 26, 16
	RGB 09, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 24
	RGB 28, 15, 21
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 28, 14
	RGB 26, 20, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 21, 22
	RGB 15, 15, 18
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 19, 13
	RGB 14, 12, 17
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 18, 21
	RGB 10, 12, 18
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 22, 15, 16
	RGB 17, 02, 05
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 20, 20
	RGB 05, 16, 16
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 15, 19
	RGB 14, 04, 12
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 20, 17, 18
	RGB 18, 13, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 21, 16
	RGB 12, 12, 10
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 25, 29
	RGB 30, 22, 24
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 23, 16
	RGB 29, 14, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 18, 18, 18
	RGB 10, 10, 10
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 15
	RGB 00, 23, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 15
	RGB 31, 23, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 15
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 29, 26, 19
	RGB 27, 20, 14
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 20, 10
	RGB 21, 00, 04
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 10
	RGB 21, 00, 04
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 16
	RGB 16, 12, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 28, 26
	RGB 12, 22, 26
	RGB 03, 16, 14

	RGB 31, 31, 31
	RGB 15, 28, 26
	RGB 23, 24, 24
	RGB 00, 00, 00

	RGB 31, 31, 24
	RGB 07, 27, 19
	RGB 26, 20, 10
	RGB 19, 12, 08

	RGB 31, 31, 31
	RGB 31, 28, 14
	RGB 31, 13, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 18, 21
	RGB 10, 12, 18
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 21, 16
	RGB 12, 12, 10
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 00
	RGB 07, 11, 15
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 21, 22
	RGB 26, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 27, 04
	RGB 24, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 13, 25
	RGB 24, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 19, 29
	RGB 24, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 24
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 21, 25, 29
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 20, 26, 16
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 31, 28, 14
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 18, 18, 18
	RGB 26, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 24
	RGB 28, 15, 21
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 20, 00
	RGB 16, 19, 29
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 02, 30
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 13, 04
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 28, 04, 02
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 18, 23, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 20, 11
	RGB 18, 13, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 25, 30, 00
	RGB 25, 30, 00

	RGB 00, 00, 00
	RGB 08, 11, 11
	RGB 21, 21, 21
	RGB 31, 31, 31

Palettes_a8be:
; HP Pals
	RGB 30, 26, 15
	RGB 00, 23, 00

	RGB 30, 26, 15
	RGB 31, 21, 00

	RGB 30, 26, 15
	RGB 31, 00, 00

Palettes_a8ca:
	RGB 30, 26, 15
	RGB 04, 17, 31

INCLUDE "gfx/pics/palette_pointers.asm"

INCLUDE "gfx/trainers/palette_pointers.asm"

SetPlayerRace:
	ld a, [wPlayerCharacteristics]
	swap a
	and 7
	ld hl, RacePalettes
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld d, h
	ld e, l

	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	ld de, wOriginalOBJPals + 2
	jr SetPlayerColorTOD

SetPlayerColor:
	ld hl, wPlayerClothesPalette
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wOriginalOBJPals + 4
SetPlayerColorTOD:
	push de
	;Change colors based on lightning
	ld a, [wTimeOfDayPal]
	and 3
	cp NITE
	jr c, .setColors
	call nz, ColorNight
	call ColorNight
.setColors
	pop de
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalOBJPals)
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a

	pop af
	ldh [rSVBK], a
	ret

IncreaseColor:
	cp 31
	ret nc
	cp 4
	ret c
	cp 8
	jr c, .increaseOne
	cp 16
	jr c, .increaseTwo
	inc a
.increaseTwo
	inc a
.increaseOne
	inc a
	ret

ColorNight:
	call GetRed
	call IncreaseColor
	srl a
	ld e, a

	call GetGreen
	call IncreaseColor

	add 3
	srl a
	ld b, a
	and 7
	add a
	swap a
	add e
	ld e, a

	ld a, b
	rrca
	rrca
	rrca
	and %00011111
	ld d, a

	call GetBlue
	cp 2
	jr c, .skipBlue
	sub 2
	add a
	add a
	add d
	ld d, a

.skipBlue
	ld h, d
	ld l, e
	ret
;hl: Color
;a: Result
GetRed:
	ld a, l
	and $1f
	ret

GetGreen:
	ld a, l
	swap a
	srl a
	and 7
	ld b, a

	ld a, h
	and 3
	add a
	add a
	add a
	add b
	ret

GetBlue:
	ld a, h
	srl a
	srl a
	ret

RacePalettes:
	RGB 31, 21, 09
	RGB 31, 27, 17
	RGB 30, 24, 15
	RGB 28, 21, 13
	RGB 24, 16, 08
	RGB 17, 10, 04
	RGB 10, 06, 03

LoadSpecialMapPalette:
	ld a, [wTileset]
	cp TILESET_TRAINER_HOUSE ;load darker colors for the Trainer House, Battle Arcade or Battle Tower
	ld hl, .battle_room_palette
	jr z, .load_eight_palettes
	cp TILESET_TUNOD
	ld hl, .tunod_palette
	jr z, .load_time_of_day_palettes
	cp TILESET_ESPO_FOREST
	ld hl, .espo_forest_palette
	jr z, .load_time_of_day_palettes
	cp TILESET_OLCAN_ISLE
	jr z, .olcan_isle
	and a
	ret

.olcan_isle
	ld hl, .tunod_palette
	ld a, [wMapGroup]
	cp GROUP_OLCAN_ISLE
	jr nz, .load_time_of_day_palettes
	ld a, [wMapNumber]
	cp MAP_OLCAN_ISLE
	jr nz, .load_time_of_day_palettes
	ld hl, .olcan_isle_palette
.load_time_of_day_palettes
	ld a, [wTimeOfDayPal]
	and 3
	ld bc, 8 palettes
	rst AddNTimes
.load_eight_palettes
	ld a, BANK(wOriginalBGPals)
	ld de, wOriginalBGPals
	ld bc, 8 palettes
	call FarCopyWRAM
	scf
	ret

.battle_room_palette: INCLUDE "tilesets/battle_tower.pal"
.tunod_palette:       INCLUDE "tilesets/tunod.pal"
.espo_forest_palette: INCLUDE "tilesets/espo_forest.pal"
.olcan_isle_palette:  INCLUDE "tilesets/olcan_isle.pal"

LoadMapPals:
	call LoadSpecialMapPalette
	jr c, .got_pals

	ld a, [wPermission]
	and 7
	ld e, a
	ld d, 0
	ld hl, .TilesetColorsPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTimeOfDayPal]
	and 3
	add a
	add a
	add a
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld e, l
	ld d, h
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	ld hl, wOriginalBGPals
	ld b, 8
.outer_loop
	ld a, [de] ; lookup index for TilesetBGPalette
	push de
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, TilesetBGPalette
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld c, 1 palettes
.inner_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .inner_loop
	pop de
	inc de
	dec b
	jr nz, .outer_loop
	pop af
	ldh [rSVBK], a

.got_pals
	ld a, [wTimeOfDayPal]
	and 3
	ld bc, 8 palettes
	ld hl, MapObjectPals
	rst AddNTimes
	push hl
	ld de, wOriginalOBJPals
	ld bc, 8 palettes
	ld a, BANK(wOriginalOBJPals)
	call FarCopyWRAM
	pop hl
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .setMonColour
	call SetPlayerColor
	call SetPlayerRace
	jr .continue
.setMonColour
	ld a, [wPokeonlyMonPalette]
	ld bc, 1 palettes
	rst AddNTimes
	inc hl
	inc hl
	ld de, wOriginalOBJPals + 2
	ld bc, 4
	ld a, BANK(wOriginalOBJPals)
	call FarCopyWRAM
.continue
	ld a, [wTileset]
	cp TILESET_ESPO_FOREST
	jr z, .espo_forest ; skip loading a roof pal
	cp TILESET_OLCAN_ISLE
	jr z, .olcan_isle ; skip loading a roof pal
	cp TILESET_TUNOD
	call z, .tunod
	ld a, [wMapGroup]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, RoofPals
	add hl, de
	ld a, [wTimeOfDayPal]
	and 3
	cp DARKNESS
	ret z
	cp NITE
	jr c, .morn_day
	inc hl
	inc hl
	inc hl
	inc hl
.morn_day
	ld a, BANK(wOriginalBGPals)
	ld de, wOriginalBGPals + 6 palettes + 2
	ld bc, 4
	jp FarCopyWRAM

.tunod
.olcan_isle
	ld hl, wOriginalBGPals + 2 palettes
	ld de, wOriginalOBJPals + 2 palettes
	ld a, BANK(wOriginalBGPals)
	ld bc, 1 palettes
	jp FarCopyWRAM

.espo_forest
	ld hl, wOriginalBGPals + 3 palettes
	ld de, wOriginalOBJPals + 2 palettes
	ld a, BANK(wOriginalBGPals)
	ld bc, 1 palettes
	jp FarCopyWRAM

.TilesetColorsPointers
	dw .OutdoorColors ; unused
	dw .OutdoorColors ; TOWN
	dw .OutdoorColors ; ROUTE
	dw .IndoorColors ; INDOOR
	dw .DungeonColors ; CAVE
	dw .Perm5Colors ; PERM_5
	dw .IndoorColors ; GATE
	dw .DungeonColors ; DUNGEON

; Valid indices: $00 - $29
.OutdoorColors
	db $00, $01, $02, $28, $04, $05, $06, $07 ; morn
	db $08, $09, $0a, $28, $0c, $0d, $0e, $0f ; day
	db $10, $11, $12, $29, $14, $15, $16, $17 ; nite
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f ; dark

.IndoorColors
	db $20, $21, $22, $23, $24, $25, $26, $07 ; morn
	db $20, $21, $22, $23, $24, $25, $26, $07 ; day
	db $10, $11, $12, $13, $14, $15, $16, $07 ; nite
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $07 ; dark

.DungeonColors
	db $00, $01, $02, $03, $04, $05, $06, $07 ; morn
	db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; day
	db $10, $11, $12, $13, $14, $15, $16, $17 ; nite
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f ; dark

.Perm5Colors
	db $00, $01, $02, $03, $04, $05, $06, $07 ; morn
	db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; day
	db $10, $11, $12, $13, $14, $15, $16, $17 ; nite
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f ; dark

TunodGrassGreenOBPals:
	RGB 16,25,16, 16,25,16, 13,17,05, 06,06,06 ; morn
	RGB 20,24,07, 20,24,07, 13,17,05, 06,06,06 ; day
	RGB 10,12,05, 10,12,05, 07,09,04, 00,00,00 ; green

Palette_b311: ; not mobile
	RGB 31, 31, 31
	RGB 17, 19, 31
	RGB 14, 16, 31
	RGB 00, 00, 00

TilesetBGPalette: INCLUDE "tilesets/bg.pal"

MapObjectPals:: INCLUDE "tilesets/ob.pal"

RoofPals: INCLUDE "tilesets/roof.pal"

Palettes_b641:
	RGB 27, 31, 27
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 07, 06
	RGB 20, 02, 03
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 10, 31, 09
	RGB 04, 14, 01
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 08, 12, 31
	RGB 01, 04, 31
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 22, 16, 08
	RGB 13, 07, 01
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 15, 31, 31
	RGB 05, 17, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 11, 11, 19
	RGB 07, 07, 12
	RGB 00, 00, 00

Palettes_Pokemon_Menu:
;Orange
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 30, 15, 00
	RGB 00, 00, 00

;Blue
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 09, 04, 31
	RGB 00, 00, 00

;Green
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 07, 23, 03
	RGB 00, 00, 00

;Brown
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 15, 10, 03
	RGB 00, 00, 00

;Red
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 31, 07, 00
	RGB 00, 00, 00

;Gray
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 14, 14, 10
	RGB 00, 00, 00

;Yellow
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 31, 28, 00
	RGB 00, 00, 00

;Purple
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 26, 00, 26
	RGB 00, 00, 00

Palettes_b681:
	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 10, 14, 20
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 08, 12, 31
	RGB 01, 04, 31
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 24, 18, 07
	RGB 20, 15, 03
	RGB 07, 07, 07

MaleTownMapPals:
	RGB 31, 31, 31
	RGB 05, 17, 31
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 09, 19, 31
	RGB 03, 09, 29

	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 24, 18, 07
	RGB 20, 15, 03

	RGB 31, 31, 31
	RGB 25, 12, 09
	RGB 15, 07, 00
	RGB 00, 00, 00

	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 25, 04, 00
	RGB 31, 31, 31

	RGB 31, 31, 31
	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 25, 04, 00

	RGB 25, 12, 09
	RGB 09, 19, 31
	RGB 03, 09, 29
	RGB 02, 05, 17

	RGB 31, 31, 31
	RGB 24, 18, 07
	RGB 20, 15, 03
	RGB 25, 04, 00

Palettes_b7a9:
	RGB 31, 31, 31
	RGB 24, 25, 28
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 10, 06
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 31, 00
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 15, 31
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 21, 31
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 11
	RGB 31, 31, 06
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 19, 29
	RGB 25, 22, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 10, 06
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 30, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 06
	RGB 20, 15, 03
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 06
	RGB 15, 21, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 06
	RGB 20, 15, 03
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 24, 21
	RGB 31, 13, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00

GetPartySpritePalPointer:
	push de
	callba GetCurPartySpritePalIndex
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, Palettes_Pokemon_Menu
	add hl, de
	pop de
	ret

GetBallPackPal:
	ld a, [wMenuSelection]

; fallthrough
LoadBallPal:
	push de
	ld hl, PokeBallPals
	ld e, 5
	call IsInArray
	inc hl
	pop de
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	call LoadPalette_White_Col1_Col2_Black
	pop af
	ldh [rSVBK], a
	ret

GetBallAnimPal_:
	ld de, wOriginalOBJPals + 2 palettes
	ld a, [wCurItem] ; CurItem
	call LoadBallPal
	call ApplyPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

PokeBallPals:
	db MASTER_BALL
	RGB 27, 01, 29
	RGB 18, 01, 21
	db ULTRA_BALL
	RGB 31, 29, 03
	RGB 01, 01, 01
	db GREAT_BALL
	RGB 27, 00, 00
	RGB 02, 08, 28
	db POKE_BALL
	RGB 31, 31, 31
	RGB 27, 00, 00
	db DIVE_BALL
	RGB 02, 21, 27
	RGB 31, 00, 00
	db FAST_BALL
	RGB 31, 29, 03
	RGB 31, 00, 00
	db FRIEND_BALL
	RGB 10, 30, 02
	RGB 30, 00, 00
	db SHINY_BALL
	RGB 31, 29, 03
	RGB 31, 17, 00
	db QUICK_BALL
	RGB 31, 29, 03
	RGB 04, 21, 31
	db DUSK_BALL
	RGB 00, 15, 00
	RGB 28, 09, 00
	db REPEAT_BALL
	RGB 30, 25, 03
	RGB 31, 00, 00
	db TIMER_BALL
	RGB 31, 08, 08
	RGB 08, 08, 08
	db PARK_BALL
	RGB 16, 31, 04
	RGB 02, 11, 02
	db EAGULOU_BALL
	RGB 31, 31, 31
	RGB 20, 17, 08
	db -1
	RGB 31, 31, 31
	RGB 27, 00, 00

DarkenBall:
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalOBJPals)
	ld hl, wOriginalOBJPals + 2 palettes + 2
	ld c, 2
.loop
	push bc
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ColorNight
	pop de
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld h, d
	ld l, e
	ld [hli], a
	pop bc
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	call ApplyPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

LoadOW_BGPal7::
	ld hl, .palette
	ld de, wOriginalBGPals + 8 * 7
	ld bc, 8
	ld a, BANK(wOriginalBGPals)
	jp FarCopyWRAM

.palette
	RGB 31, 31, 31
	RGB 08, 19, 28
	RGB 05, 05, 16
	RGB 03, 03, 03
