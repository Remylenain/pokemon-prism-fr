GetEmote2bpp:
	vbk BANK(vWalkingFrameTiles)
	call Get2bpp
	vbk BANK(vFontTiles)
	ret

_ReplaceKrisSprite::
	call GetPlayerSprite
	ld a, [wUsedSprites]
	ldh [hUsedSpriteIndex], a
	ld a, [wUsedSprites + 1]
	ldh [hUsedSpriteTile], a
	jp GetUsedSprite

RefreshSprites::
	xor a
	ld bc, wUsedSpritesEnd - wUsedSprites
	ld hl, wUsedSprites
	call ByteFill
	call GetPlayerSprite
	call AddMapSprites
	call LoadAndSortSprites
	jp RunSpritesCallback

GetPlayerSprite:
; Get Chris or Kris's sprite.
	CheckEngine ENGINE_CUSTOM_PLAYER_SPRITE
	ld a, [wPlayerSprite]
	jr nz, .finishCustomSprite
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .GetPlayerSprite_PokemonMode
	ld hl, .Male0
	CheckEngine ENGINE_KRIS_IN_CABLE_CLUB
	jr nz, .go
	ld a, [wPlayerCharacteristics]
	and $f
	jr z, .go
	cp 14
	jr nc, .go
	ld e, a
	ld d, 0
	; add 9 times
	add hl, de
	swap e
	srl e
	add hl, de
.go
	ld a, [wPlayerState]
	ld e, 2
	call IsInArray
	inc hl
	jr c, .good
; Any player state not in the array defaults to Chris's sprite.
	assert PLAYER_NORMAL == 0
	xor a
	ld [wPlayerState], a
.fail
	ld a, SPRITE_P0
	jr .finish

.GetPlayerSprite_PokemonMode
	ld a, [wPokeonlyMainSpecies]
	and a
	jr nz, .get_pkmn_sprite
	ld hl, wPartyMon1 + MON_HP
	ld de, wPartySpecies
	ld bc, PARTYMON_STRUCT_LENGTH - 1
	jr .handleLoop

.nextMon
	inc de
	add hl, bc
.handleLoop
	ld a, [de]
	and a
	jr z, .fail
	cp $ff
	jr z, .fail
	cp EGG
	jr z, .nextMon
	ld a, [hli]
	or [hl]
	jr z, .nextMon
	ld bc, MON_DVS - (MON_HP + 1)
	add hl, bc
	ld bc, wPokeonlyMainDVs
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [bc], a
	ld a, [de]
	ld [wPokeonlyMainSpecies], a
.get_pkmn_sprite
	ld a, SPRITE_POKEONLY_PLAYER
	jr .finish

.good
	ld a, [hl]
.finish
	ld [wPlayerSprite], a
.finishCustomSprite
	ld [wUsedSprites + 0], a
	ld [wPlayerObjectSprite], a
	ret

