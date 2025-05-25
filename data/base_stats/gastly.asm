	db GASTLY
	db 30, 35, 30, 80, 100, 35
	db GHOST, GAS
	db 190 ;catch rate
	db 95 ;exp rate
	db NO_ITEM
	db SPELL_TAG
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/gastly/dimensions.asm"
	db ABILITY_LEVITATE, ABILITY_LEVITATE ;abilities
	db 0, 0 ;padding
	db MEDIUM_SLOW ;growth rate
	dn AMORPHOUS, AMORPHOUS ;egg groups

