; Replaces the functionality of sgb.asm to work with CGB hardware.

GetSGBLayout::
	ld a, b
	cp SCGB_RAM
	jr nz, .not_ram
	ld a, [wSGBPredef]
.not_ram
	cp SCGB_PARTY_MENU_HP_PALS
	jp z, CGB_ApplyPartyMenuHPPals
	call ResetPals
	jumptable

	dw _CGB_BattleGrayscale
	dw _CGB_BattleColors
	dw _CGB_TownMapPals
	dw _CGB_StatsScreenHPPals
	dw _CGB_Pokedex
	dw _CGB_SlotMachine
	dw _CGB_ScrollingMenu
	dw _CGB_MapPals
	dw _CGB0a
	dw _CGB0b
	dw _CGB0e
	dw _CGB_PokedexSearchOption
	dw _CGB_Pokepic
	dw _CGB_PackPals
	dw _CGB_TrainerCard
	dw _CGB17
	dw _CGB18
	dw _CGB19
	dw _CGB1a
	dw _CGB1b
	dw _CGB_FrontpicPals
	dw _CGB_SecondLogoIntroPals

_CGB_BattleGrayscale:
	ld hl, PalPacket_9c66
	ld de, wOriginalBGPals
	ld c, 4
	call CopyPalettes
	ld hl, PalPacket_9c66
	ld de, wOriginalBGPals + 4 palettes
	ld c, 4
	call CopyPalettes
	ld hl, PalPacket_9c66
	ld de, wOriginalOBJPals
	ld c, 2
	call CopyPalettes
	jr _CGB_FinishBattleScreenLayout

_CGB_BattleColors:
	ld de, wOriginalBGPals
	call GetBattlemonBackpicPalettePointer
	push hl
	call LoadPalette_White_Col1_Col2_Black
	call GetEnemyFrontpicPalettePointer
	push hl
	call LoadPalette_White_Col1_Col2_Black
	ld a, [wEnemyHPPal]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld a, [wPlayerHPPal]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palettes_a8ca
	call LoadPalette_White_Col1_Col2_Black
	ld de, wOriginalOBJPals
	pop hl
	call LoadPalette_White_Col1_Col2_Black
	pop hl
	call LoadPalette_White_Col1_Col2_Black
	ld a, SCGB_BATTLE_COLORS
	ld [wSGBPredef], a
	call ApplyPals
_CGB_FinishBattleScreenLayout:
	call InitPartyMenuBGPal7
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, 2
	call ByteFill
	hlcoord 0, 4, wAttrMap
	lb bc, 8, 10
	ld a, 0
	call FillBoxWithByte
	hlcoord 10, 0, wAttrMap
	lb bc, 7, 10
	ld a, 1
	call FillBoxWithByte
	hlcoord 0, 0, wAttrMap
	lb bc, 4, 10
	ld a, 2
	call FillBoxWithByte
	hlcoord 10, 7, wAttrMap
	lb bc, 5, 10
	ld a, 3
	call FillBoxWithByte
	hlcoord 10, 11, wAttrMap
	lb bc, 1, 9
	ld a, 4
	call FillBoxWithByte
	hlcoord 0, 12, wAttrMap
	ld bc, 6 * SCREEN_WIDTH
	ld a, 7
	call ByteFill
	ld hl, Palettes_979c
	ld de, wOriginalOBJPals + 2 palettes
	ld bc, 6 palettes
	ld a, 5
	call FarCopyWRAM
	jp ApplyAttrMap

InitPartyMenuBGPal7:
	ld hl, Palette_b311
	ld de, wOriginalBGPals + 8 * 7
	jr InitPartyMenuBGPal7_Continue

InitPartyMenuBGPal0:
	ld hl, Palette_b311
	ld de, wOriginalBGPals
InitPartyMenuBGPal7_Continue:
	ld bc, 1 palettes
	ld a, 5
	jp FarCopyWRAM

