EVAR_PACHISI_POSITION EQU EVAR_X
EVAR_PACHISI_DICE_ROLLS EQU EVAR_Y

PachisiGameBotan::
	setevent EVENT_PACHISI_GAME_IN_BOTAN
	jump PachisiMain

PachisiGameTorenia::
	clearevent EVENT_PACHISI_GAME_IN_BOTAN
	; fallthrough

PachisiMain:
	opentext
	special PlaceMoneyTopRight
	writetext PachisiTextStartText
	yesorno
	sif false
		closetextend
	checkmoney 0, 2000
	sif =, 2
		jumptext PachisiTextNotEnoughMoney
	takemoney 0, 2000
	waitsfx
	playsound SFX_TRANSACTION
	closetext
	applymovement PLAYER, .player_step_aside_movement
	applymovement 2, .guard_move_down_movement
	applymovement PLAYER, .player_enter_board_movement
	applymovement 2, .guard_move_up_movement
	playmusic MUSIC_MOBILE_ADAPTER
	seteventvartovalue EVAR_PACHISI_DICE_ROLLS, 25
	checkevent EVENT_PACHISI_GAME_IN_BOTAN
	sif true
		seteventvartovalue EVAR_PACHISI_DICE_ROLLS, 30
	seteventvar EVAR_PACHISI_POSITION, 0
.main_loop
	opentext
	callasm FacePlayerToNextTile
	applymovement PLAYER, wPachisiPath
	readeventvar EVAR_PACHISI_DICE_ROLLS
	sif false, then
		writetext PachisiOutOfRollsText
		playwaitsfx SFX_QUIT_SLOTS
		closetext
		jump .game_over
	sendif
	sif =, 1, then
		writetext PachisiAskRollFinalText
	selse
		writetext PachisiAskRollText
	sendif
	yesorno
	iffalse .ask_end_game
	deceventvar EVAR_PACHISI_DICE_ROLLS
	random 6
	addvar 1
	writetext PachisiRolledDiceText
.move_player_forwards
	callasm CreatePachisiPath
.move_player_by_calculated_path
	closetext
	applymovement PLAYER, wPachisiPath
	callasm GetPachisiTile
	if_greater_than LAST_PACHISI_TILE, .main_loop
	anonjumptable
	dw .main_loop
	dw .grass_mon_tile
	dw .water_mon_tile
	dw .cave_mon_tile
	dw .get_money_tile
	dw .party_heal_tile
	dw .get_item_tile
	dw .lose_money_tile
	dw .warp_tile_torenia_forwards
	dw .warp_tile_torenia_backwards
	dw .death_tile
	dw .extra_rolls_tile
	dw .random_tile
	dw .finish_tile
	dw .move_forwards_tile
	dw .move_backwards_tile
	dw .warp_tile_botan_item_section
	dw .warp_tile_botan_second_section
	dw .warp_tile_botan_random_section
	dw .warp_tile_botan_third_section
	dw .warp_tile_botan_fourth_section
	dw .main_loop

.grass_mon_tile
	writehalfword PachisiGrassPokemon
	jump .do_battle_tile

.water_mon_tile
	writehalfword PachisiWaterPokemon
	jump .do_battle_tile

.cave_mon_tile
	writehalfword PachisiCavePokemon
.do_battle_tile
	callasm PachisiGetPokemon
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	startbattle
	dontrestartmapmusic
	reloadmap
	iftrue .game_over
	playmusic MUSIC_MOBILE_ADAPTER
	jump .main_loop

.get_money_tile
	opentext
	playwaitsfx SFX_TRANSACTION
	writetext PachisiMoneyText
	givemoney 0, 500
	waitbutton
	closetext
	jump .main_loop

.party_heal_tile
	special HealParty
	special Special_BattleTowerFade
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	showtext HealTileText
	jump .main_loop

.get_item_tile
	callasm GetPachisiItem
	opentext
	verbosegiveitem ITEM_FROM_MEM
	waitbutton
	jump .main_loop

.lose_money_tile
	opentext
	playwaitsfx SFX_BEAT_UP
	writetext PachisiMuncher
	takemoney 0, 500
	waitbutton
	closetext
	jump .main_loop

.death_tile
	playmusic MUSIC_NONE
	playwaitsfx SFX_GS_INTRO_CHARIZARD_FIREBALL
	showtext PachisiDeathText
	jump .game_over

.extra_rolls_tile
	random 4
	sif false
		writebyte 2
	playwaitsfx SFX_EGG_HATCH
	sif =, 1, then
		showtext PachisiGetOneDieRollText
	selse
		showtext PachisiGetDiceRollsText
	sendif
	addtoeventvar EVAR_PACHISI_DICE_ROLLS, 0
	jump .main_loop

