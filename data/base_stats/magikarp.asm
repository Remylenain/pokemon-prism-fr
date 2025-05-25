	db MAGIKARP
	db 20, 10, 55, 80, 15, 20
	db WATER, WATER
	db 255 ;catch rate
	db 20 ;exp rate
	db NO_ITEM
	db ORAN_BERRY
	db 127 ;gender
	db 100 ;unknown
	db 5 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/magikarp/dimensions.asm"
	db ABILITY_SWIFT_SWIM, ABILITY_SWIFT_SWIM ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn REPTILE, FISH ;egg groups

