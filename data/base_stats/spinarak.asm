	db SPINARAK
	db 40, 60, 40, 30, 40, 40
	db BUG, POISON
	db 255 ;catch rate
	db 54 ;exp rate
	db SILK
	db SILK
	db 127 ;gender
	db 100 ;unknown
	db 15 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/spinarak/dimensions.asm"
	db ABILITY_SWARM, ABILITY_INSOMNIA ;abilities
	db 0, 0 ;padding
	db FAST ;growth rate
	dn INSECT, INSECT ;egg groups

