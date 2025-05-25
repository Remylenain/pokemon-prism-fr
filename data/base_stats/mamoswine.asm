	db MAMOSWINE
	db 110, 130, 80, 80, 70, 60
	db ICE, GROUND
	db 50 ;catch rate
	db 207 ;exp rate
	db NO_ITEM
	db NEVERMELTICE
	db 127 ;gender
	db 100 ;unknown
	db 21 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/mamoswine/dimensions.asm"
	db ABILITY_OBLIVIOUS, ABILITY_SNOW_CLOAK ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn FIELD, FIELD ;egg groups

