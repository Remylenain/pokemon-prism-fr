macro_newline EQUS "\n"

	enum_start

	enum scall_command
MACRO scall
	db scall_command
	dw \1 ; pointer
	ENDM

	enum farscall_command
MACRO farscall
	db farscall_command
	dba \1
	ENDM

	enum ptcall_command
MACRO ptcall
	db ptcall_command
	dw \1 ; pointer
	ENDM

	enum jump_command
MACRO jump
	db jump_command
	dw \1 ; pointer
	ENDM

	enum farjump_command
MACRO farjump
	db farjump_command
	dba \1
	ENDM

	enum ptjump_command
MACRO ptjump
	db ptjump_command
	dw \1 ; pointer
	ENDM

	enum if_equal_command
MACRO if_equal
	db if_equal_command
	db \1 ; byte
	dw \2 ; pointer
	ENDM

	enum if_not_equal_command
MACRO if_not_equal
	db if_not_equal_command
	db \1 ; byte
	dw \2 ; pointer
	ENDM

	enum iffalse_command
MACRO iffalse
	db iffalse_command
	dw \1 ; pointer
	ENDM

	enum iftrue_command
MACRO iftrue
	db iftrue_command
	dw \1 ; pointer
	ENDM

	enum if_greater_than_command
MACRO if_greater_than
	db if_greater_than_command
	db \1 ; byte
	dw \2 ; pointer
	ENDM

	enum if_less_than_command
MACRO if_less_than
	db if_less_than_command
	db \1 ; byte
	dw \2 ; pointer
	ENDM

	enum jumpstd_command
MACRO jumpstd
	db jumpstd_command
	db \1 ; predefined_script
	ENDM

	enum fieldmovepokepic_command
MACRO fieldmovepokepic
	db fieldmovepokepic_command
	ENDM

	enum callasm_command
MACRO callasm
	db callasm_command
	if strcmp("\1", "-1")
		dba \1
	else
		db \1
		dw -1
	endc
	ENDM

	enum special_command
MACRO special
	db special_command
	db (\1Special - SpecialsPointers) / 3
	ENDM

MACRO add_special
\1Special::
	dba \1
ENDM

	enum ptcallasm_command
MACRO ptcallasm
	db ptcallasm_command
	dw \1 ; asm
	ENDM

	enum checkmaptriggers_command
MACRO checkmaptriggers
	db checkmaptriggers_command
	map \1 ; map
	ENDM

	enum domaptrigger_command
MACRO domaptrigger
	db domaptrigger_command
	map \1 ; map
	db \2 ; trigger_id
	ENDM

	enum checktriggers_command
MACRO checktriggers
	db checktriggers_command
	ENDM

	enum dotrigger_command
MACRO dotrigger
	db dotrigger_command
	db \1 ; trigger_id
	ENDM

	enum writebyte_command
MACRO writebyte
	db writebyte_command
	db \1 ; value
	ENDM

	enum addvar_command
MACRO addvar
	db addvar_command
	db \1 ; value
	ENDM

	enum random_command
MACRO random
	db random_command
	IF _NARG == 1
		db \1 ; input
	ELSE
		db 0
	ENDC
	ENDM

	enum readarrayhalfword_command
MACRO readarrayhalfword
	db readarrayhalfword_command
	db \1 ; array entry index
	ENDM

	enum copybytetovar_command
MACRO copybytetovar
	db copybytetovar_command
	dw \1 ; address
	ENDM

	enum copyvartobyte_command
MACRO copyvartobyte
	db copyvartobyte_command
	dw \1 ; address
	ENDM

	enum loadvar_command
MACRO loadvar
	db loadvar_command
	dw \1 ; address
	db \2 ; value
	ENDM

	enum checkcode_command
MACRO checkcode
	db checkcode_command
	db \1 ; variable_id
	ENDM

	enum writevarcode_command
MACRO writevarcode
	db writevarcode_command
	db \1 ; variable_id
	ENDM

	enum writecode_command
MACRO writecode
	db writecode_command
	db \1 ; variable_id
	db \2 ; value
	ENDM

	enum giveitem_command
MACRO giveitem
	db giveitem_command
	db \1 ; item
if _NARG == 2
	db \2 ; quantity
else
	db 1
endc
	ENDM

	enum takeitem_command
