FieldMoveFailed:
	ld hl, .CantUseHere
	jp MenuTextBoxBackup

.CantUseHere
	; Can't use that here.
	text_jump FieldMoveFailedText

FieldMovePokepicScript::
	checkflag ENGINE_POKEMON_MODE
	sif true
		end
	refreshscreen 0
	callasm GetPartyMonUsingFieldMove
	checkcode VAR_MOVEMENT
	sif false, then
		applymovement PLAYER, FieldMoveMovement
		special ReplaceKrisSprite
	sendif
	copybytetovar wFieldMovePokepicSpecies
	callasm .pokepicwithshinycheck
	cry 0
	closepokepic
	reloadmappart
	end

.pokepicwithshinycheck
	ldh a, [hScriptVar]
	ld [wCurPartySpecies], a
	ld b, 0
	jpba Pokepic

FieldMoveMovement:
	field_move
	step_end

CutFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
	dw .CheckAble
	dw .DoCut
	dw .FailCut

.CheckAble
	CheckEngine ENGINE_NATUREBADGE
	jr z, .nohivebadge
	call CheckMapForSomethingToCut
	jr c, .nothingtocut
	ld a, 1
	ret

.nohivebadge
	call PrintNoBadgeText
	ld a, $80
	ret

.nothingtocut
	ld a, 2
	ret

.DoCut
	ld hl, Script_CutFromMenu
	call QueueScript
	ld a, $81
	ret

.FailCut
	ld hl, Text_NothingToCut
	call MenuTextBoxBackup
	ld a, $80
	ret

Text_UsedCut:
	; used CUT!
	text_jump UsedCutText

Text_NothingToCut:
	; There's nothing to CUT here.
	text_jump NothingToCutText

CheckMapForSomethingToCut:
	; Does the collision data of the facing tile permit cutting?
	call GetFacingTileCoord
	ld c, a
	push de
	callba CheckCutCollision
	pop de
	ccf
	ret c
	; Get the location of the current block in wOverworldMap.
	call GetBlockLocation
	ld c, [hl]
	; See if that block contains something that can be cut.
	push hl
	ld hl, CutTreeBlockPointers
	call CheckOverworldTileArrays
	pop hl
	ccf
	ret c
	; Back up the wOverworldMap address to wFieldMoveCutTileLocation
	ld a, l
	ld [wFieldMoveCutTileLocation], a
	ld a, h
	ld [wFieldMoveCutTileLocation + 1], a
	; Back up the replacement tile to wFieldMoveCutTileReplacement
	ld a, b
	ld [wFieldMoveCutTileReplacement], a
	; Back up the animation index to wWhichCutAnimation
	ld a, c
	ld [wWhichCutAnimation], a
	xor a
	ret

Script_CutFromMenu:
	reloadmappart
	special UpdateTimePals

Script_Cut:
	callasm GetPartyNick
	writetext Text_UsedCut
	reloadmappart
	fieldmovepokepic
	callasm CutDownTreeOrGrass
	closetextend

CutDownTreeOrGrass:
	ld hl, wFieldMoveCutTileLocation ; current overworld tile
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wFieldMoveCutTileReplacement] ; replacement tile
	ld [hl], a
	xor a
	ldh [hBGMapMode], a
	call OverworldTextModeSwitch
	call UpdateSprites
	call DelayFrame
	ld a, [wWhichCutAnimation]
	ld e, a
	callba OWCutAnimation
	call BufferScreen
	call GetMovementPermissions
	call UpdateSprites
	call DelayFrame
	jp LoadStandardFont

CheckOverworldTileArrays:
	; Input: c contains the tile you're facing
	; Output: Replacement tile in b and effect on wild encounters in c, plus carry set.
	;         Carry is not set if the facing tile cannot be replaced, or if the tileset
	;         does not contain a tile you can replace.

	; Dictionary lookup for pointer to tile replacement table
	push bc
	ld a, [wTileset]
	ld e, 3
	call IsInArray
	pop bc
	ret nc
	; Load the pointer
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; Look up the tile you're facing
	ld e, 3
	ld a, c
	call IsInArray
	ret nc
	inc hl
	ld a, [hli]
	ld c, [hl] ; Load the animation type parameter to c
	ld b, a ; Load the replacement to b
	scf
	ret

