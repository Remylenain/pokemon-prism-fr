	db DUSKULL
	db 20, 40, 90, 25, 30, 90
	db GHOST, GHOST
	db 190 ;catch rate
	db 97 ;exp rate
	db NO_ITEM
	db SPELL_TAG
	db 127 ;gender
	db 100 ;unknown
	db 26 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/duskull/dimensions.asm"
	db ABILITY_LEVITATE, ABILITY_LEVITATE ;abilities
	db 0, 0 ;padding
	db FAST ;growth rate
	dn AMORPHOUS, AMORPHOUS ;egg groups

