CheckBreedmonCompatibility:
	call .CheckBreedingGroupCompatibility
	ld a, 0
	ret c
	ld a, [wBreedMon1Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon1DVs]
	ld [wTempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [wTempMonDVs + 1], a
	ld a, BREEDMON
	ld [wMonType], a
	predef GetGender
	jr c, .genderless
	ld b, 1
	jr nz, .breedmon2
	inc b

.breedmon2
	push bc
	ld a, [wBreedMon2Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon2DVs]
	ld [wTempMonDVs], a
	ld a, [wBreedMon2DVs + 1]
	ld [wTempMonDVs + 1], a
	ld a, BREEDMON
	ld [wMonType], a
	predef GetGender
	pop bc
	jr c, .genderless
	ld a, 1
	jr nz, .compare_gender
	inc a

.compare_gender
	cp b
	jr nz, .compute

.genderless
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .ditto1
	ld a, [wBreedMon2Species]
	cp DITTO
	jr nz, .no_breeding
	jr .compute

.ditto1
	ld a, [wBreedMon2Species]
	sub DITTO
	ret z ; if both are Ditto, return 0 here

.compute
	call .CheckDVs
	ld a, -1
	ret z
	ld a, [wBreedMon2Species]
	ld b, a
	ld a, [wBreedMon1Species]
	ld c, 254
	cp b
	jr z, .compare_ids
	ld c, 128
.compare_ids
	; Speed up
	ld a, [wBreedMon1ID]
	ld b, a
	ld a, [wBreedMon2ID]
	cp b
	jr nz, .done
	ld a, [wBreedMon1ID + 1]
	ld b, a
	ld a, [wBreedMon2ID + 1]
	cp b
	jr nz, .done
	ld a, c
	sub 77
	ret
.done
	ld a, c
	ret

.no_breeding
	xor a
	ret

.CheckDVs
; If Defense DVs match and the lower 3 bits of the Special DVs match,
; avoid breeding
	ld a, [wBreedMon1DVs]
	ld b, a
	ld a, [wBreedMon2DVs]
	xor b
	and %1111
	ret nz
	ld a, [wBreedMon1DVs + 1]
	ld b, a
	ld a, [wBreedMon2DVs + 1]
	xor b
	and %111
	ret

.CheckBreedingGroupCompatibility
; return carry if NOT compatible (changed from pokecrystal!)

; If either mon is in the No Eggs group,
; they are not compatible.
	ld a, [wBreedMon2Species]
	ld c, a ;store the species to use it later
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseEggGroups]
	ld b, a
	inc a
	scf
	ret z

	ld a, [wBreedMon1Species]
	cp DITTO ;if we got this far, the other mon isn't in the No Eggs group
	ret z
	ld [wCurSpecies], a
	push bc
	call GetBaseData
	pop bc
	ld a, [wBaseEggGroups]
	ld d, a
	inc a
	scf
	ret z

; Ditto is automatically compatible with everything.
	ld a, c
	cp DITTO
	ret z

; If not Ditto, compare the groups
	ld a, b
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	ld b, a
	ld a, d
	push af
	and $f
	ld d, a
	pop af
	swap a
	and $f

	cp b
	ret z
	cp c
	ret z
	ld a, d
	cp b
	ret z
	cp c
	ret z
	scf
	ret

DoEggStep::
	xor a
	ld [wEngineBuffer1], a
	call CheckFastHatchingAbilities
	sbc a
	ld b, a
	ld de, wPartySpecies
	ld hl, wPartyMon1Happiness
	jr .handleLoop

.loop
	push de
	ld de, PARTYMON_STRUCT_LENGTH
	add hl, de
	pop de
.handleLoop
	ld a, [de]
	inc de
	inc a
	jr z, .done
	cp EGG + 1
	jr nz, .loop
	dec [hl]
	jr z, .hatch
	ld a, b
	and a
	jr z, .loop
	dec [hl]
	jr nz, .loop
.hatch
	ld a, 1
	ld [wEngineBuffer1], a
	jr .loop

.done
	ld a, [wEngineBuffer1]
	and a
	ret