MACRO takeitem
	db takeitem_command
	db \1 ; item
if _NARG == 2
	db \2 ; quantity
else
	db 1
endc
	ENDM

	enum checkitem_command
MACRO checkitem
	db checkitem_command
	db \1 ; item
	ENDM

	enum givemoney_command
MACRO givemoney
	db givemoney_command
	db \1 ; account
	dt \2 ; money
	ENDM

	enum takemoney_command
MACRO takemoney
	db takemoney_command
	db \1 ; account
	dt \2 ; money
	ENDM

	enum checkmoney_command
MACRO checkmoney
	db checkmoney_command
	db \1 ; account
	dt \2 ; money
	ENDM

	enum givecoins_command
MACRO givecoins
	db givecoins_command
	dw \1 ; coins
	ENDM

	enum takecoins_command
MACRO takecoins
	db takecoins_command
	dw \1 ; coins
	ENDM

	enum checkcoins_command
MACRO checkcoins
	db checkcoins_command
	dw \1 ; coins
	ENDM

	enum writehalfword_command
MACRO writehalfword
	db writehalfword_command
	dw \1 ; halfword to store
	ENDM

	enum pushhalfword_command
MACRO pushhalfword
	db pushhalfword_command
	dw \1 ; halfword to push
	ENDM

	enum pushhalfwordvar_command
MACRO pushhalfwordvar
	db pushhalfwordvar_command
	ENDM

	enum checktime_command
MACRO checktime
	db checktime_command
	db \1 ; time
	ENDM

	enum checkpoke_command
MACRO checkpoke
	db checkpoke_command
	db \1 ; pkmn
	ENDM

	enum givepoke_command
MACRO givepoke
	db givepoke_command
	db \1 ; pokemon
	db \2 ; level
	if _NARG >= 3
	db \3 ; item
	if _NARG >= 4
	db \4 ; trainer
	if \4
	dw \5 ; trainer_name_pointer
	dw \6 ; pkmn_nickname
	endc
	else
	db 0
	endc
	else
	db NO_ITEM, 0
	endc
	ENDM

	enum giveegg_command
MACRO giveegg
	db giveegg_command
	db \1 ; pkmn
	db \2 ; level
	ENDM

	enum copyhalfwordvartovar_command
MACRO copyhalfwordvartovar
	db copyhalfwordvartovar_command
	ENDM

	enum copyvartohalfwordvar_command
MACRO copyvartohalfwordvar
	db copyvartohalfwordvar_command
	ENDM

	enum checkevent_command
MACRO checkevent
	db checkevent_command
	dw \1 ; event_flag
	ENDM

	enum clearevent_command
MACRO clearevent
	db clearevent_command
	dw \1 ; event_flag
	ENDM

	enum setevent_command
MACRO setevent
	db setevent_command
	dw \1 ; event_flag
	ENDM

	enum checkflag_command
MACRO checkflag
	db checkflag_command
	dw \1 ; engine_flag
	ENDM

	enum clearflag_command
MACRO clearflag
	db clearflag_command
	dw \1 ; engine_flag
	ENDM

	enum setflag_command
MACRO setflag
	db setflag_command
	dw \1 ; engine_flag
	ENDM

	enum wildon_command
MACRO wildon
	db wildon_command
	ENDM

	enum wildoff_command
MACRO wildoff
	db wildoff_command
	ENDM

	enum warpmod_command
MACRO warpmod
	db warpmod_command
	db \1 ; warp_id
	map \2 ; map
	ENDM

	enum blackoutmod_command
MACRO blackoutmod
	db blackoutmod_command
	map \1 ; map
	ENDM

	enum warp_command
MACRO warp
	db warp_command
	map \1 ; map
	db \2 ; x
	db \3 ; y
	ENDM

	enum readmoney_command
MACRO readmoney
	db readmoney_command
	db \1 ; account
	db \2 ; memory
	ENDM

	enum readcoins_command
MACRO readcoins
	db readcoins_command
	db \1 ; memory
	ENDM

	enum variablestablerandom_command
MACRO variablestablerandom
	db variablestablerandom_command
	db \1 ; index
	db \2 ; upper bound
	ENDM

	enum pokenamemem_command
MACRO pokenamemem
	db pokenamemem_command
	db \1 ; pokemon
	db \2 ; memory
	ENDM

	enum itemtotext_command
