SaveMenu:
	call LoadStandardMenuHeader
	callba DisplaySaveInfoOnSave
	call SpeechTextBox
	call UpdateSprites
	call CopyTilemapAtOnce
	ld hl, .want_to_save_text
	call SaveTheGame_yesorno
	jr nz, .refused
	call AskOverwriteSaveFile
	jr c, .refused
	call PauseGameLogic
	call SaveTheGame
	call ResumeGameLogic
	call ExitMenu
	and a
	ret

.refused
	call ExitMenu
	call CopyTilemapAtOnce
	scf
	ret

.want_to_save_text
	ctxt "Would you like to"
	line "save the game?"
	done

BattleTower_SaveGame::
	ld a, [wd265]
	push af
	call AskOverwriteSaveFile
	jr c, FinishCustomSaveFunction
	call PauseGameLogic
	call SaveGameData
	call ResumeGameLogic
	and a
	jr FinishCustomSaveFunction

Special_TryQuickSave:
	ld a, [wd265]
	push af
	call Link_SaveGame
FinishCustomSaveFunction:
	; a = carry ? 0 : 1
	sbc a
	inc a
	ldh [hScriptVar], a
	pop af
	ld [wd265], a
	ret

SaveAfterLinkTrade:
	call PauseGameLogic
	call AddRTCToSavedRTCAndResetRTC_NoLoadFromSRAM
	call SavePokemonData
	call SaveChecksum
	call SaveBackupPokemonData
	call SaveBackupChecksum
	callba SaveRTC
	jp ResumeGameLogic

ChangeBoxNoSaveGame:
	call PauseGameLogic
	call SaveBox
	ld a, [wCatchMonSwitchBox]
	ld [wCurBox], a
	call LoadBox
	call SaveGameData
	jp ResumeGameLogic

ChangeBoxSaveGame:
	push de
	ld hl, .will_save_text
	call MenuTextBox
	call YesNoBox
	call ExitMenu
	jr c, .refused
	call AskOverwriteSaveFile
	jr c, .refused
	call PauseGameLogic
	call SaveBox
	pop de
	ld a, e
	ld [wCurBox], a
	call LoadBox
	call SaveTheGame
	call ResumeGameLogic
	and a
	ret
.refused
	pop de
	ret

.will_save_text
	ctxt "When you change a"
	line "#mon Box, data"
	cont "will be saved. OK?"
	done

Link_SaveGame:
	call AskOverwriteSaveFile
	ret c
	call PauseGameLogic
	call SaveTheGame
	call ResumeGameLogic
	and a
	ret

MovePkmnWOMail_SaveGame:
	call PauseGameLogic
	push de
	call SaveBox
	pop de
	ld a, e
	ld [wCurBox], a
	call LoadBox
	jp ResumeGameLogic

SaveGameDataFromMoveMon:
	call PauseGameLogic
	push de
	call SaveBox
	pop de
	ld a, e
	ld [wCurBox], a
	ld a, 1
	ld [wSaveFileExists], a
	call AddRTCToSavedRTCAndResetRTC_NoLoadFromSRAM
	call ValidateSave
	call SaveOptions
	call SavePlayerData
	call SavePokemonData
	call SaveExtraData
	call SaveChecksum
	call SaveStableRNGSeeds
	call ValidateBackupSave
	call SaveBackupOptions
	call SaveBackupPlayerData
	call SaveBackupPokemonData
	call SaveBackupExtraData
	call SaveBackupChecksum
	callba SaveRTC
	call LoadBox
	call ResumeGameLogic
	ld de, SFX_SAVE
	jp PlaySFX

StartMovePkmnWOMail_SaveGame:
	ld hl, .will_save_text
	call MenuTextBox
	call YesNoBox
	call ExitMenu
	jr c, .refused
	call AskOverwriteSaveFile
	jr c, .refused
	call PauseGameLogic
	call SaveTheGame
	call ResumeGameLogic
	and a
	ret

.refused
	scf
	ret

