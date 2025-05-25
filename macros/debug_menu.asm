MACRO debug_menu ;name, parent, options, default action, load action
	dw \2 ;parent menu, 0 exits
	dw \3 ;options
	if _NARG > 3
		dw \4 ;default action, 0 for none
		if _NARG > 4
			dw \5 ;load action, 0 for none
		else
			dw 0
		endc
	else
		dw 0, 0
	endc
	db \1 ;menu name, will be displayed on the title bar
	db "@"
ENDM

MACRO debug_menu_options
	assert _NARG <= 13, "Too many menu options given"
	rept _NARG
		dw \1
		shift
	endr
	dw 0
ENDM

MACRO debug_option ;name, action, cursors, select
	if _NARG > 1
		dw \2 ;action, 0 for none
		if _NARG > 2
			dw \3 ;cursors, 0 for none
			if _NARG > 3
				dw \4 ;select, 0 for none
			else
				dw 0
			endc
		else
			dw 0, 0
		endc
	else
		dw 0, 0, 0
	endc
	db \1 ;name
	db "@"
ENDM

MACRO debug_exit ;exit mode, exit script
	if _NARG > 2
		lb de, \3, \1
		ld bc, \2
	elif _NARG > 1
		lb de, BANK(\2), \1
		ld bc, \2
	else
		ld de, \1 & $ff
		ld b, d
		ld c, d
	endc
	call DebugMenuExit
ENDM

MACRO debug_exit_jp ;exit mode, exit script
	if _NARG > 2
		lb de, \3, \1
		ld bc, \2
	elif _NARG > 1
		lb de, BANK(\2), \1
		ld bc, \2
	else
		ld de, \1 & $ff
		ld b, d
		ld c, d
	endc
	jp DebugMenuExit
ENDM
