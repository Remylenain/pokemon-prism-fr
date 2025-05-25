	db FEEBAS
	db 20, 15, 20, 80, 10, 55
	db WATER, WATER
	db 255 ;catch rate
	db 61 ;exp rate
	db NO_ITEM
	db SITRUS_BERRY
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/feebas/dimensions.asm"
	db ABILITY_SWIFT_SWIM, ABILITY_OBLIVIOUS ;abilities
	db 0, 0 ;padding
	db ERRATIC ;growth rate
	dn AMPHIBIAN, REPTILE ;egg groups