.will_save_text
	ctxt "Each time you move"
	line "a #mon, data"
	cont "will be saved. OK?"
	done

PauseGameLogic:
	ld a, 1
	ld [wGameLogicPause], a
	ret

ResumeGameLogic:
	xor a
	ld [wGameLogicPause], a
	ret

AddHallOfFameEntry:
	sbk BANK(sHallOfFame)
	ld hl, sHallOfFame + HOF_LENGTH * (NUM_HOF_TEAMS - 1) - 1
	ld de, sHallOfFame + HOF_LENGTH * NUM_HOF_TEAMS - 1
	ld bc, HOF_LENGTH * (NUM_HOF_TEAMS - 1)
.loop
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ld hl, wOverworldMap
	ld de, sHallOfFame
	ld bc, HOF_LENGTH
	rst CopyBytes
	jp CloseSRAM

AskOverwriteSaveFile:
	ld a, [wSaveFileExists]
	and a
	jr z, .erase
	call CompareLoadedAndSavedPlayerID
	jr z, .ok
	ld hl, .another_save_text
	call SaveTheGame_yesorno
	jr z, .erase
	scf
	ret

.erase
	call ErasePreviousSave
.ok
	and a
	ret

.another_save_text
	ctxt "There is another"
	line "save file. Is it"
	cont "OK to overwrite?"
	done

SaveTheGame_yesorno:
	ld b, BANK(SaveTheGame_yesorno)
	call MapTextbox
	call LoadMenuTextBox
	lb bc, 0, 7
	call PlaceYesNoBox
	ld a, [wMenuCursorY]
	dec a
	call CloseWindow
	and a
	ret

CompareLoadedAndSavedPlayerID:
	sbk BANK(sPlayerData)
	ld hl, sPlayerData + (wPlayerID - wPlayerData)
	ld a, [hli]
	ld c, [hl]
	ld b, a
	ld hl, sPlayerData + (wSecretID - wPlayerData)
	ld a, [hli]
	ld e, [hl]
	ld d, a
	scls
	ld a, [wPlayerID]
	cp b
	ret nz
	ld a, [wPlayerID + 1]
	cp c
	ret nz
	ld a, [wSecretID]
	cp d
	ret nz
	ld a, [wSecretID + 1]
	cp e
	ret

SaveTheGame::
	call SaveGameData
PrintSavedGameText::
	ld hl, .saved_text
	call PrintText
	ld de, SFX_SAVE
	call WaitPlaySFX
	jp WaitSFX

.saved_text
	ctxt "<PLAYER> saved"
	line "the game."
	done

SaveGameData::
	ldh a, [hVBlank]
	push af
	ld a, 2
	ldh [hVBlank], a
	dec a
	ld [wSaveFileExists], a
	call AddRTCToSavedRTCAndResetRTC_NoLoadFromSRAM
	sbk BANK(sBuildNumber)
	ld hl, sBuildNumber
	ld [hl], LOW(BUILD_NUMBER)
	inc hl
	ld [hl], HIGH(BUILD_NUMBER)
	call ValidateSave
	call SaveOptions
	call SavePlayerData
	call SavePokemonData
	call SaveBox
	call SaveExtraData
	call SaveChecksum
	call SaveStableRNGSeeds
	call ValidateBackupSave
	call SaveBackupOptions
	call SaveBackupPlayerData
	call SaveBackupPokemonData
	call SaveBackupExtraData
	call SaveBackupChecksum
	call UpdateStackTop
	callba SaveRTC
	sbk BANK(sBattleTowerChallengeState)
	ld a, [sBattleTowerChallengeState]
	cp BATTLETOWER_RECEIVED_REWARD
	jr nz, .ok
	xor a
	ld [sBattleTowerChallengeState], a
.ok
	pop af
	ldh [hVBlank], a
	jp CloseSRAM

