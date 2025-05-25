CheckTriggers::
; Checks wCurrentMapTriggerPointer.  If it's empty, returns -1 in a.  Otherwise, returns the active trigger ID in a.
	push hl
	ld hl, wCurrentMapTriggerPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ld a, [hl]
	jr nz, .triggerexists
	ld a, -1

.triggerexists
	pop hl
	ret

GetCurrentMapTrigger::
; Grabs the wram map trigger pointer for the current map and loads it into wCurrentMapTriggerPointer.
; If there are no triggers, both bytes of wCurrentMapTriggerPointer are wiped clean.
; Copy the current map group and number into bc.  This is needed for GetMapTrigger.
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
; Blank out wCurrentMapTriggerPointer; this is the default scenario.
	xor a
	ld [wCurrentMapTriggerPointer], a
	ld [wCurrentMapTriggerPointer + 1], a
	call GetMapTrigger
	ret c ; The map is not in the trigger table
; Load the trigger table pointer from de into wCurrentMapTriggerPointer
	ld a, e
	ld [wCurrentMapTriggerPointer], a
	ld a, d
	ld [wCurrentMapTriggerPointer + 1], a
	xor a
	ret

GetMapTrigger::
; Searches the trigger table for the map group and number loaded in bc, and returns the wram pointer in de.
; If the map is not in the trigger table, returns carry.
	anonbankpush MapTriggers
	; end of function

	ld hl, MapTriggers
	ld de, 4
	jr .handleLoop
.loop
	pop hl
	add hl, de
.handleLoop
	push hl
	ld a, [hli] ; map group, or terminator
	cp -1
	jr z, .end ; the current map is not in the trigger table
	cp b
	jr nz, .loop ; map group did not match
	ld a, [hli] ; map number
	cp c
	jr nz, .loop ; map number did not match
	ld a, [hli]
	ld d, [hl]
	ld e, a
	jr .done
.end
	scf
.done
	pop hl
	ret

OverworldTextModeSwitch::
LoadMapPart::
	jpba _LoadMapPart

ReturnToMapFromSubmenu::
	ld a, MAPSETUP_SUBMENU
	ldh [hMapEntryMethod], a
	callba RunMapSetupScript
	xor a
	ldh [hMapEntryMethod], a
	ret

CheckWarpTile::
	call GetDestinationWarpNumber
	ret nc

	push bc
	callba CheckDirectionalWarp
	pop bc
	ret nc

	call CopyWarpData
	scf
	ret

WarpCheck::
	call GetDestinationWarpNumber
	ret nc
	jp CopyWarpData

GetDestinationWarpNumber::
	callba CheckWarpCollision
	ret nc
	call StackCallInMapScriptHeaderBank

.GetDestinationWarpNumber:
	ld a, [wPlayerStandingMapY]
	sub 4
	ld e, a
	ld a, [wPlayerStandingMapX]
	sub 4
	ld d, a
	ld a, [wCurrMapWarpCount]
	and a
	ret z

	ld c, a
	ld hl, wCurrMapWarpHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	push hl
	ld a, [hli]
	cp e
	jr nz, .next
	ld a, [hli]
	cp d
	jr z, .found_warp

.next
	pop hl
	ld a, 5
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	dec c
	jr nz, .loop
	xor a
	ret

.found_warp
	pop hl
	inc hl
	inc hl

	ld a, [wCurrMapWarpCount]
	inc a
	sub c
	ld c, a
	scf
	ret

CopyWarpData::
	call StackCallInMapScriptHeaderBank

.CopyWarpData
	push bc
	ld hl, wCurrMapWarpHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	dec a
	ld bc, 5 ; warp size
	rst AddNTimes
	ld bc, 2 ; warp number
	add hl, bc
	ld a, [hli]
	cp $ff
	jr nz, .skip
	ld hl, wBackupWarpNumber
	ld a, [hli]

.skip
	pop bc
	ld [wNextWarp], a
	ld a, [hli]
	ld [wNextMapGroup], a
	ld a, [hli]
	ld [wNextMapNumber], a

	ld a, c
	ld [wPrevWarp], a
	ld a, [wMapGroup]
	ld [wPrevMapGroup], a
	ld a, [wMapNumber]
	ld [wPrevMapNumber], a
	scf
	ret

CheckOutdoorMap::
	cp ROUTE
	ret z
	cp TOWN
	ret

CheckIndoorMap::
	cp INDOOR
	ret z
	cp CAVE
	ret z
	cp DUNGEON
	ret z
	cp GATE
	ret

LoadMapAttributes::
	call CopyMapHeaders
	call SwitchToMapScriptHeaderBank
	call ReadMapScripts
	xor a
	jp ReadMapEventHeader

LoadMapAttributes_SkipPeople::
	call CopyMapHeaders
	call SwitchToMapScriptHeaderBank
	call ReadMapScripts
	ld a, 1
	jp ReadMapEventHeader

CopyMapHeaders::
	call PartiallyCopyMapHeader
	call SwitchToMapBank
	call GetSecondaryMapHeaderPointer
	call CopySecondMapHeader
	jp GetMapConnections

