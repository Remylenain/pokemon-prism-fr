INCLUDE "engine/landmarksigns.asm"

CheckForHiddenItems:
; Checks to see if there are hidden items on the screen that have not yet been found.  If it finds one, returns carry.
	ld a, 1
	ld [wUndiscoveredHiddenItemExists], a
	ld a, [wMapScriptHeaderBank]
	ld [wItemfinderSignpostsBank], a
; Get the coordinate of the bottom right corner of the screen, and load it in wItemfinderScreenBottom/wItemfinderScreenRight.
	ld a, [wXCoord]
	add SCREEN_WIDTH / 4
	ld [wItemfinderScreenRight], a
	ld a, [wYCoord]
	add SCREEN_HEIGHT / 4
	ld [wItemfinderScreenBottom], a
; Get the pointer for the first signpost header in the map...
	ld hl, wCurrentMapSignpostHeaderPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
; ... before even checking to see if there are any signposts on this map.
	ld a, [wCurrentMapSignpostCount]
	and a
	jr z, .nosignpostitems
; For i = 1:wCurrentMapSignpostCount...
.loop
; Store the counter in wItemfinderSignpostsCount, and store the signpost header pointer in the stack.
	ld [wItemfinderSignpostsCount], a
; Get the Y coordinate of the signpost.
	ld de, wMapHiddenItemsBuffer
	ld bc, 5
	ld a, [wItemfinderSignpostsBank]
	call FarCopyBytes
; Save the pointer of the signpost header
	push hl
; Is this signpost a hidden item?  If not, go to the next signpost.
	ld hl, wMapHiddenItemsBuffer + 2
	ld a, [hli]
	cp SIGNPOST_ITEM
	jr nz, .next
; Has this item already been found?  If so, go to the next signpost.
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wItemfinderSignpostsBank]
	call GetFarHalfword
	ld d, h
	ld e, l
	ld b, CHECK_FLAG
	predef EventFlagAction
	jr nz, .next
	ld a, 2
	ld [wUndiscoveredHiddenItemExists], a
	ld hl, wMapHiddenItemsBuffer
	ld a, [hli]
	ld e, a
; Is the Y coordinate of the signpost on the screen?  If not, go to the next signpost.
	ld a, [wItemfinderScreenBottom]
	sub e
	jr c, .next
	cp SCREEN_HEIGHT / 2
	jr nc, .next
; Is the X coordinate of the signpost on the screen?  If not, go to the next signpost.
	ld a, [hli]
	ld d, a
	ld a, [wItemfinderScreenRight]
	sub d
	jr c, .next
	cp SCREEN_WIDTH / 2
	jr nc, .next
; An item is nearby
	pop hl
	xor a
	ret
.next
; Restore the signpost header pointer
	pop hl
; Restore the signpost counter and decrement it.  If it hits zero, there are no hidden items in range.
	ld a, [wItemfinderSignpostsCount]
	dec a
	jr nz, .loop
.nosignpostitems
	ld a, [wUndiscoveredHiddenItemExists]
	ret

TreeMonEncounter:
	xor a
	ld [wTempWildMonSpecies], a
	ld [wCurPartyLevel], a

	ld hl, TreeMonMaps
	call GetTreeMonSet
	jr nc, .no_battle

	call GetTreeMons
	jr nc, .no_battle

	call GetTreeMon
	jr nc, .no_battle

	ld a, BATTLETYPE_TREE
	ld [wBattleType], a
	ld a, 1
	ldh [hScriptVar], a
	ret

.no_battle
	xor a
	ldh [hScriptVar], a
	ret

RockMonEncounter:
	xor a
	ld [wTempWildMonSpecies], a
	ld [wCurPartyLevel], a

	ld hl, RockMonMaps
	call GetTreeMonSet
	jr nc, .no_battle

	call GetTreeMons
	jr nc, .no_battle

	ld a, 10
	call RandomRange
	cp 4
	jr nc, .no_battle

	call SelectTreeMon
	ret c

.no_battle
	xor a
	ret

GetTreeMonSet:
; Return carry and treemon set in a
; if the current map is in table hl.
	ld a, [wMapNumber]
	ld e, a
	ld a, [wMapGroup]
	ld d, a
