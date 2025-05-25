Marts:
	dw CaperMartItems
	dw OxalisMartItems
	dw SpurgeMartItems1
	dw SpurgeMartItems2
	dw SpurgeMartItems3
	dw SpurgeMartItems4
	dw HeathMartItems
	dw LaurelMartItems
	dw ToreniaMartItems
	dw PhaceliaMartItems
	dw SaxifrageMartItems
	dw PhloxMartItems
	dw AcaniaMartItems
	dw SaffronMartItems
	dw LeagueMartItems
	dw GravelMartItems
	dw MersonMartItems
	dw OwsauriMartItems
	dw MoragaMartItems
	dw JaeruMartItems
	dw HaywardMartItems1
	dw HaywardMartItems2
	dw HaywardMartItems3
	dw HaywardMartItems4
	dw HaywardMartItems5
	dw BotanMartItems
	dw CastroMartItems
	dw EagulouMartItems
	dw AzaleaMartItems
	dw GoldenrodMartItems
	dw SoutherlyMartItems
	dw SilphWarehouseMartItems
MartsEnd:

GoldTokenMarts:
	dw SpurgeMartGoldTokenExchange
	dw LaurelMartGoldTokenExchange
	dw AcaniaMartGoldTokenExchange
	dw JaeruGuardGoldTokenExchange
GoldTokenMartsEnd:

DefaultMartItems:
CaperMartItems:
	db 5 ; # items
	db POKE_BALL
	db POTION
	db ANTIDOTE
	db ESCAPE_ROPE
	db REPEL
	db $ff

OxalisMartItems:
	db 9 ; # items
	db BRICK_PIECE
	db POKE_BALL
	db POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db BURN_HEAL
	db AWAKENING
	db REPEL
	db ESCAPE_ROPE
	db $ff

SpurgeMartItems1:
	db 8 ; # items
	db X_ATTACK
	db X_DEFEND
	db X_SPEED
	db X_SP_ATK
	db X_SP_DEF
	db X_ACCURACY
	db GUARD_SPEC
	db DIRE_HIT
	db $ff

SpurgeMartItems2:
	db 8 ; # items
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db MOOMOO_MILK
	db $ff

SpurgeMartItems3:
	db 4 ; # items
	db BURGER
	db FRIES
	db SODA_POP
	db LEMONADE
	db $ff

SpurgeMartItems4:
	db 5 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ESCAPE_ROPE
	db REPEL
	db POKE_DOLL
	db $ff

HeathMartItems:
	db 8 ; # items
	db MINING_PICK
	db POKE_BALL
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db ESCAPE_ROPE
	db REPEL
	db $ff

LaurelMartItems:
	db 10 ; # items
	db POKE_BALL
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db ICE_HEAL
	db REVIVE
	db $ff

ToreniaMartItems:
	db 8 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db PARLYZ_HEAL
	db AWAKENING
	db ANTIDOTE
	db SUPER_REPEL
	db ESCAPE_ROPE
	db REVIVE
	db $ff

PhaceliaMartItems:
	db 6 ; # items
	db MINING_PICK
	db ULTRA_BALL
	db GREAT_BALL
	db HYPER_POTION
	db SUPER_POTION
	db SUPER_REPEL
	db $ff

SaxifrageMartItems:
	db 6 ; # items
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db FULL_HEAL
	db REVIVE
	db CIGARETTE
	db $ff

PhloxMartItems:
	db 8 ; # items
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db FULL_HEAL
	db REVIVE
	db MAX_REPEL
	db ESCAPE_ROPE
	db $ff

AcaniaMartItems:
	db 9 ; # items
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db MAX_REPEL
	db ESCAPE_ROPE
	db REVIVE
	db ANTIDOTE
	db FULL_HEAL
	db X_ACCURACY
	db $ff

SaffronMartItems:
	db 8 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db HYPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db ICE_HEAL
	db SUPER_REPEL
	db $ff

LeagueMartItems:
	db 7 ; # items
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db FULL_HEAL
	db REVIVE
	db ELIXIR
	db $ff

GravelMartItems:
	db 8 ; # items
	db ULTRA_BALL
	db HYPER_POTION
	db FULL_HEAL
	db REVIVE
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db $ff

MersonMartItems:
	db 7 ; # items
	db WATER_STONE
	db POKE_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db $ff

OwsauriMartItems:
	db 9 ; # items
	db FIRE_STONE
	db GREAT_BALL
	db ULTRA_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db FULL_HEAL
	db X_DEFEND
	db X_ATTACK
	db DIRE_HIT
	db $ff

MoragaMartItems:
	db 8 ; # items
	db LEAF_STONE
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db MAX_REPEL
	db FULL_HEAL
	db PARLYZ_HEAL
	db AWAKENING
	db $ff

JaeruMartItems:
	db 7 ; # items
	db THUNDERSTONE
	db ULTRA_BALL
	db KEG_OF_BEER
	db HYPER_POTION
	db REVIVE
	db PARLYZ_HEAL
	db FULL_HEAL
	db $ff

HaywardMartItems1:
	db 6 ; # items
	db POTION
	db SUPER_POTION
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db REVIVE
	db $ff

HaywardMartItems2:
	db 3 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db $ff