ReadMapEventHeader::
	push af
	ld hl, wMapEventHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	call ReadWarps
	call ReadCoordEvents
	call ReadSignposts

	pop af
	and a
	ret nz

	jp ReadObjectEvents

ReadMapScripts::
	ld hl, wMapScriptHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ReadMapTriggers
	jp ReadMapCallbacks

CopySecondMapHeader::
	ld de, wMapHeader
	ld bc, 12 ; size of the second map header
	rst CopyBytes
	ret

GetMapConnections::
	ld a, $ff
	ld [wNorthConnectedMapGroup], a
	ld [wSouthConnectedMapGroup], a
	ld [wWestConnectedMapGroup], a
	ld [wEastConnectedMapGroup], a

	ld a, [wMapConnections]
	swap a

	add a
	ld de, wNorthMapConnection
	call c, GetMapConnection

	add a
	ld de, wSouthMapConnection
	call c, GetMapConnection

	add a
	ld de, wWestMapConnection
	call c, GetMapConnection

	add a
	ret nc
	ld de, wEastMapConnection

GetMapConnection::
; Load map connection struct at hl into de.
	push af
	ld bc, wSouthMapConnection - wNorthMapConnection
	rst CopyBytes
	pop af
	ret

ReadMapTriggers::
	ld a, [hli] ; trigger count
	ld c, a
	ld [wCurrMapTriggerCount], a ; current map trigger count
	ld a, l
	ld [wCurrMapTriggerHeaderPointer], a ; map trigger pointer
	ld a, h
	ld [wCurrMapTriggerHeaderPointer + 1], a
	ld a, c
	and a
	ret z

	ld bc, 4 ; size of a map trigger header entry
	rst AddNTimes
	ret

ReadMapCallbacks::
	ld a, [hli]
	ld c, a
	ld [wCurrMapCallbackCount], a
	ld a, l
	ld [wCurrMapCallbackHeaderPointer], a
	ld a, h
	ld [wCurrMapCallbackHeaderPointer + 1], a
	ld a, c
	and a
	ret z

	ld bc, 3
	rst AddNTimes
	ret

ReadWarps::
	ld a, [hli]
	ld c, a
	ld [wCurrMapWarpCount], a
	ld a, l
	ld [wCurrMapWarpHeaderPointer], a
	ld a, h
	ld [wCurrMapWarpHeaderPointer + 1], a
	ld a, c
	and a
	ret z
	ld bc, 5
	rst AddNTimes
	ret

ReadCoordEvents::
	ld a, [hli]
	ld c, a
	ld [wCurrentMapXYTriggerCount], a
	ld a, l
	ld [wCurrentMapXYTriggerHeaderPointer], a
	ld a, h
	ld [wCurrentMapXYTriggerHeaderPointer + 1], a

	ld a, c
	ld bc, XY_TRIGGER_SIZE
	rst AddNTimes
	ret

ReadSignposts::
	ld a, [hli]
	ld c, a
	ld [wCurrentMapSignpostCount], a
	ld a, l
	ld [wCurrentMapSignpostHeaderPointer], a
	ld a, h
	ld [wCurrentMapSignpostHeaderPointer + 1], a

	ld a, c
	and a
	ret z

	ld bc, 5
	rst AddNTimes
	ret

ReadObjectEvents::
	push hl
	call ClearObjectStructs
	pop de
	ld hl, wMap1Object
	ld a, [de]
	inc de
	ld [wCurrentMapPersonEventCount], a
	ld a, e
	ld [wCurrentMapPersonEventHeaderPointer], a
	ld a, d
	ld [wCurrentMapPersonEventHeaderPointer + 1], a

	ld a, [wCurrentMapPersonEventCount]
	call CopyMapObjectHeaders

; get NUM_OBJECTS - [wCurrentMapPersonEventCount]
	ld a, [wCurrentMapPersonEventCount]
	cp NUM_OBJECTS
	jr nc, .skip
	; a = NUM_OBJECTS - a
	cpl
	add NUM_OBJECTS + 1

	inc hl
; Fill the remaining sprite IDs and y coords with 0 and -1, respectively.
	ld bc, OBJECT_LENGTH
.loop
	ld [hl], 0
	inc hl
	ld [hl], -1
	dec hl
	add hl, bc
	dec a
	jr nz, .loop

.skip
	ld h, d
	ld l, e
	ret

CopyMapObjectHeaders::
	and a
	ret z

	ld c, a
.loop
	push bc
	push hl
	ld a, $ff
	ld [hli], a
	ld b, MAPOBJECT_E - MAPOBJECT_SPRITE
.loop2
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop2

	pop hl
	ld bc, OBJECT_LENGTH
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

ClearObjectStructs::
	ld hl, wObject1Struct
	ld bc, OBJECT_STRUCT_LENGTH * (NUM_OBJECT_STRUCTS - 1)
	xor a
	jp ByteFill

