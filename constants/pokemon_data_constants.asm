; growth rate
	const_def
	const MEDIUM_FAST
	const SLIGHTLY_FAST
	const SLIGHTLY_SLOW
	const MEDIUM_SLOW
	const FAST
	const SLOW
	const ERRATIC
	const FLUCTUATING

; egg group constants -- comments list what the community generally call them
const_value = 1
	const MONSTER      ; 1 ("Monster")
	const AMPHIBIAN    ; 2 ("Water 1")
	const INSECT       ; 3 ("Bug")
	const AVIAN        ; 4 ("Flying")
	const FIELD        ; 5 ("Field")
	const FAIRY        ; 6 ("Fairy")
	const PLANT        ; 7 ("Grass")
	const HUMANSHAPE   ; 8 ("Human-Like")
	const INVERTEBRATE ; 9 ("Water 3")
	const INANIMATE    ; a ("Mineral")
	const AMORPHOUS    ; b ("Amorphous")
	const FISH         ; c ("Water 2")
	const LADIES_MAN   ; d ("Ditto")
	const REPTILE      ; e ("Dragon")
	const NO_EGGS      ; f ("Undiscovered")

; menu sprites
const_value = 1
	const ICON_POLIWAG
	const ICON_JIGGLYPUFF
	const ICON_DIGLETT
	const ICON_PIKACHU
	const ICON_STARYU
	const ICON_FISH
	const ICON_BIRD
	const ICON_MONSTER
	const ICON_CLEFAIRY
	const ICON_ODDISH
	const ICON_BUG
	const ICON_GHOST
	const ICON_LAPRAS
	const ICON_HUMANSHAPE
	const ICON_FOX
	const ICON_EQUINE
	const ICON_SHELL
	const ICON_BLOB
	const ICON_SERPENT
	const ICON_VOLTORB
	const ICON_SQUIRTLE
	const ICON_BULBASAUR
	const ICON_CHARMANDER
	const ICON_CATERPILLAR
	const ICON_UNOWN
	const ICON_GEODUDE
	const ICON_FIGHTER
	const ICON_EGG
	const ICON_JELLYFISH
	const ICON_MOTH
	const ICON_BAT
	const ICON_SNORLAX
	const ICON_HO_OH
	const ICON_LUGIA
	const ICON_GYARADOS
	const ICON_SLOWPOKE
	const ICON_SUDOWOODO
	const ICON_BIGMON

; evolution types
const_value = 1
	const EVOLVE_LEVEL
	const EVOLVE_ITEM
	const EVOLVE_TRADE
	const EVOLVE_HAPPINESS
	const EVOLVE_STAT
	const EVOLVE_MAPGROUP
	const EVOLVE_HOLD_NIGHT
	const EVOLVE_ITEM_MALE
	const EVOLVE_ITEM_FEMALE
	const EVOLVE_SYLVEON
	const EVOLVE_MOVE

BASE_HAPPINESS        EQU 70
FRIEND_BALL_HAPPINESS EQU 200

; happiness evolution triggers
HAPPINESS_TO_EVOLVE EQU 220
const_value = 1
	const TR_ANYTIME
	const TR_MORNDAY
	const TR_NITE

; stat evolution triggers
const_value = 1
	const ATK_GT_DEF
	const ATK_LT_DEF
	const ATK_EQ_DEF

SYLVEON_NEEDED_STATEXP EQU $8000

NUM_GRASSMON EQU 7
NUM_WATERMON EQU 3
MAX_POKERUS_DAYS EQU 4

GRASS_WILDDATA_LENGTH EQU (NUM_GRASSMON * 2 + 1) * 3 + 2
WATER_WILDDATA_LENGTH EQU (NUM_WATERMON * 2 + 1) * 1 + 2

NUM_WILDMONS_PER_AREA_TIME_OF_DAY EQU 7
WILDMON_GRASS_STRUCTURE_LENGTH EQU 2 + 3 * (1 + 2 * NUM_WILDMONS_PER_AREA_TIME_OF_DAY)