CheckFastHatchingAbilities:
	; returns carry if a mon in the player's party has Flame Body or Magma Armor
	ld de, wPartyCount
	ld a, [de]
	and a
	ret z ; avoid issues...
	inc de
	ld b, a
	ld hl, wPartyMon1 + MON_DVS
	jr .handleLoop
.loop
	inc de
	cp EGG
	jr z, .isEgg
	ld [wCurSpecies], a
	push hl
	call CalcMonAbility
	pop hl
	cp ABILITY_FLAME_BODY
	jr z, .found
	cp ABILITY_MAGMA_ARMOR
	jr z, .found
.isEgg
	ld a, PARTYMON_STRUCT_LENGTH
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	and a
	dec b
	ret z
.handleLoop
	ld a, [de]
	cp $ff
	jr nz, .loop
	ret

.found
	scf
	ret

OverworldHatchEgg::
	call RefreshScreen
	call LoadStandardMenuHeader
	call HatchEggs
	call ExitAllMenus
	call TryRestartMapMusic
	jp CloseText

HatchEggs:
	ld de, wPartySpecies
	ld hl, wPartyMon1Happiness
	xor a
	ld [wCurPartyMon], a

.loop
	ld a, [de]
	inc de
	cp -1
	ret z
	push de
	push hl
	cp EGG
	jp nz, .next
	ld a, [hl]
	and a
	jp nz, .next
	ld [hl], $78

	push de

	callba SetEggMonCaughtData
	ld a, [wCurPartyMon]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [hl]
	ld [wCurPartySpecies], a
	dec a
	call SetSeenAndCaughtMon

.nottogepi

	pop de

	ld a, [wCurPartySpecies]
	dec de
	ld [de], a
	ld [wd265], a
	ld [wCurSpecies], a
	call GetPokemonName
	xor a
	ld [wd26b], a
	call GetBaseData
	ld a, [wCurPartyMon]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	push hl
	ld bc, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push hl
	ld c, MON_LEVEL ; b = 0
	add hl, bc
	ld a, [hl]
	ld [wCurPartyLevel], a
	pop hl
	push hl
	ld c, MON_STATUS ; b = 0
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	pop hl
	push hl
	ld c, MON_STAT_EXP - 1 ; b = 0
	add hl, bc
	; b is still 0
	predef CalcPkmnStats
	pop bc
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_HP
	add hl, bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ld hl, MON_ID
	add hl, bc
	ld a, [wPlayerID]
	ld [hli], a
	ld a, [wPlayerID + 1]
	ld [hl], a
	ld hl, MON_MOVES
	add hl, bc
	ld d, h
	ld e, l
	callba AddMovesObtained
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, wPlayerName
	rst CopyBytes
	ld hl, .Text_HatchEgg
	call PrintText
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	push de
	ld hl, .Text_NicknameHatchling
	call PrintText
	call YesNoBox
	pop de
	jr c, .nonickname

	ld a, 1
	ld [wd26b], a
	xor a
	ld [wMonType], a
	push de
	ld b, 0
	callba NamingScreen
	pop hl
	ld de, wStringBuffer1
	call InitName
	jr .next

.nonickname
	ld hl, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

.next
	ld hl, wCurPartyMon
	inc [hl]
	pop hl
	ld de, PARTYMON_STRUCT_LENGTH
	add hl, de
	pop de
	jp .loop

.Text_HatchEgg
	text "Huh?"
	para "@"
	start_asm
	ld hl, wVramState
	res 0, [hl]
	push hl
	push de
	push bc
	ld a, [wCurPartySpecies]
	push af
	call EggHatch_AnimationSequence
	ld hl, GenericDummyText
	call PrintText
	pop af
	ld [wCurPartySpecies], a
	pop bc
	pop de
	pop hl
	ld hl, .CameOutOfItsEgg
	ret

.CameOutOfItsEgg
	ctxt "<STRBF1> came"
	line "out of its egg!@"
	start_asm
	ld de, SFX_CAUGHT_MON
	jp Text_PlaySFXAndPrompt

.Text_NicknameHatchling
	ctxt "Give a nickname to"
	line "<STRBF1>?"
	done

InitEggMoves:
	call GetHeritableMoves
	ld d, h
	ld e, l
	ld b, NUM_MOVES
.loop
	ld a, [de]
	and a
	ret z
	ld hl, wEggMonMoves
	ld c, NUM_MOVES