RestoreFacingAfterWarp::
	call SwitchToMapScriptHeaderBank

	ld hl, wMapEventHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl ; get to the warp coords
	inc hl
	inc hl
	ld a, [wWarpNumber]
	dec a
	ld c, a
	ld b, 0
	ld a, 5
	rst AddNTimes
	ld a, [hli]
	ld [wYCoord], a
	ld a, [hli]
	ld [wXCoord], a
	; destination warp number
	ld a, [hli]
	cp $ff
	jr nz, .skip
	ld a, [wPrevWarp]
	ld [wBackupWarpNumber], a
	ld a, [wPrevMapGroup]
	ld [wBackupMapGroup], a
	ld a, [wPrevMapNumber]
	ld [wBackupMapNumber], a
.skip
	jpba GetCoordOfUpperLeftCorner

SwitchToMapScriptHeaderBank:
	ld a, [wMapScriptHeaderBank]
	jp Bankswitch

LoadBlockData::
	ldh a, [hVBlank]
	push af
	ld a, 2
	ldh [hVBlank], a
	ld hl, wOverworldMap
	ld bc, wOverworldMapEnd - wOverworldMap
	xor a
	call ByteFill
	call ChangeMap
	call FillMapConnections
	ld a, MAPCALLBACK_TILES
	call RunMapCallback
	pop af
	ldh [hVBlank], a
	ret

ChangeMap::
	ld a, [wMapBlockDataBank]
	ld b, a
	ld hl, wMapBlockDataPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMapWidth]
	ld d, a
	ld a, [wMapHeight]
	ld e, a

	call RunFunctionInWRA6
	; end of function

	push de
	call FarDecompressAtB_D000
	pop de

	ld a, d
	ldh [hConnectedMapWidth], a
	add 6
	ldh [hConnectionStripLength], a
	ld hl, wOverworldMap

	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, 3
	add hl, bc

	ld b, e
	ld de, wDecompressScratch
.row
	push hl
	ldh a, [hConnectedMapWidth]
	ld c, a
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ldh a, [hConnectionStripLength]
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	dec b
	jr nz, .row
	ret

DecompressConnectionMap:
	push de
	push bc
	call DecompressWRA6
	pop bc
	pop de
	ret

FillMapConnections::
	; North
	ld a, [wNorthConnectedMapGroup]
	cp $ff
	jr z, .South
	ld b, a
	ld a, [wNorthConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld hl, wNorthConnectionStripPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wNorthConnectionStripLocation]
	ld e, a
	ld a, [wNorthConnectionStripLocation + 1]
	ld d, a
	ld a, [wNorthConnectionStripLength]
	ldh [hConnectionStripLength], a
	ld a, [wNorthConnectedMapWidth]
	ldh [hConnectedMapWidth], a
	call FillNorthConnectionStrip

.South
	ld a, [wSouthConnectedMapGroup]
	cp $ff
	jr z, .West
	ld b, a
	ld a, [wSouthConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld hl, wSouthConnectionStripPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wSouthConnectionStripLocation]
	ld e, a
	ld a, [wSouthConnectionStripLocation + 1]
	ld d, a
	ld a, [wSouthConnectionStripLength]
	ldh [hConnectionStripLength], a
	ld a, [wSouthConnectedMapWidth]
	ldh [hConnectedMapWidth], a
	call FillSouthConnectionStrip

.West
	ld a, [wWestConnectedMapGroup]
	cp $ff
	jr z, .East
	ld b, a
	ld a, [wWestConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld hl, wWestConnectionStripPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wWestConnectionStripLocation]
	ld e, a
	ld a, [wWestConnectionStripLocation + 1]
	ld d, a
	ld a, [wWestConnectionStripLength]
	ld b, a
	ld a, [wWestConnectedMapWidth]
	ldh [hConnectionStripLength], a
	call FillWestConnectionStrip

.East
	ld a, [wEastConnectedMapGroup]
	cp $ff
	ret z
	ld b, a
	ld a, [wEastConnectedMapNumber]
	ld c, a
	call GetAnyMapBlockdataBankPointer
	call DecompressConnectionMap

	ld hl, wEastConnectionStripPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wEastConnectionStripLocation]
	ld e, a
	ld a, [wEastConnectionStripLocation + 1]
	ld d, a
	ld a, [wEastConnectionStripLength]
	ld b, a
	ld a, [wEastConnectedMapWidth]
	ldh [hConnectionStripLength], a

; fallthrough
FillWestConnectionStrip::
FillEastConnectionStrip::
	ld a, [wMapWidth]
	add 6
	ldh [hConnectedMapWidth], a

	call RunFunctionInWRA6
	; end of function

.loop
	push de

	push hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop hl

	ldh a, [hConnectionStripLength]
	ld e, a
	ld d, 0
	add hl, de
	pop de

	ldh a, [hConnectedMapWidth]
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	dec b
	jr nz, .loop
	ret

FillNorthConnectionStrip::
FillSouthConnectionStrip::
	ld a, [wMapWidth]
	add 6
	ldh [hMapWidthPlus6], a
	call RunFunctionInWRA6
	; end of function

	ld c, 3
.y
	push de

	push hl
	ldh a, [hConnectionStripLength]
	ld b, a
.x
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .x
	pop hl

	ldh a, [hConnectedMapWidth]
	ld e, a
	ld d, 0
	add hl, de
	pop de

	ldh a, [hMapWidthPlus6]
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	dec c
	jr nz, .y
	ret

