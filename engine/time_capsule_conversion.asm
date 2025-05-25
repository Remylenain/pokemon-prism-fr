ValidateOTTrademon:
	ld a, [wd003]
	ld hl, wOTPartyMon1Species
	call GetPartyLocation
	push hl
	ld a, [wd003]
	inc a
	ld c, a
	ld b, 0
	ld hl, wOTPartyCount
	add hl, bc
	ld a, [hl]
	pop hl
	cp NO_POKEMON
	jr z, .abnormal

.matching_or_egg
	ld b, h
	ld c, l
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	cp MAX_LEVEL + 1
	jr nc, .abnormal
	ld hl, wOTPartySpecies
	ld a, [wd003]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	and a
	jr z, .abnormal

	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wLinkOTPartyMonTypes
	add hl, bc
	add hl, bc
	ld a, [hli]
	cp BIRD
	jr z, .abnormal
	ld a, [hl]
	cp BIRD
	jr z, .abnormal
.normal
	and a
	ret

.abnormal
	xor a
	ld [wTempNumber], a
	scf
	ret

CheckIfTradedMonIsOnlyAliveMon:
	ld a, [wd002]
	ld d, a
	ld a, [wPartyCount]
	ld b, a
	ld c, 0
.loop
	ld a, c
	cp d
	jr z, .next
	push bc
	ld a, c
	ld hl, wPartyMon1HP
	call GetPartyLocation
	pop bc
	ld a, [hli]
	or [hl]
	jr nz, .done

.next
	inc c
	dec b
	jr nz, .loop
	ld a, [wd003]
	ld hl, wOTPartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	jr nz, .done
	scf
	ret

.done
	and a
	ret

PlaceTradePartnerNamesAndParty:
	hlcoord 4, 0
	ld de, wPlayerName
	call PlaceString
	ld a, $14
	ld [bc], a
	hlcoord 4, 8
	ld de, wOTPlayerName
	call PlaceString
	ld a, $14
	ld [bc], a
	hlcoord 7, 1
	ld de, wPartySpecies
	call .PlaceSpeciesNames
	hlcoord 7, 9
	ld de, wOTPartySpecies
.PlaceSpeciesNames
	ld c, 0
.loop
	ld a, [de]
	cp -1
	ret z
	ld [wd265], a
	push bc
	push hl
	push de
	push hl
	ld a, c
	ldh [hProduct], a
	call GetPokemonName
	pop hl
	call PlaceString
	pop de
	inc de
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	inc c
	jr .loop

