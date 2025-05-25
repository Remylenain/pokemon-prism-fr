DebugMainMenu: debug_menu " DEBUG MAIN MENU", 0, .options, DebugMenuCancel
.options debug_menu_options .get_pokemon, .manage_items, .manage_money, .warp, .edit_flags, .memory_access, .misc, .pics, .cancel
.get_pokemon debug_option "Get #mon", .load_get_pokemon_menu
.manage_items debug_option "Manage Items", .load_manage_items_menu
.manage_money debug_option "Manage Money", .load_money_menu
.warp debug_option "Warp Anywhere", .load_warp_menu
.edit_flags debug_option "Edit flags", .load_edit_flags_menu
.memory_access debug_option "Memory Access", .load_memory_access_menu
.misc debug_option "Miscellaneous", .load_misc_menu
.pics debug_option "Pics", .load_pics_menu
.cancel debug_option "Cancel", DebugMenuCancel
.load_get_pokemon_menu
	ld bc, DebugGetPokemonMainMenu
	jr .load
.load_manage_items_menu
	ld bc, DebugManageItemsMenu
	jr .load
.load_warp_menu
	ld bc, DebugWarpMenu
	jr .load
.load_money_menu
	ld bc, DebugMoneyMenu
	jr .load
.load_edit_flags_menu
	ld bc, DebugFlagsMenu
	jr .load
.load_memory_access_menu
	ld bc, DebugMemoryAccessMenu
	jr .load
.load_misc_menu
	ld bc, DebugMiscellaneousMenu
	jr .load
.load_pics_menu
	ld bc, DebugPicTestMenu
.load
	jp DebugMenuLoad

DebugGetPokemonMainMenu: debug_menu " Get #mon", DebugMainMenu, .options, DebugMenuCancel
.options debug_menu_options .give_pokemon, .give_egg, .back, .cancel
.give_pokemon debug_option "Get #mon", .load_get_pokemon_menu
.give_egg debug_option "Get egg", .load_get_egg_menu
.back debug_option "Go back", DebugMenuCancel
.cancel debug_option "Cancel", DebugCloseAllMenus
.load_get_pokemon_menu
	ld bc, DebugGetPokemonMenu
	jr .load
.load_get_egg_menu
	ld bc, DebugGetEggMenu
.load
	jp DebugMenuLoad

DebugManageItemsMenu: debug_menu " Manage Items", DebugMainMenu, .options, DebugMenuCancel
.options debug_menu_options .give_item, .manage_tm_hm, .back, .cancel
.give_item debug_option "Get item", .load_get_item_menu
.manage_tm_hm debug_option "Manage TMs/HMs", .load_tm_hm_menu
.back debug_option "Go back", DebugMenuCancel
.cancel debug_option "Cancel", DebugCloseAllMenus
.load_get_item_menu
	ld bc, DebugGetItemMenu
	jr .load
.load_tm_hm_menu
	xor a
	ld [wDebugMenuParameter], a
	ld bc, DebugTMHMMenu
.load
	jp DebugMenuLoad

DebugFlagsMenu: debug_menu " Edit flags", DebugMainMenu, .options, DebugMenuCancel
.options debug_menu_options .edit_engine_flags, .edit_event_flags, .back, .cancel
.edit_engine_flags debug_option "Edit engine flags", .load_engine_flag_menu
.edit_event_flags debug_option "Edit event flags", .load_event_flag_menu
.back debug_option "Go back", DebugMenuCancel
.cancel debug_option "Cancel", DebugCloseAllMenus
.load_engine_flag_menu
	ld bc, DebugEngineFlagMenu
	jr .load
.load_event_flag_menu
	ld bc, DebugEventFlagMenu
.load
	xor a
	ld [wDebugMenuParameter], a
	jp DebugMenuLoad

DebugMemoryAccessMenu: debug_menu " Memory Access", DebugMainMenu, .options, DebugMenuCancel
.options debug_menu_options .edit_wram, .execute_function, .back, .cancel
.edit_wram debug_option "Edit WRAM memory", .load_edit_memory_menu
.execute_function debug_option "Execute function", .load_execute_function_menu
.back debug_option "Go back", DebugMenuCancel
.cancel debug_option "Cancel", DebugCloseAllMenus
.load_edit_memory_menu
	ld bc, DebugEditMemoryMenu
	jr .load
.load_execute_function_menu
	ld bc, DebugExecuteFunctionMenu
.load
	jp DebugMenuLoad

DebugPicTestMenu: debug_menu " Pic Test", DebugMainMenu, .options, DebugMenuCancel
.options debug_menu_options .trainer, .pokemon, .exit
.trainer debug_option "Trainer", .load_trainer
.pokemon debug_option "#mon", .load_pokemon
.exit debug_option "Go back", DebugMenuCancel
.load_trainer
	ld bc, DebugTrainerPicTestMenu
	jr .load
.load_pokemon
	ld bc, DebugPokemonPicTestMenu
.load
	jp DebugMenuLoad

DebugTrainerPicTestMenu: debug_menu " Trainer Pic Test", DebugPicTestMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .class, .back
.class debug_option "", 0, .change_class, .change_step
.back debug_option "Go back", DebugMenuCancel, 0, .change_step

.change_class
	ld de, wDebugMenuScratchSpace + 1
	ld hl, wDebugMenuScratchSpace
	lb bc, 1, NUM_TRAINER_CLASSES - 2
	call DebugMenuChangeValueLimited
	jr .update_pic

.change_step
	ld hl, wDebugMenuScratchSpace + 1
	call DebugMenuChangeStep
	jr .update_pic

.initialize
	ld a, 1
	ld [wDebugMenuScratchSpace], a
	ld [wDebugMenuScratchSpace + 1], a
	ldh [rSVBK], a
.update_pic
	xor a
	ldh [hBGMapMode], a
	ld de, wDebugMenuScratchSpace
	hlcoord 2, 4
	call DebugPrintTrainerClassName
	ld a, [wDebugMenuScratchSpace]
	ld [wTrainerClass], a
	ld e, 0
	callba ApplyMonOrTrainerPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ld de, vBGTiles
	predef GetTrainerPic
	xor a
	ldh [hGraphicStartTile], a
	hlcoord 7, 9
	lb bc, 7, 7
	predef PlaceGraphic
	ld a, 1
	ldh [hBGMapMode], a
	ld hl, wDebugMenuFlags
	set 5, [hl]
	jp ApplyTilemapInVBlank

DebugPokemonPicTestMenu: debug_menu " #mon Pic Test", DebugPicTestMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .class, .back
.class debug_option "", 0, .change_class, .change_step
.back debug_option "Go back", DebugMenuCancel, 0, .change_step

.change_class
	ld de, wDebugMenuScratchSpace + 1
	ld hl, wDebugMenuScratchSpace
	lb bc, 1, NUM_POKEMON
	call DebugMenuChangeValueLimited
	scf
	jr .update_pic

.change_step
	ld hl, wDebugMenuScratchSpace + 1
	call DebugMenuChangeStep
	and a
	jr .update_pic

.initialize
	ld a, BULBASAUR
	ld [wDebugMenuScratchSpace], a
	ld [wDebugMenuScratchSpace + 1], a
	ldh [rSVBK], a
	hlcoord 1, 15
	ld de, .help_info
	call PlaceText
	scf
