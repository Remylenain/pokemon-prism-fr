TownMap_LoadGFX:
	call ClearVBank1
	ld hl, TownMapSpritesGFX
	ld de, vObjTiles
	call Decompress
	call TownMap_LoadTileGFX
	call LoadMapTilemap
	call GetPlayerIcon
	call RunFunctionInWRA6

; standing sprite
	ld hl, wDecompressScratch
	ld de, vObjTiles tile $10
	ld bc, 4 tiles
	rst CopyBytes

; walking sprite
	ld hl, wDecompressScratch + 12 tiles
	ld de, vObjTiles tile $14
	ld bc, 4 tiles
	rst CopyBytes
	ret

TownMap_RegionCheck:
	callba RegionCheck
	ld a, e
	ld [wTownMapRegion], a
	ret

TownMap_InitPlayerIcon:
	push af
	push af
	depixel 0, 0
	ld a, SPRITE_ANIM_INDEX_RED_WALK
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $10
	pop af
	ld e, a
	push bc
	callba GetLandmarkCoords
	pop bc
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], e
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], d
	pop af
	ret

TownMap_InitCursor:
	push af
	depixel 0, 0
	ld a, SPRITE_ANIM_INDEX_POKEGEAR_ARROW
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], 4
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_NULL
	pop af
	push bc
	ld e, a
	callba GetLandmarkCoords
	ld a, e
	ld [wTownMapCursorX], a
	ld a, d
	ld [wTownMapCursorY], a
	pop bc
	push bc
	call TownMap_UpdateCursorPosition
	pop bc
	ret

TownMap_UpdateCursorPosition:
	ld a, [wTownMapCursorX]
	ld e, a
	ld a, [wTownMapCursorY]
	ld d, a
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], e
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], d

TownMap_UpdateLandmarkName:
	hlcoord 0, 0
	lb bc, 1, 20
	call ClearBox
	ld a, [wTownMapCursorX]
	ld e, a
	ld a, [wTownMapCursorY]
	ld d, a
	ld a, [wTownMapRegion]
	ld c, a
	callba GetLandmarkNameByCoords
	ld de, wStringBuffer1
	hlcoord 1, 0
	jp PlaceString

TownMapSpritesGFX: INCBIN "gfx/town_map/sprites.2bpp.lz"

GetTownMapLimits:
	ld a, [wTownMapRegion]
	and a
	jr z, .farawayCheck
.setlimits
	ld d, 0
	ld hl, .limits
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret
.farawayCheck
	push de
	push bc
	ld hl, wEventFlags
	ld de, EVENT_FARAWAY_UNLOCKED
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop bc
	pop de
	jr z, .setlimits
	ld e, 7 ; New Limits for Naljo
	jr .setlimits

.limits
	db HEATH_VILLAGE, ROUTE_87 ; Naljo
	db SEASHORE_CITY, SOUTH_RIJON_GATE ; Rijon
	db ROUTE_47, GOLDENROD_CAPE ; Johto
	db SAFFRON_CITY, SAFFRON_CITY ; Kanto
	db EMBER_BROOK, TREASURE_COVE ; Sevii
	db TUNOD_WATERWAY, SOUTHERLY_CITY ; Tunod
	db MYSTERY_ZONE, MYSTERY_ZONE ; Mystery Zone
	db HEATH_VILLAGE, FARAWAY_ISLAND ; Naljo Faraway Unlocked

_FlyMap:
	ld hl, wTownMapFlags
	set 6, [hl]
	jr TownMapLoop

_TownMap:
	ld hl, wTownMapFlags
	res 6, [hl]

TownMapLoop:
	callba GetCurrentLandmark
	ld [wFlypoint], a
	ld [wd003], a
	call TownMap_RegionCheck

	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]

	ldh a, [hInMenu]
	push af
	ld a, 1
	ldh [hInMenu], a

	ld a, [wVramState]
	push af
	xor a
	ld [wVramState], a

	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call TownMap_LoadGFX
	callba ClearSpriteAnims
	callba LoadTownMapLandmarks
	ld a, 8
	call SkipMusic
	call EnableLCD
	ld a, $e3
	ldh [rLCDC], a
	ld a, [wd003]
	call TownMap_InitPlayerIcon
	call TownMap_InitCursor
	ld a, c
	ld [wd004], a
	ld a, b
	ld [wd005], a
	xor a
	ldh [hBGMapMode], a
	call LoadMapTilemap
	callba TownMapPals
	call ApplyAttrAndTilemapInVBlank
	call TownMap_UpdateLandmarkName
	lb bc, SCGB_TOWN_MAP_PALS, 0
	predef GetSGBLayout
	call SetPalettes
	ld a, %11100100
	call DmgToCgbObjPal0
	call DelayFrame
	call GetTownMapLimits
	call .loop

	pop af
	ld [wVramState], a

	pop af
	ldh [hInMenu], a

	pop af
	ld [wOptions], a

	jp ClearBGPalettes

