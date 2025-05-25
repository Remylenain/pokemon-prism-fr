	db IGGLYBUFF
	db 90, 30, 15, 15, 40, 20
	db SOUND, FAIRY_T
	db 170 ;catch rate
	db 39 ;exp rate
	db NO_ITEM
	db ORAN_BERRY
	db 191 ;gender
	db 100 ;unknown
	db 10 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/igglybuff/dimensions.asm"
	db ABILITY_CUTE_CHARM, ABILITY_COMPETITIVE ;abilities
	db 0, 0 ;padding
	db FAST ;growth rate
	dn NO_EGGS, NO_EGGS ;egg groups

