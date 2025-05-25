	db RHYDON
	db 105, 130, 120, 40, 45, 45
	db GROUND, ROCK
	db 60 ;catch rate
	db 204 ;exp rate
	db NO_ITEM
	db HARD_STONE
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/rhydon/dimensions.asm"
	db ABILITY_LIGHTNINGROD, ABILITY_ROCK_HEAD ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn FIELD, MONSTER ;egg groups