.update_pic
	push af
	xor a
	ldh [hBGMapMode], a
	ld de, wDebugMenuScratchSpace
	hlcoord 2, 4
	call DebugPrintPokemonName
	hlcoord 2, 7
	lb bc, 7, 15
	call ClearBox
	hlcoord 16, 15
	ld a, [wDebugMenuScratchSpace + 1]
	ld e, a
	ld bc, 0
	ld d, b
	predef PrintBigNumber
	xor a
	ldh [hRunPicAnim], a
	ld hl, wcf64
	res 6, [hl]
	ld a, [wDebugMenuScratchSpace]
	ld [wCurPartySpecies], a
	ld e, 1
	callba ApplyMonOrTrainerPals
	ld a, 1
	ldh [hCGBPalUpdate], a
	ld hl, wDebugMenuFlags
	set 5, [hl]
	xor a
	ld [wBoxAlignment], a
	ld de, vBGTiles + (7 * 7) tiles
	predef GetBackpic
	hlcoord 2, 8
	ld a, [wDebugMenuScratchSpace]
	cp EGG
	lb bc, 6, 6
	jr nz, .okay
	lb bc, 5, 5
.okay
	ld a, 7 * 7
	ldh [hGraphicStartTile], a
	predef PlaceGraphic

	ld de, vBGTiles
	predef GetAnimatedFrontpic
	hlcoord 10, 7
	pop af
	jr nc, .egg
	ld a, [wDebugMenuScratchSpace]
	cp EGG
	jr z, .egg
	lb de, 0, ANIM_MON_MENU
	predef LoadMonAnimation
	ld hl, wcf64
	set 6, [hl]
	ld a, 1
	ldh [hRunPicAnim], a
.anim_loop
	callba StatsScreen_WaitAnim
	ld a, [wcf64]
	bit 6, a
	jr nz, .anim_loop
	jr .done

.egg
	lb bc, 7, 7
	xor a
	ldh [hGraphicStartTile], a
	predef PlaceGraphic
.done
	ld a, 1
	ldh [hBGMapMode], a
	ret

.help_info
	ctxt "L/R: change by"
	nl   "SEL: change step"
	done

DebugMiscellaneousMenu: debug_menu " Miscellaneous", DebugMainMenu, .options, DebugMenuCancel
.options debug_menu_options .mult_div_test, .sound_test, .stopwatch_test, .experience_groups_test, .credits_roll_option, .back, .cancel
.mult_div_test debug_option "Mult/div test", .load_mult_div_test_menu
.sound_test debug_option "Sound test", .load_sound_test_menu
.stopwatch_test debug_option "Stopwatch test", .load_stopwatch_test_menu
.experience_groups_test debug_option "Exp Groups", .load_exp_grp_menu
.credits_roll_option debug_option "Credits roll", .credits_roll
.back debug_option "Go back", DebugMenuCancel
.cancel debug_option "Cancel", DebugCloseAllMenus
.load_mult_div_test_menu
	ld bc, DebugMultDivTestMenu
	jr .load
.load_sound_test_menu
	ld bc, DebugSoundTestMenu
	jr .load
.load_stopwatch_test_menu
	ld bc, DebugStopwatchTestMenu
	jr .load
.load_exp_grp_menu
	ld bc, DebugExpGrpMenu
.load
	jp DebugMenuLoad
.credits_roll
	debug_exit_jp MENU_EXIT_SCRIPT, .credits_roll_script
.credits_roll_script
	callasm Credits
	reloadmap
	end

DebugGetPokemonMenu: debug_menu " Get Any #mon", DebugGetPokemonMainMenu, .options, .get_pokemon, .initialize
.options: debug_menu_options .species, .level, .helditem, .receive, .back
.species: debug_option "", 0, .change_species, .change_step
.level: debug_option "Level:", 0, .change_level, .change_step
.helditem: debug_option "", 0, .change_held_item, .change_step
.receive: debug_option "Get #mon!", .get_pokemon, 0, .change_step
.back: debug_option "Back", DebugMenuCancel, 0, .change_step
.initialize
	ld a, 1
	ld [wDebugMenuScratchSpace], a
	ld [wDebugMenuScratchSpace + 1], a
	ld [wDebugMenuScratchSpace + 2], a
	ldh [rSVBK], a
	xor a
	ld [wDebugMenuScratchSpace + 3], a
	ld de, DebugMenuInfoString
	hlcoord 2, 14
	call PlaceText
.show_status
	xor a
	ldh [hBGMapMode], a
	ld b, a
	ld c, a
	ld d, a
	ld a, [wDebugMenuScratchSpace + 2]
	ld e, a
	hlcoord 17, 14
	ld a, 2
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	ld bc, 0
	ld d, b
	ld a, [wDebugMenuScratchSpace + 1]
	ld e, a
	ld a, 3
	ldh [hDigitsFlags], a
	hlcoord 9, 5
	predef PrintBigNumber
	hlcoord 2, 4
	ld de, wDebugMenuScratchSpace
	call DebugPrintPokemonName
	hlcoord 2, 6
	ld de, wDebugMenuScratchSpace + 3
	call DebugPrintItemName
	ld a, 1
	ldh [hBGMapMode], a
	ret
.change_species
	ld de, wDebugMenuScratchSpace + 2
	ld hl, wDebugMenuScratchSpace
.change_value
	call DebugMenuChangeValue
	jr .show_status
.change_step
	ld hl, wDebugMenuScratchSpace + 2
	call DebugMenuChangeStep
	jr .show_status
.change_level
	ld de, wDebugMenuScratchSpace + 2
	ld hl, wDebugMenuScratchSpace + 1
	lb bc, 1, 100
	call DebugMenuChangeValueLimited
	jr .show_status
.change_held_item
	ld de, wDebugMenuScratchSpace + 2
	ld hl, wDebugMenuScratchSpace + 3
	jr .change_value
.get_pokemon
	ld a, [wDebugMenuScratchSpace]
	call IsAPokemon
	jr c, .invalid_pokemon
	cp EGG
	jr z, .invalid_pokemon
	ld b, a
	ld a, [wDebugMenuScratchSpace + 1]
	ld c, a
	ld a, [wDebugMenuScratchSpace + 3]
	ld d, a
	inc a
	jr z, .invalid_pokemon
	push bc
	push de
	ld hl, .get_pokemon_script
	ld de, wDebugMenuScratchSpace
	ld bc, .end_copied_script - .get_pokemon_script
	rst CopyBytes
	pop de
	pop bc
	ld hl, wDebugMenuScratchSpace + 1
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], d
	debug_exit MENU_EXIT_SCRIPT, wDebugMenuScratchSpace, BANK(.get_pokemon_script)
	ld de, SFX_TRANSACTION
	jr .play_sound
.invalid_pokemon
	ld de, SFX_WRONG
.play_sound
	jp PlayWaitSFX
.get_pokemon_script
	givepoke 0, 0, 0, 0
	sif >, 1
		jumptext .no_room_text
	closetextend
.end_copied_script
	assert (.end_copied_script - .get_pokemon_script) <= 24
.no_room_text
	ctxt "You don't have"
	line "enough room in"
	para "your party or box"
	line "to receive another"
	cont "#mon."
	done

DebugGetItemMenu: debug_menu " Get Any Item(s)", DebugManageItemsMenu, .options, .get_item, .initialize
.options debug_menu_options .item, .quantity, .receive, .back
.item debug_option "", 0, .change_item, .change_step
.quantity debug_option "Quantity:", 0, .change_quantity, .change_step
.receive debug_option "Get item(s)!", .get_item, 0, .change_step
.back debug_option "Back", DebugMenuCancel, 0, .change_step
.initialize
	ld a, 1
	ld [wDebugMenuScratchSpace], a
	ld [wDebugMenuScratchSpace + 1], a
	ld [wDebugMenuScratchSpace + 2], a
	ldh [rSVBK], a
	ld de, DebugMenuInfoString
	hlcoord 2, 14
	call PlaceText
.show_status
	xor a
	ldh [hBGMapMode], a
	ld b, a
	ld c, a
	ld d, a
	ld a, [wDebugMenuScratchSpace + 2]
	ld e, a
	hlcoord 17, 14
	ld a, 2
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	hlcoord 2, 4
	ld de, wDebugMenuScratchSpace
	call DebugPrintItemName
	ld bc, 0
	ld d, b
	ld a, [wDebugMenuScratchSpace + 1]
	ld e, a
	hlcoord 12, 5
	predef PrintBigNumber
	ld a, 1
	ldh [hBGMapMode], a
	ret
