	db EXEGGCUTE
	db 60, 40, 80, 40, 60, 45
	db GRASS, PSYCHIC
	db 90 ;catch rate
	db 98 ;exp rate
	db NO_ITEM
	db ORAN_BERRY
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/exeggcute/dimensions.asm"
	db ABILITY_CHLOROPHYLL, ABILITY_CHLOROPHYLL ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn PLANT, PLANT ;egg groups

