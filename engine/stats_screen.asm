BattleStatsScreenInit:
StatsScreenInit:
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a ; disable overworld tile animations
	ld a, [wBoxAlignment] ; whether sprite is to be mirrorred
	push af
	ld a, [wJumptableIndex]
	ld b, a
	ld a, [wcf64]
	ld c, a

	push bc
	call ClearBGPalettes
	call ClearTileMap
	call UpdateSprites
	callba StatsScreen_LoadFont
	call StatsScreenMain
	call ClearBGPalettes
	call ClearTileMap
	pop bc

	; restore old values
	ld a, b
	ld [wJumptableIndex], a
	ld a, c
	ld [wcf64], a
	pop af
	ld [wBoxAlignment], a
	pop af
	ldh [hMapAnims], a
	ret

StatsClearPokemonBox:
	push hl
	push de
	push bc
	push af
	ld a, " "
	hlcoord 0, 0
	lb bc, 7, 7
	call FillBoxWithByte
	jp PopOffRegsAndReturn

StatsScreenMain:
	xor a
	ld [wJumptableIndex], a
	and $f8
	or 1
	ld [wcf64], a

.loop
	ld a, [wJumptableIndex]
	and $7f
	jumptable .jumptable
	call StatsScreen_WaitAnim ; check for keys?
	ld a, [wJumptableIndex]
	add a, a
	jr nc, .loop
	ret

.jumptable
	dw MonStatsInit       ; regular pokémon
	dw EggStatsInit       ; egg
	dw StatsScreenWaitCry
	dw EggStatsJoypad
	dw StatsScreen_LoadPage
	dw StatsScreenWaitCry
	dw MonStatsJoypad
	dw StatsScreen_Exit

StatsScreen_WaitAnim:
	ld hl, wcf64
	bit 6, [hl]
	jr nz, .try_anim
	bit 5, [hl]
	jr nz, .finishFrame
	jp DelayFrame

.try_anim
	callba SetUpPokeAnim
	ldh a, [hDEDCryFlag]
	and a
	jr nz, .playDEDCry
.checkForPicAnim
	ldh a, [hRunPicAnim]
	and a
	jr nz, .finishFrame
	ld hl, wcf64
	res 6, [hl]
.finishFrame
	ld hl, wcf64
	res 5, [hl]
	jpba HDMATransferTileMapToWRAMBank3
.playDEDCry
	push af
	callba HDMATransferTileMapToWRAMBank3
	pop af
	; PokeAnim_CryNoWait calls this for regular cries
	call PlayCry2
	jr .checkForPicAnim

StatsScreen_SetJumptableIndex:
	ld a, [wJumptableIndex]
	and $80
	or h
	ld [wJumptableIndex], a
	ret

StatsScreen_Exit:
	ld hl, wJumptableIndex
	set 7, [hl]
	xor a
	ldh [hRunPicAnim], a
	ret

MonStatsInit:
	xor a
	ldh [hRunPicAnim], a
	ld hl, wcf64
	res 6, [hl]
	call ClearBGPalettes
	call ClearTileMap
	callba HDMATransferTileMapToWRAMBank3
	call StatsScreen_CopyToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, MonStatsInit_egg
	call StatsScreen_InitUpperHalf
	ld hl, wcf64
	set 4, [hl]
	ld h, 4
	call StatsScreen_SetJumptableIndex

InitStatsScreenAnimCounter:
	ld a, 90 ; 1.5 seconds
	ld [wcf65], a
	ret

MonStatsInit_egg:
	ld h, 1
	jr StatsScreen_SetJumptableIndex

EggStatsInit:
	call EggStatsScreen
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

EggStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .check
	ld h, 0
	jr StatsScreen_SetJumptableIndex

.check
	bit A_BUTTON_F, a
	jr nz, .quit
	and D_DOWN | D_UP | A_BUTTON | B_BUTTON
	jp StatsScreen_JoypadAction

.quit
	ld h, 7
	jr StatsScreen_SetJumptableIndex

StatsScreen_LoadPage:
	call StatsScreen_LoadGFX
	ld hl, wcf64
	res 4, [hl]
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

