	const_def

	def_engine_flag ENGINE_HAS_MAP, wTownMapFlags, 7 ; on/off ; $0

	def_engine_flag ENGINE_DAYCARE_MAN_HAS_EGG, wDaycareMan, 6 ; egg is ready

	def_engine_flag ENGINE_DAYCARE_MAN_HAS_MON, wDaycareMan, 0 ; monster 1 in daycare
	def_engine_flag ENGINE_DAYCARE_LADY_HAS_MON, wDaycareLady, 0 ; monster 2 in daycare

	def_engine_flag ENGINE_MOM_SAVING_MONEY, wBankSavingMoney, 0 ; mom saving money
	def_engine_flag ENGINE_DST, wBankSavingMoney, 7 ; dst

	def_engine_flag ENGINE_POKEDEX, wStatusFlags, 0 ; pokedex
	def_engine_flag ENGINE_POKEMON_MODE, wStatusFlags, 1 ; used to tell if we are in pokemon only mode
	def_engine_flag ENGINE_CUSTOM_PLAYER_SPRITE, wStatusFlags, 2 ; $8
	def_engine_flag ENGINE_POKERUS, wStatusFlags, 3 ; pokerus
	def_engine_flag ENGINE_USE_TREASURE_BAG, wStatusFlags, 4
	def_engine_flag ENGINE_CREDITS_SKIP, wStatusFlags, 6 ; credits skip
	def_engine_flag ENGINE_BUG_CONTEST_ON, wStatusFlags, 7 ; bug contest on

	def_engine_flag ENGINE_FLASH, wStatusFlags2, 0 ; flash in overworld
	def_engine_flag ENGINE_RTC_TIMERS_ENABLED, wStatusFlags2, 1 ; daily and other recurring timers enabled
	def_engine_flag ENGINE_PARK_MINIGAME, wStatusFlags2, 2 ; park minigame is on
	def_engine_flag ENGINE_TIME_ENABLED, wStatusFlags2, 3 ; unused, possibly related to a 2-day timer ; $10
	def_engine_flag ENGINE_HYPER_SHARE_ENABLED, wStatusFlags2, 4 ; hyper share enabled
	def_engine_flag ENGINE_GIVE_POKERUS, wStatusFlags2, 5 ; give pokerus
	def_engine_flag ENGINE_FLORIA, wStatusFlags2, 6 ; berry -> berry juice when trading?
	def_engine_flag ENGINE_ROCKETS_IN_MAHOGANY, wStatusFlags2, 7 ; rockets in mahogany

	def_engine_flag ENGINE_STRENGTH_ACTIVE, wBikeFlags, 0 ; strength active
	def_engine_flag ENGINE_ALWAYS_ON_BIKE, wBikeFlags, 1 ; always on bike (cant surf)
	def_engine_flag ENGINE_DOWNHILL, wBikeFlags, 2 ; downhill (cycling road)

	def_engine_flag ENGINE_PYREBADGE, wNaljoBadges, 0 ; $18
	def_engine_flag ENGINE_NATUREBADGE, wNaljoBadges, 1
	def_engine_flag ENGINE_CHARMBADGE, wNaljoBadges, 2
	def_engine_flag ENGINE_MIDNIGHTBADGE, wNaljoBadges, 3
	def_engine_flag ENGINE_MUSCLEBADGE, wNaljoBadges, 4
	def_engine_flag ENGINE_HAZEBADGE, wNaljoBadges, 5
	def_engine_flag ENGINE_RAUCOUSBADGE, wNaljoBadges, 6
	def_engine_flag ENGINE_NALJOBADGE, wNaljoBadges, 7

	def_engine_flag ENGINE_MARINEBADGE, wRijonBadges, 0 ; $20
	def_engine_flag ENGINE_HAILBADGE, wRijonBadges, 1
	def_engine_flag ENGINE_SPROUTBADGE, wRijonBadges, 2
	def_engine_flag ENGINE_SPARKYBADGE, wRijonBadges, 3
	def_engine_flag ENGINE_FISTBADGE, wRijonBadges, 4
	def_engine_flag ENGINE_PSIBADGE, wRijonBadges, 5
	def_engine_flag ENGINE_WHITEBADGE, wRijonBadges, 6
	def_engine_flag ENGINE_STARBADGE, wRijonBadges, 7

	def_engine_flag ENGINE_HIVEBADGE, wOtherBadges, 0 ; $28
	def_engine_flag ENGINE_PLAINBADGE, wOtherBadges, 1
	def_engine_flag ENGINE_MARSHBADGE, wOtherBadges, 2
	def_engine_flag ENGINE_BLAZEBADGE, wOtherBadges, 3
	def_engine_flag ENGINE_WILDS_DISABLED, wStatusFlags, 5
	def_engine_flag ENGINE_UNUSED_4, wOtherBadges, 7

	def_engine_flag ENGINE_FLYPOINT_START, wVisitedSpawns, 0
	def_engine_flag ENGINE_FLYPOINT_CAPER_RIDGE, wVisitedSpawns, 1
	def_engine_flag ENGINE_FLYPOINT_OXALIS_CITY, wVisitedSpawns, 2 ; $30
	def_engine_flag ENGINE_FLYPOINT_SPURGE_CITY, wVisitedSpawns, 3
	def_engine_flag ENGINE_FLYPOINT_HEATH_VILLAGE, wVisitedSpawns, 4
	def_engine_flag ENGINE_FLYPOINT_LAUREL_CITY, wVisitedSpawns, 5
	def_engine_flag ENGINE_FLYPOINT_TORENIA_CITY, wVisitedSpawns, 6
	def_engine_flag ENGINE_FLYPOINT_PHACELIA_TOWN, wVisitedSpawns, 7
	def_engine_flag ENGINE_FLYPOINT_ACANIA_DOCKS, wVisitedSpawns + 1, 0
	def_engine_flag ENGINE_FLYPOINT_SAXIFRAGE_ISLAND, wVisitedSpawns + 1, 1
	def_engine_flag ENGINE_FLYPOINT_PHLOX_TOWN, wVisitedSpawns + 1, 2 ; $38
	def_engine_flag ENGINE_FLYPOINT_BATTLE_ARCADE, wVisitedSpawns + 1, 3
	def_engine_flag ENGINE_FLYPOINT_SEASHORE_CITY, wVisitedSpawns + 1, 4
	def_engine_flag ENGINE_FLYPOINT_GRAVEL_TOWN, wVisitedSpawns + 1, 5
	def_engine_flag ENGINE_FLYPOINT_MERSON_CITY, wVisitedSpawns + 1, 6
	def_engine_flag ENGINE_FLYPOINT_HAYWARD_CITY, wVisitedSpawns + 1, 7
	def_engine_flag ENGINE_FLYPOINT_OWSAURI_CITY, wVisitedSpawns + 2, 0
	def_engine_flag ENGINE_FLYPOINT_MORAGA_TOWN, wVisitedSpawns + 2, 1
	def_engine_flag ENGINE_FLYPOINT_JAERU_CITY, wVisitedSpawns + 2, 2 ; $40
	def_engine_flag ENGINE_FLYPOINT_BOTAN_CITY, wVisitedSpawns + 2, 3
	def_engine_flag ENGINE_FLYPOINT_CASTRO_VALLEY, wVisitedSpawns + 2, 4
	def_engine_flag ENGINE_FLYPOINT_EAGULOU_CITY, wVisitedSpawns + 2, 5
	def_engine_flag ENGINE_FLYPOINT_RIJON_LEAGUE, wVisitedSpawns + 2, 6
	def_engine_flag ENGINE_FLYPOINT_SENECA_CAVERNS, wVisitedSpawns + 2, 7
	def_engine_flag ENGINE_FLYPOINT_AZALEA_TOWN, wVisitedSpawns + 3, 0
	def_engine_flag ENGINE_FLYPOINT_GOLDENROD_CITY, wVisitedSpawns + 3, 1
	def_engine_flag ENGINE_FLYPOINT_SOUTHERLY_CITY, wVisitedSpawns + 3, 3 ; skipping Saffron's fly bit that's never used ; $48
	def_engine_flag ENGINE_FLYPOINT_ROUTE_81, wVisitedSpawns + 4, 2 ; skipping fly bits that aren't spawns
	def_engine_flag ENGINE_FLYPOINT_BATTLE_TOWER, wVisitedSpawns + 4, 3
	def_engine_flag ENGINE_FLYPOINT_OLCAN_ISLE, wVisitedSpawns + 4, 4

	def_engine_flag ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT, wDailyFlags, 0 ; kurt making balls
	def_engine_flag ENGINE_DAILY_BUG_CONTEST, wDailyFlags, 1 ; ????
	def_engine_flag ENGINE_SPECIAL_WILDDATA, wDailyFlags, 2 ; special wilddata?
	def_engine_flag ENGINE_TIME_CAPSULE, wDailyFlags, 3 ; time capsule (24h wait)
	def_engine_flag ENGINE_ALL_FRUIT_TREES, wDailyFlags, 4 ; all fruit trees ; $50
	def_engine_flag ENGINE_SHUCKLE_GIVEN, wDailyFlags, 5 ; shuckle given
	def_engine_flag ENGINE_GOLDENROD_UNDERGROUND_MERCHANT_CLOSED, wDailyFlags, 6 ; goldenrod underground merchant closed
	def_engine_flag ENGINE_FOUGHT_IN_TRAINER_HALL_TODAY, wDailyFlags, 7 ; fought in trainer hall today

	def_engine_flag ENGINE_MT_MOON_SQUARE_CLEFAIRY, wWeeklyFlags, 0 ; mt moon square clefairy
	def_engine_flag ENGINE_UNION_CAVE_LAPRAS, wWeeklyFlags, 1 ; union cave lapras
	def_engine_flag ENGINE_GOLDENROD_MALL_5F_HAPPINESS_EVENT, wWeeklyFlags, 2 ; goldenrod mall happiness event floor05 person07
	def_engine_flag ENGINE_TEA_IN_BLUES_HOUSE, wWeeklyFlags, 3 ; tea in blues house ; $58
	def_engine_flag ENGINE_INDIGO_PLATEAU_RIVAL_FIGHT, wWeeklyFlags, 4 ; indigo plateau rival fight
	def_engine_flag ENGINE_DAILY_MOVE_TUTOR, wWeeklyFlags, 5 ; move tutor
	def_engine_flag ENGINE_BUENAS_PASSWORD, wWeeklyFlags, 6 ; buenas password

	def_engine_flag ENGINE_BUENAS_PASSWORD_2, wSwarmFlags, 0
	def_engine_flag ENGINE_GOLDENROD_DEPT_STORE_SALE_IS_ON, wSwarmFlags, 1 ; goldenrod dept store sale is on

	def_engine_flag ENGINE_62, wGameTimerPause, 7

	def_engine_flag ENGINE_PLAYER_IS_FEMALE, wPlayerGender, 0 ; player is female

	def_engine_flag ENGINE_KRIS_IN_CABLE_CLUB, wPlayerSpriteSetupFlags, 2 ; female player has been transformed into male ; $60

	def_engine_flag ENGINE_DUNSPARCE_SWARM, wSwarmFlags, 2 ; dunsparce swarm
	def_engine_flag ENGINE_YANMA_SWARM, wSwarmFlags, 3 ; yanma swarm

NUM_ENGINE_FLAGS EQU const_value
