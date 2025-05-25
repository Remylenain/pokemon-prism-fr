	db JIGGLYPUFF
	db 115, 45, 20, 20, 45, 25
	db SOUND, FAIRY_T
	db 170 ;catch rate
	db 76 ;exp rate
	db ORAN_BERRY
	db NO_ITEM
	db 191 ;gender
	db 100 ;unknown
	db 10 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/jigglypuff/dimensions.asm"
	db ABILITY_CUTE_CHARM, ABILITY_COMPETITIVE ;abilities
	db 0, 0 ;padding
	db FAST ;growth rate
	dn FAIRY, FAIRY ;egg groups

