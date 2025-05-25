	db PHANPY
	db 90, 60, 60, 40, 40, 40
	db GROUND, GROUND
	db 120 ;catch rate
	db 124 ;exp rate
	db NO_ITEM
	db SMOOTH_ROCK
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/phanpy/dimensions.asm"
	db ABILITY_PICKUP, ABILITY_PICKUP ;abilities
	db 0, 0 ;padding
	db MEDIUM_FAST ;growth rate
	dn FIELD, FIELD ;egg groups