.change_step
	ld hl, wDebugMenuScratchSpace + 2
	call DebugMenuChangeStep
	jr .show_status
.change_item
	ld de, wDebugMenuScratchSpace + 2
	ld hl, wDebugMenuScratchSpace
	call DebugMenuChangeValue
	jr .show_status
.change_quantity
	ld hl, wDebugMenuScratchSpace + 1
	ld de, wDebugMenuScratchSpace + 2
	lb bc, 1, 99
	call DebugMenuChangeValueLimited
	jr .show_status
.get_item
	ld a, [wDebugMenuScratchSpace]
	call IsValidID
	jr c, .invalid_item
	ld hl, .give_item_script
	ld de, wDebugMenuScratchSpace + 2
	ld bc, .end_give_item_script - .give_item_script
	rst CopyBytes
	ld a, [wDebugMenuScratchSpace]
	ld [wDebugMenuScratchSpace + 3], a
	ld a, [wDebugMenuScratchSpace + 1]
	ld [wDebugMenuScratchSpace + 4], a
	debug_exit_jp MENU_EXIT_SCRIPT, wDebugMenuScratchSpace + 2, BANK(.give_item_script) ;so we can jump to something in this ROM bank
.invalid_item
	ld de, SFX_WRONG
	jp PlayWaitSFX
.give_item_script
	verbosegiveitem 0, 0
	endtext
.end_give_item_script
	assert (.end_give_item_script - .give_item_script) <= 22

DebugWarpMenu: debug_menu " Warp Anywhere", DebugMainMenu, .options, .warp, .initialize
.options debug_menu_options .map_group, .map, .coordinates, .warp_option, .back
.map_group debug_option "Map group:", 0, .change_value, .change_step
.map debug_option "Map number:", 0, .change_value, .change_step
.coordinates debug_option "Pos:", .change_current_coordinate, .change_coordinate_value, .change_step
.warp_option debug_option "Warp!", .warp, 0, .change_step
.back debug_option "Go back", DebugMenuCancel, 0, .change_step
.initialize
	ld de, DebugMenuInfoString
	hlcoord 2, 14
	call PlaceText
	ld de, .extra_coord_info_string
	hlcoord 2, 13
	call PlaceText
	wbk BANK(wMapGroup)
	ld hl, wDebugMenuScratchSpace
	ld a, [wMapGroup]
	ld [hli], a
	ld a, [wMapNumber]
	ld [hli], a
	ld a, [wXCoord]
	ld [hli], a
	ld a, [wYCoord]
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], 1
.show_values
	xor a
	ldh [hBGMapMode], a
	ld b, a
	ld c, a
	ld d, a
	ld a, [wDebugMenuScratchSpace]
	ld e, a
	ld a, 3
	hlcoord 15, 4
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	ld a, [wDebugMenuScratchSpace + 1]
	ld e, a
	ld bc, 0
	ld d, b
	hlcoord 15, 5
	predef PrintBigNumber
	ld a, [wDebugMenuScratchSpace + 2]
	ld e, a
	ld bc, 0
	ld d, b
	hlcoord 8, 6
	ld a, "("
	ld [hli], a
	ld a, [wDebugMenuScratchSpace + 4]
	xor 1
	call .load_arrow_if_selected
	ld [hli], a
	ld a, 3
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	ld a, [wDebugMenuScratchSpace + 3]
	ld e, a
	ld bc, 0
	ld d, b
	hlcoord 13, 6
	ld a, ","
	ld [hli], a
	ld a, [wDebugMenuScratchSpace + 4]
	call .load_arrow_if_selected
	ld [hli], a
	predef PrintBigNumber
	hlcoord 18, 6
	ld [hl], ")"
	ld a, [wDebugMenuScratchSpace + 5]
	ld e, a
	ld bc, 0
	ld d, b
	hlcoord 17, 14
	ld a, 2
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	ld a, 1
	ldh [hBGMapMode], a
	ret
.change_value
	push af
	ld hl, wDebugMenuScratchSpace
	ld a, [wDebugMenuCurrentOption]
	bit 0, a
	jr z, .change_value_for_variable
	inc hl
	jr .change_value_for_variable
.change_coordinate_value
	push af
	ld hl, wDebugMenuScratchSpace + 2
	ld a, [wDebugMenuScratchSpace + 4]
	bit 0, a
	jr z, .change_value_for_variable
	inc hl
.change_value_for_variable
	; called with af pushed
	pop af
	ld d, h
	ld e, l
	ld a, [de]
	ld hl, wDebugMenuScratchSpace + 5
	jr nc, .lower_value_for_variable
	add a, [hl]
	jr nc, .updated_value_for_variable
	ld a, $ff
	jr .updated_value_for_variable
.lower_value_for_variable
	sub [hl]
	jr nc, .updated_value_for_variable
	xor a
.updated_value_for_variable
	ld [de], a
	jr .show_values_after_update
.change_step
	ld hl, wDebugMenuScratchSpace + 5
	call DebugMenuChangeStep
	jr .show_values_after_update
.change_current_coordinate
	ld a, [wDebugMenuScratchSpace + 4]
	xor 1
	ld [wDebugMenuScratchSpace + 4], a
.show_values_after_update
	jp .show_values
.warp
	ld hl, wDebugMenuScratchSpace
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	push de
	push bc
	ld hl, .warp_script
	ld de, wDebugMenuScratchSpace
	ld bc, .end_warp_script - .warp_script
	rst CopyBytes
	ld hl, wDebugMenuScratchSpace + 1
	rept 2
		pop bc
		ld a, b
		ld [hli], a
		ld a, c
		ld [hli], a
	endr
	debug_exit_jp MENU_EXIT_SCRIPT, wDebugMenuScratchSpace, BANK(.warp_script)
.extra_coord_info_string
	ctxt "A: select coord"
	done
.load_arrow_if_selected
	bit 0, a
	jr z, .not_selected
	ld a, DEBUG_CURSOR_RIGHT
	ret
.not_selected
	ld a, " "
	ret
.warp_script
	warp N_A, 0, 0
	end
.end_warp_script
	assert (.end_warp_script - .warp_script) <= 24

DebugGetEggMenu: debug_menu " Get #mon Eggs", DebugGetPokemonMainMenu, .options, .receive_egg, .initialize
.options debug_menu_options .species, .level, .receive, .back
.species debug_option "", 0, .change_species, .change_step
.level debug_option "Level:", 0, .change_level, .change_step
.receive debug_option "Receive egg!", .receive_egg, 0, .change_step
.back debug_option "Go back", DebugMenuCancel, 0, .change_step
.initialize
	ld de, DebugMenuInfoString
	hlcoord 2, 14
	call PlaceText
	ld a, 1
	ldh [rSVBK], a
	ld hl, wDebugMenuScratchSpace
	ld [hli], a
	ld [hli], a
	ld [hli], a
.show_status
	xor a
	ldh [hBGMapMode], a
	ld b, a
	ld c, a
	ld d, a
	ld a, [wDebugMenuScratchSpace + 2]
	ld e, a
	hlcoord 17, 14
	ld a, 2
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	ld bc, 0
	ld d, b
	ld a, [wDebugMenuScratchSpace + 1]
	ld e, a
	ld a, 3
	hlcoord 9, 5
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	hlcoord 2, 4
	ld de, wDebugMenuScratchSpace
	call DebugPrintPokemonName
	ld a, 1
	ldh [hBGMapMode], a
	ret
.change_species
	ld de, wDebugMenuScratchSpace + 2
	ld hl, wDebugMenuScratchSpace
	call DebugMenuChangeValue
	jr .show_status
