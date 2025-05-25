EnableScriptMode::
	push af
	ld a, SCRIPT_READ
	ld [wScriptMode], a
	pop af
	ret

ScriptEvents::
	ld a, [wScriptBank]
	ld [wInitialScriptBank], a
	ld a, [wScriptPos]
	ld [wInitialScriptPos], a
	ld a, [wScriptPos + 1]
	ld [wInitialScriptPos + 1], a
	call StartScript
.loop
	ld a, [wScriptMode]
	jumptable .modes
	call CheckScript
	jr nz, .loop
	ret

.modes
	dw StopScript
	dw RunScriptCommand
	dw WaitScriptMovement
	dw WaitScript

WaitScript:
	call StopScript

	ld hl, wScriptDelay
	dec [hl]
	ret nz

	callba ReleaseAllMapObjects

	ld a, SCRIPT_READ
	ld [wScriptMode], a
	jp StartScript

WaitScriptMovement:
	call StopScript

	ld hl, wVramState
	bit 7, [hl]
	ret nz

	callba ReleaseAllMapObjects

	ld a, SCRIPT_READ
	ld [wScriptMode], a
	jp StartScript

RunScriptCommand:
	call GetScriptByte
	cp (ScriptCommandTableEnd - ScriptCommandTable) / 2
	jr c, .go
	ldh [hCrashSavedA], a
	ld a, 9
	call Crash
; crash ends here
.go
	jumptable
ScriptCommandTable:
	dw Script_scall ;0
	dw Script_farscall
	dw Script_ptcall
	dw Script_jump
	dw Script_farjump
	dw Script_ptjump
	dw Script_if_equal
	dw Script_if_not_equal
	dw Script_iffalse ;8
	dw Script_iftrue
	dw Script_if_greater_than
	dw Script_if_less_than
	dw Script_jumpstd
	dw Script_fieldmovepokepic
	dw Script_callasm
	dw Script_special
	dw Script_ptcallasm ;10
	dw Script_checkmaptriggers
	dw Script_domaptrigger
	dw Script_checktriggers
	dw Script_dotrigger
	dw Script_writebyte
	dw Script_addvar
	dw Script_random
	dw Script_readarrayhalfword ;18
	dw Script_copybytetovar
	dw Script_copyvartobyte
	dw Script_loadvar
	dw Script_checkcode
	dw Script_writevarcode
	dw Script_writecode
	dw Script_giveitem
	dw Script_takeitem ;20
	dw Script_checkitem
	dw Script_givemoney
	dw Script_takemoney
	dw Script_checkmoney
	dw Script_givecoins
	dw Script_takecoins
	dw Script_checkcoins
	dw Script_writehalfword ;28
	dw Script_pushhalfword
	dw Script_pushhalfwordvar
	dw Script_checktime
	dw Script_checkpoke
	dw Script_givepoke
	dw Script_giveegg
	dw Script_copyhalfwordvartovar
	dw Script_copyvartohalfwordvar ;30
	dw Script_checkevent
	dw Script_clearevent
	dw Script_setevent
	dw Script_checkflag
	dw Script_clearflag
	dw Script_setflag
	dw Script_wildon
	dw Script_wildoff ;38
	dw Script_warpmod
	dw Script_blackoutmod
	dw Script_warp
	dw Script_readmoney
	dw Script_readcoins
	dw Script_variablestablerandom
	dw Script_pokenamemem
	dw Script_itemtotext ;40
	dw Script_mapnametotext
	dw Script_trainertotext
	dw Script_stringtotext
	dw Script_itemnotify
	dw Script_pocketisfull
	dw Script_opentext
	dw Script_refreshscreen
	dw Script_closetext ;48
	dw Script_cmdwitharrayargs
	dw Script_farwritetext
	dw Script_writetext
	dw Script_repeattext
	dw Script_yesorno
	dw Script_loadmenudata
	dw Script_closewindow
	dw Script_jumptextfaceplayer ;50
	dw Script_farjumptext
	dw Script_jumptext
	dw Script_waitbutton
	dw Script_buttonsound
	dw Script_pokepic
	dw Script_closepokepic
	dw Script_eventvarop
	dw Script_verticalmenu ;58
	dw Script_scrollingmenu
	dw Script_randomwildmon
	dw Script_loadmemtrainer
	dw Script_loadwildmon
	dw Script_loadtrainer
	dw Script_startbattle
	dw Script_reloadmapafterbattle
	dw Script_addhalfwordtovar ;60
	dw Script_trainertext
	dw Script_trainerflagaction
	dw Script_winlosstext
	dw Script_scripttalkafter
	dw Script_end_if_just_battled
	dw Script_check_just_battled
	dw Script_setlasttalked
	dw Script_applymovement ;68
	dw Script_applymovement2
	dw Script_faceplayer
	dw Script_faceperson
	dw Script_variablesprite
	dw Script_disappear
	dw Script_appear
	dw Script_follow
	dw Script_stopfollow ;70
	dw Script_moveperson
	dw Script_writepersonxy
	dw Script_loademote
	dw Script_showemote
	dw Script_spriteface
	dw Script_follownotexact
	dw Script_earthquake
	dw Script_changemap ;78
	dw Script_changeblock
	dw Script_reloadmap
	dw Script_reloadmappart
	dw Script_writecmdqueue
	dw Script_delcmdqueue
	dw Script_playmusic
	dw Script_encountermusic
	dw Script_musicfadeout ;80
	dw Script_playmapmusic
	dw Script_dontrestartmapmusic
	dw Script_cry
	dw Script_playsound
	dw Script_waitsfx
	dw Script_warpsound
	dw Script_copyvarbytetovar
	dw Script_newloadmap ;88
	dw Script_pause
	dw Script_deactivatefacing
	dw Script_priorityjump
	dw Script_warpcheck
	dw Script_ptpriorityjump
	dw Script_return
	dw Script_end
	dw Script_reloadandreturn ;90
	dw Script_end_all
	dw Script_pokemart
	dw Script_elevator
	dw Script_scriptstartasmf
	dw Script_pophalfwordvar
	dw GenericDummyFunction
	dw GenericDummyFunction
	dw Script_pushbyte ;98
	dw Script_fruittree
	dw Script_swapbyte
	dw Script_loadarray
	dw Script_verbosegiveitem
	dw Script_verbosegiveitem2
	dw Script_swarm
	dw Script_killsfx
	dw Script_checkiteminbox ;a0
	dw Script_warpfacing
	dw Script_battletowertext
	dw Script_landmarktotext
	dw Script_trainerclassname
	dw Script_name
	dw Script_wait
	dw Script_loadscrollingmenudata
	dw Script_backupcustchar ;a8
	dw Script_restorecustchar
	dw Script_addhalfwordvartovar
	dw Script_addhalfwordtohalfwordvar
	dw Script_givecraftingEXP
	dw Script_copybytetohalfwordvar
	dw Script_giveTM
	dw GenericDummyFunction
	dw Script_itemplural ;b0
	dw Script_pullvar
	dw Script_setplayersprite
	dw Script_setplayercolor
	dw Script_loadsignpost
	dw Script_checkpokemontype
	dw Script_isinarray
	dw Script_pusharray
	dw Script_poparray ;b8
	dw Script_startmirrorbattle
	dw Script_comparevartobyte
	dw Script_backupsecondpokemon
	dw Script_restoresecondpokemon
	dw Script_loadhalfwordvar
	dw Script_pullhalfwordvar
	dw Script_divideby
	dw Script_isinsingulararray ;c0
	dw Script_getnthstring
	dw Script_readpersonxy
	dw Script_return_if_callback_else_end
	dw Script_copy
	dw Script_switch
	dw Script_multiplyvar
	dw Script_seteventvar
	dw Script_callasmf ;c8
	dw Script_scriptjumptable
	dw Script_anonjumptable
	dw Script_varblocks
	dw Script_addbytetovar
	dw Script_paragraphdelay
	dw Script_playwaitsfx
	dw Script_scriptstartasm
	dw Script_copystring ;d0
	dw Script_endtext
	dw Script_pushvar
	dw Script_popvar
	dw Script_swapvar
	dw Script_getweekday
	dw Script_toggle
	dw GenericDummyFunction
	dw Script_selse ;d8
	dw Script_sendif ;does nothing by itself
	dw Script_siffalse
	dw Script_siftrue
	dw Script_sifgt
	dw Script_siflt
	dw Script_sifeq
	dw Script_sifne
	dw Script_readarray ;e0
	dw Script_giveTMnomessage
	dw Script_findpokemontype
	dw Script_startpokeonly
	dw Script_endpokeonly
	dw Script_fadetomapmusic
	dw Script_menuanonjumptable
	dw Script_modifyeventvar
	dw Script_showtext ;e8
	dw Script_closetextend
	dw Script_toggleevent
	dw Script_getpartymonname
ScriptCommandTableEnd:

StartScript:
	ld hl, wScriptFlags
	set SCRIPT_RUNNING, [hl]
	ret

CheckScript:
	ld hl, wScriptFlags
	bit SCRIPT_RUNNING, [hl]
	ret

StopScript:
	ld hl, wScriptFlags
	res SCRIPT_RUNNING, [hl]
	ret

GetScriptByteOrVar:
	; returns the script byte if non-zero, or the script variable otherwise
	call GetScriptByte
	and a
	ret nz
	ldh a, [hScriptVar]
	ret

GetScriptByteOrVar_FF:
	call GetScriptByte
	cp $ff
	ret nz
	ldh a, [hScriptVar]
	ret

Script_callasmf:
	call Script_callasm
	ldh [hScriptVar], a
	ret

Script_callasm:
	call GetScriptByteOrVar_FF
	ld b, a
	call GetScriptHalfwordOrVar_HL
	ld a, b
	jp FarCall_hl

Script_special:
	call GetScriptByte
	ld e, a
	jpba Special

Script_ptcallasm:
	call GetScriptHalfword
	jp FarPointerCall

