	db ELECTRIKE
	db 40, 45, 40, 65, 65, 40
	db ELECTRIC, ELECTRIC
	db 120 ;catch rate
	db 104 ;exp rate
	db NO_ITEM
	db X_SP_ATK
	db 127 ;gender
	db 100 ;unknown
	db 21 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/electrike/dimensions.asm"
	db ABILITY_STATIC, ABILITY_LIGHTNINGROD ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn FIELD, FIELD ;egg groups

