	db PHANCERO
	db  178, 137, 57, 128, 85,  65
	db GHOST, FLYING
	db 3 ;catch rate
	db 216 ;exp rate
	db NO_ITEM ;item 1
	db NO_ITEM ;item 2
	db 255 ;gender
	db 100 ;unknown
	db 80 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/phancero/dimensions.asm"
	db ABILITY_DOWNLOAD, ABILITY_CONTRARY
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn NO_EGGS, NO_EGGS ;egg groups
