StartMenu::
	call ClearWindowData

	ld de, SFX_MENU
	call PlaySFX

	callba AnchorBGMap

	ld hl, .MenuHeader
	call LoadMenuHeader
	call .SetUpMenuItems
	ld a, [wd0d2]
	ld [wMenuCursorBuffer], a
	call .DrawCurrentTime
	call DrawVariableLengthMenuBox
	call SafeUpdateSprites
	call BGMapAnchorTopLeft
	callba LoadFont
	call UpdateTimePals
	jr .Select

.Reopen
	call UpdateSprites
	call UpdateTimePals
	call .SetUpMenuItems
	ld a, [wd0d2]
	ld [wMenuCursorBuffer], a

.Select
	call .GetInput
	jr c, .Exit
	call .DrawCurrentTime
	ld a, [wMenuCursorBuffer]
	ld [wd0d2], a
	call PlayClickSFX
	call PlaceHollowCursor
	call .OpenMenu

; Menu items have different return functions.
; For example, saving exits the menu.
	jumptable
.MenuReturns
	dw .Reopen
	dw .Exit
	dw .ExitMenuCallFuncCloseText
	dw .ExitMenuRunScriptCloseText
	dw .ExitMenuRunScript
	dw .ReturnEnd
	dw .ReturnRedraw

.Exit
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	call LoadFontsExtra
	pop af
	ldh [hOAMUpdate], a
.ReturnEnd
	call ExitMenu
.ReturnEnd2
	call CloseText
	jp UpdateTimePals

.GetInput
; Return carry on exit, and no-carry on selection.
	xor a
	ldh [hBGMapMode], a
	call .DrawCurrentTime
	call SetUpMenu
	ld a, $ff
	ld [wMenuSelection], a
.loop
	call .PrintCurrentTime
	call ReadMenuJoypad
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .b
	cp A_BUTTON
	jr nz, .loop
	call PlayClickSFX
	and a
	ret
.b
	scf
	ret

.ExitMenuRunScript
	call ExitMenu
	ld a, HMENURETURN_SCRIPT
	ldh [hMenuReturn], a
	ret

.ExitMenuRunScriptCloseText
	call ExitMenu
	ld a, HMENURETURN_SCRIPT
	ldh [hMenuReturn], a
	jr .ReturnEnd2

.ExitMenuCallFuncCloseText
	call ExitMenu
	ld hl, wQueuedScriptBank
	call FarPointerCall
	jr .ReturnEnd2

.ReturnRedraw
	call ClearBGPalettes
	call ExitMenu
	call ReloadTilesetAndPalettes
	call .DrawCurrentTime
	call DrawVariableLengthMenuBox
	call UpdateSprites
	call CloseSubmenu_AfterExitMenu
	jp .Reopen

.MenuHeader
	db $40 ; tile backup
	db 0, 10 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default selection

.MenuData
	db %10101000 ; x padding, wrap around, start can close
	dn 0, 0 ; rows, columns
	dw wMenuItemsList
	dw .MenuString
	dw .MenuData2

.MenuData2
	dw StartMenu_Pokedex,     .PokedexString
	dw StartMenu_Pokemon,     .PartyString
	dw StartMenu_Pack,        .PackString
	dw StartMenu_Map,         .MapString
	dw StartMenu_Status,      .StatusString
	dw StartMenu_Save,        .SaveString
	dw StartMenu_Option,      .OptionString
IF DEF(DEBUG_MODE)
	dw StartMenu_Debug,       .DebugString
ELSE
	dw StartMenu_Exit,        .ExitString
ENDC
	dw StartMenu_TreasureBag, .BagString

.PokedexString 	db "#dex@"
.PartyString   	db "#mon@"
.PackString    	db "Pack@"
.StatusString  	db "<PLAYER>@"
.SaveString    	db "Save@"
.OptionString  	db "Options@"
.ExitString    	db "Exit@"
.MapString	    db "Map@"
.DebugString    db "Debug@"
.BagString      db "Bag@"


.OpenMenu
	ld a, [wMenuSelection]
	call .GetMenuAccountTextPointer
	jp CallLocalPointer

.MenuString
	push de
	ld a, [wMenuSelection]
	call .GetMenuAccountTextPointer
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	jp PlaceString

.GetMenuAccountTextPointer
	ld e, a
	ld d, 0
	ld hl, wMenuDataPointerTableAddr
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ld l, e
	ld h, d
	add hl, hl ; x2
	add hl, hl ; x4
	add hl, bc
	ret