LoadTilesetCollisionOnly:
	jr LoadMetatilesTilecoll.collision

LoadMetatilesTilecoll:
	ld hl, wTilesetBlocksBank
	ld de, wDecompressedMetatiles
	ld c, BANK(wDecompressedMetatiles)
	call .Decompress

	ld hl, wTilesetAttributesBank
	ld de, wDecompressedAttributes
	ld c, BANK(wDecompressedAttributes)
	call .Decompress

.collision
	ld hl, wTilesetCollisionBank
	ld de, wDecompressedCollision
	ld c, BANK(wDecompressedCollision)

; fallthrough
.Decompress:
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	call StackCallInWRAMBankA
	; jumps to the function after switching WRAM banks for the duration of the call
	jp FarDecompressAtB_DE

CallMapScript::
; Call a script at hl in the current bank if there isn't already a script running
	ld a, [wScriptRunning]
	and a
	ret nz
	ld a, [wMapScriptHeaderBank]

CallScript::
; Call a script at a:hl.

	ld [wScriptBank], a
	ld a, l
	ld [wScriptPos], a
	ld a, h
	ld [wScriptPos + 1], a

	ld a, PLAYEREVENT_MAPSCRIPT
	ld [wScriptRunning], a

	scf
	ret

RunMapCallback::
; Will run the first callback found in the map header with execution index equal to a.
	ld b, a
	call StackCallInMapScriptHeaderBank
	; end of function

	call .FindCallback
	ret nc

	ld a, [wMapScriptHeaderBank]
	ld b, a
	ld d, h
	ld e, l
	jp ExecuteCallbackScript

.FindCallback
	ld a, [wCurrMapCallbackCount]
	ld c, a
	and a
	ret z
	ld hl, wCurrMapCallbackHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld de, 3
.loop
	ld a, [hl]
	cp b
	jr z, .found
	add hl, de
	dec c
	jr nz, .loop
	xor a
	ret

.found
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	scf
	ret

RunScriptFromASM::
; very much a hack
; more variables will be protected when recognized
	ld hl, wScriptFlags
	ld a, [hl]
	push af
	set 4, [hl]
	call ExecuteCallbackScript
	pop af
	ld [wScriptFlags], a
	ret

ExecuteCallbackScript::
; Do map callback de and return to script bank b.
	callba CallCallback
	ld a, [wScriptMode]
	push af
	ld hl, wScriptFlags
	ld a, [hl]
	push af
	set 1, [hl]
	callba EnableScriptMode
	callba ScriptEvents
	pop af
	ld [wScriptFlags], a
	pop af
	ld [wScriptMode], a
	ret

MapTextbox::
	ld a, b
	call StackCallInBankA
LocalMapTextbox::
	push hl
	call SpeechTextBox
	call SafeUpdateSprites
	ld a, 1
	ldh [hOAMUpdate], a
	call ApplyTilemap
	pop hl
	call PrintTextBoxText
	xor a
	ldh [hOAMUpdate], a
	ret

PeekScriptByte::
	push hl
	ld hl, wScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wScriptBank]
	call GetFarByte
	pop hl
	ret

GetScriptByte::
; Return byte at wScriptBank:wScriptPos in a.
	ld a, [wScriptBank]
	call StackCallInBankA
	; end of function

	push hl
	push de

	ld hl, wScriptPos
	ld a, [hli]
	ld d, [hl]
	ld e, a

	ld a, [de]
	inc de

	ld [hl], d
	dec hl
	ld [hl], e

	pop de
	pop hl
	ret

GetScriptHalfword::
; Return 16-bit value at wScriptBank:wScriptPos in hl.
	ld a, [wScriptBank]
	call StackCallInBankA
	; end of function

	ld hl, wScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a

	inc hl
	inc hl

	ld a, l
	ld [wScriptPos], a
	ld a, h
	ld [wScriptPos + 1], a

	dec hl
	ld a, [hld]
	ld l, [hl]
	ld h, a
	ret

GetScriptThreeBytes::
; Return 24-bit value at wScriptBank:wScriptPos in cde.
	push hl
	call GetScriptByte
	ld c, a
	call GetScriptHalfword
	ld d, l
	ld e, h
	pop hl
	ret

GetScriptWord::
; Return 32-bit value at wScriptBank:wScriptPos in bcde.
	push hl
	call GetScriptHalfword
	ld b, l
	ld c, h
	call GetScriptHalfword
	ld d, l
	ld e, h
	pop hl
	ret

ObjectEvent::
	jumptextfaceplayer ObjectEventText

ObjectEventText::
	text_jump _ObjectEventText

AddSignpostHeader::
	signpostheader 0
	text_jump _AddSignpostText

ScrollMapDown::
	hlcoord 0, 0
	ld de, wBGMapBuffer
	call BackupBGMapRow
	hlcoord 0, 0, wAttrMap
	ld de, wBGMapPalBuffer
	call BackupBGMapRow
	ld a, [wBGMapAnchor]
	ld e, a
	ld a, [wBGMapAnchor + 1]
	jr ScrollMapHorizontally_UpdateBGMapRow