MonStatsJoypad:
	call StatsScreen_GetJoypad
	jr nc, .next
	ld h, 0
	jr StatsScreen_SetJumptableIndex

.next
	and D_DOWN | D_UP | D_LEFT | D_RIGHT | A_BUTTON | B_BUTTON
	call StatsScreen_JoypadAction
	ldh a, [hRunPicAnim]
	and a
	ret nz
	call StatsScreen_GetAnimationParam
	ret nc
	ld hl, wcf65
	dec [hl]
	ret nz
	ld a, [wJumptableIndex]
	and a
	ret z
	cp 7
	ret z
	call InitStatsScreenAnimCounter
	jp ReAnimateStatsScreenMon

StatsScreenWaitCry:
	call IsSFXPlaying
	ret nc
	ld a, [wJumptableIndex]
	inc a
	ld [wJumptableIndex], a
	ret

StatsScreen_CopyToTempMon:
	ld a, [wMonType]
	cp BREEDMON
	jr nz, .breedmon
	ld a, [wBufferMon]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wBufferMon
	ld de, wTempMon
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	jr .done

.breedmon
	callba CopyPkmnToTempMon
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .done
	ld a, [wMonType]
	cp BOXMON
	jr c, .done
	callba CalcTempmonStats
.done
	and a
	ret

StatsScreen_GetJoypad:
	call GetJoypad
	ld a, [wMonType]
	cp BREEDMON
	jr nz, .notbreedmon
	push hl
	push de
	push bc
	callba StatsScreenDPad
	pop bc
	pop de
	pop hl
	ld a, [wMenuJoypad]
	and D_DOWN | D_UP
	jr nz, .set_carry
	ld a, [wMenuJoypad]
	jr .clear_flags

.notbreedmon
	ldh a, [hJoyPressed]
.clear_flags
	and a
	ret

.set_carry
	scf
	ret

StatsScreen_JoypadAction:
	push af
	ld a, [wcf64]
	and 7
	ld c, a
	pop af
	bit B_BUTTON_F, a
	jp nz, .b_button
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit D_UP_F, a
	jr nz, .d_up
	bit D_DOWN_F, a
	ret z

; d_down
	ld a, [wMonType]
	cp BOXMON
	ret nc
	and a
	ld a, [wPartyCount]
	jr z, .next_mon
	ld a, [wOTPartyCount]
.next_mon
	ld b, a
	ld a, [wCurPartyMon]
	ld c, a
.checkValidMonLoop_down
	ld a, [wCurPartyMon]
	inc a
	cp b
	jr nz, .notEnd_down
	ld a, c
	ld [wCurPartyMon], a
	ret
.notEnd_down
	ld [wCurPartyMon], a
	ld a, [wMonType]
	and a
	jr nz, .checkMonSpecies_down
	ld a, [wCurPartyMon]
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon
.checkMonSpecies_down
	call .CheckOTMonSpecies
	jr nz, .load_mon
	jr .checkValidMonLoop_down

.d_up
	ld a, [wCurPartyMon]
	ld c, a
.checkValidMonLoop_up
	ld a, [wCurPartyMon]
	and a
	jr nz, .notEnd_up
	ld a, c
	ld [wCurPartyMon], a
	ret
.notEnd_up
	dec a
	ld [wCurPartyMon], a
	ld b, a
	ld a, [wMonType]
	and a
	jr nz, .checkMonSpecies_up
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	jr .load_mon
.checkMonSpecies_up
	call .CheckOTMonSpecies
	jr nz, .load_mon
	jr .checkValidMonLoop_up

.d_left
	dec c
	jr nz, .set_page
	ld c, 4
	jr .set_page

.a_button
	ld a, c
	cp 4
	jr z, .b_button
.d_right
	inc c
	ld a, 4
	cp c
	jr nc, .set_page
	ld c, 1
	; fallthrough

.set_page
	ld a, [wcf64]
	and %11111000
	or c
	ld [wcf64], a
	ld h, 4
	jp StatsScreen_SetJumptableIndex