; pokemon structure in RAM
MON_SPECIES              EQUS "(wPartyMon1Species - wPartyMon1)"
MON_ITEM                 EQUS "(wPartyMon1Item - wPartyMon1)"
MON_MOVES                EQUS "(wPartyMon1Moves - wPartyMon1)"
MON_ID                   EQUS "(wPartyMon1ID - wPartyMon1)"
MON_EXP                  EQUS "(wPartyMon1Exp - wPartyMon1)"
MON_STAT_EXP             EQUS "(wPartyMon1StatExp - wPartyMon1)"
MON_HP_EXP               EQUS "(wPartyMon1HPExp - wPartyMon1)"
MON_ATK_EXP              EQUS "(wPartyMon1AtkExp - wPartyMon1)"
MON_DEF_EXP              EQUS "(wPartyMon1DefExp - wPartyMon1)"
MON_SPD_EXP              EQUS "(wPartyMon1SpdExp - wPartyMon1)"
MON_SPC_EXP              EQUS "(wPartyMon1SpcExp - wPartyMon1)"
MON_DVS                  EQUS "(wPartyMon1DVs - wPartyMon1)"
MON_PP                   EQUS "(wPartyMon1PP - wPartyMon1)"
MON_HAPPINESS            EQUS "(wPartyMon1Happiness - wPartyMon1)"
MON_PKRUS                EQUS "(wPartyMon1PokerusStatus - wPartyMon1)"
MON_CAUGHTDATA           EQUS "(wPartyMon1CaughtData - wPartyMon1)"
MON_CAUGHTLEVEL          EQUS "(wPartyMon1CaughtLevel - wPartyMon1)"
MON_CAUGHTTIME           EQUS "(wPartyMon1CaughtTime - wPartyMon1)"
MON_CAUGHTGENDER         EQUS "(wPartyMon1CaughtGender - wPartyMon1)"
MON_CAUGHTLOCATION       EQUS "(wPartyMon1CaughtLocation - wPartyMon1)"
MON_LEVEL                EQUS "(wPartyMon1Level - wPartyMon1)"
MON_STATUS               EQUS "(wPartyMon1Status - wPartyMon1)"
MON_HP                   EQUS "(wPartyMon1HP - wPartyMon1)"
MON_MAXHP                EQUS "(wPartyMon1MaxHP - wPartyMon1)"
MON_ATK                  EQUS "(wPartyMon1Attack - wPartyMon1)"
MON_DEF                  EQUS "(wPartyMon1Defense - wPartyMon1)"
MON_SPD                  EQUS "(wPartyMon1Speed - wPartyMon1)"
MON_SAT                  EQUS "(wPartyMon1SpclAtk - wPartyMon1)"
MON_SDF                  EQUS "(wPartyMon1SpclDef - wPartyMon1)"
BOXMON_STRUCT_LENGTH     EQUS "(wPartyMon1End - wPartyMon1)"
PARTYMON_STRUCT_LENGTH   EQUS "(wPartyMon1StatsEnd - wPartyMon1)"
REDMON_STRUCT_LENGTH EQU 44

const_value = 1
	const MONMENU_CUT        ; 1
	const MONMENU_FLY        ; 2
	const MONMENU_SURF       ; 3
	const MONMENU_STRENGTH   ; 4
	const MONMENU_WATERFALL  ; 5
	const MONMENU_FLASH      ; 6
	const MONMENU_WHIRLPOOL  ; 7
	const MONMENU_DIG        ; 8
	const MONMENU_TELEPORT   ; 9
	const MONMENU_SOFTBOILED ; 10
	const MONMENU_HEADBUTT   ; 11
	const MONMENU_ROCKSMASH  ; 12
	const MONMENU_MILKDRINK  ; 13
	const MONMENU_SWEETSCENT ; 14

	const MONMENU_STATS      ; 15
	const MONMENU_SWITCH     ; 16
	const MONMENU_ITEM       ; 17
	const MONMENU_CANCEL     ; 18
	const MONMENU_MOVE       ; 19
	const MONMENU_MAIL       ; 20
	const MONMENU_ERROR      ; 21
	const MONMENU_PMODE_ITEM ; 22

MONMENU_FIELD_MOVE EQU 0
MONMENU_MENUOPTION EQU 1