ScrollMapUp::
	hlcoord 0, SCREEN_HEIGHT - 2
	ld de, wBGMapBuffer
	call BackupBGMapRow
	hlcoord 0, SCREEN_HEIGHT - 2, wAttrMap
	ld de, wBGMapPalBuffer
	call BackupBGMapRow
	ld hl, wBGMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0200
	add hl, bc
; cap d at HIGH(vWindowMap)
	ld a, h
	and 3
	or HIGH(vBGMap)
	ld e, l
ScrollMapHorizontally_UpdateBGMapRow:
	ld d, a
	call UpdateBGMapRow
	jr ScrollMap_SetBGMapUpdate

ScrollMapRight::
	hlcoord 0, 0
	ld de, wBGMapBuffer
	call BackupBGMapColumn
	hlcoord 0, 0, wAttrMap
	ld de, wBGMapPalBuffer
	call BackupBGMapColumn
	ld a, [wBGMapAnchor]
	jr ScrollMapHorizontally_UpdateBGMapColumn

ScrollMapLeft::
	hlcoord SCREEN_WIDTH - 2, 0
	ld de, wBGMapBuffer
	call BackupBGMapColumn
	hlcoord SCREEN_WIDTH - 2, 0, wAttrMap
	ld de, wBGMapPalBuffer
	call BackupBGMapColumn
	ld a, [wBGMapAnchor]
	ld e, a
	and %11100000
	ld b, a
	ld a, e
	add SCREEN_HEIGHT
	and %00011111
	or b
ScrollMapHorizontally_UpdateBGMapColumn:
	ld e, a
	ld a, [wBGMapAnchor + 1]
	ld d, a
	call UpdateBGMapColumn
ScrollMap_SetBGMapUpdate:
	ld a, 1
	ldh [hBGMapUpdate], a
	ret

BackupBGMapRow::
	ld c, 2 * SCREEN_WIDTH
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

BackupBGMapColumn::
	lb bc, SCREEN_WIDTH - 1, SCREEN_HEIGHT
.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, b
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	dec c
	jr nz, .loop
	ret

UpdateBGMapRow::
	ld hl, wBGMapBufferPtrs
	push de
	call .iteration
	pop de
	ld a, $20
	add e
	ld e, a

.iteration
	ld c, 10
.loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	inc a
	inc a
	and $1f
	ld b, a
	ld a, e
	and $e0
	or b
	ld e, a
	dec c
	jr nz, .loop
	ld a, SCREEN_WIDTH
	ldh [hBGMapTileCount], a
	ret

UpdateBGMapColumn::
	ld hl, wBGMapBufferPtrs
	lb bc, $20, SCREEN_HEIGHT
.loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, b
	add e
	ld e, a
	jr nc, .skip
	inc d
; cap d at HIGH(vWindowMap)
	res 2, d
.skip
	dec c
	jr nz, .loop
	ld a, SCREEN_HEIGHT
	ldh [hBGMapTileCount], a
	ret

LoadTileset::
	ld hl, wTilesetBank
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	call .LoadTilesetGFX
	ld a, [wTileset]
	ld hl, .roof_tilesets
	call IsInSingularArray
	jr nc, .skip_roof
	callba LoadMapGroupRoof
.skip_roof
	xor a
	ldh [hTileAnimFrame], a
	ret

.roof_tilesets
	db TILESET_NALJO_1
	db TILESET_NALJO_2
	db TILESET_NALJO_3
	db -1

.LoadTilesetGFX:
	call RunFunctionInWRA6
	; no fallthrough

	push hl
	ld hl, wDecompressScratch
	ld bc, (2 * $80) tiles
	xor a
	call ByteFill
	pop hl

	ld a, e
	ld de, wDecompressScratch
	call FarDecompress

	ld hl, wDecompressScratch
	ld de, vBGTiles
	ld bc, $7f tiles
	rst CopyBytes

	call StackCallInVBK1
	; no fallthrough

	ld hl, wDecompressScratch + $80 tiles
	ld de, vBGTiles
	ld bc, $7f tiles
	rst CopyBytes
	ret

BufferScreen::
	ld hl, wOverworldMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wScreenSave
	lb bc, 6, 5
.row
	push bc
	push hl
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .col
	pop hl
	ld a, [wMapWidth]
	add 6
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	dec c
	jr nz, .row
	ret

SaveScreen::
	ld hl, wOverworldMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wScreenSave
	ld a, [wMapWidth]
	add 6
	ldh [hMapObjectIndexBuffer], a
	ld a, [wPlayerStepDirection]
	and a
	jr z, .down
	cp UP
	jr z, .up
	cp LEFT
	jr z, .left
	cp RIGHT
	jr z, .right
	ret

.up
	ld de, wScreenSave + 6
	ldh a, [hMapObjectIndexBuffer]
	ld c, a
	ld b, 0
	add hl, bc
	jr .vertical

.down
	ld de, wScreenSave
.vertical
	lb bc, 6, 4
	jr SaveScreen_LoadNeighbor

.left
	ld de, wScreenSave + 1
	inc hl
	jr .horizontal

.right
	ld de, wScreenSave
.horizontal
	lb bc, 5, 5
	jr SaveScreen_LoadNeighbor

