Pack:
	ld hl, wOptions
	set NO_TEXT_SCROLL, [hl]
	call InitPackBuffers
.loop
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .done
	call .RunJumptable
	call DelayFrame
	jr .loop

.done
	ld a, [wCurrPocket]
	ld [wLastPocket], a
	ld hl, wOptions
	res NO_TEXT_SCROLL, [hl]
	ret

.RunJumptable:
	ld a, [wJumptableIndex]
	jumptable

.Jumptable:
	dw .InitGFX            ;  0
	dw .InitItemsPocket    ;  1
	dw .ItemsPocketMenu    ;  2
	dw .InitBallsPocket    ;  3
	dw .BallsPocketMenu    ;  4
	dw .InitKeyItemsPocket ;  5
	dw .KeyItemsPocketMenu ;  6
	dw .InitTMHMPocket     ;  7
	dw .TMHMPocketMenu     ;  8
	dw Pack_QuitNoScript   ;  9
	dw Pack_QuitRunScript

.InitGFX:
	xor a
	ldh [hBGMapMode], a
	call Pack_InitGFX
	ld a, [wcf64]
	ld [wJumptableIndex], a
	jp Pack_InitColors

.InitItemsPocket:
	xor a
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	call WaitBGMap_DrawPackGFX
	jp Pack_JumptableNext

.ItemsPocketMenu:
	ld hl, ItemsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wItemsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wItemsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wItemsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wItemsPocketCursor], a
	lb bc, 7, 3
	call Pack_InterpretJoypad
	ret c
	jp .ItemBallsKey_LoadSubmenu

.InitKeyItemsPocket:
	ld a, 2
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	call WaitBGMap_DrawPackGFX
	jp Pack_JumptableNext

.KeyItemsPocketMenu:
	ld hl, KeyItemsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wKeyItemsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wKeyItemsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wKeyItemsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wKeyItemsPocketCursor], a
	lb bc, 3, 7
	call Pack_InterpretJoypad
	ret c
	jp .ItemBallsKey_LoadSubmenu

.InitTMHMPocket:
	ld a, 3
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	xor a
	ldh [hBGMapMode], a
	call WaitBGMap_DrawPackGFX
	jp Pack_JumptableNext

.TMHMPocketMenu:
	callba TMHMPocket
	lb bc, 5, 1
	call Pack_InterpretJoypad
	ret c

	ld a, [wCurItem]
	inc a
	ret z

	ld hl, .MenuHeader1
	call LoadMenuHeader
	call VerticalMenu
	call ExitMenu
	ret c
	ld a, [wMenuCursorY]
	dec a
	jumptable
.Jumptable1:
	dw .UseItem
	dw GenericDummyFunction

.MenuHeader1:
	db $40 ; flags
	db 07, 13 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2_1
	db 1 ; default option

.MenuData2_1:
	db $c0 ; flags
	db 2 ; items
	db "Use@"
	db "Quit@"

.UseItem:
	callba AskTeachTMHM
	ret c
	callba ChooseMonToLearnTMHM
	jr c, .declined
	ld hl, wOptions
	ld a, [hl]
	push af
	res NO_TEXT_SCROLL, [hl]
	callba TeachTMHM
	pop af
	ld [wOptions], a
.declined
	xor a
	ldh [hBGMapMode], a
	call Pack_InitGFX
	call WaitBGMap_DrawPackGFX
	jp Pack_InitColors

.InitBallsPocket:
	ld a, $1
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	call WaitBGMap_DrawPackGFX
	jp Pack_JumptableNext

.BallsPocketMenu:
	ld hl, BallsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wBallsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wBallsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wBallsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wBallsPocketCursor], a
	lb bc, 1, 5
	call Pack_InterpretJoypad
	ret c

.ItemBallsKey_LoadSubmenu:
	ld hl, wd002
	ld [hl], 1
	ld de, wd003
	call IsValidItemMenuType
	jr nc, .no_use
	ld a, [wItemAttributeParamBuffer]
	and a
	jr z, .no_use
	xor a ; use
	ld [de], a
	inc de
	inc [hl]
