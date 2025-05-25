	db LOMBRE
	db 60, 50, 50, 50, 60, 70
	db WATER, GRASS
	db 120 ;catch rate
	db 141 ;exp rate
	db NO_ITEM
	db LEAF_STONE
	db 127 ;gender
	db 100 ;unknown
	db 16 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/lombre/dimensions.asm"
	db ABILITY_SWIFT_SWIM, ABILITY_RAIN_DISH ;abilities
	db 0, 0 ;padding
	db MEDIUM_SLOW ;growth rate
	dn PLANT, AMPHIBIAN ;egg groups