.change_step
	ld hl, wDebugMenuScratchSpace + 2
	call DebugMenuChangeStep
	jr .show_status
.change_level
	ld de, wDebugMenuScratchSpace + 2
	ld hl, wDebugMenuScratchSpace + 1
	lb bc, 1, 100
	call DebugMenuChangeValueLimited
	jr .show_status
.receive_egg
	ld a, [wDebugMenuScratchSpace]
	call IsAPokemon
	jr c, .invalid_pokemon
	cp EGG
	jr z, .invalid_pokemon
	ld b, a
	ld a, [wDebugMenuScratchSpace + 1]
	ld c, a
	push bc
	ld hl, .get_egg_script
	ld de, wDebugMenuScratchSpace
	ld bc, .end_copied_script - .get_egg_script
	rst CopyBytes
	pop bc
	ld hl, wDebugMenuScratchSpace + (.script_insertion_point - .get_egg_script) + 1
	ld a, b
	ld [hli], a
	ld [hl], c
	debug_exit MENU_EXIT_SCRIPT, wDebugMenuScratchSpace, BANK(.get_egg_script)
	ld de, SFX_TRANSACTION
	jr .play_sound
.invalid_pokemon
	ld de, SFX_WRONG
.play_sound
	jp PlayWaitSFX
.get_egg_script
	checkcode VAR_PARTYCOUNT
	sif >, 5
		jumptext .no_room_text
.script_insertion_point
	giveegg 0, 0
	jumptext .egg_received_text
.end_copied_script
	assert (.end_copied_script - .get_egg_script) <= 24
.no_room_text
	ctxt "You have 6 #mon"
	line "currently in your"
	para "party. You have"
	line "no room to"
	cont "receive this Egg."
	done
.egg_received_text
	ctxt "You received the"
	line "chosen Egg!"
	done

DebugMoneyMenu: debug_menu " Manage Money", DebugMainMenu, .options, .save_changes, .initialize
.options debug_menu_options .unit_selector, .own_money, .saved_money, .saving_money, .save, .reset, .cancel
.unit_selector debug_option "(cursor)", 0, .change_current_digit, .reset_current_digit
.own_money debug_option "Money:", 0, .change_money, .zero_out_money
.saved_money debug_option "Saved:", 0, .change_money, .zero_out_money
.saving_money debug_option "Saving:", 0, .toggle_saving, .toggle_saving
.save debug_option "Save changes", .save_changes
.reset debug_option "Reset changes", .initialize
.cancel debug_option "Go back", DebugMenuCancel
.help_message
	ctxt "Negative values"
	nl   "are only shown as"
	nl   "a calculation aid."
	nl   "They will not be"
	nl   "treated as signed!"
	done
.initialize
	ld de, .help_message
	hlcoord 1, 12
	call PlaceText
	wbk BANK(wMoney)
	ld hl, wMoney
	ld de, wDebugMenuScratchSpace
	ld bc, 6
	rst CopyBytes
	ld a, [wBankSavingMoney]
	and 1
	ld [wDebugMenuScratchSpace + 6], a
	xor a
	ld [wDebugMenuScratchSpace + 7], a
.show_status
	xor a
	ldh [hBGMapMode], a
	ld hl, wDebugMenuScratchSpace
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, c
	add a, $20 ;$000000 - $dfffff are shown as positive; $e00000 - $ffffff are shown as negative
	sbc a
	ld b, a
	hlcoord 10, 5
	ld a, 8
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	ld hl, wDebugMenuScratchSpace + 3
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, c
	add a, $20
	sbc a
	ld b, a
	hlcoord 10, 6
	predef PrintBigNumber
	hlcoord 11, 4
	ld de, DebugMenuClearString7
	call PlaceString
	ld a, [wDebugMenuScratchSpace + 7]
	cpl
	ld c, a
	ld b, $ff
	hlcoord 18, 4
	add hl, bc
	ld [hl], DEBUG_CURSOR_DOWN
	ld hl, wDebugMenuScratchSpace + 6
	bit 0, [hl]
	hlcoord 15, 7
	call DebugMenuPrintYesNo
	ld a, 1
	ldh [hBGMapMode], a
	ret
.change_current_digit
	ld a, [wDebugMenuScratchSpace + 7]
	jr c, .decrease_current_digit
	inc a
	cp 7
	jr c, .current_digit_selected
	xor a
	jr .current_digit_selected
.decrease_current_digit
	and a
	jr z, .highest_digit_selected
	dec a
	jr .current_digit_selected
.highest_digit_selected
	ld a, 6
	jr .current_digit_selected
.reset_current_digit
	xor a
.current_digit_selected
	ld [wDebugMenuScratchSpace + 7], a
.show_status_after_update
	jr .show_status
.change_money
	call .select_money_variable
	push hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, [wDebugMenuScratchSpace + 7]
	call DebugMenuModifyByPowerOfTen
	pop hl
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	jr .show_status_after_update
.zero_out_money
	call .select_money_variable
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	jr .show_status_after_update
.select_money_variable
	push af
	ld hl, wDebugMenuScratchSpace
	ld a, [wDebugMenuCurrentOption]
	dec a
	ld b, a
	add a, a
	add a, b
	ld c, a
	ld b, 0
	add hl, bc
	pop af
	ret
.toggle_saving
	ld a, [wDebugMenuScratchSpace + 6]
	xor 1
	ld [wDebugMenuScratchSpace + 6], a
	jr .show_status_after_update
.save_changes
	ld hl, wDebugMenuScratchSpace
	ld de, wMoney
	ld bc, 6
	rst CopyBytes
	ld a, [wBankSavingMoney]
	ld hl, wDebugMenuScratchSpace + 6
	and $fe
	or [hl]
	ld [wBankSavingMoney], a
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	jp DebugCloseAllMenus

DebugMenuPrintYesNo:
	;yes on nz, no on z
	jr z, .show_no
	ld de, .yes
	jr .got_text
.show_no
	ld de, .no
.got_text
	jp PlaceText

.yes
	text "yes"
	done
.no
	text " no"
	done

DebugTMHMMenu: debug_menu " Manage TMs/HMs", DebugManageItemsMenu, .options, .save, .initialize
.options debug_menu_options .cursors, .data, .data, .data, .data, .data, .data, .data, .data, .data, .data, .hm_list, .help
.cursors debug_option "", 0, .move_cursors, .reload
.data debug_option "", .toggle, .move_cursors, .reload
.hm_list debug_option "HM:", .toggle_hm, .move_cursors, .reload
.help debug_option "Help", .load_help, .move_cursors, .reload
.initialize
	wbk BANK(wTMsHMs)
	ld a, [wDebugMenuParameter]
	and a
	call z, .initial_data_load
	xor a
	ld [wDebugMenuScratchSpace], a
.show_status
	xor a
	ldh [hBGMapMode], a
	call .call_base_fn
	lb de, 1, NUM_TMS
	ld a, 4
	call DebugFlagGridBase
	hlcoord 10, 15
	ld a, [wDebugMenuScratchSpace + 15]
	ld c, NUM_HMS
.show_hm
	rrca
	ld [hl], DEBUG_FLAG_SET
	jr c, .hm_shown
	ld [hl], DEBUG_FLAG_CLEAR
.hm_shown
	inc hl
	dec c
	jr nz, .show_hm
	ld a, 1
	ldh [hBGMapMode], a
	ret
.initial_data_load
	ld a, 1
	ld [wDebugMenuParameter], a
.load_data
	ld hl, wTMsHMs
	ld bc, (NUM_TMS + 7) >> 3
	ld de, wDebugMenuScratchSpace + 2
	rst CopyBytes
	ld de, NUM_TMS
	lb bc, NUM_HMS + 1, 0
.load_hm_loop
	dec b
	ret z
	push de
	push bc
	ld hl, wTMsHMs
	ld b, 2
	call BigFlagAction
	ld b, 1
	jr nz, .has_hm
	dec b