.PlayerSprites
.Male0
	db PLAYER_NORMAL,    SPRITE_P0
	db PLAYER_BIKE,      SPRITE_P0_BIKE
	db PLAYER_SURF,      SPRITE_P0_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female0
	db PLAYER_NORMAL,    SPRITE_P1
	db PLAYER_BIKE,      SPRITE_P1_BIKE
	db PLAYER_SURF,      SPRITE_P1_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male1
	db PLAYER_NORMAL,    SPRITE_P2
	db PLAYER_BIKE,      SPRITE_P2_BIKE
	db PLAYER_SURF,      SPRITE_P2_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female1
	db PLAYER_NORMAL,    SPRITE_P3
	db PLAYER_BIKE,      SPRITE_P3_BIKE
	db PLAYER_SURF,      SPRITE_P3_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male2
	db PLAYER_NORMAL,    SPRITE_P4
	db PLAYER_BIKE,      SPRITE_P4_BIKE
	db PLAYER_SURF,      SPRITE_P4_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female2
	db PLAYER_NORMAL,    SPRITE_P5
	db PLAYER_BIKE,      SPRITE_P5_BIKE
	db PLAYER_SURF,      SPRITE_P5_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male3
	db PLAYER_NORMAL,    SPRITE_P6
	db PLAYER_BIKE,      SPRITE_P6_BIKE
	db PLAYER_SURF,      SPRITE_P6_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female3
	db PLAYER_NORMAL,    SPRITE_P7
	db PLAYER_BIKE,      SPRITE_P7_BIKE
	db PLAYER_SURF,      SPRITE_P7_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male4
	db PLAYER_NORMAL,    SPRITE_P8
	db PLAYER_BIKE,      SPRITE_P8_BIKE
	db PLAYER_SURF,      SPRITE_P8_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female4
	db PLAYER_NORMAL,    SPRITE_P9
	db PLAYER_BIKE,      SPRITE_P9_BIKE
	db PLAYER_SURF,      SPRITE_P9_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Male5
	db PLAYER_NORMAL,    SPRITE_P10
	db PLAYER_BIKE,      SPRITE_P10_BIKE
	db PLAYER_SURF,      SPRITE_P10_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.Female5
	db PLAYER_NORMAL,    SPRITE_P11
	db PLAYER_BIKE,      SPRITE_P11_BIKE
	db PLAYER_SURF,      SPRITE_P11_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.PalettePatroller
	db PLAYER_NORMAL,    SPRITE_PALETTE_PATROLLER
	db PLAYER_BIKE,      SPRITE_P12_BIKE
	db PLAYER_SURF,      SPRITE_P12_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

.PalettePatrollerF
	db PLAYER_NORMAL,    SPRITE_PALETTE_PATROLLER
	db PLAYER_BIKE,      SPRITE_P12_BIKE
	db PLAYER_SURF,      SPRITE_P12_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff

AddMapSprites:
	call GetMapPermission
	call CheckOutdoorMap
	jp z, .outdoor
	ld hl, wMap1ObjectSprite
	ld a, NUM_OBJECTS
.loop
	dec a
	ret z
	push af
	ld a, [hl]
	call AddSpriteGFX
	ld de, OBJECT_LENGTH
	add hl, de
	pop af
	jr .loop

.outdoor:
	ld a, [wMapGroup]
	dec a
	ld c, a
	ld b, 0
	ld hl, OutdoorSprites
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop2
	ld a, [hli]
	and a
	ret z
	call AddSpriteGFX
	jr .loop2

RunSpritesCallback:
	ld a, MAPCALLBACK_SPRITES
	call RunMapCallback
	call GetUsedSprites

	ld c, EMOTE_SHADOW
	call LoadEmote
	call GetMapPermission
	call CheckOutdoorMap
	ld c, EMOTE_0B
	jr z, .outdoor
	ld c, EMOTE_BOULDER_DUST
.outdoor
	jp LoadEmote

GetSpriteHeaderFromFar:
	ld a, b
GetSprite:
	call GetMonSprite
	ret c

	ld hl, SpriteHeaders ; address
	dec a
	ld bc, 6
	rst AddNTimes
	; load the address into de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	; load the length into c
	ld a, [hli]
	swap a
	ld c, a
	; load the sprite bank into both b
	ld b, [hl]
	inc hl
	; load the sprite type into l and the default palette into h
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

GetMonSprite:
; Return carry if a monster sprite was loaded.
	cp SPRITE_POKEONLY_PLAYER
	jp z, .WalkingPokemon
	cp SPRITE_POKEMON
	jr c, .Normal
	cp SPRITE_DAYCARE_MON_1
	jr z, .wBreedMon1
	cp SPRITE_DAYCARE_MON_2
	jr z, .wBreedMon2
	cp SPRITE_VARS
	jr nc, .Variable
; icon
	sub SPRITE_POKEMON
	ld e, a
	ld d, 0
	ld hl, SpriteMons
	add hl, de
	ld a, [hl]
	jr .NPCPokemon

.wBreedMon1
	ld a, [wBreedMon1Species]
	jr .Mon

