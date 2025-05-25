	db BANETTE
	db 64, 115, 65, 65, 83, 63
	db GHOST, GHOST
	db 45 ;catch rate
	db 179 ;exp rate
	db NO_ITEM
	db SPELL_TAG
	db 127 ;gender
	db 100 ;unknown
	db 26 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/banette/dimensions.asm"
	db ABILITY_INSOMNIA, ABILITY_FRISK ;abilities
	db 0, 0 ;padding
	db FAST ;growth rate
	dn AMORPHOUS, AMORPHOUS ;egg groups

