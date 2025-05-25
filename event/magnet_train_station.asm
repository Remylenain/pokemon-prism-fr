MagnetTrainScript::
	writehalfword MagnetTrainWarpDataArray
	jump MagnetTrainOrMinecartScript

MinecartScript::
	writehalfword MinecartWarpDataArray

MagnetTrainOrMinecartScript::
	writebyte 0
	loadarray -1, 0
	readarrayhalfword 0
	isinarray wMapGroup, -1, 2, 4, 4
	sif =, $ff
		end
	scriptstartasm
	ldh a, [hScriptVar]
	ld [wScriptBuffer], a
	ld b, a
	ld c, 0
	ld hl, wMagnetTrainOrMinecartMenuItems
	ld a, 4
	ld [hli], a
.loop
	ld a, c
	cp b
	jr z, .skip
	ld [hli], a
.skip
	inc a
	ld c, a
	cp 5
	jr c, .loop
	ld [hl], $ff
	xor a
	ld [wWhichIndexSet], a
	scriptstopasm
	opentext
	readarrayhalfword 2
	writetext -1
	readarrayhalfword 4
	loadmenudata -1
	verticalmenu
	closewindow
	sif >, 3
		closetextend
	readarrayhalfword 6
	pushvar
	scall -1
	sif false
		end
	readarrayhalfword 8
	playmusic -1
	pullvar
	comparevartobyte wScriptBuffer ; var = destination, byte = source
	copyvartobyte wScriptBuffer
	readarray 10
	readarrayhalfword 11
	callasm -1, -1
	wait 14
	popvar
	callasm ForceMapMusicRestart
	pusharray
	readarrayhalfword 0
	loadarray -1, 4
	cmdwitharrayargs
	db warp_command, %111, 0, 2, 3
	endcmdwitharrayargs
	poparray
	readarrayhalfword 13
	jump -1

MACRO mapwarpcoords
	map \1
	db \2, \3
ENDM

MagnetTrainWarpDataArray:
	dw .MagnetTrainMapWarpsArray
	dw .magnet_train_greetings_text
	dw .MagnetTrainMenuHeader
	dw .MagnetTrainBeforeWarpCallback
	dw MUSIC_MAGNET_TRAIN
	dba MagnetTrainAnimation
	dw .MagnetTrainAfterWarpCallback

.MagnetTrainMapWarpsArray:
	mapwarpcoords TORENIA_MAGNET_TRAIN, 11, 6
.MagnetTrainMapWarpsArrayEntrySizeEnd:
	mapwarpcoords BOTAN_MAGNET_TRAIN, 11, 6
	mapwarpcoords GOLDENROD_MAGNET_TRAIN, 11, 6
	mapwarpcoords SAFFRON_MAGNET_TRAIN, 11, 6

.MagnetTrainMenuHeader:
	db $40 ; flags
	db 01, 10 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80
	db 0
	dw wMagnetTrainOrMinecartMenuItems
	dw PlaceMenuStrings
	dw .Strings

.Strings:
	db "Naljo@"
	db "Rijon@"
	db "Johto@"
	db "Kanto@"
	db "Cancel@"

.MagnetTrainBeforeWarpCallback:
	sif >, 1, then
		checkitem MAGNET_PASS
		sif false
			jumptext .need_pass_text
	sendif
	writetext .enter_train_text
	closetext
	applymovement 2, .employee_enter_train
	applymovement PLAYER, .player_enter_train
	writebyte 1
	end

.MagnetTrainAfterWarpCallback:
	applymovement 2, .employee_exit_train
	applymovement PLAYER, .player_exit_train
	applymovement 2, .employee_walk_back
	mapnametotext 0
	getnthstring .Strings, 0
	jumptext .arrived_in_city_text

.employee_enter_train
	step_up
	step_up
	step_left
	step_end

.player_enter_train
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

.employee_exit_train
	step_down
	step_left
	step_end

.player_exit_train
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

.employee_walk_back
	step_right
	step_up
	turn_head_down
	step_end

.magnet_train_greetings_text
	ctxt "Greetings!"

	para "Where can we take"
	line "you today?"
	prompt

.enter_train_text
	ctxt "OK, please board"
	line "the Magnet Train."
	sdone

.need_pass_text
	ctxt "You need a Magnet"
	line "Pass to go there."
	done

.arrived_in_city_text
	ctxt "Welcome to"
	line "<STRBF3>,"
	cont "<STRBF1>!"
	done

MinecartWarpDataArray:
	dw .MinecartMapWarpsArray
	dw .MinecartSeemsStableText
	dw .MinecartMenuHeader
	dw .MinecartBeforeWarpCallback
	dw MUSIC_NONE
	dba .TempMinecartAnimation
	dw .MinecartAfterWarpCallback

.MinecartMapWarpsArray:
	mapwarpcoords ACQUA_START, 28, 36
.MinecartMapWarpsArrayEntrySizeEnd:
	mapwarpcoords MOUND_B3F, 8, 58
	mapwarpcoords CLATHRITE_1F, 20, 38
	mapwarpcoords FIRELIGHT_MINECART, 12, 14

.MinecartSeemsStableText:
	ctxt "This mine cart"
	line "seems stable!"
	para "Where do you want"
	line "to go?"
	prompt

.MinecartMenuHeader:
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80
	db 0
	dw wMagnetTrainOrMinecartMenuItems
	dw PlaceMenuStrings
	dw .Strings

.Strings:
	db "Acqua Mines@"
	db "Mound Cave@"
	db "Clathrite Tunnel@"
	db "Firelight Caverns@"
	db "Cancel@"

.MinecartBeforeWarpCallback:
	closetext
	applymovement PLAYER, .player_moves_down
	writebyte 1
	end

.player_moves_down
	step_down
	step_end

.TempMinecartAnimation:
	xor a
	ldh [hMapAnims], a
	call ClearPalettes
	call DelayFrame
	ld de, SFX_BALL_POOF
	call PlaySFX
	ld c, 8
	ld de, SFX_SANDSTORM
.loop
	call PlayWaitSFX
	dec c
	jr nz, .loop
	ld de, SFX_EMBER
	call PlayWaitSFX
	ld de, SFX_STOMP
	jp PlayWaitSFX

.MinecartAfterWarpCallback:
	applymovement PLAYER, .player_moves_up
	end

.player_moves_up
	step_up
	step_end