SaveStableRNGSeeds:
	ld hl, wStableRNGData
	ld de, sStableRNGData
	sbk BANK(sStableRNGData)
	ld a, BANK(wStableRNGData)
	call StackCallInWRAMBankA
	; end of function

	xor a
.loop
	push af
	ld c, a
	ld a, [hli]
	or [hl]
	jr nz, .skipCopyingReseed1
	push hl
	push de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	or b
	jr z, .skipCopyingReseed2 ; don't copy if the saved count is zero
	push hl
	push bc
	ld hl, wStableRNGReseedFlags
	ld b, CHECK_FLAG
	predef FlagAction
	pop bc
	pop hl
	jr nz, .skipCopyingReseed2
	push hl
	push bc
	ld hl, wStableRNGReseedFlags
	ld b, SET_FLAG
	predef FlagAction
	pop bc
	pop hl
	ld d, h
	ld e, l
	inc de
	ld b, 0
	ld a, (wStableRNGDataEntryEnd - wStableRNGDataEntry)
	ld hl, wStableRNGReseedValues
	rst AddNTimes
	ld bc, 8
	rst CopyBytes

.skipCopyingReseed2
	pop de
	pop hl
.skipCopyingReseed1
	dec hl
	ld bc, (wStableRNGDataEntryEnd - wStableRNGDataEntry)
	rst CopyBytes
	pop af
	inc a
	cp (wStableRNGDataEnd - wStableRNGData) / 10
	jr c, .loop
	jp CloseSRAM

LoadStableRNGSeeds:
	ld hl, sStableRNGData
	ld de, wStableRNGData
	ld bc, wStableRNGDataEnd - wStableRNGData
	ld a, BANK(wStableRNGData)
	call StackCallInWRAMBankA
	; end of function

	sbk BANK(sStableRNGData)
	rst CopyBytes
	jp CloseSRAM

UpdateStackTop:
; sStackTop appears to be unused.
; It could have been used to debug stack overflow during saving.
	call FindStackTop
	sbk BANK(sStackTop)
	ld a, [sStackTop]
	ld e, a
	ld a, [sStackTop + 1]
	ld d, a
	or e
	jr z, .update
	ld a, e
	sub l
	ld a, d
	sbc h
	jr c, .done
.update
	ld a, l
	ld [sStackTop], a
	ld a, h
	ld [sStackTop + 1], a
.done
	jp CloseSRAM

FindStackTop:
; Find the furthest point that sp has traversed to.
; This is distinct from the current value of sp.
	ld hl, wStackBottom + 2
.loop
	ld a, [hli]
	and a
	jr z, .loop
	dec hl
	ret

ErasePreviousSave:
	call EraseBoxes
	call EraseHallOfFame
	call EraseLinkBattleStats
	call EraseBattleTowerStatus
	sbk BANK(sStackTop)
	xor a
	ld [sStackTop], a
	ld [sStackTop + 1], a
	scls
	ld a, 1
	ld [wSavedAtLeastOnce], a
	ret

EraseLinkBattleStats:
	sbk BANK(sLinkBattleStats)
	ld hl, sLinkBattleStats
	ld bc, sLinkBattleStatsEnd - sLinkBattleStats
	jr ErasePartialSavedData

EraseHallOfFame:
	sbk BANK(sHallOfFame)
	ld hl, sHallOfFame
	ld bc, sHallOfFameEnd - sHallOfFame
ErasePartialSavedData:
	xor a
	call ByteFill
	jp CloseSRAM

EraseBattleTowerStatus:
	sbk BANK(sBattleTowerChallengeState)
	xor a
	ld [sBattleTowerChallengeState], a
	jp CloseSRAM

HallOfFame_InitSaveIfNeeded:
	ld a, [wSavedAtLeastOnce]
	and a
	ret nz
	jp ErasePreviousSave

ValidateSave:
	sbk BANK(sValidCheck1)
	ld a, 99
	ld [sValidCheck1], a
	ld a, " "
	ld [sValidCheck2], a
	jp CloseSRAM