CutTreeBlockPointers:
; Which tileset are we in?
	dbw TILESET_NALJO_1, .naljo
	dbw TILESET_NALJO_2, .naljo
	dbw TILESET_NALJO_3, .naljo
	dbw TILESET_RIJON, .rijon
	dbw TILESET_JOHTO, .johto
	dbw TILESET_KANTO, .kanto
	dbw TILESET_PARK, .park
	dbw TILESET_FOREST, .ilex
	db -1

.naljo
; Which meta tile are we facing, which should we replace it with, and which animation?
	db $03, $02, $01 ; grass
	db $5b, $3c, $00 ; tree
	db $5f, $3d, $00 ; tree
	db $63, $3f, $00 ; tree
	db $67, $3e, $00 ; tree
	db -1

.johto ; Goldenrod area
	db $03, $02, $01 ; grass
	db -1

.rijon ; Rijon OW
.kanto ; Kanto OW
	db $0b, $0a, $01 ; grass
	db $32, $6d, $00 ; tree
	db $33, $6c, $00 ; tree
	db $34, $6f, $00 ; tree
	db $35, $41, $00 ; tree
	db $60, $6e, $00 ; tree
	db -1

.park ; National Park
	db $13, $03, $01 ; grass
	db $03, $04, $01 ; grass
	db -1

.ilex ; Ilex Forest
	db $0f, $17, $00
	db -1

OWFlash:
	call .CheckUseFlash
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.CheckUseFlash
	jr c, .useflash
	ld a, [wTimeOfDayPalset]
	inc a ; if the palette is 3 (dark) for all four colors
	jr nz, .notadarkcave
.useflash
	call UseFlash
	ld a, $81
	ret

.notadarkcave
	call FieldMoveFailed
	ld a, $80
	ret

UseFlash:
	ld hl, Script_UseFlash
	jp QueueScript

Script_UseFlash:
	reloadmappart
	special UpdateTimePals
	fieldmovepokepic
	farwritetext UseFlashText
	playwaitsfx SFX_FLASH
	callasm BlindingFlash
	closetextend

SurfFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
	dw .TrySurf
	dw .DoSurf
	dw .FailSurf
	dw .AlreadySurfing

.TrySurf
	CheckEngine ENGINE_HAZEBADGE
	jr z, .no_badge
	ld hl, wBikeFlags
	bit 1, [hl] ; always on bike
	jr nz, .cannotsurf
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .alreadyfail
	cp PLAYER_SURF_PIKA
	jr z, .alreadyfail
	call GetFacingTileCoord
	cp COLL_FAST_CURRENT
	jr z, .currentTooFast
	call GetTileCollision
	dec a
	jr nz, .cannotsurf
	call CheckDirection
	jr c, .cannotsurf
	callba CheckFacingObject
	jr c, .cannotsurf
	ld hl, wMapGroup
	ld a, [hli]
	cp GROUP_SAXIFRAGE_ISLAND
	jr nz, .notInSaxifrage
	ld a, [hl]
	cp MAP_SAXIFRAGE_ISLAND
	jr z, .inSaxifrage
.notInSaxifrage
	ld a, 1
	ret

.inSaxifrage
	ld hl, CantSurfSaxifrageText
	jr .PrintFailureMessageWithPrompt

.currentTooFast:
	ld hl, .FastCurrentText

.PrintFailureMessageWithPrompt:
	call MenuTextBox
	call ButtonSound
	call CloseWindow
	ld a, $80
	ret

.no_badge
	call PrintNoBadgeText
	ld a, $80
	ret

.alreadyfail
	ld a, 3
	ret

.cannotsurf
	ld a, 2
	ret

.DoSurf
	call GetSurfType
	ld [wFieldMoveSurfType], a
	call GetPartyNick
	ld hl, SurfFromMenuScript
	call QueueScript
	ld a, $81
	ret

.FailSurf
	ld hl, CantSurfText
	call MenuTextBoxBackup
	ld a, $80
	ret

.AlreadySurfing
	ld hl, AlreadySurfingText
	call MenuTextBoxBackup
	ld a, $80
	ret

.FastCurrentText
	text_jump FastCurrentText

