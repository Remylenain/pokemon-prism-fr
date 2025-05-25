	db EXEGGUTOR
	db 95, 95, 85, 55, 125, 75
	db GRASS, PSYCHIC
	db 45 ;catch rate
	db 212 ;exp rate
	db NO_ITEM
	db ORAN_BERRY
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/exeggutor/dimensions.asm"
	db ABILITY_CHLOROPHYLL, ABILITY_CHLOROPHYLL ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn PLANT, PLANT ;egg groups