Script_jumptextfaceplayer:
	ld a, [wScriptBank]
	call LoadScriptTextPointer
	ld b, BANK(JumpTextFacePlayerScript)
	ld hl, JumpTextFacePlayerScript
	jp ScriptJump

Script_jumptext:
	ld a, [wScriptBank]
	call LoadScriptTextPointer
	ld b, BANK(JumpTextScript)
	ld hl, JumpTextScript
	jp ScriptJump

Script_farjumptext:
	call GetScriptByte
	call LoadScriptTextPointer
	ld b, BANK(JumpTextScript)
	ld hl, JumpTextScript
	jp ScriptJump

Script_jumptextnoreopen:
	ld a, [wScriptBank]
	call LoadScriptTextPointer
	ld b, BANK(JumpTextNoReopenScript)
	ld hl, JumpTextNoReopenScript
	jp ScriptJump

LoadScriptTextPointer:
	ld [wScriptTextBank], a
	call GetScriptHalfwordOrVar_HL
	ld a, l
	ld [wScriptTextAddr], a
	ld a, h
	ld [wScriptTextAddr + 1], a
	ret

JumpTextFacePlayerScript:
	faceplayer
JumpTextScript:
	opentext
JumpTextNoReopenScript:
	repeattext
	endtext

Script_writetext:
	call GetScriptHalfwordOrVar_HL
	ld a, [wScriptBank]
	ld b, a
	jp MapTextbox

Script_farwritetext:
	call GetScriptByteOrVar
	ld b, a
	call GetScriptHalfwordOrVar_HL
	jp MapTextbox

Script_repeattext:
	ld hl, wScriptTextBank
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp MapTextbox

Script_buttonsound:
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	call ApplyTilemapInVBlank
	call ButtonSound
	pop af
	ldh [hOAMUpdate], a
	ret

Script_paragraphdelay:
	call ClearSpeechBox
	call UnloadBlinkingCursor
	ld c, 18 ; factors in ApplyTilemap time
	jp DelayFrames

Script_yesorno:
	call YesNoBox
	; a = carry ? FALSE (0) : TRUE (1)
	sbc a
	inc a
	ldh [hScriptVar], a
	ret

Script_closewindow:
	call CloseWindow
	jp UpdateSprites

Script_pokepic:
	call GetScriptByteOrVar
	ld [wCurPartySpecies], a
	ld b, 1
	jpba Pokepic

Script_closepokepic:
	jpba ClosePokepic

Script_verticalmenu:
	ld a, [wScriptBank]
	ld hl, VerticalMenu
	call FarCall_hl
	push af
	ld a, [wMenuFlags]
	bit 2, a
	ld a, [wMenuCursorY]
	jr nz, .variableDataMenu
	ld b, a
	pop af
	ld a, b
	jr nc, .ok
	xor a
.ok
	ldh [hScriptVar], a
	ret
.variableDataMenu
	ld a, [wMenuSelection]
	ldh [hScriptVar], a
	pop af
	ret

Script_battletowertext:
	call SetUpTextBox
	call GetScriptByte
	ld c, a
	jpba BattleTowerText

Script_itemplural:
	ldh a, [hScriptVar]
	dec a
	jp z, GetScriptByte
	call GetScriptStringBuffer
	jr GiveItemCheckPluralMain

Script_verbosegiveitem:
	call Script_giveitem
	call CurItemName
	ld de, wStringBuffer1
	ld a, 1
	call CopyConvertedText
	ld b, BANK(GiveItemScript)
	ld de, GiveItemScript
	jp ScriptCall

GiveItemCheckPlural::
	; returns -1 if more than 1 item
	ld a, [wItemQuantityChangeBuffer]
	cp 2
	ret c
	ld hl, wStringBuffer4
	call GiveItemCheckPluralMain

	ld hl, wStringBuffer4
	ld de, wStringBuffer1
	ld bc, 15
	rst CopyBytes

	ld b, BANK(GiveItemScriptPlural)
	ld hl, GiveItemScriptPlural
	jp ScriptJump

GiveItemCheckPluralBuffer3::
	ld a, [wItemQuantityChangeBuffer]
	cp 2
	ret c
	ld hl, wStringBuffer3
GiveItemCheckPluralMain:
.loop
	ld a, [hli]
	cp "@"
	jr nz, .loop

	dec hl
	dec hl
	push hl

	ld a, [wCurItem]
	ld hl, .pluraledgecases
	ld de, 3
	call IsInArray
	pop de
	jp c, CallLocalPointer_AfterIsInArray

	ld a, [de]
	cp "o"
	jr z, .spluralsuffix
	cp "s"
	jr z, .spluralsuffix
	cp "y"
	jr z, .ypluralsuffix

.normalpluralsuffix
	inc de
	ld hl, .normalpluralsuffixtext
	jr .copy

.spluralsuffix:
	inc de
	ld hl, .spluralsuffixtext
	jr .copy

.guardspec
	ld hl, .guardspecsuffixtext
	jr .copy

.fpluralsuffix:
	ld hl, .fpluralsuffixtext
	jr .copy

.ypluralsuffix:
	ld hl, .ypluralsuffixtext
.copy
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .copy
.nopluralsuffix
	ret

.kegofbeer
	ld l, e
	ld h, d
	ld de, -7
	add hl, de
	ld e, l
	ld d, h
	ld hl, .kegofbeersuffixtext
	jr .copy

.pluraledgecases
	dbw LUCKY_PUNCH,  .spluralsuffix      ; Lucky Punch'es'
	dbw GUARD_SPEC,   .guardspec          ; Guard Spec's'.
	dbw SILVER_LEAF,  .fpluralsuffix      ; Silver Lea'ves'
	dbw GOLD_LEAF,    .fpluralsuffix      ; Gold Lea'ves'
	dbw FRIES,        .nopluralsuffix     ; Fries''
	dbw BLACKGLASSES, .nopluralsuffix     ; BlackGlasses''
	dbw LEFTOVERS,    .nopluralsuffix     ; Leftovers''
	dbw CAGE_KEY,     .normalpluralsuffix ; Cage Key's'
	dbw SACRED_ASH,   .spluralsuffix      ; Sacred Ash'es'
	dbw SAFE_GOGGLES, .nopluralsuffix     ; Safe Goggles''
	dbw LIGHT_CLAY,   .normalpluralsuffix ; Light Clay's'
	dbw KEG_OF_BEER,  .kegofbeer          ; Keg's' of Beer
	db $ff

.ypluralsuffixtext:
	db "i"
.spluralsuffixtext:
	db "e"
.normalpluralsuffixtext:
	db "s@"

.guardspecsuffixtext:
	db "s.@"

.fpluralsuffixtext:
	db "ves@"

.kegofbeersuffixtext:
	db "s of Beer@"

GiveItemScript:
	pushvar
	callasm GiveItemCheckPlural
	popvar
	writetext .text
	sif true, then
		waitsfx
		playwaitsfx SFX_ITEM
		itemnotify
	selse
		buttonsound
		pocketisfull
	sendif
	end

.text
	ctxt "<PLAYER> received"
	line "<STRBF4>."
	done

GiveItemScriptPlural:
	popvar
	writetext .text
	sif true, then
		waitsfx
		playwaitsfx SFX_ITEM
		callasm ItemNotifyFromMem
	selse
		buttonsound
		pocketisfull
	sendif
	end

.text
	ctxt "<PLAYER> received"
	line "@"
	deciram wItemQuantityChangeBuffer, 1, 2
	text " <STRBF4>."
	done

Script_verbosegiveitem2:
	call GetScriptByte
	cp ITEM_FROM_MEM
	jr nz, .ok
	ldh a, [hScriptVar]
.ok
	ld [wCurItem], a
	call GetScriptByte
	call GetVarAction
	ld a, [de]
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	; a = carry ? TRUE : FALSE
	sbc a
	and TRUE
	ldh [hScriptVar], a
	call CurItemName
	ld de, wStringBuffer1
	ld a, 1
	call CopyConvertedText
	ld b, BANK(GiveItemScript)
	ld de, GiveItemScript
	jp ScriptCall

Script_itemnotify:
	call CurItemName
	call GetPocketName
	CheckEngine ENGINE_USE_TREASURE_BAG
	ld b, BANK(PutItemInPocketText)
	ld hl, PutItemInPocketText
	jr z, .gotText
	ld hl, PutItemInPocketText_Pokeonly
.gotText
	jp MapTextbox

ItemNotifyFromMem::
	call GetPocketName
	ld b, BANK(PutItemInPocketText)
	ld hl, PutItemInPocketText
	jp MapTextbox

Script_pocketisfull:
	call GetPocketName
	call CurItemName
	ld b, BANK(PocketIsFullText)
	ld hl, PocketIsFullText
	jp MapTextbox

GetPocketName:
	CheckEngine ENGINE_USE_TREASURE_BAG
	ld de, .TreasureBag
	jr nz, .copyName
	callba CheckItemPocket
	ld a, [wItemAttributeParamBuffer]
	dec a
	ld hl, .Pockets
	and 3
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
.copyName
	ld hl, wStringBuffer3
	jp CopyName2

.Pockets
	dw .Item
	dw .Key
	dw .Ball
	dw .TM

.Item
	db "Item Pocket@"
.Key
	db "Key Pocket@"
.Ball
	db "Ball Pocket@"
.TM
	db "TM Pocket@"
.TreasureBag
	db "Treasure Bag@"

CurItemName:
	ld a, [wCurItem]
	ld [wd265], a
	jp GetItemName

PutItemInPocketText:
	text "<PLAYER>@"
.continue
	ctxt " put the"
	line "<STRBF1> in"
	cont "the <STRBF3>."
	done

PutItemInPocketText_Pokeonly:
	text "<STRBF2>@"
	text_jump PutItemInPocketText.continue

PocketIsFullText:
	ctxt "The <STRBF3>"
	line "is full…"
	prompt

