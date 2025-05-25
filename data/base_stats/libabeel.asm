	db LIBABEEL
	db 125, 100, 125, 100, 100, 100
	db STEEL, POISON
	db 3 ;catch rate
	db 215 ;exp rate
	db NO_ITEM
	db NO_ITEM
	db 255 ;gender
	db 100 ;unknown
	db 35 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/libabeel/dimensions.asm"
	db ABILITY_NALJO_FURY, ABILITY_NALJO_FURY ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn NO_EGGS, NO_EGGS ;egg groups

