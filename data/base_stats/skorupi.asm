	db SKORUPI
	db 40, 50, 90, 65, 30, 55
	db POISON, BUG
	db 120 ;catch rate
	db 114 ;exp rate
	db NO_ITEM
	db POISON_BARB
	db 127 ;gender
	db 100 ;unknown
	db 21 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/skorupi/dimensions.asm"
	db ABILITY_BATTLE_ARMOR, ABILITY_SNIPER ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn INVERTEBRATE, INSECT ;egg groups