_CGB_TownMapPals:
	ld a, c
	and a
	push af
	ld hl, MaleTownMapPals
	ld de, wOriginalBGPals
	ld bc, 8 palettes
	ld a, 5
	call FarCopyWRAM
	ld de, wOriginalOBJPals
	pop af
	jr z, .skip
	call GetPartySpritePalPointer
	ld bc, 1 palettes
	ld a, 5
	call FarCopyWRAM
.skip
	xor a
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call ApplyPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

_CGB_StatsScreenHPPals:
	ld de, wOriginalBGPals
	ld a, [wcda1]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld a, [wCurPartySpecies]
	ld bc, wTempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palettes_a8ca
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palette8f52
	ld de, wOriginalBGPals + 8 * 3
	ld bc, 4 palettes
	ld a, 5
	call FarCopyWRAM
	call WipeAttrMap

	hlcoord 0, 0, wAttrMap
	lb bc, 7, SCREEN_WIDTH
	ld a, 1
	call FillBoxWithByte

	hlcoord 10, 16, wAttrMap
	ld bc, 10
	ld a, 2
	call ByteFill

	hlcoord 11, 5, wAttrMap
	lb bc, 2, 2
	ld a, 3
	call FillBoxWithByte

	hlcoord 13, 5, wAttrMap
	lb bc, 2, 2
	ld a, 4
	call FillBoxWithByte

	hlcoord 15, 5, wAttrMap
	lb bc, 2, 2
	ld a, 5
	call FillBoxWithByte

	hlcoord 17, 5, wAttrMap
	lb bc, 2, 2
	ld a, 6
	call FillBoxWithByte

	hlcoord 0, 7, wAttrMap
	ld bc, SCREEN_WIDTH
	ld a, 7
	call ByteFill

	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

Palette8f52:
	RGB 31, 31, 31
	RGB 31, 19, 31
	RGB 31, 15, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 31, 14
	RGB 17, 31, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 17, 31, 31
	RGB 17, 31, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 19, 00
	RGB 31, 15, 00
	RGB 00, 00, 00

StatsScreenPals:
	RGB 31, 19, 31
	RGB 21, 31, 14
	RGB 17, 31, 31
	RGB 31, 19, 00

_CGB_Pokedex:
	ld de, wOriginalBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [wCurPartySpecies]
	cp $ff
	jr nz, .is_pokemon
	ld hl, Palette8fba
	call LoadHLPaletteIntoDE
	jr .got_palette

.is_pokemon
	call GetMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
.got_palette
	call WipeAttrMap
	hlcoord 1, 1, wAttrMap
	lb bc, 7, 7
	ld a, 1
	call FillBoxWithByte
	call InitPartyMenuOBPals
	ld hl, Palette8fc2
	ld de, wOriginalOBJPals + 7 palettes
	ld bc, 1 palettes
	ld a, 5
	call FarCopyWRAM
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

Palette8fba:
	RGB 11, 23, 00
	RGB 07, 17, 00
	RGB 06, 16, 03
	RGB 05, 12, 01

Palette8fc2:
	RGB 00, 00, 00
	RGB 11, 23, 00
	RGB 07, 17, 00
	RGB 00, 00, 00

_CGB17:
	ld de, wOriginalBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [wCurPartySpecies]
	cp $ff
	jr nz, .GetMonPalette
	ld hl, Palette9036
	call LoadHLPaletteIntoDE
	jr .Resume

.GetMonPalette
	ld bc, wTempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
.Resume
	call WipeAttrMap
	hlcoord 1, 4, wAttrMap
	lb bc, 7, 7
	ld a, 1
	call FillBoxWithByte
	call InitPartyMenuOBPals
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

Palette9036:
	RGB 31, 15, 00
	RGB 23, 12, 00
	RGB 15, 07, 00
	RGB 00, 00, 00