.wBreedMon2
	ld a, [wBreedMon2Species]

.Mon
	and a
	jr z, .NoBreedmon
	jr .NPCPokemon

.Variable
	sub SPRITE_VARS
	ld e, a
	ld d, 0
	ld hl, wVariableSprites
	add hl, de
	ld a, [hl]
	and a
	jp nz, GetMonSprite

.NoBreedmon
	ld a, SPRITE_P0
	lb hl, PAL_OW_PLAYER, WALKING_SPRITE

.Normal
	and a
	ret

.WalkingPokemon
	ld a, [wPokeonlyMainSpecies]
.NPCPokemon
	dec a
	ld e, a
	ld d, 0
	ld hl, PokemonOWSpritePointers
	add hl, de
	add hl, de
	add hl, de
	ld a, BANK(PokemonOWSpritePointers)
	call GetFarByteHalfword
	ld b, a
	ld d, h
	ld e, l
	ld c, 12
	lb hl, PAL_OW_PLAYER, WALKING_SPRITE
	scf
	ret

_DoesSpriteHaveFacings::
; Checks to see whether we can apply a facing to a sprite.
; Returns carry unless the sprite is a Pokemon or a Still Sprite.
	ld a, b
_DoesSpriteHaveFacings_IDInA:
	cp SPRITE_POKEONLY_PLAYER
	jr z, .has_facings
	cp SPRITE_POKEMON
	jr nc, .has_facings

	push hl
	push bc
	ld hl, SpriteHeaders + SPRITEHEADER_TYPE ; type
	dec a
	ld c, a
	ld b, 0
	ld a, NUM_SPRITEHEADER_FIELDS
	rst AddNTimes
	ld a, [hl]
	pop bc
	pop hl
	cp STILL_SPRITE
	jr nz, .has_facings
	scf
	ret

.has_facings
	and a
	ret

LoadAndSortSprites:
	call LoadSpriteGFX
	call SortUsedSprites
	jp ArrangeUsedSprites

AddSpriteGFX:
; Add any new sprite ids to a list of graphics to be loaded.
; Return carry if the list is full.

	push hl
	push bc
	ld b, a
	ld hl, wUsedSprites + 2
	ld c, SPRITE_GFX_LIST_CAPACITY - 1
.loop
	ld a, [hl]
	and a
	jr z, .new
	cp b
	jr nz, .next
	inc hl
	ld a, [hld]
	cp d
	jr z, .exists
.next
	inc hl
	inc hl
	dec c
	jr nz, .loop

	pop bc
	pop hl
	scf
	ret

.new
	ld [hl], b
	inc hl
	ld [hl], d
.exists
	pop bc
	pop hl
	and a
	ret

LoadSpriteGFX:
	ld hl, wUsedSprites
	ld b, SPRITE_GFX_LIST_CAPACITY
.loop
	ld a, [hli]
	and a
	ret z
	push hl
	push bc
	call GetSprite
	ld a, l
	pop bc
	pop hl
	ld [hli], a
	dec b
	jr nz, .loop
	ret

SortUsedSprites:
; Bubble-sort sprites by type.

; Run backwards through wUsedSprites to find the last one.

	ld c, SPRITE_GFX_LIST_CAPACITY
	ld de, wUsedSprites + (SPRITE_GFX_LIST_CAPACITY - 1) * 2
.FindLastSprite
	ld a, [de]
	and a
	jr nz, .FoundLastSprite
	dec de
	dec de
	dec c
	jr nz, .FindLastSprite
.FoundLastSprite
	dec c
	ret z

; If the length of the current sprite is
; higher than a later one, swap them.

	inc de
	ld hl, wUsedSprites + 1

.CheckSprite
	push bc
	push de
	push hl

.CheckFollowing
	ld a, [de]
	cp [hl]
	jr nc, .loop

; Swap the two sprites.

	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	dec de
	dec hl
	ld a, [de]
	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	inc de
	inc hl

; Keep doing this until everything's in order.