.no_use

	push hl
	callba _CheckTossableItem
	pop hl
	ld a, [wItemAttributeParamBuffer]
	and a
	jr nz, .no_toss
	inc a ; give
	ld [de], a
	inc de
	inc [hl]
	inc a ; toss
	ld [de], a
	inc de
	inc [hl]
.no_toss

	push hl
	callba CheckSelectableItem
	pop hl
	ld a, [wItemAttributeParamBuffer]
	and a
	ld a, 3 ; sel
	jr nz, .no_select
	ld [de], a
	inc de
	inc [hl]
.no_select
	inc a ; quit
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	xor a
	ld [wWhichIndexSet], a
	ld hl, ItemSubmenuDataHeader
	call LoadMenuHeader
	ld a, [wd002]
	add a
	ld b, a
	ld a, [wMenuBorderBottomCoord]
	sub b
	ld [wMenuBorderTopCoord], a
	call ItemsMenuJoypad
	call ExitMenu
	ret c
	ld a, [wMenuCursorY]
	add LOW(wd002)
	ld l, a
	adc HIGH(wd002)
	sub l
	ld h, a
	ld a, [hl]
	jumptable

ItemSubmenuJumptable:
	dw UseItem
	dw GiveItem
	dw TossMenu
	dw RegisterItem
	dw GenericDummyFunction

ItemSubmenuDataHeader:
	db $40
	db 00, 13
	db 11, 19
	dw .MenuData2
	db 1

.MenuData2
	db $80
	db 0
	dw wd002
	dw PlaceMenuStrings
	dw .Strings

.Strings
	db "Use@"
	db "Give@"
	db "Toss@"
	db "Sel@"
	db "Quit@"

ItemsMenuJoypad:
	call SetUpMenu
.loop
	call ReadMenuJoypad
	ld a, [wMenuJoypad]
	and A_BUTTON | B_BUTTON
	jr z, .loop
	call PlayClickSFX
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .b_button
	and a
	ret

.b_button
	scf
	ret

UseItem:
	callba CheckItemMenu
	ld a, [wItemAttributeParamBuffer]
	jumptable

.dw:
	dw .Oak
	dw .Oak
	dw .Overworld
	dw .Reload
	dw DoItemEffect
	dw .Party
	dw .Close

.Oak:
	ld hl, Text_ThisIsntTheTime
	jp Pack_PrintTextNoScroll

.Overworld:
	call ClearBGPalettes
	call ClearScreen
	call ReloadTilesetAndPalettes
	ld b, SCGB_MAPPALS
	predef GetSGBLayout
	callba LoadOW_BGPal7
	call ApplyAttrAndTilemapInVBlank
	callba AnchorBGMap
	call EnableSpriteUpdates
	call UpdateSprites
	call DoItemEffect
	call DisableSpriteUpdates
	jr .redrawPack

.Reload:
	call DoItemEffect
	jr .redrawPack

.Party:
	ld a, [wPartyCount]
	and a
	jr z, .NoPokemon
	call DoItemEffect
.redrawPack
	xor a
	ldh [hBGMapMode], a
	call Pack_InitGFX
	call WaitBGMap_DrawPackGFX
	jp Pack_InitColors

.Close:
	call DoItemEffect
	ld a, [wItemEffectSucceeded]
	and a
	jr z, .Oak
	cp 3 ; don't close menu
	ret z
	cp 4 ; redraw pack
	jr z, .redrawPack
	ld a, 10
	ld [wJumptableIndex], a
	ret

.NoPokemon
	ld hl, TextJump_YouDontHaveAPkmn
	jp Pack_PrintTextNoScroll

TossMenu:
	ld hl, Text_ThrowAwayHowMany
	call Pack_PrintTextNoScroll
	callba SelectQuantityToToss
	push af
	call ExitMenu
	pop af
	ret c
	call Pack_GetItemName
	ld hl, Text_ConfirmThrowAway
	call MenuTextBox
	call YesNoBox
	push af
	call ExitMenu
	pop af
	ret c
	ld hl, wNumItems
	ld a, [wCurItemQuantity]
	call TossItem
	call Pack_GetItemName
	ld hl, Text_ThrewAway
	jp Pack_PrintTextNoScroll