KantoMonSpecials:
; The original special base stat for
; each Kanto monster from Red/Blue.
	db  65 ; BULBASAUR
	db  80 ; IVYSAUR
	db 100 ; VENUSAUR
	db  50 ; CHARMANDER
	db  65 ; CHARMELEON
	db  85 ; CHARIZARD
	db  50 ; SQUIRTLE
	db  65 ; WARTORTLE
	db  85 ; BLASTOISE
	db  20 ; CATERPIE
	db  25 ; METAPOD
	db  80 ; BUTTERFREE
	db  20 ; BULBASAUR
	db  25 ; KAKUNA
	db  45 ; BEEDRILL
	db  35 ; PIDGEY
	db  50 ; PIDGEOTTO
	db  70 ; PIDGEOT
	db  25 ; RATTATA
	db  50 ; RATICATE
	db  31 ; SPEAROW
	db  61 ; FEAROW
	db  40 ; EKANS
	db  65 ; ARBOK
	db  50 ; PIKACHU
	db  90 ; RAICHU
	db  30 ; SANDSHREW
	db  55 ; SANDSLASH
	db  40 ; NIDORAN_F
	db  55 ; NIDORINA
	db  75 ; NIDOQUEEN
	db  40 ; NIDORAN_M
	db  55 ; NIDORINO
	db  75 ; NIDOKING
	db  60 ; CLEFAIRY
	db  85 ; CLEFABLE
	db  65 ; VULPIX
	db 100 ; NINETALES
	db  25 ; JIGGLYPUFF
	db  50 ; WIGGLYTUFF
	db  40 ; ZUBAT
	db  75 ; GOLBAT
	db  75 ; ODDISH
	db  85 ; GLOOM
	db 100 ; VILEPLUME
	db  55 ; PARAS
	db  80 ; PARASECT
	db  40 ; VENONAT
	db  90 ; VENOMOTH
	db  45 ; DIGLETT
	db  70 ; DUGTRIO
	db  40 ; MEOWTH
	db  65 ; PERSIAN
	db  50 ; PSYDUCK
	db  80 ; GOLDUCK
	db  35 ; MANKEY
	db  60 ; PRIMEAPE
	db  50 ; GROWLITHE
	db  80 ; ARCANINE
	db  40 ; POLIWAG
	db  50 ; POLIWHIRL
	db  70 ; POLIWRATH
	db 105 ; ABRA
	db 120 ; KADABRA
	db 135 ; ALAKAZAM
	db  35 ; MACHOP
	db  50 ; MACHOKE
	db  65 ; MACHAMP
	db  70 ; BELLSPROUT
	db  85 ; WEEPINBELL
	db 100 ; VICTREEBEL
	db 100 ; TENTACOOL
	db 120 ; TENTACRUEL
	db  30 ; GEODUDE
	db  45 ; GRAVELER
	db  55 ; GOLEM
	db  65 ; PONYTA
	db  80 ; RAPIDASH
	db  40 ; SLOWPOKE
	db  80 ; SLOWBRO
	db  95 ; MAGNEMITE
	db 120 ; MAGNETON
	db  58 ; FARFETCH_D
	db  35 ; DODUO
	db  60 ; DODRIO
	db  70 ; SEEL
	db  95 ; DEWGONG
	db  40 ; GRIMER
	db  65 ; MUK
	db  45 ; SHELLDER
	db  85 ; CLOYSTER
	db 100 ; GASTLY
	db 115 ; HAUNTER
	db 130 ; GENGAR
	db  30 ; ONIX
	db  90 ; DROWZEE
	db 115 ; HYPNO
	db  25 ; KRABBY
	db  50 ; KINGLER
	db  55 ; VOLTORB
	db  80 ; ELECTRODE
	db  60 ; EXEGGCUTE
	db 125 ; EXEGGUTOR
	db  40 ; CUBONE
	db  50 ; MAROWAK
	db  35 ; HITMONLEE
	db  35 ; HITMONCHAN
	db  60 ; LICKITUNG
	db  60 ; KOFFING
	db  85 ; WEEZING
	db  30 ; RHYHORN
	db  45 ; RHYDON
	db 105 ; CHANSEY
	db 100 ; TANGELA
	db  40 ; KANGASKHAN
	db  70 ; HORSEA
	db  95 ; SEADRA
	db  50 ; GOLDEEN
	db  80 ; SEAKING
	db  70 ; STARYU
	db 100 ; STARMIE
	db 100 ; MR__MIME
	db  55 ; SCYTHER
	db  95 ; JYNX
	db  85 ; ELECTABUZZ
	db  85 ; MAGMAR
	db  55 ; PINSIR
	db  70 ; TAUROS
	db  20 ; MAGIKARP
	db 100 ; GYARADOS
	db  95 ; LAPRAS
	db  48 ; DITTO
	db  65 ; EEVEE
	db 110 ; VAPOREON
	db 110 ; JOLTEON
	db 110 ; FLAREON
	db  75 ; PORYGON
	db  90 ; OMANYTE
	db 115 ; OMASTAR
	db  45 ; KABUTO
	db  70 ; KABUTOPS
	db  60 ; AERODACTYL
	db  65 ; SNORLAX
	db 125 ; ARTICUNO
	db 125 ; ZAPDOS
	db 125 ; MOLTRES
	db  50 ; DRATINI
	db  70 ; DRAGONAIR
	db 100 ; DRAGONITE
	db 154 ; MEWTWO
	db 100 ; MEW
	;Brown mons
	db 57
	db 71
	db 91
	db 55
	db 72
	db 97
	db 46
	db 61
	db 81
	db 65
	db 115
	db 67
	db 60
	db 86
	db 40
	db 60
	db 56
	db 76
	db 30
	db 60
	db 65
	db 57
	db 82
	db 55
	db 70
	db 102
	db 35
	db 70
	db 63
	db 78
	db 47
	db 67
	db 97
	db 40
	db 60
	db 25
	db 65
	db 52
	db 92
	db 117
	db 50
	db 77
	db 55
	db 65
	db 35
	db 72
	db 85
	db 105
	db 112
	db 95
	db 98
	db 112
	db 110
	db 90
	db 110
	db 100
	db 105
	db 80
	db 67
	db 60
	db 105
	db 95
	db 55
	db 105
	db 75
	db 95
	db 107
	db 82
	db 102
	db 122
	db 132
	db 30
	db 57
	db 120

