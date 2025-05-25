OverworldLoop::
	xor a
	ld [wMapStatus], a
.loop
	call .OverworldLoop
	jr nc, .loop
	ret

.OverworldLoop
	ld a, [wMapStatus]
	and a
	jr z, StartMap
	dec a
	jr z, EnterMap
	dec a
	jr z, HandleMap
	scf
	ret

DisableEvents:
	xor a
	ld [wScriptFlags3], a
	ret

EnableEvents::
	ld a, $ff
	ld [wScriptFlags3], a
	ret

EnableWildEncounters:
	ld hl, wScriptFlags3
	set 4, [hl]
	ret

StartMap:
	xor a
	ldh [hScriptVar], a
	ld [wScriptRunning], a
	ld hl, wMapStatus
	ld bc, wMapStatusEnd - wMapStatus
	call ByteFill
	call ClearJoypad
EnterMap:
	call SetUpFiveStepWildEncounterCooldown
	callba RunMapSetupScript
	call DisableEvents

	ldh a, [hMapEntryMethod]
	cp MAPSETUP_CONNECTION
	call z, EnableEvents

	ldh a, [hMapEntryMethod]
	cp MAPSETUP_RELOADMAP
	jr nz, .dontresetpoison
	xor a
	ld [wPoisonStepCount], a
.dontresetpoison

	xor a ; end map entry, also clears carry
	ldh [hMapEntryMethod], a
	ld a, 2 ; HandleMap
	ld [wMapStatus], a
	ret

HandleMap:
	call ResetOverworldDelay
	call HandleMapTimeAndJoypad
	call HandleCmdQueue
	call MapEvents

; Not immediately entering a connected map will cause problems.
	ld a, [wMapStatus]
	cp 2 ; HandleMap
	jr nz, .done
	call DoBackgroundEvents
	call DoBackgroundEvents
.done
	and a
	ret

DoBackgroundEvents:
	call HandleOverworldObjects
	call UpdateStableRNGSeeds
	call NextOverworldFrame
	call HandleMapBackgroundEvents
	jp EnableEventsIfPlayerNotMoving

UpdateStableRNGSeeds:
	ld a, BANK(wStableRNGReseedValues)
	call StackCallInWRAMBankA
	; end of function

	ld hl, wCurrentStableRNGSeedFrame
	push hl
	ld a, [hli]
	ld e, a
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl ; get current seed
	ld bc, wStableRNGReseedValues
	add hl, bc
	ld a, e
	cp 16
	jr c, .initialSeeding
	callba StableRandom
	jr .done
.initialSeeding
	srl e
	push af
	ld d, 0
	add hl, de
	call Random
	ld b, d ; d = 0
	rrca
	rl b
	ldh a, [hRandomAdd]
	rrca
	rl b
	ldh a, [rTIMA]
	rrca
	rl b
	ldh a, [rSTAT]
	and %11
	cp 1
	rl b
	pop af
	ld c, $f0
	jr nc, .noSwap
	swap b
	ld c, $f
.noSwap
	ld a, [hl]
	and c
	or b
	ld [hl], a
.done
	pop hl
	ld a, [hl]
	cp 23
	jr c, .incrementRNGSeedPortion
	ld [hl], 0
	inc hl
	ld a, [hl]
	cp ((wStableRNGOnlyReseedValuesEnd - wStableRNGReseedValues) / 8)
	jr nc, .skipSettingReseedFlags
	push hl
	push af
	ld hl, wStableRNGReseedFlags
	ld b, RESET_FLAG
	ld c, a
	predef FlagAction
	pop af
	pop hl
.skipSettingReseedFlags
	cp ((wStableRNGReseedValuesEnd - wStableRNGReseedValues) / 8) - 1
	jr c, .incrementRNGSeedPortion
	ld [hl], -1
.incrementRNGSeedPortion
	inc [hl]
	ret

MapEvents:
	ld a, [wMapEventStatus]
	and a
	ret nz
	call PlayerEvents
	call DisableEvents
	jpba ScriptEvents

ResetOverworldDelay:
	ld hl, wOverworldDelay
	bit 7, [hl]
	res 7, [hl]
	ret nz
	ld [hl], 2
	ret

NextOverworldFrame:
	ld a, [wOverworldDelay]
	and a
	jp nz, DelayFrame
