	db RHYPERIOR
	db 115, 140, 130, 40, 55, 55
	db GROUND, ROCK
	db 30 ;catch rate
	db 217 ;exp rate
	db NO_ITEM
	db MOON_STONE
	db 127 ;gender
	db 100 ;unknown
	db 21 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/rhyperior/dimensions.asm"
	db ABILITY_LIGHTNINGROD, ABILITY_SOLID_ROCK ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn FIELD, MONSTER ;egg groups