RegisterItem:
	callba CheckSelectableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr nz, .cant_register
	ld a, [wCurrPocket]
	rrca
	rrca
	and $c0
	ld b, a
	ld a, [wCurItemQuantity]
	inc a
	and $3f
	or b
	ld [wWhichRegisteredItem], a
	ld a, [wCurItem]
	ld [wRegisteredItem], a
	call Pack_GetItemName
	ld de, SFX_FULL_HEAL
	call WaitPlaySFX
	ld hl, Text_RegisteredItem
	jp Pack_PrintTextNoScroll

.cant_register
	ld hl, Text_CantRegister
	jp Pack_PrintTextNoScroll

GiveItem:
	ld a, [wPartyCount]
	and a
	jp z, .NoPokemon
	ld a, [wOptions]
	push af
	res NO_TEXT_SCROLL, a
	ld [wOptions], a
	ld a, 8
	ld [wPartyMenuActionText], a
	call ClearBGPalettes
	callba LoadPartyMenuGFX
	callba InitPartyMenuWithCancel
	callba InitPartyMenuGFX
.loop
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame
	callba PartyMenuSelect
	jr c, .finish
	ld a, [wCurPartySpecies]
	cp EGG
	jr nz, .give
	ld hl, .Egg
	call PrintText
	jr .loop

.give
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	call GetCurNick
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	call TryGiveItemToPartymon
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
.finish
	pop af
	ld [wOptions], a
	xor a
	ldh [hBGMapMode], a
	call Pack_InitGFX
	call WaitBGMap_DrawPackGFX
	jp Pack_InitColors

.NoPokemon:
	ld hl, TextJump_YouDontHaveAPkmn
	jp Pack_PrintTextNoScroll

.Egg:
	; An EGG can't hold an item.
	text_jump Text_AnEGGCantHoldAnItem

BattlePack:
	ld hl, wOptions
	set NO_TEXT_SCROLL, [hl]
	call InitPackBuffers
.loop
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .end
	jumptable .Jumptable
	call DelayFrame
	jr .loop

.end
	ld a, [wCurrPocket]
	ld [wLastPocket], a
	ld hl, wOptions
	res NO_TEXT_SCROLL, [hl]
	ret

.Jumptable:
	dw .InitGFX            ;  0
	dw .InitItemsPocket    ;  1
	dw .ItemsPocketMenu    ;  2
	dw .InitBallsPocket    ;  3
	dw .BallsPocketMenu    ;  4
	dw .InitKeyItemsPocket ;  5
	dw .KeyItemsPocketMenu ;  6
	dw .InitTMHMPocket     ;  7
	dw .TMHMPocketMenu     ;  8
	dw Pack_QuitNoScript   ;  9
	dw Pack_QuitRunScript

.InitGFX:
	xor a
	ldh [hBGMapMode], a
	call Pack_InitGFX
	ld a, [wcf64]
	ld [wJumptableIndex], a
	jp Pack_InitColors

.InitItemsPocket:
	xor a
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	call WaitBGMap_DrawPackGFX
	jp Pack_JumptableNext

.ItemsPocketMenu:
	ld hl, ItemsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wItemsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wItemsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wItemsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wItemsPocketCursor], a
	lb bc, 7, 3
	call Pack_InterpretJoypad
	ret c
	jp ItemSubmenu

.InitKeyItemsPocket:
	ld a, 2
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	call WaitBGMap_DrawPackGFX
	jp Pack_JumptableNext

.KeyItemsPocketMenu:
	ld hl, KeyItemsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wKeyItemsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wKeyItemsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wKeyItemsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wKeyItemsPocketCursor], a
	lb bc, 3, 7
	call Pack_InterpretJoypad
	ret c
	jp ItemSubmenu