_CGB_SlotMachine:
	ld hl, Palettes_b7a9
	ld de, wOriginalBGPals
	ld bc, $80
	ld a, 5
	call FarCopyWRAM
	call WipeAttrMap
	hlcoord 0, 2, wAttrMap
	lb bc, 10, 3
	ld a, 2
	call FillBoxWithByte
	hlcoord 17, 2, wAttrMap
	lb bc, 10, 3
	ld a, 2
	call FillBoxWithByte
	hlcoord 0, 4, wAttrMap
	lb bc, 6, 3
	ld a, 3
	call FillBoxWithByte
	hlcoord 17, 4, wAttrMap
	lb bc, 6, 3
	ld a, 3
	call FillBoxWithByte
	hlcoord 0, 6, wAttrMap
	lb bc, 2, 3
	ld a, 4
	call FillBoxWithByte
	hlcoord 17, 6, wAttrMap
	lb bc, 2, 3
	ld a, 4
	call FillBoxWithByte
	hlcoord 4, 2, wAttrMap
	lb bc, 2, 12
	ld a, 1
	call FillBoxWithByte
	hlcoord 3, 2, wAttrMap
	lb bc, 10, 1
	ld a, 1
	call FillBoxWithByte
	hlcoord 16, 2, wAttrMap
	lb bc, 10, 1
	ld a, 1
	call FillBoxWithByte
	hlcoord 0, 12, wAttrMap
	ld bc, $78
	ld a, 7
	call ByteFill
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

_CGB_ScrollingMenu:
	ld hl, Palettes_b641
	ld de, wOriginalBGPals
	ld bc, 16 palettes
	ld a, 5
	call FarCopyWRAM

	ld hl, PalPacket_9cb6
	call CopyFourPalettes
	call WipeAttrMap
	jp ApplyAttrMap

_CGB_MapPals:
	call LoadMapPals
	ld a, SCGB_MAPPALS
	ld [wSGBPredef], a
	ret

_CGB0a:
	ld hl, PalPacket_9c56
	call CopyFourPalettes
	call InitPartyMenuBGPal0
	call InitPartyMenuBGPal7
	call InitPartyMenuOBPals
	jp ApplyAttrMap

_CGB0b:
	ld de, wOriginalBGPals
	ld a, c
	and a
	jr z, .pokemon
	ld a, $1a
	call GetPredefPal
	call LoadHLPaletteIntoDE
	jr .got_palette

.pokemon
	ld hl, wPartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld c, l
	ld b, h
	ld a, [wPlayerHPPal]
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palettes_979c
	ld de, wOriginalOBJPals + 2 palettes
	ld bc, 6 palettes
	ld a, 5
	call FarCopyWRAM

.got_palette
	call WipeAttrMap
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

_CGB18:
	ld hl, PalPacket_9bc6
	call CopyFourPalettes
	ld de, wOriginalOBJPals
	ld a, $4c
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalOBJPals)
	ld hl, wOriginalOBJPals
	ld a, $1f
	ld [hli], a
	ld a, 0
	ld [hl], a
	pop af
	ldh [rSVBK], a
	call WipeAttrMap
	jp ApplyAttrMap

_CGB_TrainerCard:
	ld de, wOriginalBGPals
	ld a, [wPlayerGender]
	bit 0, a
	ld hl, .boycard
	jr z, .boy
	ld hl, .girlcard
.boy
	call LoadPalette_White_Col1_Col2_Black
	xor a
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalOBJPals)
	ld hl, wOriginalOBJPals
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
; setup all leader and badge pals into wTrainerCardLeaderPals
	ld de, wTrainerCardLeaderPals
	ld b, 20
.loop
	ld a, [hli]
	push bc
	wbk BANK(wNaljoBadges)
	ld a, 20		; convert the loop counter into the badge number
	sub b

	cp 8			; get the address of the byte the flag resides in into HL
	ld hl, wNaljoBadges
	jr c, .gotaddress
	cp 16
	ld hl, wRijonBadges
	jr c, .gotaddress
	ld hl, wOtherBadges