MACRO itemtotext
	db itemtotext_command
	db \1 ; item
	db \2 ; memory
	ENDM

	enum mapnametotext_command
MACRO mapnametotext
	db mapnametotext_command
	db \1 ; memory
	ENDM

	enum trainertotext_command
MACRO trainertotext
	db trainertotext_command
	db \1 ; trainer_id
	db \2 ; trainer_group
	db \3 ; memory
	ENDM

	enum stringtotext_command
MACRO stringtotext
	db stringtotext_command
	dw \1 ; text_pointer
	db \2 ; memory
	ENDM

	enum itemnotify_command
MACRO itemnotify
	db itemnotify_command
	ENDM

	enum pocketisfull_command
MACRO pocketisfull
	db pocketisfull_command
	ENDM

	enum opentext_command
MACRO opentext
	db opentext_command
	ENDM

	enum refreshscreen_command
MACRO refreshscreen
	db refreshscreen_command
	ENDM

	enum closetext_command
MACRO closetext
	db closetext_command
	ENDM

current_cmdwitharrayargs = 0

MACRO cmdwitharrayargs_length
	db .__cmdwitharrayargs\1End - .__cmdwitharrayargs\1
macro_newline
.__cmdwitharrayargs\1
macro_newline
ENDM

MACRO doendcmdwitharrayargslabel
.__cmdwitharrayargs\1End
ENDM

	enum cmdwitharrayargs_command
MACRO cmdwitharrayargs
	db cmdwitharrayargs_command
	IF _NARG == 1
		db \1
	ELSE
		cmdwitharrayargs_length {d:current_cmdwitharrayargs} ; skip offset (for script conditionals)
	ENDC
	ENDM

MACRO endcmdwitharrayargs
	doendcmdwitharrayargslabel {d:current_cmdwitharrayargs}
current_cmdwitharrayargs = current_cmdwitharrayargs + 1
ENDM

MACRO customarraycmd
	db \1_command ; command
	db \2 ; length
; just do a hardcode for now
	if _NARG == 3
		db (\3 - 1)
		db $00
	elif _NARG == 4
		db (\4 - 1) << 2 | (\3 - 1)
		db $00
	elif _NARG == 5
		db (\5 - 1) << 4 | (\4 - 1) << 2 | (\3 - 1)
		db $00
	elif _NARG == 6
		db (\6 - 1) << 6 | (\5 - 1) << 4 | (\4 - 1) << 2 | (\3 - 1)
		db $00
	elif _NARG == 7
		db (\6 - 1) << 6 | (\5 - 1) << 4 | (\4 - 1) << 2 | (\3 - 1)
		db (\7 - 1)
	elif _NARG == 8
		db (\6 - 1) << 6 | (\5 - 1) << 4 | (\4 - 1) << 2 | (\3 - 1)
		db (\8 - 1) << 2 | (\7 - 1)
	elif _NARG == 9
		db (\6 - 1) << 6 | (\5 - 1) << 4 | (\4 - 1) << 2 | (\3 - 1)
		db (\9 - 1) << 4 | (\8 - 1) << 2 | (\7 - 1)
	else
		db (\6 - 1) << 6 | (\5 - 1) << 4 | (\4 - 1) << 2 | (\3 - 1)
		db (\<10> - 1) << 6 | (\9 - 1) << 4 | (\8 - 1) << 2 | (\7 - 1)
	endc
	ENDM

	enum farwritetext_command
MACRO farwritetext
	db farwritetext_command
	if _NARG == 2
		dbw \1, \2
	else
		dba \1
	endc
	ENDM

	enum writetext_command
MACRO writetext
	db writetext_command
	dw \1 ; text_pointer
	ENDM

	enum repeattext_command
MACRO repeattext
	db repeattext_command
	ENDM

	enum yesorno_command
MACRO yesorno
	db yesorno_command
	ENDM

	enum loadmenudata_command
MACRO loadmenudata
	db loadmenudata_command
	dw \1 ; data
	ENDM

	enum closewindow_command
MACRO closewindow
	db closewindow_command
	ENDM

	enum jumptextfaceplayer_command
MACRO jumptextfaceplayer
	db jumptextfaceplayer_command
	dw \1 ; text_pointer
	ENDM

	enum farjumptext_command
