LANDMARK_MAP_WIDTH EQU 18
LANDMARK_MAP_HEIGHT EQU 15

MACRO region_def
	enum REGION_\1
\1_LANDMARK EQU const_value
	ENDM

	enum_start

	const_def
	const SPECIAL_MAP        ; 00

	region_def NALJO
	const HEATH_VILLAGE      ; 01
	const ROUTE_69           ; 02
	const ROUTE_70           ; 03
	const CAPER_RIDGE        ; 04
	const ROUTE_71_EAST      ; 05
	const ROUTE_71_WEST      ; 06
	const ROUTE_72           ; 07
	const OXALIS_CITY        ; 08
	const ROUTE_73           ; 09
	const MOUND_CAVE         ; 0a
	const SPURGE_CITY        ; 0b
	const ROUTE_74           ; 0c
	const ROUTE_75           ; 0d
	const LAUREL_CITY        ; 0e
	const MAGIKARP_CAVERNS	 ; 0f
	const ROUTE_76           ; 10
	const LAUREL_FOREST      ; 11
	const TORENIA_CITY       ; 12
	const ROUTE_83           ; 13
	const ROUTE_77           ; 14
	const MILOS_CATACOMBS    ; 15
	const PHACELIA_CITY      ; 16
	const BATTLE_TOWER       ; 17
	const ROUTE_78           ; 18
	const ROUTE_79           ; 19
	const SAXIFRAGE_ISLAND   ; 1a
	const ROUTE_80           ; 1b
	const ROUTE_81           ; 1c
	const PROVINICIAL_PARK   ; 1d
	const FIRELIGHT_CAVERNS  ; 1e
	const ROUTE_85           ; 1f
	const NALJO_RUINS        ; 20
	const CLATHRITE_TUNNEL   ; 21
	const ROUTE_84           ; 22
	const PHLOX_TOWN         ; 23
	const ACQUA_MINES        ; 24
	const ROUTE_82           ; 25
	const ACANIA_DOCKS       ; 26
	const ROUTE_68           ; 27
	const NALJO_BORDER       ; 28
	const ROUTE_86           ; 29
	const CHAMPION_ISLE      ; 2a
	const TUNNEL             ; 2b
	const ROUTE_87           ; 2c
	const FARAWAY_ISLAND     ; 2d
	const DUMMY2             ; 2e
	const DUMMY3             ; 2f
	const DUMMY4             ; 30

	region_def RIJON
	const SEASHORE_CITY      ; 31
	const ROUTE_53           ; 32
	const GRAVEL_TOWN        ; 33
	const MERSON_CAVE        ; 34
	const ROUTE_54           ; 35
	const MERSON_CITY        ; 36
	const ROUTE_55           ; 37
	const RIJON_UNDERGROUND  ; 38
	const ROUTE_52           ; 39
	const HAYWARD_CITY       ; 3a
	const ROUTE_64           ; 3b
	const ROUTE_51           ; 3c
	const ROUTE_50           ; 3d
	const ROUTE_49           ; 3e
	const OWSAURI_CITY       ; 3f
	const ROUTE_66           ; 40
	const ROUTE_48           ; 41
	const ROUTE_63           ; 42
	const SILK_TUNNEL        ; 43
	const MORAGA_TOWN        ; 44
	const ROUTE_60           ; 45
	const JAERU_CITY         ; 46
	const ROUTE_59           ; 47
	const SILPH_WAREHOUSE    ; 48
	const BOTAN_CITY         ; 49
	const HAUNTED_FOREST     ; 4a
	const POWER_PLANT        ; 4b
	const ROUTE_58           ; 4c
	const CASTRO_VALLEY      ; 4d
	const CASTRO_MANSION     ; 4e
	const CASTRO_FOREST      ; 4f
	const ROUTE_62           ; 50
	const ROUTE_61           ; 51
	const ROUTE_57           ; 52
	const ROUTE_56           ; 53
	const EAGULOU_CITY       ; 54
	const EAGULOU_PARK       ; 55
	const ROUTE_65           ; 56
	const RIJON_LEAGUE       ; 57
	const ROUTE_67           ; 58
	const MT_BOULDER         ; 59
	const SENECA_CAVERNS     ; 5a
	const SOUTH_RIJON_GATE   ; 5b


	region_def JOHTO
	const ROUTE_47           ; 5c
	const ILEX_FOREST        ; 5d
	const AZALEA_TOWN        ; 5e
	const ROUTE_34           ; 5f
	const GOLDENROD_CITY     ; 60
	const GOLDENROD_CAPE     ; 61

	region_def KANTO
	const SAFFRON_CITY       ; 62

	region_def SEVII
	const EMBER_BROOK        ; 63
	const MT_EMBER           ; 64
	const KINDLE_ROAD        ; 65
	const ONE_ISLAND         ; 66
	const TREASURE_BEACH     ; 67
	const TREASURE_COVE      ; 68

	region_def TUNOD
	const TUNOD_WATERWAY     ; 69
	const SOUTH_SOUTHERLY    ; 6a
	const SOUTHERLY_CITY     ; 6b
	const ESPO_CLEARING      ; 6c
	const ESPO_FOREST        ; 6d
	const OLCAN_CHINE        ; 6e
	const OLCAN_ISLE         ; 6f

	region_def MYSTERY
	const MYSTERY_ZONE       ; 70