; reset overworld delay to leak into the next frame
	ld a, $82
	ld [wOverworldDelay], a
	ret

HandleMapTimeAndJoypad:
	ld a, [wMapEventStatus]
	dec a ; no events
	ret z

	call UpdateTime
	call GetJoypad
	jp TimeOfDayPals

HandleOverworldObjects:
	callba HandleNPCStep ; engine/map_objects.asm
	callba _HandlePlayerStep
	jp _CheckObjectEnteringVisibleRange

HandleMapBackgroundEvents:
	callba _UpdateSprites
	callba RunLandmarkSignAnim
	jpba ScrollScreen

EnableEventsIfPlayerNotMoving:
	ld a, [wPlayerStepFlags]
	bit 5, a ; in the middle of step
	jr z, .events
	bit 6, a ; stopping step
	jr z, .noevents
	bit 4, a ; in midair
	jr nz, .noevents
	call EnableEvents
.events
	xor a ; events
	ld [wMapEventStatus], a
	ret

.noevents
	ld a, 1 ; no events
	ld [wMapEventStatus], a
	ret

_CheckObjectEnteringVisibleRange:
	ld hl, wPlayerStepFlags
	bit 6, [hl]
	ret z
	jpba CheckObjectEnteringVisibleRange

PlayerEvents:
; If there's already a player event, don't interrupt it.
	ld a, [wScriptRunning]
	and a
	ret nz

	call CheckTrainerBattle3
	jr c, .got_script

	call CheckTileEvent
	jr c, .got_script

	call DoMapTrigger
	jr c, .got_script

	call CheckTimeEvents
	jr c, .got_script

	call OWPlayerInput
	jr c, .got_script

	xor a
	ret

.got_script
	push af
	callba EnableScriptMode
	pop af

	ld [wScriptRunning], a
	call DoPlayerEvent
	ld a, [wScriptRunning]
	cp PLAYEREVENT_CONNECTION
	jr z, .no_cancel_map_sign
	cp PLAYEREVENT_JOYCHANGEFACING
	call nz, CancelMapSign
.no_cancel_map_sign
	scf
	ret

CheckTrainerBattle3:
	call CheckTrainerBattle
	ld a, 0
	ret nc
	ld a, PLAYEREVENT_SEENBYTRAINER
	ret

CheckTileEvent:
; Check for warps, tile triggers or wild battles.

	ld hl, wScriptFlags3
	bit 2, [hl]
	jr z, .connections_disabled

	callba CheckMovingOffEdgeOfMap
	jr c, .map_connection

	call CheckWarpTile
	jr c, .warp_tile

.connections_disabled
	ld hl, wScriptFlags3
	bit 1, [hl]
	call nz, RunCurrentMapXYTriggers
 	; if function not called, carry is not set
 	; because of the jump to .warp_tile
	ret c
	ld hl, wScriptFlags3
	bit 0, [hl]
	jr z, .step_count_disabled

	call CountStep
	ret c

.step_count_disabled
	ld hl, wScriptFlags3
	bit 4, [hl]
	jr z, .ok

	call RandomEncounter
	ret c

.ok
	xor a
	ret

.map_connection
	ld a, PLAYEREVENT_CONNECTION
	scf
	ret

.warp_tile
	ld a, [wPlayerStandingTile]
	cp COLL_HOLE
	scf
	ld a, PLAYEREVENT_FALL
	ret z
	ld a, PLAYEREVENT_WARP
	ret


CheckWildEncounterCooldown::
	ld hl, wWildEncounterCooldown
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret z
	scf
	ret

SetUpFiveStepWildEncounterCooldown:
	ld a, 5
	ld [wWildEncounterCooldown], a
	ret

SetMinTwoStepWildEncounterCooldown:
	ld a, [wWildEncounterCooldown]
	cp 2
	ret nc
	ld a, 2
	ld [wWildEncounterCooldown], a
	ret