Script_pokemart:
	call Script_faceplayer
	call Script_opentext
	call GetScriptByte
	ld c, a
	call GetScriptByte
	ld e, a
	ld a, [wScriptBank]
	ld b, a
	callba OpenMartDialog
	call Script_closetext
	jp Script_end

Script_elevator:
	xor a
	ldh [hScriptVar], a
	call GetScriptByte
	ld e, a
	call GetScriptByte
	ld d, a
	ld a, [wScriptBank]
	ld b, a
	callba Elevator
	ret c
	ld a, TRUE
	ldh [hScriptVar], a
	ret

Script_fruittree:
	call GetScriptByte
	ld [wCurFruitTree], a
	ld b, BANK(FruitTreeScript)
	ld hl, FruitTreeScript
	jp ScriptJump

Script_swarm:
	call GetScriptByte
	ld c, a
	call GetScriptHalfword
	ld d, l ; intentional
	ld e, h
	jpba StoreSwarmMapIndices

Script_trainertext:
	call GetScriptByte
	ld c, a
	ld b, 0
	ld hl, wSeenTextPointer
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTempTrainerBank]
	ld b, a
	jp MapTextbox

Script_scripttalkafter:
	ld hl, wScriptAfterPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTempTrainerBank]
	ld b, a
	jp ScriptJump

Script_trainerflagaction:
	xor a
	ldh [hScriptVar], a
	ld hl, wTempTrainerEventFlag
	ld e, [hl]
	inc hl
	ld d, [hl]
	call GetScriptByte
	ld b, a
	predef EventFlagAction
	ld a, c
	and a
	ret z
	ld a, TRUE
	ldh [hScriptVar], a
	ret

Script_winlosstext:
	ld hl, wWinTextPointer
	call GetScriptByte
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	ret

Script_end_if_just_battled:
	ld a, [wRunningTrainerBattleScript]
	and a
	ret z
	jp Script_end

Script_check_just_battled:
	ld a, TRUE
	ldh [hScriptVar], a
	ld a, [wRunningTrainerBattleScript]
	and a
	ret nz
	xor a
	ldh [hScriptVar], a
	ret

Script_encountermusic:
	call PushSoundstate
	ld a, [wOtherTrainerClass]
	ld e, a
	jpba PlayTrainerEncounterMusic

Script_playmusic:
	ld de, MUSIC_NONE
	call PlayMusic
	xor a
	ld [wMusicFade], a
	call MaxVolume
	call GetScriptHalfwordOrVar
	jp PlayMusic

Script_fadetomapmusic:
	call GetMapMusic
	ld a, e
	ld [wMusicFadeID], a
	ld [wMapMusic], a
	ld a, d
	jr Script_finish_music_fade

Script_musicfadeout:
	call GetScriptByte
	ld [wMusicFadeID], a
	call GetScriptByte
Script_finish_music_fade:
	ld [wMusicFadeID + 1], a
	call GetScriptByte
	and $7f
	ld [wMusicFade], a
	ret

Script_playsound:
	call GetScriptHalfword_de
	jp PlaySFX

Script_playwaitsfx:
	call GetScriptHalfword_de
	jp PlayWaitSFX

GetScriptHalfword_de:
	push hl
	call GetScriptHalfword
	ld d, h
	ld e, l
	pop hl
	ret

Script_warpsound:
	ld a, [wPlayerStandingTile]
	ld de, SFX_ENTER_DOOR
	cp COLL_DOOR
	jr z, .play
	ld de, SFX_WARP_TO
	cp COLL_WARP_PANEL
	jr z, .play
	ld de, SFX_EXIT_BUILDING
.play
	jp PlaySFX

Script_cry:
	call GetScriptByteOrVar
	jp PlayCry

GetScriptPerson:
	and a
	ret z
	cp LAST_TALKED
	ret z
	cp $ff
	jr z, .useScriptVar
	dec a
	ret
.useScriptVar
	ldh a, [hScriptVar]
	jr GetScriptPerson

Script_setlasttalked:
	call GetScriptByteOrVar ;makes no sense to do setlasttalked 0, so we might as well
	call GetScriptPerson
	ldh [hLastTalked], a
	ret

Script_applymovement:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	ld c, a

ApplyMovement:
	push bc
	ld a, c
	callba SetFlagsForMovement_1
	pop bc

	push bc
	callba SetFlagsForMovement_2
	pop bc

	call GetScriptHalfwordOrVar_HL
	ld a, [wScriptBank]
	ld b, a
	call GetMovementData
	ret c

	ld a, SCRIPT_WAIT_MOVEMENT
	ld [wScriptMode], a
	jp StopScript

Script_applymovement2:
	ldh a, [hLastTalked]
	ld c, a
	jp ApplyMovement

Script_faceplayer:
	ldh a, [hLastTalked]
	and a
	ret z
	ld d, 0
	ldh a, [hLastTalked]
	ld e, a
	callba GetRelativeFacing
	ld a, d
	add a
	add a
	ld e, a
	ldh a, [hLastTalked]
	ld d, a
	jp ApplyPersonFacing

Script_faceperson:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	ld e, a
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	ld d, a
	push de
	callba GetRelativeFacing
	pop bc
	ret c
	ld a, d
	add a
	add a
	ld e, a
	ld d, c
	jp ApplyPersonFacing

Script_spriteface:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	ld d, a
	call GetScriptByte
	add a
	add a
	ld e, a

ApplyPersonFacing:
	ld a, d
	push de
	call CheckObjectVisibility
	jr c, .not_visible
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	push bc
	call DoesSpriteHaveFacings
	pop bc
	jr c, .not_visible ; STILL_SPRITE
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit FIXED_FACING, [hl]
	jr nz, .not_visible
	pop de
	ld a, e
	call SetSpriteDirection
	ld hl, wVramState
	bit 6, [hl]
	jr nz, .done
	call LoadMapPart
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
.loop
	res 7, [hl]
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
.done
	jp UpdateSprites

.not_visible
	pop de
	scf
	ret

Script_variablesprite:
	call GetScriptByte
	ld e, a
	ld d, 0
	ld hl, wVariableSprites
	add hl, de
	call GetScriptByte
	ld [hl], a
	ret

Script_appear:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	call _CopyObjectStruct
	ldh a, [hMapObjectIndexBuffer]
	ld b, RESET_FLAG
	jp ApplyEventActionAppearDisappear

Script_disappear:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	call DeleteObjectStruct
	ldh a, [hMapObjectIndexBuffer]
	ld b, SET_FLAG
	call ApplyEventActionAppearDisappear
	jpba _UpdateSprites

ApplyEventActionAppearDisappear:
	push bc
	call GetMapObject
	ld hl, MAPOBJECT_EVENT_FLAG
	add hl, bc
	pop bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	and d
	inc a
	ret z
	bit 7, d
	jr z, .performFlagAction
	res 7, d
	ld a, b
	xor 1
	ld b, a
.performFlagAction
	predef_jump EventFlagAction

CheckLastTalked:
	cp LAST_TALKED
	ret nz
	ldh a, [hLastTalked]
	ret

Script_follow:
	call GetScriptByte
	call GetScriptPerson
	ld b, a
	call GetScriptByte
	call GetScriptPerson
	ld c, a
	jpba StartFollow

Script_stopfollow:
	jpba StopFollow

Script_moveperson:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	ld b, a
	call GetScriptByte
	add 4
	ld d, a
	call GetScriptByte
	add 4
	ld e, a
	jpba CopyDECoordsToMapObject

Script_readpersonxy:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	ld c, 13
	ld hl, wObjectStructs + OBJECT_MAP_OBJECT_INDEX
	ld de, OBJECT_STRUCT_LENGTH
.loop
	cp [hl]
	jr z, .found
	add hl, de
	dec c
	jr nz, .loop
	lb de, -1, -1
	jr .notFound
.found
	ld de, OBJECT_NEXT_MAP_X - OBJECT_MAP_OBJECT_INDEX
	add hl, de
	ld a, [hli]
	ld e, [hl]
	ld d, a
.notFound
	call GetScriptHalfwordOrVar_HL
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

Script_writepersonxy:
	call GetScriptByte
	call GetScriptPerson
	call CheckLastTalked
	ld b, a
	jpba WritePersonXY

Script_follownotexact:
	call GetScriptByte
	call GetScriptPerson
	ld b, a
	call GetScriptByte
	call GetScriptPerson
	ld c, a
	jpba FollowNotExact

Script_loademote:
	call GetScriptByte
	cp -1
	jr nz, .not_var_emote
	ldh a, [hScriptVar]
.not_var_emote
	ld c, a
	jpba LoadEmote

Script_showemote:
	call Script_writebyte
	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr z, .ok
	ldh [hLastTalked], a
.ok
	call GetScriptByte
	ld [wScriptDelay], a
	call GetScriptByte
	ld [wPlayEmoteSFX], a
	ld b, BANK(ShowEmoteScript)
	ld de, ShowEmoteScript
	jp ScriptCall

ShowEmoteScript:
	loademote EMOTE_MEM
	applymovement2 .Show
	pause 0
	applymovement2 .Hide
	end

.Show
	show_emote
	step_sleep_1
	step_end

.Hide
	hide_emote
	step_sleep_1
	step_end

Script_earthquake:
	ld hl, EarthquakeMovement
	ld de, wd002
	ld bc, EarthquakeMovementEnd - EarthquakeMovement
	rst CopyBytes
	call GetScriptByte
	ld [wd003], a
	and (1 << 6) - 1
	ld [wd005], a
	ld b, BANK(.script)
	ld de, .script
	jp ScriptCall

.script:
	applymovement PLAYER, wd002
	end

EarthquakeMovement:
	step_shake 16 ; the 16 gets overwritten with the script byte
	step_sleep 16 ; the 16 gets overwritten with the lower 6 bits of the script byte
	step_end
EarthquakeMovementEnd:

Script_scrollingmenu:
	call InitScrollingMenu
	call UpdateSprites
	ld a, [wScrollingMenuCursorBuffer]
	ld [wMenuCursorBuffer], a
	ld a, [wScrollingMenuScrollPosition]
	ld [wMenuScrollPosition], a
	ld hl, ScrollingMenu
	ld a, [wScriptBank]
	call FarCall_hl
	ld a, [wMenuScrollPosition]
	ld [wScrollingMenuScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wScrollingMenuCursorBuffer], a
	call GetScriptByte
	bit 0, a ; draw speech box?
	push af
	call nz, SpeechTextBox
	pop bc
	ld a, [wMenuJoypad]
	cp B_BUTTON
	ld a, 0
	jr z, .backedOut
	bit 1, b ; use cursor position or menu selection?
	ld a, [wMenuSelection]
	jr z, .backedOut
	ld a, [wScrollingMenuCursorPosition]
	inc a
.backedOut
	ldh [hScriptVar], a
	ret

Script_randomwildmon:
	xor a
	ld [wBattleScriptFlags], a
	jp PushSoundstate

Script_loadmemtrainer:
	ld a, (1 << 7) | 1
	ld [wBattleScriptFlags], a
	ld a, [wTempTrainerClass]
	ld [wOtherTrainerClass], a
	ld a, [wTempTrainerID]
	ld [wOtherTrainerID], a
	ret

Script_loadwildmon:
	ld a, (1 << 7)
	ld [wBattleScriptFlags], a
	call GetScriptByteOrVar
	ld [wTempWildMonSpecies], a
	call GetScriptByte
	bit 7, a
	res 7, a
	ld [wCurPartyLevel], a
	ret z
	ld hl, wWildMonCustomItem
	ld c, 5
.getScriptByteLoop
	call GetScriptByte
	ld [hli], a
	dec c
	jr nz, .getScriptByteLoop
	ret

Script_loadtrainer:
	ld a, (1 << 7) | 1
	ld [wBattleScriptFlags], a
	call GetScriptByte
	ld [wOtherTrainerClass], a
	call GetScriptByte
	ld [wOtherTrainerID], a
	ret

Script_startmirrorbattle:
	ld hl, wPartyCount
	ld de, wOTPartyCount
	ld bc, wPartyMonNicknamesEnd - wPartyCount
	rst CopyBytes
	callba HealOTParty
	ld hl, wInBattleTowerBattle
	ld a, [hl]
	push af
	set 1, [hl]
	call Script_startbattle
	pop af
	ld [wInBattleTowerBattle], a
	ret

Script_startbattle:
	call BufferScreen
	ld a, [wPartyCount]
	and a
	jr z, .no_pokemon
	predef StartBattle
	ld a, [wBattleResult]
	and $3f
	ldh [hScriptVar], a
	ret

.no_pokemon
	inc a
	ld [wBattleResult], a
	ldh [hScriptVar], a
	ld b, BANK(Script_OverworldWhiteout)
	ld hl, Script_OverworldWhiteout
	jp ScriptJump

Script_reloadmapafterbattle:
	ld hl, wBattleScriptFlags
	ld a, [hl]
	ld [wWhiteOutFlags], a
	ld [hl], 0
	ld a, [wBattleResult]
	and $3f
	cp 1
	jr nz, Script_reloadmap
	ld b, BANK(Script_BattleWhiteout)
	ld hl, Script_BattleWhiteout
	jp ScriptJump

Script_reloadmap:
	xor a
	ld [wBattleScriptFlags], a
	ld a, MAPSETUP_RELOADMAP
	jp WriteMapEntryMethodLoadMapStatusEnterMapAndStopScript

Script_fieldmovepokepic::
	ld b, BANK(FieldMovePokepicScript)
	ld de, FieldMovePokepicScript
	jr ScriptCall

Script_scall:
	ld a, [wScriptBank]
	ld b, a
	call GetScriptHalfwordOrVar
	jr ScriptCall

Script_farscall:
	call GetScriptByte
	ld b, a
	call GetScriptByte
	ld e, a
	call GetScriptByte
	ld d, a
	jr ScriptCall

Script_ptcall:
	call GetScriptHalfword
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
CallCallback::
ScriptCall:
	push de
	ld hl, wScriptStackSize
	ld a, [hl]
	cp 5
	jr nc, .full
	ld e, a
	inc [hl]
	ld d, 0
	ld hl, wScriptStack
	add hl, de
	add hl, de
	add hl, de
	pop de
	ld a, [wScriptBank]
	ld [hli], a
	ld a, [wScriptPos]
	ld [hli], a
	ld a, [wScriptPos + 1]
	ld [hl], a
	ld a, b
	ld [wScriptBank], a
	ld a, e
	ld [wScriptPos], a
	ld a, d
	ld [wScriptPos + 1], a
	and a
	ret

.full
	ldh [hCrashSavedA], a
	ld a, 11
	jp Crash

Script_jump:
	call GetScriptHalfwordOrVar_HL
	jp LocalScriptJump

Script_farjump:
	call GetScriptByte
	ld b, a
	call GetScriptHalfword
	jp ScriptJump

Script_ptjump:
	call GetScriptHalfword
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp ScriptJump

Script_iffalse:
	ldh a, [hScriptVar]
	and a
	jr Script_if_equal.compare

Script_iftrue:
	ldh a, [hScriptVar]
	and a
	jr Script_if_not_equal.compare

Script_if_equal:
	call GetScriptByte
	ld hl, hScriptVar
	cp [hl]
.compare
	jr z, Script_jump
	jr SkipTwoScriptBytes

Script_if_not_equal:
	call GetScriptByte
	ld hl, hScriptVar
	cp [hl]
.compare
	jr nz, Script_jump
	jr SkipTwoScriptBytes

Script_if_greater_than:
	ldh a, [hScriptVar]
	ld b, a
	call GetScriptByte
	cp b
	jr c, Script_jump
	jr SkipTwoScriptBytes

Script_if_less_than:
	call GetScriptByte
	ld b, a
	ldh a, [hScriptVar]
	cp b
	jr c, Script_jump
	jr SkipTwoScriptBytes

Script_jumpstd:
	call StdScript
	jr ScriptJump

StdScript:
	call GetScriptByte
	ld e, a
	ld d, 0
	ld hl, StdScripts
	add hl, de
	add hl, de
	add hl, de
	ld a, BANK(StdScripts)
	call GetFarByteHalfword
	ld b, a
	ret

SkipTwoScriptBytes:
	ld hl, wScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	jr LocalScriptJump

ScriptJump:
	call ScriptJump_StoreCurrentScriptBankPos
	ld a, b
	ld [wScriptBank], a
	jr ScriptJump_common
LocalScriptJump:
	call ScriptJump_StoreCurrentScriptBankPos
ScriptJump_common:
	ld a, [wScriptBank]
	ld [wLastScriptJumpDestBank], a
	ld a, l
	ld [wScriptPos], a
	ld [wLastScriptJumpDestPos], a
	ld a, h
	ld [wScriptPos + 1], a
	ld [wLastScriptJumpDestPos + 1], a
	ret

ScriptJump_StoreCurrentScriptBankPos:
	ld a, [wScriptBank]
	ld [wLastScriptJumpSrcBank], a
	ld a, [wScriptPos]
	ld [wLastScriptJumpSrcPos], a
	ld a, [wScriptPos + 1]
	ld [wLastScriptJumpSrcPos + 1], a
	ret

Script_priorityjump:
	ld a, [wScriptBank]
	ld [wPriorityScriptBank], a
	call GetScriptByte
	ld [wPriorityScriptAddr], a
	call GetScriptByte
	ld [wPriorityScriptAddr + 1], a
	ld hl, wScriptFlags
	set 3, [hl]
	ret

Script_checktriggers:
	call CheckTriggers
	jr nz, .load_trigger
	ld a, $ff
.load_trigger
	ldh [hScriptVar], a
	ret

Script_checkmaptriggers:
	call GetScriptByte
	ld b, a
	call GetScriptByte
	ld c, a
	call GetMapTrigger
	ld a, d
	or e
	jr z, .no_triggers
	ld a, [de]
	jr .load_trigger

.no_triggers
	dec a ; $ff
.load_trigger
	ldh [hScriptVar], a
	ret

Script_dotrigger:
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	jr DoTrigger

Script_domaptrigger:
	call GetScriptByte
	ld b, a
	call GetScriptByte
	ld c, a
DoTrigger:
	call GetMapTrigger
	ld a, d
	or e
	ret z
	call GetScriptByte
	ld [de], a
	ret

Script_copyhalfwordvartovar:
	call GetHalfwordVar
	jr WriteHLToScriptVar

Script_copybytetovar:
	call GetScriptHalfword
WriteHLToScriptVar:
	ld a, [hl]
	ldh [hScriptVar], a
	ret

Script_copyvartohalfwordvar:
	call GetHalfwordVar
	jr WriteScriptVarToHL

Script_copyvartobyte:
	call GetScriptHalfword
WriteScriptVarToHL:
	ldh a, [hScriptVar]
	ld [hl], a
	ret

Script_loadhalfwordvar:
	call GetHalfwordVar
	jr WriteScriptByteToHL

Script_loadvar:
	call GetScriptHalfword
WriteScriptByteToHL:
	call GetScriptByte
	ld [hl], a
	ret

Script_writebyte:
	call GetScriptByte
	ldh [hScriptVar], a
	ret

Script_addvar:
	call GetScriptByte
	ld hl, hScriptVar
	add [hl]
	ld [hl], a
	ret

Script_multiplyvar:
	call GetScriptByte
	ld c, a
	inc a
	ldh a, [hScriptVar]
	jr nz, .not_complement
	cpl
	inc a
	jr .got_byte
.not_complement
	call SimpleMultiply
.got_byte
	ldh [hScriptVar], a
	ret

Script_divideby:
	call GetScriptByte
	ld c, a
	ldh a, [hScriptVar]
	call SimpleDivide
	ld a, b
	ldh [hScriptVar], a
	ret

Script_variablestablerandom:
	call GetScriptByteOrVar_FF
	ld e, a
	ld d, 1
	jr Script_variablestablerandom_EntryPoint

