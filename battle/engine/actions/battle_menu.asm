BattleMenu:
	xor a
	ldh [hBGMapMode], a
	call LoadTempTileMapToTileMap

	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jr z, .ok
	call EmptyBattleTextBox
	call UpdateBattleHuds
	call EmptyBattleTextBox
	call LoadTileMapToTempTileMap
.ok

.loop
	callba LoadBattleMenu
	ld a, 1
	ldh [hBGMapMode], a
	ld a, [wd0d2]
	dec a
	jr z, BattleMenu_Fight
	dec a
	jp z, BattleMenu_PKMN
	dec a
	jr z, BattleMenu_PackOrGuard
	dec a
	jr nz, .loop
	; fallthrough

BattleMenu_Run:
	call Call_LoadTempTileMapToTileMap
	ld a, 3
	ld [wMenuCursorY], a
	ld hl, wBattleMonSpeed
	ld de, wEnemyMonSpeed
	call TryToRunAwayFromBattle
	ld a, 0
	ld [wFailedToFlee], a
	ret c
	ld a, [wBattlePlayerAction]
	and a
	jr z, BattleMenu
	ret

BattleMenu_Guard:
	ld hl, wPlayerSubStatus2
	set SUBSTATUS_GUARDING, [hl]

; fallthrough
BattleMenu_Fight:
	call CheckIfInEagulouParkBattle
	jr z, .eagulou_park_battle
	xor a
	ld [wNumFleeAttempts], a
	call Call_LoadTempTileMapToTileMap
	and a
	ret

.eagulou_park_battle
	ld hl, BattleText_BattleCantFightEagulou
	call StdBattleTextBox
	jr BattleMenu

BattleMenu_PackOrGuard:
	ld a, [wLinkMode]
	and a
	jr nz, .show_cant_use_items_error

	CheckEngine ENGINE_POKEMON_MODE
	jr nz, BattleMenu_Guard
	ld a, [wInBattleTowerBattle]
	and 5
	jr nz, .show_cant_use_items_error

	call LoadStandardMenuHeader

	callba BattlePack
	ld a, [wBattlePlayerAction]
	and a
	jr nz, .use_item

.didnt_use_item
	call ClearPalettes
	call DelayFrame
	callba LoadBattleFontsHPBar
	call GetMonBackpic
	call GetMonFrontpic
	call ExitMenu
	call ApplyTilemapInVBlank
	call FinishBattleAnim
	call LoadTileMapToTempTileMap
	jr .back_to_menu

.show_cant_use_items_error
	ld hl, BattleText_ItemsCantBeUsedHere
	call StdBattleTextBox
.back_to_menu
	jp BattleMenu

.use_item
	ld a, [wWildMon]
	and a
	jr nz, .run
	callba CheckItemPocket
	ld a, [wItemAttributeParamBuffer]
	cp BALL
	call nz, ClearBGPalettes
	xor a
	ldh [hBGMapMode], a
	callba LoadBattleFontsHPBar
	call ClearSprites
	ld a, [wBattleType]
	call GetMonBackpic
	call GetMonFrontpic
	ld a, 1
	ld [wMenuCursorY], a
	call ExitMenu
	call UpdateBattleHUDs
	call ApplyTilemapInVBlank
	call LoadTileMapToTempTileMap
	call ClearWindowData
	call FinishBattleAnim
	and a
	ret

.run
	xor a
	ld [wWildMon], a
	ld a, [wBattleResult]
	and $c0
	ld [wBattleResult], a
	call ClearWindowData
	call SetPalettes
	scf
	ret

BattleMenu_PKMN:
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr z, .not_final_chance
	ld hl, BattleText_NoSwitchFinalChance
	call StdBattleTextBox
	jp BattleMenu

.not_final_chance
	call LoadStandardMenuHeader
BattleMenuPKMN_ReturnFromStats:
	call ExitMenu
	call LoadStandardMenuHeader
	call ClearBGPalettes
BattleMenuPKMN_Loop:
	call SetUpBattlePartyMenu
	xor a
	ld [wPartyMenuActionText], a
	call JumpToPartyMenuAndPrintText
	callba PartyMenuSelect
	jr c, .leave