.loop_resetflypoint
	ld e, a
.loop
	call JoyTextDelay
	ldh a, [hJoyPressed]
	bit B_BUTTON_F, a
	jr nz, .pressedB
	bit A_BUTTON_F, a
	jr nz, .pressedA

	ldh a, [hJoyDown]
	call TownMap_HandleInput
	callba PlaySpriteAnimations
	call DelayFrame
	jr .loop

.pressedB
	ld a, [wTownMapFlags]
	bit 6, a
	ret z
	ld a, $ff
	ld e, a
	ret

.pressedA
	ld a, [wTownMapFlags]
	bit 6, a
	jr z, .loop
	ld a, [wTownMapCursorX]
	ld e, a
	ld a, [wTownMapCursorY]
	ld d, a
	ld a, [wTownMapRegion]
	ld c, a
	callba GetLandmarkByCoords
	ld c, 0
	ld hl, Flypoints
.nextFlypoint
	inc c
	ld a, [hli]
	cp $ff
	jr z, .loop_resetflypoint
	cp e
	jr nz, .nextFlypoint
	call CheckIfVisitedFlypoint
	jr z, .loop
	ld a, c
	ld e, a
	ret

TownMap_HandleInput:
	ld b, a
	ld a, [wTownMapCursorX]
	and a
	ld a, b
	ret z

	ld hl, wTownMapCursorX
	bit D_RIGHT_F, a
	jr nz, .pressed_right

	bit D_LEFT_F, a
	jr nz, .pressed_left

	ld hl, wTownMapCursorY
	bit D_DOWN_F, a
	jr nz, .pressed_down

	bit D_UP_F, a
	ret z

.pressed_up
	push af
	ld a, [hl]
	cp $25
	jr nc, .okay
	ld a, $25
	ld [hl], a

.okay
	dec [hl]
	pop af
	jr .next

.pressed_down
	push af
	ld a, [hl]
	cp $94
	jr c, .okay2
	ld a, $93
	ld [hl], a

.okay2
	inc [hl]
	pop af
	jr .next

.pressed_left
	push af
	ld a, [hl]
	cp $15
	jr nc, .okay3
	ld a, $15
	ld [hl], a

.okay3
	dec [hl]
	pop af
	jr .next

.pressed_right
	push af
	ld a, [hl]
	cp $9C
	jr c, .okay4
	ld a, $9B
	ld [hl], a

.okay4
	inc [hl]
	pop af

.next
	push af
	push hl
	ld a, [wd004]
	ld c, a
	ld a, [wd005]
	ld b, a
	call TownMap_UpdateCursorPosition
	pop hl
	ld a, [hl]
	and 7
	cp 4
	pop bc ; don't mess with flags
	ld a, b
	ret z
	push af
	callba PlaySpriteAnimations
	call DelayFrame
	pop af
	jr TownMap_HandleInput

LoadMapTilemap:
	ld a, [wTownMapRegion]
	ld e, a
	ld d, 0
	ld hl, TownMapTilemapPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	coord de, 0, 1 ; strats
	jp Decompress

TownMapTilemapPointers:
	dw NaljoMap
	dw RijonMap
	dw JohtoMap
	dw KantoMap
	dw SeviiMap
	dw TunodMap
	dw TunodMap

TownMap_LoadTileGFX:
	ld hl, TownMapGFX
	ld de, vBGTiles
	lb bc, BANK(TownMapGFX), $30
	jp DecompressRequest2bpp

CheckIfVisitedFlypoint:
	push bc
	push de
	push hl
	ld hl, wVisitedSpawns
	ld b, CHECK_FLAG
	predef FlagAction
	pop hl
	pop de
	pop bc
	ret

