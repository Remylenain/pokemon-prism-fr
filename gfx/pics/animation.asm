; Pic animation arrangement.

AnimateMon_Menu:
	lb de, 0, ANIM_MON_MENU
	jp AnimateFrontpic

AnimateMon_Trade:
	lb de, 0, ANIM_MON_TRADE
	jp AnimateFrontpic

AnimateMon_Evolve:
	lb de, 0, ANIM_MON_EVOLVE
	jp AnimateFrontpic

AnimateMon_Hatch:
	lb de, 0, ANIM_MON_HATCH
	jp AnimateFrontpic

MACRO POKEANIM
	rept _NARG
		db (PokeAnim_\1_ - PokeAnim_SetupCommands) / 2
		shift
	endr
	db (PokeAnim_Finish_ - PokeAnim_SetupCommands) / 2
ENDM

PokeAnims:
	dw .Slow
	dw .Normal
	dw .Menu
	dw .MenuRepeating
	dw .Trade
	dw .Evolve
	dw .Hatch
	dw .Egg1
	dw .Egg2

.Slow:          POKEANIM StereoCry, Setup2, Play
.Normal:        POKEANIM StereoCry, Setup, Play
.Menu:          db (PokeAnim_CryNoWait_ - PokeAnim_SetupCommands) / 2
.MenuRepeating: POKEANIM Setup, Play, SetWait, Wait, Extra, Play
.Trade:         POKEANIM Extra, Play2, Extra, Play, SetWait, Wait, Cry, Setup, Play
.Evolve:        POKEANIM Extra, Play, SetWait, Wait, CryNoWait, Setup, Play
.Hatch:         POKEANIM Extra, Play, CryNoWait, Setup, Play, SetWait, Wait, Extra, Play
.Egg1:          POKEANIM Setup, Play
.Egg2:          POKEANIM Extra, Play


AnimateFrontpic:
	call AnimateMon_CheckIfPokemon
	ret c
	call LoadMonAnimation
	ld a, 1
	ldh [hRunPicAnim], a
.loop
	call SetUpPokeAnim
	callba HDMATransferTileMapToWRAMBank3
	ldh a, [hDEDCryFlag]
	and a
	call nz, _PlayCry
	ldh a, [hRunPicAnim]
	and a
	jr nz, .loop
	ret

LoadMonAnimation:
	push hl
	ld c, e
	ld b, 0
	ld hl, PokeAnims
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	jp PokeAnim_InitPicAttributes

SetUpPokeAnim:
	ldh a, [rSVBK]
	push af
	wbk BANK(wPokeAnimSceneIndex)
	ld a, [wPokeAnimSceneIndex]
	ld c, a
	ld b, 0
	ld hl, wPokeAnimPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, [hl]
	jumptable PokeAnim_SetupCommands
	ld a, [wPokeAnimSceneIndex]
	ld c, a
	pop af
	ldh [rSVBK], a
	ld a, c
	add a, a
	ret

PokeAnim_SetupCommands:
MACRO setup_command
\1_: dw \1
ENDM
	setup_command PokeAnim_Finish
	setup_command PokeAnim_BasePic
	setup_command PokeAnim_SetWait
	setup_command PokeAnim_Wait
	setup_command PokeAnim_Setup
	setup_command PokeAnim_Setup2
	setup_command PokeAnim_Extra
	setup_command PokeAnim_Play
	setup_command PokeAnim_Play2
	setup_command PokeAnim_Cry
	setup_command PokeAnim_CryNoWait
	setup_command PokeAnim_StereoCry

PokeAnim_SetWait:
	ld a, 18
	ld [wPokeAnimWaitCounter], a
	call PokeAnim_IncrementSceneIndex
	; fallthrough

PokeAnim_Wait:
	ld hl, wPokeAnimWaitCounter
	dec [hl]
	ret nz
	; fallthrough

PokeAnim_IncrementSceneIndex:
	ld a, [wPokeAnimSceneIndex]
	inc a
	ld [wPokeAnimSceneIndex], a
	ret

PokeAnim_Setup:
	lb bc, 0, FALSE
	; fallthrough

PokeAnim_Setup_End:
	call PokeAnim_InitAnim
	call PokeAnim_SetVBank1
	jr PokeAnim_IncrementSceneIndex

