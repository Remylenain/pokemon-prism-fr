Special::
; Run script special de.
	ld hl, SpecialsPointers
	ld d, 0
	add hl, de
	add hl, de
	add hl, de
	jp FarPointerCall

SpecialsPointers::
	add_special Special_SetBitsForLinkTradeRequest ; 1
	add_special Special_WaitForLinkedFriend
	add_special Special_CheckLinkTimeout
	add_special Special_TryQuickSave
	add_special Special_CheckBothSelectedSameRoom
	add_special Special_FailedLinkToPast
	add_special Special_CloseLink
	add_special WaitForOtherPlayerToExit ; 8
	add_special Special_SetBitsForBattleRequest
	add_special Special_SetBitsForTimeCapsuleRequest
	add_special Special_CheckTimeCapsuleCompatibility
	add_special Special_EnterTimeCapsule
	add_special Special_TradeCenter
	add_special Special_Colosseum
	add_special Special_TimeCapsule
	add_special Special_CableClubCheckWhichChris ; 10
	add_special Special_FadeOutMusic
	add_special Diploma
	add_special PrintDiploma
	add_special SaveParty
	add_special RestoreParty
	add_special PushSoundstate
	add_special PopSoundstate
	add_special HealParty ; 18
	add_special PokemonCenterPC
	add_special Special_KrissHousePC
	add_special Special_DayCareMan
	add_special Special_DayCareLady
	add_special Special_DayCareManOutside
	add_special MoveDeletion
	add_special Special_SpurgeMartBank
	add_special GenericDummyFunction
	add_special SpecialNameRival
	add_special Special_TownMap
	add_special Reset
	add_special Special_FossilPuzzle
	add_special Special_SlotMachine
	add_special Special_CardFlip
	add_special Special_MemoryGame ; 28
	add_special Special_ClearBGPalettesBufferScreen
	add_special FadeOutPalettes
	add_special Special_BattleTowerFade
	add_special Special_FadeBlackQuickly
	add_special FadeInPalettes
	add_special Special_FadeInQuickly
	add_special Special_ReloadSpritesNoPalettes
	add_special ClearBGPalettes ; 30
	add_special UpdateTimePals
	add_special ClearTileMap
	add_special UpdateSprites
	add_special ReplaceKrisSprite
	add_special Special_GameCornerPrizeMonCheckDex
	add_special SpecialSeenMon
	add_special PlayMapMusic
	add_special RestartMapMusic ; 38
	add_special HealMachineAnim
	add_special Special_SurfStartStep
	add_special Special_FindGreaterThanThatLevel
	add_special Special_FindAtLeastThatHappy
	add_special Special_FindThatSpecies
	add_special Special_FindThatSpeciesYourTrainerID
	add_special Special_DayCareMon1
	add_special Special_DayCareMon2 ; 40
	add_special RefreshSprites
	add_special SpecialGiveNobusAggron
	add_special SpecialReturnNobusAggron
	add_special Special_SelectMonFromParty
	add_special SpecialCheckPokerus
	add_special Special_DisplayCoinCaseBalance
	add_special Special_DisplayMoneyAndCoinBalance
	add_special PlaceMoneyTopRight ; 48
	add_special SpecialMonCheck
	add_special Special_MoveTutor
	add_special Special_GoldenrodHappinessMoveTutor
	add_special Special_SetPlayerPalette
	add_special NameRater
	add_special Special_DisplayLinkRecord
	add_special GetFirstPokemonHappiness ; 50
	add_special CheckFirstMonIsEgg
	add_special RunSpritesCallback
	add_special PlaySlowCry
	add_special LoadMapPalettes
	add_special Special_YoungerHaircutBrother
	add_special Special_OlderHaircutBrother
	add_special InitRoamMons
	add_special PlayCurMonCry ; 58
	add_special MoveRelearner
	add_special ConvertDayToText

Special_SetPlayerPalette:
	ldh a, [hScriptVar]
	ld d, a
	jpba SetPlayerPalette

Special_GameCornerPrizeMonCheckDex:
	ldh a, [hScriptVar]
	dec a
	call CheckCaughtMon
	ret nz
	ldh a, [hScriptVar]
	dec a
	call SetSeenAndCaughtMon
	call FadeToMenu
	ldh a, [hScriptVar]
	ld [wd265], a
	callba NewPokedexEntry
	jp ExitAllMenus

SpecialSeenMon:
	ldh a, [hScriptVar]
	dec a
	jp SetSeenMon

Special_FindGreaterThanThatLevel:
	ldh a, [hScriptVar]
	ld b, a
	callba _FindGreaterThanThatLevel
	jr CheckSpecialSearchResults

Special_FindAtLeastThatHappy:
	ldh a, [hScriptVar]
	ld b, a
	callba _FindAtLeastThatHappy
	jr CheckSpecialSearchResults

Special_FindThatSpecies:
	ldh a, [hScriptVar]
	ld b, a
	callba _FindThatSpecies
	jr CheckSpecialSearchResults

