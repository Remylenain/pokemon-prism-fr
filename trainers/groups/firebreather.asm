FirebreatherGroup:
	; 1
	db "David@"

	db TRAINERTYPE_NORMAL

	db 55, NINETALES
	db 54, MAGCARGO
	db -1

	; 2
	db "Frank@"

	db TRAINERTYPE_NORMAL

	db 32, MAGMAR
	db 33, MAGMAR
	db 34, FLAREON
	db -1

	; 3
	db "Earl@"

	db TRAINERTYPE_NORMAL

	db 33, HOUNDOUR
	db 34, VULPIX
	db 36, HOUNDOOM
	db -1

	; 4
	db "Garth@"

	db TRAINERTYPE_NORMAL

	db 61, CAMERUPT
	db 62, ARCANINE
	db 63, NINETALES
	db -1

	; 5
	db "Barry@"

	db TRAINERTYPE_NORMAL

	db 80, NINETALES
	db 81, CAMERUPT
	db 83, HOUNDOOM
	db -1

	; 6
	db "Henri@" ; Henrique in Glazed, doesn't fit!

	db TRAINERTYPE_NORMAL

	db 82, CHARIZARD
	db 82, TYPHLOSION
	db -1

	; 7
	db "Trey@"

	db TRAINERTYPE_NORMAL

	db 41, RAPIDASH
	db 41, ARCANINE
	db 41, MAGCARGO
	db -1

	; 8
	db "Vic@"

	db TRAINERTYPE_NORMAL

	db 41, WEEZING
	db 41, MAGMAR
	db 41, NINETALES
	db -1

	; 9
	db "Lex@"

	db TRAINERTYPE_NORMAL

	db 53, NINETALES
	db 53, CAMERUPT
	db 54, TYPHLOSION
	db -1

	; 10
	db "Ben@"

	db TRAINERTYPE_MOVES

	db 80, WAILORD
		db FREEZE_BURN
		db NOISE_PULSE
		db RAIN_DANCE
		db HYDRO_PUMP

	db 80, FROSLASS
		db ICE_BEAM
		db BLIZZARD
		db PSYCHIC_M
		db DESTINY_BOND

	db 80, WIGGLYTUFF
		db FLAMETHROWER
		db SING
		db HYPER_VOICE
		db SUNNY_DAY

	db 80, LUDICOLO
		db HYDRO_PUMP
		db FREEZE_BURN
		db RAIN_DANCE
		db RAZOR_LEAF

	db 80, CHARIZARD
		db FIRE_BLAST
		db SWORDS_DANCE
		db SUNNY_DAY
		db DRAGON_CLAW

	db -1