LoadNeighboringBlockData::
	ld hl, wOverworldMapAnchor
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMapWidth]
	add 6
	ldh [hConnectionStripLength], a
	ld de, wScreenSave
	lb bc, 6, 5

SaveScreen_LoadNeighbor::
.row
	push bc
	push hl
	push de
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .col
	pop de
	ld a, e
	add 6
	ld e, a
	adc d
	sub e
	ld d, a
	pop hl
	ldh a, [hConnectionStripLength]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	dec c
	jr nz, .row
	ret

GetMovementPermissions::
	xor a
	ld [wTilePermissions], a
	call .LeftRight
	call .UpDown
; get coords of current tile
	ld a, [wPlayerStandingMapX]
	ld d, a
	ld a, [wPlayerStandingMapY]
	ld e, a
	call GetCoordTile
	ld [wPlayerStandingTile], a
	call .CheckHiNybble
	ret nz

	ld a, [wPlayerStandingTile]
	and 7
	add LOW(.MovementPermissionsData)
	ld l, a
	adc HIGH(.MovementPermissionsData)
	sub l
	ld h, a
	ld a, [hl]
	ld hl, wTilePermissions
	or [hl]
	ld [hl], a
	ret

.MovementPermissionsData
	db 1 << DOWN
	db 1 << UP
	db 1 << LEFT
	db 1 << RIGHT
	db (1 << DOWN) | (1 << RIGHT)
	db (1 << UP) | (1 << RIGHT)
	db (1 << DOWN) | (1 << LEFT)
	db (1 << UP) | (1 << LEFT)

.UpDown
	ld a, [wPlayerStandingMapX]
	ld d, a
	ld a, [wPlayerStandingMapY]
	ld e, a

	push de
	inc e
	call GetCoordTile
	ld [wTileDown], a
	call .Down

	pop de
	dec e
	call GetCoordTile
	ld [wTileUp], a
	jp .Up

.LeftRight
	ld a, [wPlayerStandingMapX]
	ld d, a
	ld a, [wPlayerStandingMapY]
	ld e, a

	push de
	dec d
	call GetCoordTile
	ld [wTileLeft], a
	call .Left

	pop de
	inc d
	call GetCoordTile
	ld [wTileRight], a
	jp .Right

.Down
	call .CheckHiNybble
	ret nz
	ld a, [wTileDown]
	and 7
	cp 2
	jr z, .ok_down
	cp 6
	jr z, .ok_down
	cp 7
	ret nz

.ok_down
	ld a, [wTilePermissions]
	or FACE_DOWN
	ld [wTilePermissions], a
	ret

.Up
	call .CheckHiNybble
	ret nz
	ld a, [wTileUp]
	and 7
	cp 3
	jr z, .ok_up
	cp 4
	jr z, .ok_up
	cp 5
	ret nz

.ok_up
	ld a, [wTilePermissions]
	or FACE_UP
	ld [wTilePermissions], a
	ret

.Right
	call .CheckHiNybble
	ret nz
	ld a, [wTileRight]
	and 7
	cp 1
	jr z, .ok_right
	cp 5
	jr z, .ok_right
	cp 7
	ret nz

.ok_right
	ld a, [wTilePermissions]
	or FACE_RIGHT
	ld [wTilePermissions], a
	ret

.Left
	call .CheckHiNybble
	ret nz
	ld a, [wTileLeft]
	and 7
	jr z, .ok_left
	cp 4
	jr z, .ok_left
	cp 6
	ret nz

.ok_left
	ld a, [wTilePermissions]
	or FACE_LEFT
	ld [wTilePermissions], a
	ret

.CheckHiNybble
	and $f0
	cp $b0
	ret z
	cp $c0
	ret

GetFacingTileCoord::
; Return map coordinates in (d, e) and tile id in a
; of the tile the player is facing.

	ld a, [wPlayerDirection]
	and %1100
	ld l, a
	ld h, 0
	ld de, .Directions
	add hl, de

	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl

	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wPlayerStandingMapX]
	add d
	ld d, a
	ld a, [wPlayerStandingMapY]
	add e
	ld e, a
	ld a, [hl]
	ret

.Directions
	;   x,  y
	db  0,  1
	dw wTileDown
	db  0, -1
	dw wTileUp
	db -1,  0
	dw wTileLeft
	db  1,  0
	dw wTileRight

GetCoordTile::
; Get the collision byte for tile d, e
	call GetBlockLocation
	ld a, [hl]
	and a
	jr z, .nope
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld a, h
	add HIGH(wDecompressedCollision)
	ld h, a

	rr d
	jr nc, .nocarry
	inc l

.nocarry
	rr e
	jr nc, .nocarry2
	inc l
	inc l

.nocarry2
	ld a, BANK(wDecompressedCollision)
	jp GetFarWRAMByte

.nope
	ld a, -1
	ret

GetBlockLocation::
	ld a, [wMapWidth]
	add 6
	ld c, a
	ld b, 0
	ld hl, wOverworldMap + 1
	add hl, bc
	ld a, e
	srl a
	jr z, .nope
	rst AddNTimes