DoMapTrigger:
	ld a, [wCurrMapTriggerCount]
	and a
	ret z

	ld c, a
	call CheckTriggers
	cp c
	ret nc

	add a, a
	add a, a
	ld e, a
	ld d, 0
	ld hl, wCurrMapTriggerHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de

	ld a, [wMapScriptHeaderBank]
	ld b, a
	call GetFarHalfword
	ld a, b
	call GetFarByte
	cp end_command
	ret z ; boost efficiency of maps with dummy/"finished" triggers
	ld a, b
	call CallScript

	ld hl, wScriptFlags
	res 3, [hl]

	callba EnableScriptMode
	callba ScriptEvents

	ld hl, wScriptFlags
	and a
	bit 3, [hl]
	ret z

	ld hl, wPriorityScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wPriorityScriptBank]
	jp CallScript

CheckTimeEvents:
	ld a, [wLinkMode]
	and a
	ret nz

	ld hl, wTimeEventCallback
	ld a, [hli]
	and a
	jr z, .doRTCTimers
	ld l, [hl]
	ld h, a
	ld a, [wTimeEventCallbackBank]
	call FarCall_hl
	ret c
.doRTCTimers
	callba CheckRTCTimers
	xor a
	ret

OWPlayerInput:
	call PlayerMovement
	ret c
	and a
	ret nz

; Can't perform button actions while sliding on ice.
	callba CheckStandingOnIce
	ccf
	ret nc

	call CheckAPressOW
	jr c, .Action

	call CheckMenuOW
	ret nc

.Action
	push af

	ld hl, wPlayerNextMovement
	ld a, movement_step_sleep_1
	cp [hl]
	jr z, .skip

	ld [hl], a
	xor a
	ld [wPlayerMovementDirection], a
.skip
	pop af
	scf
	ret

CheckAPressOW:
	ldh a, [hJoyPressed]
	and A_BUTTON
	ret z
	call TryObjectEvent
	ret c
	call TryReadSign
	ret c
	jp CheckFacingTileEvent

TryObjectEvent:
	callba CheckFacingObject
	ret nc
	call PlayClickSFX
	ldh a, [hObjectStructIndexBuffer]
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	ldh [hLastTalked], a
	call GetMapObject
	ld hl, MAPOBJECT_COLOR
	add hl, bc
	ld a, [hl]
	and %00001111

	cp (.pointers_end - .pointers) / 2
	ret nc
	jumptable

.pointers
	dw .script ; PERSONTYPE_SCRIPT
	dw .itemball ; PERSONTYPE_ITEMBALL
	dw .trainer ; PERSONTYPE_TRAINER
	dw .tmhm ; PERSONTYPE_TMHMBALL
	dw .trainer ; PERSONTYPE_GENERICTRAINER
	dw .text ; PERSONTYPE_TEXT
	dw .textfp ; PERSONTYPE_TEXTFP
	dw .jumpstd ; PERSONTYPE_JUMPSTD
	dw .mart ; PERSONTYPE_MART
	dw .fruittree ; PERSONTYPE_FRUITTREE
.pointers_end

.load_pointer_and_bank
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMapScriptHeaderBank]
	ret

.script
	call .load_pointer_and_bank
	jp CallScript

.itemball
	ld hl, MAPOBJECT_PARAMETER
	add hl, bc
	ld a, [hli]
	ld e, [hl]
	ld hl, wCurItemBallContents + 1
	ld [hld], a
	ld [hl], e
	ld a, PLAYEREVENT_ITEMBALL
	scf
	ret

.trainer
	call TalkToTrainer
	ld a, PLAYEREVENT_TALKTOTRAINER
	scf
	ret

.tmhm
	ld hl, MAPOBJECT_PARAMETER
	add hl, bc
	ld a, [hl]
	ld [wCurItemBallContents], a
	ld a, PLAYEREVENT_GETTMHM
	scf
	ret

.textfp
	ld a, jumptextfaceplayer_command
	jr .textfp_entrypoint

.text
	ld a, jumptext_command
.textfp_entrypoint
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld de, wTemporaryScriptBuffer
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jr .call_temporary_script_buffer

.jumpstd
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld hl, wTemporaryScriptBuffer + 3
	ld [hld], a
	ld a, jumpstd_command
	ld [hld], a
	ld a, d
	ld [hld], a
	ld [hl], writebyte_command
.call_temporary_script_buffer
	ld hl, wTemporaryScriptBuffer
.call_script_in_bank
	ld a, [wMapScriptHeaderBank]
	jp CallScript

.mart
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld de, wTemporaryScriptBuffer
	ld a, pokemart_command
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jr .call_temporary_script_buffer

