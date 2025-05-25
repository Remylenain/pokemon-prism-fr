	const FIGHTING ; 0 = NORMAL
	const FLYING
	const POISON
	const GROUND
	const ROCK
	const BIRD
	const BUG
	const GHOST
	const STEEL
	const FAIRY_T
	const GAS
	const TYPE_12
	const SOUND
	const TRI_T
	const PRISM_T
	const TYPE_16
	const TYPE_17
	const TYPE_18
	const CURSE_T
	const FIRE
	const WATER
	const GRASS
	const ELECTRIC
	const PSYCHIC
	const ICE
	const DRAGON
	const DARK

TYPES_END EQU const_value

MATCHUP_TABLE_WIDTH EQU (TYPES_END + 3) >> 2

	const_def
	const IMM
	const NVE
	const NTL
	const SE_

	const_def
	const PHYSICAL ; 00
	const SPECIAL  ; 40
	const STATUS   ; 80