.nope
	ld c, d
	srl c
	ld b, 0
	add hl, bc
	ret

CheckFacingSign::
	call GetFacingTileCoord
; Load facing into b.
	ld b, a
; Convert the coordinates at de to within-boundaries coordinates.
	ld a, d
	sub 4
	ld d, a
	ld a, e
	sub 4
	ld e, a
; If there are no signposts, we don't need to be here.
	ld a, [wCurrentMapSignpostCount]
	and a
	ret z
	ld c, a
	call StackCallInMapScriptHeaderBank

.CheckIfFacingTileCoordIsSign:
; Checks to see if you are facing a signpost.  If so, copies it into wEngineBuffer1 and sets carry.
	ld hl, wCurrentMapSignpostHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	push hl
	ld a, [hli]
	cp e
	jr nz, .next
	ld a, [hli]
	cp d
	jr z, .copysign

.next
	pop hl
	ld a, 5 ; signpost event length
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	dec c
	jr nz, .loop
	xor a
	ret

.copysign
	pop hl
	ld de, wCurSignpostYCoord
	ld bc, 5 ; signpost event length
	rst CopyBytes
	scf
	ret

RunCurrentMapXYTriggers::
; If there are no xy triggers, we don't need to be here.
	ld a, [wCurrentMapXYTriggerCount]
	and a
	ret z
; Copy the trigger count into c.
	ld c, a
	call StackCallInMapScriptHeaderBank

; Checks to see if you are standing on an xy-trigger.  If yes, copies the trigger to wEngineBuffer1 and sets carry.

; Load the active trigger ID into b
	call CheckTriggers
	ld b, a
; Load your current coordinates into de.  This will be used to check if your position is in the xy-trigger table for the current map.
	assert wPlayerStandingMapY == wPlayerStandingMapX + 1
	ld hl, wPlayerStandingMapX
	ld a, [hli]
	sub 4
	ld d, a
	ld a, [hl]
	sub 4
	ld e, a

	ld hl, wCurrentMapXYTriggerHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a

.loop
	push hl
	ld a, [hli]
	cp b
	jr z, .got_id
	inc a
	jr nz, .next

.got_id
	ld a, [hli]
	cp e
	jr nz, .next
	ld a, [hli]
	cp d
	jr nz, .next
	push de
	push bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	or d
	jr z, .runtrigger
	push hl
	call CheckEventFlag
	pop hl
	jr nz, .runtrigger
	pop bc
	pop de

.next
	pop hl
	ld a, XY_TRIGGER_SIZE
	add l
	ld l, a
	adc h
	sub l
	ld h, a

	dec c
	jr nz, .loop
	and a ; clear carry flag
	ret

.runtrigger
	add sp, 6
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMapScriptHeaderBank]
	jp CallScript

FadeToMenu::
	xor a
	ldh [hBGMapMode], a
	call LoadStandardMenuHeader
	ld c, 1 << 7 | 3
	call FadeToWhite
	call ClearSprites
	jp DisableSpriteUpdates

CloseSubmenu::
	call ClearBGPalettes
	call ReloadTilesetAndPalettes
	call UpdateSprites
	call ExitMenu
	jr CloseSubmenu_AfterExitMenu

ExitAllMenus::
	call ClearBGPalettes
	call ExitMenu
ExitAllMenus_AfterExitMenu::
	call ReloadTilesetAndPalettes
	call UpdateSprites
	; fallthrough
CloseSubmenu_AfterExitMenu::
	ld b, SCGB_MAPPALS
	predef GetSGBLayout
	callba LoadOW_BGPal7
	call ApplyAttrAndTilemapInVBlank
	callba FadeInPalettes
	jp EnableSpriteUpdates

ReturnToMapWithSpeechTextbox::
	push af
	ld a, 1
	ld [wSpriteUpdatesEnabled], a
	call ClearBGPalettes
	call ClearSprites
	call ReloadTilesetAndPalettes
	hlcoord 0, 12
	lb bc, 4, 18
	call TextBox
	ld hl, wVramState
	set 0, [hl]
	call UpdateSprites
	call ApplyAttrAndTilemapInVBlank
	ld b, SCGB_MAPPALS
	predef GetSGBLayout
	callba LoadOW_BGPal7
	call UpdateTimePals
	call DelayFrame
	ld a, 1
	ldh [hMapAnims], a
	pop af
	ret

ReloadTilesetAndPalettes::
	call DisableLCD
	call ClearSprites
	callba RefreshSprites
	call LoadStandardFont
	call ProtectedBankStackCall
	; end of function

	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call SwitchToAnyMapBank
	callba UpdateTimeOfDayPal
	call OverworldTextModeSwitch
	call LoadTileset
	ld a, 9
	call SkipMusic
	jp EnableLCD

GetMapHeaderPointer::
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
GetAnyMapHeaderPointer::
; Prior to calling this function, you must have switched banks so that
; MapGroupPointers is visible.

; inputs:
; b = map group, c = map number

; outputs:
; hl points to the map header
	push bc ; save map number for later

	; get pointer to map group
	dec b
	ld c, b
	ld b, 0
	ld hl, MapGroupPointers
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc ; restore map number

	; find the cth map header
	dec c
	ld b, 0
	ld a, 9
	rst AddNTimes
	ret