.SetUpMenuItems
	xor a
	ld [wWhichIndexSet], a
	call .FillMenuList

	ld a, [wStatusFlags]
	bit 0, a ; has pokedex?
	jr z, .no_pokedex
	bit 1, a ; pokemon only mode?
	jr nz, .no_pokedex
	xor a ; pokedex
	ld [hli], a
	inc c
.no_pokedex
	ld a, [wPartyCount]
	and a
	jr z, .no_pokemon
	ld a, START_MENU_PKMN
	ld [hli], a
	inc c
.no_pokemon
	ld a, [wLinkMode]
	and a
	jr nz, .no_pack
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .checkTreasureBag
	ld a, START_MENU_PACK
	ld [hli], a
	inc c
.no_pack
	ld a, [wTownMapFlags]
	bit 7, a ; has map?
	jr z, .no_map
	ld a, START_MENU_MAP
	ld [hli], a
	inc c
.no_map
	ld a, START_MENU_STATUS
	ld [hli], a
	inc c
	jr .checkSave
.checkTreasureBag
	CheckEngineForceReuseA ENGINE_USE_TREASURE_BAG
	jr z, .checkSave
	ld a, START_MENU_TREASURE_BAG
	ld [hli], a
	inc c
.checkSave
	ld a, [wLinkMode]
	and a
	jr nz, .no_save
	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .no_save
	ld a, START_MENU_SAVE
	ld [hli], a
	inc c
.no_save
	ld a, START_MENU_OPTION
	ld [hli], a
	ld [hl], START_MENU_EXIT
	ld a, c
	add 2
	ld [wMenuItemsList], a
	ret

.FillMenuList
	xor a
	ld hl, wMenuItemsList
	ld [hli], a
	ld a, -1
	ld bc, wMenuItemsListEnd - (wMenuItemsList + 1)
	call ByteFill
	ld hl, wMenuItemsList + 1
	ld c, 0
	ret

.PrintCurrentTime
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	call .DrawCurrentTime
	decoord 0, 14
	call UpdateTime
	call GetWeekday
	ld c, a
	decoord 0, 14
	callba PlaceWeekday
	ld b, 0
	hlcoord 4, 14
	callba MainMenu_PrintDate
	bccoord 1, 16
	ldh a, [hHours]
	ld d, a
	ldh a, [hMinutes]
	ld e, a
	callba PrintHoursMins
	ld h, b
	ld l, c
	ld a, [wOptions2]
	and 1 << 3
	jr nz, .no_seconds
	ld a, ":"
	ld [hli], a
	ldh a, [hSeconds]
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add a, "0"
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hl], a
.no_seconds

	ld hl, wStatusFlags2
	bit 2, [hl]
	call nz, .PrintRemainingParkTime

	pop af
	ldh [hBGMapMode], a
	ret

.DrawCurrentTime
	hlcoord 0, 13
	lb bc, 5, 10
	call ClearBox
	hlcoord 0, 13
	lb bc, 3, 8
	call TextBoxPalette
	ld hl, wStatusFlags2
	bit 2, [hl] ;park minigame
	ret z
	hlcoord 10, 16
	lb bc, 2, 10
	call ClearBox
	hlcoord 10, 16
	lb bc, 2, 10
	jp TextBoxPalette

.PrintRemainingParkTime
	callba CalculateRemainingParkMinigameTime
	decoord 11, 16
	ld bc, wParkMinigameRemainingTime
	callba PrintFormattedStopwatchValue
	ld hl, .RemainingString
	coord de, 10, 17
	ld bc, .RemainingStringEnd - .RemainingString
	rst CopyBytes
	ret
.RemainingString
	db "remaining"
.RemainingStringEnd

StartMenu_Exit:
	ld a, MENU_EXIT_ALL
	ret

StartMenu_Save:
	call BufferScreen
	callba SaveMenu
	sbc a
	assert MENU_EXIT_RETURN == 0
	assert MENU_EXIT_ALL == 1
	inc a ;a = 0 if carry, 1 if no carry
	ret

StartMenu_Option:
	call FadeToMenu
	callba OptionsMenu
	ld a, MENU_EXIT_RETURN_REDRAW
	ret

StartMenu_Status:
	call FadeToMenu
	callba TrainerCard
	jr StartMenu_CloseSubmenuAndGoBack

StartMenu_Pokedex:
	ld a, [wPartyCount]
	and a
	ret z
	call FadeToMenu
	callba Pokedex
StartMenu_CloseSubmenuAndGoBack:
	call CloseSubmenu
	assert MENU_EXIT_RETURN == 0
	xor a
	ret

