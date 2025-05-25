SageGroup:
	; 1
	db "Genjo@"

	db TRAINERTYPE_NORMAL

	db 21, GASTLY
	db 21, SHUPPET
	db 22, HAUNTER
	db -1

	; 2
	db "Minoru@"

	db TRAINERTYPE_NORMAL

	db 22, DUSKULL
	db 22, SHUPPET
	db 23, HAUNTER
	db -1

	; 3
	db "Daikoku@"

	db TRAINERTYPE_NORMAL

	db 26, SABLEYE
	db -1

	; 4
	db "Osamu@"

	db TRAINERTYPE_NORMAL

	db 60, WEEPINBELL
	db 60, VICTREEBEL
	db -1

	; 5
	db "Taro@"

	db TRAINERTYPE_NORMAL

	db 60, HAUNTER
	db 60, GENGAR
	db 61, MISDREAVUS
	db -1

	; 6
	db "Gorou@"

	db TRAINERTYPE_NORMAL

	db 60, VICTREEBEL
	db 60, JOLTEON
	db 61, BUTTERFREE
	db -1

	; 7
	db "Tenzin@"

	db TRAINERTYPE_NORMAL

	db 77, DRIFBLIM
	db 78, SPIRITOMB
	db 78, DUSCLOPS
	db -1

	; 8
	db "Koiking@"

	db TRAINERTYPE_ITEM | TRAINERTYPE_MOVES

	db 80, BRONZONG, DAMP_ROCK
		db RAIN_DANCE
		db EXPLOSION
		db 0
		db 0

	db 100, MAGIKARP, SHINY_RING
		db HYDRO_PUMP
		db 0
		db 0
		db 0

	db 100, MAGIKARP, SAFE_GOGGLES
		db REVERSAL
		db FLAIL
		db VAPORIZE
		db 0

	db 100, MAGIKARP, FOCUS_BAND
		db REVERSAL
		db 0
		db 0
		db 0

	db 100, MAGIKARP, MYSTIC_WATER
		db HYDRO_PUMP
		db 0
		db 0
		db 0

	db 80, FORRETRESS, DAMP_ROCK
		db RAIN_DANCE
		db EXPLOSION
		db 0
		db 0

	db -1

	; 9
	db "Isaiah@"

	db TRAINERTYPE_NORMAL

	db 85, BELLSPROUT
	db 83, WEEPINBELL
	db 81, VICTREEBEL
	db -1