GetMapHeaderMember::
; Extract data from the current map's header.

; inputs:
; de = offset of desired data within the mapheader

; outputs:
; bc = data from the current map's header
; (e.g., de = $0003 would return a pointer to the secondary map header)

	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
GetAnyMapHeaderMember::
	anonbankpush MapGroupPointers
	; end of function

	call GetAnyMapHeaderPointer
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ret

SwitchToMapBank::
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	; fallthrough
SwitchToAnyMapBank::
	call GetAnyMapBank
	jp Bankswitch

GetMapBank::
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
GetAnyMapBank::
	push hl
	push de
	ld de, 0
	call GetAnyMapHeaderMember
	ld a, c
	pop de
	pop hl
	ret

PartiallyCopyMapHeader::
; Copy second map header bank, tileset, permission, and second map header address
; from the current map's map header.
	anonbankpush MapGroupPointers
	; end of function

	call GetMapHeaderPointer
	ld de, wSecondMapHeaderBank
	ld bc, wMapHeader - wSecondMapHeaderBank
	rst CopyBytes
	ret

GetAnyMapBlockdataBankPointer::
; Return the blockdata bank for group b map c.
	push de
	push bc

	push bc
	ld de, 3 ; second map header pointer
	call GetAnyMapHeaderMember
	ld l, c
	ld h, b
	pop bc

	push hl
	ld de, 0 ; second map header bank
	call GetAnyMapHeaderMember
	pop hl

	inc hl
	inc hl
	inc hl
	ld a, c
	call GetFarByteHalfword
	rbk a

	jr PopOffBCDEAndReturn

GetSecondaryMapHeaderPointer::
; returns the current map's secondary map header pointer in hl.
	push de
	push bc
	ld de, 3 ; secondary map header pointer (offset within header)
	call GetMapHeaderMember
	ld l, c
	ld h, b
PopOffBCDEAndReturn:
	pop bc
	pop de
	ret

GetMapPermission::
	push hl
	push de
	push bc
	ld de, 2 ; permission
	call GetMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetAnyMapPermission::
	push hl
	push de
	push bc
	ld de, 2 ; permission
	call GetAnyMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetCurMapTileset::
	ld de, 1 ; tileset
	call GetMapHeaderMember
	ld a, c
	ret

GetAnyMapTileset::
	ld de, 1 ; tileset
	call GetAnyMapHeaderMember
	ld a, c
	ret

GetCurWorldMapLocation::
	push hl
	push de
	push bc

	ld de, 5 ; landmark
	call GetMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetWorldMapLocation::
; given a map group/id in bc, return its location on the town map.
	push hl
	push de
	push bc

	ld de, 5 ; landmark
	call GetAnyMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

GetMapMusic::
	call SpecialMapMusic
	ret c

; fallthrough
GetMapHeaderMusic::
	push hl
	push bc
	ld de, 6 ; music
	call GetMapHeaderMember
	ld e, c
	ld d, 0
PopOffBCHLAndReturn:
	pop bc
	pop hl
	ret

GetMapHeaderTimeOfDayNybble::
	push hl
	push bc

	ld de, 7 ; phone service and time of day
	call GetMapHeaderMember
	ld a, c
	and $f

	jr PopOffBCHLAndReturn

GetFishingGroup::
	push de
	push hl
	push bc

	ld de, 8 ; fishing group
	call GetMapHeaderMember
	jp GetMapHeaderAttribute_PopOffBCDEHLAndReturn

LoadTilesetHeader::
	push hl
	push bc

	ld hl, Tilesets
	ld bc, Tileset01 - Tileset00
	ld a, [wTileset]
	rst AddNTimes

	ld de, wTilesetBank
	ld bc, Tileset01 - Tileset00

	ld a, BANK(Tilesets)
	call FarCopyBytes
	jr PopOffBCHLAndReturn

GetCurNick::
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	; fallthrough

GetNick::
; Get nickname a from list hl.

	push hl
	push bc

	call SkipNames
	ld de, wStringBuffer1

	push de
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	pop de

	callba CheckNickErrors

	jr PopOffBCHLAndReturn

FixMapObjectPointersOnContinue::
	call GetSecondaryMapHeaderPointer
	call GetMapBank
	call StackCallInBankA
	; end of function

	ld bc, 6
	add hl, bc
	ld a, [hli]
	push af
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	rbk a
	inc hl
	inc hl
	ld a, [hli]
	ld bc, 5
	rst AddNTimes
	ld a, [hli]
	ld bc, XY_TRIGGER_SIZE
	rst AddNTimes
	ld a, [hli]
	ld bc, 5
	rst AddNTimes
	ld a, [hli]
	and a
	ret z
	ld de, wMap1ObjectScript - wMap1ObjectSprite
	add hl, de
	ld de, wMap1ObjectScript
	ld bc, 11
.loop
	push af
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	add hl, bc
	ld a, e
	add wMap2Object - wMap1Object - 2
	ld e, a
	adc d
	sub e
	ld d, a
	pop af
	dec a
	jr nz, .loop
	ret
