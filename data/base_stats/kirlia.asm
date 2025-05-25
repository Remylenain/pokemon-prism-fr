	db KIRLIA
	db 38, 35, 35, 50, 65, 55
	db PSYCHIC, FAIRY_T
	db 120 ;catch rate
	db 140 ;exp rate
	db NO_ITEM
	db NO_ITEM
	db 127 ;gender
	db 100 ;unknown
	db 21 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/kirlia/dimensions.asm"
	db ABILITY_SYNCHRONIZE, ABILITY_TRACE ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn AMORPHOUS, HUMANSHAPE ;egg groups

