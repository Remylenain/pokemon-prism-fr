	const_def
	const START_MENU_DEX
	const START_MENU_PKMN
	const START_MENU_PACK
	const START_MENU_MAP
	const START_MENU_STATUS
	const START_MENU_SAVE
	const START_MENU_OPTION
	const START_MENU_EXIT
	const START_MENU_TREASURE_BAG

	const_def
	const MENU_EXIT_RETURN
	const MENU_EXIT_ALL
	const MENU_EXIT_FUNCTION
	const MENU_EXIT_SCRIPT_CLOSE_TEXT
	const MENU_EXIT_SCRIPT
	const MENU_EXIT_RETURN_END
	const MENU_EXIT_RETURN_REDRAW

; String constants here have two advantages:
; - If the character they're meant to overwrite changes its charmap, the constant will too
; - They can be used in compressed text, e.g. `nl   DEBUG_FLAG_SET,   ": flag set (1)"`
DEBUG_FLAG_SET       EQUS "\"<9>\""     ; $d7
DEBUG_FLAG_CLEAR     EQUS "\"-\""       ; $e3
DEBUG_CURSOR_DOWN    EQUS "\"▼\""       ; $ee
DEBUG_CURSOR_RIGHT   EQUS "\"▶\""       ; $ed
DEBUG_LEFT_ARROW     EQUS "\"<LEFT>\""  ; $df
DEBUG_RIGHT_ARROW    EQUS "\"<RIGHT>\"" ; $eb