SaveOptions:
	sbk BANK(sOptions)
	ld hl, wOptions
	ld de, sOptions
	ld bc, wOptionsEnd - wOptions
	rst CopyBytes
	ld a, [wOptions]
	and ~(1 << NO_TEXT_SCROLL)
	ld [sOptions], a
	jp CloseSRAM

SavePlayerData:
	sbk BANK(sPlayerData)
	ld hl, wPlayerData
	ld de, sPlayerData
	ld bc, wPlayerDataEnd - wPlayerData
	rst CopyBytes
	ld hl, wMapData
	ld de, sMapData
	ld bc, wMapDataEnd - wMapData
	rst CopyBytes
	jp CloseSRAM

SavePokemonData:
	sbk BANK(sPokemonData)
	ld hl, wPokemonData
	ld de, sPokemonData
	ld bc, wPokemonDataEnd - wPokemonData
	rst CopyBytes
	jp CloseSRAM

SaveExtraData:
	wbk BANK(wExtraData) ;no need to push rSVBK because we know it must be 1 when this function is called
	sbk BANK(sExtraData)
	ld hl, wExtraData
	ld de, sExtraData
	ld bc, wExtraDataEnd - wExtraData
	rst CopyBytes
	wbk BANK(wPlayerData)
	jp CloseSRAM

SaveBox:
	call GetBoxAddress
	jp SaveBoxAddress

SaveChecksum:
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	sbk BANK(sGameData)
	call Checksum
	ld hl, sChecksum
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, sExtraData
	ld bc, wExtraDataEnd - wExtraData
	call Checksum
	ld hl, sExtraChecksum
	ld a, e
	ld [hli], a
	ld [hl], d
	jp CloseSRAM

ValidateBackupSave:
	sbk BANK(sBackupValidCheck1)
	ld a, 99
	ld [sBackupValidCheck1], a
	ld a, " "
	ld [sBackupValidCheck2], a
	jp CloseSRAM

SaveBackupOptions:
	sbk BANK(sBackupOptions)
	ld hl, wOptions
	ld de, sBackupOptions
	ld bc, wOptionsEnd - wOptions
	rst CopyBytes
	jp CloseSRAM

SaveBackupPlayerData:
	sbk BANK(sBackupPlayerData)
	ld hl, wPlayerData
	ld de, sBackupPlayerData
	ld bc, wPlayerDataEnd - wPlayerData
	rst CopyBytes
	ld hl, wMapData
	ld de, sBackupMapData
	ld bc, wMapDataEnd - wMapData
	rst CopyBytes
	jp CloseSRAM

SaveBackupPokemonData:
	sbk BANK(sBackupPokemonData)
	ld hl, wPokemonData
	ld de, sBackupPokemonData
	ld bc, wPokemonDataEnd - wPokemonData
	rst CopyBytes
	jp CloseSRAM

SaveBackupExtraData:
	wbk BANK(wExtraData) ;no need to push rSVBK because we know it must be 1 when this function is called
	sbk BANK(sBackupExtraData)
	ld hl, wExtraData
	ld de, sBackupExtraData
	ld bc, wExtraDataEnd - wExtraData
	rst CopyBytes
	wbk BANK(wPlayerData)
	jp CloseSRAM

SaveBackupChecksum:
	ld hl, sBackupGameData
	ld bc, sBackupGameDataEnd - sBackupGameData
	sbk BANK(sBackupGameData)
	call Checksum
	ld hl, sBackupChecksum
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, sBackupExtraData
	ld bc, wExtraDataEnd - wExtraData
	call Checksum
	ld hl, sBackupExtraChecksum
	ld a, e
	ld [hli], a
	ld [hl], d
	jp CloseSRAM

AddRTCToSavedRTCAndResetRTC_NoLoadFromSRAM:
	ld de, StageRTCTimeForSave_NoLoadFromSRAM
	jr AddRTCToSavedRTCAndResetRTC_common

AddRTCToSavedRTCAndResetRTC:
	ld de, StageRTCTimeForSave