Script_random:
	ld d, 0
Script_variablestablerandom_EntryPoint:
	call GetScriptByte
	and a
	jr z, .noRejectionSampling
	cp $ff
	jr nz, .notFromScriptVar
	ldh a, [hScriptVar]
.notFromScriptVar
	ld b, a
	ld c, $ff
	jr .handleLoop
.loop
	srl c
.handleLoop
	add a
	jr nc, .loop
.rejectionSamplingLoop
	call RandomOrVariableStableRandom
	and c
	cp b
	jr nc, .rejectionSamplingLoop
	ldh [hScriptVar], a
	ret

.noRejectionSampling
	call RandomOrVariableStableRandom
	ldh [hScriptVar], a
	ret

RandomOrVariableStableRandom:
	ld a, d
	and a
	jp z, Random
	jpba VariableStableRandom

Script_checkcode:
	call GetScriptByte
	call GetVarAction
	ld a, [de]
	ldh [hScriptVar], a
	ret

Script_writevarcode:
	call GetScriptByte
	call GetVarAction
	ldh a, [hScriptVar]
	ld [de], a
	ret

Script_writecode:
	call GetScriptByte
	call GetVarAction
	call GetScriptByte
	ld [de], a
	ret

GetVarAction:
	ld c, a
	jpba _GetVarAction

Script_pokenamemem:
	call GetScriptByteOrVar
	ld [wd265], a
	call GetPokemonName
	ld de, wStringBuffer1
ConvertMemToText:
	call GetScriptByte
	cp 3
	jr c, CopyConvertedText
	xor a
CopyConvertedText:
	ld hl, wStringBuffer3
	ld bc, wStringBuffer4 - wStringBuffer3
	rst AddNTimes
	jp CopyName2

Script_itemtotext:
	call GetScriptByteOrVar
	ld [wd265], a
	call GetItemName
	ld de, wStringBuffer1
	jr ConvertMemToText

Script_mapnametotext:
	call GetCurWorldMapLocation

ConvertLandmarkToText:
	ld e, a
	callba GetLandmarkName
	ld de, wStringBuffer1
	jp ConvertMemToText

Script_landmarktotext:
	call GetScriptByte
	jr ConvertLandmarkToText

Script_trainertotext:
	call GetScriptByte
	ld c, a
	call GetScriptByte
	ld b, a
	callba GetTrainerName
	jr ConvertMemToText

Script_name:
	call GetScriptByte
	ld [wNamedObjectTypeBuffer], a

ContinueToGetName:
	call GetScriptByte
	ld [wCurSpecies], a
	call GetName
	ld de, wStringBuffer1
	jp ConvertMemToText

Script_trainerclassname:
	ld a, TRAINER_NAME
	ld [wNamedObjectTypeBuffer], a
	jr ContinueToGetName

Script_readmoney:
	call ResetStringBuffer1
	call GetMoneyAccount
	ld hl, wStringBuffer1
	lb bc, PRINTNUM_LEFTALIGN | 3, 6
	call PrintNum
	ld de, wStringBuffer1
	jp ConvertMemToText

ResetStringBuffer1:
	ld hl, wStringBuffer1
	ld bc, NAME_LENGTH
	ld a, "@"
	jp ByteFill

Script_readcoins:
	call ResetStringBuffer1
	ld hl, wStringBuffer1
	ld de, wCoins
	lb bc, PRINTNUM_LEFTALIGN | 2, 6
	call PrintNum
	ld de, wStringBuffer1
	jp ConvertMemToText

Script_stringtotext:
	call GetScriptHalfword
	ld d, h
	ld e, l
	ld a, [wScriptBank]
	ld hl, CopyName1
	call FarCall_hl
	ld de, wStringBuffer2
	jp ConvertMemToText

Script_giveitem:
	call GetScriptByte
	cp ITEM_FROM_MEM
	jr nz, .ok
	ldh a, [hScriptVar]
.ok
	ld [wCurItem], a
	call GetScriptByte
	ld [wItemQuantityChangeBuffer], a
	ld hl, wNumItems
	call ReceiveItem
	; a = carry ? TRUE : FALSE
	sbc a
	and TRUE
	ldh [hScriptVar], a
	ret

Script_takeitem:
	xor a
	ldh [hScriptVar], a

	call GetScriptByte
	cp ITEM_FROM_MEM
	jr z, .memitem
	ld [wCurItem], a

.memitem
	call GetScriptByteOrVar

	ld [wItemQuantityChangeBuffer], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld hl, wNumItems
	call TossItem
	ret nc
	ld a, TRUE
	ldh [hScriptVar], a
	ret

Script_checkiteminbox:
	ld hl, wPCItems
	jr Script_checkiteminbox_EntryPoint

Script_checkitem:
	ld hl, wNumItems
Script_checkiteminbox_EntryPoint:
	call GetScriptByteOrVar
	ld [wCurItem], a
	call CheckItem
	sbc a
	and 1
	ldh [hScriptVar], a
	ret

Script_givemoney:
	call GetMoneyAccount
	call LoadMoneyAmountToMem
	jpba GiveMoney

Script_takemoney:
	call GetMoneyAccount
	call LoadMoneyAmountToMem
	jpba TakeMoney

Script_checkmoney:
	call GetMoneyAccount
	call LoadMoneyAmountToMem
	callba CompareMoney
CompareMoneyAction:
	jr z, .one
	sbc a
	and 2
.done
	ldh [hScriptVar], a
	ret
.one
	ld a, 1
	jr .done

GetMoneyAccount:
	call GetScriptByte
	and a
	ld de, wMoney
	ret z
	ld de, wBankMoney
	ret

LoadMoneyAmountToMem:
	ld bc, hMoneyTemp
	push bc
	call GetScriptByte
	ld [bc], a
	inc bc
	call GetScriptByte
	ld [bc], a
	inc bc
	call GetScriptByte
	ld [bc], a
	pop bc
	ret

Script_givecoins:
	call LoadCoinAmountToMem
	jpba GiveCoins

Script_takecoins:
	call LoadCoinAmountToMem
	jpba TakeCoins

Script_checkcoins:
	call LoadCoinAmountToMem
	callba CheckCoins
	jr CompareMoneyAction

LoadCoinAmountToMem:
	call GetScriptHalfwordOrVar
	ld a, e
	ldh [hMoneyTemp + 1], a
	ld a, d
	ldh [hMoneyTemp], a
	ld bc, hMoneyTemp
	ret

Script_checktime:
	ld a, [wTimeOfDay]
	ld b, a
	inc b
	call GetScriptByte
	rlca
.loop
	rrca
	dec b
	jr nz, .loop
	and 1
	ldh [hScriptVar], a
	ret

Script_checkpoke:
	xor a
	ldh [hScriptVar], a
	call GetScriptByte
	ld hl, wPartySpecies
	call IsInSingularArray
	ret nc
	ld a, TRUE
	ldh [hScriptVar], a
	ret

Script_addhalfwordtohalfwordvar:
	call GetHalfwordVar
	call GetScriptHalfword_de
	add hl, de
	ld d, h
	ld e, l
	jr WriteDEToScriptHalfword

Script_writehalfword:
	call GetScriptHalfword_de
WriteDEToScriptHalfword:
	ld hl, hScriptHalfwordVar
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

Script_givepoke:
	call GetScriptByteOrVar
	ld [wCurPartySpecies], a
	call GetScriptByte
	ld [wCurPartyLevel], a
	call GetScriptByte
	ld [wCurItem], a
	call GetScriptByte
	and a
	ld b, a
	jr z, .ok
	ld hl, wScriptPos
	ld e, [hl]
	inc hl
	ld d, [hl]
	call GetScriptByte
	call GetScriptByte
	call GetScriptByte
	call GetScriptByte
.ok
	callba GivePoke
	ld a, b
	ldh [hScriptVar], a
	ret

Script_giveegg:
	; if no room in the party, return 0 in hScriptVar; else, return 2
	assert PARTYMON == 0
	xor a
	ld [wMonType], a
	call GetScriptByte
	ld [wCurPartySpecies], a
	call GetScriptByte
	ld [wCurPartyLevel], a
	callba GiveEgg
	sbc a
	and 2
	ldh [hScriptVar], a
	ret

Script_setevent:
	call GetScriptHalfwordOrVar
	ld b, SET_FLAG
	predef_jump EventFlagAction

Script_clearevent:
	call GetScriptHalfwordOrVar
	ld b, RESET_FLAG
	predef_jump EventFlagAction

Script_toggleevent:
	call GetScriptHalfwordOrVar
	push de
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop de
	ld b, RESET_FLAG
	ld a, c
	and a
	jr nz, .go
	inc b ; SET_FLAG
.go
	predef_jump EventFlagAction

Script_checkevent:
	call GetScriptHalfwordOrVar
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld a, c
	and a
	jr z, .false
	ld a, TRUE
.false
	ldh [hScriptVar], a
	ret

GetScriptHalfwordOrVar_HL:
	push de
	call GetScriptHalfwordOrVar
	ld h, d
	ld l, e
	pop de
	ret

GetScriptHalfwordOrVar:
	; use hScriptHalfwordVar if $ffff, otherwise use halfword arg
	call GetScriptHalfword_de
	ld a, d
	and e
	inc a
	ret nz
	ldh a, [hScriptHalfwordVar]
	ld e, a
	ldh a, [hScriptHalfwordVar + 1]
	ld d, a
	ret

Script_setflag:
	call GetScriptHalfword_de
	ld b, SET_FLAG
_EngineFlagAction:
	jpba EngineFlagAction

Script_clearflag:
	call GetScriptHalfword_de
	ld b, RESET_FLAG
	jr _EngineFlagAction

Script_checkflag:
	call GetScriptHalfword_de
	ld b, CHECK_FLAG
	call _EngineFlagAction
	ld a, c
	and a
	jr z, .false
	ld a, TRUE
