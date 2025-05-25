SRAM_Begin EQU $a000
SRAM_End   EQU $c000
EXPORT SRAM_Begin, SRAM_End

SECTION "SRAM Bank 0", SRAM
sScratch:: ds 7 * 7 tiles

sBattleTowerPartyBackup:: ds 2 + PARTY_LENGTH * (PARTYMON_STRUCT_LENGTH + 2 * PKMN_NAME_LENGTH + 1)

sBuildNumber:: ds 2

SECTION "Saved Stable RNG", SRAM
sStableRNGData:: ds wStableRNGDataEnd - wStableRNGData

SECTION "RTC", SRAM
sRTCStatusFlags:: ds 1
; bit 0: day counter went past a year
; bit 5: day counter exceeded 139
; bit 6: day counter exceeded 255
; bit 7: time not set

sRTC::
sRTCBaseDay:: ds 1
sRTCBaseHours:: ds 1
sRTCBaseMinutes:: ds 1
sRTCBaseSeconds:: ds 1
sRTCBaseYear:: ds 1
sRTCBaseMonth:: ds 1
sRTCEnd::

	ds 4

sRNGState:: ds 8

SECTION "Backup Save", SRAM
sBackupOptions:: ds wOptionsEnd - wOptions

	ds 2

sBackupValidCheck1:: ds 1

sBackupGameData::
sBackupPlayerData::  ds wPlayerDataEnd - wPlayerData
sBackupMapData::     ds wMapDataEnd - wMapData
sBackupPokemonData:: ds wPokemonDataEnd - wPokemonData
sBackupGameDataEnd::

sBackupExtraData:: ds wExtraDataEnd - wExtraData

sBackupExtraChecksum:: ds 2

	ds 5

sBackupChecksum:: ds 2
sBackupValidCheck2:: ds 1
sStackTop:: ds 2


SECTION "SRAM Bank 1", SRAM

sOptions:: ds wOptionsEnd - wOptions

	ds 2

sValidCheck1:: ds 1 ; loaded with 99, used to check save corruption

sGameData::
sPlayerData::  ds wPlayerDataEnd - wPlayerData
sMapData::     ds wMapDataEnd - wMapData
sPokemonData:: ds wPokemonDataEnd - wPokemonData
sGameDataEnd::

sExtraData:: ds wExtraDataEnd - wExtraData

sExtraChecksum:: ds 2

	ds 5

sChecksum::    ds 2
sValidCheck2:: ds 1 ; loaded with 0x7f, used to check save corruption

	box sBox

	ds $100

sLinkBattleStats:: ; b260
sLinkBattleWins::   ds 2
sLinkBattleLosses:: ds 2 ; b262
sLinkBattleDraws::  ds 2 ; b264
MACRO link_battle_record
\1Name:: ds NAME_LENGTH - 1
\1ID:: ds 2
\1Wins:: ds 2
\1Losses:: ds 2
\1Draws:: ds 2
ENDM
sLinkBattleRecord::
sLinkBattleRecord1:: link_battle_record sLinkBattleRecord1
sLinkBattleRecord2:: link_battle_record sLinkBattleRecord2
sLinkBattleRecord3:: link_battle_record sLinkBattleRecord3
sLinkBattleRecord4:: link_battle_record sLinkBattleRecord4
sLinkBattleRecord5:: link_battle_record sLinkBattleRecord5
sLinkBattleStatsEnd::

sHallOfFame:: ; b2c0
x = 1
rept NUM_HOF_TEAMS
DOIT equs "hall_of_fame sHallOfFame{d:x}"
	DOIT
PURGE DOIT
x = x + 1
endr
sHallOfFameEnd::

	ds 9

; data of the BattleTower must be in SRAM because you can save and leave between battles
sBattleTowerChallengeState:: ds 1
; 0: normal
; 2: battle tower

sBattleTower::
sBTCurStreak:: ds 1
sBTChoiceOfLvlGroup:: ds 1
sBTOpponentIndices:: ds 7
sBTMonsSelected:: ds 3 * 7
sBTOTTrainer:: battle_tower_struct sBTOT
sBTTrainerTextIndex:: ds 2
sBTWinStreak:: ds 1
sBattleTowerEnd::

SECTION "Boxes 1-7", SRAM
	box sBox1
	box sBox2
	box sBox3
	box sBox4
	box sBox5
	box sBox6
	box sBox7

SECTION "Boxes 8-14", SRAM
	box sBox8
	box sBox9
	box sBox10
	box sBox11
	box sBox12
	box sBox13
	box sBox14