StartMenu_Debug:
	call FadeToMenu
	callba DebugMenu
	push bc
	ld a, b
	and a
	jr z, .debug_close
	cp 6
	jr z, .debug_close
	call ExitAllMenus
	pop bc
	ld a, b
	ret
.debug_close
	call CloseSubmenu
	pop bc
	ld a, b
	ret

StartMenu_Map:
	ld a, [wMapGroup]
	cp GROUP_MYSTERY_ZONE
	jr z, .inMysteryZone
	call FadeToMenu
	callba _TownMap
	jr StartMenu_CloseSubmenuAndGoBack

.inMysteryZone
	ld hl, _MapMysteryZoneText
	call MenuTextBoxBackup
	assert MENU_EXIT_RETURN == 0
	xor a
	ret

StartMenu_Pack:
	call FadeToMenu
	callba Pack
	ld a, [wcf66]
	and a
	jr z, StartMenu_CloseSubmenuAndGoBack
	call ExitAllMenus
	ld a, MENU_EXIT_SCRIPT
	ret

StartMenu_TreasureBag:
	ld a, [wTreasureBag]
	inc a
	cp 2
	jr c, .NoItems
	call FadeToMenu
	callba TreasureBag
	ld a, MENU_EXIT_RETURN_REDRAW
	ret

.NoItems
	ld a, BANK(.NoItemsScript)
	ld hl, .NoItemsScript
	call CallScript
	ld a, MENU_EXIT_SCRIPT
	ret

.NoItemsScript:
	jumptext .NoItemsText

.NoItemsText:
	ctxt "The Treasure Bag"
	line "is empty."
	done

StartMenu_Pokemon:
	ld a, [wPartyCount]
	and a
	jp z, StartMenu_CloseSubmenuAndGoBack
	call FadeToMenu

.choosemenu
	xor a
	ld [wPartyMenuActionText], a ; Choose a POKéMON.
	call ClearBGPalettes

.menu
	callba LoadPartyMenuGFX
	callba InitPartyMenuWithCancel
	callba InitPartyMenuGFX

.menunoreload
	ld a, A_BUTTON | B_BUTTON | SELECT
	ld [wMenuJoypadFilter], a

	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call ApplyTilemapInVBlank
	call SetPalettes ; load regular palettes?
	call DelayFrame
	callba PartyMenuSelect
	jr c, .return ; if cancelled or pressed B

	ldh a, [hJoyLast]
	and SELECT
	jr z, .not_switch

	call SwitchPartyMons
	jr .after_action
.not_switch
	call PokemonActionSubmenu
.after_action
	and a
	jr z, .choosemenu
	dec a
	jr z, .menunoreload
	dec a
	jr z, .quit
	dec a
	jr z, .menu
.return
	jp StartMenu_CloseSubmenuAndGoBack

.quit
	ld a, b
	push af
	call ExitAllMenus
	pop af
	ret

HasNoItems:
	ld a, [wNumItems]
	and a
	ret nz
	ld a, [wNumKeyItems]
	and a
	ret nz
	ld a, [wNumBalls]
	and a
	ret nz
	ld hl, wTMsHMs
	ld b, NUM_TMS + NUM_HMS
.loop
	ld a, [hli]
	and a
	ret nz
	dec b
	jr nz, .loop
	scf
	ret

TossItemSubmenu:
	push de
	call PartyMonItemName
	callba _CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr nz, .cant_toss
	ld hl, .Text_TossOutHowManyNameS
	call MenuTextBox
	callba SelectQuantityToToss
	push af
	call CloseWindow
	call ExitMenu
	pop af
	jr c, .failed
	ld hl, .Text_ThrowAwayQuantityName
	call MenuTextBox
	call YesNoBox
	push af
	call ExitMenu
	pop af
	jr c, .failed
	pop hl
	ld a, [wCurItemQuantity]
	call TossItem
	call PartyMonItemName
	ld hl, .Text_DiscardedNameS
	call MenuTextBox
	call ExitMenu
	and a
	ret

.cant_toss
	call .Print_TooImportantToToss
.failed
	pop hl
	scf
	ret

.Text_TossOutHowManyNameS
	; Toss out how many @ (S)?
	text_jump Toss_AskHowMany

.Text_ThrowAwayQuantityName
	; Throw away @ @ (S)?
	text_jump Toss_Confirm

.Text_DiscardedNameS
	; Discarded @ (S).
	text_jump Text_Discarded

.Print_TooImportantToToss
	ld hl, .Text_TooImportantToToss
	jp MenuTextBoxBackup