.fruittree
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hl]
	ld hl, wTemporaryScriptBuffer + 1
	ld [hld], a
	ld [hl], fruittree_command
	jr .call_script_in_bank

TryReadSign:
	call CheckFacingSign
	ret nc
	ld a, [wCurSignpostType]
	rlca
	rlca
	and 3
	jr z, .skip
	dec a
	jumptable .GlobalSignHandlers
	ret z
.skip
	ld a, [wCurSignpostType]
	and $3f
	jumptable

.signs
	dw .read ; SIGNPOST_READ
	dw .up ; SIGNPOST_UP
	dw .down ; SIGNPOST_DOWN
	dw .right ; SIGNPOST_RIGHT
	dw .left ; SIGNPOST_LEFT
	dw .itemifset ; SIGNPOST_ITEM
	dw .loadsignpost ; SIGNPOST_LOAD
	dw .text ; SIGNPOST_TEXT
	dw .jumpstd ; SIGNPOST_JUMPSTD
	dw .jumpstdnosfx ; SIGNPOST_JUMPSTDNOSFX

.GlobalSignHandlers:
	dw HandleEventBasedSign_Reset
	dw HandleEventBasedSign_Set
	dw DummyGlobalSignHandler

.up
	ld b, OW_UP
	jr .checkdir

.down
	ld b, OW_DOWN
	jr .checkdir

.right
	ld b, OW_RIGHT
	jr .checkdir

.left
	ld b, OW_LEFT
.checkdir
	ld a, [wPlayerDirection]
	and %1100
	cp b
	jr nz, .dontread

.read
	call PlayClickSFX
	ld hl, wCurSignpostScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMapScriptHeaderBank]
	jr .call_script_set_carry

.text
	ld a, jumptext_command
	jr .signpost_text_entrypoint

.loadsignpost
	ld a, loadsignpost_command
.signpost_text_entrypoint
	push af
	call PlayClickSFX
	ld hl, wTemporaryScriptBuffer + 2
	ld a, [wCurSignpostScriptAddr + 1]
	ld [hld], a
	ld a, [wCurSignpostScriptAddr]
	ld [hld], a
	pop af
	ld [hl], a
	ld a, [wMapScriptHeaderBank]
.call_script_set_carry
	jp CallScript

.itemifset
	call CheckSignFlag
	jr nz, .dontread
	call PlayClickSFX
	ld a, [wMapScriptHeaderBank]
	ld de, wCurSignpostItemFlag
	ld bc, 3
	call FarCopyBytes
	ld a, BANK(HiddenItemScript)
	ld hl, HiddenItemScript
	jr .call_script_set_carry

.dontread
	xor a
	ret

.jumpstd
	call PlayClickSFX
.jumpstdnosfx
	ld hl, wTemporaryScriptBuffer + 3
	ld a, [wCurSignpostScriptAddr]
	ld [hld], a
	ld a, jumpstd_command
	ld [hld], a
	ld a, [wCurSignpostScriptAddr + 1]
	ld [hld], a
	ld [hl], writebyte_command ; just to be safe (as opposed to directly writing to hScriptVar)
	ld a, [wMapScriptHeaderBank]
	jr .call_script_set_carry

HandleEventBasedSign_Reset:
	ld a, 1
	jr HandleEventBasedSign
HandleEventBasedSign_Set:
	xor a
HandleEventBasedSign:
	push af
	call CheckSignFlag
	ld a, c
	and a
	jr z, .cIsZero
	ld c, 1
.cIsZero
	pop af
	xor c
	ret z
	inc hl
	inc hl
	ld a, l
	ld [wCurSignpostScriptAddr], a
	ld a, h
	ld [wCurSignpostScriptAddr + 1], a
DummyGlobalSignHandler:
	ld a, 1
	and a
	ret

CheckSignFlag:
	ld hl, wCurSignpostScriptAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wMapScriptHeaderBank]
	call GetFarHalfword
	ld e, l
	ld d, h
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld a, c
	and a
	pop hl
	ret

PlayerMovement:
	callba DoPlayerMovement
	ld a, c
	jumptable

	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw .six
	dw .seven

.zero
.four
.seven
	xor a
	ret

.one
	ld a, PLAYEREVENT_WARP
	scf
	ret

.two
	ld a, PLAYEREVENT_JOYCHANGEFACING
	scf
	ret