PokeAnim_Setup2:
	lb bc, 4, FALSE
	jr PokeAnim_Setup_End

PokeAnim_Extra:
	lb bc, 0, TRUE
	jr PokeAnim_Setup_End

PokeAnim_Play:
	call PokeAnim_DoAnimScript
	ld a, [wPokeAnimJumptableIndex]
	bit 7, a
	ret z
	call PokeAnim_PlaceGraphic
	jr PokeAnim_IncrementSceneIndex

PokeAnim_Play2:
	call PokeAnim_DoAnimScript
	ld a, [wPokeAnimJumptableIndex]
	bit 7, a
	ret z
	jr PokeAnim_IncrementSceneIndex

PokeAnim_BasePic:
	call PokeAnim_DeinitFrames
	jr PokeAnim_IncrementSceneIndex

PokeAnim_Finish:
	call PokeAnim_DeinitFrames
	ld hl, wPokeAnimSceneIndex
	set 7, [hl]
	xor a
	ldh [hRunPicAnim], a
	ret

PokeAnim_Cry:
	ld a, [wPokeAnimSpecies]
	call LoadCryHeader
	ld a, [wPokeAnimSpecies]
	jr c, PokeAnim_DedCry
	call _PlayCry
	jr PokeAnim_IncrementSceneIndex

PokeAnim_CryNoWait:
	ld a, [wPokeAnimSpecies]
	call LoadCryHeader
	ld a, [wPokeAnimSpecies]
	jr c, PokeAnim_DedCry
	call PlayCry2
	jr PokeAnim_IncrementSceneIndex

PokeAnim_StereoCry:
	ld a, $f
	ld [wCryTracks], a
	ld a, [wPokeAnimSpecies]
	call LoadCryHeader
	ld a, [wPokeAnimSpecies]
	jr c, PokeAnim_DedCry
	call PlayStereoCry2
	jr PokeAnim_IncrementSceneIndex

PokeAnim_DedCry:
	ldh [hDEDCryFlag], a
	jr PokeAnim_IncrementSceneIndex

PokeAnim_DeinitFrames:
	ldh a, [rSVBK]
	push af
	wbk BANK(wPokeAnimSceneIndex)
	call PokeAnim_PlaceGraphic
	callba HDMAHBlankTransferTileMap_DuringDI
	call PokeAnim_SetVBank0
	callba HDMAHBlankTransferAttrMap_DuringDI
	pop af
	ldh [rSVBK], a
	ret

AnimateMon_CheckIfPokemon:
	ld a, [wCurPartySpecies]
	cp EGG
	jp nz, IsAPokemon
	scf
	ret

PokeAnim_InitPicAttributes:
	ldh a, [rSVBK]
	push af
	wbk BANK(wPokeAnimSceneIndex)

	push bc
	push hl
	ld hl, wPokeAnimSceneIndex
	ld bc, wPokeAnimStructEnd - wPokeAnimSceneIndex
	xor a
	call ByteFill
	pop hl
	pop bc

; bc contains anim pointer
	ld a, c
	ld [wPokeAnimPointer], a
	ld a, b
	ld [wPokeAnimPointer + 1], a
; hl contains tilemap coords
	ld a, l
	ld [wPokeAnimCoord], a
	ld a, h
	ld [wPokeAnimCoord + 1], a
; d = start tile
	ld a, d
	ld [wPokeAnimGraphicStartTile], a
; convert tilemap coord to BGMap coords
	call ConvertTileMapAddrToBGMap
	ld a, l
	ld [wPokeAnimDestination], a
	ld a, h
	ld [wPokeAnimDestination + 1], a
	ld a, BANK(wCurPartySpecies)
	ld hl, wCurPartySpecies
	call GetFarWRAMByte
	ld [wPokeAnimSpecies], a
	ld [wPokeAnimSpecies2], a

	call PokeAnim_GetFrontpicDims
	ld a, c
	ld [wPokeAnimFrontpicHeight], a

	pop af
	ldh [rSVBK], a
	ret

ConvertTileMapAddrToBGMap:
	ld a, l
	sub LOW(wTileMap)
	ld l, a
	ld a, h
	sbc HIGH(wTileMap)
	ld h, a
	ld bc, -SCREEN_WIDTH
	ld d, 0
	jr .handleLoop