PlaySlowCry:
	ldh a, [hScriptVar]
	ld e, 0
	call LoadCryHeader
	ret c

	ld hl, wCryPitch
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -$140
	add hl, bc
	ld a, l
	ld [wCryPitch], a
	ld a, h
	ld [wCryPitch + 1], a
	ld hl, wCryLength
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $60
	add hl, bc
	ld a, l
	ld [wCryLength], a
	ld a, h
	ld [wCryLength + 1], a
	callba _PlayCryHeader
	jp WaitSFX

NewPokedexEntry:
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a
	call LowVolume
	call ClearBGPalettes
	call ClearTileMap
	call UpdateSprites
	call ClearSprites
	ld a, [wPokedexStatus]
	push af
	ldh a, [hSCX]
	add 5
	ldh [hSCX], a
	xor a
	ld [wPokedexStatus], a
	callba _NewPokedexEntry
	call WaitPressAorB_BlinkCursor
	ld a, 1
	ld [wPokedexStatus], a
	callba DisplayDexEntry
	call WaitPressAorB_BlinkCursor
	pop af
	ld [wPokedexStatus], a
	call MaxVolume
	ld c, 1
	call FadeToLightestColor
	ldh a, [hSCX]
	sub 5 ; 251 ; NUM_POKEMON
	ldh [hSCX], a
	call .ReturnFromDexRegistration
	pop af
	ldh [hMapAnims], a
	ret

.ReturnFromDexRegistration
	call ClearTileMap
	call LoadStandardFont
	callba Pokedex_PlaceFrontpicTopLeftCorner
	call ApplyAttrAndTilemapInVBlank
	callba GetEnemyMonDVs
	ld a, [hli]
	ld [wTempMonDVs], a
	ld a, [hl]
	ld [wTempMonDVs + 1], a
	ld b, SCGB_FRONTPICPALS
	predef GetSGBLayout
	jp SetPalettes

ConvertMon_2to1:
; Takes the Gen-2 Pokemon number stored in wd265, finds it in the Pokered_MonIndices table, and returns its index in wd265.
	push bc
	push hl
	ld a, [wd265]
	ld b, a
	ld c, 0
	ld hl, Pokered_MonIndices
.loop
	inc c
	ld a, [hli]
	cp b
	jr nz, .loop
	ld a, c
	ld [wd265], a
	pop hl
	pop bc
	ret

ConvertMon_1to2:
; Takes the Gen-1 Pokemon number stored in wd265 and returns the corresponding value from Pokered_MonIndices in wd265.
	push bc
	push hl
	ld a, [wd265]
	dec a
	ld hl, Pokered_MonIndices
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	pop hl
	pop bc
	ret