.loop
	ld a, [hli]
	cp -1
	jr z, .not_in_table

	cp d
	jr nz, .skip2

	ld a, [hli]
	cp e
	jr nz, .skip1

	ld a, [hl]
	scf
	ret

.skip2
	inc hl
.skip1
	inc hl
	jr .loop

.not_in_table
	xor a
	ret

TreeMonMaps:
MACRO treemon_map
	map \1
	db  \2 ; treemon set
ENDM
	treemon_map ROUTE_67, 2
	treemon_map ROUTE_65, 1
	treemon_map RIJON_LEAGUE_OUTSIDE, 1
	treemon_map ILEX_FOREST, 5
	treemon_map ROUTE_34, 3
	treemon_map AZALEA_TOWN, 4
	treemon_map EMBER_BROOK, 2
	db -1

RockMonMaps:
	treemon_map ROUTE_85, 7
	treemon_map HAUNTED_MANSION_BASEMENT, 6
	db -1

GetTreeMons:
; Return the address of TreeMon table a in hl.
; Return nc if table a doesn't exist.

	cp 8
	ret nc

	and a
	ret z

	ld e, a
	ld d, 0
	ld hl, TreeMons
	add hl, de
	add hl, de

	ld a, [hli]
	ld h, [hl]
	ld l, a

	scf
	ret

TreeMons:
	dw TreeMons1
	dw TreeMons1
	dw TreeMons2
	dw TreeMons3
	dw TreeMons4
	dw TreeMons5
	dw RockMons
	dw RockMons2

; Two tables each (normal, rare).
; Structure:
;	db  %, species, level

TreeMons1: ;rijon league & route 65
	db 50, SPEAROW,    30
	db 15, SPEAROW,    30
	db 15, SPEAROW,    30
	db 10, SPINARAK,   30
	db  5, ARIADOS,    35
	db  5, FORRETRESS, 35
	db -1

	db 50, PINECO,     30
	db 15, TANGELA,    30
	db 15, TANGELA,    30
	db 10, SPINARAK,   30
	db  5, ARIADOS,    35
	db  5, FORRETRESS, 35
	db -1

TreeMons2: ;route 67
	db 50, SPEAROW,    30
	db 15, METAPOD,    30
	db 15, SPEAROW,    30
	db 10, SPINARAK,   30
	db  5, SPINARAK,   30
	db  5, ARIADOS,    35
	db -1

	db 50, METAPOD,    30
	db 15, TANGELA,    30
	db 15, TANGELA,    30
	db 10, SPINARAK,   30
	db  5, BUTTERFREE, 35
	db  5, ARIADOS,    35
	db -1

TreeMons3: ;route 34
	db 50, TAILLOW,    50
	db 15, SPINARAK,   50
	db 15, ARIADOS,    50
	db 10, EXEGGCUTE,  50
	db  5, EXEGGCUTE,  50
	db  5, EXEGGCUTE,  50
	db -1

	db 50, NATU,       50
	db 15, PINECO,     50
	db 15, PINECO,     50
	db 10, EXEGGCUTE,  50
	db  5, FORRETRESS, 50
	db  5, FORRETRESS, 50
	db -1

TreeMons4: ;azalea
	db 50, NATU,       50
	db 15, NATU,       50
	db 15, PINECO,     50
	db 10, SLOWPOKE,   50
	db  5, SLOWPOKE,   50
	db  5, SLOWPOKE,   50
	db -1

	db 50, SLOWPOKE,   50
	db 15, SLOWPOKE,   50
	db 15, SLOWPOKE,   50
	db 10, SLOWPOKE,   50
	db  5, FORRETRESS, 50
	db  5, FORRETRESS, 50
	db -1

TreeMons5: ;ilex forest
	db 50, TAILLOW,    50
	db 15, PINECO,     50
	db 15, PINECO,     50
	db 10, FORRETRESS, 50
	db  5, SHROOMISH,  50
	db  5, BUTTERFREE, 50
	db -1

	db 50, TAILLOW,    50
	db 15, CATERPIE,   50
	db 15, METAPOD,    50
	db 10, SWELLOW,    50
	db  5, BRELOOM,    50
	db  5, BUTTERFREE, 50
	db -1