.gotaddress
	ld b, 0
	ld c, a
	push bc
	and 7 ; move the relevant bit to the very right
	ld b, a
	ld a, [hl]
.shiftloop
	rrca
	dec b
	jr nz, .shiftloop
	bit 0, a
	ld hl, .notdefeated
	pop bc
	jr z, .gotpointer
	ld hl, .leaderlist
	add hl, bc
	ld a, [hl]
	call GetTrainerPalettePointer
.gotpointer
	ld c, 2 * 2
	wbk BANK(wTrainerCardLeaderPals)
.loop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop2
	pop bc
	dec b
	jr nz, .loop
	ld hl, .badgepals
	ld de, wTrainerCardBadgePals
	ld bc, 20 * 4
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	ld a, $24
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret
.leaderlist
	db JOSIAH, RINJI, BROOKLYN, EDISON, ANDRE, AYAKA, CADENCE, BRUCE ; Naljo
	db KARPMAN, LILY, LOIS, SPARKY, KOJI, SHERYL, JOE, SILVER ; Rijon
	db BUGSY, WHITNEY, SABRINA, ERNEST ; Extra 4
.boycard
	RGB 14, 16, 31
	RGB 07, 05, 29
.girlcard
	RGB 25, 17, 20
	RGB 26, 02, 19
.notdefeated
	RGB 00, 00, 00
	RGB 00, 00, 00
.badgepals
	; Pyre Badge
	RGB 30, 19, 04
	RGB 30, 06, 04
	; Nature Badge
	RGB 14, 30, 00
	RGB 07, 17, 06
	; Charm Badge
	RGB 30, 14, 22
	RGB 18, 09, 24
	; Midnight Badge
	RGB 17, 17, 28
	RGB 06, 10, 24
	; Muscle Badge
	RGB 28, 19, 10
	RGB 18, 08, 06
	; Smog Badge
	RGB 24, 09, 24
	RGB 11, 01, 11
	; Raucous Badge
	RGB 30, 26, 04
	RGB 16, 14, 25
	; Naljo Badge
	RGB 21, 14, 09
	RGB 14, 06, 04
	; Marine Badge
	RGB 15, 21, 30
	RGB 08, 10, 30
	; Hail Badge
	RGB 14, 27, 30
	RGB 08, 15, 11
	; Sprout Badge
	RGB 22, 27, 01
	RGB 04, 15, 06
	; Sparky Badge
	RGB 30, 30, 03
	RGB 17, 05, 17
	; Fist Badge
	RGB 30, 21, 04
	RGB 17, 08, 05
	; Psi Badge
	RGB 30, 27, 00
	RGB 22, 15, 00
	; White Badge
	RGB 30, 30, 30
	RGB 22, 21, 21
	; Star Badge
	RGB 30, 09, 01
	RGB 20, 04, 02
	; Hive Badge
	RGB 30, 13, 06
	RGB 28, 04, 04
	; Plain Badge
	RGB 30, 26, 04
	RGB 17, 19, 18
	; Marsh Badge
	RGB 27, 18, 03
	RGB 11, 07, 09
	; Blaze Badge
	RGB 30, 25, 06
	RGB 30, 11, 00

_CGB0e:
	ld de, wOriginalBGPals
	ld a, $10
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [wPlayerHPPal]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	hlcoord 11, 1, wAttrMap
	lb bc, 2, 9
	ld a, 1
	call FillBoxWithByte
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

_CGB_PokedexSearchOption:
	ld de, wOriginalBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

_CGB_PackPals:
; pack pals
	ld a, [wBattleType]
	ld hl, .ChrisPackPals
	ld a, [wPlayerGender]
	rra
	jr nc, .got_gender
	ld hl, .KrisPackPals