.false
	ldh [hScriptVar], a
	ret

Script_wildoff:
	ld hl, wStatusFlags
	set 5, [hl]
	ret

Script_wildon:
	ld hl, wStatusFlags
	res 5, [hl]
	ret

Script_warpfacing:
	call GetScriptByte
	and 3
	ld c, a
	ld a, [wPlayerSpriteSetupFlags]
	set 5, a
	or c
	ld [wPlayerSpriteSetupFlags], a
Script_warp:
	call GetScriptByte
	and a
	jr z, .not_ok
	ld [wMapGroup], a
	call GetScriptByte
	ld [wMapNumber], a
	call GetScriptByte
	ld [wXCoord], a
	call GetScriptByte
	ld [wYCoord], a
	ld a, -1
	ld [wd001], a
	ld a, [wMapGroup]
	cp GROUP_BATTLE_TOWER_HALLWAY
	ld a, MAPSETUP_BATTLE_TOWER
	jr z, .got_method
	ld a, MAPSETUP_WARP
	jr .got_method

.not_ok
	call GetScriptByte
	call GetScriptByte
	call GetScriptByte
	ld a, -1
	ld [wd001], a
	ld a, MAPSETUP_BADWARP
.got_method
	jp WriteMapEntryMethodLoadMapStatusEnterMapAndStopScript

Script_warpmod:
	call GetScriptByte
	cp $ff
	jr nz, .doNotUseScriptVar
	ldh a, [hScriptVar]
.doNotUseScriptVar
	ld [wBackupWarpNumber], a
	call GetScriptByte
	ld [wBackupMapGroup], a
	call GetScriptByte
	ld [wBackupMapNumber], a
	ret

Script_blackoutmod:
	call GetScriptByte
	ld [wLastSpawnMapGroup], a
	call GetScriptByte
	ld [wLastSpawnMapNumber], a
	ret

Script_dontrestartmapmusic:
	ld a, 1
	ld [wDontPlayMapMusicOnReload], a
	ret

Script_writecmdqueue:
	call GetScriptByte
	ld e, a
	call GetScriptByte
	ld d, a
	ld a, [wScriptBank]
	ld b, a
	jpba WriteCmdQueue

Script_delcmdqueue:
	xor a
	ldh [hScriptVar], a
	call GetScriptByte
	ld b, a
	callba DelCmdQueue
	ret c
	ld a, 1
	ldh [hScriptVar], a
	ret

Script_changemap:
	call GetScriptByte
	ld [wMapBlockDataBank], a
	call GetScriptByte
	ld [wMapBlockDataPointer], a
	call GetScriptByte
	ld [wMapBlockDataPointer + 1], a
	call ChangeMap
	jp BufferScreen

Script_changeblock:
	call GetScriptByte
	add 4
	ld d, a
	call GetScriptByte
	add 4
	ld e, a
	call GetBlockLocation
	call GetScriptByte
	ld [hl], a
	jp BufferScreen

Script_reloadmappart::
	xor a
	ldh [hBGMapMode], a
	call OverworldTextModeSwitch
	call GetMovementPermissions
	callba ReloadMapPart
	jp UpdateSprites

Script_warpcheck:
	call WarpCheck
	ret nc
	jpba EnableEvents

Script_newloadmap:
	call GetScriptByte
WriteMapEntryMethodLoadMapStatusEnterMapAndStopScript:
	ldh [hMapEntryMethod], a
	ld a, 1
	ld [wMapStatus], a
	jp StopScript

Script_reloadandreturn:
	call Script_newloadmap
	jp Script_end

Script_showtext:
	call Script_opentext
	call Script_writetext
Script_closetext:
	call BGMapAnchorTopLeft
	call IsScriptRunFromASM
	jp z, CloseText
	ld hl, wScriptFlags
	res 5, [hl]
	jp CloseWindow

Script_pause:
	call GetScriptByte
	and a
	jr z, .loop
	ld [wScriptDelay], a
.loop
	ld c, 2
	call DelayFrames
	ld hl, wScriptDelay
	dec [hl]
	jr nz, .loop
	ret

Script_deactivatefacing:
	call GetScriptByte
	and a
	jr z, .no_time
	ld [wScriptDelay], a
.no_time
	ld a, SCRIPT_WAIT
	ld [wScriptMode], a
	jp StopScript

Script_ptpriorityjump:
	call StopScript
	jp Script_jump

Script_closetextend:
	call Script_closetext
	jr Script_end

Script_return_if_callback_else_end:
	ld hl, wScriptFlags
	bit 1, [hl]
	jr nz, Script_return
Script_end:
	call ExitScriptSubroutine
	ret nc
	xor a
	ld [wScriptRunning], a
	assert SCRIPT_OFF == 0
	ld [wScriptMode], a
	ld hl, wScriptFlags
	res 0, [hl]
	jp StopScript

Script_return:
	call ExitScriptSubroutine
	ld hl, wScriptFlags
	res 0, [hl]
	jp StopScript

ExitScriptSubroutine:
	; Return carry if there's no parent to return to.
	ld hl, wScriptStackSize
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ld e, [hl]
	ld d, 0
	ld hl, wScriptStack
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld b, a
	and $7f
	ld [wScriptBank], a
	ld a, [hli]
	ld e, a
	ld [wScriptPos], a
	ld a, [hl]
	ld d, a
	ld [wScriptPos + 1], a
	and a
	ret
.done
	scf
	ret

Script_end_all:
	xor a
	ld [wScriptStackSize], a
	ld [wScriptRunning], a
	ld a, SCRIPT_OFF
	ld [wScriptMode], a
	ld hl, wScriptFlags
	res 0, [hl]
	jp StopScript

RunHallOfFameFromScript::
	ld hl, wGameTimerPause
	res 0, [hl]
	callba HallOfFame
	ld hl, wGameTimerPause
	set 0, [hl]
	jr ReturnFromCredits

RunCreditsFromScript::
	callba RedCredits
ReturnFromCredits:
	call Script_end_all
	ld a, 3
	ld [wMapStatus], a
	jp StopScript

Script_wait:
	push bc
	call GetScriptByte
.loop
	push af
	ld c, 6
	call DelayFrames
	pop af
	dec a
	jr nz, .loop
	pop bc
	ret

Script_loadscrollingmenudata:
	call Script_loadmenudata
	xor a
	ld [wScrollingMenuScrollPosition], a
	inc a
	ld [wScrollingMenuCursorBuffer], a
	ret

Script_backupcustchar:
	ld hl, wPlayerCharacteristics
	ld de, wSavedPlayerCharacteristics2
	ld bc, wSavedPlayerCharacteristics2End - wSavedPlayerCharacteristics2
	rst CopyBytes
	ret

Script_restorecustchar:
	ld hl, wSavedPlayerCharacteristics2
	ld de, wPlayerCharacteristics
	ld bc, wSavedPlayerCharacteristics2End - wSavedPlayerCharacteristics2
	rst CopyBytes
	jpba RefreshSprites

Script_giveTM:
	call GetScriptByte
	ld b, a
	add a, a
	ld a, b
	jr nz, .loaded
	ldh a, [hScriptVar]
	or b
.loaded
	ld [wd265], a
	and $7f
	ld c, a
	callba ReceiveTMHM

	push af
	ld hl, wStringBuffer3
	ld a, [wd265]
	ld b, a
	and $80
	ld c, a
	ld a, b
	and $7f
	cp NUM_TMS + 1
	ld b, "T"
	jr c, .notHM
	sub NUM_TMS
	or c
	ld [wd265], a
	and $7f
	ld b, "H"

.notHM
	ld [hl], b
	inc hl
	ld [hl], "M"
	inc hl

	; This is arguably a more efficient way to handle a 2-digit number
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add "0"
	ld [hli], a
	ld a, c
	add "0"
	ld [hli], a
	ld [hl], "@"

	call OpenText

	ld a, [wd265]
	bit 7, a
	ld hl, .received_text
	jr nz, .gotTM
	ld hl, .found_text
.gotTM
	call LocalMapTextbox

	pop af
	jr nc, .full

	ld de, SFX_GET_TM
	call KillPlayWaitSFX

	ld hl, .added_text
	ld a, 1
	jr .finish

.full
	call ButtonSound
	ld hl, .duplicate_text
	xor a
.finish
	ldh [hScriptVar], a
	call LocalMapTextbox
	call WaitButton
	jp CloseText

.found_text
	ctxt "<PLAYER> found"
	line "<STRBF3>!"
	done

.received_text
	ctxt "<PLAYER> received"
	line "<STRBF3>!"
	done

.added_text
	ctxt "<PLAYER> added <STRBF3>"
	line "to the TM Case!"
	done

.duplicate_text
	ctxt "But <PLAYER>"
	line "already has a"
	cont "<STRBF3>!"
	done

Script_giveTMnomessage:
	call GetScriptByteOrVar
	ld c, a
	callba ReceiveTMHM
	sbc a
	and 1
	ldh [hScriptVar], a
	ret

Script_givecraftingEXP:
	call GetScriptByte
	ld [wScriptBuffer], a
	ld b, BANK(GiveCraftingEXPScript)
	ld de, GiveCraftingEXPScript
	jp ScriptCall

GiveCraftingEXPScript:
	pushvar
	copybytetovar wScriptBuffer
	loadarray .array, 4
	readarrayhalfword 0
	popvar
	callasmf IncreaseCraftEXP
	sif false
		end
.loop
	readarrayhalfword 2
	writetext -1
	playwaitsfx SFX_DEX_FANFARE_50_79
	readarrayhalfword 0
	writebyte 0
	callasmf IncreaseCraftEXP
	iftrue .loop
	end

.array
	dw wMiningLevel, .mining
	dw wSmeltingLevel, .smelting
	dw wBallMakingLevel, .ballmaking
	dw wJewelingLevel, .jeweling

.mining
	ctxt "Your mining level"
	line "grew to @"
	deciram wMiningLevel, 1, 0
	text "!"
	done