MACRO farjumptext
	db farjumptext_command
	if strcmp("\1", "-1")
		dba \1
	else
		db \1
		dw -1
	endc
	ENDM

	enum jumptext_command
MACRO jumptext
	db jumptext_command
	dw \1 ; text_pointer
	ENDM

	enum waitbutton_command
MACRO waitbutton
	db waitbutton_command
	ENDM

	enum buttonsound_command
MACRO buttonsound
	db buttonsound_command
	ENDM

	enum pokepic_command
MACRO pokepic
	db pokepic_command
	db \1 ; pokemon
	ENDM

	enum closepokepic_command
MACRO closepokepic
	db closepokepic_command
	ENDM

	enum eventvarop_command
MACRO readeventvar
	db eventvarop_command
	db (\1) & $3f
	ENDM
MACRO writeeventvar
	db eventvarop_command
	db ((\1) & $3f) | $40
	ENDM
MACRO addeventvar
	db eventvarop_command
	db ((\1) & $3f) | $80
	ENDM
MACRO compareeventvar
	db eventvarop_command
	db ((\1) & $3f) | $c0
	ENDM

	enum verticalmenu_command
MACRO verticalmenu
	db verticalmenu_command
	ENDM

	enum scrollingmenu_command
MACRO scrollingmenu
	db scrollingmenu_command
	db \1 ; flags
	ENDM

	enum randomwildmon_command
MACRO randomwildmon
	db randomwildmon_command
	ENDM

	enum loadmemtrainer_command
MACRO loadmemtrainer
	db loadmemtrainer_command
	ENDM

	enum loadwildmon_command
MACRO loadwildmon
	db loadwildmon_command
	if _NARG == 2
		db \1 ; pokemon
		db \2 ; level
	elif _NARG > 2
		db \1 ; pokemon
		db \2 | $80 ; level, additional data flag
		db \3 ; item
		if _NARG > 3
			db \4 ; move 1
		else
			db $00
		endc
		if _NARG > 4
			db \5 ; move 2
		else
			db $00
		endc
		if _NARG > 5
			db \6 ; move 3
		else
			db $00
		endc
		if _NARG > 6
			db \7 ; move 4
		else
			db $00
		endc
	endc
	ENDM

	enum loadtrainer_command
MACRO loadtrainer
	db loadtrainer_command
	db \1 ; trainer_group
	db \2 ; trainer_id
	ENDM

	enum startbattle_command
MACRO startbattle
	db startbattle_command
	ENDM

	enum reloadmapafterbattle_command
MACRO reloadmapafterbattle
	db reloadmapafterbattle_command
	ENDM

	enum addhalfwordtovar_command
MACRO addhalfwordtovar
	db addhalfwordtovar_command
	dw \1
	ENDM

	enum trainertext_command
MACRO trainertext
	db trainertext_command
	db \1 ; which_text
	ENDM

	enum trainerflagaction_command
MACRO trainerflagaction
	db trainerflagaction_command
	db \1 ; action
	ENDM

	enum winlosstext_command
MACRO winlosstext
	db winlosstext_command
	dw \1 ; win_text_pointer
	dw \2 ; loss_text_pointer
	ENDM

	enum scripttalkafter_command
MACRO scripttalkafter
	db scripttalkafter_command
	ENDM

	enum end_if_just_battled_command
MACRO end_if_just_battled
	db end_if_just_battled_command
	ENDM

	enum check_just_battled_command
MACRO check_just_battled
	db check_just_battled_command
	ENDM

	enum setlasttalked_command
MACRO setlasttalked
	db setlasttalked_command
	db \1 ; person
	ENDM

	enum applymovement_command
MACRO applymovement
	db applymovement_command
	db \1 ; person
	dw \2 ; data
	ENDM

	enum applymovement2_command
MACRO applymovement2
	db applymovement2_command
	dw \1 ; data
	ENDM

	enum faceplayer_command
MACRO faceplayer
	db faceplayer_command
	ENDM

	enum faceperson_command
MACRO faceperson
	db faceperson_command
	db \1 ; person1
	db \2 ; person2
	ENDM

	enum variablesprite_command
MACRO variablesprite
	db variablesprite_command
	db \1 - SPRITE_VARS ; byte
	db \2 ; sprite
	ENDM

	enum disappear_command
MACRO disappear
	db disappear_command
	db \1 ; person
	ENDM

	enum appear_command