.has_hm
	pop de
	push de
	ld d, 0
	ld hl, wDebugMenuScratchSpace + 15
	call BigFlagAction
	pop bc
	pop de
	inc de
	inc c
	jr .load_hm_loop
.call_base_fn
	ld de, wDebugMenuScratchSpace
	ld hl, wDebugMenuScratchSpace + 1
	ld bc, 7
	jp DebugFlagGridBase
.toggle
	ld a, 3
.call_base_fn_and_show_status
	call .call_base_fn
.show_status_after_update
	jr .show_status
.toggle_hm
	ld a, [wDebugMenuScratchSpace]
	and a
	ret z
	cp 9
	ret z
	jr nc, .toggle_multiple_hms
	ld c, 1
.hm_selection_loop
	dec a
	jr z, .hm_selected
	sla c
	jr .hm_selection_loop
.hm_selected
	ld a, [wDebugMenuScratchSpace + 15]
	xor c
.update_hms_show_status
	ld [wDebugMenuScratchSpace + 15], a
	jr .show_status_after_update
.toggle_multiple_hms
	rra
	ccf
	sbc a
	jr .update_hms_show_status
.move_cursors
	ccf
	sbc a
	add a, 2
	jr .call_base_fn_and_show_status
.reload
	call .load_data
	ld de, SFX_MENU
	call PlayWaitSFX
	jr .show_status_after_update
.save
	call .save_data
	ld de, SFX_TRANSACTION
	jp PlayWaitSFX
.save_data
	ld de, wTMsHMs
	ld bc, (NUM_TMS + 7) >> 3
	ld hl, wDebugMenuScratchSpace + 2
	rst CopyBytes
	ld bc, NUM_TMS
	lb de, NUM_HMS + 1, 0
.save_hm_loop
	dec d
	ret z
	push de
	push bc
	ld hl, wDebugMenuScratchSpace + 15
	ld d, 0
	ld b, 2
	call BigFlagAction
	ld b, 1
	jr nz, .set_hm
	dec b
.set_hm
	pop de
	push de
	ld hl, wTMsHMs
	call BigFlagAction
	pop bc
	pop de
	inc bc
	inc e
	jr .save_hm_loop
.load_help
	ld bc, DebugTMHMHelpMenu
	jp DebugMenuLoad

DebugTMHMHelpMenu: debug_menu " Manage TMs/HMs", DebugTMHMMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .help
.help debug_option "HELP (A: back)", DebugMenuCancel
.initialize
	ld a, 5
	jp DebugFlagGridBase

DebugEngineFlagMenu: debug_menu " Engine Flags", DebugFlagsMenu, .options, .save_changes, .initialize
.options debug_menu_options .cursors, .data, .data, .data, .data, .data, .data, .data, .data, .data, .data, .page, .help
.cursors debug_option "", 0, .move_cursors, .reload
.data debug_option "", .toggle, .move_cursors, .reload
.page debug_option "", 0, .change_page, .reload
.help debug_option "Help", .load_help, 0, .reload
.initialize
	ld a, [wDebugMenuParameter]
	and a
	call z, .initial_data_load
	wbk BANK(wDebugMenuScratchArea)
	xor a
	ld [wDebugMenuScratchSpace], a
.show_status
	lb bc, (NUM_ENGINE_FLAGS + 99) / 100, (NUM_ENGINE_FLAGS + 99) % 100
	jp DebugEngineEventFlagShowStatus
.move_cursors
	call DebugEngineEventFlagMoveCursors
	jr .show_status
.initial_data_load
	ld a, 1
	ld [wDebugMenuParameter], a
.load
	ld de, 0
.flag_load_loop
	push de
	wbk BANK(wPlayerGender)
	ld b, 2
	callba EngineFlagAction
	wbk BANK(wDebugMenuScratchArea)
	ld a, $ff
	add c
	ccf
	sbc a
	inc a
	ld b, a
	pop de
	push de
	ld hl, wDebugMenuScratchArea
	call BigFlagAction
	pop de
	inc de
	ld a, HIGH(NUM_ENGINE_FLAGS)
	cp d
	ret c
	jr nz, .flag_load_loop
	ld a, e
	cp LOW(NUM_ENGINE_FLAGS)
	jr c, .flag_load_loop
	ret
.reload
	call .load
	ld de, SFX_MENU
	call PlayWaitSFX
	jr .show_status
.toggle
	ld a, 3
	call DebugEngineEventFlagCallBase
	jr .show_status
.change_page
	ld b, (NUM_ENGINE_FLAGS + 99) / 100
	call DebugEngineEventFlagChangePage
	jr .show_status
.save_changes
	call .save
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	wbk BANK(wDebugMenuScratchArea)
	jr .show_status
.save
	ld de, 0
.flag_save_loop
	push de
	wbk BANK(wDebugMenuScratchArea)
	ld hl, wDebugMenuScratchArea
	ld b, 2
	call BigFlagAction
	ld a, $ff
	add c
	ccf
	sbc a
	inc a
	ld b, a
	pop de
	push de
	wbk BANK(wPlayerGender)
	callba EngineFlagAction
	pop de
	inc de
	ld a, HIGH(NUM_ENGINE_FLAGS)
	cp d
	ret c
	jr nz, .flag_save_loop
	ld a, e
	cp LOW(NUM_ENGINE_FLAGS)
	jr c, .flag_save_loop
	ret
.load_help
	ld bc, DebugEngineFlagHelpMenu
	jp DebugMenuLoad

DebugEngineEventFlagCallBase:
	push af
	ld a, [wDebugMenuParameter]
	ld bc, 100
	ld hl, -100
	rst AddNTimes
	pop af
	ld b, h
	ld c, l
	ld de, wDebugMenuScratchSpace
	ld hl, wDebugMenuScratchArea
	jp DebugFlagGridBase

DebugEngineEventFlagMoveCursors:
	ccf
	sbc a
	add a, 2
	ld de, wDebugMenuScratchSpace
	jp DebugFlagGridBase

DebugEngineEventFlagShowStatus:
	; b: number of pages, c: last element in last page
	push bc
	xor a
	ldh [hBGMapMode], a
	call DebugEngineEventFlagCallBase
	hlcoord 3, 15
	ld [hl], DEBUG_LEFT_ARROW
	hlcoord 17, 15
	ld [hl], DEBUG_RIGHT_ARROW
	hlcoord 10, 15
	ld [hl], "-"
	ld a, [wDebugMenuParameter]
	ld bc, 100
	ld hl, -100
	rst AddNTimes
	ld d, h
	ld e, l
	push de
	ld bc, 0
	hlcoord 5, 15
	ld a, 4
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	ld a, [wDebugMenuParameter]
	pop bc
	cp b
	jr z, .show_last_page_status
	ld hl, 99
	add hl, de
	ld d, h
	ld e, l
	hlcoord 12, 15
	ld bc, 0
	predef PrintBigNumber
	ld a, 1
	ldh [hBGMapMode], a
	ret
.show_last_page_status
	ld l, c
	ld h, 0
	push hl
	add hl, de
	ld d, h
	ld e, l
	hlcoord 12, 15
	ld bc, 0
	ld a, 4
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	ld a, 4
	call DebugFlagGridBase
	ld a, 1
	ldh [hBGMapMode], a
	ret

DebugEngineEventFlagChangePage:
	; b: last page
	ld a, [wDebugMenuParameter]
	jr c, .page_up
	dec a
	jr nz, .page_selected
	ld a, b
	jr .page_selected
.page_up
	inc a
	cp b
	jr c, .page_selected
	jr z, .page_selected
	ld a, 1
.page_selected
	ld [wDebugMenuParameter], a
	ret

DebugEngineFlagHelpMenu: debug_menu " Engine Flags", DebugEngineFlagMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .help
.help debug_option "HELP (A: back)", DebugMenuCancel
.initialize
	ld a, 5
	jp DebugFlagGridBase

