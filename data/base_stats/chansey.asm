	db CHANSEY
	db 250, 5, 5, 50, 35, 105
	db NORMAL, NORMAL
	db 30 ;catch rate
	db 255 ;exp rate
	db NO_ITEM
	db LUCKY_EGG
	db 254 ;gender
	db 100 ;unknown
	db 40 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/chansey/dimensions.asm"
	db ABILITY_NATURAL_CURE, ABILITY_SERENE_GRACE ;abilities
	db 0, 0 ;padding
	db FAST ;growth rate
	dn FAIRY, FAIRY ;egg groups

