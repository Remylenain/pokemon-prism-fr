	db TRAPINCH
	db 45, 100, 45, 10, 45, 45
	db GROUND, GROUND
	db 255 ;catch rate
	db 73 ;exp rate
	db NO_ITEM
	db SOFT_SAND
	db 127 ;gender
	db 100 ;unknown
	db 21 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/trapinch/dimensions.asm"
	db ABILITY_HYPER_CUTTER, ABILITY_ARENA_TRAP ;abilities
	db 0, 0 ;padding
	db MEDIUM_SLOW ;growth rate
	dn INSECT, REPTILE ;egg groups
