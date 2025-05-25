INCLUDE "includes.asm"

INCLUDE "home.asm"
INCLUDE "battle/files.asm"

INCLUDE "engine/intro_menu.asm"
INCLUDE "tilesets/collision.asm"

SECTION "Code 1", ROMX

INCLUDE "gfx/initialize_map.asm"

INCLUDE "engine/learn.asm"

INCLUDE "engine/link_trade.asm"

INCLUDE "items/item_attributes.asm"

INCLUDE "engine/happiness.asm"

INCLUDE "engine/specials2.asm"

INCLUDE "engine/timeofdaypals.asm"

INCLUDE "gfx/push_oam.asm"

INCLUDE "engine/main_menu.asm"

SECTION "Code 2", ROMX

INCLUDE "engine/color.asm"

INCLUDE "engine/printer.asm"

INCLUDE "event/customization.asm"

INCLUDE "event/move_relearner.asm"

INCLUDE "event/poisonstep.asm"

INCLUDE "engine/pokedex2.asm"

SECTION "Code 3", ROMX

INCLUDE "engine/pack.asm"
INCLUDE "engine/time.asm"
INCLUDE "engine/tmhm.asm"
INCLUDE "engine/namingscreen.asm"

INCLUDE "event/itemball.asm"
INCLUDE "engine/healmachineanim.asm"
INCLUDE "event/whiteout.asm"
INCLUDE "event/itemfinder.asm"
INCLUDE "engine/startmenu.asm"
INCLUDE "engine/selectmenu.asm"
INCLUDE "event/elevator.asm"

INCLUDE "event/magnet_train.asm"

INCLUDE "engine/signpost.asm"

INCLUDE "event/cage_key_doors.asm"

SECTION "Code 4", ROMX

INCLUDE "engine/overworld.asm"
INCLUDE "engine/tile_events.asm"
INCLUDE "engine/save.asm"
INCLUDE "engine/spawn_points.asm"
INCLUDE "engine/map_setup.asm"

PokemonNames:: INCLUDE "data/pokemon_names.asm"

SECTION "Code 5", ROMX

INCLUDE "data/egg_moves.asm"

INCLUDE "engine/print_number.asm"

INCLUDE "event/hidden_item.asm"

INCLUDE "battle/badge_boosts.asm"

SECTION "Code 6", ROMX

INCLUDE "engine/pokepic.asm"

INCLUDE "engine/objects.asm"

INCLUDE "engine/scrolling_menu.asm"
INCLUDE "engine/switch_items.asm"

INCLUDE "engine/mon_menu.asm"
INCLUDE "battle/menu.asm"
INCLUDE "engine/buy_sell_toss.asm"
INCLUDE "engine/trainer_card.asm"
INCLUDE "trainers/dvs.asm"

INCLUDE "battle/consume_held_item.asm"

INCLUDE "engine/player_movement.asm"

INCLUDE "engine/search.asm"

INCLUDE "engine/changeblocks.asm"

INCLUDE "engine/landmarks.asm"

SECTION "Code 7", ROMX

INCLUDE "engine/link.asm"

INCLUDE "engine/fruit_trees.asm"

SECTION "Code 8", ROMX

INCLUDE "battle/trainer_huds.asm"

TrainerClassNames:: INCLUDE "trainers/class_names.asm"

INCLUDE "battle/ai/redundant.asm"

INCLUDE "event/move_deleter.asm"

INCLUDE "engine/tmhm2.asm"

MoveDescriptions:: INCLUDE "battle/moves/move_descriptions.asm"

INCLUDE "battle/initialize.asm"

INCLUDE "battle/music.asm"

INCLUDE "gfx/place_graphic.asm"

INCLUDE "engine/spawn_player.asm"

INCLUDE "engine/object_structs.asm"

INCLUDE "engine/walk_follow.asm"

INCLUDE "engine/heal_party.asm"

INCLUDE "gfx/load_pics.asm"

SECTION "Code 9", ROMX

INCLUDE "battle/ai/move.asm"
INCLUDE "battle/ai/items.asm"

AIScoring: INCLUDE "battle/ai/scoring.asm"

INCLUDE "event/mining.asm"
INCLUDE "event/smelting.asm"
INCLUDE "event/jeweling.asm"

SECTION "Code 10", ROMX

INCLUDE "engine/pokedex.asm"

INCLUDE "battle/moves/moves.asm"

SECTION "Code 11", ROMX

ItemNames:: INCLUDE "items/item_names.asm"

INCLUDE "items/item_descriptions.asm"

MoveNames:: INCLUDE "battle/moves/move_names.asm"

INCLUDE "engine/sound_stack.asm"

INCLUDE "event/sweet_scent.asm"

SECTION "Code 12", ROMX

INCLUDE "engine/place_on_screen.asm"

INCLUDE "engine/items.asm"

INCLUDE "event/magnet_train_station.asm"

INCLUDE "event/forced_movement.asm"

LandmarkSignGFX:: INCBIN "gfx/frames/landmarksign.2bpp"