.subtractLoop
	inc d
.handleLoop
	add hl, bc
	jr c, .subtractLoop
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld e, l
	ldh a, [hBGMapAddress]
	ld l, a
	ldh a, [hBGMapAddress + 1]
	ld h, a
	ld bc, BG_MAP_WIDTH
	ld a, d
	rst AddNTimes
	ld c, e
	ld b, 0
	add hl, bc
	ret

PokeAnim_InitAnim:
	ldh a, [rSVBK]
	push af
	wbk BANK(wPokeAnimSceneIndex)
	push bc
	ld hl, wPokeAnimExtraFlag
	ld bc, wPokeAnimDestination - wPokeAnimExtraFlag
	xor a
	call ByteFill
	pop bc
	ld a, b
	ld [wPokeAnimSpeed], a
	ld a, c
	ld [wPokeAnimExtraFlag], a
	call GetMonAnimPointer
	call GetMonFramesPointer
	call GetMonBitmaskPointer
	pop af
	ldh [rSVBK], a
	ret

PokeAnim_DoAnimScript:
	xor a
	ldh [hBGMapMode], a
.next_command
	ld a, [wPokeAnimJumptableIndex]
	and $7f
	jp nz, .WaitAnim
.RunAnim
	; get command
	ld a, [wPokeAnimFrame]
	ld e, a
	ld d, 0
	ld hl, wPokeAnimPointerAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	ld a, [wPokeAnimPointerBank]
	call GetFarHalfword
	ld e, l
	ld a, l
	ld [wPokeAnimCommand], a
	ld a, h
	ld [wPokeAnimParameter], a
	ld hl, wPokeAnimFrame
	inc [hl]

	inc e
	jr nz, .not_end
	ld hl, wPokeAnimJumptableIndex
	set 7, [hl]
	ret
.not_end

	inc e
	jr nz, .not_set_repeat
	ld a, [wPokeAnimParameter]
	ld [wPokeAnimRepeatTimer], a
	jr .next_command
.not_set_repeat

	inc e
	jr nz, .not_do_repeat
	ld hl, wPokeAnimRepeatTimer
	ld a, [hl]
	and a
	ret z
	dec a
	ld [hl], a
	ret z
	ld a, [wPokeAnimParameter]
	ld [wPokeAnimFrame], a
	jr .next_command
.not_do_repeat

	; show frame
	call PokeAnim_PlaceGraphic
	ld a, [wPokeAnimCommand]
	and a
	jp z, .got_frame
	; get bitmask index
	ld a, [wPokeAnimCommand]
	dec a
	ld c, a
	ld b, 0
	ld hl, wPokeAnimFramesAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	add hl, bc
	ld a, [wPokeAnimFramesBank]
	push af
	call GetFarHalfword
	pop af
	call GetFarByteAndIncrement
	ld d, a

	push hl
	; copy bitmask to buffer
	ld a, [wPokeAnimFrontpicHeight]
	ld c, a
	ld b, 0
	cp 7
	jr nc, .got_size
	dec c
.got_size
	ld hl, wPokeAnimBitmaskAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, d
	rst AddNTimes
	ld de, wPokeAnimBitmaskBuffer
	ld a, [wPokeAnimBitmaskBank]
	call FarCopyBytes

	; convert and apply bitmask
	xor a
	ld hl, wPokeAnimBitmaskCurCol
	ld [hli], a
	ld [hl], a
	ld d, a
.loop
	ld a, d
	inc d
	and 7
	jr nz, .got_byte
	ld a, d
	rrca
	rrca
	rrca
	and 7
	add LOW(wPokeAnimBitmaskBuffer)
	ld l, a
	adc HIGH(wPokeAnimBitmaskBuffer)
	sub l
	ld h, a
	ld e, [hl]
.got_byte

	rr e
	jr nc, .next

	ld a, [wPokeAnimFramesBank]
	pop hl
	call GetFarByteAndIncrement
	push hl
	; Picture size-dependant adjustments. They were here when I started mucking around; I don't
	; understand why they're necessary.
	push af
	ld a, [wPokeAnimFrontpicHeight]
	sub 5
	lb bc, 5 * 5, 24
	ld hl, ._5by5
	jr z, .check_add
	dec a
	jr nz, .pop_and_finish
	lb bc, 6 * 6, 13
	ld hl, ._6by6

