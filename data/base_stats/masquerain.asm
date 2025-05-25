	db MASQUERAIN
	db 70, 60, 62, 80, 100, 82
	db BUG, FLYING
	db 75 ;catch rate
	db 128 ;exp rate
	db NO_ITEM
	db SILVERPOWDER
	db 127 ;gender
	db 100 ;unknown
	db 16 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/masquerain/dimensions.asm"
	db ABILITY_INTIMIDATE, ABILITY_INTIMIDATE ;abilities
	db 0, 0 ;padding
	db MEDIUM_FAST ;growth rate
	dn INSECT, AMPHIBIAN ;egg groups

