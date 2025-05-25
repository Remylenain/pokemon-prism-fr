	db PARASECT
	db 60, 95, 80, 30, 60, 80
	db BUG, GRASS
	db 75 ;catch rate
	db 128 ;exp rate
	db TINYMUSHROOM
	db BIG_MUSHROOM
	db 127 ;gender
	db 100 ;unknown
	db 20 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/parasect/dimensions.asm"
	db ABILITY_EFFECT_SPORE, ABILITY_DRY_SKIN ;abilities
	db 0, 0 ;padding
	db MEDIUM_FAST ;growth rate
	dn PLANT, INSECT ;egg groups