MACRO appear
	db appear_command
	db \1 ; person
	ENDM

	enum follow_command
MACRO follow
	db follow_command
	db \1 ; person2
	db \2 ; person1
	ENDM

	enum stopfollow_command
MACRO stopfollow
	db stopfollow_command
	ENDM

	enum moveperson_command
MACRO moveperson
	db moveperson_command
	db \1 ; person
	db \2 ; x
	db \3 ; y
	ENDM

	enum writepersonxy_command
MACRO writepersonxy
	db writepersonxy_command
	db \1 ; person
	ENDM

	enum loademote_command
MACRO loademote
	db loademote_command
	db \1 ; bubble
	ENDM

	enum showemote_command
MACRO showemote
	db showemote_command
	db \1 ; bubble
	db \2 ; person
	db \3 ; time
IF _NARG >= 4
	db \4 ; flag
ELSE
	db 1
ENDC
	ENDM

	enum spriteface_command
MACRO spriteface
	db spriteface_command
	db \1 ; person
	db \2 ; facing
	ENDM

	enum follownotexact_command
MACRO follownotexact
	db follownotexact_command
	db \1 ; person2
	db \2 ; person1
	ENDM

	enum earthquake_command
MACRO earthquake
	db earthquake_command
	db \1 ; param
	ENDM

	enum changemap_command
MACRO changemap
	db changemap_command
	db BANK(\1) ; map_bank
	dw \1 ; map_data_pointer
	ENDM

	enum changeblock_command
MACRO changeblock
	db changeblock_command
	db \1 ; x
	db \2 ; y
	db \3 ; block
	ENDM

	enum reloadmap_command
MACRO reloadmap
	db reloadmap_command
	ENDM

	enum reloadmappart_command
MACRO reloadmappart
	db reloadmappart_command
	ENDM

	enum writecmdqueue_command
MACRO writecmdqueue
	db writecmdqueue_command
	dw \1 ; queue_pointer
	ENDM

	enum delcmdqueue_command
MACRO delcmdqueue
	db delcmdqueue_command
	db \1 ; byte
	ENDM

	enum playmusic_command
MACRO playmusic
	db playmusic_command
	dw \1 ; music_pointer
	ENDM

	enum encountermusic_command
MACRO encountermusic
	db encountermusic_command
	ENDM

	enum musicfadeout_command
MACRO musicfadeout
	db musicfadeout_command
	dw \1 ; music
	db \2 ; fadetime
	ENDM

	enum playmapmusic_command
MACRO playmapmusic
	db playmapmusic_command
	ENDM

	enum dontrestartmapmusic_command
MACRO dontrestartmapmusic
	db dontrestartmapmusic_command
	ENDM

	enum cry_command
MACRO cry
	db cry_command
	db \1 ; cry_id
	ENDM

	enum playsound_command
MACRO playsound
	db playsound_command
	dw \1 ; sound_pointer
	ENDM

	enum waitsfx_command
MACRO waitsfx
	db waitsfx_command
	ENDM

	enum warpsound_command
MACRO warpsound
	db warpsound_command
	ENDM

	enum copyvarbytetovar_command
MACRO copyvarbytetovar
	db copyvarbytetovar_command
	ENDM

	enum newloadmap_command
MACRO newloadmap
	db newloadmap_command
	db \1 ; which_method
	ENDM

	enum pause_command
MACRO pause
	db pause_command
	db \1 ; length
	ENDM

	enum deactivatefacing_command
MACRO deactivatefacing
	db deactivatefacing_command
	db \1 ; time
	ENDM

	enum priorityjump_command
MACRO priorityjump
	db priorityjump_command
	dw \1 ; pointer
	ENDM

	enum warpcheck_command
MACRO warpcheck
	db warpcheck_command
	ENDM

	enum ptpriorityjump_command
MACRO ptpriorityjump
	db ptpriorityjump_command
	dw \1 ; pointer
	ENDM

	enum return_command
MACRO return
	db return_command
	ENDM

	enum end_command
MACRO end
	db end_command
	ENDM

	enum reloadandreturn_command
MACRO reloadandreturn
	db reloadandreturn_command
	db \1 ; which_method
	ENDM

	enum end_all_command
MACRO end_all
	db end_all_command
	ENDM

	enum pokemart_command