.loop
	dec de
	dec de
	dec c
	jr nz, .CheckFollowing

	pop hl
	inc hl
	inc hl
	pop de
	pop bc
	dec c
	jr nz, .CheckSprite

	ret

ArrangeUsedSprites:
; Get the length of each sprite and space them out in VRAM.
; Crystal introduces a second table in VRAM bank 0.

	ld hl, wUsedSprites
	lb bc, 0, SPRITE_GFX_LIST_CAPACITY
.FirstTableLength
; Keep going until the end of the list.
	ld a, [hli]
	and a
	ret z

	ld a, [hl]
	call GetSpriteLength

; Spill over into the second table after $80 tiles.
	add b
	cp $80
	jr z, .loop
	jr nc, .SecondTable

.loop
	ld [hl], b
	inc hl
	ld b, a

; Assumes the next table will be reached before c hits 0.
	dec c
	jr nz, .FirstTableLength

.SecondTable
; The second tile table starts at tile $80.
	ld b, $80
	dec hl
.SecondTableLength
; Keep going until the end of the list.
	ld a, [hli]
	and a
	ret z

	ld a, [hl]
	call GetSpriteLength

; There are only two tables, so don't go any further than that.
	add b
	ret c

	ld [hl], b
	ld b, a
	inc hl

	dec c
	jr nz, .SecondTableLength

	ret

GetSpriteLength:
; Return the length of sprite type a in tiles.
	cp STILL_SPRITE
	ld a, 4
	ret z
	ld a, 12
	ret

GetUsedSprites:
	ld hl, wUsedSprites
	ld c, SPRITE_GFX_LIST_CAPACITY

.loop
	xor a
	ld [wSpriteFlags], a

	ld a, [hli]
	and a
	ret z
	ldh [hUsedSpriteIndex], a

	ld a, [hli]
	ldh [hUsedSpriteTile], a

	rlca
	and 1
	ld [wSpriteFlags], a

	push bc
	push hl
	call GetUsedSprite
	pop hl
	pop bc
	dec c
	jr nz, .loop

	ret

GetUsedSprite::
	ldh a, [hUsedSpriteIndex]
	push hl
	call GetSprite
	push bc
	ld h, d
	ld l, e
	ld a, b
	call FarDecompressWRA6
	pop bc
	pop hl

	ldh a, [hUsedSpriteTile]
	call .GetTileAddr
	push hl
	push bc
	ld de, wDecompressScratch
	call .CopyToVram
	pop bc
	pop hl

	ld a, [wSpriteFlags]
	and a
	ret nz

	ldh a, [hUsedSpriteIndex]
	call _DoesSpriteHaveFacings_IDInA
	ret c

	ld e, c
	swap e
	ld a, e
	and $f
	add HIGH(wDecompressScratch)
	ld d, a
	ld a, e
	and $f0
	ld e, a

	ld a, h
	add HIGH(vFontTiles - vObjTiles)
	ld h, a

.CopyToVram:
	ldh a, [rVBK]
	push af
	ld a, [wSpriteFlags]
	cpl ;only the lowest bit matters
	ldh [rVBK], a
	call Request2bppInWRA6
	pop af
	ldh [rVBK], a
	ret

.GetTileAddr
; Return the address of tile (a) in (hl).
	and $7f
	ld l, a
	ld h, (vObjTiles >> 12)
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ret

LoadEmote::
; Get the address of the pointer to emote c.
	ld a, c
	ld bc, 8
	ld hl, EmotesPointers
	rst AddNTimes
; Load the SFX into RAM
	ld a, [hli]
	and a
	ld [wEmoteSFX], a
	ld a, [hli]
	ld [wEmoteSFX + 1], a
	jr nz, .okay
	ld [wPlayEmoteSFX], a
.okay
; Load the emote address into de
	ld e, [hl]
	inc hl
	ld d, [hl]
; load the length of the emote (in tiles) into c
	inc hl
	ld c, [hl]
	swap c
; load the emote pointer bank into b
	inc hl
	ld b, [hl]