HaywardMartItems3:
	db 6 ; # items
	db FULL_HEAL
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db $ff

HaywardMartItems4:
	db 5 ; # items
	db REPEL
	db SUPER_REPEL
	db MAX_REPEL
	db ESCAPE_ROPE
	db POKE_DOLL
	db $ff

HaywardMartItems5:
	db 5 ; # items
	db HP_UP
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db $ff

BotanMartItems:
	db 6 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db PARLYZ_HEAL
	db AWAKENING
	db SUPER_REPEL
	db ESCAPE_ROPE
	db $ff

CastroMartItems:
	db 7 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db X_ATTACK
	db X_DEFEND
	db $ff

EagulouMartItems:
	db 5 ; # items
	db EAGULOU_BALL
	db ULTRA_BALL
	db MAX_POTION
	db ESCAPE_ROPE
	db MAX_REPEL
	db $ff

AzaleaMartItems:
	db 8 ; # items
	db CHARCOAL
	db ULTRA_BALL
	db MAX_REPEL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db REVIVE
	db FULL_HEAL
	db $ff

GoldenrodMartItems:
	db 4 ; # items
	db ENERGYPOWDER
	db ENERGY_ROOT
	db HEAL_POWDER
	db REVIVAL_HERB
	db $ff

SoutherlyMartItems:
	db 7 ; # items
	db ULTRA_BALL
	db MAX_POTION
	db FULL_RESTORE
	db BURN_HEAL
	db FULL_HEAL
	db MAX_REPEL
	db ELIXIR
	db $ff

SilphWarehouseMartItems:
	db 11
	db MAX_REVIVE
	db MAX_ELIXIR
	db RARE_CANDY
	db PP_UP
	db SACRED_ASH
	db MOON_STONE
	db DAWN_STONE
	db SHINY_STONE
	db DUSK_STONE
	db TRADE_STONE
	db EXP_SHARE
	db $ff

BattleTowerMart:
	db 18
	db PROTEIN,       1
	db CALCIUM,       1
	db IRON,          1
	db CARBOS,        1
	db HP_UP,         1
	db RAZOR_CLAW,   12
	db RAZOR_FANG,   12
	db POISON_GUARD, 16
	db BURN_GUARD,   16
	db FREEZE_GUARD, 16
	db SLEEP_GUARD,  16
	db PRZ_GUARD,    16
	db RARE_CANDY,   24
	db POWER_HERB,   24
	db BRIGHTPOWDER, 32
	db FOCUS_BAND,   32
	db SCOPE_LENS,   32
	db QUICK_CLAW,   32
	db $ff

BattleArcadePrizesAndCosts:
	db 17
	db SILVERPOWDER,  10
	db LUCKY_PUNCH,   25
	db EVERSTONE,     30
	db PP_UP,         40
	db WISE_GLASSES,  50
	db MUSCLE_BAND,   50
	db DRAGON_FANG,   60
	db EVIOLITE,      75
	db RARE_CANDY,    80
	db TRADE_STONE,  100
	db ELECTIRIZER,  100
	db MAGMARIZER,   100
	db MAX_REVIVE,   125
	db MAX_ELIXIR,   150
	db FRIEND_BALL,  200
	db SACRED_ASH,   250
	db MYSTERY_TCKT,   0
	db $ff

SpurgeMartGoldTokenExchange:
; 9 total
	db 3
	dbbw OLD_ROD, 2, EVENT_HAS_OLD_ROD
	dbbw LEFTOVERS, 2, EVENT_HAS_GOLD_TOKEN_LEFTOVERS
	dbbw TIME_MACHINE, 5, EVENT_HAS_TIME_MACHINE
	db $ff

LaurelMartGoldTokenExchange:
; 10 total
	db 3
	dbbw TRADE_STONE, 2, EVENT_HAS_GOLD_TOKEN_TRADE_STONE
	dbbw EXP_SHARE, 3, EVENT_HAS_EXP_SHARE
	dbbw ITEMFINDER, 5, EVENT_HAS_ITEMFINDER
	db $ff

AcaniaMartGoldTokenExchange:
; 35 total
	db 6
	dbbw YELLOW_FLUTE, 3, EVENT_HAS_YELLOW_FLUTE
	dbbw AMULET_COIN, 3, EVENT_HAS_AMULET_COIN
	dbbw TOKENTRACKER, 5, EVENT_HAS_TOKENTRACKER
	dbbw QR_READER, 5, EVENT_HAS_QR_READER
	dbbw IRON_PICKAXE, 9, EVENT_HAS_IRON_PICKAXE
	dbbw SMELTER, 10, EVENT_HAS_SMELTER
	db $ff

JaeruGuardGoldTokenExchange:
; 30 total
	db 6
	dbbw LUCKY_EGG, 5, EVENT_HAS_LUCKY_EGG
	dbbw HYPER_SHARE, 5, EVENT_HAS_HYPER_SHARE
	dbbw MACHO_BRACE, 5, EVENT_HAS_MACHO_BRACE
	dbbw EXPERT_BELT, 5, EVENT_HAS_EXPERT_BELT
	dbbw MUSCLE_BAND, 5, EVENT_HAS_MUSCLE_BAND
	dbbw WISE_GLASSES, 5, EVENT_HAS_WISE_GLASSES
	db $ff