MACRO pokemart
	db pokemart_command
	db \1 ; dialog_id
	db \2 ; mart_id
	ENDM

	enum elevator_command
MACRO elevator
	db elevator_command
	dw \1 ; floor_list_pointer
	ENDM

	enum scriptstartasmf_command
MACRO scriptstartasmf
	db scriptstartasmf_command
	ENDM

	enum pophalfwordvar_command
MACRO pophalfwordvar
	db pophalfwordvar_command
	ENDM

	enum skip
	enum skip

	enum pushbyte_command
MACRO pushbyte
	db pushbyte_command
	db \1 ; byte
	ENDM

	enum fruittree_command
MACRO fruittree
	db fruittree_command
	db \1 ; tree_id
	ENDM

	enum swapbyte_command
MACRO swapbyte
	db swapbyte_command
	db \1 ; byte
	ENDM

	enum loadarray_command
MACRO loadarray
	db loadarray_command
	dw \1 ; array pointer
	if _NARG == 2
		db \2 ; array size
	else
		db \1EntrySizeEnd - \1
	endc
	ENDM

	enum verbosegiveitem_command
MACRO verbosegiveitem
	db verbosegiveitem_command
	db \1 ; item
if _NARG == 2
	db \2 ; quantity
else
	db 1
endc
	ENDM

	enum verbosegiveitem2_command
MACRO verbosegiveitem2
	db verbosegiveitem2_command
	db \1 ; item
	db \2 ; var
	ENDM

	enum swarm_command
MACRO swarm
	db swarm_command
	db \1 ; flag
	map \2 ; map
	ENDM

	enum killsfx_command
MACRO killsfx
	db killsfx_command
	ENDM

	enum checkiteminbox_command
MACRO checkiteminbox
	db checkiteminbox_command
	db \1
	ENDM

	enum warpfacing_command
MACRO warpfacing
	db warpfacing_command
	db \1 ; facing
	map \2 ; map
	db \3 ; x
	db \4 ; y
	ENDM

	enum battletowertext_command
MACRO battletowertext
	db battletowertext_command
	db \1 ; memory
	ENDM

	enum landmarktotext_command
MACRO landmarktotext
	db landmarktotext_command
	db \1 ; id
	db \2 ; memory
	ENDM

	enum trainerclassname_command
MACRO trainerclassname
	db trainerclassname_command
	db \1 ; id
	db \2 ; memory
	ENDM

	enum name_command
MACRO name
	db name_command
	db \1 ; type
	db \2 ; id
	db \3 ; memory
	ENDM

	enum wait_command
MACRO wait
	db wait_command
	db \1 ; duration
	ENDM

	enum loadscrollingmenudata_command
MACRO loadscrollingmenudata
	db loadscrollingmenudata_command
	dw \1
	ENDM

;Prism Custom
	enum backupcustchar_command
MACRO backupcustchar
	db backupcustchar_command
	ENDM

	enum restorecustchar_command
MACRO restorecustchar
	db restorecustchar_command
	ENDM

	enum addhalfwordvartovar_command
MACRO addhalfwordvartovar
	db addhalfwordvartovar_command
	ENDM

	enum addhalfwordtohalfwordvar_command
MACRO addhalfwordtohalfwordvar
	db addhalfwordtohalfwordvar_command
	dw \1
	ENDM

	enum givecraftingEXP_command
MACRO givecraftingEXP
	db givecraftingEXP_command
	db \1
	ENDM

	enum copybytetohalfwordvar_command
MACRO copybytetohalfwordvar
	db copybytetohalfwordvar_command
	dw \1
	ENDM

	enum givetm_command
MACRO givetm
	db givetm_command
	db \1 ; TM
	ENDM

	enum skip

	enum itemplural_command
MACRO itemplural
	db itemplural_command
	db \1 ; string buffer
	ENDM

	enum pullvar_command
MACRO pullvar
	db pullvar_command
	ENDM

	enum setplayersprite_command
MACRO setplayersprite
	db setplayersprite_command
	db \1 ; character model index (0-5)
	ENDM

	enum setplayercolor_command
MACRO setplayercolor
	db setplayercolor_command
	db \1
if \1 == 0
	RGB \2, \3, \4 ; clothes
	db \5 ; race
endc
	ENDM

	enum loadsignpost_command