; load the VRAM destination into hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
; if the emote has a length of 0, do not proceed (error handling)
	ld a, c
	and a
	ret z
	jp GetEmote2bpp

MACRO emote_header
	dw \1, \2
	db \3 tiles, BANK(\2)
	dw vFontTiles tile \4
ENDM

EmotesPointers:
; dw source address
; db length, bank
; dw dest address

	emote_header SFX_GLASS_TING, ShockEmote,     4, $78
	emote_header SFX_SQUEAK,     QuestionEmote,  4, $78
	emote_header SFX_SWEET_KISS, HappyEmote,     4, $78
	emote_header SFX_POISON,     SadEmote,       4, $78
	emote_header SFX_UNKNOWN_7F, HeartEmote,     4, $78
	emote_header SFX_THUNDER,    BoltEmote,      4, $78
	emote_header SFX_TAIL_WHIP,  SleepEmote,     4, $78
	emote_header SFX_2_BOOPS,    FishEmote,      4, $78
	emote_header 0,              JumpShadowGFX,  1, $7c
	emote_header 0,              FishingRodGFX2, 2, $7c
	emote_header 0,              BoulderDustGFX, 2, $7e
	emote_header 0,              FishingRodGFX4, 2, $7e

SpriteMons:
	db BAGON
	db CATERPIE
	db METAPOD
	db BUTTERFREE
	db WARTORTLE
	db CHARIZARD
	db XATU
	db SURSKIT
	db TOTODILE
	db GENGAR
	db MACHOKE
	db GROUDON
	db AGGRON
	db FAMBACO
	db ELECTABUZZ
	db RAICHU
	db FLAAFFY
	db BRONZONG
	db HARIYAMA
	db METAGROSS
	db KYOGRE
	db RHYDON
	db MOLTRES
	db TYPHLOSION
	db FEAROW
	db PIDGEOT
	db SWELLOW
	db ARTICUNO
	db PHANCERO
	db HITMONCHAN
	db GLACEON
	db BLASTOISE
	db MAGMORTAR
	db AMPHAROS
	db MILOTIC
	db LIBABEEL
	db RAIWATO
	db ABRA
	db PIKACHU
	db CHARMANDER
	db LARVITAR
	db VARANEOUS
	db RAYQUAZA
	db MEW
	db ZAPDOS