.Text_TooImportantToToss
	; That's too impor- tant to toss out!
	text_jump Toss_TooImportant

CantUseItem:
	ld hl, CantUseItemText
	jp MenuTextBoxWaitButton

CantUseItemText:
	text_jump Text_IsntTheTime

PartyMonItemName:
	ld a, [wCurItem]
	ld [wd265], a
	call GetItemName
	jp CopyName1

CancelPokemonAction:
	callba InitPartyMenuWithCancel
	callba UnfreezeMonIcons
	ld a, 1
	ret

PokemonActionSubmenu:
	hlcoord 1, 15
	lb bc, 2, 18
	call ClearBox
	callba MonSubmenu
	call GetCurNick
	ld a, [wMenuSelection]
	ld hl, .Actions
	ld e, 3
	call IsInArray
	jp c, CallLocalPointer_AfterIsInArray
	xor a
	ret

.Actions
	dbw MONMENU_CUT,        MonMenu_Cut
	dbw MONMENU_FLY,        MonMenu_Fly
	dbw MONMENU_SURF,       MonMenu_Surf
	dbw MONMENU_STRENGTH,   MonMenu_Strength
	dbw MONMENU_FLASH,      MonMenu_Flash
	dbw MONMENU_DIG,        MonMenu_Dig
	dbw MONMENU_TELEPORT,   MonMenu_Teleport
	dbw MONMENU_SOFTBOILED, MonMenu_Softboiled_MilkDrink ; Softboiled
	dbw MONMENU_MILKDRINK,  MonMenu_Softboiled_MilkDrink ; MilkDrink
	dbw MONMENU_HEADBUTT,   MonMenu_Headbutt
	dbw MONMENU_ROCKSMASH,  MonMenu_RockSmash
	dbw MONMENU_SWEETSCENT, MonMenu_SweetScent
	dbw MONMENU_STATS,      OpenPartyStats
	dbw MONMENU_SWITCH,     SwitchPartyMons
	dbw MONMENU_ITEM,       GiveTakePartyMonItem
	dbw MONMENU_CANCEL,     CancelPokemonAction
	dbw MONMENU_MOVE,       ManagePokemonMoves ; move
	dbw MONMENU_PMODE_ITEM, SwapTossPartyMonItem
	db $ff

SwitchPartyMons:
	ld a, 4
	call SwitchPartyMonMenu
	jp c, CancelPokemonAction
.switchMons
	callba _SwitchPartyMons
	ld a, 3
	ret

SwitchPartyMonMenu:
	ld [wPartyMenuActionText], a
; Don't try if there's nothing to switch!
	ld a, [wPartyCount]
	cp 2
	jr c, .onlyOneMon

	ld a, [wCurPartyMon]
	inc a
	ld [wSwitchMon], a

	callba HoldSwitchmonIcon
	callba InitPartyMenuNoCancel
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText

	hlcoord 0, 1
	ld bc, SCREEN_WIDTH * 2
	ld a, [wSwitchMon]
	dec a
	ld [wSwitchMon], a
	rst AddNTimes
	ld [hl], "▷"
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame

	ld a, A_BUTTON | B_BUTTON | SELECT
	ld [wMenuJoypadFilter], a

	callba PartyMenuSelect

	ld a, 0
	ld [wPartyMenuActionText], a
	ret c ; if the player pressed b

	ld a, [wSwitchMon]
	ld b, a
	ld a, [wCurPartyMon]
	cp b
	jr z, .swappingSameMon
	and a
	ret
.onlyOneMon
	xor a
	ld [wPartyMenuActionText], a
.swappingSameMon
	scf
	ret

SwapTossPartyMonItem:
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, SwapTossPartyMonItem_cancel
	ld hl, SwapTossItemMenuData
	call LoadMenuHeader
	call VerticalMenu
	call ExitMenu
	jr c, SwapTossPartyMonItem_cancel
	call GetCurNick
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld a, [wMenuCursorY]
	dec a
	jr z, SwapPartyMonItems
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr nz, .isHoldingItem
	ld hl, IsntHoldingAnythingText
	call MenuTextBoxBackup
	jr SwapTossPartyMonItem_cancel
.isHoldingItem
	ld [wCurItem], a
	push hl
	call PartyMonItemName
	ld hl, .ConfirmThrowAwayItemText
	call MenuTextBox
	call YesNoBox
	push af
	call CloseWindow
	pop af
	pop hl
	jr c, SwapTossPartyMonItem_cancel
	ld [hl], 0
	ld hl, .ThrewAwaySingularItemText
	call MenuTextBoxBackup
	jr SwapTossPartyMonItem_cancel