DebugEventFlagMenu: debug_menu " Event Flags", DebugFlagsMenu, .options, .save_changes, .initialize
.options debug_menu_options .cursors, .data, .data, .data, .data, .data, .data, .data, .data, .data, .data, .page, .help
.cursors debug_option "", 0, .move_cursors, .reload
.data debug_option "", .toggle, .move_cursors, .reload
.page debug_option "", 0, .change_page, .reload
.help debug_option "Help", .load_help, 0, .reload
.initialize
	ld a, [wDebugMenuParameter]
	and a
	call z, .initial_data_load
	wbk BANK(wDebugMenuScratchArea)
	xor a
	ld [wDebugMenuScratchSpace], a
.show_status
	lb bc, (NUM_EVENTS + 99) / 100, (NUM_EVENTS + 99) % 100
	jp DebugEngineEventFlagShowStatus
.initial_data_load
	ld a, 1
	ld [wDebugMenuParameter], a
	call .load
	jr .show_status
.load
	ln a, BANK(wDebugMenuScratchArea), BANK(wEventFlags)
	ld hl, wEventFlags
	ld de, wDebugMenuScratchArea
.do_wram_copy
	ld bc, (NUM_EVENTS + 7) >> 3
	jp DoubleFarCopyWRAM

.move_cursors
	call DebugEngineEventFlagMoveCursors
	jr .show_status
.toggle
	ld a, 3
	call DebugEngineEventFlagCallBase
	jr .show_status
.reload
	call .load
	ld de, SFX_MENU
	jr .play_sound_and_show_status
.save_changes
	call .save
	ld de, SFX_TRANSACTION
.play_sound_and_show_status
	call PlayWaitSFX
	jr .show_status
.save
	ln a, BANK(wEventFlags), BANK(wDebugMenuScratchArea)
	ld hl, wDebugMenuScratchArea
	ld de, wEventFlags
	jr .do_wram_copy

.change_page
	ld b, (NUM_EVENTS + 99) / 100
	call DebugEngineEventFlagChangePage
	jr .show_status
.load_help
	ld bc, DebugEventFlagHelpMenu
	jp DebugMenuLoad

DebugEventFlagHelpMenu: debug_menu " Event Flags", DebugEventFlagMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .help
.help debug_option "HELP (A: back)", DebugMenuCancel
.initialize
	ld a, 5
	jp DebugFlagGridBase

DebugEditMemoryMenu: debug_menu " Edit WRAM Memory", DebugMemoryAccessMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .cursor, .address, .value, .read, .write, .back
.cursor debug_option "(cursor)", 0, .move_cursor, .change_mode
.address debug_option "Address:", 0, .change_address, .change_mode
.value debug_option "Contents:", 0, .change_value, .change_mode
.read debug_option "Read contents", .read_contents, 0, .change_mode
.write debug_option "Write contents", .write_contents, 0, .change_mode
.back debug_option "Go back", DebugMenuCancel, 0, .change_mode
.initialize
	xor a
	ld hl, wDebugMenuScratchSpace
	rept 6
		ld [hli], a
	endr
	hlcoord 1, 11
	ld de, .information_text
	call PlaceText
.show_status
	xor a
	ldh [hBGMapMode], a
	hlcoord 14, 5
	ld a, [wDebugMenuScratchSpace + 1]
	call DebugMenuPrintHexValue
	ld a, [wDebugMenuScratchSpace]
	call DebugMenuPrintHexValue
	hlcoord 14, 6
	ld a, [wDebugMenuScratchSpace + 3]
	call DebugMenuPrintHexValue
	ld a, [wDebugMenuScratchSpace + 2]
	call DebugMenuPrintHexValue
	hlcoord 14, 4
	push hl
	ld de, DebugMenuClearString4
	call PlaceString
	pop hl
	ld a, [wDebugMenuScratchSpace + 4]
	xor 3
	ld c, a
	ld b, 0
	add hl, bc
	ld [hl], DEBUG_CURSOR_DOWN
	ld hl, wDebugMenuScratchSpace + 5
	bit 0, [hl]
	ld de, .little_text
	jr z, .display_endian_chosen
	ld de, .big_text
.display_endian_chosen
	hlcoord 13, 11
	call PlaceText
	ld a, 1
	ldh [hBGMapMode], a
	ret
.move_cursor
	jr c, .move_cursor_forwards
	ld hl, wDebugMenuScratchSpace + 4
	inc [hl]
	res 2, [hl]
	jr .show_status
.move_cursor_forwards
	ld a, [wDebugMenuScratchSpace + 4]
	dec a
	and 3
	ld [wDebugMenuScratchSpace + 4], a
.show_status_after_update
	jr .show_status
.change_address
	push af
	ld a, [wDebugMenuScratchSpace + 4]
	cp 1
	ld e, a
	adc 1
	sub e
	ld d, a
	ld hl, wDebugMenuScratchSpace
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop af
	call DebugMenuChangeHexValue
	res 7, b
	ld [hl], b
	dec hl
	ld [hl], c
	jr .show_status_after_update
.change_value
	push af
	ld hl, wDebugMenuScratchSpace + 2
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	ld d, 1
	pop af
	call DebugMenuChangeHexValue
	dec hl
	ld [hl], b
	dec hl
	ld [hl], c
	jr .show_status_after_update
.read_contents
	call .select_address
	ld a, [hli]
	ld c, a
	ld b, [hl]
	call .endianness_swap
	ld hl, wDebugMenuScratchSpace + 2
	ld a, c
	ld [hli], a
	ld [hl], b
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	jr .show_status_after_update
.write_contents
	ld hl, wDebugMenuScratchSpace + 2
	ld a, [hli]
	ld c, a
	ld b, [hl]
	call .endianness_swap
	call .select_address
	ld a, h
	cp $c0
	jr z, .invalid_write_address
	cp $cf
	jr nz, .valid_write_address
	ld a, l
	cp LOW(wDebugMenuScratchSpace - 8)
	jr c, .valid_write_address
	cp LOW(wDebugMenuScratchSpace + 5)
	jr c, .invalid_write_address
.valid_write_address
	ld a, c
	ld [hli], a
	ld [hl], b
	ld de, SFX_TRANSACTION
	jr .play_sound
.invalid_write_address
	ld de, SFX_WRONG
.play_sound
	jp PlayWaitSFX
.select_address
	ld hl, wDebugMenuScratchSpace + 1
	ld a, [hl]
	swap a
	and 7
	jr z, .not_banked
	ldh [rSVBK], a
.not_banked
	xor 7
	cp 7
	adc 5
	swap a
	add a, [hl]
	dec hl
	ld l, [hl]
	ld h, a
	ret
.endianness_swap
	ld hl, wDebugMenuScratchSpace + 5
	bit 0, [hl]
	ret z
	ld a, c
	ld c, b
	ld b, a
	ret
.change_mode
	ld hl, wDebugMenuScratchSpace + 5
	ld a, 1
	xor [hl]
	ld [hl], a
	jp .show_status
.information_text
	ctxt "Endianness:"
	nl   "(SELECT: toggle)"
	nl   "Note: address is"
	nl   "absolute unbanked."
	nl   "Top nibble maps to"
	nl   "bank, rest: offset"
	done
.little_text
	ctxt "little"
	done
.big_text
	ctxt "   big"
	done

DebugExecuteFunctionMenu: debug_menu " Execute Function", DebugMemoryAccessMenu, .options, .execute, .initialize
.options debug_menu_options .cursor, .address
.cursor debug_option "(cursor)", 0, .move_cursor, .change_mode
.address debug_option "Address:   :", 0, .change_address, .change_mode
.initialize
	xor a
	ld hl, wDebugMenuScratchSpace
	rept 4
		ld [hli], a
	endr
	ld [hl], 2
	wbk BANK(wPlayerName)
	hlcoord 2, 7
	ld de, .help_text
	call PlaceText
