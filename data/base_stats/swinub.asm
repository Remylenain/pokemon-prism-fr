	db SWINUB
	db 50, 50, 40, 50, 30, 30
	db ICE, GROUND
	db 225 ;catch rate
	db 78 ;exp rate
	db NO_ITEM
	db NEVERMELTICE
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/swinub/dimensions.asm"
	db ABILITY_OBLIVIOUS, ABILITY_SNOW_CLOAK ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn FIELD, FIELD ;egg groups