.three
; force the player to move in some direction
	ld a, BANK(Script_ForcedMovement)
	ld hl, Script_ForcedMovement
	call CallScript
	ld a, PLAYEREVENT_MAPSCRIPT
	ret

.five
.six
	ld a, PLAYEREVENT_MAPSCRIPT
	and a
	ret

CheckMenuOW:
	xor a
	ldh [hMenuReturn], a
	ldh [hMenuReturn + 1], a

	debug_mode_flag
	jr c, .debug_mode
	CheckEngine ENGINE_WILDS_DISABLED
	jr nz, .NoMenu
.debug_mode
	ldh a, [hJoyPressed]

	bit SELECT_F, a
	jr nz, .Select

	bit START_F, a
	jr z, .NoMenu

	ld a, BANK(StartMenuScript)
	ld hl, StartMenuScript
	jp CallScript

.IncrementCounter
	ld hl, wSelectButtonCounter
	bit 7, [hl]
	jr nz, .NoMenu
	inc hl
	inc hl
	inc [hl]
	jr nz, .NoMenu
	dec hl
	inc [hl]
	jr nz, .NoMenu
	dec hl
	inc [hl]
.NoMenu
	xor a
	ret

.Select
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .NoMenu
	callba CheckRegisteredItem
	jr c, .IncrementCounter
	call PlayClickSFX
	ld a, BANK(SelectMenuScript)
	ld hl, SelectMenuScript
	jp CallScript

StartMenuScript:
	callasm StartMenu
	jump StartMenuCallback

SelectMenuScript:
	callasm SelectMenu
StartMenuCallback:
	copybytetovar hMenuReturn
	if_equal HMENURETURN_SCRIPT, .Script
	if_equal HMENURETURN_ASM, .Asm
	end

.Script
	ptjump wQueuedScriptBank

.Asm
	ptcallasm wQueuedScriptBank
	end

CountStep:
	; Global counter is always updated
	ld hl, wGlobalStepCounter
	inc [hl]
	jr nz, .done_global_counter
	rept 3
		inc hl
		inc [hl]
		jr nz, .done_global_counter
	endr
	ld a, -1
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hl], a
.done_global_counter

	; Don't count steps in link communication rooms.
	ld a, [wLinkMode]
	and a
	jr nz, .done

	call CollectSoot
	; If Repel wore off, don't count the step.
	call DoRepelStep
	jr c, .doscript

	; Count the step for poison and total steps
	ld hl, wPoisonStepCount
	inc [hl]
	ld hl, wStepCount
	inc [hl]
	; Every 256 steps, increase the happiness of all your Pokemon.
	jr nz, .skip_happiness

	callba StepHappiness

.skip_happiness
	; Every 256 steps, offset from the happiness incrementor by 128 steps,
	; decrease the hatch counter of all your eggs until you reach the first
	; one that is ready to hatch.
	ld a, [wStepCount]
	cp $80
	jr nz, .skip_egg

	callba DoEggStep
	jr nz, .hatch

.skip_egg
	; Increase the EXP of (both) DayCare Pokemon by 1.
	callba DaycareStep

	; Every four steps, deal damage to all Poisoned Pokemon
	ld hl, wPoisonStepCount
	ld a, [hl]
	cp 4
	jr c, .skip_poison
	ld [hl], 0

	callba DoPoisonStep
.skip_poison
	ld a, [wEventFlags + (EVENT_HAS_IRON_PICKAXE / 8)]
	bit (EVENT_HAS_IRON_PICKAXE % 8), a
	jr z, .done
	ld a, IRON_PICKAXE
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	jr nc, .done
	ld hl, wIronPickaxeStepCount
	ld a, [hl]
	cp 250
	jr nc, .done
	inc [hl]
.done
	xor a
	ret

.doscript
	ld a, PLAYEREVENT_MAPSCRIPT
	scf
	ret

.hatch
	ld a, PLAYEREVENT_HATCH
	scf
	ret

CollectSoot:
	ld a, [wMapGroup]
	cp GROUP_ROUTE_85
	jr z, .collect_soot
	cp GROUP_FIRELIGHT_F1
	jr z, .collect_soot
	cp GROUP_EMBER_BROOK
	jr z, .collect_soot
	cp GROUP_OLCAN_ISLE
	ret nz
	ld a, [wMapNumber]
	cp MAP_OLCAN_ISLE
	ret nz