.check_add
	pop af
	cp b
	jr c, .table_adjustment
	add c
	jr .finished_size

.table_adjustment
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hl]
	push af
.pop_and_finish
	pop af
.finished_size
	ld hl, wPokeAnimGraphicStartTile
	add [hl]
	push af

	; get start coord
	ld hl, wPokeAnimFrontpicHeight
	ld a, [hld]
	lb bc, 0, 6
	cp 7
	jr z, .okay
	lb bc, SCREEN_WIDTH + 1, SCREEN_WIDTH + 5
	cp 6
	jr z, .okay
	lb bc, 2 * SCREEN_WIDTH + 1, 2 * SCREEN_WIDTH + 5
.okay

	ld a, [wBoxAlignment]
	and a
	push af
	jr nz, .add_c
	ld c, b
.add_c
	ld b, 0
	ld a, [hld]
	ld l, [hl] ; wPokeAnimCoord
	ld h, a
	add hl, bc

	; add current coords
	ld a, [wPokeAnimBitmaskCurRow]
	ld c, SCREEN_WIDTH
	rst AddNTimes
	pop af ; also clears carry
	ld a, [wPokeAnimBitmaskCurCol]
	jr z, .done
	cpl
	sub -1
.done
	ld c, a
	sbc a
	ld b, a
	add hl, bc

	pop af
	ld [hl], a

.next
	ld hl, wPokeAnimBitmaskCurRow
	inc [hl]
	ld a, [wPokeAnimFrontpicHeight]
	cp [hl]
.go_loop ; extend the range
	jp nz, .loop
	ld [hl], 0
	dec hl ; move to wPokeAnimBitmaskCurCol
	inc [hl]
	cp [hl]
	jr nz, .go_loop
	pop hl ; discard the animation tile list pointer

.got_frame
	ld a, [wPokeAnimParameter]
; a * (1 + [wPokeAnimSpeed] / 16)
	ld c, a
	ld hl, 0
	ld b, l ; 0
	ld a, [wPokeAnimSpeed]
	rst AddNTimes

	ld a, h
	and $0f
	ld h, a
	ld a, l
	and $f0
	or h
	swap a

	add c
	ld [wPokeAnimWaitCounter], a

	ld hl, wPokeAnimJumptableIndex
	inc [hl]
.WaitAnim
	ld hl, wPokeAnimWaitCounter
	dec [hl]
	ret nz
	assert HIGH(wPokeAnimJumptableIndex) == HIGH(wPokeAnimWaitCounter)
	ld l, LOW(wPokeAnimJumptableIndex)
	dec [hl]
	ret

MACRO poke_anim_box
y = 7
rept \1
x = 7 - \1
rept \1
	db x + y
x = x + 1
endr
y = y + 7
endr
ENDM

._5by5:
	poke_anim_box 5
	; db  9, 10, 11, 12, 13
	; db 16, 17, 18, 19, 20
	; db 23, 24, 25, 26, 27
	; db 30, 31, 32, 33, 34
	; db 37, 38, 39, 40, 41

._6by6:
	poke_anim_box 6
	; db  8,  9, 10, 11, 12, 13
	; db 15, 16, 17, 18, 19, 20
	; db 22, 23, 24, 25, 26, 27
	; db 29, 30, 31, 32, 33, 34
	; db 36, 37, 38, 39, 40, 41
	; db 43, 44, 45, 46, 47, 48

PokeAnim_IsEgg:
	ld a, [wPokeAnimSpecies]
	cp EGG
	ret

PokeAnim_PlaceGraphic:
	call .ClearBox
	ld a, [wBoxAlignment]
	and a
	ld de, 1
	ld b, d
	ld c, d
	jr z, .okay

.flipped
	dec de
	dec de
	ld c, 6

.okay
	ld hl, wPokeAnimCoord
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	lb bc, 7, 7
	ld a, [wPokeAnimGraphicStartTile]
.loop
	push bc
	push hl
	push de
	ld de, SCREEN_WIDTH