.got_gender
	ld de, wOriginalBGPals
	ld bc, 6 palettes
	ld a, 5
	call FarCopyWRAM
	call WipeAttrMap
	hlcoord 0, 0, wAttrMap
	lb bc, 1, 10
	ld a, 1
	call FillBoxWithByte
	hlcoord 10, 0, wAttrMap
	lb bc, 1, 10
	ld a, 2
	call FillBoxWithByte
	hlcoord 7, 2, wAttrMap
	lb bc, 9, 1
	ld a, 3
	call FillBoxWithByte
	hlcoord 0, 7, wAttrMap
	lb bc, 3, 5
	ld a, 4
	call FillBoxWithByte
	hlcoord 0, 3, wAttrMap
	lb bc, 3, 5
	ld a, 5
	call FillBoxWithByte
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

.ChrisPackPals
	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 11, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 31, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 19, 07
	RGB 07, 19, 07
	RGB 00, 00, 00

.KrisPackPals
	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 15, 15, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 31, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 19, 07
	RGB 07, 19, 07
	RGB 00, 00, 00

_CGB_Pokepic:
	call _CGB_MapPals
	ld bc, wTempMonDVs
	ld a, [wCurPartySpecies]
	call GetMonNormalOrShinyPalettePointer
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalBGPals)
	ld de, wOriginalBGPals + 7 palettes
	call LoadPalette_White_Col1_Col2_Black
	pop af
	ldh [rSVBK], a
	ld bc, SCREEN_WIDTH
	hlcoord 0, 0, wAttrMap
	ld a, [wMenuBorderTopCoord]
	rst AddNTimes
	ld a, [wMenuBorderLeftCoord]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [wMenuBorderTopCoord]
	ld b, a
	ld a, [wMenuBorderBottomCoord]
	inc a
	sub b
	ld b, a
	ld a, [wMenuBorderLeftCoord]
	ld c, a
	ld a, [wMenuBorderRightCoord]
	sub c
	inc a
	ld c, a
	ld a, 7
	call FillBoxWithByte
	call ApplyAttrMapAndPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

_CGB_SecondLogoIntroPals:
	ld de, wOriginalBGPals
	ld a, $4e
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld hl, SecondLogoIntroPal
	ld de, wOriginalBGPals + 1 palettes
	call LoadHLPaletteIntoDE
	ld hl, GSIntroYellowPal
	ld de, wOriginalOBJPals
	call LoadHLPaletteIntoDE
	ld hl, GSIntroYellowPal
	call LoadHLPaletteIntoDE
	jp WipeAttrMap

_CGB19:
	ld de, wOriginalBGPals
	ld a, $4e
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld hl, CrystalIntroPalette
	ld de, wOriginalOBJPals
	call LoadHLPaletteIntoDE
	ld hl, CrystalIntroPalette
	ld de, wOriginalOBJPals + 1 palettes
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	jp ApplyAttrMapAndPals

CrystalIntroPalette:
	RGB 31, 31, 31
	RGB 13, 11, 00
	RGB 23, 12, 28
	RGB 00, 00, 00

GSIntroYellowPal:
	RGB 31, 31, 31
	RGB 25, 30, 00
	RGB 25, 30, 00
	RGB 25, 30, 00

SecondLogoIntroPal:
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 23, 12, 28

_CGB1a:
	ld de, wOriginalBGPals
	ld a, [wCurPartySpecies]
	ld bc, wTempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	jp ApplyAttrMapAndPals

_CGB1b:
	ld hl, PalPacket_9cc6
	call CopyFourPalettes
	ld hl, Palettes_b681
	ld de, wOriginalOBJPals
	ld bc, 1 palettes
	ld a, 5
	call FarCopyWRAM
	ld de, wOriginalOBJPals + 7 palettes
	ld a, $1c
	call GetPredefPal
	call LoadHLPaletteIntoDE
	jp WipeAttrMap

_CGB_FrontpicPals:
	ld de, wOriginalBGPals
	ld a, [wCurPartySpecies]
	ld bc, wTempMonDVs
	call GetFrontpicPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	jp ApplyAttrMapAndPals
