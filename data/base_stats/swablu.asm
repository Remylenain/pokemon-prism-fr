	db SWABLU
	db 45, 40, 60, 50, 40, 75
	db NORMAL, FLYING
	db 255 ;catch rate
	db 74 ;exp rate
	db NO_ITEM
	db DRAGON_FANG
	db 127 ;gender
	db 100 ;unknown
	db 21 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/swablu/dimensions.asm"
	db ABILITY_NATURAL_CURE, ABILITY_NATURAL_CURE ;abilities
	db 0, 0 ;padding
	db ERRATIC ;growth rate
	dn AVIAN, REPTILE ;egg groups