Flypoints:
	; Naljo
	db CAPER_RIDGE
	db OXALIS_CITY
	db SPURGE_CITY
	db HEATH_VILLAGE
	db LAUREL_CITY
	db TORENIA_CITY
	db PHACELIA_CITY
	db ACANIA_DOCKS
	db SAXIFRAGE_ISLAND
	db PHLOX_TOWN
	db CHAMPION_ISLE

	; Rijon
	db SEASHORE_CITY
	db GRAVEL_TOWN
	db MERSON_CITY
	db HAYWARD_CITY
	db OWSAURI_CITY
	db MORAGA_TOWN
	db JAERU_CITY
	db BOTAN_CITY
	db CASTRO_VALLEY
	db EAGULOU_CITY
	db RIJON_LEAGUE
	db SENECA_CAVERNS

	; Johto
	db AZALEA_TOWN
	db GOLDENROD_CITY

	; Kanto - not useful since there's just one
	db SAFFRON_CITY

	; Sevii - empty

	; Tunod - not useful since there's just one
	db SOUTHERLY_CITY

	; spawns that aren't flypoints
	db 0 ; BATTLE_TOWER_ENTRANCE
	db 0 ; SPURGE_GYM_1F
	db 0 ; ACQUA_START
	db 0 ; ACQUA_TUTORIAL
	db 0 ; LAUREL_FOREST_POKEMON_ONLY
	db 0 ; ROUTE_77

	; New flypoints for 0.95 - Naljo & Tunod
	db ROUTE_81
	db BATTLE_TOWER ; Outside on Route 71
	db OLCAN_ISLE

	db -1

ShowMonNestLocations:
; e: Current landmark
	ld a, e
	ld [wFlypoint], a
	call ClearSprites
	xor a
	ldh [hBGMapMode], a
	ld a, 1
	ldh [hInMenu], a

	call TownMap_RegionCheck
	callba LoadTownMapLandmarks
	ld de, PokedexNestIconGFX
	ld hl, vObjTiles tile $7f
	lb bc, BANK(PokedexNestIconGFX), 1
	call Request2bpp
	call GetPlayerIcon
	ld de, wDecompressScratch
	ld hl, vObjTiles tile $78
	ld c, 4
	call Request2bppInWRA6
	call TownMap_LoadTileGFX
	call TownMap_RegionCheck
	ld a, e
	ld [wd003], a
	call LoadMapTilemap
	call .GFX_Update
	lb bc, SCGB_TOWN_MAP_PALS, 0
	predef GetSGBLayout
	call SetPalettes
	xor a
	ldh [hBGMapMode], a
	call .GetAndPlaceNest
.loop
	call JoyTextDelay
	ld hl, hJoyPressed
	ld a, [hl]
	and A_BUTTON | B_BUTTON
	jr nz, .a_b
	ldh a, [hJoypadDown]
	and SELECT
	jr nz, .select
	call .LeftRightInput
	call .BlinkNestIcons
	jr .next

.select
	call .HideNestsShowPlayer
.next
	call DelayFrame
	jr .loop

.a_b
	jp ClearSprites

.GFX_Update
	call .PlaceString_MonsNest
	call TownMapPals
	hlbgcoord 0, 0
	jp TownMapBGUpdate

.LeftRightInput
	ld a, [wStatusFlags]
	bit 6, a ; hall of fame
	ret z
	bit D_LEFT_F, [hl]
	jr nz, .left
	bit D_RIGHT_F, [hl]
	ret z
.right
	call ClearSprites
	ld a, [wd003]
	inc a
	cp REGION_TUNOD + 1
	jr c, .UpdateGFX
	xor a
	jr .UpdateGFX

.left
	call ClearSprites
	ld a, [wd003]
	and a
	jr nz, .okay
	ld a, REGION_TUNOD + 1

.okay
	dec a
.UpdateGFX
	ld [wd003], a
	ld [wTownMapRegion], a
	call LoadMapTilemap
	call .GFX_Update
	callba LoadTownMapLandmarks
.GetAndPlaceNest
	callba FindNest ; load nest landmarks into wTileMap[0,0]
	decoord 0, 0
	ld hl, wSprites
.nestloop
	ld a, [de]
	and a
	jr z, .done_nest
	push de
	ld e, a
	push hl
	callba GetLandmarkCoords
	pop hl
	; load into OAM
	ld a, d
	sub 4
	ld [hli], a
	ld a, e
	sub 4
	ld [hli], a
	ld a, $7f ; nest icon in this context
	ld [hli], a
	xor a
	ld [hli], a
	; next
	pop de
	inc de
	jr .nestloop

