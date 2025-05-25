	db VOLBEAT
	db 65, 73, 75, 85, 47, 85
	db BUG, BUG
	db 150 ;catch rate
	db 146 ;exp rate
	db NO_ITEM
	db CHERI_BERRY
	db 0 ;gender
	db 100 ;unknown
	db 16 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/volbeat/dimensions.asm"
	db ABILITY_ILLUMINATE, ABILITY_SWARM ;abilities
	db 0, 0 ;padding
	db ERRATIC ;growth rate
	dn HUMANSHAPE, INSECT ;egg groups