Special_FindThatSpeciesYourTrainerID:
	ldh a, [hScriptVar]
	ld b, a
	callba _FindThatSpeciesYourTrainerID
	; fallthrough

CheckSpecialSearchResults:
	ld a, TRUE
	jr nz, .ok
	xor a
.ok
	ldh [hScriptVar], a
	ret

SpecialNameRival:
	ld b, 2 ; rival
	ld de, wRivalName
	callba _NamingScreen
	; default to "Bronze"
	ld hl, wRivalName
	ld de, DefaultRivalName
	jp InitName

DefaultRivalName:
	db "Bronze@"

Special_TownMap:
	call FadeToMenu
	callba _TownMap
	jp ExitAllMenus

Special_DisplayLinkRecord:
	call FadeToMenu
	callba DisplayLinkRecord
	jp ExitAllMenus

Special_KrissHousePC:
	xor a
	ldh [hScriptVar], a
	callba _KrissHousePC
	ld a, c
	ldh [hScriptVar], a
	ret

Special_FossilPuzzle:
	call FadeToMenu
	callba FossilPuzzle
	ld a, [wSolvedFossilPuzzle]
	ldh [hScriptVar], a
	jp ExitAllMenus

Special_SlotMachine:
	call Special_CheckCoins
	ret c
	ld a, BANK(_SlotMachine)
	ld hl, _SlotMachine
	jr Special_StartGameCornerGame

Special_CardFlip:
	call Special_CheckCoins
	ret c
	ld a, BANK(_CardFlip)
	ld hl, _CardFlip
	jr Special_StartGameCornerGame

Special_MemoryGame:
	call Special_CheckCoins
	ret c
	ld a, BANK(MemoryGame)
	ld hl, MemoryGame
; fallthrough

Special_StartGameCornerGame:
	call FarQueueScript
	call FadeToMenu
	ld hl, wQueuedScriptBank
	call FarPointerCall
	jp ExitAllMenus

Special_CheckCoins:
	ld hl, wCoins
	ld a, [hli]
	or [hl]
	jr z, .no_coins
	ld a, COIN_CASE
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	ld hl, .NoCoinCaseText
	jr nc, .print
	and a
	ret

.no_coins
	ld hl, .NoCoinsText

.print
	call PrintText
	scf
	ret

.NoCoinsText
	; You have no coins.
	text_jump NoCoinsText

.NoCoinCaseText
	; You don't have a COIN CASE.
	text_jump NoCoinCaseText

Special_ClearBGPalettesBufferScreen:
	call ClearBGPalettes
	jp BufferScreen

StoreSwarmMapIndices::
	ld a, c
	and a
	jr nz, .yanma
; swarm dark cave violet entrance
	ld a, d
	ld [wDunsparceMapGroup], a
	ld a, e
	ld [wDunsparceMapNumber], a
	ret

.yanma
	ld a, d
	ld [wYanmaMapGroup], a
	ld a, e
	ld [wYanmaMapNumber], a
	ret

SpecialCheckPokerus:
; Check if a monster in your party has Pokerus
	callba CheckPokerus
	sbc a
	and 1
	ldh [hScriptVar], a
	ret

PlayCurMonCry:
	ld a, [wCurPartySpecies]
	jp PlayCry

Special_FadeOutMusic:
	ld a, 2
	ld [wMusicFade], a
ForceMapMusicRestart::
	xor a
	ld [wMusicFadeIDLo], a
	ld [wMusicFadeIDHi], a
	ld [wMapMusic], a
	ret

Diploma:
	call FadeToMenu
	callba _Diploma
	jp ExitAllMenus

PrintDiploma:
	call FadeToMenu
	callba _PrintDiploma
	jp ExitAllMenus

SaveParty::
	ld de, wPartyBackup
	ld hl, wPokemonData
	ln a, BANK(wPartyBackup), BANK(wPokemonData)
	jr FinishSaveRestoreParty

RestoreParty::
	ld de, wPokemonData
	ld hl, wPartyBackup
	ln a, BANK(wPokemonData), BANK(wPartyBackup)
FinishSaveRestoreParty:
	ld bc, wPartyMonNicknamesEnd - wPokemonData
	jp DoubleFarCopyWRAM

Special_SurfStartStep::
	call InitMovementBuffer
	call .GetMovementData
	call AppendToMovementBuffer
	ld a, movement_step_end
	jp AppendToMovementBuffer

.GetMovementData
	ld a, [wPlayerDirection]
	srl a
	srl a
	and 3
	ld e, a
	ld d, 0
	ld hl, .movement_data
	add hl, de
	ld a, [hl]
	ret

.movement_data
	slow_step_down
	slow_step_up
	slow_step_left
	slow_step_right

ConvertDayToText:
	call GetWeekday
	ld hl, .day_names
	call GetNthString
	ld d, h
	ld e, l
	ld hl, wStringBuffer3
	call CopyName2
	ld de, .day_string
	jp CopyName2

.day_names
	db "Sun@Mon@Tues@Wednes@Thurs@Fri@Satur@"
.day_string
	db "day@"
