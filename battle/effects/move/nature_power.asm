BattleCommand_NaturePower:
	call ButtonSound
	ld a, [wTileset]
	dec a
	ld e, a
	ld d, 0
	ld hl, NaturePowerMoves
	add hl, de
	ld a, [hl]
	and a
	jr nz, .okay

.Tileset2Moves
	ld a, [wMapGroup]
	cp GROUP_ROUTE_70
	jr z, .snowroute
	cp GROUP_ROUTE_84
	jr z, .snowroute
	cp GROUP_ROUTE_85
	jr z, .fireroute
; any other route
	ld a, ENERGY_BALL
	jr .okay

.snowroute
	ld a, ICE_BEAM
	jr .okay

.fireroute
	ld a, FLAMETHROWER

.okay
	ld [wd265], a
	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld a, [wd265]
	ld [hl], a
	callba UpdateMoveData
	ld hl, NaturePowerText
	jp StdBattleTextBox

NaturePowerMoves::
	db ENERGY_BALL ; Naljo 1
	db $00         ; Naljo 2, variable (see above)
	db ENERGY_BALL ; Rijon
	db TRI_ATTACK  ; House 1
	db TRI_ATTACK  ; House 2
	db TRI_ATTACK  ; Pokecenter
	db TRI_ATTACK  ; Johto Gate
	db HYDRO_PUMP  ; Port
	db TRI_ATTACK  ; Lab
	db THUNDERBOLT ; Power Plant
	db TRI_ATTACK  ; Mart
	db TRI_ATTACK  ; Mansion
	db TRI_ATTACK  ; Game Corner
	db TRI_ATTACK  ; Gym
	db TRI_ATTACK  ; Kurt House
	db TRI_ATTACK  ; Train Station
	db DARK_PULSE  ; Lighthouse (Phlox Labs)
	db SIGNAL_BEAM ; Naljo Ruins (Acania Gym & Lighthouse)
	db ANCIENTPOWER; House 3 (Naljo Ruins)
	db DARK_PULSE  ; Tower (Torenia Gym)
	db POWER_GEM   ; Cave
	db ENERGY_BALL ; Park
	db DARK_PULSE  ; Prison Rooms
	db TRI_ATTACK  ; Tileset 18
	db TRI_ATTACK  ; Underground
	db ICE_BEAM    ; Ice Path
	db POWER_GEM   ; Kanto Cave
	db ENERGY_BALL ; Forest
	db TRI_ATTACK  ; Kanto Gate
	db TRI_ATTACK  ; Trainer House
	db TRI_ATTACK  ; Tileset 1F
	db EARTH_POWER ; Sidescroll
	db FLAMETHROWER; Firelight Caverns
	db ENERGY_BALL ; Johto
	db ENERGY_BALL ; Kanto
	db TRI_ATTACK  ; Pachisi Board
	db SHADOW_BALL ; Haunted Forest
	db SHADOW_BALL ; Haunted Mansion
	db SHADOW_BALL ; Psychedelic / Dream Sequence
	db THUNDERBOLT ; Cadence Gym
	db TRI_ATTACK  ; Brooklyn Gym, several Elite Four rooms
	db HYDRO_PUMP  ; Magikarp Caverns
	db DARK_PULSE  ; Prison Main (Eagulou Gym, Mansion Basement)
	db ENERGY_BALL ; Ilex Forest
	db ENERGY_BALL ; Tunod
	db TRI_ATTACK  ; Gate
	db TRI_ATTACK  ; Champion Room
	db TRI_ATTACK  ; Cave 2 (Phlox)
	db POWER_GEM   ; Cave 3 (Charizard Den, Spurge Gym, Magikarp Caverns)
	db TRI_ATTACK  ; Cave 4 (Daichi and Intro Cave)
	db POWER_GEM   ; Cave 5 (Unused)
	db POWER_GEM   ; Cave 6 (Phacelia Gym, upper Clathrite, upper Milos)
	db POWER_GEM   ; Cave 7	(Various)
