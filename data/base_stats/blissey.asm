	db BLISSEY
	db 255, 10, 10, 55, 75, 135
	db NORMAL, NORMAL
	db 30 ;catch rate
	db 255 ;exp rate
	db NO_ITEM
	db LUCKY_EGG
	db 254 ;gender
	db 100 ;unknown
	db 40 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/blissey/dimensions.asm"
	db ABILITY_NATURAL_CURE, ABILITY_SERENE_GRACE ;abilities
	db 0, 0 ;padding
	db FAST ;growth rate
	dn FAIRY, FAIRY ;egg groups