OutdoorSprites:
; Valid sprite IDs for each map group.
	dw IntroSprites ; 1
	dw CaperRidgeSprites ; 2
	dw OxalisCitySprites ; 3
	dw SpurgeCitySprites ; 4
	dw HeathVillageSprites ; 5
	dw LaurelCitySprites ; 6
	dw ToreniaCitySprites ; 7
	dw PhaceliaTownSprites ; 8
	dw SaxifrageIslandSprites ; 9
	dw PhloxTownSprites ; 10
	dw AcaniaDocksSprites ; 11
	dw AcaniaDocksSprites ; 12
	dw HeathVillageSprites ; 13
	dw CaperRidgeSprites ; 14
	dw CaperRidgeSprites ; 15
	dw OxalisCitySprites ; 16
	dw ToreniaCitySprites ; 17
	dw SpurgeCitySprites ; 18
	dw SpurgeCitySprites ; 19
	dw LaurelCitySprites ; 20
	dw Route77Sprites ; 21
	dw PhaceliaTownSprites ; 22
	dw Route85Sprites ; 23
	dw SaxifrageIslandSprites ; 24
	dw Route81Sprites ; 25
	dw AcaniaDocksSprites ; 26
	dw ToreniaCitySprites ; 27
	dw Route84Sprites ; 28
	dw Route85Sprites ; 29
	dw Route86Sprites ; 30
	dw NoOutdoorSprites ; 31 - Acqua Mines
	dw NoOutdoorSprites ; 32 - Mound Cave
	dw NoOutdoorSprites ; 33 - Laurel Forest
	dw NoOutdoorSprites ; 34 - Milos Catacombs
	dw NoOutdoorSprites ; 35 - Municipal Park
	dw NoOutdoorSprites ; 36 - Firelight Caverns
	dw NoOutdoorSprites ; 37 - Naljo Ruins
	dw NoOutdoorSprites ; 38 - Clathrite Tunnel
	dw NoOutdoorSprites ; 39 - Naljo Border
	dw NoOutdoorSprites ; 40 - Champion Isle
	dw NoOutdoorSprites ; 41 - Long Tunnel
	dw SeashoreGravelSprites ; 42
	dw SeashoreGravelSprites ; 43
	dw MersonCitySprites ; 44
	dw HaywardCitySprites ; 45
	dw OwsauriCitySprites ; 46
	dw MoragaTownSprites ; 47
	dw JaeruCitySprites ; 48
	dw BotanCitySprites ; 49
	dw BotanCitySprites ; 50
	dw EagulouLeagueSprites ; 51
	dw RijonLeagueSprites ; 52
	dw OwsauriCitySprites ; 53
	dw OwsauriCitySprites ; 54
	dw OwsauriCitySprites ; 55
	dw HaywardCitySprites ; 56
	dw HaywardCitySprites ; 57
	dw SeashoreGravelSprites ; 58
	dw SeashoreGravelSprites ; 59
	dw MersonCitySprites ; 60
	dw MersonCitySprites ; 61
	dw EagulouLeagueSprites ; 62
	dw BotanCitySprites ; 63
	dw BotanCitySprites ; 64
	dw JaeruCitySprites ; 65
	dw MoragaTownSprites ; 66
	dw EagulouLeagueSprites ; 67
	dw EagulouLeagueSprites ; 68
	dw HaywardCitySprites ; 69
	dw HaywardCitySprites ; 70
	dw RijonLeagueSprites ; 71
	dw OwsauriCitySprites ; 72
	dw EagulouLeagueSprites ; 73
	dw NoOutdoorSprites ; 74 - Merson Cave
	dw NoOutdoorSprites ; 75 - Silk Tunnel
	dw NoOutdoorSprites ; 76 - Castro Forest
	dw NoOutdoorSprites ; 77 - Mt. Boulder
	dw NoOutdoorSprites ; 78 - Rijon Underground
	dw NoOutdoorSprites ; 79 - Seneca Caverns
	dw NoOutdoorSprites ; 80 - Haunted Forest
	dw AzaleaTownSprites ; 81
	dw NoOutdoorSprites ; 82 - Ilex Forest
	dw GoldenrodSprites ; 83
	dw GoldenrodSprites ; 84
	dw SaffronSprites ; 85
	dw TunodExtrasSprites ; 86
	dw MtEmberSprites ; 87
	dw MtEmberSprites ; 88
	dw SoutherlySprites ; 89
	dw SoutherlySprites ; 90
	dw SoutherlySprites ; 91
	dw CaperRidgeSprites ; 92
	dw CaperRidgeSprites ; 93
	dw CaperRidgeSprites ; 94
	dw SeviiIslandSprites ; 95

IntroSprites:
; IntroOutside
	db SPRITE_MOM
	db SPRITE_FIRE
	db 0 ; end

CaperRidgeSprites:
; CaperRidge
; Route70
; Route71West
; Route71East
; MysteryZone
	db SPRITE_YOUNGSTER
	db SPRITE_BUG_CATCHER
	db SPRITE_TEACHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_FISHER
	db SPRITE_HIKER
	db SPRITE_JUGGLER
	db SPRITE_FIREBREATHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL
	db 0 ; end

OxalisCitySprites:
; OxalisCity
; Route72
	db SPRITE_COOLTRAINER_F
	db SPRITE_PICNICKER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL
	db 0 ; end

SpurgeCitySprites:
; SpurgeCity
; Route74
; Route75
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_M
	db SPRITE_POKEFAN_F
	db SPRITE_PSYCHIC
	db SPRITE_SCHOOLBOY
	db SPRITE_LASS
	db SPRITE_BEAUTY
	db SPRITE_BIRDKEEPER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