MACRO loadsignpost
	db loadsignpost_command
	IF _NARG == 2
		dw AddSignpostHeader
	ELSE
		dw \1
	endc
	ENDM

MACRO signpostheader
	if \1 == 0
		db \1
	elif \1 >= TX_COMPRESSED
		db \1 + 1
	else
		db \1
	endc
	ENDM

	enum checkpokemontype_command ;Check if the selected Pokemon is part type or has a move of the type.
MACRO checkpokemontype
	db checkpokemontype_command
	db \1 ;type
	ENDM

	enum isinarray_command
MACRO isinarray
	db isinarray_command
	dw \1 ; pointer to bytes to compare against
	dw \2 ; pointer to array
	dn \3, \4 ; bytes to compare, skip amount
	db \5 ; number of entries in array
	ENDM

	enum pusharray_command
MACRO pusharray
	db pusharray_command
	ENDM

	enum poparray_command
MACRO poparray
	db poparray_command
	ENDM

	enum startmirrorbattle_command
MACRO startmirrorbattle
	db startmirrorbattle_command
	ENDM

	enum comparevartobyte_command
MACRO comparevartobyte
	db comparevartobyte_command
	dw \1
	ENDM

	enum backupsecondpokemon_command
MACRO backupsecondpokemon
	db backupsecondpokemon_command
	ENDM

	enum restoresecondpokemon_command
MACRO restoresecondpokemon
	db restoresecondpokemon_command
	ENDM

	enum loadhalfwordvar_command
MACRO loadhalfwordvar
	db loadhalfwordvar_command
	db \1
	ENDM

	enum pullhalfwordvar_command
MACRO pullhalfwordvar
	db pullhalfwordvar_command
	ENDM

	enum divideby_command
MACRO divideby
	db divideby_command
	db \1
	ENDM

	enum isinsingulararray_command
MACRO isinsingulararray
	db isinsingulararray_command
	dw \1
	ENDM

	enum getnthstring_command
MACRO getnthstring
	db getnthstring_command
	dw \1
	db \2
	ENDM

	enum readpersonxy_command
MACRO readpersonxy
	db readpersonxy_command
	db \1 ; object to read
	dw \2 ; pointer to storage
	ENDM

	enum return_if_callback_else_end_command
MACRO return_if_callback_else_end
	db return_if_callback_else_end_command
	ENDM

current_copycmd = 0

MACRO copycmd_length
	db .__copycmd\1End - .__copycmd\1
macro_newline
.__copycmd\1
macro_newline
ENDM

MACRO doendcopycmdlabel
.__copycmd\1End
ENDM

	enum copy_command
MACRO copy
	db copy_command
	dw \1
	IF _NARG == 2
		db \1
	ELSE
		copycmd_length {d:current_copycmd} ; length
	ENDC
	ENDM

MACRO endcopy
	doendcopycmdlabel {d:current_copycmd}
current_copycmd = current_copycmd + 1
ENDM

	enum switch_command
MACRO switch
	db switch_command
	db \1
	ENDM

	enum multiplyvar_command
MACRO multiplyvar
	db multiplyvar_command
	db \1
	ENDM

	enum seteventvar_command
MACRO seteventvar
	if (((\2) < -1) || ((\2) > 2)) && ((\2) != $ff)
		fail "Invalid argument to seteventvar; only values of -1, 0, 1 or 2 are permitted."
	endc
	db seteventvar_command
	db (((\2) & 3) << 6) | ((\1) & $3f)
	ENDM

	enum callasmf_command
MACRO callasmf
	db callasmf_command
	if strcmp("\1", "-1")
		dba \1
	else
		db \1
		dw -1
	endc
	ENDM

	enum jumptable_command
MACRO scriptjumptable
	db jumptable_command
	dw \1
	ENDM

	enum anonjumptable_command
MACRO anonjumptable
	db anonjumptable_command
	ENDM

	enum varblocks_command
MACRO varblocks
	db varblocks_command
	dw \1
	ENDM

	enum addbytetovar_command
MACRO addbytetovar
	db addbytetovar_command
	dw \1
	ENDM

	enum paragraphdelay_command
MACRO paragraphdelay
	db paragraphdelay_command
	ENDM

	enum playwaitsfx_command
MACRO playwaitsfx
	db playwaitsfx_command
	dw \1
	ENDM

	enum scriptstartasm_command