.load_mon
	ld h, 0
	jp StatsScreen_SetJumptableIndex

.b_button
	ld h, 7
	jp StatsScreen_SetJumptableIndex

.CheckOTMonSpecies:
	ld a, [wCurPartyMon]
	add LOW(wOTPartySpecies)
	ld l, a
	adc HIGH(wOTPartySpecies)
	sub l
	ld h, a
	ld a, [hl]
	and a
	ret

StatsScreen_InitUpperHalf:
	call .PlaceHPBar
	xor a
	ldh [hBGMapMode], a
	ld a, [wCurBaseData]
	ld [wd265], a
	ld [wCurSpecies], a
	hlcoord 8, 0
	ld [hl], "№"
	inc hl
	ld [hl], "."
	inc hl
	hlcoord 10, 0

	push hl
	callba Pokedex_GetNaljoNum
	pop hl
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	ld de, wDexSearchMonType2

	call PrintNum
	hlcoord 14, 0
	call PrintLevel
	ld hl, .NicknamePointers
	call GetNicknamePointer
	call CopyNickname
	hlcoord 8, 2
	call PlaceString
	hlcoord 18, 0
	call .PlaceGenderChar
	hlcoord 9, 4
	ld a, "/"
	ld [hli], a
	ld a, [wCurBaseData]
	ld [wd265], a
	call GetPokemonName
	call PlaceString
	call StatsScreen_PlacePageSwitchArrows
	call StatsScreen_PlaceShinyIcon
	jp StatsClearPokemonBox

.PlaceHPBar
	ld hl, wTempMonHP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wTempMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	callba ComputeHPBarPixels
	ld hl, wcda1
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	predef GetSGBLayout
	jp DelayFrame

.PlaceGenderChar
	push hl
	callba GetGender
	pop hl
	ret c
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"
.got_gender
	ld [hl], a
	ret

.NicknamePointers
	dw wPartyMonNicknames
	dw wOTPartyMonNicknames
	dw sBoxMonNicknames
	dw wBufferMonNick

StatsScreen_PlaceHorizontalDivider:
	hlcoord 0, 7
	ld b, SCREEN_WIDTH
	ld a, $33
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

StatsScreen_PlacePageSwitchArrows:
	hlcoord 10, 6
	ld [hl], "◀"
	hlcoord 19, 6
	ld [hl], "▶"
	ret

StatsScreen_PlaceShinyIcon:
	ld hl, wTempMonDVs
	callba CheckShininessHL
	ret nc
	hlcoord 19, 0
	ld [hl], "<SHINY>"
	ret

StatsScreen_LoadGFX:
	ld a, [wBaseDexNo]
	ld [wd265], a
	ld [wCurSpecies], a
	xor a
	ldh [hBGMapMode], a
	call StatsScreen_PlaceHorizontalDivider
	call .ClearBox
	call .PageTilemap
	call .LoadPals
	ld hl, wcf64
	bit 4, [hl]
	jp z, SetPalettes
	jp StatsScreen_PlaceFrontpic

.ClearBox
	ld a, [wcf64]
	and 7
	ld c, a
	call StatsScreen_LoadPageIndicators
	hlcoord 0, 8
	lb bc, 10, 20
	jp ClearBox

.LoadPals
	ld a, [wcf64]
	and 7
	ld c, a
	callba LoadStatsScreenPals
	call DelayFrame
	ld hl, wcf64
	set 5, [hl]
	ret

.PageTilemap
	ld a, [wcf64]
	and 7
	dec a
	jumptable

	dw .PinkPage
	dw .GreenPage
	dw .BluePage
	dw .OrangePage

.PinkPage
	hlcoord -1, 9
	ld b, 0
	predef DrawPlayerHP
	ld a, " "
	ldcoord_a -1, 9
	ld de, .Status_Type
	hlcoord 0, 12
	call PlaceText
	ld a, [wTempMonPokerusStatus]
	ld b, a
	and $f
	jr nz, .HasPokerus
	ld a, b
	and $f0
	jr z, .NotImmuneToPkrs
	hlcoord 8, 12
	ld [hl], "<NOPKRS>"