.show_status
	xor a
	ldh [hBGMapMode], a
	ld a, " "
	ldcoord_a 1, 8
	ldcoord_a 1, 10
	ldcoord_a 1, 12
	ld a, [wDebugMenuScratchSpace + 4]
	hlcoord 1, 4
	ld bc, 2 * SCREEN_WIDTH
	rst AddNTimes
	ld [hl], DEBUG_CURSOR_RIGHT
	ld a, [wDebugMenuScratchSpace + 2]
	hlcoord 11, 5
	call DebugMenuPrintHexValue
	inc hl
	ld a, [wDebugMenuScratchSpace + 1]
	call DebugMenuPrintHexValue
	ld a, [wDebugMenuScratchSpace]
	call DebugMenuPrintHexValue
	hlcoord 11, 4
	push hl
	ld de, DebugMenuClearString7
	call PlaceString
	ld hl, wDebugMenuScratchSpace + 3
	ld a, 5
	sub [hl]
	pop hl
	ld c, a
	ld b, 0
	cp 2
	jr c, .cursor_in_bank
	inc c
.cursor_in_bank
	add hl, bc
	ld [hl], DEBUG_CURSOR_DOWN
	ld a, 1
	ldh [hBGMapMode], a
	ret
.move_cursor
	ld a, [wDebugMenuScratchSpace + 3]
	jr c, .move_cursor_forwards
	inc a
	cp 6
	jr c, .cursor_moved
	xor a
	jr .cursor_moved
.move_cursor_forwards
	sub 1 ; sets carry for 0
	jr nc, .cursor_moved
	ld a, 5
.cursor_moved
	ld [wDebugMenuScratchSpace + 3], a
.show_status_after_update
	jr .show_status
.change_address
	push af
	ld d, 1
	ld hl, wDebugMenuScratchSpace + 3
	ld e, [hl]
	bit 2, e
	jr nz, .change_bank
	ld hl, wDebugMenuScratchSpace
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop af
	call DebugMenuChangeHexValue
	ld a, b
	ld [hld], a
	ld [hl], c
	jr .show_status_after_update
.change_bank
	res 2, e
	ld hl, wDebugMenuScratchSpace + 2
	ld c, [hl]
	ld b, 0
	pop af
	call DebugMenuChangeHexValue
	res 7, c
	ld [hl], c
	jr .show_status_after_update
.change_mode
	ld a, [wDebugMenuScratchSpace + 4]
	inc a
	cp 5
	jr c, .mode_changed
	ld a, 2
.mode_changed
	ld [wDebugMenuScratchSpace + 4], a
	jr .show_status_after_update
.execute
	ld hl, wDebugMenuScratchSpace
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	jr z, .address_is_zero
	ld d, [hl]
	ld a, [wDebugMenuScratchSpace + 4]
	ld e, a
	push bc
	push de
	ld de, SFX_TRANSACTION
	call PlayWaitSFX
	pop de
	pop bc
	jp DebugMenuExit
.address_is_zero
	ld de, SFX_WRONG
	jp PlayWaitSFX
.help_text
	ctxt "Calling modes:"
	nl   "2: close text,"
	nl   "   call directly"
	nl   "3: close text,"
	nl   "   execute script"
	nl   "4: no close text,"
	nl   "   execute script"
	nl   ""
	nl   "SEL: change mode"
	nl   "START: close/exec"
	done

DebugMultDivTestMenu: debug_menu " Mult/Div Test", DebugMiscellaneousMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .cursor, .first, .second, .back
.cursor debug_option "(cursor)", 0, .move_cursor
.first debug_option "1st number:", 0, .change_number
.second debug_option "2nd number:", 0, .change_number
.back debug_option "Go back", DebugMenuCancel
.initialize
	xor a
	ld hl, wDebugMenuScratchSpace
	rept 5
		ld [hli], a
	endr
	ld de, .labels
	hlcoord 2, 11
	call PlaceText
.show_status
	xor a
	ldh [hBGMapMode], a
	hlcoord 14, 4
	push hl
	ld de, DebugMenuClearString5
	call PlaceString
	pop hl
	ld a, [wDebugMenuScratchSpace + 4]
	cpl
	add a, 5
	ld c, a
	ld b, 0
	add hl, bc
	ld [hl], DEBUG_CURSOR_DOWN
	ld a, [wDebugMenuScratchSpace]
	ld e, a
	ld a, [wDebugMenuScratchSpace + 1]
	ld d, a
	push de
	ld bc, 0
	ld a, 5
	hlcoord 14, 5
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	ld a, [wDebugMenuScratchSpace + 2]
	ld e, a
	ld a, [wDebugMenuScratchSpace + 3]
	ld d, a
	push de
	ld bc, 0
	hlcoord 14, 6
	predef PrintBigNumber
	pop de
	pop bc
	push bc
	push de
	call Multiply16
	hlcoord 9, 12
	ld a, 10 | $80
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	pop bc
	call .show_division_result
	ld a, 1
	ldh [hBGMapMode], a
	ret
.show_division_result
	ld a, d
	or e
	jr z, .division_by_zero
	call Divide16
	push bc
	ld bc, 0
	ld a, 5
	hlcoord 5, 15
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	pop de
	ld bc, 0
	hlcoord 14, 15
	predef_jump PrintBigNumber
.division_by_zero
	ld de, .div0
	push de
	hlcoord 5, 15
	call PlaceText
	pop de
	hlcoord 14, 15
	jp PlaceText
.move_cursor
	ld a, [wDebugMenuScratchSpace + 4]
	jr c, .move_cursor_forwards
	inc a
	cp 5
	jr c, .cursor_moved
	xor a
	jr .cursor_moved
.move_cursor_forwards
	sub 1 ; sets carry for 0
	jr nc, .cursor_moved
	ld a, 4
.cursor_moved
	ld [wDebugMenuScratchSpace + 4], a
.show_status_after_update
	jp .show_status
.change_number
	push af
	ld hl, wDebugMenuScratchSpace - 2
	ld a, [wDebugMenuCurrentOption]
	ld bc, 2
	rst AddNTimes
	ld bc, 0
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop af
	push hl
	ld a, [wDebugMenuScratchSpace + 4]
	call DebugMenuModifyByPowerOfTen
	pop hl
	ld a, d
	ld [hld], a
	ld [hl], e
	jr .show_status_after_update
.labels
	ctxt "Multiplication:"
	nl   "    P:"
	nl   ""
	nl   "Division:"
	nl   "Q:       R:"
	done
.div0
	text "-----"
	done

DebugSoundTestMenu: debug_menu " Sound test", DebugMiscellaneousMenu, .options, .restart_back, .initialize
.options debug_menu_options .music, .sound, .cry, .cry_faint, .restart, .restart_go_back, .exit
.music debug_option "Play music:", .play_music, .change_music, .change_step
.sound debug_option "Play sound:", .play_sound, .change_sound, .change_step
.cry debug_option "Play cry:", .play_cry, .change_cry, .change_step
.cry_faint debug_option "Fainting cry:", .play_fainted_cry, .change_fainted_cry, .change_step
.restart debug_option "Restart map music", RestartMapMusic, 0, .change_step
.restart_go_back debug_option "Restart/go back", .restart_back, 0, .change_step
.exit debug_option "Exit all menus", DebugCloseAllMenus, 0, .change_step
.initialize
	xor a
	ld hl, wDebugMenuScratchSpace
	ld [hli], a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld de, .help_info
	hlcoord 2, 14
	call PlaceText
	jr .show_status

.change_music
	ld hl, wDebugMenuScratchSpace
	lb bc, 0, NUM_MUSIC - 1