.collect_soot
	ld a, SOOT_SACK
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	ret nc

	xor a
	ldh [hMoneyTemp], a
	inc a
	ldh [hMoneyTemp + 1], a
	ld bc, hMoneyTemp
	jpba GiveAsh

DoRepelStep:
	callba CheckStandingOnIce
	jr c, .nope

	ld hl, wRepelEffect
	ld a, [hli]
	or [hl]
	ret z

	ld a, [hld]
	ld c, [hl]
	ld b, a
	dec bc
	ld a, c
	ld [hli], a
	ld [hl], b
	or b
	ret nz

	ld a, BANK(RepelWoreOffScript)
	ld hl, RepelWoreOffScript
	jp CallScript

.nope
	and a
	ret

DoPlayerEvent:
	ld a, [wScriptRunning]
	and a
	ret z

	cp PLAYEREVENT_MAPSCRIPT ; run script
	ret z

	cp NUM_PLAYER_EVENTS
	ret nc

	ld c, a
	ld b, 0
	ld hl, PlayerEventScriptPointers
	add hl, bc
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld [wScriptBank], a
	ld a, [hli]
	ld [wScriptPos], a
	ld a, [hl]
	ld [wScriptPos + 1], a
	ret

PlayerEventScriptPointers:
	dba GenericDummyScript       ; 0
	dba SeenByTrainerScript      ; 1
	dba TalkToTrainerScript      ; 2
	dba FindItemInBallScript     ; 3
	dba EdgeWarpScript           ; 4
	dba WarpToNewMapScript       ; 5
	dba FallIntoMapScript        ; 6
	dba Script_OverworldWhiteout ; 7
	dba HatchEggScript           ; 8
	dba ChangeDirectionScript    ; 9
	dba FindTMorHMScript         ; 10

HatchEggScript:
	callasm OverworldHatchEgg
	end

WarpToNewMapScript:
	warpsound
	newloadmap MAPSETUP_DOOR
	end

FallIntoMapScript:
	newloadmap MAPSETUP_FALL
	playsound SFX_KINESIS
	applymovement PLAYER, .movement
	playsound SFX_STRENGTH
	earthquake 16
	end

.movement
	skyfall
	step_end

EdgeWarpScript:
	reloadandreturn MAPSETUP_CONNECTION

ChangeDirectionScript:
	callasm ReleaseAllMapObjects
	callasm EnableWildEncounters
	end

CheckFacingTileEvent::
	call GetFacingTileCoord
	ld [wTempFacingTile], a
	ld c, a
	call CheckFacingTileForStd
	jr c, .skip_sfx

	ld a, [wTempFacingTile]
	cp COLL_CUT_TREE
	jr nz, .headbutt
	callba TryCutOW
	jr .done

.headbutt
	ld a, [wTempFacingTile]
	cp COLL_HEADBUTT_TREE
	jr nz, .surf
	callba TryHeadbuttOW
	jr c, .done
	jr .noevent

.surf
	callba TrySurfOW
	jr c, .done

.noevent
	xor a
	ret

.done
	call PlayClickSFX
.skip_sfx
	ld a, $ff
	scf
	ret

RandomEncounter::
; Random encounter

	call CheckWildEncounterCooldown
	jr c, .nope
	call CanUseSweetScent
	jr nc, .nope
	ld hl, wStatusFlags2
	callba TryWildEncounter
	jr nz, .nope

.ok
	ld a, BANK(WildBattleScript)
	ld hl, WildBattleScript
	jp CallScript

.nope
	ld a, 1
	and a
	ret

WildBattleScript:
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

CanUseSweetScent::
	CheckEngine ENGINE_WILDS_DISABLED
	jr nz, .no

	ld a, [wPermission]
	cp CAVE
	jr z, .ice_check
	cp DUNGEON
	jr z, .ice_check
	callba CheckGrassCollision
	ret nc

.ice_check
	ld a, [wPlayerStandingTile]
	cp COLL_ICE
	ret z ;zero is no carry
	scf
	ret

.no
	and a
	ret

ClearCmdQueue::
	ld hl, wCmdQueue
	ld de, CMDQUEUE_ENTRY_SIZE
	ld c, CMDQUEUE_CAPACITY
	xor a
