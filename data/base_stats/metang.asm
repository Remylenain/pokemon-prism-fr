	db METANG
	db 60, 75, 100, 50, 55, 80
	db STEEL, PSYCHIC
	db 3 ;catch rate
	db 153 ;exp rate
	db NO_ITEM
	db METAL_COAT
	db 255 ;gender
	db 100 ;unknown
	db 41 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/metang/dimensions.asm"
	db ABILITY_CLEAR_BODY, ABILITY_CLEAR_BODY ;abilities
	db 0, 0 ;padding
	db SLOW ;growth rate
	dn INANIMATE, INANIMATE ;egg groups