.random_tile
	random 11
	anonjumptable
	dw .grass_mon_tile
	dw .cave_mon_tile
	dw .water_mon_tile
	dw .party_heal_tile
	dw .get_item_tile
	dw .lose_money_tile
	dw .get_money_tile
	dw .death_tile
	dw .extra_rolls_tile
	dw .move_forwards_tile
	dw .move_backwards_tile

.move_forwards_tile
	opentext
	random 6
	addvar 1
	writetext PachisiMoveForwardText
	jump .move_player_forwards

.move_backwards_tile
	opentext
	random 6
	addvar 1
	callasm BackwardsTile
	writetext PachisiMoveBackwardsText
	jump .move_player_by_calculated_path

.warp_tile_torenia_forwards
	scall .prepare_warp
	warp TORENIA_PACHISI, 3, 12
	writebyte (PachisiToreniaWarp2 - PachisiToreniaTiles)
	jump .do_warp

.warp_tile_torenia_backwards
	scall .prepare_warp
	warp TORENIA_PACHISI, 18, 2
	writebyte (PachisiToreniaWarp1 - PachisiToreniaTiles)
	jump .do_warp

.warp_tile_botan_second_section
	scall .prepare_warp
	warp BOTAN_PACHISI, 12, 8
	writebyte (PachisiBotanSection2 - PachisiBotanTiles)
	jump .do_warp

.warp_tile_botan_third_section
	scall .prepare_warp
	warp BOTAN_PACHISI, 17, 18
	writebyte (PachisiBotanSection3 - PachisiBotanTiles)
	jump .do_warp

.warp_tile_botan_fourth_section
	scall .prepare_warp
	warp BOTAN_PACHISI, 10, 30
	writebyte (PachisiBotanSection4 - PachisiBotanTiles)
	jump .do_warp

.warp_tile_botan_item_section
	scall .prepare_warp
	warp BOTAN_PACHISI, 38, 2
	writebyte (PachisiBotanItem - PachisiBotanTiles)
	jump .do_warp

.warp_tile_botan_random_section
	scall .prepare_warp
	warp BOTAN_PACHISI, 27, 30
	writebyte (PachisiBotanRandom - PachisiBotanTiles)
.do_warp
	writeeventvar EVAR_PACHISI_POSITION
	playsound SFX_WARP_TO
	playmusic MUSIC_MOBILE_ADAPTER
	applymovement PLAYER, .after_warp_movement
	jump .main_loop

.prepare_warp
	playsound SFX_WARP_FROM
	applymovement PLAYER, .before_warp_movement
	special FadeOutPalettes
	end

.finish_tile
	playwaitsfx SFX_DEX_FANFARE_230_PLUS
	scriptstartasm
	ld hl, wPachisiWinCount
	inc [hl]
	jr nz, .done_increasing_win_count
	inc hl
	inc [hl]
	jr nz, .done_increasing_win_count
	dec [hl]
	dec hl
	dec [hl]
.done_increasing_win_count
	scriptstopasm
	checkevent EVENT_PACHISI_GAME_IN_BOTAN
	sif true, then
		warpfacing 1, BOTAN_PACHISI, 15, 39
		writehalfword EVENT_BOTAN_SHINY_BALL
	selse
		warpfacing 1, TORENIA_PACHISI, 17, 27
		writehalfword EVENT_TORENIA_SHINY_BALL
	sendif
	opentext
	writetext PachisiCongratsText
	checkevent -1
	sif true, then
		verbosegiveitem BIG_NUGGET
	selse
		setevent -1
		verbosegiveitem SHINY_BALL
	sendif
	endtext

.ask_end_game
	writetext AskLeaveText
	yesorno
	iffalse .main_loop
.game_over
	special HealParty
	callasm ForceMapMusicRestart
	checkevent EVENT_PACHISI_GAME_IN_BOTAN
	sif false, then
		warpfacing UP, TORENIA_PACHISI, 17, 27
	selse
		warpfacing UP, BOTAN_PACHISI, 15, 39
	sendif
	jumptext LostGameText

.before_warp_movement
	teleport_from
	step_end

.after_warp_movement
	teleport_to
	step_end

.player_step_aside_movement
	step_left
	turn_head_right
	step_end

.guard_move_down_movement
	step_down
	step_down
	turn_head_up
	step_end

.player_enter_board_movement
	step_right
.guard_move_up_movement
	step_up
	step_up
	step_end

FacePlayerToNextTile:
	call GetPachisiDirection
	call AddPachisiPositionOffset
	ld a, [hl]
	and 3
	ld hl, wPachisiPath
	ld [hli], a
	ld a, movement_step_end
	ld [hl], a
	ret

PachisiGetPokemon:
	ld a, (1 << 7) | 1
	ld [wBattleScriptFlags], a
	call Random
	and $f
	ld l, a
	ldh a, [hScriptHalfwordVar]
	add a, l
	ld l, a
	ldh a, [hScriptHalfwordVar + 1]
	ld h, a
	jr nc, .ok
	inc h
