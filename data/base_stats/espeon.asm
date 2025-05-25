	db ESPEON
	db 65, 65, 60, 110, 130, 95
	db PSYCHIC, PSYCHIC
	db 45 ;catch rate
	db 197 ;exp rate
	db NO_ITEM
	db ORAN_BERRY
	db 31 ;gender
	db 100 ;unknown
	db 35 ;egg cycles
	db 5 ;unknown
	INCLUDE "gfx/pics/espeon/dimensions.asm"
	db ABILITY_SYNCHRONIZE, ABILITY_SYNCHRONIZE ;abilities
	db 0, 0 ;padding
	db MEDIUM_FAST ;growth rate
	dn FIELD, FIELD ;egg groups