;Rock Smash Pokemon:
;Geodude
;Slugma
;Graveler

RockMons: ;haunted mansion basement
	db 90, SPIRITOMB,  60
	db 10, SPIRITOMB,  65
	db -1

RockMons2: ;route 85
	db 90, SLUGMA,     25
	db 10, MAGCARGO,   30
	db -1

GetTreeMon:
	push hl
	call GetTreeScore
	pop hl
	and a
	jr z, .bad
	cp 1
	jr z, .good
	cp 2
	jr z, .rare
	ret

.bad
	ld a, 10
	call RandomRange
	and a
	jr nz, NoTreeMon
	jr SelectTreeMon

.good
	ld a, 10
	call RandomRange
	cp 5
	jr nc, NoTreeMon
	jr SelectTreeMon

.rare
	ld a, 10
	call RandomRange
	cp 8
	jr nc, NoTreeMon
.skip
	ld a, [hli]
	cp -1
	jr nz, .skip
	; fallthrough

SelectTreeMon:
; Read a TreeMons table and pick one monster at random.

	ld a, 100
	call RandomRange
.loop
	sub [hl]
	jr c, .ok
	inc hl
	inc hl
	inc hl
	jr .loop

.ok
	ld a, [hli]
	cp $ff
	jr z, NoTreeMon

	ld a, [hli]
	ld [wTempWildMonSpecies], a
	ld a, [hl]
	ld [wCurPartyLevel], a
	scf
	ret

NoTreeMon:
	xor a
	ld [wTempWildMonSpecies], a
	ld [wCurPartyLevel], a
	ret

GetTreeScore:
	call .CoordScore
	ld [wTreeCoordScore], a
	call .OTIDScore
	ld [wTreeIDScore], a
	ld c, a
	ld a, [wTreeCoordScore]
	sub c
	jr z, .rare
	jr nc, .ok
	add 10
.ok
	cp 5
	jr c, .good

.bad
	xor a
	ret

.good
	ld a, 1
	ret

.rare
	ld a, 2
	ret

.CoordScore
	call GetFacingTileCoord
	ld hl, 0
	ld c, e
	ld b, 0
	ld a, d

	and a
	jr z, .next
.loop
	add hl, bc
	dec a
	jr nz, .loop
.next

	add hl, bc
	ld c, d
	add hl, bc

	ld a, h
	ldh [hDividend], a
	ld a, l
	ldh [hDividend + 1], a
	ld a, 5
	ldh [hDivisor], a
	ld b, 2
	predef Divide

	ldh a, [hQuotient + 1]
	ldh [hDividend], a
	ldh a, [hQuotient + 2]
	ldh [hDividend + 1], a
	ld a, 10
	ldh [hDivisor], a
	ld b, 2
	predef Divide

	ldh a, [hRemainder]
	ret

.OTIDScore
	ld a, [wPlayerID]
	ldh [hDividend], a
	ld a, [wPlayerID + 1]
	ldh [hDividend + 1], a
	ld a, 10
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ldh a, [hRemainder]
	ret

LoadFishingGFX:
	ldh a, [rVBK]
	push af
	vbk BANK(vStandingFrameTiles)
	ld a, [wPlayerCharacteristics]
	ld hl, FishingGFX7
	and $f
	cp $c
	jr nc, .setGFX

	ld hl, FishingGFX
	ld bc, 24 tiles
	rst AddNTimes

.setGFX
	push hl
	ld d, h
	ld e, l
	ld hl, vStandingFrameTiles tile $00
	lb bc, BANK(FishingGFX), 12
	call Get2bpp
	pop hl
	ld de, 12 tiles
	add hl, de
	ld d, h
	ld e, l
	ld hl, vFontTiles tile $00
	lb bc, BANK(FishingGFX), 12
	call Get2bpp
	ld hl, vObjTiles tile $7c
	ld de, FishingGFXExtra
	lb bc, BANK(FishingGFXExtra), 4
	call Get2bpp
	pop af
	ldh [rVBK], a
	ld hl, wScriptFlags2
	set 0, [hl]
	ret