.smelting
	ctxt "Your smelting"
	line "level grew to"
	cont "@"
	deciram wSmeltingLevel, 1, 0
	text "!"
	done

.ballmaking
	ctxt "Your ball making"
	line "level grew to"
	cont "@"
	deciram wBallMakingLevel, 1, 0
	text "!"
	done

.jeweling
	ctxt "Your jeweling"
	line "level grew to"
	cont "@"
	deciram wJewelingLevel, 1, 0
	text "!"
	done

IncreaseCraftEXP:
	; Returns 1 if you gained a level
	ldh a, [hScriptVar]
	ld b, a
	call GetHalfwordVar
	ld a, [hli] ; Max crafting level is 100
	cp 100
	jr nc, .skip

	ld a, [hl]
	add b
	ld [hld], a
	ld b, a
	ld a, [hl]
	call GetCraftingEXPForLevel
	cp b
	jr z, .increaseLevel
	jr c, .increaseLevel
.skip
	xor a
	ret

.increaseLevel
	sub b
	cpl
	inc a
	inc [hl]
	inc hl
	ld [hl], a
	ld a, 1
	ret

GetCraftingEXPForLevel:
	push hl
	inc a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, -1
	ld de, 1
.sqrtLoop
	inc a
	dec e
	dec de
	add hl, de
	jr c, .sqrtLoop
	pop hl
	ret

Script_checkash:
	ld bc, hScriptHalfwordVar
	callba CheckAsh
	jp CompareMoneyAction

Script_setplayersprite:
	call GetScriptByte
	cp $ff
	jr nz, .compute
	ldh a, [hScriptVar]
.compute
	and 7
	rla
	ld b, a
	ld a, [wPlayerGender]
	and 1
	or b
	ld [wPlayerGender], a
	ret ; callba RefreshSprites to apply

Script_setplayercolor:
	call GetScriptByte
	and a
	jr nz, .mem
	call GetScriptByte
	ld [wPlayerClothesPalette], a
	call GetScriptByte
	ld [wPlayerClothesPalette + 1], a
	ld a, [wPlayerGender]
	and $f
	ld b, a
	call GetScriptByte
	jr .set_race

.mem
	ld hl, wPlayerColor
	ld a, [hli]
	ld [wPlayerClothesPalette], a
	ld a, [hli]
	ld [wPlayerClothesPalette + 1], a
	ld a, [hl]
.set_race
	and $f
	swap a
	or b
	ld [wPlayerGender], a
	ret ; callba RefreshSprites to apply

Script_loadsignpost:
	call RefreshScreen

	call GetScriptHalfwordOrVar_HL

	callba _Signpost
	call CloseText
	jp Script_end

Script_checkpokemontype:
	; Returns 1 if this Pokemon is either X type or has a X typed move. 0 if it doesn't have either. 2 if you backed out.
	call GetScriptByte
	push af
	callba SelectMonFromParty
	jr c, .cancel
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	pop af
	ld hl, wBaseType
	cp [hl]
	jr z, .OK
	inc hl
	cp [hl]
	jr z, .OK
	push af
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Moves
	call GetPartyLocation
	pop bc
	ld c, 4

.loop
	push bc
	ld a, [hli]
	push hl
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and $3f
	pop hl
	pop bc
	cp b
	jr z, .OK

	dec c
	jr nz, .loop
	xor a
	ldh [hScriptVar], a
	ret

.OK
	ld a, 1
	ldh [hScriptVar], a
	ret

.cancel
	pop af
	ld a, 2
	ldh [hScriptVar], a
	ret

Script_addbytetovar:
	call GetScriptHalfwordOrVar_HL
	ldh a, [hScriptVar]
	add [hl]
	ldh [hScriptVar], a
	ret

TakeOrphanPointsFromScript::
	call LoadCoinAmountToMem
	jpba TakeOrphanPoints

CheckOrphanPointsFromScript::
	call LoadCoinAmountToMem
	callba CheckOrphanPoints
	jp CompareMoneyAction

Script_backupsecondpokemon:
	CheckEngine ENGINE_POKEMON_MODE
	ret nz ; sanity check
	ld hl, wPartyMon2
	ld de, wBackupMon
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	ld hl, wPartyCount
	ld a, [hl]
	ld [wBackupSecondPartySpecies], a
	ld a, 1
	ld [hl], a

	ld hl, wPartySpecies + 1
	ld de, wPokeonlyBackupPokemonSpecies
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld a, $ff
	dec hl
	ld [hl], a

	ld de, wPokeonlyBackupPokemonOT
	ld hl, wPartyMonOT + NAME_LENGTH
	ld bc, NAME_LENGTH
	rst CopyBytes

	ld de, wPokeonlyBackupPokemonNickname
	ld hl, wPartyMonNicknames + PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

	ret

Script_restoresecondpokemon:
	CheckEngine ENGINE_POKEMON_MODE
	ret z ; insanity check
	ld de, wPartyMon2
	ld hl, wBackupMon
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	ld a, [wBackupSecondPartySpecies]
	ld [wPartyCount], a

	ld de, wPartySpecies + 1
	ld hl, wPokeonlyBackupPokemonSpecies
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld hl, wPokeonlyBackupPokemonOT
	ld de, wPartyMonOT + NAME_LENGTH
	ld bc, NAME_LENGTH
	rst CopyBytes

	ld hl, wPokeonlyBackupPokemonNickname
	ld de, wPartyMonNicknames + PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret

Script_copystring:
	ld hl, hScriptHalfwordVar
	ld a, [hli]
	ld d, [hl]
	ld e, a
	call GetScriptStringBuffer
Script_getnthstring_CopyName2:
	jp CopyName2

Script_checkarcademaxround:
	call GetScriptHalfword
	ld a, [wBattleArcadeMaxRound]
	cp h
	jr nz, .done
	ld a, [wBattleArcadeMaxRound + 1]
	cp l
	jr nz, .done
	ld a, 1
	jr .calculated
.done
	sbc a
	and 2
.calculated
	ldh [hScriptVar], a
	ret

Script_scriptjumptable:
	call GetScriptHalfword
	ld b, 1
	jr ScriptJumptable

Script_menuanonjumptable:
	call Script_loadmenudata
	call Script_verticalmenu
	call Script_closewindow
Script_anonjumptable:
	ld hl, wScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0

ScriptJumptable:
	ldh a, [hScriptVar]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [wScriptBank]
	call GetFarHalfword
	ld a, b
	and a
	jp z, LocalScriptJump
	ld a, [wScriptBank]
	ld b, a
	ld d, h
	ld e, l
	jp ScriptCall

Script_scriptstartasm:
	call ScriptStartAsm_CallASMInScript
ScriptStartAsm_EntryPoint:
	ld a, h
	or l
	jp z, Script_end
	jp LocalScriptJump

Script_scriptstartasmf:
	call ScriptStartAsm_CallASMInScript
	ldh [hScriptVar], a
	jr ScriptStartAsm_EntryPoint

ScriptStartAsm_CallASMInScript:
	ld a, [wScriptBank]
	ld hl, wScriptPos
	jp FarCall_Pointer

Script_pushbyte:
	call Script_writebyte
Script_pushvar:
	call ScriptVarStackOperation
.op
	inc [hl]
	ld c, [hl]
	add hl, bc
	ldh a, [hScriptVar]
	ld [hl], a
	ret

Script_popvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	dec [hl]
ReadByteOffScriptVarStack:
	add hl, bc
	ld a, [hl]
	ldh [hScriptVar], a
	ret

Script_swapbyte:
	call Script_writebyte
Script_swapvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	add hl, bc
	ld c, [hl]
	ldh a, [hScriptVar]
	ld [hl], a
	ld a, c
	ldh [hScriptVar], a
	ret

Script_pullvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	jr ReadByteOffScriptVarStack

Script_pushhalfword:
	call Script_writehalfword
Script_pushhalfwordvar:
	call ScriptVarStackOperation
.op
	ld a, [hl]
	inc a
	ld c, a
	inc a
	ld [hl], a
	add hl, bc
	ldh a, [hScriptHalfwordVar]
	ld [hli], a
	ldh a, [hScriptHalfwordVar + 1]
	ld [hl], a
	ret

Script_pullhalfwordvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	jr ReadHalfwordOffScriptVarStack

Script_pophalfwordvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	dec [hl]
	dec [hl]
ReadHalfwordOffScriptVarStack:
	add hl, bc
	ld a, [hld]
	ld e, [hl]
	ld d, a
	jp WriteDEToScriptHalfword

ScriptVarStackOperation:
	pop hl
	ldh a, [rSVBK]
	push af
	wbk BANK(wScriptVarStackCount)
	call .execute_op
	pop af
	ldh [rSVBK], a
	ret
.execute_op
	push hl
	ld hl, wScriptVarStackCount
	ld b, 0
	ret ; intentional push/pop mismatch

Script_loadarray:
; load array data
; pointer and array entry size
	call GetScriptHalfwordOrVar
	ld a, [wScriptBank]
	ld [wScriptArrayBank], a
	ld hl, wScriptArrayAddress
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	and a
	jr z, .singularArray
	ldh a, [hScriptVar]
.singularArray
	ld [hl], a
	ret

Script_readarray:
; reads the following value in the loaded array at index [wScriptArrayCurrentEntry]
	call GetScriptArrayPointer
	call GetFarByte
	ldh [hScriptVar], a
	ret

Script_readarrayhalfword:
; like Script_readarray, but return a halfword in hScriptHalfwordVar instead
	call GetScriptArrayPointer
	call GetFarHalfword
	ld a, l
	ldh [hScriptHalfwordVar], a
	ld a, h
	ldh [hScriptHalfwordVar + 1], a
	ret

Script_pusharray:
; pushes the current array on the script stack
	call ScriptVarStackOperation
.op
	ld a, [hl]
	ld c, a
	add 5
	ld [hli], a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	ld hl, wScriptArrayBank
	ld bc, 5
	ln a, BANK(wScriptVarStack), BANK(wScriptArrayBank)
	jp DoubleFarCopyWRAM