AddRTCToSavedRTCAndResetRTC_common:
	ld a, [wGameLogicPause]
	push af
	call PauseGameLogic
	sbk BANK(sRTCStatusFlags)
	ld hl, sRTCStatusFlags
	ld a, [hl]
	push af
	set 7, [hl]
	scls
	ld h, d
	ld l, e
	ld a, BANK(StageRTCTimeForSave)
	call FarCall_hl
	call PanicResetClock
	sbk BANK(sRTCStatusFlags)
	pop af
	ld [sRTCStatusFlags], a
	scls
	pop af
	ld [wGameLogicPause], a
	ret

TryLoadSaveFile:
	call VerifyChecksum
	jr nz, .backup
	call LoadPlayerData
	call LoadPokemonData
	call LoadExtraData
	call LoadBox
	call LoadStableRNGSeeds
	call ValidateBackupSave
	call SaveBackupOptions
	call SaveBackupPlayerData
	call SaveBackupPokemonData
	call SaveBackupExtraData
	call SaveBackupChecksum
	call AddRTCToSavedRTCAndResetRTC
	call FixMapObjectPointersOnContinue
	and a
	ret

.backup
	call VerifyBackupChecksum
	jr nz, .corrupt
	call LoadBackupPlayerData
	call LoadBackupPokemonData
	call LoadBackupExtraData
	call LoadBox
	call ValidateSave
	call SaveOptions
	call SavePlayerData
	call SavePokemonData
	call SaveExtraData
	call SaveChecksum
	call AddRTCToSavedRTCAndResetRTC
	call FixMapObjectPointersOnContinue
	ld hl, .SaveFileCorrruptPreviousLoadedText
	call PrintInstantText
	and a
	ret

.corrupt
	ld hl, .corrupted_text
	call PrintInstantText
	scf
	ret

.corrupted_text
	ctxt "The save file is"
	line "corrupted!"
	prompt

.SaveFileCorrruptPreviousLoadedText
	ctxt "The save file is"
	line "corrupted. The"
	para "previous save file"
	line "will be loaded."
	prompt

TryLoadSaveData:
	xor a
	ld [wSaveFileExists], a
	call CheckPrimarySaveFile
	ld a, [wSaveFileExists]
	and a
	jr z, .backup

	sbk BANK(sPlayerData)
	ld hl, sPlayerData + wPokerusTimerDay - wPlayerData
	ld de, wPokerusTimerDay
	ld bc, 8
	rst CopyBytes
	ld hl, sPlayerData + wStatusFlags - wPlayerData
	ld de, wStatusFlags
	ld a, [hl]
	ld [de], a
	jp CloseSRAM

.backup
	call CheckBackupSaveFile
	ld a, [wSaveFileExists]
	and a
	jr z, .corrupt

	sbk BANK(sBackupPlayerData)
	ld hl, sBackupPlayerData + wPokerusTimerDay - wPlayerData
	ld de, wPokerusTimerDay
	ld bc, 8
	rst CopyBytes
	ld hl, sBackupPlayerData + wStatusFlags - wPlayerData
	ld de, wStatusFlags
	ld a, [hl]
	ld [de], a
	jp CloseSRAM

.corrupt
	ld hl, DefaultOptions
	ld de, wOptions
	ld bc, wOptionsEnd - wOptions
	rst CopyBytes
	jp PanicResetClock

DefaultOptions:
	db $01 | (1 << STEREO); fast text speed, stereo
	db $00 ; wSaveFileExists
	db $00 ; frame 0
	db $01 ; wTextBoxFlags
	db $02 ; gb printer: normal brightness
	db $00 ; no hold to mash
	db $00 ; ??
	db $00 ; ??

CheckPrimarySaveFile:
	sbk BANK(sValidCheck1)
	ld a, [sValidCheck1]
	cp 99
	jr nz, .nope
	ld a, [sValidCheck2]
	cp " "
	jr nz, .nope
	ld hl, sOptions
	ld de, wOptions
	ld bc, wOptionsEnd - wOptions
	rst CopyBytes
	ld a, 1
	ld [wSaveFileExists], a
