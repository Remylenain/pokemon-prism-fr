	db KOFFING
	db 40, 65, 95, 35, 60, 45
	db POISON, GAS
	db 190 ;catch rate
	db 114 ;exp rate
	db NO_ITEM
	db CIGARETTE
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/koffing/dimensions.asm"
	db ABILITY_LEVITATE, ABILITY_LEVITATE ;abilities
	db 0, 0 ;padding
	db MEDIUM_FAST ;growth rate
	dn AMORPHOUS, AMORPHOUS ;egg groups