Script_poparray:
; pops array data off the stack and reloads it into the array
	call ScriptVarStackOperation
.op
	ld a, [hl]
	sub 5
	ld c, a
	ld [hli], a
	ld b, 0
	add hl, bc
	ld de, wScriptArrayBank
	ld bc, 5
	ln a, BANK(wScriptArrayBank), BANK(wScriptVarStack)
	jp DoubleFarCopyWRAM

Script_cmdwitharrayargs:
; execute a command with custom arguments
	callba CreateScriptCommandWithCustomArguments
	ld de, wScriptArrayCommandBuffer
	ld b, BANK(Script_cmdwitharrayargs)
	jp ScriptCall

GetScriptArrayPointer:
	ld hl, wScriptArrayAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wScriptArrayEntrySize]
	ld c, a
	ld b, 0 ; store entry size in bc
	call GetScriptByteOrVar_FF
	ld e, a
	ld d, b ; store entry index in de
	ld a, [wScriptArrayCurrentEntry]
	rst AddNTimes ; get entry pointer
	add hl, de ; plus index
	ld a, [wScriptArrayBank]
	ret

Script_getweekday:
	call UpdateTime
	call GetWeekday
	ldh [hScriptVar], a
	ret

Script_toggle:
	call GetScriptHalfword
	ld e, l
	ld d, h
	push de
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop de
	push af
	ld b, SET_FLAG
	jr z, .set
	ld b, RESET_FLAG
.set
	predef EventFlagAction
	call GetScriptHalfword
	ld d, h
	ld e, l
	call GetScriptHalfword
	pop af
	jr z, .okay
	ld d, h
	ld e, l
.okay
	ld a, d
	or e
	ret z
	ld a, [wScriptBank]
	ld b, a
	jp ScriptCall

Script_switch:
; writebyte + selse combined into one
; hacky way of having fallthroughs to one point, abusing how selse and sendif work
; might break something
	call Script_writebyte

Script_selse:
	jpba ScriptSkipPastEndIf

Script_siffalse:
	ld b, 0
	jr ScriptConditionalEntryPoint

Script_siftrue:
	ld b, 1
	jr ScriptConditionalEntryPoint

Script_siflt:
	ld b, 2
	jr ScriptConditionalEntryPoint

Script_sifgt:
	ld b, 3
	jr ScriptConditionalEntryPoint

Script_sifeq:
	ld b, 4
	jr ScriptConditionalEntryPoint

Script_sifne:
	ld b, 5
ScriptConditionalEntryPoint:
	jpba ScriptConditional

Script_sendif:
; purely a debugging statement
	ld a, [wScriptBank]
	ld [wLastSEndIfBank], a
	ld a, [wScriptPos]
	ld [wLastSEndIfPos], a
	ld a, [wScriptPos + 1]
	ld [wLastSEndIfPos + 1], a
	ret

Script_comparevartobyte:
; output values:
; 0: var > byte
; 1: var < byte
; 2: var = byte
	call GetScriptHalfwordOrVar_HL
	ldh a, [hScriptVar]
	cp [hl] ; var - byte
	ld a, 2
	jr z, .done
	sbc a
	and 1
.done
	ldh [hScriptVar], a
	ret

Script_findpokemontype:
	; finds a Pokémon of the indicated type, or one that has a move of that type. Returns in [hScriptVar], party index (1..6) if found or 0 if not
	call GetScriptByte
	ldh [hScriptBuffer], a
	ld a, [wPartyCount]
	and a
	ld d, a
	jr z, .done
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	ld e, b ; b = 0 since the partymon struct is less than $100 bytes
.loop
	inc e
	push de
	push bc
	push hl
	call .check_type
	jr z, .found
	pop hl
	push hl
	call .check_moves
	jr c, .found
	pop hl
	pop bc
	pop de
	add hl, bc
	dec d
	jr nz, .loop
	xor a
.done
	ldh [hScriptVar], a
	ret
.found
	add sp, 4 ;skip the pushed values
	pop de
	ld a, e
	jr .done
.check_type
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	ldh a, [hScriptBuffer]
	ld hl, wBaseType
	cp [hl]
	ret z
	inc hl
	cp [hl]
	ret
.check_moves
	inc hl
	inc hl
	ld e, NUM_MOVES
	ldh a, [hScriptBuffer]
	ld d, a
.move_loop
	ld a, [hli]
	push hl
	and a
	jr z, .skip_move
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and $3f
	cp d
	jr z, .found_move
.skip_move
	pop hl
	dec e
	jr nz, .move_loop
	and a
	ret
.found_move
	pop hl
	scf
	ret

Script_startpokeonly:
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .good
	call GetScriptThreeBytes
	xor a
	ldh [hScriptVar], a
	ret

.good
	call Script_blackoutmod
	call GetScriptByte
	ld b, a
	ld de, ENGINE_USE_TREASURE_BAG
	call _EngineFlagAction
	call Script_backupsecondpokemon
	ld a, 1
	ldh [hScriptVar], a
	ret

Script_endpokeonly:
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .good
	call GetScriptThreeBytes
	xor a
	ldh [hScriptVar], a
	ret

.good
	call Script_blackoutmod
	call GetScriptByte
	ld b, a
	ld de, ENGINE_USE_TREASURE_BAG
	call _EngineFlagAction
	call Script_restoresecondpokemon
	ld a, 1
	ldh [hScriptVar], a
	ret

Script_addhalfwordvartovar:
	call GetHalfwordVar
	jr Script_addhalfwordvartovar_EntryPoint

Script_addhalfwordtovar:
	call GetScriptHalfword
Script_addhalfwordvartovar_EntryPoint:
	ldh a, [hScriptVar]
	add l
	ldh [hScriptHalfwordVar], a
	ld a, h
	adc 0
	ldh [hScriptHalfwordVar + 1], a
	ret

GetHalfwordVar:
	ld hl, hScriptHalfwordVar
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Script_copyvarbytetovar:
	call GetHalfwordVar
	ld a, [wScriptBank]
	call GetFarByte
	ldh [hScriptVar], a
	ret

Script_copybytetohalfwordvar:
	call GetScriptHalfwordOrVar_HL
	ld a, [hli]
	ldh [hScriptHalfwordVar], a
	ld a, [hl]
	ldh [hScriptHalfwordVar + 1], a
	ret

Script_isinsingulararray:
	call GetScriptHalfwordOrVar_HL
	ldh a, [hScriptVar]
	call IsInSingularArray
	ld a, $ff
	jr nc, .notFound
	ld a, b
.notFound
	ldh [hScriptVar], a
	ret

Script_isinarray:
	call GetScriptHalfwordOrVar
	call GetScriptHalfwordOrVar_HL
	call GetScriptByte
	ld c, a
	and $f
	ld b, a
	ld a, c
	and $f0
	swap a
	ld c, a
	call GetScriptByte
	push af
.loop
	push af
	push bc
	push de
	push hl
	ld a, [wScriptBank]
	call FarStringCmp
	pop hl
	pop de
	pop bc
	jr z, .found
	ld a, b
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	pop af
	dec a
	jr nz, .loop
	pop af
	ld a, $ff
	jr .writeToScriptVarAndReturn
.found
	pop bc
	pop af
	sub b
.writeToScriptVarAndReturn
	ldh [hScriptVar], a
	ret

Script_copy:
	call GetScriptHalfwordOrVar_HL
	call GetScriptByteOrVar
	ld c, a
.loop
	call GetScriptByte
	ld [hli], a
	dec c
	jr nz, .loop
	ret

GetEventVarAndOpcode:
	call GetScriptByte
	wbk BANK(wEventVariables)
CalculateEventVarAndOpcode:
	ld b, a
	and $3f
	ld c, a
	ld a, b
	ld b, 0
	ld hl, wEventVariables
	add hl, bc
	rlca
	rlca
	and 3
	ret

Script_eventvarop:
	; top two bits: op (0 = load, 1 = store, 2 = add, 3 = compare (returns 0 if equal, 1 if greater or 2 if smaller))
	; lower 6 bits: event variable ID
	ldh a, [hScriptVar]
	ld e, a
	call GetEventVarAndOpcode
	jr nz, .not_load
	ld a, [hl]
	jr .done

.not_load
	dec a
	jr nz, .not_store
	ld [hl], e
	jr .exit

.not_store
	dec a
	ld a, [hl]
	jr nz, .not_add
	add a, e
	jr .done

.not_add
	sub e
	jr z, .done
	sbc a
	add a, 2
.done
	ldh [hScriptVar], a
.exit
	wbk 1
	ret

Script_seteventvar:
	; top two bits: value (0, 1, 2 stand for themselves; 3 is -1)
	; lower 6 bits: event variable ID
	call GetEventVarAndOpcode
	cp 3
	jr c, .ok
	ld a, -1
.ok
	ld [hl], a
	wbk 1
	ret

Script_modifyeventvar:
	; top two bits: operation (0: set, 1: add, 2: inc, 3: dec)
	; lower 6 bits: event variable ID
	call GetScriptByte
	call CalculateEventVarAndOpcode

	xor 2
	jr nz, .not_inc
	wbk BANK(wEventVariables)
	inc [hl]
.done
	wbk 1
	ret

.not_inc
	dec a
	jr nz, .not_dec
	wbk BANK(wEventVariables)
	dec [hl]
	jr .done

.not_dec
	ld b, a
	call GetScriptByte
	wbk BANK(wEventVariables)
	dec b
	jr z, .set
	and a
	jr nz, .add
	ldh a, [hScriptVar]
.add
	add a, [hl]
.set
	ld [hl], a
	jr .done

Script_varblocks:
	call GetScriptHalfwordOrVar
	ld a, [wScriptBank]
	ld b, a
	jpba VariableBlocks

Script_getpartymonname:
	call GetScriptByteOrVar
	ld hl, wPartyMonNicknames - PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	jp CopyName1