.nope
	jp CloseSRAM

CheckBackupSaveFile:
	sbk BANK(sBackupValidCheck1)
	ld a, [sBackupValidCheck1]
	cp 99
	jr nz, .nope
	ld a, [sBackupValidCheck2]
	cp " "
	jr nz, .nope
	ld hl, sBackupOptions
	ld de, wOptions
	ld bc, wOptionsEnd - wOptions
	rst CopyBytes
	ld a, 2
	ld [wSaveFileExists], a
.nope
	jp CloseSRAM

LoadPlayerData:
	sbk BANK(sPlayerData)
	ld hl, sPlayerData
	ld de, wPlayerData
	ld bc, wPlayerDataEnd - wPlayerData
	rst CopyBytes
	ld hl, sMapData
	ld de, wMapData
	ld bc, wMapDataEnd - wMapData
	rst CopyBytes
	sbk BANK(sBattleTowerChallengeState)
	ld a, [sBattleTowerChallengeState]
	scls
	cp BATTLETOWER_RECEIVED_REWARD
	ret nz
	ld a, BATTLETOWER_WON_CHALLENGE
	ld [sBattleTowerChallengeState], a
	ret

LoadPokemonData:
	sbk BANK(sPokemonData)
	ld hl, sPokemonData
	ld de, wPokemonData
	ld bc, wPokemonDataEnd - wPokemonData
	rst CopyBytes
	jp CloseSRAM

LoadExtraData:
	wbk BANK(wExtraData) ;no need to push rSVBK because we know it must be 1 when this function is called
	sbk BANK(sExtraData)
	ld hl, sExtraData
	ld de, wExtraData
	ld bc, wExtraDataEnd - wExtraData
	rst CopyBytes
	wbk BANK(wPlayerData)
	jp CloseSRAM

LoadBox:
	call GetBoxAddress
	jp LoadBoxAddress

VerifyChecksum:
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	sbk BANK(sGameData)
	call Checksum
	ld hl, sChecksum
	ld a, [hli]
	cp e
	jr nz, .done
	ld a, [hl]
	cp d
	jr nz, .done
	sbk BANK(sBuildNumber)
	ld hl, sBuildNumber + 1
	ld a, [hld]
	and a
	jr nz, .check_extra
	ld a, [hl]
	cp 151
	jr nc, .check_extra
	cp a
	jr .done
.check_extra
	sbk BANK(sExtraData)
	ld hl, sExtraData
	ld bc, wExtraDataEnd - wExtraData
	call Checksum
	ld hl, sExtraChecksum
	ld a, [hli]
	cp e
	jr nz, .done
	ld a, [hl]
	cp d
.done
	jp CloseSRAM

LoadBackupPlayerData:
	sbk BANK(sBackupPlayerData)
	ld hl, sBackupPlayerData
	ld de, wPlayerData
	ld bc, wPlayerDataEnd - wPlayerData
	rst CopyBytes
	ld hl, sBackupMapData
	ld de, wMapData
	ld bc, wMapDataEnd - wMapData
	rst CopyBytes
	jp CloseSRAM

LoadBackupPokemonData:
	sbk BANK(sBackupPokemonData)
	ld hl, sBackupPokemonData
	ld de, wPokemonData
	ld bc, wPokemonDataEnd - wPokemonData
	rst CopyBytes
	jp CloseSRAM

LoadBackupExtraData:
	wbk BANK(wExtraData) ;no need to push rSVBK because we know it must be 1 when this function is called
	sbk BANK(sBackupExtraData)
	ld hl, sBackupExtraData
	ld de, wExtraData
	ld bc, wExtraDataEnd - wExtraData
	rst CopyBytes
	wbk Bank(wPlayerData)
	jp CloseSRAM