.loop
	callba FreezeMonIcons
	callba BattleMonMenu
	jr c, BattleMenuPKMN_Loop
	call PlaceHollowCursor
	ld a, [wMenuCursorY]
	dec a ; SWITCH
	jr z, TryPlayerSwitch
	dec a ; STATS
	jr z, .stats
	dec a ; CANCEL
	jr z, BattleMenuPKMN_Loop
	jr .loop

.leave
	call ClearSprites
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	call CloseWindow
	call LoadTileMapToTempTileMap
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	jp BattleMenu

.stats
	call Battle_StatsScreen
	jr BattleMenuPKMN_ReturnFromStats

Battle_StatsScreen:
	call DisableLCD
	ld hl, vBGTiles tile $31
	ld de, vObjTiles
	ld bc, $11 tiles
	rst CopyBytes
	ld hl, vBGTiles
	ld de, vObjTiles tile $11
	ld bc, $31 tiles
	rst CopyBytes
	call EnableLCD
	call ClearSprites
	call LowVolume
	xor a ; PARTYMON
	ld [wMonType], a
	callba BattleStatsScreenInit
	call MaxVolume
	call DisableLCD
	ld hl, vObjTiles
	ld de, vBGTiles tile $31
	ld bc, $11 tiles
	rst CopyBytes
	ld hl, vObjTiles tile $11
	ld de, vBGTiles
	ld bc, $31 tiles
	rst CopyBytes
	jp EnableLCD

TryPlayerSwitch:
	ld a, [wCurBattleMon]
	ld d, a
	ld a, [wCurPartyMon]
	cp d
	ld hl, BattleText_PkmnIsAlreadyOut
	jr z, .print_message_and_loop
	ld a, [wPlayerWrapCount]
	and a
	jr nz, .trapped
	call CheckEnemyAbilityPreventsEscaping
	jr c, .trapped
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .trapped
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr z, .try_switch
.trapped
	ld hl, BattleText_PkmnCantBeRecalled
.print_message_and_loop
	call StdBattleTextBox
.back_to_pkmn_menu_loop
	jp BattleMenuPKMN_Loop

.try_switch
	call CheckIfCurPartyMonIsStillAlive
	jr z, .back_to_pkmn_menu_loop
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, 2
	ld [wBattlePlayerAction], a
	call ClearPalettes
	call DelayFrame
	call ClearSprites
	call _LoadHPBar
	call CloseWindow
	ld b, SCGB_RAM
	predef GetSGBLayout
	call SetPalettes
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	jp PlayerSwitch

SetUpBattlePartyMenu_NoLoop:
	call ClearBGPalettes
SetUpBattlePartyMenu: ; switch to fullscreen menu?
	callba LoadPartyMenuGFX
	callba InitPartyMenuWithCancel
	callba InitPartyMenuBGPal7
	jpba InitPartyMenuGFX

JumpToPartyMenuAndPrintText:
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call ApplyTilemapInVBlank
	call SetPalettes
	jp DelayFrame

PickPartyMonInBattle:
.loop
	ld a, 2 ; Which PKMN?
	ld [wPartyMenuActionText], a
	call JumpToPartyMenuAndPrintText
	callba PartyMenuSelect
	ret c
	call CheckIfCurPartyMonIsStillAlive
	jr z, .loop
	xor a
	ret

SwitchMonAlreadyOut:
	ld hl, wCurBattleMon
	ld a, [wCurPartyMon]
	cp [hl]
	jr nz, .notout

	ld hl, BattleText_PkmnIsAlreadyOut
	call StdBattleTextBox
	scf
	ret

.notout
	xor a
	ret

ForcePickPartyMonInBattle:
; Can't back out.

.pick
	call PickPartyMonInBattle
	ret nc

	ld de, SFX_WRONG
	call PlayWaitSFX
	jr .pick

PickSwitchMonInBattle:
.pick
	call PickPartyMonInBattle
	ret c
	call SwitchMonAlreadyOut
	jr c, .pick
	xor a
	ret

ForcePickSwitchMonInBattle:
; Can't back out.

.pick
	call ForcePickPartyMonInBattle
	call SwitchMonAlreadyOut
	jr c, .pick

	xor a
	ret
