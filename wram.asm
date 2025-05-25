INCLUDE "includes.asm"
INCLUDE "macros/wram.asm"
INCLUDE "hram.asm"
INCLUDE "vram.asm"

SECTION "Version check", WRAM0
wBuildNumberCheck:: ; c000

SECTION "Stack", WRAM0
wc000::
wStackBottom::
	ds $100 - 1
wStack::
wStackTop::
	ds 1


SECTION "Audio WRAM", WRAM0
wMusic::
wMusicPlaying:: ; c100
; nonzero if playing
	ds 1

wChannels::
wChannel1:: channel_struct wChannel1 ; c101
wChannel2:: channel_struct wChannel2 ; c133
wChannel3:: channel_struct wChannel3 ; c165
wChannel4:: channel_struct wChannel4 ; c197

wSFXChannels::
wChannel5:: channel_struct wChannel5 ; c1c9
wChannel6:: channel_struct wChannel6 ; c1fb
wChannel7:: channel_struct wChannel7 ; c22d
wChannel8:: channel_struct wChannel8 ; c25f
wChannelsEnd::
	ds 1 ; c291
wCurTrackDuty:: ds 1
wCurTrackIntensity:: ds 1
wCurTrackFrequency:: dw
wc296:: ds 1 ; BCD value, dummied out
wCurNoteDuration:: ds 1

wCurMusicByte:: ; c298
	ds 1
wCurChannel:: ; c299
	ds 1