VerifyBackupChecksum:
	ld hl, sBackupGameData
	ld bc, sBackupGameDataEnd - sBackupGameData
	sbk BANK(sBackupGameData) ;BANK(sBackupGameData) == BANK(sBuildNumber)
	call Checksum
	ld hl, sBackupChecksum
	ld a, [hli]
	cp e
	jr nz, .done
	ld a, [hl]
	cp d
	jr nz, .done
	ld hl, sBuildNumber + 1
	ld a, [hld]
	and a
	jr nz, .check_extra
	ld a, [hl]
	cp 151
	jr nc, .check_extra
	cp a
	jr .done
.check_extra
	ld hl, sBackupExtraData
	ld bc, wExtraDataEnd - wExtraData
	call Checksum
	ld hl, sBackupExtraChecksum
	ld a, [hli]
	cp e
	jr nz, .done
	ld a, [hl]
	cp d
.done
	jp CloseSRAM

GetBoxAddress:
	ld a, [wCurBox]
	cp NUM_BOXES
	jr c, .ok
	xor a
	ld [wCurBox], a

.ok
	ld e, a
	ld d, 0
	ld hl, BoxAddresses
rept 5
	add hl, de
endr
	ld a, [hli]
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ret

SaveBoxAddress:
; Save box via wDecompressScratch, instead of wMisc because of WRAM banks.
	ld b, a
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)
	push hl
; Copy to scratch space
	ld a, b
	push af
	push de
	sbk BANK(sBox)
	ld hl, sBox
	ld de, wDecompressScratch
	ld bc, sBoxEnd - sBox
	rst CopyBytes
	scls
	pop de
	pop af
; Save it to the target box.
	sbk a
	ld hl, wDecompressScratch
	ld bc, sBoxEnd - sBox
	jr CopyForLoadOrSaveBoxAddressAndFinish

LoadBoxAddress:
; Load box via wDecompressScratch, instead of wMisc because of WRAM banks.
	sbk a
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)
	push hl
	ld h, d
	ld l, e
	ld de, wDecompressScratch
	ld bc, sBoxEnd - sBox
	rst CopyBytes

	sbk BANK(sBox)
	ld hl, wDecompressScratch
	ld de, sBox
	ld bc, sBoxEnd - sBox
CopyForLoadOrSaveBoxAddressAndFinish:
	rst CopyBytes
	scls
	pop hl
	pop af
	ldh [rSVBK], a
	ret

EraseBoxes:
	ld hl, BoxAddresses
	ld c, NUM_BOXES
.next
	push bc
	sbk [hl]
	inc hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	xor a
	ld [de], a
	inc de
	dec a
	ld [de], a
	inc de
	ld bc, sBoxEnd - (sBox + 2)
.clear
	xor a
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .clear
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, -1
	ld [de], a
	inc de
	xor a
	ld [de], a
	scls
	pop bc
	dec c
	jr nz, .next
	ret

BoxAddresses:
; dbww bank, address, address
	dbww BANK(sBox1),  sBox1,  sBox1End
	dbww BANK(sBox2),  sBox2,  sBox2End
	dbww BANK(sBox3),  sBox3,  sBox3End
	dbww BANK(sBox4),  sBox4,  sBox4End
	dbww BANK(sBox5),  sBox5,  sBox5End
	dbww BANK(sBox6),  sBox6,  sBox6End
	dbww BANK(sBox7),  sBox7,  sBox7End
	dbww BANK(sBox8),  sBox8,  sBox8End
	dbww BANK(sBox9),  sBox9,  sBox9End
	dbww BANK(sBox10), sBox10, sBox10End
	dbww BANK(sBox11), sBox11, sBox11End
	dbww BANK(sBox12), sBox12, sBox12End
	dbww BANK(sBox13), sBox13, sBox13End
	dbww BANK(sBox14), sBox14, sBox14End

Checksum:
	ld de, 0
	inc b
	inc c
	jr .ok
.loop
	ld a, [hli]
	add e
	ld e, a
	adc d
	sub e
	ld d, a
.ok
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret
