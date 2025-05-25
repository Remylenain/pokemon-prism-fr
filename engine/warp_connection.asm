RunCallback_05_03:
	call ResetMapBufferEventFlags
	call ResetFlashIfOutOfCave
	call GetCurrentMapTrigger
	call ResetBikeFlags
	ld a, MAPCALLBACK_NEWMAP
	call RunMapCallback
RunCallback_03:
	callba ClearCmdQueue
	ld a, MAPCALLBACK_CMDQUEUE
	call RunMapCallback
	call GetMapHeaderTimeOfDayNybble
	ld [wMapTimeOfDay], a
	ret

EnterMapConnection:
; Return carry if a connection has been entered.
	ld a, [wPlayerStepDirection]
	and a
	jp z, EnterSouthConnection
	dec a
	jr z, EnterNorthConnection
	dec a
	jr z, EnterWestConnection
	dec a
	ret nz
	; fallthrough

EnterEastConnection:
	ld a, [wEastConnectedMapGroup]
	ld [wMapGroup], a
	ld a, [wEastConnectedMapNumber]
	ld [wMapNumber], a
	ld a, [wEastConnectionStripXOffset]
	ld [wXCoord], a
	ld a, [wEastConnectionStripYOffset]
	ld hl, wYCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, wEastConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl c
	jr z, .skip_to_load
	ld a, [wEastConnectedMapWidth]
	add 6
	ld e, a
	ld d, 0

.loop
	add hl, de
	dec c
	jr nz, .loop

.skip_to_load
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

EnterWestConnection:
	ld a, [wWestConnectedMapGroup]
	ld [wMapGroup], a
	ld a, [wWestConnectedMapNumber]
	ld [wMapNumber], a
	ld a, [wWestConnectionStripXOffset]
	ld [wXCoord], a
	ld a, [wWestConnectionStripYOffset]
	ld hl, wYCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, wWestConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl c
	jr z, .skip_to_load
	ld a, [wWestConnectedMapWidth]
	add 6
	ld e, a
	ld d, 0

.loop
	add hl, de
	dec c
	jr nz, .loop

.skip_to_load
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

EnterNorthConnection:
	ld a, [wNorthConnectedMapGroup]
	ld [wMapGroup], a
	ld a, [wNorthConnectedMapNumber]
	ld [wMapNumber], a
	ld a, [wNorthConnectionStripYOffset]
	ld [wYCoord], a
	ld a, [wNorthConnectionStripXOffset]
	ld hl, wXCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, wNorthConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

EnterSouthConnection:
	ld a, [wSouthConnectedMapGroup]
	ld [wMapGroup], a
	ld a, [wSouthConnectedMapNumber]
	ld [wMapNumber], a
	ld a, [wSouthConnectionStripYOffset]
	ld [wYCoord], a
	ld a, [wSouthConnectionStripXOffset]
	ld hl, wXCoord
	add [hl]
	ld [hl], a
	ld c, a
	ld hl, wSouthConnectionWindow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	scf
	ret

LoadWarpData:
	call .SaveDigWarp
	call .SetSpawn
	ld a, [wNextWarp]
	ld [wWarpNumber], a
	ld a, [wNextMapGroup]
	ld [wMapGroup], a
	ld a, [wNextMapNumber]
	ld [wMapNumber], a
	ret

.SaveDigWarp
	call GetMapPermission
	call CheckOutdoorMap
	ret nz
	ld a, [wNextMapGroup]
	ld b, a
	ld a, [wNextMapNumber]
	ld c, a
	cp MAP_RUINS_F5
	jr nz, .doNotPreserveDigWarp
	ld a, b
	cp GROUP_RUINS_F5
	ret z
.doNotPreserveDigWarp
	call GetAnyMapPermission
	call CheckIndoorMap
	ret nz
	ld a, [wPrevWarp]
	ld [wDigWarp], a
	ld a, [wPrevMapGroup]
	ld [wDigMapGroup], a
	ld a, [wPrevMapNumber]
	ld [wDigMapNumber], a
	ret

.SetSpawn
	call GetMapPermission
	call CheckOutdoorMap
	ret nz
	ld a, [wNextMapGroup]
	ld b, a
	ld a, [wNextMapNumber]
	ld c, a
	push bc
	call GetAnyMapPermission
	call CheckIndoorMap
	pop bc
	ret nz
	call GetAnyMapTileset
	ld a, c
	cp TILESET_POKECENTER
	ret nz
	ld a, [wPrevMapGroup]
	ld [wLastSpawnMapGroup], a
	ld a, [wPrevMapNumber]
	ld [wLastSpawnMapNumber], a
	ret

LoadMapTimeOfDay:
	ld hl, wVramState
	res 6, [hl]
	ld a, 1
	ld [wSpriteUpdatesEnabled], a
	callba ReplaceTimeOfDayPals
	callba UpdateTimeOfDayPal
	call OverworldTextModeSwitch
	call ClearBGMap

	decoord 0, 0
	call .copy

	decoord 0, 0, wAttrMap
	vbk BANK(vBGAttrs)
.copy
	hlbgcoord 0, 0
	lb bc, SCREEN_HEIGHT, SCREEN_WIDTH
.row
	push bc
.column
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .column
	ld bc, BG_MAP_WIDTH - SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	vbk BANK(vBGMap)
	ret

ClearBGMap:
	ld a, HIGH(vBGMap)
	ld [wBGMapAnchor + 1], a
	xor a
	ld [wBGMapAnchor], a
	ldh [hSCY], a
	ldh [hSCX], a
	callba ReanchorOverworldSprites
	ldh a, [rVBK]
	push af
	vbk BANK(vBGAttrs)
	xor a
	ld bc, vWindowAttrs - vBGAttrs
	hlbgcoord 0, 0
	call ByteFill
	pop af
	ldh [rVBK], a
	ld a, "<BLACK>"
	ld bc, vWindowMap - vBGMap
	hlbgcoord 0, 0
	jp ByteFill

LoadGraphics:
	call LoadTilesetHeader
LoadGraphicsNoHeader:
	call LoadTileset
	xor a
	ldh [hMapAnims], a
	ldh [hTileAnimFrame], a
	callba RefreshSprites
	jp LoadFontsExtra

LoadMapPalettes:
	ld b, SCGB_MAPPALS
	predef_jump GetSGBLayout

PrismNoMapSign::
	ld a, $90
	ldh [rWY], a
	ldh [hWY], a
	xor a
	ld [wLCDCPointer], a
	ldh [hBGMapMode], a
	ret

RefreshMapSprites:
	call ClearSprites
	; call PrismNoMapSign
	callba QueueLandmarkSignAnim
	call GetMovementPermissions
	callba RefreshPlayerSprite
	callba CheckReplaceKrisSprite
	ld hl, wPlayerSpriteSetupFlags
	bit 6, [hl]
	jr nz, .skip
	ld hl, wVramState
	set 0, [hl]
	call SafeUpdateSprites
.skip
	ld a, [wPlayerSpriteSetupFlags]
	and %00011100
	ld [wPlayerSpriteSetupFlags], a
	ret

CheckMovingOffEdgeOfMap::
	ld a, [wPlayerStepDirection]
	cp 4
	ret nc
	bit 1, a
	jr z, .vertical
	ld b, a
	ld a, [wMapWidth]
	ld c, a
	ld a, [wPlayerStandingMapX]
	jr .okay1

.vertical
	xor 1
	ld b, a
	ld a, [wMapHeight]
	ld c, a
	ld a, [wPlayerStandingMapY]
.okay1
	sub 4
	bit 0, b
	jr z, .right_or_bottom
	sla c
	cp c
	ccf
	ret z
	and a
	ret

.right_or_bottom
	add 1 ; sets carry for -1
	ret

GetCoordOfUpperLeftCorner::
	ld hl, wOverworldMap
	ld a, [wXCoord]
	bit 0, a
	jr nz, .increment_then_halve1
	srl a
	inc a
	jr .resume

.increment_then_halve1
	inc a
	srl a

.resume
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wMapWidth]
	add 6
	ld c, a
	ld b, 0
	ld a, [wYCoord]
	bit 0, a
	jr nz, .increment_then_halve2
	srl a
	inc a
	jr .resume2

.increment_then_halve2
	inc a
	srl a

.resume2
	rst AddNTimes
	ld a, l
	ld [wOverworldMapAnchor], a
	ld a, h
	ld [wOverworldMapAnchor + 1], a
	ld a, [wYCoord]
	and 1
	ld [wMetatileStandingY], a
	ld a, [wXCoord]
	and 1
	ld [wMetatileStandingX], a
	ret