.NotImmuneToPkrs
	ld a, [wMonType]
	cp BOXMON
	jr z, .StatusOK
	hlcoord 6, 13
	push hl
	ld de, wTempMonStatus
	predef PlaceStatusString
	pop hl
	jr nz, .done_status
	jr .StatusOK
.HasPokerus
	ld de, .PkrsStr
	hlcoord 1, 13
	call PlaceText
	jr .done_status
.StatusOK
	ld de, .OK_str
	call PlaceText
.done_status
	hlcoord 1, 15
	call PrintMonTypes
	hlcoord 9, 8
	ld de, SCREEN_WIDTH
	ld b, 10
	ld a, $31
.vertical_divider
	ld [hl], a
	add hl, de
	dec b
	jr nz, .vertical_divider
	hlcoord 9, 7
	ld [hl], $34
	hlcoord 9, 9
	ld a, $32
	ld [hli], a
	ld de, .ExpPointStr
	call PlaceText
	hlcoord 17, 14
	call .PrintNextLevel
	hlcoord 13, 10
	lb bc, 3, 7
	ld de, wTempMonExp
	call PrintNum
	call CalcExpToNextLevel
	hlcoord 13, 13
	lb bc, 3, 7
	ld de, wExpToNextLevel
	call PrintNum
	ld de, .LevelUpStr
	hlcoord 10, 12
	call PlaceText
	ld de, .ToStr
	hlcoord 14, 14
	call PlaceText
	hlcoord 10, 16
	ld a, [wTempMonLevel]
	ld b, a
	ld de, wTempMonExp + 2
	predef FillInExpBar
	hlcoord 9, 16
	ld [hl], $40
	hlcoord 19, 16
	ld [hl], $41
	ret