.ConfirmThrowAwayItemText
	text_jump ConfirmThrowAwayItemText

.ThrewAwaySingularItemText
	text_jump ThrewAwaySingularItemText

SwapPartyMonItems:
	ld a, 9
	call SwitchPartyMonMenu
	jp c, CancelPokemonAction
	call GetPartyItemLocation
	ld d, h
	ld e, l ; de = dest

	ld hl, wPartyMon1 + MON_ITEM
	ld a, [wSwitchMon]
	call GetPartyLocation
	; hl = item source
	; de = item dest

	ld a, [de]
	ld b, a
	ld a, [hl]
	ld [de], a
	ld [hl], b

	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
SwapTossPartyMonItem_cancel:
	ld a, 3
	ret

GiveTakePartyMonItem:
; Eggs can't hold items!
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .cancel

	ld hl, GiveTakeItemMenuData
	call LoadMenuHeader
	call VerticalMenu
	call ExitMenu
	jr c, .cancel

	call GetCurNick
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld a, [wMenuCursorY]
	dec a
	jr z, .give
	dec a
	jp nz, SwapPartyMonItems
.take
	call TakePartyItem
.cancel
	ld a, 3
	ret

.give
	call LoadStandardMenuHeader
	call ClearPalettes
	call .GiveItem
	call ClearPalettes
	call LoadFontsBattleExtra
	call ExitMenu
	xor a
	ret

.GiveItem
	callba DepositSellInitPackBuffers
.loop
	callba DepositSellPack

	ld a, [wcf66]
	and a
	ret z

	ld a, [wcf65]
	cp 2
	jr z, .next

	call CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jp z, TryGiveItemToPartymon

.next
	ld hl, CantBeHeldText
	call MenuTextBoxBackup
	jr .loop

TryGiveItemToPartymon:
	call SpeechTextBox
	call PartyMonItemName
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr nz, .already_holding_item

.give_item_to_mon
	call GiveItemToPokemon
	ld hl, MadeHoldText
	call MenuTextBoxBackup
	jp GivePartyItem

.already_holding_item
	ld [wd265], a
	call GetItemName
	ld hl, SwitchAlreadyHoldingText
	call StartMenuYesNo
	ret c

	call GiveItemToPokemon
	ld a, [wd265]
	push af
	ld a, [wCurItem]
	ld [wd265], a
	pop af
	ld [wCurItem], a
	call ReceiveItemFromPokemon
	jr nc, .bag_full

	ld hl, TookAndMadeHoldText
	call MenuTextBoxBackup
	ld a, [wd265]
	ld [wCurItem], a
	jp GivePartyItem

.bag_full
	ld a, [wd265]
	ld [wCurItem], a
	call ReceiveItemFromPokemon
	ld hl, ItemStorageIsFullText
	jp MenuTextBoxBackup

GivePartyItem:
	call GetPartyItemLocation
	ld a, [wCurItem]
	ld [hl], a
	ld d, a
	ret

TakePartyItem:
	call SpeechTextBox
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr z, .not_holding_anything

	ld [wCurItem], a
	call ReceiveItemFromPokemon
	jr nc, .full_bag

	call GetPartyItemLocation
	ld a, [hl]
	ld [wd265], a
	ld [hl], NO_ITEM
	call GetItemName
	ld hl, TookFromText
	jp MenuTextBoxBackup

.not_holding_anything
	ld hl, IsntHoldingAnythingText
	jp MenuTextBoxBackup

.full_bag
	ld hl, ItemStorageIsFullText
	jp MenuTextBoxBackup

GiveTakeItemMenuData:
	db %01010000
	db 10, 12 ; start coords
	db 17, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db %10000000 ; x padding
	db 3 ; # items
	db "Give@"
	db "Take@"
	db "Swap@"

SwapTossItemMenuData:
	db %01010000
	db 12, 12 ; start coords
	db 17, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db %10000000 ; x padding
	db 2 ; # items
	db "Swap@"
	db "Toss@"

_MapMysteryZoneText:
	text_jump MapMysteryZoneText

TookAndMadeHoldText:
	text_jump HoldItem_SwapText

MadeHoldText:
	text_jump HoldItem_MadeHold

IsntHoldingAnythingText:
	text_jump MonIsntHoldingAnythingText

ItemStorageIsFullText:
	text_jump ItemStorageFullText

TookFromText:
	text_jump HoldItem_TookText