SurfFromMenuScript:
	special UpdateTimePals

UsedSurfScript:
	writetext UsedSurfText ; "used SURF!"
	waitbutton
	closetext
	fieldmovepokepic
	copybytetovar wFieldMoveSurfType
	writevarcode VAR_MOVEMENT

	special ReplaceKrisSprite
	special PlayMapMusic
; step into the water
	special Special_SurfStartStep ; (slow_step_x, step_end)
	applymovement PLAYER, wMovementBuffer ; PLAYER, MovementBuffer
	scriptstartasm
	ld a, [wPlayerDirection]
	srl a
	srl a
	and 3
	ld [wPlayerStepDirection], a
	callba CheckMovingOffEdgeOfMap
	jr nc, .done
	ld a, MAPSETUP_CONNECTION
	ldh [hMapEntryMethod], a
	callba RunMapSetupScript
.done
	ld hl, 0
	ret

UsedSurfText:
	text_jump _UsedSurfText

CantSurfText:
	text_jump _CantSurfText

AlreadySurfingText:
	text_jump _AlreadySurfingText

GetSurfType:
; Surfing on Pikachu uses an alternate sprite.
; This is done by using a separate movement type.

	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de

	ld a, [hl]
	cp PIKACHU
	ld a, PLAYER_SURF_PIKA
	ret z
	ld a, PLAYER_SURF
	ret

CheckDirection:
; Return carry if a tile permission prevents you
; from moving in the direction you're facing.

; Get player direction
	ld a, [wPlayerDirection]
	and %00001100 ; bits 2 and 3 contain direction
	rrca
	rrca
	ld e, a
	ld d, 0
	ld hl, .Directions
	add hl, de

; Can you walk in this direction?
	ld a, [wTilePermissions]
	and [hl]
	ret z
	scf
	ret

.Directions
	db FACE_DOWN
	db FACE_UP
	db FACE_LEFT
	db FACE_RIGHT

TrySurfOW::
; Checking a tile in the overworld.
; Return carry if fail is allowed.

; Don't ask to surf if already fail.
	ld a, [wPlayerState]
	cp PLAYER_SURF_PIKA
	ret z ; z implies nc
	cp PLAYER_SURF
	ret z

; Must be facing water.
	ld a, [wTempFacingTile]
	call GetTileCollision
	assert WATERTILE == 1
	dec a
	jr nz, .quit