.next
	ld a, [de]
	cp [hl]
	jr z, .skip
	inc hl
	dec c
	jr nz, .next
	call GetEggMove
	call c, LoadEggMove

.skip
	inc de
	dec b
	jr nz, .loop
	ret

GetEggMove:
	push bc

	; check if the current move is in the list of egg moves
	ld a, [wEggMonSpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EggMovePointers
	add hl, bc
	add hl, bc
	ld a, BANK(EggMovePointers)
	call GetFarHalfword
	jr .egg_move_check_handle_loop

.egg_move_check_loop
	ld a, [de]
	cp b
	jr z, .is_egg_move
.egg_move_check_handle_loop
	ld a, BANK(EggMoves)
	call GetFarByteAndIncrement
	ld b, a
	inc a
	jr nz, .egg_move_check_loop

	; check if the parent knows the move
	call GetBreedmonMovePointer
	ld b, NUM_MOVES + 1
.egg_move_search_loop
	dec b
	jr z, .check_TMs_HMs
	ld a, [de]
	cp [hl]
	inc hl
	jr nz, .egg_move_search_loop

	; check if the mon can learn the move by level-up (and ignore it if it can)
	ld a, [wEggMonSpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarHalfword
	ld b, BANK(EvosAttacks)

.skip_evolutions_loop
	ld a, b
	call GetFarByteAndIncrement
	and a
	jr nz, .skip_evolutions_loop
	jr .levelup_move_search_handle_loop

.levelup_move_search_loop
	ld a, b
	call GetFarByteAndIncrement
	ld c, a
	ld a, [de]
	cp c
	jr z, .is_egg_move
.levelup_move_search_handle_loop
	ld a, b
	call GetFarByteAndIncrement
	and a
	jr nz, .levelup_move_search_loop

	; if the move is not an inheritable egg move, check if the mon can learn it via TM/HM
.check_TMs_HMs
	ld hl, TMHMMoves
.TM_HM_search_loop
	ld a, BANK(TMHMMoves)
	call GetFarByteAndIncrement
	and a
	jr z, .not_egg_move ;not a TM/HM move at all
	ld b, a
	ld a, [de]
	cp b
	jr nz, .TM_HM_search_loop
	ld [wPutativeTMHMMove], a
	predef CanLearnTMHMMove
	ld a, c
	and a
	jr nz, .is_egg_move
.not_egg_move
	pop bc
	ret

.is_egg_move
	pop bc
	scf
	ret

LoadEggMove:
	push de
	push bc
	ld a, [de]
	ld b, a
	ld hl, wEggMonMoves
	ld c, NUM_MOVES
.loop
	ld a, [hli]
	and a
	jr z, .done
	dec c
	jr nz, .loop
	ld de, wEggMonMoves
	ld hl, wEggMonMoves + 1
	rept 2
		ld a, [hli]
		ld [de], a
		inc de
	endr
	ld a, [hli]
	ld [de], a

.done
	dec hl
	ld [hl], b
	ld hl, wEggMonMoves
	ld de, wEggMonPP
	predef FillPP
	pop bc
	pop de
	ret

GetHeritableMoves:
	ld hl, wBreedMon2Moves
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .ditto1
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .ditto2
	ld a, [wBreedMotherOrNonDitto]
	and a
	ret z
	ld hl, wBreedMon1Moves
	ret

.ditto1
	ld a, [wCurPartySpecies]
	push af
	ld a, [wBreedMon2Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon2DVs]
	ld [wTempMonDVs], a
	ld a, [wBreedMon2DVs + 1]
	ld [wTempMonDVs + 1], a
	ld a, BREEDMON
	ld [wMonType], a
	predef GetGender
	jr c, .inherit_mon2_moves
	jr nz, .inherit_mon2_moves

.inherit_mon1_moves
	ld hl, wBreedMon1Moves
.gotMovePointer
	pop af
	ld [wCurPartySpecies], a
	ret

.ditto2
	ld a, [wCurPartySpecies]
	push af
	ld a, [wBreedMon1Species]
	ld [wCurPartySpecies], a
	ld a, [wBreedMon1DVs]
	ld [wTempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [wTempMonDVs + 1], a
	ld a, BREEDMON
	ld [wMonType], a
	predef GetGender
	jr c, .inherit_mon1_moves
	jr nz, .inherit_mon1_moves

.inherit_mon2_moves
	ld hl, wBreedMon2Moves
	jr .gotMovePointer

GetBreedmonMovePointer:
	ld hl, wBreedMon1Moves
	ld a, [wBreedMon1Species]
	cp DITTO
	ret z
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .ditto
	ld a, [wBreedMotherOrNonDitto]
	and a
	ret z

.ditto
	ld hl, wBreedMon2Moves
	ret

GetEggFrontpic:
	push de
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	pop de
	predef_jump GetFrontpic

GetHatchlingFrontpic:
	push de
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	pop de
	predef_jump GetAnimatedFrontpic

Hatch_UpdateFrontpicBGMapCenter:
	push af
	call WaitTop
	push hl
	push bc
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	pop bc
	pop hl
	ld a, b
	ldh [hBGMapAddress + 1], a
	ld a, c
	ldh [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	pop af
	call Hatch_LoadFrontpicPal
	call SetPalettes
	jp ApplyAttrAndTilemapInVBlank

EggHatch_DoAnimFrame:
	push hl
	push de
	push bc
	callba PlaySpriteAnimations
	call DelayFrame
	pop bc
	pop de
	pop hl
	ret

EggHatch_AnimationSequence:
	ld a, [wd265]
	ld [wJumptableIndex], a
	ld a, [wCurSpecies]
	push af
	ld de, MUSIC_NONE
	call PlayMusic
	callba BlankScreen
	call DisableLCD
	hlbgcoord 20, 0
	call .clearborder
	hlbgcoord 31, 0
	call .clearborder
	ld hl, EggHatchGFX
	ld de, vObjTiles tile $00
	ld bc, $20
	ld a, BANK(EggHatchGFX)
	call FarCopyBytes
	callba ClearSpriteAnims
	ld de, vBGTiles tile $00
	ld a, [wJumptableIndex]
	call GetHatchlingFrontpic
	ld de, vBGTiles tile $31
	ld a, EGG
	call GetEggFrontpic
	ld de, MUSIC_EVOLUTION
	call PlayMusic
	call EnableLCD
	hlcoord 7, 4
	lb bc, HIGH(vBGMap), $31 ; Egg tiles start here
	ld a, EGG
	call Hatch_UpdateFrontpicBGMapCenter
	ld c, 80
	call DelayFrames
	xor a
	ld [wcf64], a
	ldh a, [hSCX]
	ld b, a
.outerloop
	ld hl, wcf64
	ld a, [hl]
	inc [hl]
	cp 8
	jr nc, .done
	ld e, [hl]
.loop
; wobble e times
	ld a, 2
	ldh [hSCX], a
	ld a, -2
	ld [wGlobalAnimXOffset], a
	call EggHatch_DoAnimFrame
	ld c, 2
	call DelayFrames
	ld a, -2
	ldh [hSCX], a
	ld a, 2
	ld [wGlobalAnimXOffset], a
	call EggHatch_DoAnimFrame
	ld c, 2
	call DelayFrames
	dec e
	jr nz, .loop
	ld c, 16
	call DelayFrames
	call EggHatch_CrackShell
	jr .outerloop

.done
	ld de, SFX_EGG_HATCH
	call PlaySFX
	xor a
	ldh [hSCX], a
	ld [wGlobalAnimXOffset], a
	call ClearSprites
	call Hatch_InitShellFragments
	hlcoord 6, 3
	lb bc, HIGH(vBGMap), $00 ; Hatchling tiles start here
	ld a, [wJumptableIndex]
	call Hatch_UpdateFrontpicBGMapCenter
	call Hatch_ShellFragmentLoop
	call WaitSFX
	ld a, [wJumptableIndex]
	ld [wCurPartySpecies], a
	hlcoord 6, 3
	lb de, 0, ANIM_MON_HATCH
	predef AnimateFrontpic
	pop af
	ld [wCurSpecies], a
	ret

.clearborder
	ld de, BG_MAP_WIDTH
	lb bc, SCREEN_HEIGHT, " "
.clearborderloop
	ld [hl], c
	add hl, de
	dec b
	jr nz, .clearborderloop
	ret

Hatch_LoadFrontpicPal:
	ld [wPlayerHPPal], a
	lb bc, SCGB_EVOLUTION, 0
	predef_jump GetSGBLayout

EggHatch_CrackShell:
	ld a, [wcf64]
	dec a
	and 7
	cp 7
	ret z
	srl a
	ret nc
	swap a
	srl a
	add 9 * 8 + 4
	ld d, a
	ld e, 11 * 8
	ld a, SPRITE_ANIM_INDEX_EGG_CRACK
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], 0
	ld de, SFX_EGG_CRACK
	jp PlaySFX

EggHatchGFX: INCBIN "gfx/evo/egg_hatch.2bpp"

Hatch_InitShellFragments:
	callba ClearSpriteAnims
	ld hl, .SpriteData
.loop
	ld a, [hli]
	cp -1
	jr z, .done
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	push bc

	ld a, SPRITE_ANIM_INDEX_EGG_HATCH
	call _InitSpriteAnimStruct

	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], 0

	pop de
	ld a, e
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	add [hl]
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], d

	pop hl
	jr .loop
.done
	ld de, SFX_EGG_HATCH
	call PlaySFX
	jp EggHatch_DoAnimFrame

.SpriteData
; Probably OAM.
	dsprite 10, 4,  9, 0, $00, $3c
	dsprite 11, 4,  9, 0, $01, $04
	dsprite 10, 4, 10, 0, $00, $30
	dsprite 11, 4, 10, 0, $01, $10
	dsprite 10, 4, 11, 0, $02, $24
	dsprite 11, 4, 11, 0, $03, $1c
	dsprite 10, 0,  9, 4, $00, $36
	dsprite 12, 0,  9, 4, $01, $0a
	dsprite 10, 0, 10, 4, $02, $2a
	dsprite 12, 0, 10, 4, $03, $16
	db -1

Hatch_ShellFragmentLoop:
	ld c, 129
.loop
	call EggHatch_DoAnimFrame
	dec c
	jr nz, .loop
	ret

Special_DayCareMon1:
	ld hl, DayCareMonLeftWithChickText
	call PrintText
	ld a, [wBreedMon1Species]
	call PlayCry
	ld a, [wDaycareLady]
	ld hl, wBreedMon2Nick
	jr Special_DayCareMon_Continue

Special_DayCareMon2:
	ld hl, DayCareMonLeftWithDudeText
	call PrintText
	ld a, [wBreedMon2Species]
	call PlayCry
	ld a, [wDaycareMan]
	ld hl, wBreedMon1Nick
Special_DayCareMon_Continue:
	rra
	jp nc, WaitPressAorB_BlinkCursor
	push hl
	call ButtonSound
	pop hl
	call DayCareMonCompatibilityText
	jp PrintText

DayCareMonLeftWithDudeText:
	text "It's @"
	text_from_ram wBreedMon2Nick
	ctxt ""
	line "that was left with"
	cont "the Day-Care Dude."
	done

DayCareMonLeftWithChickText:
	text "It's @"
	text_from_ram wBreedMon1Nick
	ctxt ""
	line "that was left with"
	para "the Day-Care"
	line "Chick."
	done

DayCareMonCompatibilityText:
	push bc
	ld de, wStringBuffer1
	ld bc, NAME_LENGTH
	rst CopyBytes
	call CheckBreedmonCompatibility
	pop bc
	ld hl, .AllAlone
	cp -1
	ret z
	ld hl, .Incompatible
	and a
	ret z
	ld hl, .HighCompatibility
	cp 230
	ret nc
	cp 70
	ld hl, .ModerateCompatibility
	ret nc
	ld hl, .SlightCompatibility
	ret

.AllAlone
	ctxt "It's brimming with"
	line "energy."
	prompt

.Incompatible
	ctxt "It has no interest"
	line "in <STRBF1>."
	prompt

.HighCompatibility
	ctxt "It appears to care"
	line "for <STRBF1>."
	prompt

.ModerateCompatibility
	ctxt "It's friendly with"
	line "<STRBF1>."
	prompt

.SlightCompatibility
	ctxt "It shows interest"
	line "in <STRBF1>."
	prompt