.change_value_limited_and_show_status
	ld de, wDebugMenuScratchSpace + 2
	call DebugMenuChangeValueLimited
	jr .show_status

.change_sound
	ld hl, wDebugMenuScratchSpace + 1
	lb bc, 0, NUM_SFX - 1
	jr .change_value_limited_and_show_status

.change_cry
	ld hl, wDebugMenuScratchSpace + 3
	lb bc, 1, 254
	jr .change_value_limited_and_show_status

.change_fainted_cry
	ld hl, wDebugMenuScratchSpace + 4
	lb bc, 1, 254
	jr .change_value_limited_and_show_status

.change_step
	ld hl, wDebugMenuScratchSpace + 2
	call DebugMenuChangeStep
.show_status
	xor a
	ldh [hBGMapMode], a
	ld a, 3
	ldh [hDigitsFlags], a
	ld a, [wDebugMenuScratchSpace]
	hlcoord 16, 4
	call .print_index
	ld a, [wDebugMenuScratchSpace + 1]
	hlcoord 16, 5
	call .print_index
	ld a, [wDebugMenuScratchSpace + 3]
	hlcoord 16, 6
	call .print_index
	ld a, [wDebugMenuScratchSpace + 4]
	hlcoord 16, 7
	call .print_index
	ld a, 2
	ldh [hDigitsFlags], a
	ld a, [wDebugMenuScratchSpace + 2]
	hlcoord 17, 14
	call .print_index
	ld a, 1
	ldh [hBGMapMode], a
	ret

.print_index
	ld e, a
	ld bc, 0
	ld d, b
	predef_jump PrintBigNumber

.play_music
	ld de, 0
	call PlayMusic
	call DelayFrame
	ld a, [wDebugMenuScratchSpace]
	ld e, a
	ld d, 0
	jp PlayMusic
.play_sound
	ld a, [wDebugMenuScratchSpace + 1]
	ld e, a
	ld d, 0
	call WaitPlaySFX
	jp WaitSFX
.play_cry
	ld a, [wDebugMenuScratchSpace + 3]
	jp PlayCry
.play_fainted_cry
	; PlayCry does this before doing the rest, PlayFaintingCry doesn't!
	xor a
	ld [wStereoPanningMask], a
	ld [wCryTracks], a
	ld a, [wDebugMenuScratchSpace + 4]
	jp PlayFaintingCry
.restart_back
	call RestartMapMusic
	jp DebugMenuCancel

.help_info
	ctxt "L/R: change by"
	nl   "SEL: change step"
	nl   "A: play selected"
	done

DebugStopwatchTestMenu: debug_menu " Stopwatch test", DebugMiscellaneousMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .number, .read, .toggle, .reset, .back
.number debug_option "Stopwatch:", 0, .change_stopwatch
.read debug_option "Read:", .read_stopwatch
.toggle debug_option "Start/stop", .toggle_stopwatch
.reset debug_option "Reset", .reset_stopwatch
.back debug_option "Go back", DebugMenuCancel
.initialize
	xor a
	ld [wDebugMenuScratchSpace], a
.show_stopwatch_number
	hlcoord 18, 4
	ld a, [wDebugMenuScratchSpace]
	add a, "0"
	ld [hl], a
	ret
.change_stopwatch
	sbc a
	and 2
	dec a
	ld hl, wDebugMenuScratchSpace
	add a, [hl]
	and 7
	ld [hl], a
	call .clear_read_field
	jr .show_stopwatch_number
.read_stopwatch
	ld a, [wDebugMenuScratchSpace]
	ld c, a
	ld b, 0
	decoord 11, 5
	jpba PrintStopwatchValue
.toggle_stopwatch
	ld a, [wDebugMenuScratchSpace]
	ld c, 1
	and a
	jr z, .stopwatch_selected
.selection_loop
	sla c
	dec a
	jr nz, .selection_loop
.stopwatch_selected
	ld a, [wStopwatchControl]
	xor c
	ld [wStopwatchControl], a
	jr .clear_read_field
.reset_stopwatch
	ld a, [wDebugMenuScratchSpace]
	ld c, a
	ld b, STOPWATCH_RESET
	callba ReadStopwatch
.clear_read_field
	ld de, DebugMenuClearString8
	hlcoord 11, 5
	jp PlaceString

DebugExpGrpMenu: debug_menu " Gen 3 Exp Test", DebugMiscellaneousMenu, .options, DebugMenuCancel, .initialize
.options debug_menu_options .grp, .level, .back
.grp debug_option "Group:", .calc_exp, .change_grp, .change_step
.level debug_option "Level:", .calc_exp, .change_level, .change_step
.back debug_option "Go Back", DebugMenuCancel, 0, .change_step
.initialize
	xor a
	ld [wDebugMenuScratchSpace], a
	ld [wDebugMenuScratchSpace + 2], a ; growth rate
	inc a
	ld [wDebugMenuScratchSpace + 1], a ; level
	ld [wDebugMenuScratchSpace + 3], a ; step size

	ld de, .result_str
	hlcoord 4, 7
	call PlaceText

	ld de, .help_info
	hlcoord 2, 14
	call PlaceText
.calc_exp
	xor a
	ldh [hBGMapMode], a
	ld a, [wDebugMenuScratchSpace + 1] ; level
	ld d, a
	ld a, [wDebugMenuScratchSpace + 2] ; growth rate
	ld b, a

	ldh a, [rSVBK]
	push af
	wbk BANK(wBaseGrowthRate)
	ld a, b
	ld [wBaseGrowthRate], a
	callba CalcExpAtLevel
	pop af
	ldh [rSVBK], a
	ld hl, hProduct + 1
	ld b, 0
	ld c, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld e, [hl]
	hlcoord 4, 8
	ld a, $88
	ldh [hDigitsFlags], a
	predef PrintBigNumber
	jr .update_remaining_display

.change_grp
	assert FLUCTUATING == 7
	ld hl, wDebugMenuScratchSpace + 2 ; growth rate
	ccf
	sbc a
	sbc -1 ; a = -1 if no carry, 1 if carry
	add a, [hl]
	and 7
	ld [hl], a
	jr .update_display

.change_level
	ld hl, wDebugMenuScratchSpace + 1 ; level
	ld de, wDebugMenuScratchSpace + 3 ; step size
	lb bc, 1, MAX_LEVEL
	call DebugMenuChangeValueLimited
	jr .update_display

.change_step
	ld hl, wDebugMenuScratchSpace + 3 ; step size
	call DebugMenuChangeStep
.update_display
	xor a
	ldh [hBGMapMode], a
.update_remaining_display
	ld a, [wDebugMenuScratchSpace + 2] ; growth rate
	ld bc, .FluctuatingString - .ErraticString
	ld hl, .GrowthRatesStrings
	rst AddNTimes
	decoord SCREEN_WIDTH - CHARLEN("Fluctuating@"), 4
	rst CopyBytes

	ld a, 3
	ldh [hDigitsFlags], a
	ld a, [wDebugMenuScratchSpace + 1]
	hlcoord 16, 5
	call .print_index

	ld a, 2
	ldh [hDigitsFlags], a
	ld a, [wDebugMenuScratchSpace + 3]
	hlcoord 17, 14
.print_index
	ld e, a
	ld bc, 0
	ld d, b
	predef PrintBigNumber
	ld a, 1
	ldh [hBGMapMode], a
	ret

.GrowthRatesStrings:
.MedFastString     db "Medium Fast"
.SlightFastString  db "Slight Fast"
.SlightSlowString  db "Slight Slow"
.MedSlowString     db "Medium Slow"
.SlowString        db "       Slow"
.FastString        db "       Fast"
.ErraticString     db "    Erratic"
.FluctuatingString db "Fluctuating"

.result_str
	ctxt "Results:"
	done

.help_info
	ctxt "L/R: change by"
	nl   "SEL: change step"
	nl   "  A: calculate"
	done