.loop2
	ld [hl], a
	inc a
	add hl, de
	dec b
	jr nz, .loop2
	pop de
	pop hl
	add hl, de
	pop bc
	dec c
	jr nz, .loop
	ret

.ClearBox
	ld hl, wPokeAnimCoord
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb bc, 7, 7
	jp ClearBox

PokeAnim_SetVBank1:
	ldh a, [rSVBK]
	push af
	wbk BANK(wPokeAnimSceneIndex)
	xor a
	ldh [hBGMapMode], a

	call PokeAnim_GetAttrMapCoord
	lb bc, 7, 7
	ld de, SCREEN_WIDTH
.row
	push bc
	push hl
.col
	set 3, [hl]
	add hl, de
	dec c
	jr nz, .col
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .row

	callba HDMAHBlankTransferAttrMap_DuringDI
	pop af
	ldh [rSVBK], a
	ret

PokeAnim_SetVBank0:
	call PokeAnim_GetAttrMapCoord
	lb bc, 7, 7
	ld de, SCREEN_WIDTH
.row
	push bc
	push hl
.col
	res 3, [hl]
	add hl, de
	dec c
	jr nz, .col
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .row
	ret

PokeAnim_GetAttrMapCoord:
	ld hl, wPokeAnimCoord
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wAttrMap - wTileMap
	add hl, de
	ret

GetMonAnimPointer:
	ld c, BANK(PicAnimations)
	ld hl, AnimationPointers
	ld de, AnimationExtraPointers

	ld a, [wPokeAnimExtraFlag]
	and a
	jr z, .extras
	ld h, d
	ld l, e
.extras

	call PokeAnim_IsEgg
	jr z, .egg

	ld a, [wPokeAnimSpecies2]
	dec a
	ld e, a
	jr .selected

.egg
	ld e, EGG - 1

.selected
	ld d, 0
	add hl, de
	add hl, de
	ld a, c
	ld [wPokeAnimPointerBank], a
	call GetFarHalfword
	ld a, l
	ld [wPokeAnimPointerAddr], a
	ld a, h
	ld [wPokeAnimPointerAddr + 1], a
	ret

PokeAnim_GetFrontpicDims:
	ldh a, [rSVBK]
	push af
	wbk BANK(wCurPartySpecies)
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBasePicSize]
	and $f
	ld c, a
	pop af
	ldh [rSVBK], a
	ret

GetMonFramesPointer:
	call PokeAnim_IsEgg
	jr nz, .ok
	ld a, EGG - 1
	jr .selected
.ok
	ld a, [wPokeAnimSpecies2]
	dec a
.selected
	ld e, a
	ld d, 0
	ld hl, FramesPointers
	add hl, de
	add hl, de
	add hl, de
	ld a, BANK(FramesPointers)
	call GetFarByteHalfword
	ld [wPokeAnimFramesBank], a
	ld a, l
	ld [wPokeAnimFramesAddr], a
	ld a, h
	ld [wPokeAnimFramesAddr + 1], a
	ret

GetMonBitmaskPointer:
	call PokeAnim_IsEgg

	ld a, BANK(BitmasksPointers)
	ld hl, BitmasksPointers
	ld [wPokeAnimBitmaskBank], a

	jr z, .egg

	ld a, [wPokeAnimSpecies2]
	dec a
	ld e, a
	jr .selected

.egg
	ld e, EGG - 1

.selected
	ld d, 0
	add hl, de
	add hl, de
	ld a, [wPokeAnimBitmaskBank]
	call GetFarHalfword
	ld a, l
	ld [wPokeAnimBitmaskAddr], a
	ld a, h
	ld [wPokeAnimBitmaskAddr + 1], a
	ret

HOF_AnimateFrontpic:
	call AnimateMon_CheckIfPokemon
	jr c, .fail
	ld h, d
	ld l, e
	push bc
	push hl
	ld de, vBGTiles
	predef GetAnimatedFrontpic
	pop hl
	pop bc
	ld d, 0
	ld e, c
	call AnimateFrontpic
	xor a
	ld [wBoxAlignment], a
	ret

.fail
	xor a
	ld [wBoxAlignment], a
	inc a
	ld [wCurPartySpecies], a
	ret