MACRO scriptstartasm
	db scriptstartasm_command
	ENDM

MACRO scriptstopasm
	; This is not a command; this simply closes a scriptstartasm so that the script continues right after this macro
	call ScriptStopASM
	ENDM

	enum copystring_command
MACRO copystring
	db copystring_command
	db \1
	ENDM

	enum endtext_command
MACRO endtext
	db endtext_command
	ENDM

	enum pushvar_command
MACRO pushvar
	db pushvar_command
	ENDM

	enum popvar_command
MACRO popvar
	db popvar_command
	ENDM

	enum swapvar_command
MACRO swapvar
	db swapvar_command
	ENDM

	enum getweekday_command
MACRO getweekday
	db getweekday_command
	ENDM

	enum toggle_command
MACRO toggle
	db toggle_command
	dw \1 ; event flag
	if _NARG == 1
		dw 0, 0
	else
		dw \2 ; iffalse
		if _NARG > 2
			shift
		endc
		dw \2 ; iftrue
	endc
	ENDM

	enum skip

then_command EQU scriptstartasm_command ;we can't use scriptstartasm with conditionals, so...

	enum selse_command
MACRO selse
	db selse_command
	ENDM

	enum sendif_command
MACRO sendif
	db sendif_command
	ENDM

	enum siffalse_command
	enum siftrue_command
	enum sifgt_command
	enum siflt_command
	enum sifeq_command
	enum sifne_command
MACRO sif
parameterized_if_command = 1
if_parameter_offset = 0
if !strcmp("\1", "=") || !strcmp("\1", "==")
	db sifeq_command
elif !strcmp("\1", "!=") || !strcmp("\1", "<>")
	db sifne_command
elif !strcmp("\1", ">")
	db sifgt_command
elif !strcmp("\1", "<")
	db siflt_command
elif !strcmp("\1", ">=")
if_parameter_offset = -1
	db sifgt_command
elif !strcmp("\1", "<=")
if_parameter_offset = 1
	db siflt_command
elif !strcmp("\1", "true")
parameterized_if_command = 0
	db siftrue_command
elif !strcmp("\1", "false")
parameterized_if_command = 0
	db siffalse_command
else
	fail "Invalid condition to sif"
endc
if parameterized_if_command
	db (\2) + if_parameter_offset
	if _NARG == 3
		if !strcmp("\3", "then")
			db then_command
		endc
	endc
elif _NARG == 2
	if !strcmp("\2", "then")
		db then_command
	endc
endc
	ENDM

	enum readarray_command
MACRO readarray
	db readarray_command
	db \1 ; index within array
	ENDM

	enum givetmnomessage_command
MACRO givetmnomessage
	db givetmnomessage_command
	db \1
	ENDM

	enum findpokemontype_command
MACRO findpokemontype
	db findpokemontype_command
	db \1
	ENDM

	enum startpokeonly_command
MACRO startpokeonly
	db startpokeonly_command
	map \1
	db \2
	ENDM

	enum endpokeonly_command
MACRO endpokeonly
	db endpokeonly_command
	map \1
	db \2
	ENDM

	enum fadetomapmusic_command
MACRO fadetomapmusic
	db fadetomapmusic_command
	db \1 ; fade time
	ENDM

	enum menuanonjumptable_command
MACRO menuanonjumptable
	db menuanonjumptable_command
	dw \1
	ENDM

	enum modifyeventvar_command
MACRO inceventvar
	db modifyeventvar_command
	db ((\1) & $3f) | $80
	ENDM

MACRO deceventvar
	db modifyeventvar_command
	db ((\1) & $3f) | $c0
	ENDM

MACRO addtoeventvar
	db modifyeventvar_command
	db ((\1) & $3f) | $40
	db \2
	ENDM

MACRO seteventvartovalue
	db modifyeventvar_command
	db (\1) & $3f
	db \2
	ENDM

	enum showtext_command
MACRO showtext
	db showtext_command
	dw \1
	ENDM

	enum closetextend_command
MACRO closetextend
	db closetextend_command
	ENDM

	enum toggleevent_command
MACRO toggleevent
	db toggleevent_command
	dw \1
	ENDM

	enum getpartymonname_command
MACRO getpartymonname
	db getpartymonname_command
	db \1
	ENDM