.InitTMHMPocket:
	ld a, 3
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	xor a
	ldh [hBGMapMode], a
	call WaitBGMap_DrawPackGFX
	ld hl, GenericDummyText
	call Pack_PrintTextNoScroll
	jp Pack_JumptableNext

.TMHMPocketMenu:
	callba TMHMPocket
	lb bc, 5, 1
	call Pack_InterpretJoypad
	ret c
	xor a
	jp TMHMSubmenu

.InitBallsPocket:
	ld a, 1
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	call WaitBGMap_DrawPackGFX
	jp Pack_JumptableNext

.BallsPocketMenu:
	ld hl, BallsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wBallsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wBallsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wBallsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wBallsPocketCursor], a
	lb bc, 1, 5
	call Pack_InterpretJoypad
	ret c

	call CheckIfInEagulouParkBattle
	ld d, 0
	jr nz, .notInEagulou
	inc d
.notInEagulou
	ld a, [wCurItem]
	cp EAGULOU_BALL
	ld a, 0
	jr nz, .notEagulouBall
	inc a
.notEagulouBall
	xor d
	jr nz, BattlePack_Unusable

ItemSubmenu:
	callba CheckItemContext
	ld a, [wItemAttributeParamBuffer]
TMHMSubmenu:
	and a
	jr z, BattlePack_Unusable
	ld hl, BattlePack_UsableMenuHeader
	ld de, BattlePack_UsableJumptable
	jr BattlePack_SubmenuProceed

BattlePack_Unusable:
	ld hl, BattlePack_UnusableMenuHeader
	ld de, BattlePack_UnusableJumptable
BattlePack_SubmenuProceed:
	push de
	call LoadMenuHeader
	call VerticalMenu
	call ExitMenu
	pop hl
	ret c
	ld a, [wMenuCursorY]
	dec a
	jp OldJumpTable

BattlePack_UsableMenuHeader:
	db $40 ; flags
	db 07, 13 ; start coords
	db 11, 19 ; end coords
	dw .UsableMenuData2
	db 1 ; default option

.UsableMenuData2:
	db $c0 ; flags
	db 2 ; items
	db "Use@"
	db "Quit@"

BattlePack_UsableJumptable:
	dw BattlePack_Use
	dw GenericDummyFunction

BattlePack_UnusableMenuHeader:
	db $40 ; flags
	db 09, 13 ; start coords
	db 11, 19 ; end coords
	dw .UnusableMenuData2
	db 1 ; default option

.UnusableMenuData2:
	db $c0 ; flags
	db 1 ; items
	db "Quit@"

BattlePack_UnusableJumptable:
	dw GenericDummyFunction

BattlePack_Use:
	callba CheckItemContext
	ld a, [wItemAttributeParamBuffer]
	jumptable

.ItemFunctionJumptable:
	dw .Oak
	dw .Oak
	dw .Oak
	dw .Oak
	dw .Unused
	dw .BattleField
	dw .BattleOnly

.Oak:
	ld hl, Text_ThisIsntTheTime
	jp Pack_PrintTextNoScroll

.BattleField:
	call DoItemEffect
	ld a, [wItemEffectSucceeded]
	and a
	jr nz, .quit_run_script
	xor a
	ldh [hBGMapMode], a
	call Pack_InitGFX
	call WaitBGMap_DrawPackGFX
	jp Pack_InitColors

.Unused:
	call DoItemEffect
	ld a, [wItemEffectSucceeded]
	and a
	ret z
.ReturnToBattle:
	call ClearBGPalettes
	jr .quit_run_script

.BattleOnly:
	call DoItemEffect
	ld a, [wItemEffectSucceeded]
	and a
	jr z, .Oak
	cp 2
	jr z, .didnt_use_item
.quit_run_script:
	ld a, 10
	ld [wJumptableIndex], a
	jp ZeroDamage

.didnt_use_item:
	xor a
	ld [wItemEffectSucceeded], a
	ret