SECTION "Code 13", ROMX

INCLUDE "engine/map_triggers.asm"

INCLUDE "engine/copy_tilemap_at_once.asm"

Shrink1Pic: INCBIN "gfx/shrink/shrink1.xbpp.lz"
Shrink2Pic: INCBIN "gfx/shrink/shrink2.xbpp.lz"

INCLUDE "engine/link_display.asm"

Tilesets:: INCLUDE "tilesets/tileset_headers.asm"

INCLUDE "engine/trademon_pic.asm"

INCLUDE "engine/set_caught_data.asm"

INCLUDE "engine/find_pokemon.asm"

INCLUDE "engine/stats_screen.asm"

INCLUDE "engine/evolution_animation.asm"

INCLUDE "event/end_game.asm"

INCLUDE "battle/sliding_intro.asm"

INCLUDE "event/gbc_only.asm"

INCLUDE "engine/pokerus.asm"

INCLUDE "engine/main_menu_debug.asm"

SECTION "Code 14", ROMX

INCLUDE "engine/party_menu.asm"

INCLUDE "engine/pokemon_structs.asm"

INCLUDE "engine/hp_bars.asm"

INCLUDE "engine/print_mon_stats.asm"

INCLUDE "engine/gender.asm"
INCLUDE "engine/show_pokemon_info.asm"
INCLUDE "engine/switch_party_mons.asm"

INCLUDE "engine/events_2.asm"

SECTION "Code 15", ROMX

INCLUDE "engine/menu.asm"
INCLUDE "event/red_credits.asm"

INCLUDE "engine/fish.asm"

INCLUDE "engine/options_menu.asm"

INCLUDE "engine/variables.asm"

INCLUDE "engine/hdma.asm"

INCLUDE "event/spurge_gym.asm"

SECTION "Code 16", ROMX

INCLUDE "event/ballmaking.asm"
INCLUDE "event/happiness_tutor.asm"

INCLUDE "engine/specials.asm"

INCLUDE "engine/vwf.asm"

INCLUDE "engine/math.asm"

SECTION "Code 17", ROMX

INCLUDE "engine/battle_start.asm"

INCLUDE "engine/town_map.asm"

INCLUDE "engine/script_conditionals.asm"

INCLUDE "engine/datetimeset.asm"

SECTION "Code 18", ROMX

INCLUDE "engine/specials_move_tutor.asm"

INCLUDE "battle/bg_effects.asm"

SECTION "Code 19", ROMX

INCLUDE "gfx/pics/animation.asm"
INCLUDE "event/qrcode.asm"
INCLUDE "engine/treasure_bag.asm"

PackFGFX: INCBIN "gfx/pack/pack_f.2bpp"

SECTION "Code 20", ROMX

INCLUDE "event/slot_machine.asm"

INCLUDE "engine/field_moves.asm"
INCLUDE "engine/field_items.asm"

INCLUDE "engine/stable_rng.asm"

SECTION "Code 21", ROMX

INCLUDE "engine/engine_flags.asm"

INCLUDE "engine/printnum.asm"

INCLUDE "gfx/blank_screen.asm"

SECTION "Code 22", ROMX

INCLUDE "battle/anims.asm"

INCLUDE "engine/print_bcd.asm"

SECTION "Code 23", ROMX

INCLUDE "engine/experience.asm"

INCLUDE "engine/pop_mon.asm"

SECTION "Code 24", ROMX

INCLUDE "tilesets/animations.asm"

INCLUDE "event/halloffame.asm"

INCLUDE "engine/compressed_text.asm"

INCLUDE "engine/math16.asm"

SECTION "Code 25", ROMX

INCLUDE "event/card_flip.asm"
INCLUDE "engine/fossil_puzzle.asm"
INCLUDE "event/memory_game.asm"
INCLUDE "engine/billspc.asm"

SECTION "Code 26", ROMX

INCLUDE "engine/move_mon.asm"

INCLUDE "engine/move_player_pic.asm"

INCLUDE "engine/name_player.asm"

INCLUDE "engine/playerpic.asm"

INCLUDE "items/pokeball_wobble.asm"

INCLUDE "engine/time_machine.asm"

SECTION "Code 27", ROMX

INCLUDE "engine/anim_hp_bar.asm"
INCLUDE "event/sacred_ash.asm"

SECTION "Code 28", ROMX

INCLUDE "engine/title.asm"

INCLUDE "engine/credits.asm"

SECTION "Code 29", ROMX

INCLUDE "engine/printer_helpers.asm"

PrinterHPIcon: INCBIN "gfx/printer/hp.1bpp"
PrinterLvIcon: INCBIN "gfx/printer/lv.1bpp"

INCLUDE "engine/diploma.asm"

INCLUDE "event/judge.asm"

QuestionMarkLZ: INCBIN "gfx/pokedex/questionmark.xbpp.lz"

INCLUDE "engine/print_time.asm"

INCLUDE "engine/relative_facing.asm"

INCLUDE "engine/sine.asm"

INCLUDE "data/predefs.asm"