SwitchAlreadyHoldingText:
	text_jump HoldItem_AskSwitch

CantBeHeldText:
	text_jump HoldItem_CantBeHeldText

GetPartyItemLocation:
	push af
	ld a, MON_ITEM
	call GetPartyParamLocation
	pop af
	ret

ReceiveItemFromPokemon:
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	jp ReceiveItem

GiveItemToPokemon:
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	jp TossItem

StartMenuYesNo:
	call MenuTextBox
	call YesNoBox
	jp ExitMenu

OpenPartyStats:
	call LoadStandardMenuHeader
	call ClearSprites
; PartyMon
	xor a
	ld [wMonType], a
	call LowVolume
	predef StatsScreenInit
	call MaxVolume
	call ExitMenu
	xor a
	ret

MonMenu_Cut:
	callba CutFunction
	ld a, [wFieldMoveSucceeded]
	cp 1
	jr FinalizeFieldMoveZero

MonMenu_Fly:
	callba FlyFunction
	ld a, [wFieldMoveSucceeded]
	cp 2
	jr z, .Fail
	and a
	ret z
	ld b, MENU_EXIT_SCRIPT
	ld a, 2
	ret
.Fail
	ld a, 3
	ret

MonMenu_Flash:
	callba OWFlash
	ld a, [wFieldMoveSucceeded]
	dec a
	jr FinalizeFieldMoveZero

MonMenu_Strength:
	callba StrengthFunction
	ld a, [wFieldMoveSucceeded]
	dec a
	; fallthrough

FinalizeFieldMoveZero:
	jr nz, FailedFieldMove
	; fallthrough
SucceededFieldMove:
	ld b, MENU_EXIT_SCRIPT
	ld a, 2
	ret

MonMenu_Teleport:
	callba TeleportFunction
	ld a, [wFieldMoveSucceeded]
	and a
	; fallthrough

FinalizeFieldMoveNonZero:
	jr nz, SucceededFieldMove
	; fallthrough
FailedFieldMove:
	ld a, 3
	ret

MonMenu_Surf:
	callba SurfFunction
	ld a, [wFieldMoveSucceeded]
	and a
	jr FinalizeFieldMoveNonZero

MonMenu_Dig:
	callba DigFunction
	ld a, [wFieldMoveSucceeded]
	dec a
	jr FinalizeFieldMoveZero

MonMenu_Softboiled_MilkDrink:
	call .CheckMonHasEnoughHP
	jr nc, .NotEnoughHP
	callba Softboiled_MilkDrinkFunction
	jr .finish

.NotEnoughHP
	ld hl, .Text_NotEnoughHP
	call PrintText

.finish
	xor a
	ld [wPartyMenuActionText], a
	ld a, 3
	ret

.Text_NotEnoughHP
	; Not enough HP!
	text_jump Text_NotEnoughHP

.CheckMonHasEnoughHP
; Need to have at least (MaxHP / 5) HP left.
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld a, 5
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ld a, MON_HP + 1
	call GetPartyParamLocation
	ldh a, [hQuotient + 2]
	sub [hl]
	dec hl
	ldh a, [hQuotient + 1]
	sbc [hl]
	ret

MonMenu_Headbutt:
	callba HeadbuttFunction
	ld a, [wFieldMoveSucceeded]
	dec a
	jr FinalizeFieldMoveZero

MonMenu_RockSmash:
	callba RockSmashFunction
	ld a, [wFieldMoveSucceeded]
	dec a
	jr FinalizeFieldMoveZero

MonMenu_SweetScent:
	callba SweetScentFromMenu
	jr SucceededFieldMove

ChooseMoveToDelete:
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call LoadFontsBattleExtra
	call .show_moves
	pop bc
	ld a, b
	ld [wOptions], a
	push af
	call ClearBGPalettes
	pop af
	ret

.show_moves
	call SetUpMoveScreenBG
	ld de, DeleteMoveScreenAttrs
	call SetMenuAttributes
	call SetUpMoveList
	ld hl, w2DMenuFlags1
	set 6, [hl]

.place_move_data
	call PrepareToPlaceMoveData
	call PlaceMoveData

	call DoMenuJoypadLoop
	bit B_BUTTON_F, a
	jr nz, .cancel
	bit A_BUTTON_F, a
	jr z, .place_move_data

	and a
	jr .finish

.cancel
	scf

.finish
	push af
	xor a
	ld [wSwitchMon], a
	ld hl, w2DMenuFlags1
	res 6, [hl]
	call ClearSprites
	call ClearTileMap
	pop af
	ret