InitPackBuffers:
	xor a
	ld [wJumptableIndex], a
	ld a, [wLastPocket]
	and 3
	ld [wCurrPocket], a
	inc a
	add a
	dec a
	ld [wcf64], a
	xor a
	ld [wcf66], a
	xor a
	ld [wSwitchItem], a
	ret

DepositSellInitPackBuffers:
	xor a
	ldh [hBGMapMode], a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wCurrPocket], a
	ld [wcf66], a
	ld [wSwitchItem], a
	call Pack_InitGFX
	jp Pack_InitColors

DepositSellPack:
.loop
	call .RunJumptable
	call DepositSellTutorial_InterpretJoypad
	jr c, .loop
	ret

.RunJumptable:
	call RunAnonymousJumptable

.Jumptable:
	dw .ItemsPocket
	dw .BallsPocket
	dw .KeyItemsPocket

.ItemsPocket:
	xor a
	call InitPocket
	ld hl, PC_Mart_ItemsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wItemsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wItemsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wItemsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wItemsPocketCursor], a
	ret

.KeyItemsPocket:
	ld a, 2
	call InitPocket
	ld hl, PC_Mart_KeyItemsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wKeyItemsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wKeyItemsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wKeyItemsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wKeyItemsPocketCursor], a
	ret

.BallsPocket:
	ld a, 1
	call InitPocket
	ld hl, PC_Mart_BallsPocketMenuHeader
	call CopyMenuHeader
	ld a, [wBallsPocketCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wBallsPocketScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wBallsPocketScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wBallsPocketCursor], a
	ret

InitPocket:
	ld [wCurrPocket], a
	call ClearPocketList
	call DrawPocketName
	jp WaitBGMap_DrawPackGFX

DepositSellTutorial_InterpretJoypad:
	ld hl, wMenuJoypad
	ld a, [hl]
	and A_BUTTON | B_BUTTON
	jr nz, .aOrBbutton
	ld a, [hl]
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	scf
	ret

.aOrBbutton
	and 1
	ld [wcf66], a
	ret nz
	ld a, [wCurrPocket]
	dec a ; balls pocket
	jp z, ClearSprites
	ret

.d_left
	ld a, [wJumptableIndex]
	dec a
	cp -1
	jr nz, .noWrapAround
	ld a, 2
.noWrapAround
	ld [wJumptableIndex], a
	push de
	ld de, SFX_SWITCH_POCKETS
	call PlaySFX
	pop de
	jp ClearSpritesIfBallsPocket

.d_right
	ld a, [wJumptableIndex]
	inc a
	cp 3
	jr c, .noWrapAround2
	xor a
.noWrapAround2
	ld [wJumptableIndex], a
	push de
	ld de, SFX_SWITCH_POCKETS
	call PlaySFX
	pop de
	jp ClearSpritesIfBallsPocket

Pack_JumptableNext:
	ld hl, wJumptableIndex
	inc [hl]
	ret

Pack_QuitNoScript:
	ld hl, wJumptableIndex
	set 7, [hl]
	xor a
	ld [wcf66], a
	ret

Pack_QuitRunScript:
	ld hl, wJumptableIndex
	set 7, [hl]
	ld a, TRUE
	ld [wcf66], a
	ret

Pack_PrintTextNoScroll:
	ld a, [wOptions]
	push af
	set NO_TEXT_SCROLL, a
	ld [wOptions], a
	call PrintText
	pop af
	ld [wOptions], a
	ret

WaitBGMap_DrawPackGFX:
	call ApplyTilemapInVBlank
DrawPackGFX:
	ld a, [wCurrPocket]
	and 3
	ld e, a
	ld d, 0
	ld hl, .Offsets
	add hl, de
	ld d, [hl]
	ld bc, 15 tiles
	ld hl, PackGFX
	ld e, BANK(PackGFX)
	ld a, [wPlayerGender]
	bit 0, a
	jr z, .male_dude
	ld hl, PackFGFX
	ld e, BANK(PackFGFX)
.male_dude
	ld a, d
	rst AddNTimes
	ld b, e
	ld c, 15
	ld d, h
	ld e, l
	ld hl, vBGTiles tile $50
	jp Request2bpp

