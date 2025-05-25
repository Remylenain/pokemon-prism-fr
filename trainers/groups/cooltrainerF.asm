CooltrainerFGroup:
	; 1
	db "Carla@"

	db TRAINERTYPE_NORMAL

	db 14, MARILL
	db 15, CHINCHOU
	db 15, MARILL
	db -1

	; 2
	db "Maud@"

	db TRAINERTYPE_NORMAL

	db 33, LAIRON
	db 33, PONYTA
	db 35, NINETALES
	db -1

	; 3
	db "Jenny@"

	db TRAINERTYPE_MOVES

	db 37, LAIRON
		db METAL_CLAW
		db TAKE_DOWN
		db SANDSTORM
		db DIG

	db 38, ABSOL
		db BITE
		db SLASH
		db SANDSTORM
		db SWORDS_DANCE

	db 38, MAGCARGO
		db HARDEN
		db FLAMETHROWER
		db LAVA_POOL
		db BURNING_MIST

	db -1

	; 4
	db "Lucy@"

	db TRAINERTYPE_MOVES

	db 80, AGGRON
		db METAL_CLAW
		db SHADOW_CLAW
		db DRAGON_CLAW
		db DYNAMICPUNCH

	db 81, ABSOL
		db BITE
		db SLASH
		db SANDSTORM
		db SWORDS_DANCE

	db 80, MAGCARGO
		db HARDEN
		db FLAMETHROWER
		db LAVA_POOL
		db BURNING_MIST

	db -1

	; 5
	db "Gina@"

	db TRAINERTYPE_NORMAL

	db 74, BRELOOM
	db 74, BRELOOM
	db 78, VENUSAUR
	db -1

	; 6 - Esper in Glazed
	db "Haley@"

	db TRAINERTYPE_NORMAL

	db 79, KADABRA
	db 81, ALAKAZAM
	db -1