SECTION "Code 30", ROMX

INCLUDE "engine/fade.asm"

INCLUDE "engine/unit_conversion.asm"

SECTION "Code 31", ROMX

INCLUDE "engine/wildmons.asm"

INCLUDE "engine/stopwatch.asm"

INCLUDE "engine/warp_connection.asm"

INCLUDE "engine/pokecenter_pc.asm"

SECTION "Base Data", ROMX
BaseData:: INCLUDE "data/base_stats.asm"
INCLUDE "battle/abilities.asm"
INCLUDE "battle/ability_names.asm"
INCLUDE "battle/pickup.asm"
INCLUDE "engine/breeding.asm"

SECTION "Battle Animation GFX", ROMX
INCLUDE "battle/anim_gfx.asm"

SECTION "Battle Arcade", ROMX
INCLUDE "event/battle_arcade.asm"
INCLUDE "data/battle_arcade.asm"

SECTION "Battle Miscellaneous Functions", ROMX
INCLUDE "battle/misc.asm"

SECTION "Battle Tower code", ROMX
INCLUDE "event/battle_tower.asm"
INCLUDE "text/battle_tower.asm"

SECTION "Battle Tower data", ROMX
INCLUDE "data/battle_tower.asm"

SECTION "Bingo", ROMX
INCLUDE "event/bingo.asm"

SECTION "Card Games", ROMX
INCLUDE "event/cardgames.asm"
INCLUDE "event/poker.asm"
INCLUDE "event/blackjack.asm"

SECTION "Crash", ROMX
INCLUDE "engine/crash_report.asm"
INCLUDE "engine/emulator_check.asm"

SECTION "Daycare", ROMX
INCLUDE "engine/daycare.asm"
INCLUDE "event/daycare.asm"

SECTION "Debug Menu", ROMX
INCLUDE "engine/debug_menu.asm"
INCLUDE "engine/debug_menu_contents.asm"

SECTION "Demo Sine", ROMX
INCLUDE "data/demosine.asm"

SECTION "Evolution", ROMX
INCLUDE "engine/evolve.asm"
INCLUDE "data/evos_attacks_pointers.asm"
INCLUDE "data/evos_attacks.asm"

SECTION "Field Moves", ROMX
INCLUDE "event/field_moves.asm"

SECTION "Font code", ROMX
INCLUDE "engine/font.asm"

SECTION "Gold Tokens", ROMX
INCLUDE "event/gold_tokens.asm"
INCLUDE "engine/token_tracker.asm"

SECTION "Intro Movie", ROMX
INCLUDE "engine/crystal_intro.asm"

SECTION "Item Effects", ROMX
INCLUDE "items/item_effects.asm"
INCLUDE "items/pokeball_effects.asm"
INCLUDE "engine/respawnable_event_mon.asm"

SECTION "Link Helpers", ROMX
INCLUDE "engine/link_helpers.asm"

SECTION "Map Events", ROMX
INCLUDE "engine/events.asm"
INCLUDE "engine/scripting.asm"
INCLUDE "engine/std_scripts.asm"

SECTION "Map Objects", ROMX
INCLUDE "data/facings.asm"
INCLUDE "data/map_objects.asm"
INCLUDE "engine/map_object_action.asm"
INCLUDE "engine/map_objects.asm"
INCLUDE "engine/map_object_movement_pattern.asm"
INCLUDE "engine/movement.asm"
INCLUDE "engine/npc_movement.asm"

SECTION "Marts", ROMX
INCLUDE "engine/mart.asm"
INCLUDE "engine/money.asm"
INCLUDE "event/bank.asm"
INCLUDE "items/marts.asm"

SECTION "Move Animations", ROMX
INCLUDE "battle/anim_objects.asm"
INCLUDE "battle/anim_commands.asm"
INCLUDE "engine/growl_roar_ded_vblank_hook.asm"

SECTION "Name Rater and Time Capsule Conversion", ROMX
INCLUDE "event/name_rater.asm"
INCLUDE "engine/time_capsule_conversion.asm"

SECTION "NPC Trades", ROMX
INCLUDE "engine/npctrade.asm"

SECTION "Nickname Errors", ROMX
INCLUDE "engine/check_nick_errors.asm"

SECTION "Pachisi", ROMX
INCLUDE "event/pachisi.asm"
INCLUDE "data/pachisi.asm"

SECTION "Park Minigame", ROMX
INCLUDE "event/park_minigame.asm"
INCLUDE "data/park_minigame.asm"

SECTION "Player Movement", ROMX
INCLUDE "engine/player_step.asm"
INCLUDE "engine/load_map_part.asm"

SECTION "Repel", ROMX
INCLUDE "engine/repel.asm"

SECTION "RTC code", ROMX
INCLUDE "engine/rtc.asm"

SECTION "Sprites", ROMX
INCLUDE "engine/sprites.asm"
INCLUDE "engine/sprite_anims.asm"
INCLUDE "data/sprite_engine.asm"
INCLUDE "engine/mon_icons.asm"