HeathVillageSprites:
; HeathVillage
; Route69
; Route69North
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_POKE_BALL
	db SPRITE_HIKER
	db SPRITE_COOLTRAINER_M
	db SPRITE_SAILOR
	db 0 ; end

LaurelCitySprites:
; LaurelCity
; Route76
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_GRAMPS
	db SPRITE_FISHER
	db SPRITE_TWIN
	db SPRITE_PSYCHIC
	db SPRITE_FIREBREATHER
	db SPRITE_POKE_BALL
	db SPRITE_TOTODILE
	db 0 ; end

ToreniaCitySprites:
; ToreniaCity
; Route73
; Route83
	db SPRITE_PICNICKER
	db SPRITE_BIRDKEEPER
	db SPRITE_BUG_CATCHER
	db SPRITE_JUGGLER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_GRAMPS
	db SPRITE_SCHOOLBOY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

PhaceliaTownSprites:
; PhaceliaCity
; Route78
	db SPRITE_LASS
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_BLACK_BELT
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_BOULDER
	db SPRITE_FRUIT_TREE
	db SPRITE_MACHOKE
	db 0 ; end

SaxifrageIslandSprites:
; SaxifrageIsland
; Route80
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_OFFICER
	db SPRITE_HIKER
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER
	db 0 ; end

PhloxTownSprites:
; PhloxTown
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_POKEFAN_F
	db SPRITE_SURFING_PIKACHU
	db SPRITE_FISHING_GURU
	db SPRITE_OFFICER
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_SLOWPOKE
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_FRUIT_TREE
	db SPRITE_PAPER
	db 0 ; end

AcaniaDocksSprites:
; AcaniaDocks
; Route68
; Route82
	db SPRITE_COOLTRAINER_F
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

Route77Sprites:
; Route77
; Route77DaycareGarden
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_PICNICKER
	db SPRITE_OFFICER
	db SPRITE_DAYCARE_MON_1
	db SPRITE_DAYCARE_MON_2
	db SPRITE_EGG
	db SPRITE_BOULDER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

Route81Sprites:
; Route81
	db SPRITE_SUPER_NERD
	db SPRITE_BLACK_BELT
	db SPRITE_BIRDKEEPER
	db SPRITE_PICNICKER
	db SPRITE_GUITARISTF
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

Route84Sprites:
; Route84
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUENA
	db SPRITE_HIKER
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER
	db SPRITE_FRUIT_TREE
	db 0 ; end

Route85Sprites:
; Route79
; Route85
	db SPRITE_BIRDKEEPER
	db SPRITE_OFFICER
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_PSYCHIC
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_PICNICKER
	db SPRITE_ROCK
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

Route86Sprites:
; Route86
; Route86Dock
; FarawayIslandOutside
; FarawayIslandInside
	db SPRITE_SAILOR
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_F
	db SPRITE_MEW
	db 0 ; end

SeashoreGravelSprites:
; SeashoreCity
; GravelTown
; Route52
; Route53
	db SPRITE_JEN
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_SUPER_NERD
	db SPRITE_FISHING_GURU
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_FRUIT_TREE
	db 0 ; end

MersonCitySprites:
; MersonCity
; Route54
; Route55
; SouthRijonGate
	db SPRITE_COOLTRAINER_F
	db SPRITE_COOLTRAINER_M
	db SPRITE_LASS
	db SPRITE_FISHER
	db SPRITE_FISHING_GURU
	db SPRITE_SAGE
	db SPRITE_GENTLEMAN
	db SPRITE_BLACK_BELT
	db SPRITE_FRUIT_TREE
	db 0 ; end

HaywardCitySprites:
; HaywardCity
; Route50
; Route51
; Route63
; Route64
	db SPRITE_BUG_CATCHER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_FISHER
	db SPRITE_GYM_GUY
	db SPRITE_BURGLAR
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db SPRITE_FRUIT_TREE
	db 0 ; end