.ok
	ld a, [hl]
	ld [wTempWildMonSpecies], a
	call Random
	and 7
	add a, 25
	ld [wCurPartyLevel], a
	ret

GetPachisiItem:
	ld hl, PachisiItems
	call Random
	and $3f
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ldh [hScriptVar], a
	ret

GetPachisiTile:
	ld de, EVENT_PACHISI_GAME_IN_BOTAN
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld hl, PachisiToreniaTiles
	jr z, .inTorenia
	ld hl, PachisiBotanTiles
.inTorenia
	call AddPachisiPositionOffset
	ld a, [hl]
	ldh [hScriptVar], a
	ret

GetPachisiDirection:
	ld de, EVENT_PACHISI_GAME_IN_BOTAN
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld hl, PachisiToreniaDirections
	ret z
	ld hl, PachisiBotanDirections
	ret

BackwardsTile:
	call GetPachisiDirection
	call AddPachisiPositionOffset
	ldh a, [hScriptVar]
	dec hl
	ld c, a
	ld b, 0
	ld de, wPachisiPath
.loop
	ld a, [hld]
	cp movement_step_end
	jr z, .endLoop
	xor 1
	ld [de], a
	inc de
	inc b
	dec c
	jr nz, .loop
.endLoop
	ld a, movement_step_end
	ld [de], a
	xor a
	sub b
	jr UpdatePachisiPosition

CreatePachisiPath:
	call GetPachisiDirection
	call AddPachisiPositionOffset
	ldh a, [hScriptVar]
	ld c, a
	ld b, 0
	ld de, wPachisiPath
.loop
	ld a, [hli]
	cp movement_step_end
	jr z, .endLoop
	ld [de], a
	inc de
	inc b
	dec c
	jr nz, .loop
.endLoop
	ld a, movement_step_end
	ld [de], a
	ld a, b
UpdatePachisiPosition:
	wbk BANK(wEventVariables)
	ld hl, wEventVariables + EVAR_PACHISI_POSITION
	add a, [hl]
	ld [hl], a
	wbk 1
	ret

AddPachisiPositionOffset:
	wbk BANK(wEventVariables)
	ld a, [wEventVariables + EVAR_PACHISI_POSITION]
	wbk 1
	add a, l
	ld l, a
	ret nc
	inc h
	ret

PachisiMoveBackwardsText:
	start_asm
	ld hl, .backwards_string
	jr PachisiBackwardsForwardsTextRoutine

.backwards_string
	db "backwards@"
PachisiForwardsString:
	db "forwards@"

PachisiMoveForwardText:
	start_asm
	ld hl, PachisiForwardsString
PachisiBackwardsForwardsTextRoutine:
	push bc
	ld de, wStringBuffer3
	ld bc, 10
	rst CopyBytes
	ldh a, [hScriptVar]
	pop bc
	ld hl, .multiple_tiles_text
	dec a
	ret nz
	ld hl, .one_tile_text
	ret

.multiple_tiles_text
	ctxt "Move @"
	deciram hScriptVar, 1, 3
	ctxt " tiles"
	line "<STRBF3>!"
	sdone

.one_tile_text
	ctxt "Move one tile"
	line "<STRBF3>!"
	sdone

PachisiOutOfRollsText:
	ctxt "You have run out"
	line "of rolls."

	para "The game is over."
	done

HealTileText:
	ctxt "Your #mon party"
	line "was fully healed!"
	sdone

LostGameText:
	ctxt "Nice try! Come"
	line "back some other"
	cont "time!"
	done

AskLeaveText:
	ctxt "Are you sure you"
	line "want to leave the"
	cont "game?"
	done

PachisiRolledDiceText:
	ctxt "You rolled a @"
	deciram hScriptVar, 1, 3
	text "!"
	sdone

PachisiAskRollFinalText:
	ctxt "Last roll!"
	line "Roll the dice?"
	done

PachisiAskRollText:
	deciram hScriptVar, 1, 2
	ctxt " rolls left."
	line "Roll the dice?"
	done

PachisiTextNotEnoughMoney:
	ctxt "You don't have"
	line "enough money to"
	cont "play."
	done

PachisiTextStartText:
	ctxt "Welcome to the"
	line "Pachisi Board!"

	para "It costs ¥2000 to"
	line "play. Want to give"
	cont "it a go?"
	done

PachisiMoneyText:
	ctxt "You found ¥500!"
	done

PachisiMuncher:
	ctxt "The Muncher nipped"
	line "¥500 off of you!"
	done

PachisiDeathText:
	ctxt "Uh oh!"

	para "The game is now"
	line "over."
	sdone

PachisiGetOneDieRollText:
	ctxt "Gained one"
	line "additional roll!"
	sdone

PachisiGetDiceRollsText:
	ctxt "Gained @"
	deciram hScriptVar, 1, 3
	ctxt ""
	line "additional rolls!"
	sdone

PachisiCongratsText:
	ctxt "Congratulations!"
	line "You have won!"
	sdone
