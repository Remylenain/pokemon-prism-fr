	db WAILMER
	db 130, 70, 35, 60, 70, 35
	db WATER, WATER
	db 125 ;catch rate
	db 137 ;exp rate
	db NO_ITEM
	db LEFTOVERS
	db 127 ;gender
	db 100 ;unknown
	db 41 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/wailmer/dimensions.asm"
	db ABILITY_WATER_VEIL, ABILITY_OBLIVIOUS ;abilities
	db 0, 0 ;padding
	db FLUCTUATING ;growth rate
	dn FISH, FIELD ;egg groups