.PrintNextLevel
	ld a, [wTempMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .AtMaxLevel
	inc a
	ld [wTempMonLevel], a
.AtMaxLevel
	call PrintLevel
	pop af
	ld [wTempMonLevel], a
	ret

.Status_Type
	text "Status/"
	next "Type/"
	done

.OK_str
	text "OK "
	done

.ExpPointStr
	ctxt "Exp Points"
	done

.LevelUpStr
	text "Level Up"
	done

.ToStr
	text "to"
	done

.PkrsStr
	text "#rus"
	done

.GreenPage
	ld de, .Item
	hlcoord 0, 8
	call PlaceText
	call .GetItemName
	hlcoord 8, 8
	call PlaceString
	ld de, .Move
	hlcoord 0, 10
	call PlaceText
	ld hl, wTempMonMoves
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	rst CopyBytes
	hlcoord 8, 10
	ld a, SCREEN_WIDTH * 2
	ld [wListMoves_Spacing], a
	predef ListMoves
	hlcoord 12, 11
	ld a, SCREEN_WIDTH * 2
	ld [wListMoves_Spacing], a
	predef_jump ListMovePP

.GetItemName
	ld de, .ThreeDashes
	ld a, [wTempMonItem]
	and a
	ret z
	ld b, a
	callba TimeCapsule_ReplaceTeruSama
	ld a, b
	ld [wd265], a
	jp GetItemName

.Item
	text "Item"
	done

.ThreeDashes
	db "---@"

.Move
	text "Move"
	done

.BluePage
	call .PlaceOTInfo
	hlcoord 10, 8
	ld de, SCREEN_WIDTH
	ld b, 10
	ld a, $31
.BluePageVerticalDivider
	ld [hl], a
	add hl, de
	dec b
	jr nz, .BluePageVerticalDivider
	hlcoord 10, 7
	ld [hl], $34
	hlcoord 11, 8
	ld bc, 6
	predef_jump PrintTempMonStats

.PlaceOTInfo
	ld de, IDNoString
	hlcoord 0, 9
	call PlaceString
	ld de, OTString
	hlcoord 0, 12
	call PlaceString
	hlcoord 2, 10
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	ld de, wTempMonID
	call PrintNum
	ld hl, .OTNamePointers
	call GetNicknamePointer
	call CopyNickname
	callba CheckNickErrors
	hlcoord 2, 13
	call PlaceString
	ld a, [wTempMonCaughtGender]
	and a
	ret z
	cp " "
	ret z
	add a, a
	; a = carry ? "♀" : "♂"
	sbc a
	and "♀" - "♂"
	add "♂"
	hlcoord 9, 13
	ld [hl], a
	ret

.OTNamePointers
	dw wPartyMonOT
	dw wOTPartyMonOT
	dw sBoxMonOT
	dw wBufferMonOT

.OrangePage
INCLUDE "engine/trainer_notes.asm"

CalcExpToNextLevel::
	ld a, [wTempMonLevel]
	cp MAX_LEVEL
	jr z, .AlreadyAtMaxLevel
	inc a
	ld d, a
	callba CalcExpAtLevel
	ld hl, wTempMonExp + 2
	ldh a, [hQuotient + 2]
	ld [wTotalExpToNextLevel + 2], a
	sub [hl]
	dec hl
	ld [wExpToNextLevel + 2], a
	ldh a, [hQuotient + 1]
	ld [wTotalExpToNextLevel + 1], a
	sbc [hl]
	dec hl
	ld [wExpToNextLevel + 1], a
	ldh a, [hQuotient]
	ld [wTotalExpToNextLevel], a
	sbc [hl]
	ld [wExpToNextLevel], a
	ret

.AlreadyAtMaxLevel
	ld hl, wExpToNextLevel
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

IDNoString:
	db "<ID>№.@"

OTString:
	db "OT/@"

StatsScreen_PlaceFrontpic:
	call StatsScreen_GetAnimationParam
	jr c, .notFainted
	jr z, .fainted
; wild mon
	call SetPalettes
	call .AnimateMon
	ld a, [wCurPartySpecies]
	jp PlayCry2
.fainted
	call .AnimateEgg
	jr .SetPalettes
.notFainted
	call .AnimateMon
.SetPalettes
	jp SetPalettes

.AnimateEgg
	ld hl, wcf64
	set 5, [hl]
	hlcoord 0, 0
	jp PrepMonFrontpic

.AnimateMon
	ld a, TRUE
	ld [wBoxAlignment], a
	ld a, [wCurPartySpecies]
	call IsAPokemon
	ret c
	call StatsScreen_LoadTextBoxSpaceGFX
	ld de, vBGTiles tile $00
	predef GetAnimatedFrontpic
	lb de, 0, ANIM_MON_MENU
StatsScreen_PlaceFrontpic_common:
	hlcoord 0, 0
	predef LoadMonAnimation
	ld hl, wcf64
	set 6, [hl]
	ld a, 1
	ldh [hRunPicAnim], a
	ret

ReAnimateStatsScreenMon:
	lb de, 0, ANIM_MON_MENU_REPEATING
	jr StatsScreen_PlaceFrontpic_common

StatsScreen_GetAnimationParam:
	ld a, [wMonType]
	jumptable

	dw .PartyMon
	dw .OTPartyMon
	dw .BoxMon
	dw .Tempmon
	dw .Wildmon

.PartyMon
	ld a, [wCurPartyMon]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld b, h
	ld c, l
	jr .CheckEggFaintedFrzSlp

.FaintedFrzSlp
.OTPartyMon
	xor a
	ret

.BoxMon
	ld hl, sBoxMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld b, h
	ld c, l
	sbk BANK(sBoxMons)
	call .CheckEggFaintedFrzSlp
	jp CloseSRAM

.Tempmon
	ld bc, wTempMonSpecies
.CheckEggFaintedFrzSlp
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call CheckFaintedFrzSlp
	jr c, .FaintedFrzSlp
.egg
	xor a
	scf
	ret

.Wildmon
	ld a, 1
	and a
	ret

StatsScreen_LoadTextBoxSpaceGFX:
	push hl
	push de
	push bc
	push af
	call DelayFrame
	ldh a, [rVBK]
	push af
	vbk BANK(vBGTiles2)
	ld de, TextBoxSpaceGFX
	lb bc, BANK(TextBoxSpaceGFX), 1
	ld hl, vBGTiles2 tile $7f
	call Get2bpp
	pop af
	ldh [rVBK], a
	jp PopOffRegsAndReturn

EggStatsScreen:
	xor a
	ldh [hBGMapMode], a
	ld hl, wcda1
	call SetHPPal
	ld b, SCGB_STATS_SCREEN_HP_PALS
	predef GetSGBLayout
	call StatsScreen_PlaceHorizontalDivider
	ld de, EggString
	hlcoord 8, 1
	call PlaceString
	ld de, IDNoString
	hlcoord 8, 3
	call PlaceString
	ld de, OTString
	hlcoord 8, 5
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 3
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 5
	call PlaceString
	ld a, [wTempMonHappiness] ; egg status
	ld de, EggSoonString
	cp 6
	jr c, .picked
	ld de, EggCloseString
	cp 11
	jr c, .picked
	ld de, EggMoreTimeString
	cp 41
	jr c, .picked
	ld de, EggALotMoreTimeString
.picked
	hlcoord 1, 9
	call PlaceText
	ld hl, wcf64
	set 5, [hl]
	call SetPalettes ; pals
	call DelayFrame
	hlcoord 0, 0
	call PrepMonFrontpic
	callba HDMATransferTileMapToWRAMBank3
	call StatsScreen_AnimateEgg

	ld a, [wTempMonHappiness]
	cp 6
	ret nc
	ld de, SFX_2_BOOPS
	jp PlaySFX

EggString:
	db "Egg@"

FiveQMarkString:
	db "?????@"

EggSoonString:
	ctxt "It's making sounds"
	next "inside. It's going"
	next "to hatch soon!"
	done

EggCloseString:
	ctxt "It moves around"
	next "inside sometimes."
	next "It must be close"
	next "to hatching."
	done

EggMoreTimeString:
	ctxt "Wonder what's"
	next "inside? It needs"
	next "more time, though."
	done

EggALotMoreTimeString:
	ctxt "This Egg needs a"
	next "lot more time to"
	next "hatch."
	done

StatsScreen_AnimateEgg:
	call StatsScreen_GetAnimationParam
	ret nc
	ld a, [wTempMonHappiness]
	ld e, 7
	cp 6
	jr c, .animate
	inc e
	cp 11
	ret nc

.animate
	push de
	ld a, 1
	ld [wBoxAlignment], a
	call StatsScreen_LoadTextBoxSpaceGFX
	ld de, vBGTiles tile $00
	predef GetAnimatedFrontpic
	pop de
	hlcoord 0, 0
	ld d, 0
	predef LoadMonAnimation
	ld hl, wcf64
	set 6, [hl]
	ret

StatsScreen_LoadPageIndicators:
	hlcoord 11, 5
	ld a, $36
	call .load_square
	hlcoord 13, 5
	ld a, $36
	call .load_square
	hlcoord 15, 5
	ld a, $36
	call .load_square
	hlcoord 17, 5
	ld a, $36
	call .load_square
	ld a, c
	cp 2
	ld a, $3a
	hlcoord 11, 5
	jr c, .load_square
	hlcoord 13, 5
	jr z, .load_square
	bit 2, c
	hlcoord 15, 5
	jr z, .load_square
	hlcoord 17, 5
.load_square
	push bc
	ld [hli], a
	inc a
	ld [hld], a
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	pop bc
	ret

CopyNickname:
	ld de, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	ld a, [wMonType]
	cp BOXMON
	jr nz, .partymon
	sbk BANK(sBoxMonNicknames)
	push de
	rst CopyBytes
	pop de
	jp CloseSRAM

.partymon
	push de
	rst CopyBytes
	pop de
	ret

GetNicknamePointer:
	ld a, [wMonType]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonType]
	cp BREEDMON
	ret z
	ld a, [wCurPartyMon]
	jp SkipNames


CheckFaintedFrzSlp:
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .fainted_frz_slp
	ld hl, MON_STATUS
	add hl, bc
	ld a, [hl]
	and (1 << FRZ) | SLP
	ret z
.fainted_frz_slp
	scf
	ret

INCLUDE "engine/print_types.asm"