Pokered_MonIndices: ; Make compatible with Brown + Prism
	db RHYDON
	db KANGASKHAN
	db 0
	db 0
	db SPEAROW
	db 0
	db 0
	db SLOWBRO    ;$08
	db IVYSAUR
	db EXEGGUTOR
	db 0
	db EXEGGCUTE
	db 0
	db GENGAR
	db 0
	db 0          ;$10
	db 0
	db RHYHORN
	db 0
	db ARCANINE
	db MEW
	db GYARADOS
	db 0
	db TENTACOOL  ;$18
	db GASTLY
	db SCYTHER
	db 0
	db BLASTOISE
	db 0
	db TANGELA
	db CHIKORITA
	db BAYLEEF    ;$20
	db GROWLITHE
	db ONIX
	db FEAROW
	db PIDGEY
	db SLOWPOKE
	db KADABRA
	db GRAVELER
	db CHANSEY    ;$28
	db MACHOKE
	db 0
	db HITMONLEE
	db HITMONCHAN
	db 0
	db PARASECT
	db 0
	db 0          ;$30
	db GOLEM
	db CRANIDOS
	db MAGMAR
	db PUPITAR
	db ELECTABUZZ
	db MAGNETON
	db KOFFING
	db CYNDAQUIL  ;$38
	db 0
	db 0
	db 0
	db 0
	db QUILAVA
	db TYPHLOSION
	db TOTODILE
	db 0          ;$40
	db VENONAT
	db 0
	db CROCONAW
	db FERALIGATR
	db HOUNDOUR
	db 0
	db 0
	db 0          ;$48
	db MOLTRES
	db ARTICUNO
	db ZAPDOS
	db DITTO
	db 0
	db 0
	db HOUNDOOM
	db 0          ;$50
	db YANMA
	db VULPIX
	db NINETALES
	db PIKACHU
	db RAICHU
	db RAMPARDOS
	db SNEASEL
	db 0          ;$58
	db 0
	db 0
	db 0
	db 0
	db 0
	db SPINARAK
	db ARIADOS
	db 0          ;$60
	db 0
	db 0
	db 0
	db JIGGLYPUFF
	db WIGGLYTUFF
	db EEVEE
	db FLAREON
	db JOLTEON    ;$68
	db VAPOREON
	db MACHOP
	db ZUBAT
	db 0
	db PARAS
	db 0
	db 0
	db 0          ;$70
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db VENOMOTH
	db 0          ;$78
	db CHINCHOU
	db LANTURN
	db CATERPIE
	db METAPOD
	db BUTTERFREE
	db MACHAMP
	db SWINUB
	db 0          ;$80
	db 0
	db GOLBAT
	db MEWTWO
	db SNORLAX
	db MAGIKARP
	db PILOSWINE
	db TYROGUE
	db 0          ;$88
	db 0
	db 0
	db 0
	db TYROGUE
	db 0
	db 0
	db WEEZING
	db 0          ;$90
	db 0
	db TYROGUE
	db HAUNTER
	db ABRA
	db ALAKAZAM
	db PIDGEOTTO
	db PIDGEOT
	db 0          ;$98
	db BULBASAUR
	db VENUSAUR
	db TENTACRUEL
	db NATU
	db GOLDEEN
	db SEAKING
	db XATU
	db MAREEP     ;$A0
	db FLAAFFY
	db 0
	db PONYTA
	db RAPIDASH
	db 0
	db 0
	db 0
	db 0          ;$A8
	db GEODUDE
	db PORYGON
	db 0
	db GLIGAR
	db MAGNEMITE
	db MARILL
	db AZUMARILL
	db CHARMANDER ;$B0
	db SQUIRTLE
	db CHARMELEON
	db WARTORTLE
	db CHARIZARD
	db 0
	db 0
	db MISDREAVUS
	db LARVITAR   ;$B8
	db 0
	db 0
	db 0
	db BELLSPROUT
	db WEEPINBELL
	db VICTREEBEL
	db PHANPY
	db DONPHAN    ;$C0
	db TOGEPI
	db TOGETIC
	db 0
	db 0
	db ESPEON
	db UMBREON
	db EEVEE
	db EEVEE      ;$C8
	db EEVEE
	db TYRANITAR
	db CROBAT
	db AMPHAROS
	db LUGIA
	db HO_OH
	db MAGNEZONE
	db 0          ;$D0
	db RHYPERIOR
	db BLISSEY
	db TANGROWTH
	db 0
	db PORYGON2
	db PORYGONZ
	db 0 ;Honchkrow - not in Prism!
	db MISMAGIUS  ;$D8
	db LEAFEON
	db GLACEON
	db ELECTIVIRE
	db MAGMORTAR
	db MAMOSWINE
	db YANMEGA
	db HITMONTOP
	db SLOWKING   ;$E0
	db TOGEKISS
	db STEELIX
	db GLISCOR
	db SCIZOR
	db WEAVILE
	db MEGANIUM
	db SYLVEON
	db 0          ;$E8
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0          ;$F0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0          ;$F8
	db 0
	db 0
	db 0
	db 0
