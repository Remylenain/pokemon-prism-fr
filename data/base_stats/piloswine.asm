	db PILOSWINE
	db 100, 100, 80, 50, 60, 60
	db ICE, GROUND
	db 75 ;catch rate
	db 160 ;exp rate
	db NO_ITEM
	db NEVERMELTICE
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/piloswine/dimensions.asm"
	db ABILITY_OBLIVIOUS, ABILITY_SNOW_CLOAK ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn FIELD, FIELD ;egg groups

