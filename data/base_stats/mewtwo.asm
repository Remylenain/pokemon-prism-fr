	db MEWTWO
	db 106, 110, 90, 130, 154, 90
	db PSYCHIC, PSYCHIC
	db 3 ;catch rate
	db 220 ;exp rate
	db NO_ITEM
	db BERSERK_GENE
	db 255 ;gender
	db 100 ;unknown
	db 120 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/mewtwo/dimensions.asm"
	db ABILITY_PRESSURE, ABILITY_PRESSURE ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn NO_EGGS, NO_EGGS ;egg groups