.loop
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	ret

HandleCmdQueue::
	ld hl, wCmdQueue
	xor a
.loop
	ldh [hMapObjectIndexBuffer], a
	ld a, [hl]
	and a
	jr z, .skip
	push hl
	ld b, h
	ld c, l
	call HandleQueuedCommand
	pop hl

.skip
	ld de, CMDQUEUE_ENTRY_SIZE
	add hl, de
	ldh a, [hMapObjectIndexBuffer]
	inc a
	cp CMDQUEUE_CAPACITY
	jr nz, .loop
	ret

WriteCmdQueue::
	push bc
	push de
	call .GetNextEmptyEntry
	ld d, h
	ld e, l
	pop hl
	pop bc
	ret c
	ld a, b
	ld bc, CMDQUEUE_ENTRY_SIZE - 1
	call FarCopyBytes
	xor a
	ld [hl], a
	ret

.GetNextEmptyEntry
	ld hl, wCmdQueue
	ld de, CMDQUEUE_ENTRY_SIZE
	ld c, CMDQUEUE_CAPACITY
.loop
	ld a, [hl]
	and a
	jr z, .done
	add hl, de
	dec c
	jr nz, .loop
	scf
	ret

.done
	ld a, CMDQUEUE_CAPACITY
	sub c
	and a
	ret

DelCmdQueue::
	ld hl, wCmdQueue
	ld de, CMDQUEUE_ENTRY_SIZE
	ld c, CMDQUEUE_CAPACITY
.loop
	ld a, [hl]
	cp b
	jr z, .done
	add hl, de
	dec c
	jr nz, .loop
	and a
	ret

.done
	xor a
	ld [hl], a
	scf
	ret

HandleQueuedCommand:
	ld de, wPlayerStruct
	ld a, NUM_OBJECT_STRUCTS
.loop
	push af

	ld hl, OBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

	ld hl, OBJECT_MOVEMENTTYPE
	add hl, de
	ld a, [hl]
	cp STEP_TYPE_SKYFALL_TOP
	jr nz, .next

	ld hl, OBJECT_NEXT_TILE
	add hl, de
	ld a, [hl]
	cp COLL_HOLE
	jr nz, .next

	ld hl, OBJECT_DIRECTION_WALKING
	add hl, de
	ld a, [hl]
	cp STANDING
	jr nz, .next
	call HandleStoneQueue
	jr c, .fall_down_hole

.next
	ld hl, OBJECT_STRUCT_LENGTH
	add hl, de
	ld d, h
	ld e, l

	pop af
	dec a
	jr nz, .loop
	ret

.fall_down_hole
	pop af
	ret

CheckFacingTileForStd::
; Checks to see if the tile you're facing has a std script associated with it.  If so, executes the script and returns carry.
	ld a, c
	ld e, 2
	ld hl, .table
	call IsInArray
	ret nc

	ld a, jumpstd_command
	ld [wTemporaryScriptBuffer], a
	inc hl
	ld a, [hli]
	ld [wTemporaryScriptBuffer + 1], a
	cp jumpingshoes
	jr z, .skip_sfx
	cp mining
	jr z, .skip_sfx
	cp pcscript
	jr nz, .play_sfx
	ld a, [wPlayerDirection]
	cp OW_UP
	jr nz, .not_in_table
.play_sfx
	call PlayClickSFX
.skip_sfx
	ld a, [wMapScriptHeaderBank]
	ld hl, wTemporaryScriptBuffer
	jp CallScript

.not_in_table
	xor a
	ret

.table
	db COLL_BOOKSHELF,       magazinebookshelf
	db COLL_TV,              tvtext
	db COLL_PC,              pcscript
	db COLL_SMELTING,        smelting
	db COLL_TOWN_MAP,        townmap
	db COLL_MART_SHELF,      merchandiseshelf
	db COLL_JUMPING_SHOES,   jumpingshoes
	db COLL_MINING,          mining
	db COLL_FAST_CURRENT,    fastcurrent
	db COLL_POKECENTER_SIGN, pokecentersign
	db COLL_MART_SIGN,       martsign
	db COLL_OASIS,           oasis
	db COLL_MAGNETIC_TAPE_DRIVE, magnetictapedrive
	db -1 ; end