OwsauriCitySprites:
; OwsauriCity
; Route47
; Route48
; Route49
; Route66
	db SPRITE_LASS
	db SPRITE_SUPER_NERD
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_KIMONO_GIRL
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

MoragaTownSprites:
; MoragaTown
; Route60
	db SPRITE_COOLTRAINER_M
	db SPRITE_TEACHER
	db SPRITE_POKEFAN_F
	db SPRITE_SAGE
	db SPRITE_POKE_BALL
	db 0 ; end

JaeruCitySprites:
; JaeruCity
; Route59
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_FISHER
	db SPRITE_SAGE
	db SPRITE_BURGLAR
	db SPRITE_FIREBREATHER
	db SPRITE_JUGGLER
	db SPRITE_POKE_BALL
	db 0 ; end

BotanCitySprites:
; BotanCity
; CastroValley
; CastroDock
; Route57
; Route58
	db SPRITE_YOUNGSTER
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_F
	db SPRITE_FISHER
	db SPRITE_FISHING_GURU
	db SPRITE_SAGE
	db SPRITE_SAILOR
	db 0 ; end

EagulouLeagueSprites:
; EagulouCity
; EagulouPark1
; EagulouPark2
; EagulouPark3
; Route56
; Route61
; Route62
; Route67
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_SAGE
	db SPRITE_BLACK_BELT
	db SPRITE_GENTLEMAN
	db SPRITE_OFFICER
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

RijonLeagueSprites:
; RijonLeagueOutside
; RijonLeagueParty
; Route65
	db SPRITE_LANCE
	db SPRITE_MOM
	db SPRITE_FIRE
	db SPRITE_SILVER
	db SPRITE_JUGGLER
	db SPRITE_POKEMANIAC
	db 0 ; end

AzaleaTownSprites:
; AzaleaTown
; AzaleaKurtBasement
	db SPRITE_YOUNGSTER
	db SPRITE_TEACHER
	db SPRITE_GRAMPS
	db SPRITE_FRUIT_TREE
	db 0 ; end

GoldenrodSprites:
; Route34
; GoldenrodCity
; GoldenrodCape
	db SPRITE_COOLTRAINER_F
	db SPRITE_BIRDKEEPER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_OFFICER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_POKE_BALL
	db SPRITE_ROCK
	db 0 ; end

SaffronSprites:
; SaffronCity
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_POKEFAN_M
	db SPRITE_FISHER
	db SPRITE_POKE_BALL
	db 0 ; end

TunodExtrasSprites:
; EspoForest
; OlcanIsle
	db SPRITE_PSYCHIC
	db SPRITE_GRANNY
	db SPRITE_SAGE
	db SPRITE_SUPER_NERD
	db SPRITE_MINER
	db SPRITE_POKEMANIAC
	db SPRITE_HIKER
	db SPRITE_BLACK_BELT
	db SPRITE_SWIMMER_GIRL
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db 0 ; end

MtEmberSprites:
; EmberBrook
	db SPRITE_POKE_BALL
	db SPRITE_MOLTRES
	db SPRITE_PICNICKER
	db SPRITE_SWIMMER_GIRL
	db SPRITE_MINER
	db SPRITE_OFFICER
	db SPRITE_SAGE
	db SPRITE_BIRDKEEPER
	db SPRITE_CHEERLEADER
	db SPRITE_TWIN
	db SPRITE_BURGLAR
	db 0 ; end

SoutherlySprites:
; Route87
; TunodWaterway
; SouthSoutherly
; SoutherlyCity
; EspoClearing
; OlcanChine
	db SPRITE_COOLTRAINER_F
	db SPRITE_LASS
	db SPRITE_SWIMMER_GUY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_FISHER
	db SPRITE_BLACK_BELT
	db SPRITE_OFFICER
	db SPRITE_PICNICKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_TYPHLOSION
	db 0 ; end

SeviiIslandSprites:
; SeviiIsland1
; SeviiIsland2
; SeviiIsland3
	db 0 ; end

NoOutdoorSprites:
; N/A
	db 0 ; end

INCLUDE "data/sprite_headers.asm"