; Check tile permissions.
	call CheckDirection
	ccf
	ret nc

	CheckEngine ENGINE_HAZEBADGE
	jr z, .quit

	ld d, SURF
	call CheckPartyMove
	jr c, .quit

	ld hl, wBikeFlags
	bit 1, [hl] ; always on bike (can't surf)
	jr nz, .quit

	ld hl, wMapGroup
	ld a, [hli]
	cp GROUP_SAXIFRAGE_ISLAND
	jr nz, .notInSaxifrage
	ld a, [hl]
	cp MAP_SAXIFRAGE_ISLAND
	jr z, .inSaxifrage

.notInSaxifrage
	call GetSurfType
	ld [wFieldMoveSurfType], a
	call GetPartyNick

	ld hl, AskSurfScript
	jr .script

.inSaxifrage
	ld hl, NoSurfSaxifrageScript
.script
	ld a, BANK(NoSurfSaxifrageScript)
	jp CallScript

.quit
	xor a
	ret

NoSurfSaxifrageScript:
	jumptext CantSurfSaxifrageText

AskSurfScript:
	opentext
	farwritetext AskSurfText
	yesorno
	iftrue UsedSurfScript
	closetextend

FlyFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
 	dw .TryFly
 	dw .DoFly
 	dw .FailFly
	dw .FailFlyNoMessage

.TryFly
	CheckEngine ENGINE_MIDNIGHTBADGE
	jp z, .nostormbadge
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .outdoors
	ld a, 2
	ret

.outdoors
	ld a, [wMapGroup]
	cp GROUP_SAXIFRAGE_ISLAND
	jr nz, .notSaxifrage
	CheckEngine ENGINE_RAUCOUSBADGE
	jr z, .cantFlySaxifrage
.notSaxifrage
	ld a, [wMapGroup]
	cp GROUP_SOUTH_RIJON_GATE
	jr nz, .notSouthRijon
	ld a, [wMapNumber]
	cp MAP_SOUTH_RIJON_GATE
	jr z, .no
.notSouthRijon
	ld a, [wEventFlags + (EVENT_IN_UNDERCOVER_MISSION / 8)]
	bit (EVENT_IN_UNDERCOVER_MISSION % 8), a
	jr nz, .inUndercoverMission

	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .in_park_minigame

	callba RegionCheck
	ld a, e
	cp REGION_KANTO
	jr z, .no
	cp REGION_SEVII
	jr z, .no
	cp REGION_MYSTERY
	jr z, .no
	cp REGION_TUNOD
	jr z, .tunod_check
	cp REGION_JOHTO
	jr nz, .ok

.johto_check
	ld b, 3
	jr .region_check

.tunod_check
	ld b, 8
.region_check
	ld a, [wVisitedSpawns + 3]
	and b
	jr z, .no

.ok
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocation

	xor a
	ldh [hMapAnims], a
	call LoadStandardMenuHeader
	call ClearSprites
	callba _FlyMap
	ld a, e
	cp -1
	jr z, .illegal
	cp NUM_SPAWNS
	jr nc, .illegal

	ld [wd001], a
	call CloseWindow
	ld a, 1
	ret

.no
	ld hl, CantUseFlyHere
.error_message_loaded
	call MenuTextBox
	call CloseWindow
	ld a, 3
	ret

.inUndercoverMission
	ld hl, CantFlyUndercover
	jr .error_message_loaded

.cantFlySaxifrage
	ld hl, CantFlySaxifrage
	jr .error_message_loaded

.in_park_minigame
	ld hl, CantFlyParkChallenge
	jr .error_message_loaded

.nostormbadge
	call PrintNoBadgeText
	ld a, $82
	ret

.illegal
	call CloseWindow
	call ApplyTilemapInVBlank
	ld a, $80
	ret

.DoFly
	ld hl, .FlyScript
	call QueueScript
	ld a, $81
	ret

.FailFly
	call FieldMoveFailed
.FailFlyNoMessage
	ld a, $82
	ret

.FlyScript
	reloadmappart
	callasm HideSprites
	special UpdateTimePals
	fieldmovepokepic
	callasm FlyFromAnim
	callasm DelayLoadingNewSprites
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	newloadmap MAPSETUP_FLY
	callasm FlyToAnim
	waitsfx
	callasm .ReturnFromFly
	setevent EVENT_USED_FLY_AT_LEAST_ONCE
	end

.ReturnFromFly
	callba ReturnFromFly_SpawnOnlyPlayer
	call DelayFrame
	jp ReplaceKrisSprite

CantUseFlyHere:
	text_jump _CantUseFlyHere

CantFlyUndercover:
	text_jump _CantFlyUndercover

CantFlySaxifrage:
	text_jump _CantFlySaxifrage

CantFlyParkChallenge:
	text_jump _CantFlyParkChallenge

EscapeRopeFunction:
	call ClearFieldMoveBuffer
	ld a, 1
	jr Dig_InCave

DigFunction:
	call ClearFieldMoveBuffer
	ld a, 2
	; fallthrough

Dig_InCave:
	ld [wFieldMoveEscapeType], a
.loop
	ld hl, .DigTable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.DigTable
	dw .CheckCanDig
	dw .DoDig
	dw .FailDig

.CheckCanDig
	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .fail
	call GetMapPermission
	cp CAVE
	jr z, .incave
	cp DUNGEON
	jr z, .incave
.fail
	ld a, 2
	ret

.incave
	ld hl, wDigWarp
	ld a, [hli]
	and a
	jr z, .fail
	ld a, [hli]
	and a
	jr z, .fail
	ld a, [hl]
	and a
	jr z, .fail
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .fail
	ld a, 1
	ret

.DoDig
	ld hl, wDigWarp
	ld de, wNextWarp
	ld bc, 3
	rst CopyBytes
	call GetPartyNick
	ld a, [wFieldMoveEscapeType]
	cp 2
	jr nz, .escaperope
	ld hl, .UsedDigScript
	call QueueScript
	ld a, $81
	ret

.escaperope
	;callba SpecialKabutoChamber
	ld hl, .UsedEscapeRopeScript
	call QueueScript
	ld a, $81
	ret

.FailDig
	ld a, [wFieldMoveEscapeType]
	cp 2
	jr nz, .failescaperope
	ld hl, .Text_CantUseHere
	call MenuTextBox
	call WaitPressAorB_BlinkCursor
	call CloseWindow

.failescaperope
	ld a, $80
	ret

.Text_UsedDig
	; used DIG!
	text_jump UsedDigText

.Text_UsedEscapeRope
	; used an ESCAPE ROPE.
	text_jump UsedRopeText

.Text_CantUseHere
	; Can't use that here.
	text_jump FailDigText

.UsedEscapeRopeScript
	reloadmappart
	special UpdateTimePals
	writetext .Text_UsedEscapeRope
	waitbutton
	closetext
	jump .UsedDigOrEscapeRopeScript

.UsedDigScript
	reloadmappart
	special UpdateTimePals
	writetext .Text_UsedDig
	waitbutton
	closetext
	fieldmovepokepic
	; fallthrough

.UsedDigOrEscapeRopeScript
	playsound SFX_WARP_TO
	applymovement PLAYER, .DigOut
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	newloadmap MAPSETUP_DOOR
	playsound SFX_WARP_FROM
	applymovement PLAYER, .DigReturn
	end

.DigOut
	step_dig 32
	hide_person
	step_end

.DigReturn
	show_person
	return_dig 32
	step_end

TeleportFunction:
	call ClearFieldMoveBuffer
.loop
	ld hl, .Jumptable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.Jumptable
	dw .TryTeleport
	dw .DoTeleport
	dw .FailTeleport

.TryTeleport
	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .nope
	ld a, [wEventFlags + (EVENT_IN_UNDERCOVER_MISSION / 8)]
	bit (EVENT_IN_UNDERCOVER_MISSION % 8), a
	jr nz, .nope
	call GetMapPermission
	call CheckOutdoorMap
	jr nz, .nope

	ld a, [wLastSpawnMapGroup]
	ld d, a
	ld a, [wLastSpawnMapNumber]
	ld e, a
	callba IsSpawnPoint
	jr nc, .nope
	ld a, c
	ld [wd001], a
	ld a, 1
	ret

.nope
	ld a, 2
	ret

.DoTeleport
	call GetPartyNick
	ld hl, .TeleportScript
	call QueueScript
	ld a, $81
	ret

.FailTeleport
	ld hl, .Text_CantUseHere
	call MenuTextBoxBackup
	ld a, $80
	ret

.Text_CantUseHere
	; Can't use that here.
	text_jump FailTeleportText

.TeleportScript
	reloadmappart
	special UpdateTimePals
	fieldmovepokepic
	playsound SFX_WARP_TO
	applymovement PLAYER, .TeleportFrom
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	newloadmap MAPSETUP_TELEPORT
	playsound SFX_WARP_FROM
	applymovement PLAYER, .TeleportTo
	end

.TeleportFrom
	teleport_from
	step_end

.TeleportTo
	teleport_to
	step_end

StrengthFunction:
	call .TryStrength
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.TryStrength
	CheckEngine ENGINE_CHARMBADGE
	jr z, .Failed
	ld hl, Script_StrengthFromMenu
	call QueueScript
	ld a, $81
	ret

.Failed
	call PrintNoBadgeText
	ld a, $80
	ret

SetStrengthFlag:
	ld hl, wBikeFlags
	set 0, [hl]
	call GetPartyNick
GetPartyMonUsingFieldMove:
	ld a, [wPlayerState]
	and a
	call z, .LoadGFX
	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	ld [wFieldMovePokepicSpecies], a
	ld a, MON_DVS
	call GetPartyParamLocation
	ld de, wTempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

.LoadGFX
	ldh a, [rVBK]
	push af
	vbk BANK(vStandingFrameTiles)
	ld a, [wPlayerCharacteristics]
	ld hl, Player12FieldMoveSpriteGFX
	and $f
	cp $c
	jr nc, .setGFX

	ld hl, FieldMoveSpriteGFX
	ld bc, 8 tiles
	rst AddNTimes

.setGFX
	ld d, h
	ld e, l
	lb bc, BANK(FieldMoveSpriteGFX), 4
	push bc
	push de
	ld hl, vStandingFrameTiles tile $00
	call Request2bpp
	pop hl
	ld de, 4 tiles
	add hl, de
	ld d, h
	ld e, l
	pop bc
	ld hl, vFontTiles tile $00
	call Request2bpp
	pop af
	ldh [rVBK], a
	ret

Script_StrengthFromMenu:
	reloadmappart
	special UpdateTimePals

Script_UsedStrength:
	checkflag ENGINE_POKEMON_MODE
	sif false, then
		closetext
		callasm SetStrengthFlag
		checkcode VAR_MOVEMENT
		sif false, then
			applymovement PLAYER, FieldMoveMovement
			special ReplaceKrisSprite
		sendif
		copybytetovar wFieldMovePokepicSpecies
		callasm FieldMovePokepicScript.pokepicwithshinycheck
		cry 0
		waitsfx
		closepokepic
		opentext
	sendif
	farjumptext StrengthText

AskStrengthScript:
	callasm TryStrengthOW
	anonjumptable
	dw .AskStrength
	dw .DontMeetRequirements
	dw .AlreadyUsedStrength

.DontMeetRequirements
	jumptext DontMeetRequirementsText

.AlreadyUsedStrength
	jumptext AlreadyUsedStrengthText

.AskStrength
	opentext
	writetext AskStrengthText
	yesorno
	iftrue Script_UsedStrength
	closetextend

AskStrengthText:
	; A #mon may be able to move this. Want to use STRENGTH?
	text_jump AskStrength

AlreadyUsedStrengthText:
	; Boulders may now be moved!
	text_jump AlreadyUsedStrength

DontMeetRequirementsText:
	; A #mon may be able to move this.
	text_jump DontMeetStrengthRequirements

TryStrengthOW:
	ld d, STRENGTH
	call CheckPartyMove
	jr c, .nope

	CheckEngine ENGINE_HAZEBADGE
	jr z, .nope

	CheckEngine ENGINE_STRENGTH_ACTIVE
	jr z, .allow_use

	ld a, 2
	jr .done

.nope
	ld a, 1
	jr .done

.allow_use
	xor a

.done
	ldh [hScriptVar], a
	ret

HeadbuttFunction:
	call TryHeadbuttFromMenu
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

TryHeadbuttFromMenu:
	call GetFacingTileCoord
	cp COLL_HEADBUTT_TREE
	jr nz, .no_tree

	ld hl, HeadbuttFromMenuScript
	call QueueScript
	ld a, $81
	ret

.no_tree
	call FieldMoveFailed
	ld a, $80
	ret

HeadbuttText:
	; did a HEADBUTT!
	text_jump _HeadbuttText

HeadbuttFromMenuScript:
	reloadmappart
	special UpdateTimePals

HeadbuttScript:
	callasm GetPartyNick
	writetext HeadbuttText
	fieldmovepokepic
	callasm ShakeHeadbuttTree

	callasm TreeMonEncounter
	sif false
		farjumptext HeadbuttFailText
	closetext
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

TryHeadbuttOW::
	ld d, HEADBUTT
	call CheckPartyMove
	ccf
	ret nc

	ld a, BANK(AskHeadbuttScript)
	ld hl, AskHeadbuttScript
	jp CallScript

AskHeadbuttScript:
	opentext
	farwritetext AskHeadbutt
	yesorno
	iftrue HeadbuttScript
	closetextend

RockSmashFunction:
	call TryRockSmashFromMenu
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

TryRockSmashFromMenu:
	CheckEngine ENGINE_MUSCLEBADGE
	jr z, .nobadge
	call GetFacingObject
	jr c, .no_rock
	ld a, d
	cp $18
	jr nz, .no_rock

	ld hl, RockSmashFromMenuScript
	call QueueScript
	ld a, $81
	ret

.no_rock
	call FieldMoveFailed
	ld a, $80
	ret

.nobadge
	call PrintNoBadgeText
	ld a, $80
	ret

GetFacingObject:
	callba CheckFacingObject
	ccf
	ret c

	ldh a, [hObjectStructIndexBuffer]
	call GetObjectStruct
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	ldh [hLastTalked], a
	call GetMapObject
	ld hl, MAPOBJECT_MOVEMENT
	add hl, bc
	ld a, [hl]
	ld d, a
	and a
	ret

RockSmashFromMenuScript:
	reloadmappart
	special UpdateTimePals

RockSmashScript::
	callasm GetPartyNick
	farwritetext RockSmashText
	closetext
	fieldmovepokepic
	playsound SFX_STRENGTH
	earthquake 84
	applymovement2 .movement
	disappear LAST_TALKED

	callasm RockMonEncounter
	copybytetovar wTempWildMonSpecies
	sif false
		end
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

.movement
	rock_smash 10
	step_end

AskRockSmashScript:
	callasm CanUseRockSmash
	sif =, 1
		farjumptext FarText_BreakableRock_NoHM
	opentext
	farwritetext FarText_BreakableRock_HasHM
	yesorno
	iftrue RockSmashScript
	closetextend

CanUseRockSmash::
	CheckEngine ENGINE_MUSCLEBADGE
	jr z, .no
	ld d, ROCK_SMASH
	call CheckPartyMove
	jr nc, .yes

.no
	ld a, 1
	jr .done

.yes
	xor a

.done
	ldh [hScriptVar], a
	ret

TryCutOW::
	ld d, CUT
	call CheckPartyMove
	jr c, .cant_cut

	CheckEngine ENGINE_NATUREBADGE
	jr z, .cant_cut

	ld a, BANK(AskCutScript)
	ld hl, AskCutScript
	jr .call_script_set_carry

.cant_cut
	ld a, BANK(CantCutScript)
	ld hl, CantCutScript
.call_script_set_carry
	jp CallScript

AskCutScript:
	opentext
	farwritetext AskCutText
	yesorno
	sif false
		closetextend
	callasm .CheckMap
	iftrue Script_Cut
	closetextend

.CheckMap
	xor a
	ldh [hScriptVar], a
	call CheckMapForSomethingToCut
	ret c
	ld a, TRUE
	ldh [hScriptVar], a
	ret

CantCutScript:
	farjumptext CantCutText

ClearFieldMoveBuffer:
	xor a
	ld hl, wFieldMoveBufferSpace
	ld bc, wFieldMoveBufferSpaceEnd - wFieldMoveBufferSpace
	jp ByteFill

FieldMoveJumptable:
	ld a, [wFieldMoveJumptableIndex]
	call OldJumpTable
	ld [wFieldMoveJumptableIndex], a
	bit 7, a
	jr nz, .okay
	and a
	ret

.okay
	and $7f
	scf
	ret

GetPartyNick:
; write wCurPartyMon nickname to wStringBuffer1-3
	ld hl, wPartyMonNicknames
	ld a, BOXMON
	ld [wMonType], a
	ld a, [wCurPartyMon]
	call GetNick
	call CopyName1
; copy text from wStringBuffer2 to wStringBuffer3
	ld de, wStringBuffer2
	ld hl, wStringBuffer3
	jp CopyName2

CantSurfSaxifrageText::
	text_jump _CantSurfSaxifrageText

PrintNoBadgeText:
; Check engine flag a (ENGINE_ZEPHYRBADGE thru ENGINE_EARTHBADGE)
; Display "Badge required" text and return carry if the badge is not owned
	ld hl, .BadgeRequiredText
	jp MenuTextBoxBackup ; push text to queue

.BadgeRequiredText
	; Sorry! A new BADGE
	; is required.
	text_jump _BadgeRequiredText

CheckPartyMove:
; Check if a monster in your party has move d.

	ld e, 0
	xor a
	ld [wCurPartyMon], a
.loop
	ld c, e
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	scf ; inc and dec leave the carry alone
	inc a
	ret z
	dec a
	ret z
	cp EGG
	jr z, .next

	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Moves
	ld a, e
	rst AddNTimes
	ld b, NUM_MOVES
.check
	ld a, [hli]
	cp d
	jr z, .yes
	dec b
	jr nz, .check

.next
	inc e
	jr .loop

.yes
	ld a, e
	ld [wCurPartyMon], a ; which mon has the move
	xor a
	ret