.Offsets:
	db 1, 3, 0, 2

Pack_InterpretJoypad:
	ld hl, wMenuJoypad
	ld a, [wSwitchItem]
	and a
	jr nz, .switching_item
	ld a, [hl]
	and A_BUTTON
	ret nz
	ld a, [hl]
	and B_BUTTON
	jr nz, .b_button
	ld a, [hl]
	and D_LEFT
	jr nz, .d_left
	ld a, [hl]
	and D_RIGHT
	jr nz, .d_right
	ld a, [hl]
	and SELECT
	jr nz, .select
	scf
	ret

.b_button
	ld a, 9
	ld [wJumptableIndex], a
	jr ClearSpritesIfBallsPocket

.d_left
	ld a, b
	ld [wJumptableIndex], a
	ld [wcf64], a
	push de
	ld de, SFX_SWITCH_POCKETS
	call PlaySFX
	pop de
	jr ClearSpritesIfBallsPocket

.d_right
	ld a, c
	ld [wJumptableIndex], a
	ld [wcf64], a
	push de
	ld de, SFX_SWITCH_POCKETS
	call PlaySFX
	pop de
	jr ClearSpritesIfBallsPocket

.select
	callba SwitchItemsInBag
	ld hl, Text_MoveItemWhere
	call Pack_PrintTextNoScroll
	scf
	ret

.switching_item
	ld a, [hl]
	and A_BUTTON | SELECT
	jr nz, .place_insert
	ld a, [hl]
	and B_BUTTON
	jr nz, .end_switch
	scf
	ret

.place_insert
	callba SwitchItemsInBag
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
.end_switch
	xor a
	ld [wSwitchItem], a
	scf
	ret

ClearSpritesIfBallsPocket:
	ld a, [wCurrPocket]
	dec a
	scf
	ret nz
	call ClearSprites
	scf
	ret

Pack_InitGFX:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	ld hl, PackMenuGFX
	ld de, vBGTiles
	ld bc, $60 tiles
	ld a, BANK(PackMenuGFX)
	call FarCopyBytes
; Background (blue if male, pink if female)
	hlcoord 0, 1
	ld bc, 11 * SCREEN_WIDTH
	ld a, $24
	call ByteFill
; This is where the items themselves will be listed.
	hlcoord 5, 1
	lb bc, 11, 15
	call ClearBox
; ◀▶ POCKET       ▼▲ ITEMS
	hlcoord 0, 0
	ld a, $28
	ld c, SCREEN_WIDTH
.loop
	ld [hli], a
	inc a
	dec c
	jr nz, .loop
	call DrawPocketName
	call PlacePackGFX
; Place the textbox for displaying the item description
	hlcoord 0, SCREEN_HEIGHT - 4 - 2
	lb bc, 4, SCREEN_WIDTH - 2
	call TextBox
	call EnableLCD
	jp DrawPackGFX

PlacePackGFX:
	hlcoord 0, 3
	ld a, $50
	ld de, SCREEN_WIDTH - 5
	ld b, 3
.row
	ld c, 5
.column
	ld [hli], a
	inc a
	dec c
	jr nz, .column
	add hl, de
	dec b
	jr nz, .row
	ret

DrawPocketName:
	hlcoord 0, 7
	ld de, .top_border
	call .draw_row

	ld a, [wCurrPocket]
	; * 5
	ld d, a
	add a
	add a
	add d

	add LOW(.tilemap)
	ld e, a
	adc HIGH(.tilemap)
	sub e
	ld d, a
	call .draw_row

	ld de, .bottom_border
	; fallthrough
.draw_row
	ld b, 5
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop
	ld c, SCREEN_WIDTH - 5 ; b is already 0
	add hl, bc
	ret

.top_border
	db $00, $04, $04, $04, $01 ; top border
.bottom_border
	db $02, $05, $05, $05, $03 ; bottom border