DeleteMoveScreenAttrs:
	db 3, 1
	db 3, 1
	db $40, $00
	dn 2, 0
	db D_UP | D_DOWN | A_BUTTON | B_BUTTON

ManagePokemonMoves:
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call MoveScreenLoop
	pop af
	ld [wOptions], a
	call ClearBGPalettes
.egg
	xor a
	ret

MoveScreenLoop:
	ld a, [wCurPartyMon]
	inc a
	ld [wPartyMenuCursor], a
	call SetUpMoveScreenBG
	call Function132d3
	ld de, MoveScreenAttributes
	call SetMenuAttributes
.loop
	call SetUpMoveList
	ld hl, w2DMenuFlags1
	set 6, [hl]
	jr .skip_joy

.joy_loop
	call DoMenuJoypadLoop
	bit 1, a
	jr nz, .b_button
	bit 0, a
	jp nz, .a_button
	bit 4, a
	jr nz, .d_right
	bit 5, a
	jr nz, .d_left

.skip_joy
	call PrepareToPlaceMoveData
	ld a, [wMoveSwapBuffer]
	and a
	jr nz, .moving_move
	call PlaceMoveData
	jr .joy_loop

.moving_move
	ld a, " "
	hlcoord 1, 11
	ld bc, 7
	call ByteFill
	hlcoord 1, 12
	lb bc, 5, SCREEN_WIDTH - 2
	call ClearBox
	hlcoord 1, 12
	ld de, .string_where
	call PlaceText
	jr .joy_loop
.b_button
	call PlayClickSFX
	ld a, [wMoveSwapBuffer]
	and a
	jp z, .exit

	ld a, [wMoveSwapBuffer]
	ld [wMenuCursorY], a
	xor a
	ld [wMoveSwapBuffer], a
	hlcoord 1, 2
	lb bc, 8, SCREEN_WIDTH - 2
	call ClearBox
	jr .loop

.d_right
	ld a, [wMoveSwapBuffer]
	and a
	jr nz, .joy_loop

	ld a, [wCurPartyMon]
	ld b, a
	push bc
	call .cycle_right
.done_right_left
	pop bc
	ld a, [wCurPartyMon]
	cp b
	jr z, .joy_loop
	jp MoveScreenLoop

.d_left
	ld a, [wMoveSwapBuffer]
	and a
	jp nz, .joy_loop
	ld a, [wCurPartyMon]
	ld b, a
	push bc
	call .cycle_left
	jr .done_right_left

.cycle_right
	ld a, [wCurPartyMon]
	inc a
	ld [wCurPartyMon], a
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	cp -1
	jr z, .cycle_left
	cp EGG
	ret nz
	jr .cycle_right

.cycle_left
	ld a, [wCurPartyMon]
	and a
	ret z
.cycle_left_loop
	ld a, [wCurPartyMon]
	dec a
	ld [wCurPartyMon], a
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	cp EGG
	ret nz
	ld a, [wCurPartyMon]
	and a
	jr z, .cycle_right
	jr .cycle_left_loop

.a_button
	call PlayClickSFX
	ld a, [wMoveSwapBuffer]
	and a
	jr nz, .place_move
	ld a, [wMenuCursorY]
	ld [wMoveSwapBuffer], a
	call PlaceHollowCursor
	jp .moving_move

.place_move
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	push hl
	call .copy_move
	pop hl
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	call .copy_move
	ld a, [wBattleMode]
	jr z, .swap_moves
	ld hl, wBattleMonMoves
	ld bc, wBattleMonStructEnd - wBattleMon
	ld a, [wCurPartyMon]
	rst AddNTimes
	push hl
	call .copy_move
	pop hl
	ld bc, wBattleMonPP - wBattleMonMoves
	add hl, bc
	call .copy_move

.swap_moves
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
	hlcoord 1, 2
	lb bc, 8, 18
	call ClearBox
	hlcoord 10, 10
	lb bc, 1, 9
	call ClearBox
	jp .loop

.copy_move
	push hl
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wMoveSwapBuffer]
	dec a
	ld c, a ;b is still 0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret

.exit
	xor a
	ld [wMoveSwapBuffer], a
	ld hl, w2DMenuFlags1
	res 6, [hl]
	call ClearSprites
	jp ClearTileMap

.string_where
	text "Where?"
	done

MoveScreenAttributes:
	db 3, 1
	db 3, 1
	db $40, $00
	dn 2, 0
	db D_UP | D_DOWN | D_LEFT | D_RIGHT | A_BUTTON | B_BUTTON