wVolume:: ; c29a
; corresponds to $ff24
; Channel control / ON-OFF / Volume (R/W)
;   bit 7 - Vin->SO2 ON/OFF
;   bit 6-4 - SO2 output level (volume) (# 0-7)
;   bit 3 - Vin->SO1 ON/OFF
;   bit 2-0 - SO1 output level (volume) (# 0-7)
	ds 1
wSoundOutput:: ; c29b
; corresponds to $ff25
; bit 4-7: ch1-4 so2 on/off
; bit 0-3: ch1-4 so1 on/off
	ds 1
wSoundInput:: ; c29c
; corresponds to $ff26
; bit 7: global on/off
; bit 0: ch1 on/off
; bit 1: ch2 on/off
; bit 2: ch3 on/off
; bit 3: ch4 on/off
	ds 1

wMusicID::
wMusicIDLo:: ; c29d
	ds 1
wMusicIDHi:: ; c29e
	ds 1
wMusicBank:: ; c29f
	ds 1
wNoiseSampleAddress::
wNoiseSampleAddressLo:: ; c2a0
	ds 1
wNoiseSampleAddressHi:: ; c2a1
	ds 1
wNoiseSampleDelay:: ; noise delay? ; c2a2
	ds 1
; c2a3
	ds 1
wMusicNoiseSampleSet:: ; c2a4
	ds 1
wSFXNoiseSampleSet:: ; c2a5
	ds 1
wLowHealthAlarm:: ; c2a6
; bit 7: on/off
; bit 4: pitch
; bit 0-3: counter
	ds 1
wMusicFade:: ; c2a7
; fades volume over x frames
; bit 7: fade in/out
; bit 0-5: number of frames for each volume level
; $00 = none (default)
	ds 1
wMusicFadeCount:: ; c2a8
	ds 1
wMusicFadeID::
wMusicFadeIDLo:: ; c2a9
	ds 1
wMusicFadeIDHi:: ; c2aa
	ds 1

	ds 5

wCryPitch:: ; c2b0
	ds 2
wCryLength:: ; c2b2
	ds 2
wLastVolume:: ; c2b4
	ds 1
wc2b5:: ds 1
wSFXPriority:: ; c2b6
; if nonzero, turn off music when playing sfx
	ds 1

	ds 5

wStereoPanningMask:: ds 1
wCryTracks:: ; c2bd
; plays only in left or right track depending on what side the monster is on
; both tracks active outside of battle
	ds 1
wSFXDuration:: ds 1
wCurSFX:: ; c2bf
; id of sfx currently playing
	ds 1

wMapMusic:: ; c2c0
	ds 1

wDontPlayMapMusicOnReload:: ds 1
wMusicEnd::

SECTION "WRAM 0", WRAM0

wPartyMenuItemEffectPointer::
	ds 2
wSavedPartyMenuActionText::
	ds 1

wMonPicTileCount::
	ds 1

wBoxAlignment:: ds 1

wMemoryGameLastMatches:: ds 5

wMonStatusFlags:: ds 1
wGameLogicPause:: ds 1
wSpriteUpdatesEnabled:: ds 1
wMapTimeOfDay:: ds 1

wTextEndPointer:: ds 2

wCurrentStableRNGSeedFrame:: ds 1
wCurrentStableRNGSeedIndex:: ds 1

wPrinterConnectionOpen:: ds 1 ; related to printer
wPrinterDataJumptableIndex:: ds 1 ; related to printer
wLastDexEntry:: ds 1
wLinkSuppressTextScroll:: ds 1 ; related to link comms

wCurrentLandmark:: ds 1
wLastLandmark:: ds 1
wMapSignTimer:: ds 1
wMapSignRoutineIdx:: ds 1

wLinkMode:: ; c2dc
; 0 not in link battle
; 1 link battle
; 4 mobile battle
	ds 1

	ds 3

wPlayerNextMovement:: ds 1
wPlayerMovement:: ds 1
wMovementBuffer1::
wMovementPerson:: ds 1
wMovementDataPointer:: ds 3 ; dba
wMovementBuffer2:: ds 4
wMovementByteWasControlSwitch:: ds 1
wMovementPointer:: ds 2 ; c2eb

; do not put anything here, cleared in some movement function
	ds 2

	ds 1

wTempObjectCopyMapObjectIndex:: ds 1 ; c2f0
wTempObjectCopySprite:: ds 1 ; c2f1
wTempObjectCopySpriteVTile:: ds 1 ; c2f2
wTempObjectCopyPalette:: ds 1 ; c2f3
wTempObjectCopyMovement:: ds 1 ; c2f4
wTempObjectCopyRange:: ds 1 ; c2f5
wTempObjectCopyX:: ds 1 ; c2f6
wTempObjectCopyY:: ds 1 ; c2f7
wTempObjectCopyRadius:: ds 1 ; c2f8
wTempObjectCopySpritesAddr::
	ds 1

wTileDown:: ; c2fa
	ds 1
wTileUp:: ; c2fb
	ds 1
wTileLeft:: ; c2fc
	ds 1
wTileRight:: ; c2fd
	ds 1

wTilePermissions:: ; c2fe
; set if tile behavior prevents
; you from walking in that direction
; bit 3: down
; bit 2: up
; bit 1: left
; bit 0: right
	ds 1

wOptionsBackup:: ds 1

SECTION "WRAM Sprite Animations", WRAM0
; wc300 - wc313 is a 10x2 dictionary.
; keys: taken from third column of SpriteAnimSeqData
; values: VTiles
wSpriteAnimDict:: ds 10 * 2

wSpriteAnimationStructs::

MACRO sprite_anim_struct
\1Index:: ds 1          ; 0
\1FramesetID:: ds 1     ; 1
\1AnimSeqID:: ds 1      ; 2
\1TileID:: ds 1         ; 3
\1XCoord:: ds 1         ; 4
\1YCoord:: ds 1         ; 5
\1XOffset:: ds 1        ; 6
\1YOffset:: ds 1        ; 7
\1Duration:: ds 1       ; 8
\1DurationOffset:: ds 1 ; 9
\1FrameIndex:: ds 1     ; a
\1Sprite0b:: ds 1
\1Sprite0c:: ds 1
\1Sprite0d:: ds 1
\1Sprite0e:: ds 1
\1Sprite0f:: ds 1
ENDM

; Field  0: Index
; Fields 1-3: Loaded from SpriteAnimSeqData
wSpriteAnim1:: sprite_anim_struct wSpriteAnim1
wSpriteAnim2:: sprite_anim_struct wSpriteAnim2
wSpriteAnim3:: sprite_anim_struct wSpriteAnim3
wSpriteAnim4:: sprite_anim_struct wSpriteAnim4
wSpriteAnim5:: sprite_anim_struct wSpriteAnim5
wSpriteAnim6:: sprite_anim_struct wSpriteAnim6
wSpriteAnim7:: sprite_anim_struct wSpriteAnim7
wSpriteAnim8:: sprite_anim_struct wSpriteAnim8
wSpriteAnim9:: sprite_anim_struct wSpriteAnim9
wSpriteAnim10:: sprite_anim_struct wSpriteAnim10
wSpriteAnimationStructsEnd::

wSpriteAnimCount:: ds 1
wCurrSpriteOAMAddr:: ds 1

wCurIcon:: ; c3b6
	ds 1


wCurIconTile:: ds 1
wSpriteAnimAddrBackup::
wSpriteAnimIDBuffer::
wCurrSpriteAddSubFlags::
	ds 2
wCurrAnimVTile:: ds 1
wCurrAnimXCoord:: ds 1
wCurrAnimYCoord:: ds 1
wCurrAnimXOffset:: ds 1
wCurrAnimYOffset:: ds 1
wGlobalAnimYOffset:: ds 1
wGlobalAnimXOffset:: ds 1
wSpriteAnimsEnd::

wPrintTextInitialSP:: ds 2
wPrintTextInitialBank:: ds 1
wPrintTextSavedSource:: ds 2
wPrintTextSavedDest:: ds 2
wPlaceStringInitialSP:: ds 2
wPlaceStringInitialBank:: ds 1
wPlaceStringSavedSource:: ds 2
wPlaceStringSavedDest:: ds 2

wCrashPrintAsmRegBuffer:: ds 6
wInvalidBuildNumberTerminator:: ds 1

wInitialScriptBank:: ds 1
wInitialScriptPos:: ds 2
wLastScriptJumpSrcBank:: ds 1
wLastScriptJumpSrcPos:: ds 2
wLastScriptJumpDestBank:: ds 1
wLastScriptJumpDestPos:: ds 2
wLastSEndIfBank:: ds 1
wLastSEndIfPos:: ds 2
wScriptConditionalCondition:: ds 1
wScriptConditionalInitialPos:: ds 2
wScriptConditionalRecursionFlag:: ds 1

SECTION "Sprites WRAM", WRAM0

wSprites:: ; c400
; 4 bytes per sprite
; 40 sprites
; struct:
;	y (px)
;	x (px)
;	tile id
;	attributes:
;		bit 7: priority
;		bit 6: y flip
;		bit 5: x flip
;		bit 4: pal # (non-cgb)
;		bit 3: vram bank (cgb only)
;		bit 2-0: pal # (cgb only)
	ds 4 * 40
wSpritesEnd::


SECTION "Tilemap", WRAM0

wTileMap:: ; c4a0
; 20x18 grid of 8x8 tiles
	ds SCREEN_WIDTH * SCREEN_HEIGHT
wTileMapEnd::


SECTION "Battle", WRAM0
wMisc::

UNION ; 1: c608
wc608::
wOddEgg:: party_struct wOddEgg
wOddEggName:: ds PKMN_NAME_LENGTH
wOddEggOTName:: ds PKMN_NAME_LENGTH
NEXTU ; 1: c608

wBTOTTemp:: battle_tower_struct wBTOTTemp
NEXTU ; 1: c608

	hall_of_fame wHallOfFameTemp
NEXTU ; 1: c608

wWeakestToStrongestMonList::
	ds 7

wPokemonDataMisc::

wPartyCountMisc::
	ds 1
wPartySpeciesMisc::
	ds PARTY_LENGTH
wPartyEndMisc::
	ds 1

wPartyMonsMisc::
wPartyMon1Misc:: party_struct wPartyMon1Misc
wPartyMon2Misc:: party_struct wPartyMon2Misc
wPartyMon3Misc:: party_struct wPartyMon3Misc
wPartyMon4Misc:: party_struct wPartyMon4Misc
wPartyMon5Misc:: party_struct wPartyMon5Misc
wPartyMon6Misc:: party_struct wPartyMon6Misc

wPartyMonOTMisc:: ds NAME_LENGTH * PARTY_LENGTH

wPartyMonNicknamesMisc:: ds PKMN_NAME_LENGTH * PARTY_LENGTH
wPokemonDataMiscEnd::

NEXTU ; 1: c608

wTempOreCaseInventory:: ds 1 + 10 * 2 + 1
wTotalOrePrices:: ds 3
NEXTU ; 1: c608

wTempTokenTrackerOverworldInventory:: ds 1 + 65
wTempTokenTrackerBingoInventory:: ds 1 + 3
wTempTokenTrackerMersonInventory:: ds 1 + 8
wTokenTrackerOverworldTokensCount:: ds 1
wTokenTrackerBingoTokensCount:: ds 1
wTokenTrackerMersonTokensCount:: ds 1

wTokenTrackerPage:: ds 1

wTokenTrackerCursorState::
wTokenTrackerOverworldCursor:: ds 1
wTokenTrackerOverworldScrollPosition:: ds 1
wTokenTrackerBingoCursor:: ds 1
wTokenTrackerBingoScrollPosition:: ds 1
wTokenTrackerMersonCursor:: ds 1
wTokenTrackerMersonScrollPosition:: ds 1
wTokenTrackerCursorStateEnd::

wTokenTrackerPageTotal:: ds 1

UNION ; 2: c662
wTotalTokensCount:: ds 1
NEXTU ; 2: c662

wTimesetCursorPosition::
	ds 1
wIsTimeMachine::
wCompletedDateTimeSet::
	ds 1
wJumptableIndexAndBufferVarsTemp::
	ds 7
wc612::
	ds 10
ENDU ; 2: c662
NEXTU ; 1: c608

wBattle::
wEnemyMoveStruct::  move_struct wEnemyMoveStruct ; c608
wPlayerMoveStruct:: move_struct wPlayerMoveStruct ; c60f

wEnemyMonNick::  ds PKMN_NAME_LENGTH ; c616
wBattleMonNick:: ds PKMN_NAME_LENGTH ; c621

wBattleMon:: battle_struct wBattleMon ; c62c

wSavedDamage:: ds 2; c64c

wWildMon:: ds 1 ; c64e

wStatEXPMultiplier:: ds 1

wEnemyTrainerItem1:: ds 1 ; c650
wEnemyTrainerItem2:: ds 1 ; c651
wEnemyTrainerBaseReward:: ds 1 ; c652
wEnemyTrainerAIFlags:: ds 3 ; c653
wOTClassName:: ds TRAINER_CLASS_NAME_LENGTH ; c656

wCurOTMon:: ; c663
	ds 1

wBattleParticipantsNotFainted::
; Bit array.  Bits 0 - 5 correspond to party members 1 - 6.
; Bit set if the mon appears in battle.
; Bit cleared if the mon faints.
; Backed up if the enemy switches.
; All bits cleared if the enemy faints.
	ds 1

wTypeModifier:: ; c665
; >10: super-effective
;  10: normal
; <10: not very effective
; bit 7: stab
	ds 1

wCriticalHitOrOHKO:: ; c666
; 0 if not critical
; 1 for a critical hit
; 2 for a OHKO
	ds 1

wAttackMissed:: ; c667
; nonzero for a miss
	ds 1

wPlayerSubStatus1:: ; c668
; bit
; 7 attract
; 6 encore
; 5 endure
; 4 perish song
; 3 identified
; 2 protect
; 1 curse
; 0 nightmare
	ds 1
wPlayerSubStatus2:: ; c669
; bit
; 7 sturdy
; 6 unburden
; 4 flash fire
; 4 ability changed
; 3 guarding
; 2 final chance
; 1 curled
; 0 fatigued
	ds 1
wPlayerSubStatus3:: ; c66a
; bit
; 7 confused
; 6 flying
; 5 underground
; 4 charged
; 3 flinch
; 2 in loop
; 1 rollout
; 0 bide
	ds 1
wPlayerSubStatus4:: ; c66b
; bit
; 7 leech seed
; 6 rage
; 5 recharge
; 4 substitute
; 3
; 2 focus energy
; 1 mist
; 0 bide: unleashed energy
	ds 1
wPlayerSubStatus5:: ; c66c
; bit
; 7 cant run
; 6 destiny bond
; 5 lock-on
; 4 encore
; 3 transformed
; 2
; 1
; 0 toxic
	ds 1

wEnemySubStatus1:: ; c66d
; see wPlayerSubStatus1
	ds 1
wEnemySubStatus2:: ; c66e
; see wPlayerSubStatus2
	ds 1
wEnemySubStatus3:: ; c66f
; see wPlayerSubStatus3
	ds 1
wEnemySubStatus4:: ; c670
; see wPlayerSubStatus4
	ds 1
wEnemySubStatus5:: ; c671
; see wPlayerSubStatus5
	ds 1

wPlayerRolloutCount:: ; c672
	ds 1
wPlayerConfuseCount:: ; c673
	ds 1
wPlayerToxicCount:: ; c674
	ds 1
wPlayerDisableCount:: ; c675
	ds 1
wPlayerEncoreCount:: ; c676
	ds 1
wPlayerPerishCount:: ; c677
	ds 1
wPlayerFuryCutterCount:: ; c678
	ds 1
wPlayerProtectCount:: ; c679
	ds 1

wEnemyRolloutCount:: ; c67a
	ds 1
wEnemyConfuseCount:: ; c67b
	ds 1
wEnemyToxicCount:: ; c67c
	ds 1
wEnemyDisableCount:: ; c67d
	ds 1
wEnemyEncoreCount:: ; c67e
	ds 1
wEnemyPerishCount:: ; c67f
	ds 1
wEnemyFuryCutterCount:: ; c680
	ds 1
wEnemyProtectCount:: ; c681
	ds 1

wPlayerDamageTaken:: ; c682
	ds 2
wEnemyDamageTaken:: ; c684
	ds 2

wBattleReward:: ds 3 ; c686
wBattleAnimParam:: ds 1 ; c689
wBattleScriptBuffer:: ; c68a
	ds 40

wBattleScriptBufferLoc:: ; c6b2
	ds 2

wTurnEnded:: ds 1 ; c6b4
	ds 1

wPlayerStats:: ; c6b6
	ds 10
	ds 1
wEnemyStats:: ; c6c1
	ds 10
	ds 1

wPlayerStatLevels:: ; c6cc
; 07 neutral
wPlayerAtkLevel:: ; c6cc
	ds 1
wPlayerDefLevel:: ; c6cd
	ds 1
wPlayerSpdLevel:: ; c6ce
	ds 1
wPlayerSAtkLevel:: ; c6cf
	ds 1

UNION ; 2: c6d0
wc6d0::
wPlayerSDefLevel:: ; c6d0
	ds 1
wPlayerAccLevel:: ; c6d1
	ds 1
wPlayerEvaLevel:: ; c6d2
	ds 1
wPlayerAbility:: ; c6d3
	ds 1
wPlayerStatLevelsEnd::

wEnemyStatLevels:: ; c6d4
; 07 neutral
wEnemyAtkLevel:: ; c6d4
	ds 1
wEnemyDefLevel:: ; c6d5
	ds 1
wEnemySpdLevel:: ; c6d6
	ds 1
wEnemySAtkLevel:: ; c6d7
	ds 1
wEnemySDefLevel:: ; c6d8
	ds 1
wEnemyAccLevel:: ; c6d9
	ds 1
wEnemyEvaLevel:: ; c6da
	ds 1
wEnemyAbility:: ; c6db
	ds 1
wEnemyTurnsTaken:: ; c6dc
	ds 1
wPlayerTurnsTaken:: ; c6dd
	ds 1

wBattleTurnTemp:: ; c6de
	ds 1

wPlayerSubstituteHP:: ; c6df
	ds 1
wEnemySubstituteHP:: ; c6e0
	ds 1

	ds 2

wCurPlayerMove:: ; c6e3
	ds 1
wCurEnemyMove:: ; c6e4
	ds 1

wLinkBattleRNCount:: ; c6e5
; how far through the prng stream
	ds 1

wEnemyItemState:: ds 1 ; c6e6

	ds 2

wCurEnemyMoveNum:: ds 1 ; c6e9

wEnemyHPAtTimeOfPlayerSwitch:: ds 2 ; c6ea

	ds 6

wEnemyBackupDVs:: ds 2; used when enemy is transformed

wAlreadyDisobeyed:: ; c6f4
	ds 1
wDisabledMove:: ; c6f5
	ds 1
wEnemyDisabledMove:: ; c6f6
	ds 1

wWhichMonFaintedFirst:: ds 1

; exists so you can't counter on switch
wLastEnemyCounterMove:: ; c6f8
	ds 1
wLastPlayerCounterMove:: ; c6f9
	ds 1

wEnemyMinimized:: ds 1 ; c6fa

wAlreadyFailed:: ; c6fb
	ds 1

wBattleParticipantsIncludingFainted:: ds 1 ; c6fc
wBattleLowHealthAlarm:: ds 1 ; c6fd
wPlayerMinimized:: ds 1 ; c6fe
wPlayerScreens:: ; c6ff
; bit
; 4 reflect
; 3 light screen
; 2 safeguard
; 0 spikes
	ds 1

wEnemyScreens:: ; c700
; see wPlayerScreens
	ds 1

wPlayerSafeguardCount:: ; c701
	ds 1
wPlayerLightScreenCount:: ; c702
	ds 1
wPlayerReflectCount:: ; c703
	ds 1

wTempAIAbility:: ; c704
	ds 1

wEnemySafeguardCount:: ; c705
	ds 1
wEnemyLightScreenCount:: ; c706
	ds 1
wEnemyReflectCount:: ; c707
	ds 1

wEnemyAlreadyDisobeyed::
	ds 1

wBattleTurns::
	ds 1

wWeather:: ; c70a
; 00 normal
; 01 rain
; 02 sun
; 03 sandstorm
; 04 hail
; 05 rain stopped
; 06 sunlight faded
; 07 sandstorm subsided
; 08 hail stopped
	ds 1

wWeatherCount:: ; c70b
; # turns remaining
	ds 1

wRaisedStat::
wLoweredStat:: ; c70c
	ds 1
wEffectFailed:: ; c70d
	ds 1
wFailedMessage:: ; c70e
	ds 1
wEnemyGoesFirst:: ; c70f
	ds 1
wPlayerIsSwitching:: ds 1 ; c710
wEnemyIsSwitching::  ds 1 ; c711

wPlayerUsedMoves:: ; c712
; add a move that has been used once by the player
; added in order of use
	ds NUM_MOVES

wEnemyAISwitchScore:: ds 1 ; c716
wEnemySwitchMonParam:: ds 1 ; c717
wEnemySwitchMonIndex:: ds 1 ; c718
wTempLevel:: ds 1 ; c719
wLastPlayerMon:: ds 1 ; c71a
wLastPlayerMove:: ; c71b
	ds 1
wLastEnemyMove:: ; c71c
	ds 1

wPlayerFutureSightCount:: ds 1 ; c71d
wPlayerFutureSightLevel:: ds 1
wEnemyFutureSightCount:: ds 1 ; c71e
wEnemyFutureSightLevel:: ds 1
wGivingExperienceToExpShareHolders:: ds 1 ; c71f
wBackupEnemyMonBaseStats:: ds 5 ; c720
wBackupEnemyMonCatchRate:: db ; c725
wBackupEnemyMonBaseExp:: db ; c726
wPlayerFutureSightUsersSpAtk:: ds 2 ; c727
wEnemyFutureSightUsersSpAtk:: ds 2 ; c729
wPlayerRageCounter:: ds 1 ; c72b
wEnemyRageCounter:: ds 1 ; c72c
wBeatUpHitAtLeastOnce:: ds 1 ; c72d
wPlayerTrappingMove:: ds 1 ; c72e
wEnemyTrappingMove:: ds 1 ; c72f
wPlayerWrapCount:: ds 1 ; c730
wEnemyWrapCount:: ds 1 ; c731
wPlayerCharging:: ds 1 ; c732
wEnemyCharging:: ds 1 ; c733
wBattleEnded:: ; c734
	ds 1

wWildMonMoves:: ds NUM_MOVES ; c735
wWildMonPP:: ds NUM_MOVES ; c739
wAmuletCoin:: ds 1 ; c73a
wSomeoneIsRampaging:: ds 1 ; c73b
wPlayerJustGotFrozen:: ds 1 ; c73c
wEnemyJustGotFrozen:: ds 1 ; c73d

wPlayerJustSentMonOut:: ds 1
wEnemyJustSentMonOut:: ds 1
wBattleEnd::
; Battle RAM

; c741
NEXTU ; 2: c6d0
wTrademons::
wPlayerTrademon:: trademon wPlayerTrademon
wOTTrademon::     trademon wOTTrademon
wTrademonsEnd::
wTradeAnimPointer::
	ds 2
wLinkPlayer1Name:: ds NAME_LENGTH
wLinkPlayer2Name:: ds NAME_LENGTH
wLinkTradeSendmonSpecies:: ds 1
wLinkTradeGetmonSpecies:: ds 1
NEXTU ; 2: c6d0

; naming screen
wNamingScreenDestinationPointer:: ds 2 ; c6d0
wNamingScreenCurrNameLength:: ds 1 ; c6d2
wNamingScreenMaxNameLength:: ds 1 ; c6d3
wNamingScreenType:: ds 1 ; c6d4
wNamingScreenCursorObjectPointer:: ds 2 ; c6d5
wNamingScreenLastCharacter:: ds 1 ; c6d7
wNamingScreenStringEntryCoord:: ds 2 ; c6d8
NEXTU ; 2: c6d0

; town map
wTownMapRegion:: ds 1 ; c6d0
wTownMapCursorX:: ds 1
wTownMapCursorY:: ds 1
NEXTU ; 2: c6d0

wSlots::
; Slot Machine
; c6d0
wReel1:: slot_reel wReel1
wReel2:: slot_reel wReel2
wReel3:: slot_reel wReel3
; c700
wReel1Stopped:: ds 3
wReel2Stopped:: ds 3
wReel3Stopped:: ds 3
wSlotBias:: ds 1
wSlotBet:: ds 1
wFirstTwoReelsMatching:: ds 1
wFirstTwoReelsMatchingSevens:: ds 1
wSlotMatched:: ds 1
wCurrReelStopped:: ds 3
wPayout:: ds 2
wCurrReelXCoord:: ds 1
wCurrReelYCoord:: ds 1
	ds 2
wSlotBuildingMatch:: ds 1
wSlotsDataEnd::
	ds 28
wSlotsEnd::
NEXTU ; 2: c6d0

; Card Flip
; c6d0
wCardFlip::
wDeck:: ds 24
wDeckEnd::
; c6e8
wCardFlipNumCardsPlayed:: ds 1
wCardFlipFaceUpCard:: ds 1
wDiscardPile:: ds 24
wDiscardPileEnd::
wCardFlipEnd::
NEXTU ; 2: c6d0

; Memory Game
; c6d0
wMemoryGame::
wMemoryGameCards:: ds 9 * 5
wMemoryGameCardsEnd::
wMemoryGameLastCardPicked:: ds 1 ; c6fd
wMemoryGameCard1:: ds 1 ; c6fe
wMemoryGameCard2:: ds 1 ; c6ff
wMemoryGameCard1Location:: ds 1 ; c700
wMemoryGameCard2Location:: ds 1 ; c701
wMemoryGameTriesRemaining:: ds 1 ; c702
wMemoryGameCounter:: ds 1 ; c708
wMemoryGameNumCardsMatched:: ds 1 ; c709
wMemoryGameEnd::
NEXTU ; 2: c6d0

; Fossil Puzzle
wFossilPuzzle::
wPuzzlePieces::
	ds 6 * 6
wFossilPuzzleEnd::

NEXTU ; 2: c6d0

; Bingo
; c6d0

wBingo::

wBingoCursorX:: ds 1
wBingoCursorY:: ds 1

wBingoCursorPointer:: ds 2

wBingoCurrentCell:: ds 1

wBingoEnd::
NEXTU ; 2: c6d0

wPokedexTownMapRegion:: ds 1

wPokedexDataStart::
wPokedexOrder:: ds NUM_POKEMON
wPokedexOrderEnd:: ds 256 - NUM_POKEMON
wPokedexMetadata::
wDexListingScrollOffset:: ; offset of the first displayed entry from the start
	ds 1
wDexListingCursor::
	ds 1 ; Dex cursor
wDexListingEnd::
	ds 1 ; Last mon to display
wDexListingHeight:: ; number of entries displayed at once in the dex listing
	ds 1

wDexSearchMonType1:: ds 1 ; first type to search
wDexSearchMonType2:: ds 1 ; second type to search
wDexSearchResultCount:: ds 1
wDexArrowCursorPosIndex:: ds 1
wDexArrowCursorDelayCounter:: ds 1
wDexArrowCursorBlinkCounter:: ds 1
wDexSearchSlowpokeFrame:: ds 1
	ds 3

wDexConvertedMonType:: ds 1 ; mon type converted from dex search mon type
wSearchBackupDexListingScrollOffset:: ds 1
wSearchBackupDexListingCursor:: ds 1
wBackupDexListingCursor::
	ds 1
wBackupDexListingPage::
	ds 1
wDexCurrentLocation::
	ds 1
wPokedexStatus::
	ds 1
wPokedexDataEnd::
	ds 2

ENDU ; 2: c6d0
ENDU ; 1: c608
wMiscEnd::

wCurrentDamageData::
wCurDamage:: ds 2 ; c7e8
wCurDamageMovePowerNumerator:: ds 2 ; c7ea
wCurDamageMovePowerDenominator:: ds 1 ; c7ec
wCurDamageLevel:: ds 1 ; c7ed
wCurDamageItemModifier:: ds 1 ; c7ee
wCurDamageFlags:: ds 1 ; c7ef - bit 7: fixed damage, bit 6: dirty, bit 5-4: x1.5 damage mods (crits), bit 3-2: x1.5 defense mods, bit 1-0: x1.5 attack mods
wCurDamageFixedValue::
wCurDamageAttack:: ds 2 ; c7f0
wCurDamageDefense:: ds 2 ; c7f2
wCurDamageShiftCount:: ds 1 ; c7f4 - signed!
wCurDamageRandomVariance:: ds 1 ; c7f5 - complemented (variance: *(100 - this value)/100)
wCurDamageModifierNumerator:: ds 3 ; c7f6
wCurDamageModifierDenominator:: ds 2 ; c7f9
wCurrentDamageDataEnd::

wWildMonCustomItem::
	ds 1

wWildMonCustomMoves::
	ds NUM_MOVES

SECTION "Overworld Map", WRAM0
UNION ; 1: c800
wOverworldMap:: ; c800
	ds 1300
wOverworldMapEnd::
NEXTU ; 1: c800

wBillsPCPokemonList::
; Pokemon, box number, list index

wMysteryGiftPartyTemp:: ; ds PARTY_LENGTH * (1 + 1 + NUM_MOVES)
wMysteryGiftStaging::

wLinkData:: ; ds $514
wLinkPlayerName:: ds NAME_LENGTH
wLinkPartyCount:: ds 1
wLinkPartySpecies:: ds PARTY_LENGTH
wLinkPartySpeciesEnd:: ds 1

UNION ; 2: c813
wTimeCapsulePlayerData::
wTimeCapsulePartyMon1:: red_party_struct wTimeCapsulePartyMon1
wTimeCapsulePartyMon2:: red_party_struct wTimeCapsulePartyMon2
wTimeCapsulePartyMon3:: red_party_struct wTimeCapsulePartyMon3
wTimeCapsulePartyMon4:: red_party_struct wTimeCapsulePartyMon4
wTimeCapsulePartyMon5:: red_party_struct wTimeCapsulePartyMon5
wTimeCapsulePartyMon6:: red_party_struct wTimeCapsulePartyMon6
wTimeCapsulePartyMonOTNames:: ds PARTY_LENGTH * NAME_LENGTH
wTimeCapsulePartyMonNicks:: ds PARTY_LENGTH * PKMN_NAME_LENGTH
wTimeCapsulePlayerDataEnd::
NEXTU ; 2: c813

wLinkPlayerData::
wLinkPlayerPartyMon1:: party_struct wLinkPlayerPartyMon1
wLinkPlayerPartyMon2:: party_struct wLinkPlayerPartyMon2
wLinkPlayerPartyMon3:: party_struct wLinkPlayerPartyMon3
wLinkPlayerPartyMon4:: party_struct wLinkPlayerPartyMon4
wLinkPlayerPartyMon5:: party_struct wLinkPlayerPartyMon5
wLinkPlayerPartyMon6:: party_struct wLinkPlayerPartyMon6
wLinkPlayerPartyMonOTNames:: ds PARTY_LENGTH * NAME_LENGTH
wLinkPlayerPartyMonNicks:: ds PARTY_LENGTH * PKMN_NAME_LENGTH
wLinkPlayerDataEnd:: ; c9b7
ENDU ; 2: c813
	ds $35d

wLinkDataEnd::
NEXTU ; 1: c800

	ds $50

wMysteryGiftTrainerData:: ds (1 + 1 + NUM_MOVES) * PARTY_LENGTH + 2
wMysteryGiftTrainerDataEnd::

	ds $8a

wMysteryGiftPartnerData:: ds 1
wMysteryGiftPartnerID:: ds 2
wMysteryGiftPartnerName:: ds NAME_LENGTH
wMysteryGiftPartnerDexCaught:: ds 1
wc90f::
wMysteryGiftPartnerSentDeco:: ds 1
wMysteryGiftPartnerWhichItem:: ds 1
wMysteryGiftPartnerWhichDeco:: ds 1
wMysteryGiftPartnerBackupItem:: ds 2
wMysteryGiftPartnerDataEnd::
	ds 60

wMysteryGiftPlayerData:: ds 1
wMysteryGiftPlayerID:: ds 2
wMysteryGiftPlayerName:: ds NAME_LENGTH
wMysteryGiftPlayerDexCaught:: ds 1
wMysteryGiftPlayerSentDeco:: ds 1
wMysteryGiftPlayerWhichItem:: ds 1
wMysteryGiftPlayerWhichDeco:: ds 1
wMysteryGiftPlayerBackupItem:: ds 2
wMysteryGiftPlayerDataEnd::
	ds 144

wc9f4:: ds 12

wCreditsFaux2bpp::
	ds 128

wca80:: ds 1
wPrinterRowIndex:: ds 1

; Gameboy Printer
wPrinterData:: ds 4
wPrinterChecksum:: ds 2

wPrinterHandshake:: ds 1
wPrinterStatusFlags::
; bit 7: set if error 1 (battery low)
; bit 6: set if error 4 (too hot or cold)
; bit 5: set if error 3 (paper jammed or empty)
; if this and the previous byte are both $ff: error 2 (connection error)
	ds 1

wHandshakeFrameDelay:: ds 1
wPrinterSerialFrameDelay:: ds 1
wPrinterSendByteOffset:: ds 2
wPrinterSendByteCounter:: ds 2

; tilemap backup?
wPrinterTilemap:: ds 154 ; continues below

; this stuff is right in the middle of the printer's tilemap
wBillsPC_ScrollPosition:: ds 1
wBillsPC_CursorPosition:: ds 1
wBillsPC_NumMonsInBox:: ds 1
wBillsPC_NumMonsOnScreen:: ds 1
wBillsPC_LoadedBox:: ds 1 ; 0 if party, 1 - 14 if box, 15 if active box
wBillsPC_BackupScrollPosition:: ds 1
wBillsPC_BackupCursorPosition:: ds 1
wBillsPC_BackupLoadedBox:: ds 1

	ds 82 ;the tilemap keeps going, but the area below is shared with link features

wcb84:: ds 100
wcbe8:: dw
wLinkOTPartyMonTypes::
	ds 2 * PARTY_LENGTH
	ds 2
;printer tilemap ends here as well

wPrinterStatus::
wcbf8:: ds 2
wcbfa:: ds 1
wPrinterBrightness:: ds 1
; 292 bytes unallocated (still used by overworld map)
ENDU ; 1: c800

SECTION "WRAM 0 continued", WRAM0
UNION ; 1: cd20
wCreditsPos::
	ds 2
wCreditsTimer:: ; cd22
	ds 1

NEXTU ; 1: cd20

wBGMapBuffer::
	ds 40
wBGMapPalBuffer:: ; cd48
	ds 40

wBGMapBufferPtrs:: ; cd70
; 20 bg map addresses (16x8 tiles)
	ds 40
ENDU ; 1: cd20

wPlayerHPPal:: ; cd99
	ds 1
wEnemyHPPal:: ; cd9a
	ds 1

wHPPals:: ds PARTY_LENGTH
wcda1:: ds 1

wLCD:: ds 15
wLCDCPointer:: ds 25
	ds 16

wAttrMap:: ; cdd9
; 20x18 grid of palettes for 8x8 tiles
; read horizontally from the top row
; bit 3: vram bank
; bit 0-2: palette id
	ds SCREEN_WIDTH * SCREEN_HEIGHT
wAttrMapEnd::
wTileAnimBuffer::
	ds $10
; addresses dealing with serial comms
wOtherPlayerLinkMode:: ds 1
wOtherPlayerLinkAction:: ds 4
wPlayerLinkAction:: ds 1
wcf57:: ds 4
wLinkTimeoutFrames:: ds 2
wcf5d:: ds 2

wMonType:: ; cf5f
	ds 1

wCurSpecies:: ; cf60
wCurMove::
	ds 1

wNamedObjectTypeBuffer::
	ds 1

wSGBPredef::
	ds 1

wJumptableIndex::
wBattleTowerBattleEnded::
wOptionsCursorLocation::
	ds 1

wNrOfBeatenBattleTowerTrainers::
wMomBankDigitCursorPosition::
wIntroSceneFrameCounter::
wHoldingFossilPuzzlePiece::
wCardFlipCursorY::
wCreditsBorderFrame::
wDexEntryPrevJumptableIndex::
wDatesetYear::
wOptionsNumOptions::
wNamingScreenShift::
wcf64::
	ds 1

wCreditsBorderMon::
wTitleScreenTimer::
wFossilPuzzleCursorPosition::
wCardFlipCursorX::
wCurrPocket::
wDatesetMonth::
wOptionsCurPage::
wPrinterQueueLength::
wcf65::
	ds 1

wCreditsLYOverride::
wTitleScreenTimerHi::
wFossilPuzzleHeldPiece::
wCardFlipWhichCard::
wDatesetDay::
wcf66::
	ds 1

wInitHourBuffer::
wcf67::
	ds 1

wInitMinuteBuffer::
wcf68::
	ds 1

wDatesetMonthLength::
wcf69::
	ds 1

wMoveIsAnAbility::
	ds 1
wSGBPals::
	ds 1

wFadeCounter::
	ds 1
wFadeColorsCount::
	ds 1

	ds 3

wWindowStackPointer:: dw ; cf71
wMenuJoypad:: ds 1   ; cf73
wMenuSelection:: ds 1 ; cf74
wMenuSelectionQuantity:: ds 1 ; cf75
wWhichIndexSet:: ds 1
wScrollingMenuCursorPosition:: ds 1
wWindowStackSize:: ds 9

; menu data header
wMenuHeader:: ; cf81
wMenuFlags:: ds 1
; bit 7: When set, don't print menu items one line below the starting coord
; bit 6: When set, push the tiles behind the menu
; bit 5: When set, only allow A on cancel
; bit 4: When set, set bit 6 of w2DMenuFlags1 (Play sprite animations)
; bit 3: When set, don't play the click SFX
; bit 2: When set, use the cursor pos as an offset to the variable data menu pointer for the menu result
; bit 1: When set, push one extra tile length from each side.
; bit 0: When set, don't restore tile backup for exit menu. May be written in _PushWindow (unsure)

wMenuBorderTopCoord:: ds 1
wMenuBorderLeftCoord:: ds 1
wMenuBorderBottomCoord:: ds 1
wMenuBorderRightCoord:: ds 1
wMenuDataPointer:: ds 2
wMenuCursorBuffer:: ds 2
; end menu data header
wMenuDataBank:: ds 1
	ds 6
wMenuHeaderEnd::

wMenuData::
wMenuDataFlags:: ds 1 ; cf91
; bit 7: When set, start printing text one tile to the right of the border
;        In scrolling menus, SELECT is functional
; bit 6: When clear, start printing text one tile below the border
;        In scrolling menus, START is functional
; bit 5: Related to 2D menus in non-scrolling menus
;        In scrolling menus, call function #3 when a new item is selected
; bit 4: In scrolling menus, display arrows showing the scrolling directions
; bit 3: When set, SELECT is functional
;        In scrolling menus, LEFT is functional
; bit 2: When set, L/R are functional
;        In scrolling menus, RIGHT is functional
; bit 1: Enable Select button
;        In scrolling menus, call function #3 (if bit 5 allows it) even if the same item is being selected
; bit 0: Disable B button
;        In scrolling menus, call function #1 when Cancel is to be displayed

UNION
; Vertical Menu/DoNthMenu/SetUpMenu
wMenuDataItems:: db
wMenuDataIndicesPointer:: dw
wMenuDataDisplayFunctionPointer:: dw
wMenuDataPointerTableAddr:: dw
NEXTU
; 2D Menu
wMenuData_2DMenuDimensions:: db
wMenuData_2DMenuSpacing:: db
wMenuData_2DMenuItemStringsBank:: db
wMenuData_2DMenuItemStringsAddr:: dw
wMenuData_2DMenuFunctionBank:: db
wMenuData_2DMenuFunctionAddr:: dw
NEXTU
; Scrolling Menu
wMenuData_ScrollingMenuHeight:: db
wMenuData_ScrollingMenuWidth:: db
wMenuData_ScrollingMenuSpacing:: db
wMenuData_ItemsPointerBank:: db
wMenuData_ItemsPointerAddr:: dw
wMenuData_ScrollingMenuFunction1:: ds 3
wMenuData_ScrollingMenuFunction2:: ds 3
wMenuData_ScrollingMenuFunction3:: ds 3
ENDU
wMenuDataEnd::

wMenuData3::
w2DMenuCursorInitY:: ds 1 ; cfa1
w2DMenuCursorInitX:: ds 1 ; cfa2
w2DMenuNumRows:: ds 1 ; cfa3
w2DMenuNumCols:: ds 1 ; cfa4
w2DMenuFlags1:: ds 1 ; cfa5
w2DMenuFlags2:: ds 1 ; cfa6
w2DMenuCursorOffsets:: ds 1 ; cfa7
wMenuJoypadFilter:: ds 1 ; cfa8
wMenuData3End::

wMenuCursorY:: ds 1 ; cfa9
wMenuCursorX:: ds 1 ; cfaa
wCursorOffCharacter:: ds 1 ; cfab
wCursorCurrentTile:: ds 2 ; cfac
wAmountOfCurItem::
	ds 2

wGenericDelay:: ; cfb0
	ds 1
wOverworldDelay:: ; cfb1
	ds 1
wTextDelayFrames:: ; cfb2
	ds 1
wVBlankOccurred:: ; cfb3
	ds 1

wRNGState:: ds 4
wRNGCumulativeDividerPlus:: ds 2
wRNGCumulativeDividerMinus:: ds 1

; Each bit controls whether the corresponding stopwatch is running or stopped.
wStopwatchControl:: ds 1 ;cfbb

wGameTimerPause:: ; cfbc
; bit 0
	ds 1

wRespawnableEventMonBaseIndex::
	ds 1

wDisableJoypad::
	ds 1

	ds 1

wInBattleTowerBattle:: ; cfc0
; 0 not in BattleTower-Battle
; 1 BattleTower-Battle
	ds 1

wAutoMashText::
	ds 1 ; cfc1

wFXAnimID::
wFXAnimIDLo:: ; cfc2
	ds 1
wFXAnimIDHi:: ; cfc3
	ds 1
wPlaceBallsX:: ; cfc4
	ds 1
wPlaceBallsY:: ; cfc5
	ds 1
wTileAnimationTimer:: ; cfc6
	ds 1

; palette backups?
wBGP:: ds 1
wOBP0:: ds 1
wOBP1:: ds 1

wNumHits:: ds 2

wOptions:: ; cfcc
; bit 0-1: index for number of frames to wait when printing text
;   inst: 0 -> 0
;   fast: 1 -> 1
;   mid:  2 -> 3
;   slow: 3 -> 5
; bit 3: turning speed
; bit 4: no text delay
; bit 5: stereo off/on
; bit 6: battle style shift/set
; bit 7: battle scene off/on
	ds 1

wSaveFileExists:: ds 1

wTextBoxFrame:: ; cfce
; bits 0-2: textbox frame 0-7
	ds 1
wTextBoxFlags::
	ds 1

wGBPrinter:: ; cfd0
; this is actually 0-4 now
	ds 1

wOptions2:: ; cfd1
; bits 0-1: index for which hold to mash setting
;   0: none
;   1: start
;   2: a+b
;   3: b
; bit 2: unit choice: 0: metric, 1: imperial
; bit 3: time format: 0: 24 hour, 1: 12 hour
	ds 1
wOptionsEnd::

; Time buffer, for counting the amount of time since
; an event began.

wYearsSince:: ds 1
wMonthsSince:: ds 1
wDaysSince:: ds 1
wHoursSince:: ds 1
wMinutesSince:: ds 1
wSecondsSince:: ds 1

wTimeSinceEnd::

wBattlePlayerSkinTone:: ds 2 ;cfd8

	ds 6

wDebugMenuCurrentMenu:: ds 2 ;cfe0
wDebugMenuNextMenu:: ds 2 ;cfe2
wDebugMenuFlags:: ds 1 ;cfe4
wDebugMenuOptionCount:: ds 1 ;cfe5
wDebugMenuCurrentOption:: ds 1 ;cfe6
wDebugMenuParameter:: ds 1 ;cfe7

wDebugMenuScratchSpace:: ds 24 ;cfe8

wRAM0End:: ; d000
wCrashStack::

SECTION "WRAM 1", WRAMX

wd000:: ds 1
wDefaultSpawnpoint::
wd001:: ds 1

UNION ; 1: d002
wMiningPickaxeModePlusOne::
wBufferMonNick:: ds PKMN_NAME_LENGTH
wBufferMonOT:: ds NAME_LENGTH
wBufferMon:: party_struct wBufferMon
	ds 8
wMonOrItemNameBuffer::
NEXTU ; 1: d002

wMovementBufferCount:: ds 1
wMovementBufferPerson:: ds 1
wMovementBufferUnknD004:: ds 1
wMovementBufferPointer:: dw
wMovementBuffer:: ds 16 ; d007
NEXTU ; 1: d002

wTowerArcadePartyCount:: ds 1
wSelectedParty:: ds 3
wTowerArcadePartyEnd::
NEXTU ; 1: d002

wMapHiddenItemsBuffer:: ds 5
wUndiscoveredHiddenItemExists:: ds 1
NEXTU ; 1: d002

wFlypoint::

wd002::
wWeekdayAtStartOfMonth::
wBattleTempExpPoints::
wTempDayOfWeek::
wApricorns::
	ds 1
wd003::
wCurMonthLength::
wPlaceBallsDirection::
	ds 1
wd004::
wTrainerHUDTiles::
	ds 1
wd005::
	ds 1
wd006::
	ds 1
wd007::
	ds 1
NEXTU ; 1: d002

wPrintedBoxMon:: ds 1
wFinishedPrintingBox:: ds 1
wPrintedBoxAddress:: ds 2
wPrintedBoxBank:: ds 1
wPrintedBoxNumber:: ds 1

NEXTU ; 1: d002

wMartItem1BCD:: ds 3
wMartItem2BCD:: ds 3
wMartItem3BCD:: ds 3
wMartItem4BCD:: ds 3
wMartItem5BCD:: ds 3
wMartItem6BCD:: ds 3
wMartItem7BCD:: ds 3
wMartItem8BCD:: ds 3
wMartItem9BCD:: ds 3
wMartItem10BCD:: ds 3
wMartItemBCDEnd::
	ds 13
wd02d:: ds 1
wd02e:: ds 1
wd02f:: ds 1
wd030:: ds 1
wd031:: ds 1
wd032:: ds 1
wd033:: ds 1
wd034:: ds 2
wd036:: ds 2
wd038:: ds 3
wd03b:: ds 3

UNION ; 2: d03e
wMagnetTrainOrMinecartMenuItems::
wTempFacingTile::
wCurFruitTree:: ds 1
wCurFruit:: ds 1
NEXTU ; 2: d03e

wElevatorPointerBank:: ds 1
wElevatorPointer:: ; dw
wElevatorPointerLo:: ds 1
wElevatorPointerHi:: ds 1
wElevatorOriginFloor:: ds 1
NEXTU ; 2: d03e

wCurSignpostYCoord:: ds 1
wCurSignpostXCoord:: ds 1
wCurSignpostType:: ds 1
wCurSignpostScriptAddr:: dw
NEXTU ; 2: d03e

wCurSignpostItemFlag:: dw
wCurSignpostItemID:: ds 1
NEXTU ; 2: d03e

wCurItemBallContents:: ds 1
wCurItemBallQuantity:: ds 1
NEXTU ; 2: d03e

wTempTrainerBank:: ds 1
wTempTrainerDistance:: ds 1
wTempTrainerFacing:: ds 1
wTempTrainerHeader::
wTempTrainerEventFlag:: ds 2
wTempTrainerClass:: ds 1
wTempTrainerID:: ds 1
wSeenTextPointer:: dw
wWinTextPointer:: dw
wGenericTempTrainerHeaderEnd::
wLossTextPointer::
wStashedAfterBattleTextPointer:: dw
wScriptAfterPointer:: dw
wTempTrainerHeaderEnd::
wRunningTrainerBattleScript:: ds 1
NEXTU ; 2: d03e

wTemporaryScriptBuffer::
wMenuItemsList::
wCurInput::
wEngineBuffer1:: ; d03e
	ds 1

wd03f::
wMartPointerBank::
wEngineBuffer2::
	ds 1

wd040::
wMartPointer:: ; d040
wEngineBuffer3::
	ds 1

wd041::
wEngineBuffer4::
	ds 1

wMovementAnimation:: ; d042
wEngineBuffer5::
	ds 1

wWalkingDirection:: ; d043
wGoldTokenExchangeItemPointer::
wBargainShopFlags::
	ds 1

wFacingDirection:: ; d044
	ds 1

wWalkingX::
wMartMenuCursorBuffer:: ; d045
wScrollingMenuCursorBuffer::
	ds 1
wWalkingY:: ; d046
wMartMenuScrollPosition::
wScrollingMenuScrollPosition::
	ds 1

wWalkingTile:: ; d047
	ds 1

	ds 3

wWinTextBank::
	ds 1
wLossTextBank::
	ds 1

	ds 1
wMenuItemsListEnd::
ENDU ; 2: d03e
wPlayerMovementDirection:: ds 24
ENDU ; 1: d002
wTMHMMoveNameBackup:: ds MOVE_NAME_LENGTH

wStringBuffer1:: ; d073
	ds 19

wStringBuffer2:: ; d086
	ds 19

wStringBuffer3:: ; d099
	ds 19

wStringBuffer4:: ; d0ac
	ds 19

wScriptBuffer:: ; d0bf
; dedicated buffer of 19 bytes to store whatever in scripts
	ds 19

wd0d2:: ds 2

wCurBattleMon:: ; d0d4
	ds 1
wCurMoveNum:: ; d0d5
	ds 1

wLastPocket:: ds 1

wPCItemMenuCursor:: ds 1
wPartyMenuCursor:: ds 1
wItemsPocketCursor:: ds 1
wKeyItemsPocketCursor:: ds 1
wBallsPocketCursor:: ds 1
wTMHMPocketCursor:: ds 1

wPCItemScrollPosition:: ds 1
	ds 1
wItemsPocketScrollPosition:: ds 1
wKeyItemsPocketScrollPosition:: ds 1
wBallsPocketScrollPosition:: ds 1
wTMHMPocketScrollPosition:: ds 1

wMoveSwapBuffer::
wSwitchMon::
wSwitchItem::
	ds 1

wMenuScrollPosition:: ds 4
wQueuedScriptBank:: ds 1
wQueuedScriptAddr:: ds 2
wNumMoves:: ds 1 ; returned to by ListMoves predef
wFieldMoveSucceeded::
wItemEffectSucceeded::
wBattlePlayerAction::
; 0 - use move
; 1 - use item
; 2 - switch
wSolvedFossilPuzzle::
	ds 1 ; d0ec

wVramState:: ; d0ed
; bit 0: overworld sprite updating on/off
; bit 6: something to do with text
; bit 7: on when surf initiates
;        flickers when climbing waterfall
	ds 1

wBattleResult:: ds 1
wUsingItemWithSelect:: ds 1

wCurMart::
wCurElevator:: ds 1
wCurElevatorFloors:: ds 21

wCurItem:: ; d106
	ds 1

wCurItemQuantity:: ; d107
wMartItemID::
	ds 1

wCurPartySpecies:: ; d108
	ds 1

wCurPartyMon:: ; d109
; contains which monster in a party
; is being dealt with at the moment
; 0-5
	ds 1

wWhichHPBar::
; 0: Enemy
; 1: Player
	ds 1
wPokemonWithdrawDepositParameter::
; 0: Take from PC
; 1: Put into PC
; 2: Take from Daycare
; 3: Put into Daycare
	ds 1
wItemQuantityChangeBuffer:: ds 1
wItemQuantityBuffer:: ds 1

wTempMon:: ; d10e
	party_struct wTempMon

wSpriteFlags:: ; d13e
; no facings if set
	ds 1

wHandlePlayerStep:: ds 2 ; d13f

wPartyMenuActionText:: ; d141
	ds 1

wItemAttributeParamBuffer:: ; d142
	ds 1

wCurPartyLevel:: ; d143
	ds 1

wScrollingMenuListSize:: ; d144
	ds 1

	ds 1

; used when following a map warp
; d146
wNextWarp:: ds 1
wNextMapGroup:: ds 1
wNextMapNumber:: ds 1
wPrevWarp:: ds 1
wPrevMapGroup:: ds 1
wPrevMapNumber:: ds 1
; d14c

wMapObjectGlobalOffsetX:: ds 1 ; used in FollowNotExact
wMapObjectGlobalOffsetY:: ds 1 ; used in FollowNotExact

; Player movement
wPlayerStepVectorX:: ds 1   ; d14e
wPlayerStepVectorY:: ds 1   ; d14f
wPlayerStepFlags:: ds 1     ; d150
; bit 7: Start step
; bit 6: Stop step
; bit 5: Doing step
; bit 4: In midair
; bits 0-3: unused
wPlayerStepDirection:: ds 1 ; d151

wBGMapAnchor:: ds 2 ; d152

wUsedSprites:: ; d154
; sprite ID, start tile
	ds 32 * 2
wUsedSpritesEnd::

wOverworldMapAnchor:: dw ; d194
wMetatileStandingY:: ds 1 ; d196
wMetatileStandingX:: ds 1 ; d197
wSecondMapHeaderBank:: ds 1 ; d198
wTileset:: ds 1 ; d199
wPermission:: ds 1 ; d19a
wSecondMapHeaderAddr:: dw ; d19b

; width/height are in blocks (2x2 walkable tiles, 4x4 graphics tiles)
wMapHeader:: ; d19d
wMapBorderBlock:: ; d19d
	ds 1
wMapHeight:: ; d19e
	ds 1
wMapWidth:: ; d19f
	ds 1
wMapBlockDataBank:: ; d1a0
	ds 1
wMapBlockDataPointer:: ; d1a1
	ds 2
wMapScriptHeaderBank:: ; d1a3
	ds 1
wMapScriptHeaderPointer:: ; d1a4
	ds 2
wMapEventHeaderPointer:: ; d1a6
	ds 2
; bit set
wMapConnections:: ; d1a8
	ds 1
wNorthMapConnection:: ; d1a9
wNorthConnectedMapGroup:: ; d1a9
	ds 1
wNorthConnectedMapNumber:: ; d1aa
	ds 1
wNorthConnectionStripPointer:: ; d1ab
	ds 2
wNorthConnectionStripLocation:: ; d1ad
	ds 2
wNorthConnectionStripLength:: ; d1af
	ds 1
wNorthConnectedMapWidth:: ; d1b0
	ds 1
wNorthConnectionStripYOffset:: ; d1b1
	ds 1
wNorthConnectionStripXOffset:: ; d1b2
	ds 1
wNorthConnectionWindow:: ; d1b3
	ds 2

wSouthMapConnection:: ; d1b5
wSouthConnectedMapGroup:: ; d1b5
	ds 1
wSouthConnectedMapNumber:: ; d1b6
	ds 1
wSouthConnectionStripPointer:: ; d1b7
	ds 2
wSouthConnectionStripLocation:: ; d1b9
	ds 2
wSouthConnectionStripLength:: ; d1bb
	ds 1
wSouthConnectedMapWidth:: ; d1bc
	ds 1
wSouthConnectionStripYOffset:: ; d1bd
	ds 1
wSouthConnectionStripXOffset:: ; d1be
	ds 1
wSouthConnectionWindow:: ; d1bf
	ds 2

wWestMapConnection:: ; d1c1
wWestConnectedMapGroup:: ; d1c1
	ds 1
wWestConnectedMapNumber:: ; d1c2
	ds 1
wWestConnectionStripPointer:: ; d1c3
	ds 2
wWestConnectionStripLocation:: ; d1c5
	ds 2
wWestConnectionStripLength:: ; d1c7
	ds 1
wWestConnectedMapWidth:: ; d1c8
	ds 1
wWestConnectionStripYOffset:: ; d1c9
	ds 1
wWestConnectionStripXOffset:: ; d1ca
	ds 1
wWestConnectionWindow:: ; d1cb
	ds 2

wEastMapConnection:: ; d1cd
wEastConnectedMapGroup:: ; d1cd
	ds 1
wEastConnectedMapNumber:: ; d1ce
	ds 1
wEastConnectionStripPointer:: ; d1cf
	ds 2
wEastConnectionStripLocation:: ; d1d1
	ds 2
wEastConnectionStripLength:: ; d1d3
	ds 1
wEastConnectedMapWidth:: ; d1d4
	ds 1
wEastConnectionStripYOffset:: ; d1d5
	ds 1
wEastConnectionStripXOffset:: ; d1d6
	ds 1
wEastConnectionWindow:: ; d1d7
	ds 2


wTilesetHeader::
wTilesetBank:: ; d1d9
	ds 1
wTilesetAddress:: ; d1da
	ds 2
wTilesetBlocksBank:: ; d1dc
	ds 1
wTilesetBlocksAddress:: ; d1dd
	ds 2
wTilesetCollisionBank:: ; d1df
	ds 1
wTilesetCollisionAddress:: ; d1e0
	ds 2
wTilesetAttributesBank:: ; d1e2
	ds 1
wTilesetAttributesAddress:: ; d1e3
	ds 2
wTilesetAnim:: ; d1e5
; bank 3f
	ds 2

	ds 1

wEvolvableFlags:: ; d1e8
	flag_array PARTY_LENGTH

wForceEvolution:: ds 1
UNION ; 1: d1ea
wCurHPAnimMaxHP::   dw ; d1ea
wCurHPAnimOldHP::   dw ; d1ec
wCurHPAnimNewHP::   dw ; d1ee
wCurHPAnimPal::     db ; d1f0
wCurHPBarPixels::   db ; d1f1
wNewHPBarPixels::   db ; d1f2
wCurHPAnimDeltaHP:: dw ; d1f3
wCurHPAnimLowHP::   db ; d1f5
wCurHPAnimHighHP::  db ; d1f6
NEXTU ; 1: d1ea

wItemfinderSignpostsBank:: ds 1
wItemfinderSignpostsCount:: ds 1
wItemfinderScreenBottom:: ds 1
wItemfinderScreenRight:: ds 1
NEXTU ; 1: d1ea

wEvolutionPrevSpecies:: ds 1
wEvolutionNewSpecies:: ds 1
wEvolutionFrontpicTileOffset:: ds 1
wEvolutionCanceled:: ds 1
NEXTU ; 1: d1ea

wCustomizationExpandedPal:: ds 3
wSavedPlayerCharacteristics:: ds 5 ; wPlayerCharacteristicsEnd - wPlayerCharacteristics
NEXTU ; 1: d1ea

wExpToNextLevel:: ds 3
wTotalExpToNextLevel:: ds 3
NEXTU ; 1: d1ea

wClockResetCurrentField:: ds 1
wClockResetPreviousField:: ds 1
wClockResetYCoord:: ds 1
wClockResetWeekday:: ds 1
wClockResetHours:: ds 1
wClockResetMinutes:: ds 1
NEXTU ; 1: d1ea

wWhiteOutFlags:: ds 1
wTrainerNotes_EncounterLevel:: ds 1
NEXTU ; 1: d1ea

wBattleTowerLegalPokemonFlags::
wBattleArcadeMenuCursorBuffer::
wListMoves_Spacing::
wFillMoves_IsPartyMon:: ds 1
wSwitchMon1:: ds 1
wSwitchMon2:: ds 1
NEXTU ; 1: d1ea

wCatchMon_CatchRate:: ds 1
wCatchMon_NumShakes:: ds 1
wCatchMon_Critical:: ds 1
NEXTU ; 1: d1ea

wPPUpPPBuffer::

wTrainerHUD_BallIcons:: ds PARTY_LENGTH
NEXTU ; 1: d1ea

wMonSubmenuItemsCount::
wPlayerOwnedApricornsCount:: ds 1
wMonSubmenuItems::
wPlayerOwnedApricornsList:: ds 10
NEXTU ; 1: d1ea

wItemPCQuantityDeltaBackup:: ds 1
wItemPCQuantityBackup:: ds 1
NEXTU ; 1: d1ea

wTempMysteryGiftTimer::
wCurItemPrice:: ds 2
wCurMartIsBTOrArcade:: ds 1
NEXTU ; 1: d1ea

wTreeCoordScore:: ds 1
wTreeIDScore:: ds 1
NEXTU ; 1: d1ea

wHealMachineAnimType:: ds 1
wHealMachineOBPBackup:: ds 1
wHealMachineRoutineIDX:: ds 1
NEXTU ; 1: d1ea

wFieldMoveBufferSpace::
wFieldMoveJumptableIndex:: ds 1
wFieldMoveSurfType::
wFieldMoveEscapeType::
wRodType:: ds 1
wFieldMoveCutTileLocation:: ds 2
wFieldMoveCutTileReplacement:: ds 1
wFieldMovePokepicSpecies::
wFishResponse:: ds 1
wWhichCutAnimation:: ds 1
wFieldMoveBufferSpaceEnd::

wAI_CurrentItem:: ds 1
	ds 1
wLinkBuffer_D1F3::
	ds 3
wTempTrainerType::
	ds 4
ENDU ; 1: d1ea

wLinkBattleRNs:: ; d1fa
	ds 10


wTempNumber::
wTempEnemyMonSpecies::  ds 1 ; d204
wTempBattleMonSpecies:: ds 1 ; d205

wEnemyMon:: battle_struct wEnemyMon ; d206
wEnemyMonBaseStats:: ds 5 ; d226
wEnemyMonCatchRate:: db ; d22b
wEnemyMonBaseExp::   db ; d22c
wEnemyMonEnd::


wBattleMode:: ; d22d
; 0: overworld
; 1: wild battle
; 2: trainer battle
	ds 1

wTempWildMonSpecies:: ds 1
wOtherTrainerClass:: ; d22f
; class (Youngster, Bug Catcher, etc.) of opposing trainer
; 0 if opponent is a wild Pokémon, not a trainer
	ds 1

wBattleType:: ; d230
; $00 normal
; $01 can lose
; $02 debug
; $03 dude/tutorial
; $04 fishing
; $05 roaming
; $06 contest
; $07 shiny
; $08 headbutt/rock smash
; $09 trap
; $0a force Item1
; $0b celebi
; $0c suicune
	ds 1

wOtherTrainerID:: ; d231
; which trainer of the class that you're fighting
; (Joey, Mikey, Albert, etc.)
	ds 1

wForcedSwitch:: ds 1

wTrainerClass:: ; d233
	ds 1

	ds 1

wMoveSelectionMenuType:: ds 1

wCurBaseData:: ; d236
wBaseDexNo:: ; d236
	ds 1
wBaseStats:: ; d237
wBaseHP:: ; d237
	ds 1
wBaseAttack:: ; d238
	ds 1
wBaseDefense:: ; d239
	ds 1
wBaseSpeed:: ; d23a
	ds 1
wBaseSpecialAttack:: ; d23b
	ds 1
wBaseSpecialDefense:: ; d23c
	ds 1
wBaseType:: ; d23d
wBaseType1:: ; d23d
	ds 1
wBaseType2:: ; d23e
	ds 1
wBaseCatchRate:: ; d23f
	ds 1
wBaseExp:: ; d240
	ds 1
wBaseItems:: ; d241
	ds 2
wBaseGender:: ; d243
	ds 1
wBaseUnknown1:: ; d244
	ds 1
wBaseEggSteps:: ; d245
	ds 1
wBaseUnknown2:: ; d246
	ds 1
wBasePicSize:: ; d247
	ds 1
wBaseAbilities::
wBaseAbility1:: db ; d248
wBaseAbility2:: db ; d249
wBasePadding:: ; d24a
	ds 2
wBaseGrowthRate:: ; d24c
	ds 1
wBaseEggGroups:: ; d24d
	ds 1
wBaseTMHM:: ; d24e
	ds 8

wSunriseOffset::
	ds 1
wSunriseOffsetDate::
	ds 2

	ds 1

wMornEncounterRate::  ds 1 ; d25a
wDayEncounterRate::   ds 1 ; d25b
wNiteEncounterRate::  ds 1 ; d25c
wWaterEncounterRate:: ds 1 ; d25d
wListMoves_MoveIndicesBuffer:: ds NUM_MOVES
wPutativeTMHMMove:: ds 1
wInitListType:: ds 1
wBattleHasJustStarted:: ds 1
wFoundMatchingIDInParty::
wNamedObjectIndexBuffer::
wCurTMHM::
wTypeMatchup::
wd265:: ds 1
wFailedToFlee:: ds 1
wNumFleeAttempts:: ds 1
wMonTriedToEvolve:: ds 1

wTimeOfDay:: ; d269
	ds 1

wLastBallShakes:: ds 1 ; d26a

wd26b::
UNION ; 1: d26b
wEmoteSFX:: ds 2
wPlayEmoteSFX:: ds 1
NEXTU ; 1: d26b
wOTPlayerName:: ds NAME_LENGTH ; d26b
wOTPlayerID:: ds 2 ; d276
	ds 8
wOTPartyCount::   ds 1 ; d280
wOTPartySpecies:: ds PARTY_LENGTH ; d281
wOTPartyEnd::     ds 1
ENDU ; 1: d26b

UNION ; 1: d288
wPachisiPath::
wCardDeck:: ds 7 ;d288 (52 Cards)
wYourCardHand:: ds 12
wDealerCardHand::
wPokerMenu::
	ds 12

NEXTU ; 1: d288

wParkMinigameData::

wParkMinigameRemainingTime:: ds 4
wParkMinigameTotalTime:: ds 1 ;minutes
wParkMinigameGameType:: ds 1

MACRO park_minigame_spot
\1Flags::
\1Species::
	ds 1 ; 0 indicates empty/cooldown, -1 indicates an item
\1Item::
\1Level::
\1Cooldown::
	ds 1
\1DVs::
\1Quantity::
	ds 2
ENDM

wParkMinigameSpot1:: park_minigame_spot wParkMinigameSpot1
wParkMinigameSpot2:: park_minigame_spot wParkMinigameSpot2
wParkMinigameSpot3:: park_minigame_spot wParkMinigameSpot3
wParkMinigameSpot4:: park_minigame_spot wParkMinigameSpot4
wParkMinigameSpot5:: park_minigame_spot wParkMinigameSpot5
wParkMinigameSpot6:: park_minigame_spot wParkMinigameSpot6
wParkMinigameSpot7:: park_minigame_spot wParkMinigameSpot7
wParkMinigameSpot8:: park_minigame_spot wParkMinigameSpot8
wParkMinigameSpot9:: park_minigame_spot wParkMinigameSpot9
wParkMinigameSpot10:: park_minigame_spot wParkMinigameSpot10
wParkMinigameSpot11:: park_minigame_spot wParkMinigameSpot11
wParkMinigameSpot12:: park_minigame_spot wParkMinigameSpot12
wParkMinigameSpot13:: park_minigame_spot wParkMinigameSpot13
wParkMinigameSpotsEnd::

wParkMinigameCurrentSpotNumber:: ds 1
wParkMinigameCurrentSpot:: park_minigame_spot wParkMinigameCurrentSpot

wParkMinigameSavedHeldItems:: ds 6
wParkMinigameSavedBalls:: ds MAX_BALLS * 2 + 2

wParkMinigameDataEnd::
NEXTU ; 1: d288

wOTPartyMons::
wOTPartyMon1:: party_struct wOTPartyMon1 ; d288
wOTPartyMon2:: party_struct wOTPartyMon2 ; d2b8
wOTPartyMon3:: party_struct wOTPartyMon3 ; d2e8
wOTPartyMon4:: party_struct wOTPartyMon4 ; d318
wOTPartyMon5:: party_struct wOTPartyMon5 ; d348
wOTPartyMon6:: party_struct wOTPartyMon6 ; d378
wOTPartyMonsEnd::
ENDU ; 1: d288

wOTPartyMonOT:: ds NAME_LENGTH * PARTY_LENGTH ; d3a8
wOTPartyMonNicknames:: ds PKMN_NAME_LENGTH * PARTY_LENGTH ; d3ea
wOTPartyDataEnd::
wAIMoveScores::
	ds 4

wBattleAction:: ds 1 ; d430

	ds 1
wMapStatus:: ; d432
	ds 1
wMapEventStatus:: ; d433
; 0: do map events
; 1: do background events
	ds 1

wScriptFlags:: ; d434
; bit 5: in opentext
; bit 4: called from ASM
; bit 3: priority jump
; bit 2: script running
; bit 1: callback
; bit 0: ????????
	ds 1
wScriptFlags2:: ; d435
; bit 0: is fishing
	ds 1
wScriptFlags3:: ; d436
; bit 4: wild encounters
; bit 2: warps and connections
; bit 1: xy triggers
; bit 0: count steps
	ds 1

wScriptMode:: ; d437
	ds 1
wScriptRunning:: ; d438
	ds 1
wScriptBank:: ; d439
	ds 1
wScriptPos:: ; d43a
	ds 2

wScriptStackSize:: ds 1
wScriptStack:: ds 3 * 5
	ds 1
wScriptDelay:: ; d44d
	ds 1

wPriorityScriptBank::
wScriptTextBank::
	ds 1 ; d44e
wPriorityScriptAddr::
wScriptTextAddr:: ds 2 ; d44f
	ds 1
wWildEncounterCooldown:: ds 1 ; d452

wScriptArrayBank::
	ds 1
wScriptArrayAddress::
	ds 2
wScriptArrayEntrySize::
	ds 1
wScriptArrayCurrentEntry::
	ds 1

wInitialTextColumn:: ds 1 ; d458

wBattleScriptFlags:: ds 2 ; d459
wPlayerSpriteSetupFlags:: ds 1 ; d45b
; bit 7: if set, cancel wPlayerAction
; bit 5: if set, set facing according to bits 0-1
; bits 0-1: direction facing

wScriptArrayCommandBuffer::
	ds 15

wCompressedTextBuffer:: ds 7 ; d465

wTimeEventCallback:: ds 2 ; d46c
wTimeEventCallbackBank:: ds 1 ; d46e
wMapStatusEnd:: ds 2 ; d470

wTempPlayerCustSelection::
	ds 1

wTempPlayerClothesPalette::
	ds 3

wGameData::
wPlayerData::
wPlayerID:: ; d47b
	ds 2

wPlayerName:: ds NAME_LENGTH ; d47d
wMomsName::   ds NAME_LENGTH ; d488
wRivalName::  ds NAME_LENGTH ; d493
wPlayerOWSprite:: ds 1 ;d49e
wPlayerColor::    ds 2 ; d49f
wPlayerRace::     ds 1 ;d4a1
wBackupPlayerOWSprite:: ds 1 ;d4a2
wBackupPlayerColor::    ds 2 ;d4a3
wBackupPlayerRace::     ds 1 ;d4a5
wMiningLevel:: ds 1 ;d4a6
wMiningEXP::   ds 1 ;d4a7
wSmeltingLevel:: ds 1 ;d4a8
wSmeltingEXP::   ds 1 ;d4a9
wJewelingLevel:: ds 1 ;d4aa
wJewelingEXP::   ds 1 ;d4ab
wBallMakingLevel:: ds 1 ;d4ac
wBallMakingEXP::   ds 1 ;d4ad
wOrphanPoints:: ds 2 ;d4ae
wSootSackAsh:: ds 2 ;d4b0
wBattlePoints:: ds 2 ;d4a6

wSavedAtLeastOnce:: ds 1
wSpawnAfterChampion:: ds 1


; init time set at newgame
wPokerusTimerDay:: ; d4b6
	ds 1
wPokerusTimerHours:: ; d4b7
	ds 1
wPokerusTimerMinutes:: ; d4b8
	ds 1
wPokerusTimerSeconds:: ; d4b9
	ds 1
wPokerusTimerYear::
	ds 1
wPokerusTimerMonth::
	ds 1
wStartDateEnd::

	ds 7

wGameTimeCap:: ; d4c3
	ds 1
wGameTimeHours:: ; d4c4
	ds 2
wGameTimeMinutes:: ; d4c6
	ds 1
wGameTimeSeconds:: ; d4c7
	ds 1
wGameTimeFrames:: ; d4c8
	ds 1

wCurYear::
	ds 1
wCurMonth::
	ds 1
wCurDay:: ; d4cb
	ds 1
wTimeDataEnd::
	ds 1
wObjectFollow_Leader:: ds 1
wObjectFollow_Follower:: ds 1
wCenteredObject:: ds 1
wFollowerMovementQueueLength:: ds 1
wFollowMovementQueue:: ds 5

wObjectStructs:: ; d4d6
MACRO object_struct
\1Struct::
\1Sprite:: ds 1
\1MapObjectIndex:: ds 1
\1SpriteTile:: ds 1
\1MovementType:: ds 1
\1Flags:: ds 2
\1Palette:: ds 1
\1Walking:: ds 1
\1Direction:: ds 1
\1StepType:: ds 1
\1StepDuration:: ds 1
\1Action:: ds 1
\1ObjectStepFrame:: ds 1
\1Facing:: ds 1
\1StandingTile:: ds 1 ; collision
\1LastTile:: ds 1     ; collision
\1StandingMapX:: ds 1
\1StandingMapY:: ds 1
\1LastMapX:: ds 1
\1LastMapY:: ds 1
\1ObjectInitX:: ds 1
\1ObjectInitY:: ds 1
\1Radius:: ds 1
\1SpriteX:: ds 1
\1SpriteY:: ds 1
\1SpriteXOffset:: ds 1
\1SpriteYOffset:: ds 1
\1MovementByteIndex:: ds 1
\1Object28:: ds 1
\1Object29:: ds 1
\1Object30:: ds 1
\1Object31:: ds 1
\1Range:: ds 1
	ds 7
\1StructEnd::
ENDM

	object_struct wPlayer
	object_struct wObject1
	object_struct wObject2
	object_struct wObject3
	object_struct wObject4
	object_struct wObject5
	object_struct wObject6
	object_struct wObject7
	object_struct wObject8
	object_struct wObject9
	object_struct wObject10
	object_struct wObject11
	object_struct wObject12
wObjectStructsEnd:: ; d6de

wCmdQueue:: ds CMDQUEUE_CAPACITY * CMDQUEUE_ENTRY_SIZE
wOreCaseInventory:: ds 10
	ds 30

wMapObjects:: ; d71e
MACRO map_object
\1Object::
\1ObjectStructID::  ds 1
\1ObjectSprite::    ds 1
\1ObjectYCoord::    ds 1
\1ObjectXCoord::    ds 1
\1ObjectMovement::  ds 1
\1ObjectRadius::    ds 1
\1ObjectHour::      ds 1
\1ObjectTimeOfDay:: ds 1
\1ObjectColor::     ds 1
\1ObjectRange::     ds 1
\1ObjectScript::    ds 2
\1ObjectEventFlag:: ds 2
	ds 2
ENDM

	map_object wPlayer
	map_object wMap1
	map_object wMap2
	map_object wMap3
	map_object wMap4
	map_object wMap5
	map_object wMap6
	map_object wMap7
	map_object wMap8
	map_object wMap9
	map_object wMap10
	map_object wMap11
	map_object wMap12
	map_object wMap13
	map_object wMap14
	map_object wMap15
wMapObjectsEnd::

wObjectMasks:: ds NUM_OBJECTS ; d81e

wVariableSprites:: ; d82e
	ds $10

wEnteredMapFromContinue:: ds 1 ; d83e
	ds 2
wTimeOfDayPal:: ; d841
	ds 1
wSelectButtonCounter::
	ds 4
; d846
wTimeOfDayPalFlags:: ds 1
wTimeOfDayPalset:: ds 1
wCurTimeOfDay:: ; d848
	ds 1

wShinyTreeID:: ds 1

wSecretID:: ds 2

wStatusFlags:: ; d84c
	; 0 - pokedex
	; 1 - unown dex
	; 2 - pokemon only mode
	; 3 - pokerus
	; 4 - use treasure bag
	; 5 - wild encounters on/off
	; 6 - hall of fame
	; 7 - bug contest on
	ds 1

wStatusFlags2:: ; d84d
	; 0 - flash
	; 1 - rtc timers enabled
	; 2 - park catching minigame
	; 3 - time enabled
	; 4 - hyper share enabled
	; 5 - pokerus
	; 6 - berry juice?
	; 7 - rockets in mahogany
	ds 1

wMoney:: ; d84e
	ds 3

wBankMoney:: ; d851
	ds 3
wBankSavingMoney:: ; d854
	ds 1

wCoins:: ; d855
	ds 2

wMysteryZoneWinCount:: ds 2 ;d857

wTMsHMs:: ; d859
	flag_array NUM_TMS + NUM_HMS
wTMsHMsEnd::

wNumItems:: ; d866
	ds 1
wItems:: ; d867
	ds MAX_ITEMS * 2 + 1
wItemsEnd::

wNumKeyItems:: ; d8a4
	ds 1
wKeyItems:: ; d8a5
	ds MAX_KEY_ITEMS + 1
wKeyItemsEnd::

wNumBalls:: ; d8bc
	ds 1
wBalls:: ; d8bd
	ds MAX_BALLS * 2 + 1
wBallsEnd::

wPCItems:: ; d8f1
	ds MAX_PC_ITEMS * 2 + 1
wPCItemsEnd::
	ds 1 ;this is part of the PC data!

wTownMapFlags:: ds 1
; bit 6: fly
; bit 7: on/off

	ds 3

wWhichRegisteredItem:: ; d95b
	ds 1
wRegisteredItem:: ; d95c
	ds 1

wPlayerState:: ; d95d
	ds 1

wHallOfFameCount:: ds 2
wTradeFlags:: flag_array 6 ; d960
	ds 1

wIronPickaxeStepCount::
	ds 1

	ds 1

wPokeonlyBackupPokemonNickname:: ; d964
	ds PKMN_NAME_LENGTH

	ds 3

wPokecenter2FTrigger::                       ds 1 ; d972
wTradeCenterTrigger::                        ds 1 ; d973
wColosseumTrigger::                          ds 1 ; d974
wTimeCapsuleTrigger::                        ds 1 ; d975
wRoute69SouthGateTrigger::                   ds 1 ; d976
wIlkBrotherHouseTrigger::                    ds 1 ; d977
wPokeonlyForestTrigger::                     ds 1 ; d978
wMilosB1FTrigger::                           ds 1 ; d979
wMilosB2FTrigger::                           ds 1 ; d97a
wMilosB2FBTrigger::                          ds 1 ; d97a
wFirelightTunnelTrigger::                    ds 1 ; d97b
wRuinsF1Trigger::                            ds 1 ; d97c
wRuinsF2Trigger::                            ds 1 ; d97d
wRuinsF3Trigger::                            ds 1 ; d97e
wRuinsF4Trigger::                            ds 1 ; d97f
wRuinsF5Trigger::                            ds 1 ; d980
wSaxifrageTrigger::                          ds 1 ; d981
wPrisonF2Trigger::                           ds 1 ; d982
wClathriteBF1Trigger::                       ds 1 ; d983
wAcquaMinesBasementTrigger::                 ds 1 ; d984
wHauntedMansionBasementTrigger::             ds 1 ; d985
wPhloxLab1FTrigger::                         ds 1 ; d986
wSoutherlyCityTrigger::                      ds 1 ; d987
wRoute69Trigger::                            ds 1 ; d988
wNaljoBadgeCheckTrigger::                    ds 1 ; d989
wLaurelCityTrigger::                         ds 1 ; d98a
wRoute49GateTrigger::                        ds 1 ; d98b
wMysteryBrownTrigger::                       ds 1 ; d98c
wMysteryGoldTrigger::                        ds 1 ; d98d
wMysteryRedTrigger::                         ds 1 ; d98e
wAcquaStartTrigger::                         ds 1 ; d9c4
wProvincialParkContestTrigger::              ds 1 ; d9c1
wBattleTowerBattleRoomTrigger::              ds 1 ; d99f
wBattleTowerElevatorTrigger::                ds 1 ; d9a0
wBattleTowerHallwayTrigger::                 ds 1 ; d9a1
wBattleTowerEntranceTrigger::                ds 1 ; d9a2
wIntroOutsideTrigger::                       ds 1 ; d9c2
wSpurgeGym1FTrigger::                        ds 1 ; d9c3
wPowerPlantTrigger::                         ds 1 ; d9c4
wCaperRidgeTrigger::                         ds 1 ; d9c5
wHeathGateTrigger::                          ds 1 ; d9c6
wLaurelForestPokemonOnlyTrigger::            ds 1 ; d9c7
wRoute34GateTrigger::                        ds 1 ; d9c8
wRoute50GateTrigger::                        ds 1 ; d9c9
	ds 49 ; free space

wMovesObtained::
	ds 32
wItemsObtained::
	ds 32

wAButtonCount:: ds 4 ; da52
wBButtonCount:: ds 4
wSelectButtonCount:: ds 4
wStartButtonCount:: ds 4
wRightButtonCount:: ds 4
wLeftButtonCount:: ds 4
wUpButtonCount:: ds 4
wDownButtonCount:: ds 4

wEventFlags:: ; da72
	flag_array NUM_EVENTS

wBingoCurrentCard:: ds 1 ; db6c
wBingoAwardedPrizes:: ds 2 ; db6d
wBingoMarkedCells:: ds 3 ; db6f

wCurBox:: ; db72
	ds 1
wCatchMonSwitchBox:: ds 1

wMiningPickaxeMode::
	ds 1

; 8 chars + $50
wBoxNames:: ds BOX_NAME_LENGTH * NUM_BOXES ; db75

	ds 2

wBikeFlags:: ; dbf5
; bit 0: using strength
; bit 1: always on bike
; bit 2: downhill
	ds 1

wEncounterRateStage:: ; dbf6
; 0 - encounter rate halved
; 1 - encounter rate normal
; 2 - encounter rate doubled
	ds 1

wCurrentMapTriggerPointer:: ds 2 ; dbf7

wCurrentCaller:: ds 2 ; dbf9
wCurrMapWarpCount:: ds 1 ; dbfb
wCurrMapWarpHeaderPointer:: ds 2 ; dbfc
wCurrentMapXYTriggerCount:: ds 1 ; dbfe
wCurrentMapXYTriggerHeaderPointer:: ds 2 ; dbff
wCurrentMapSignpostCount:: ds 1 ; dc01
wCurrentMapSignpostHeaderPointer:: ds 2 ; dc02
wCurrentMapPersonEventCount:: ds 1 ; dc04
wCurrentMapPersonEventHeaderPointer:: ds 2 ; dc05
wCurrMapTriggerCount:: ds 1 ; dc07
wCurrMapTriggerHeaderPointer:: ds 2 ; dc08
wCurrMapCallbackCount:: ds 1 ; dc0a
wCurrMapCallbackHeaderPointer:: ds 2 ; dc0b

wTimeMachineTimer:: ; day, hour, min, sec, year, month ; dc35
wTimeMachineTimerDay::
	ds 1
wTimeMachineTimerHours::
	ds 1
wTimeMachineTimerMinutes::
	ds 1
wTimeMachineTimerSeconds::
	ds 1
wTimeMachineTimerYear::
	ds 1
wTimeMachineTimerMonth::
	ds 1

; wDaysSince:: ds 1
; wHoursSince:: ds 1
; wMinutesSince:: ds 1
; wSecondsSince:: ds 1
; wYearsSince:: ds 1
; wMonthsSince:: ds 1

wDailyResetTimer::
wDailyResetTimerDay::
	ds 1
wDailyResetTimerHours::
	ds 1
wDailyResetTimerMinutes::
	ds 1
wDailyResetTimerSeconds::
	ds 1
wDailyResetTimerYear::
	ds 1
wDailyResetTimerMonth::
	ds 1

	ds 5

wDailyFlags:: ds 1
wWeeklyFlags:: ds 1
wSwarmFlags:: ds 1

wTowerTycoonsDefeated:: ds 2 ; dc21 (little-endian)

wCageKeyDoorsArrayBank:: ds 1
wCageKeyDoorsArrayPointer::	ds 2
wCageKeyDoorsArrayLength:: ds 1

wFruitTreeFlags:: ds 4 ; dc27

wPachisiWinCount:: ds 2 ; dc2b (little-endian)

	ds 2

wTreasureBagCount:: ds 1
wTreasureBag:: ds TREASURE_BAG_CAPACITY
wTreasureBagEnd:: ds 1

MACRO orphanage_record
\1Species:: db
\1Year:: db
\1Month:: db
\1Day:: db
ENDM

wOrphanageDonation1:: orphanage_record wOrphanageDonation1
wOrphanageDonation2:: orphanage_record wOrphanageDonation2
wOrphanageDonation3:: orphanage_record wOrphanageDonation3
wOrphanageDonation4:: orphanage_record wOrphanageDonation4
wOrphanageDonation5:: orphanage_record wOrphanageDonation5
wOrphanageDonation6:: orphanage_record wOrphanageDonation6
wOrphanageDonation7:: orphanage_record wOrphanageDonation7
wOrphanageDonationEnd::

	ds 3

wYanmaMapGroup:: ds 1 ; dc5a
wYanmaMapNumber:: ds 1

wGlobalStepCounter:: ds 4
wBattlesWonCounter:: ds 3
wTotalBattleTime:: ds 6 ; 3 byte hours (big endian), minutes, seconds, hundredths

	ds 6

wAccumulatedOrphanPoints:: ds 4 ; dc6f, big endian

wStepCount:: ; dc73
	ds 1
wPoisonStepCount:: ; dc74
	ds 1

wFossilsRevived:: ds 2 ; dc75 (little-endian)

wHappinessStepCount:: ds 1

wSavedMiningItem::
	ds 1

	ds 3

wLastRepelUsed:: ds 1 ; dc7c used to be the phone list

wFossilCaseCount:: ds 1 ; cd7d
wFossilCase:: ds FOSSIL_CASE_SIZE ; dc7e
wFossilCaseEnd:: ds 1 ; dc9c

	ds 4

wRepelEffect:: ds 2 ; If a Repel is in use, it contains the nr of steps it's still active
wBikeStep:: ds 1
wKurtApricornQuantity:: ds 1

wPlayerDataEnd::


wMapData::
	ds 4

wDigWarp:: ds 1
wDigMapGroup:: ds 1
wDigMapNumber:: ds 1
; used on maps like second floor pokécenter, which are reused, so we know which
; map to return to
wBackupWarpNumber:: ; dcac
	ds 1
wBackupMapGroup:: ; dcad
	ds 1
wBackupMapNumber:: ; dcae
	ds 1

	ds 3

wLastSpawnMapGroup:: ds 1
wLastSpawnMapNumber:: ds 1

wWarpNumber:: ; dcb4
	ds 1
wMapGroup:: ; dcb5
	ds 1 ; map group of current map
wMapNumber:: ; dcb6
	ds 1 ; map number of current map
wYCoord:: ; dcb7
	ds 1 ; current y coordinate relative to top-left corner of current map
wXCoord:: ; dcb8
	ds 1 ; current x coordinate relative to top-left corner of current map
wScreenSave:: ds 6 * 5

wMapDataEnd::

wPokemonData::

wPartyCount:: ; dcd7
	ds 1 ; number of Pokémon in party
wPartySpecies:: ; dcd8
	ds PARTY_LENGTH ; species of each Pokémon in party
wPartyEnd:: ; dcde
	ds 1 ; legacy scripts don't check wPartyCount

wPartyMons::
wPartyMon1:: party_struct wPartyMon1 ; dcdf
wPartyMon2:: party_struct wPartyMon2 ; dd0f
wPartyMon3:: party_struct wPartyMon3 ; dd3f
wPartyMon4:: party_struct wPartyMon4 ; dd6f
wPartyMon5:: party_struct wPartyMon5 ; dd9f
wPartyMon6:: party_struct wPartyMon6 ; ddcf

wPartyMonOT:: ds NAME_LENGTH * PARTY_LENGTH ; ddff

wPartyMonNicknames:: ds PKMN_NAME_LENGTH * PARTY_LENGTH ; de41
wPartyMonNicknamesEnd::

wPokeonlyMainSpecies:: ds 1
wPokeonlyBackupPokemonSpecies:: ds 2
wPokeonlyMainDVs:: ds 2
wPokeonlyBackupPokemonOT:: ds NAME_LENGTH

wSavedPlayerCharacteristics2::
	ds 5
wSavedPlayerCharacteristics2End::

wPokeonlyMonPalette::
	ds 1

wPokedexCaught:: ; de99
	flag_array NUM_POKEMON
wEndPokedexCaught::

wPokedexSeen:: ; deb9
	flag_array NUM_POKEMON
wEndPokedexSeen::

wBadges::
wNaljoBadges:: ; ded9
	flag_array 8
wRijonBadges:: ; deda
	flag_array 8
wOtherBadges:: ; dedb
	flag_array 8
wVisitedSpawns:: ; dedc
	flag_array NUM_SPAWNS ;5

wBattleArcadeMaxScore:: ds 4 ; dee1
wBattleArcadeMaxRound:: ds 2 ; dee5
wBattleArcadeTickets:: ds 3 ; dee7

wBattleArcadeRunData::
wBattleArcadeRunningScore:: ds 4 ; deea
wBattleArcadeCurrentRound:: ds 2 ; deee
wBattleArcadeDifficulty:: ds 1 ; def0
wBattleArcadeRoundScore:: ds 2 ; def1
wBattleArcadeRunDataEnd::

	ds 2

wDaycareMan:: ; def5
; bit 7: active
; bit 6: egg ready
; bit 5: monsters are compatible
; bit 0: monster 1 in daycare
	ds 1

wBreedMon1::
wBreedMon1Nick::  ds PKMN_NAME_LENGTH ; def6
wBreedMon1OT::    ds NAME_LENGTH ; df01
wBreedMon1Stats:: box_struct wBreedMon1 ; df0c

wDaycareLady:: ; df2c
; bit 7: active
; bit 0: monster 2 in daycare
	ds 1

wStepsToEgg:: ; df2d
	ds 1
wBreedMotherOrNonDitto:: ; df2e
;  z: yes
; nz: no
	ds 1

wBreedMon2::
wBreedMon2Nick::  ds PKMN_NAME_LENGTH ; df2f
wBreedMon2OT::    ds NAME_LENGTH ; df3a
wBreedMon2Stats:: box_struct wBreedMon2 ; df45

wEggNick:: ds PKMN_NAME_LENGTH ; df65
wEggOT::   ds NAME_LENGTH ; df70
wEggMon::  box_struct wEggMon ; df7b

wBackupSecondPartySpecies:: ds 1

wBackupMon:: party_struct wBackupMon

wDunsparceMapGroup:: ds 1
wDunsparceMapNumber:: ds 1
wFishingSwarmFlag:: ds 1

MACRO roam_struct
\1Species::   db
\1Level::     db
\1MapGroup::  db
\1MapNumber:: db
\1HP::        ds 2
\1DVs::       ds 2
ENDM

wRoamMon1:: roam_struct wRoamMon1 ; dfcf

wPlayerCharacteristics::
wPlayerGender::
; bit 0: gender
; bits 1-3: character model
; bits 4-6: skin tone
	ds 1

wPlayerClothesPalette::
	ds 2

wPlayerClothesScrollPosition::
	ds 1
wPlayerCustMenuCursorBuffer::
	ds 1
wPlayerCharacteristicsEnd::

wParkMinigamePokeBalls:: ds 1
wParkMinigameGreatBalls:: ds 1
wParkMinigameUltraBalls:: ds 1
wParkMinigameMasterBalls:: ds 1

	ds 4

wRoamMons_CurrentMapNumber:: ds 1
wRoamMons_CurrentMapGroup:: ds 1
wRoamMons_LastMapNumber:: ds 1
wRoamMons_LastMapGroup:: ds 1

; dfe8
wPokemonDataEnd::
wGameDataEnd::

wRTC:: ; dfe8
wRTCBaseDay:: ds 1
wRTCBaseHours:: ds 1
wRTCBaseMinutes:: ds 1
wRTCBaseSeconds:: ds 1
wRTCBaseYear:: ds 1
wRTCBaseMonth:: ds 1
wRTCEnd::

wScriptTemp:: ds 4 ;dfee

SECTION "WRAM 2 aligned", WRAMX

wDebugMenuScratchArea:: ds $200 ;d000

wStopwatchCounters:: ds $20 ; d200 (MUST be aligned to a multiple of 4)

SECTION "Pic Animations WRAM", WRAMX

wTempTileMap::
; 20x18 grid of 8x8 tiles
	ds SCREEN_WIDTH * SCREEN_HEIGHT ; $168 = 360

; This struct must not cross a 256-byte boundary
; PokeAnim Header
wPokeAnimSceneIndex:: ds 1
wPokeAnimPointer:: ds 2
wPokeAnimSpecies:: ds 1
	ds 1

wPokeAnimSpecies2:: ds 1
wPokeAnimGraphicStartTile:: ds 1
wPokeAnimCoord:: ds 2
wPokeAnimFrontpicHeight:: ds 1
; PokeAnim Data
wPokeAnimExtraFlag:: ds 1
wPokeAnimSpeed:: ds 1
wPokeAnimPointerBank:: ds 1
wPokeAnimPointerAddr:: ds 2
wPokeAnimFramesBank:: ds 1
wPokeAnimFramesAddr:: ds 2
wPokeAnimBitmaskBank:: ds 1
wPokeAnimBitmaskAddr:: ds 2
wPokeAnimFrame:: ds 1
wPokeAnimJumptableIndex:: ds 1
wPokeAnimRepeatTimer:: ds 1
wPokeAnimWaitCounter:: ds 1
wPokeAnimCommand:: ds 1
wPokeAnimParameter:: ds 1
wPokeAnimBitmaskCurCol:: ds 1
wPokeAnimBitmaskCurRow:: ds 1
wPokeAnimBitmaskBuffer:: ds 7
wPokeAnimDestination:: ds 2
wPokeAnimStructEnd::

SECTION "Battle Tower", WRAMX

wBattleTower::
wBTCurStreak:: ds 1
wBTChoiceOfLvlGroup:: ds 1
wBTOpponentIndices:: ds 7
wBTMonsSelected:: ds 3 * 7
wBTOTTrainer:: battle_tower_struct wBTOT
wBTTrainerTextIndex:: ds 2
wBTWinStreak:: ds 1
wBattleTowerEnd::

SECTION "WRAM 2 extra", WRAMX

wPartyBackup:: ds wPartyMonNicknamesEnd - wPokemonData

wBigNumerator:: ds 16
	ds 8 ;this space intentionally left blank
wBigDenominator:: ds 16
wBigNumberBuffer:: ds 16

wDEDTempSamp::
	ds 16
wGetDEDByte::
	ds $100
; dynamic code is loaded here
wGetDEDByteEnd::

wScriptVarStackCount:: ds 1
wScriptVarStack:: ds 15 ; assuming that nothing will exceed this limit

wExtraData::

wShinyTreeSeed:: ds 8

wEventVariables:: ds 64

	ds 326

wDonatedFossils:: ds 2

wExtraDataEnd::

SECTION "Sound Stack", WRAMX

wSoundStack:: ds SOUND_STATE_SIZE * SOUND_STACK_CAPACITY
wSoundStackSize:: db

SECTION "Metatiles", WRAMX
wDecompressedMetatiles::
	ds 256 * 16

SECTION "Attributes", WRAMX
wDecompressedAttributes::
	ds 256 * 16

SECTION UNION "Collisions + Spectrum + Battle Animations + Trainer Card Leader Palettes", WRAMX
wDecompressedCollision::
	ds 256 * 4

SECTION "Stable RNG", WRAMX
wStableRNGData::
wStableRNGDataEntry::
wMiningStableRNGCallCount:: ds 2
wMiningStableRNGSeed:: ds 8
wStableRNGDataEntryEnd::
wSmeltingOreStableRNGCallCount:: ds 2
wSmeltingOreStableRNGSeed:: ds 8
wSmeltingCoalStableRNGCallCount:: ds 2
wSmeltingCoalStableRNGSeed:: ds 8
wStableRNGDataEnd::

wStableRNGReseedValues::
wMiningStableRNGReseed:: ds 8
wSmeltingOreStableRNGReseed:: ds 8
wSmeltingCoalStableRNGReseed:: ds 8
wStableRNGOnlyReseedValuesEnd::
wBallRNGSeeds::
wEagulouBallStableRNGSeedData::
wUltraBallStableRNGSeedData:: ds 8
wGreatBallStableRNGSeedData:: ds 8
wPokeBallStableRNGSeedData:: ds 8
wDiveBallStableRNGSeedData:: ds 8
wFastBallStableRNGSeedData:: ds 8
wFriendBallStableRNGSeedData:: ds 8
wParkBallStableRNGSeedData:: ds 8
wShinyBallStableRNGSeedData:: ds 8
wQuickBallStableRNGSeedData:: ds 8
wDuskBallStableRNGSeedData:: ds 8
wRepeatBallStableRNGSeedData:: ds 8
wTimerBallStableRNGSeedData:: ds 8
wBallRNGSeedsEnd::
wStableRNGReseedValuesEnd::

wStableRNGReseedFlags:: ds 1 ; flag_array (wStableRNGOnlyReseedValuesEnd - wStableRNGReseedValues)

SECTION "GBC Video", WRAMX

; 8 4-color palettes
wOriginalBGPals::  ds 8 palettes ; d000
wOriginalOBJPals:: ds 8 palettes ; d040
wBGPals::          ds 8 palettes ; d080
wOBPals::          ds 8 palettes ; d0c0

SECTION "LY Overrides", WRAMX
wLYOverrides:: ; d100
	ds SCREEN_HEIGHT_PX
wLYOverridesEnd:: ; d190

SECTION "Magnet Train", WRAMX
wMagnetTrainDirection:: ds 1
wMagnetTrainInitPosition:: ds 1
wMagnetTrainHoldPosition:: ds 1
wMagnetTrainFinalPosition:: ds 1
wMagnetTrainPlayerSpriteInitX:: ds 1

SECTION "LY Overrides Staging", WRAMX
wLYOverridesBackup:: ; d200
	ds SCREEN_HEIGHT_PX
wLYOverridesBackupEnd::

SECTION UNION "Collisions + Spectrum + Battle Animations + Trainer Card Leader Palettes", WRAMX
wTitleScreenBGPIListAndSpectrumColours::

SECTION UNION "Collisions + Spectrum + Battle Animations + Trainer Card Leader Palettes", WRAMX
wBattleAnimTileDict:: ds 10

MACRO battle_anim_struct
; Placeholder until we can figure out what it all means
\1_Index::  ds 1
\1_Flags:: ds 1
\1_YFixParam:: ds 1
\1_FramesetIndex:: ds 1
\1_FunctionIndex:: ds 1
\1_Palette:: ds 1
\1_TileID:: ds 1
\1_XCoord:: ds 1
\1_YCoord:: ds 1
\1_XOffset:: ds 1
\1_YOffset:: ds 1
\1_Param:: ds 1
\1_Anim0c:: ds 1
\1_Anim0d:: ds 1
\1_AnonJumptableIndex:: ds 1
\1_Anim0f:: ds 1
\1_Anim10:: ds 1
\1_Anim11:: ds 1
\1_Anim12:: ds 1
\1_Anim13:: ds 1
\1_Anim14:: ds 1
\1_Anim15:: ds 1
\1_Anim16:: ds 1
\1_Anim17:: ds 1
ENDM

wActiveAnimObjects:: ; d30a
wAnimObject01:: battle_anim_struct wAnimObject01
wAnimObject02:: battle_anim_struct wAnimObject02
wAnimObject03:: battle_anim_struct wAnimObject03
wAnimObject04:: battle_anim_struct wAnimObject04
wAnimObject05:: battle_anim_struct wAnimObject05
wAnimObject06:: battle_anim_struct wAnimObject06
wAnimObject07:: battle_anim_struct wAnimObject07
wAnimObject08:: battle_anim_struct wAnimObject08
wAnimObject09:: battle_anim_struct wAnimObject09
wAnimObject10:: battle_anim_struct wAnimObject10
wActiveAnimObjectsEnd:: ; d3aa

MACRO battle_bg_effect
\1_Function:: ds 1
\1_01:: ds 1
\1_02:: ds 1
\1_03:: ds 1
ENDM

wActiveBGEffects:: ; d3fa
wBGEffect1:: battle_bg_effect BGEffect1
wBGEffect2:: battle_bg_effect BGEffect2
wBGEffect3:: battle_bg_effect BGEffect3
wBGEffect4:: battle_bg_effect BGEffect4
wBGEffect5:: battle_bg_effect BGEffect5
wActiveBGEffectsEnd::

wNumActiveBattleAnims:: ds 1 ; d40e

wBattleAnimFlags:: ; d40f
	; bit 0: animation is done
	; bit 1: in subroutine
	; bit 2: loop in progress (wBattleAnimLoops contains remaining counter)
	; bit 3: sprite clearing requested (?)
	ds 1
wBattleAnimAddress:: ; d410
	ds 2
wBattleAnimDuration:: ; d412
	ds 1
wBattleAnimParent:: ; d413
	ds 2
wBattleAnimLoops:: ; d415
	ds 1
wBattleAnimVar:: ; d416
	ds 1
wBattleAnimByte:: ; d417
	ds 1
wBattleAnimOAMPointerLo:: ds 1 ; d418
wBattleAnimTemps:: ; d419
wBattleAnimTempOAMFlags::
wBattleAnimTemp0:: ds 1
wBattleAnimTemp1:: ds 1
wBattleAnimTempTileID::
wBattleAnimTemp2:: ds 1
wBattleAnimTempXCoord::
wBattleAnimTemp3:: ds 1
wBattleAnimTempYCoord::
wBattleAnimTemp4:: ds 1
wBattleAnimTempXOffset::
wBattleAnimTemp5:: ds 1
wBattleAnimTempYOffset::
wBattleAnimTemp6:: ds 1
wBattleAnimTemp7:: ds 1
wBattleAnimTempPalette::
wBattleAnimTemp8:: ds 1

UNION ; 1: 5:d422
wSurfWaveBGEffect:: ds $40
wSurfWaveBGEffectEnd::
NEXTU ; 1: 5:d422
ds $32
wBattleAnimEnd::
ENDU ; 1: 5:d422

SECTION UNION "Collisions + Spectrum + Battle Animations + Trainer Card Leader Palettes", WRAMX
wTrainerCardLeaderPals:: ds 20 * 4
wTrainerCardBadgePals:: ds 20 * 4
wTrainerCardBadgePalsEnd::
wTempBadges:: ds 3

SECTION "3D Prism", WRAMX
w3DPrismBitMasks:: ds 9
w3DPrismAngles:: ds 4
w3DPrismXIncs:: ds 3 * 2
w3DPrismShadePos:: ds 1
w3DPrismState:: ds 1
w3DPrismPage:: ds 1
wTitleCloudsCounter:: ds 1

SECTION "Palettes 2", WRAMX
wBGPalsBuffer2:: ds 8 palettes
wOBPalsBuffer2:: ds 8 palettes
wFadeTempColors:: ds 16 * 4 * 3 * 2
wFadeDeltas:: ds 16 * 4 * 3 * 2

UNION
wTownMapLandmarks:: ds LANDMARK_MAP_WIDTH * LANDMARK_MAP_HEIGHT
wTownMapLandmarksEnd::
NEXTU
w3DPrismTmpGFX:: ds 63 tiles
ENDU

SECTION "WRAM 6", WRAMX

wDecompressScratch:: ds $400
wDecompressScratch2:: ds $800
wBackupAttrMap:: ds $400

SECTION "WRAM 7", WRAMX
wWindowStack:: ds $1000 - 1
wWindowStackBottom:: ds 1

INCLUDE "sram.asm"