.tilemap
	db $06, $07, $08, $09, $0a ; Items
	db $15, $16, $17, $18, $19 ; Balls
	db $0b, $0c, $0d, $0e, $0f ; Key Items
	db $10, $11, $12, $13, $14 ; TM/HM

Pack_GetItemName:
	ld a, [wCurItem]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	jp CopyName1

ClearPocketList:
	hlcoord 5, 2
	lb bc, 10, SCREEN_WIDTH - 5
	jp ClearBox

Pack_InitColors:
	call ApplyTilemapInVBlank
	ld b, SCGB_PACKPALS
	predef GetSGBLayout
	call SetPalettes
	jp DelayFrame

ItemsPocketMenuHeader:
	db $40 ; flags
	db 01, 07 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $ae ; flags
	db 5, 8 ; rows, columns
	db 2 ; horizontal spacing
	dbw 0, wNumItems
	dba PlaceMenuItemName
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

PC_Mart_ItemsPocketMenuHeader:
	db $40 ; flags
	db 01, 07 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $2e ; flags
	db 5, 8 ; rows, columns
	db 2 ; horizontal spacing
	dbw 0, wNumItems
	dba PlaceMenuItemName
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

KeyItemsPocketMenuHeader:
	db $40 ; flags
	db 01, 07 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $ae ; flags
	db 5, 8 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wNumKeyItems
	dba PlaceMenuItemName
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

PC_Mart_KeyItemsPocketMenuHeader:
	db $40 ; flags
	db 01, 07 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $2e ; flags
	db 5, 8 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wNumKeyItems
	dba PlaceMenuItemName
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

BallsPocketMenuHeader:
	db $40 ; flags
	db 01, 07 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $af ; flags
	db 5, 8 ; rows, columns
	db 2 ; horizontal spacing
	dbw 0, wNumBalls
	dba PlaceBallItemNameAndIcon
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

PC_Mart_BallsPocketMenuHeader:
	db $40 ; flags
	db 01, 07 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $2f ; flags
	db 5, 8 ; rows, columns
	db 2 ; horizontal spacing
	dbw 0, wNumBalls
	dba PlaceBallItemNameAndIcon
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

Text_PackNoItems:
	; No items.
	text_jump Pack_NoItems

Text_ThrowAwayHowMany:
	; Throw away how many?
	text_jump Pack_AskTossQty

Text_ConfirmThrowAway:
	; Throw away @ @ (S)?
	text_jump Pack_ConfirmToss

Text_ThrewAway:
	; Threw away @ (S).
	text_jump Pack_Tossed

Text_ThisIsntTheTime:
	; OAK:  ! This isn't the time to use that!
	text_jump Text_IsntTheTime

TextJump_YouDontHaveAPkmn:
	; You don't have a #mon!
	text_jump Text_YouDontHaveAPkmn

Text_RegisteredItem:
	; Registered the @ .
	text_jump Pack_RegisteredItem

Text_CantRegister:
	; You can't register that item.
	text_jump Pack_CantRegister

Text_MoveItemWhere:
	; Where should this be moved to?
	text_jump Pack_MoveWhere

TextJump_YouCantUseItInABattle:
	; Doesn't seem to be used anywhere
	; "You can't use it in a battle."
	text_jump Text_YouCantUseItInABattle

PackMenuGFX: INCBIN "gfx/pack/pack_menu.2bpp"
PackGFX: INCBIN "gfx/pack/pack.2bpp"

LoadBallPocketOAM:
	ld a, [wMenuScrollPosition]
	ld b, a
	ld a, [wScrollingMenuCursorPosition]
	sub b
	ld b, a
	ld c, a
	sla b
	swap a
	ld l, a
	ld h, HIGH(wSprites)
	add $18 + 2
	ld e, a
	ld d, $30

	push de
	call .LoadCol
	pop de
	ld d, $38
	set OAM_X_FLIP, c
.LoadCol:
	call .LoadTile
	ld a, e
	add 8
	ld e, a
	inc b
	call .LoadTile
	dec b
	ret

.LoadTile:
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ret