SetUpMoveScreenBG:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	xor a
	ldh [hBGMapMode], a
	callba LoadStatsScreenPageTilesGFX
	callba ClearSpriteAnims2
	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	ld [wd265], a
	ld e, 2
	callba LoadPokemonIconMoveMenu
	hlcoord 0, 1
	lb bc, 9, 18
	call TextBox
	hlcoord 0, 11
	lb bc, 5, 18
	call TextBox
	hlcoord 2, 0
	lb bc, 2, 3
	call ClearBox
	xor a
	ld [wMonType], a
	ld hl, wPartyMonNicknames
	ld a, [wCurPartyMon]
	call GetNick
	hlcoord 5, 1
	call PlaceString
	push bc
	callba CopyPkmnToTempMon
	pop hl
	call PrintLevel
	ld hl, wPlayerHPPal
	call SetHPPal
	ld b, SCGB_MOVE_LIST
	predef GetSGBLayout
	hlcoord 16, 0
	lb bc, 1, 3
	jp ClearBox

SetUpMoveList:
	xor a
	ldh [hBGMapMode], a
	ld [wMoveSwapBuffer], a
	ld [wMonType], a
	predef CopyPkmnToTempMon
	ld hl, wTempMonMoves
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	rst CopyBytes
	ld a, SCREEN_WIDTH * 2
	ld [wListMoves_Spacing], a
	hlcoord 2, 3
	predef ListMoves
	hlcoord 10, 4
	predef ListMovePP
	call ApplyTilemapInVBlank
	call SetPalettes
	ld a, [wNumMoves]
	inc a
	ld [w2DMenuNumRows], a
	hlcoord 0, 11
	lb bc, 5, 18
	jp TextBox

PrepareToPlaceMoveData:
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurMove], a
	hlcoord 1, 12
	lb bc, 5, 18
	jp ClearBox

PlaceMoveData:
	xor a
	ldh [hBGMapMode], a
	hlcoord 0, 10
	ld de, .move_data_box_top
	call PlaceString
	hlcoord 0, 11
	ld de, .move_data_type_string
	call PlaceString
	hlcoord 12, 12
	ld de, .move_data_pow_string
	call PlaceString
	hlcoord 12, 13
	ld de, .move_data_acc_string
	call PlaceString
	ld a, [wCurMove]
	ld b, a
	hlcoord 2, 12
	predef PrintMoveType
	ld a, [wCurMove]
	dec a
	ld hl, Moves + MOVE_POWER
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByteAndIncrement
	push hl
	hlcoord 16, 12
	cp 2
	jr c, .no_power
	call .Print3DigitNumber
	jr .accuracy

.no_power
	ld de, .move_data_no_number_string
	call PlaceString

.accuracy
	pop hl
	inc hl ; accuracy
	ld a, BANK(Moves)
	call GetFarByte
	hlcoord 16, 13
	cp 2
	jr c, .no_accuracy
	call .Print3DigitNumber
	jr .desc

.no_accuracy
	ld de, .move_data_no_number_string
	call PlaceString

.desc
	hlcoord 1, 14
	callba PrintMoveDesc
	ld a, 1
	ldh [hBGMapMode], a
	ret



.Print3DigitNumber
	ld [wd265], a
	ld de, wd265
	lb bc, 1, 3
	jp PrintNum

.move_data_box_top
	db "┌───────┐@"

.move_data_type_string
	db "│Type/  └@"

.move_data_pow_string
	db "Pow/@"

.move_data_no_number_string
	db "---@"

.move_data_acc_string
	db "Acc/@"

Function132d3:
	call Function132da
	ld a, [wCurPartyMon]
	inc a
	ld c, a
	ld a, [wPartyCount]
	cp c
	ret z
	ld e, c
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
.loop
	ld a, [hl]
	cp -1
	ret z
	and a
	jr z, .next
	cp EGG
	jr z, .next
	cp NUM_POKEMON + 1
	jr c, .legal

.next
	inc hl
	jr .loop

.legal
	hlcoord 18, 0
	ld [hl], "▶"
	ret

Function132da:
	ld a, [wCurPartyMon]
	and a
	ret z
	ld c, a
	ld e, a
	ld d, 0
	ld hl, wPartyCount
	add hl, de
.loop
	ld a, [hl]
	and a
	jr z, .prev
	cp EGG
	jr z, .prev
	cp NUM_POKEMON + 1
	jr c, .legal

.prev
	dec hl
	dec c
	jr nz, .loop
	ret

.legal
	hlcoord 16, 0
	ld [hl], "◀"
	ret