.done_nest
	ld hl, wSprites
	decoord 0, 0
	ld bc, wSpritesEnd - wSprites
	rst CopyBytes
	ret

.BlinkNestIcons
	ldh a, [hVBlankCounter]
	ld e, a
	and $f
	ret nz
	ld a, e
	and $10
	jp z, ClearSprites
	hlcoord 0, 0
	ld de, wSprites
	ld bc, wSpritesEnd - wSprites
	rst CopyBytes
	ret

.PlaceString_MonsNest
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call GetPokemonName
	hlcoord 2, 0
	call PlaceString
	ld h, b
	ld l, c
	ld de, .String_SNest
	jp PlaceString

.String_SNest
	db "'s nest@"

.HideNestsShowPlayer
	call .CheckPlayerLocation
	ret c
	ld a, [wFlypoint]
	ld e, a
	callba GetLandmarkCoords
	ld c, e
	ld b, d
	ld de, .PlayerOAM
	ld hl, wSprites
.ShowPlayerLoop
	ld a, [de]
	cp $80
	jr z, .clear_oam
	add b
	ld [hli], a
	inc de
	ld a, [de]
	add c
	ld [hli], a
	inc de
	ld a, [de]
	add $78 ; where the player's sprite is loaded
	ld [hli], a
	inc de
	xor a
	ld [hli], a
	jr .ShowPlayerLoop

.clear_oam
	ld hl, wSprites + 4 * 4
	ld bc, wSpritesEnd - (wSprites + 4 * 4)
	xor a
	jp ByteFill

.PlayerOAM
	db -1 * 8, -1 * 8,  0 ; top left
	db -1 * 8,  0 * 8,  1 ; top right
	db  0 * 8, -1 * 8,  2 ; bottom left
	db  0 * 8,  0 * 8,  3 ; bottom right
	db $80 ; terminator

.CheckPlayerLocation
; Don't show the player's sprite if you're
; not in the same region as what's currently
; on the screen.
	ld a, [wFlypoint]
	cp KANTO_LANDMARK
	jr c, .johto
.kanto
	ld a, [wd003]
	and a
	jr z, .clear
	jr .ok
.johto
	ld a, [wd003]
	and a
	jr nz, .clear
.ok
	and a
	ret
.clear
	ld hl, wSprites
	ld bc, wSpritesEnd - wSprites
	xor a
	call ByteFill
	scf
	ret

TownMapBGUpdate:
; Update BG Map tiles and attributes
; BG Map address
	ld a, l
	ldh [hBGMapAddress], a
	ld a, h
	ldh [hBGMapAddress + 1], a
	ld b, 3
	call SafeCopyTilemapAtOnce
	xor a
	ldh [hBGMapMode], a
	ret

TownMapPals:
; Assign palettes based on tile ids
	hlcoord 0, 0
	decoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
.loop
; Current tile
	ld a, [hli]
	push hl
; HP/borders use palette 0
	cp $60
	jr nc, .pal0
; The palette data is condensed to nybbles,
; least-significant first.
	ld hl, .PalMap
	srl a
	jr c, .odd
; Even-numbered tile ids take the bottom nybble...
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hl]
	and %111
	jr .update
.odd
; ...and odd ids take the top.
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hl]
	swap a
	and %111
	jr .update
.pal0
	xor a
.update
	pop hl
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

.PalMap
MACRO townmappals
rept _NARG / 2
	dn \2, \1
	shift 2
endr
endm
	townmappals 1, 4, 1, 2, 4, 2, 4, 4, 6, 6, 3, 4, 3, 7, 6, 5
	townmappals 4, 1, 4, 4, 7, 4, 4, 4, 6, 6, 7, 7, 7, 7, 4, 4
	townmappals 1, 4, 1, 2, 4, 2, 4, 4, 7, 4, 4, 6, 6, 6, 6, 6
	townmappals 0, 0, 0, 0, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0
	townmappals 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
	townmappals 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0

NaljoMap: INCBIN "gfx/town_map/naljo.bin.lz"
RijonMap: INCBIN "gfx/town_map/rijon.bin.lz"
JohtoMap: INCBIN "gfx/town_map/johto.bin.lz"
KantoMap: INCBIN "gfx/town_map/kanto.bin.lz"
SeviiMap: INCBIN "gfx/town_map/seviiislands.bin.lz"
TunodMap: INCBIN "gfx/town_map/tunod.bin.lz"

PokedexNestIconGFX: INCBIN "gfx/town_map/dexmap_nest_icon.2bpp"
