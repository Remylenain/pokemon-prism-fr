CheckAtLeastThreeLegalPokemon::
; Counts number of legal party mons. Returns to hScriptVar
	ld hl, wPartySpecies
	ld c, 0
	jr .handleLoop

.loop
	call BattleTower_IsCurSpeciesLegal
	jr c, .handleLoop
	inc c
.handleLoop
	ld a, [hli]
	cp $ff
	jr nz, .loop
	ld a, c
	ldh [hScriptVar], a
	ret

BattleTower_IsCurSpeciesLegal::
; returns carry if illegal
	push hl
	push bc
	ld hl, BattleTower_BannedMons
	call IsInSingularArray
	pop bc
	pop hl
	ret

BattleTower_BannedMons::
	db MEWTWO
	db MEW
	db FAMBACO
	db GROUDON
	db KYOGRE
	db RAYQUAZA
	db LUGIA
	db HO_OH
	db VARANEOUS
	db RAIWATO
	db EGG
	db LIBABEEL
	db PHANCERO
	db $ff

BattleTower_SetLevelGroup::
	ld a, [wMenuCursorY]
	ld c, 50
	call SimpleMultiply
	ld c, a
	call BattleTower_StackCallWRAMBankSwitch
	ld a, c
	ld [wBTChoiceOfLvlGroup], a
	ret

BattleTower_StackCallWRAMBankSwitch::
	ld a, BANK(wBattleTower)
	jp StackCallInWRAMBankA

BattleTower_InitChallenge::
	call BattleTower_StackCallWRAMBankSwitch
	ld hl, wBattleTower
	ld bc, wBattleTowerEnd - wBattleTower - 1
	xor a
	call ByteFill
	sbk BANK(sBTWinStreak)
	ld a, [sBTWinStreak]
	ld [hl], a
	scls
	call .SampleTeams
	ld hl, wBTOpponentIndices
	lb bc, (BattleTowerTrainerStructsEnd - BattleTowerTrainerStructs) / NAME_LENGTH, 7
	jr .init

.SampleTeams:
	ld hl, wBTMonsSelected
	lb bc, (BattleTowerMonStructsEnd - BattleTowerMonStructs) / BTMON_DATA_LENGTH, 21
.init
	push hl
	push bc
	ld b, 0
	ld a, $ff
	call ByteFill
	pop bc
	pop hl
	push hl

.loop
	call Random
	cp b
	jr nc, .loop
	ld d, a
	jr .handleLoop
.loop2
	cp d
	jr z, .loop
.handleLoop
	ld a, [hli]
	cp $ff
	jr nz, .loop2
.insert
	dec hl
	ld [hl], d
	inc hl
	dec c
	jr nz, .loop
	pop hl
	ret

BattleTower_LoadCurrentTeam::
	call BattleTower_LoadTeamIntoBank2
	ld hl, wOTPartyCount
	ld bc, wOTPartyDataEnd - wOTPartyCount
	xor a
	call ByteFill
	ld hl, wOTPartyCount
	ld a, 3
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec a
	ld [hl], a
	ld hl, wBTOTName
	ld de, wOTPlayerName
	ld bc, NAME_LENGTH - 1
	ln a, BANK(wOTPartyMonOT), BANK(wBTOTName)
	call DoubleFarCopyWRAM
	ld a, "@"
	ld [de], a

	ld b, 3
	ld hl, wOTPlayerName
	ld de, wOTPartyMonOT
.loop1
	push bc
	push hl
	ld bc, NAME_LENGTH
	rst CopyBytes
	pop hl
	pop bc
	dec b
	jr nz, .loop1
	ld hl, wBTOTTrainerClass
	ld a, BANK(wBTOTTrainerClass)
	call GetFarWRAMByte
	ld [wOtherTrainerClass], a
	xor a
	ld [wOtherTrainerID], a
	ld hl, wBTOTPkmn1
.loop2
	; Species Index
	ld [wCurPartyMon], a
	ld c, a
	ld b, 0
	push hl
	ld hl, wOTPartySpecies
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, BANK(wBTOTPkmn1)
	call GetFarWRAMByte
	ld [de], a

	; Struct part 1
	push hl
	ld hl, wOTPartyMon1
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	push de
	ld bc, MON_ID - MON_SPECIES
	ln a, BANK(wOTPartyMon1), BANK(wBTOTPkmn1)
	call DoubleFarCopyWRAM

	; Struct part 2
	ld a, MON_STAT_EXP - MON_ID
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	ld bc, MON_PP - MON_STAT_EXP
	ln a, BANK(wOTPartyMon1), BANK(wBTOTPkmn1)
	call DoubleFarCopyWRAM

	; Nickname
	push hl
	ld hl, wOTPartyMonNicknames
	ld a, [wCurPartyMon]
	call SkipNames
	ld d, h
	ld e, l
	pop hl
	ln a, BANK(wOTPartyMonNicknames), BANK(wBTOTPkmn1)
	call DoubleFarCopyWRAM

	; Level and Experience
	pop bc
	ld a, [bc]
	ld [wCurSpecies], a
	push hl
	call GetBaseData
	ld a, BANK(wBTChoiceOfLvlGroup)
	ld hl, wBTChoiceOfLvlGroup
	call GetFarWRAMByte
	ld hl, MON_LEVEL
	add hl, bc
	ld [hl], a
	ld d, a
	ld [wCurPartyLevel], a
	push bc
	callba CalcExpAtLevel
	pop bc
	ld hl, MON_EXP
	add hl, bc
	ldh a, [hProduct + 1]
	ld [hli], a
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a

	; PP
	ld hl, MON_PP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_MOVES
	add hl, bc
	predef FillPP

	; Stats
	ld hl, MON_MAXHP
	add hl, bc
	push hl
	ld d, h
	ld e, l
	dec hl
	dec hl
	push hl
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	ld b, 1
	predef CalcPkmnStats
	pop de
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	; Next
	pop hl
	ld a, [wCurPartyMon]
	inc a
	cp 3
	jp c, .loop2
	ld hl, wOTPartySpecies + 3
	ld [hl], $ff

	ld a, [wOtherTrainerClass]
	dec a
	ld e, a
	ld d, 0
	ld hl, .Sprites
	add hl, de
	ld a, [hl]
	ld [wMap1ObjectSprite], a
	ld [wUsedSprites + 2], a
	ldh [hUsedSpriteIndex], a
.reject_color
	call Random
	and $70
	cp (PAL_OW_SILVER - 1) << 4
	jr z, .reject_color
	jr c, .add_80
	add $10
.add_80
	or $80
	ld [wMap1ObjectColor], a
	ld a, [wUsedSprites + 3]
	ldh [hUsedSpriteTile], a
	jpba GetUsedSprite

.Sprites:
	db SPRITE_JOSIAH
	db SPRITE_WHITNEY
	db SPRITE_BUGSY
	db SPRITE_EDISON
	db SPRITE_CADENCE
	db SPRITE_AYAKA
	db SPRITE_ANDRE
	db SPRITE_BRUCE
	db SPRITE_SILVER
	db SPRITE_BLUE
	db SPRITE_SORA
	db SPRITE_MURA
	db SPRITE_DAICHI
	db SPRITE_YUKI
	db SPRITE_KOJI
	db SPRITE_LANCE
	db SPRITE_PALETTE_PATROLLER
	db SPRITE_SCIENTIST
	db SPRITE_YOUNGSTER
	db SPRITE_YOUNGSTER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_LASS
	db SPRITE_COOLTRAINER_M
	db SPRITE_COOLTRAINER_F
	db SPRITE_BUENA
	db SPRITE_SUPER_NERD
	db SPRITE_ROCKET
	db SPRITE_GENTLEMAN
	db SPRITE_BUENA
	db SPRITE_TEACHER
	db SPRITE_SABRINA
	db SPRITE_BUG_CATCHER
	db SPRITE_FISHER
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_SAILOR
	db SPRITE_SUPER_NERD
	db SPRITE_SILVER
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_M
	db SPRITE_BIKER
	db SPRITE_JOE
	db SPRITE_BURGLAR
	db SPRITE_FISHER
	db SPRITE_SUPER_NERD
	db SPRITE_BLACK_BELT
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_YOUNGSTER
	db SPRITE_SAGE
	db SPRITE_GRANNY
	db SPRITE_ROCKER
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKER
	db SPRITE_TWIN
	db SPRITE_POKEFAN_F
	db SPRITE_RED
	db SPRITE_BLUE
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_KARPMAN
	db SPRITE_SUPER_NERD
	db SPRITE_LILY
	db SPRITE_LOIS
	db SPRITE_SPARKY
	db SPRITE_CAL
	db SPRITE_ROCKET
	db SPRITE_COOLTRAINER_M
	db SPRITE_MOM
	db SPRITE_KIMONO_GIRL
	db SPRITE_BUGSY
	db SPRITE_WHITNEY
	db SPRITE_SABRINA
	db SPRITE_COOLTRAINER_F
	db SPRITE_COOLTRAINER_F
	db SPRITE_COOLTRAINER_M
	db SPRITE_RED
	db SPRITE_COOLTRAINER_F
	db SPRITE_CAL

BattleTower_LoadTeamIntoBank2::
	call BattleTower_StackCallWRAMBankSwitch
	ld a, [wBTCurStreak]
	ld c, a
	ld b, 0
	ld hl, wBTOpponentIndices
	add hl, bc

	ld a, [wBTWinStreak]
	cp 20
	jr z, .TycoonSilver
	cp 48
	jr z, .TycoonGold

	ld a, [hl]
	ld hl, BattleTowerTrainerStructs
	call SkipNames
	ld de, wBTOTName
	ld a, BANK(BattleTowerTrainerStructs)
	call FarCopyBytes
	ld a, [wBTCurStreak]
	ld c, a
	add a
	add c
	ld c, a
	ld b, 0
	ld hl, wBTMonsSelected
	add hl, bc
	ld b, 3
	ld de, wBTOTPkmn1
.loop
	ld a, [hli]
	push bc
	push hl
	ld hl, BattleTowerMonStructs
	ld bc, BTMonStructEnd - BTMonStructStart
	rst AddNTimes
	ld a, BANK(BattleTowerMonStructs)
	call FarCopyBytes
	pop hl
	pop bc
	dec b
	jr nz, .loop
	ret

.TycoonSilver
	ld hl, TycoonSilverTeam
	jr .copy

.TycoonGold
	ld hl, TycoonGoldTeam
.copy
	push hl
	call GetWeekday_SwitchWRAMBank
	ld c, 3
	call SimpleDivide
	pop hl
	push af
	ld bc, 3 * (BTMON_STRUCT_LENGTH + PKMN_NAME_LENGTH)
	rst AddNTimes
	ld de, wBTOTPkmn1
	ld a, BANK(TycoonErrorTeam)
	call FarCopyBytes
	ld bc, NAME_LENGTH
	ld hl, .TycoonName
	pop af
	rst AddNTimes
	ld de, wBTOTName
	rst CopyBytes
	ret

.TycoonName:
	db "Candela@@@", CANDELA
	db "Blanche@@@", BLANCHE
	db "Spark@@@@@", SPARK_T

BattleTower_ResetWinStreak::
	call BattleTower_StackCallWRAMBankSwitch
	sbk BANK(sBTWinStreak)
	xor a
	ld [sBTWinStreak], a
	jp CloseSRAM

BattleTower_RestoreWinStreak::
	call BattleTower_StackCallWRAMBankSwitch
	sbk BANK(sBTWinStreak)
	ld a, [wBTCurStreak]
	ld b, a
	ld a, [sBTWinStreak]
	sub b
	ld [sBTWinStreak], a
	jp CloseSRAM

BattleTower_SavePartyItems::
	ld hl, wPartyMon1Item
	ld de, wScriptBuffer
	ld bc, wPartyMon2Item-wPartyMon1Item
.loop
	ld a, [hl]
	ld [de], a
	inc de
	add hl, bc
	ld a, l
	cp LOW(wPartyMon4Item) ; is hl pointing to PartyMon4Item?
	jr nz, .loop
	ret

BattleTower_RestorePartyItems::
	ld hl, wPartyMon1Item
	ld de, wScriptBuffer
	ld bc, wPartyMon2Item-wPartyMon1Item
.loop
	ld a, [de]
	ld [hl], a
	inc de
	add hl, bc
	ld a, l
	cp LOW(wPartyMon4Item)
	jr nz, .loop
	ret

BattleTower_SaveChallengeData::
	call BattleTower_StackCallWRAMBankSwitch
	sbk BANK(sBattleTower)

	ld hl, wBattleTower
	ld de, sBattleTower
	ld bc, sBattleTowerEnd - sBattleTower
	rst CopyBytes
	jp CloseSRAM

BattleTower_LoadChallengeData::
	call BattleTower_StackCallWRAMBankSwitch
	sbk BANK(sBattleTower)

	ld hl, sBattleTower
	ld de, wBattleTower
	ld bc, sBattleTowerEnd - sBattleTower
	rst CopyBytes
	scls
	ld a, [wBTCurStreak]
	ldh [hScriptVar], a
	ret

StartBattleTowerBattle::
	ld hl, wOptions
	ld a, [hl]
	push af
	set BATTLE_SHIFT, [hl]

	ld hl, wInBattleTowerBattle
	ld a, [hl]
	push af
	set 0, [hl]

	xor a
	ld [wLinkMode], a

	predef StartBattle

	ld a, [wBattleResult]
	ldh [hScriptVar], a
	and $f
	call z, .IncrementWinStreak
	call BattleTower_ResetWinStreak
	pop af
	ld [wInBattleTowerBattle], a
	pop af
	ld [wOptions], a
	ret

.IncrementWinStreak:
	call BattleTower_StackCallWRAMBankSwitch
	ld hl, wBTCurStreak
	inc [hl]
	ld hl, wBTWinStreak
	ld a, [hl]
	inc a
	ret z
	ld [hl], a

	sbk BANK(sBTWinStreak)
	ld a, [hl]
	ld [sBTWinStreak], a
	jp CloseSRAM

BattleTower_CheckFought7Trainers::
	call BattleTower_CheckCurrentStreak
	ld c, 7
	call SimpleDivide
	ldh [hScriptVar], a
	ret

BattleTower_CheckCurrentStreak::
	ld hl, wBTCurStreak
	ld a, BANK(wBTCurStreak)
	call GetFarWRAMByte
	jr BattleTower_WriteScriptVarAndReturn

BattleTower_CheckDefeatedTycoon::
	ld hl, wBTWinStreak
	ld a, BANK(wBTWinStreak)
	call GetFarWRAMByte
	ld b, 1
	cp 21
	jr z, .gotWinStreak
	cp 49
	jr z, .gotWinStreak
	ld b, 0
.gotWinStreak
	ld a, b
BattleTower_WriteScriptVarAndReturn:
	ldh [hScriptVar], a
	ret

BattleTowerText::
; Print text c for trainer [wBTOTTrainerClass]
; 1: Intro text
; 2: Player lost
; 3: Player won
	call BattleTower_StackCallWRAMBankSwitch
	ld e, c ; save text type in e

	ld a, [wBTOTTrainerClass]
	cp CANDELA
	jr c, .normal
	cp SPARK_T + 1
	jr nc, .normal
	sub CANDELA
	dec e
	ld bc, 6
	ld hl, BTTycoonTextPointers
	rst AddNTimes
	ld d, 0
	add hl, de
	add hl, de
	jr .print

.normal
	dec a
	ld c, a
	ld b, CHECK_FLAG
	ld hl, BTTrainerClassGenders
	predef FlagAction
	ld a, c
	and a
	ld hl, BTFemaleTrainerTexts
	ld c, 15
	jr nz, .got_params
	ld hl, BTMaleTrainerTexts
	ld c, 25
.got_params
	dec e ; have we determined the text index already?
	jr nz, .restore ; if so, restore the index
	ld a, c
	call RandomRange
	ld [wBTTrainerTextIndex], a
	jr .gotTextIndex

.restore
	ld a, [wBTTrainerTextIndex]
.gotTextIndex
	ld c, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld b, d
	add hl, bc
	add hl, bc
.print
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bccoord 1, 14
	jp ProcessTextCommands_

BTTrainerClassGenders:
MACRO bitfield
x = 0
rept 8
x = x + (\1 << 8)
x = x >> 1
	shift
endr
	db x
ENDM

	bitfield MALE, FEMALE, MALE, MALE, FEMALE, FEMALE, MALE, MALE ; JOSIAH, BROOKLYN, RINJI, EDISON, AYAKA, CADENCE, ANDRE, BRUCE
	bitfield MALE, MALE, FEMALE, MALE, MALE, FEMALE, FEMALE, MALE ; RIVAL1, MURA, YUKI, KOJI, DAICHI, DELINQUENTF, SORA, CHAMPION
	bitfield MALE, MALE, MALE, MALE, MALE, FEMALE, FEMALE, MALE ; PATROLLER, SCIENTIST, YOUNGSTER, SCHOOLBOY, BIRD_KEEPER, LASS, CHEERLEADER, COOLTRAINERM
	bitfield FEMALE, FEMALE, MALE, MALE, MALE, FEMALE, FEMALE, FEMALE ; COOLTRAINERF, BEAUTY, POKEMANIAC, GRUNTF, GENTLEMAN, SKIER, TEACHER, SHERYL
	bitfield MALE, MALE, MALE, MALE, FEMALE, MALE, MALE, MALE ; BUG_CATCHER, FISHER, SWIMMERM, SWIMMERF, SAILOR, SUPER_NERD, RIVAL2, GUITARIST
	bitfield MALE, MALE, MALE, MALE, MALE, MALE, MALE, MALE ; HIKER, BIKER, JOE, BURGLAR, FIREBREATHER, JUGGLER, BLACKBELT_T, PSYCHIC_T
	bitfield FEMALE, MALE, MALE, FEMALE, MALE, MALE, MALE, FEMALE ; PICNICKER, CAMPER, SAGE, MEDIUM, BOARDER, POKEFANM, DELINQUENTM, TWINS
	bitfield FEMALE, MALE, MALE, MALE, MALE, MALE, MALE, FEMALE ; POKEFANF, RED, BLUE, OFFICER, MINER, KARPMAN, ARCADEPC_GROUP, LILY
	bitfield FEMALE, MALE, MALE, MALE, FEMALE, FEMALE, FEMALE, FEMALE ; LOIS, SPARKY, ERNEST, BUGSY, WHITNEY, SABRINA, CANDELA, BLANCHE
	bitfield MALE, MALE, FEMALE, MALE, MALE, MALE, MALE, MALE ; SPARK_T, BROWN, GUITARISTF, CAL

BTTycoonTextPointers:
	dw BattleTowerText_CandelaBefore
	dw BattleTowerText_CandelaLoss
	dw BattleTowerText_CandelaWin

	dw BattleTowerText_BlancheBefore
	dw BattleTowerText_BlancheLoss
	dw BattleTowerText_BlancheWin

	dw BattleTowerText_SparkBefore
	dw BattleTowerText_SparkLoss
	dw BattleTowerText_SparkWin

BTMaleTrainerTexts:
	dw .Greetings
	dw .PlayerLost
	dw .PlayerWon

.Greetings
	dw BattleTowerText_Greeting_M1
	dw BattleTowerText_Greeting_M2
	dw BattleTowerText_Greeting_M3
	dw BattleTowerText_Greeting_M4
	dw BattleTowerText_Greeting_M5
	dw BattleTowerText_Greeting_M6
	dw BattleTowerText_Greeting_M7
	dw BattleTowerText_Greeting_M8
	dw BattleTowerText_Greeting_M9
	dw BattleTowerText_Greeting_M10
	dw BattleTowerText_Greeting_M11
	dw BattleTowerText_Greeting_M12
	dw BattleTowerText_Greeting_M13
	dw BattleTowerText_Greeting_M14
	dw BattleTowerText_Greeting_M15
	dw BattleTowerText_Greeting_M16
	dw BattleTowerText_Greeting_M17
	dw BattleTowerText_Greeting_M18
	dw BattleTowerText_Greeting_M19
	dw BattleTowerText_Greeting_M20
	dw BattleTowerText_Greeting_M21
	dw BattleTowerText_Greeting_M22
	dw BattleTowerText_Greeting_M23
	dw BattleTowerText_Greeting_M24
	dw BattleTowerText_Greeting_M25

.PlayerLost
	dw BattleTowerText_PlayerLost_M1
	dw BattleTowerText_PlayerLost_M2
	dw BattleTowerText_PlayerLost_M3
	dw BattleTowerText_PlayerLost_M4
	dw BattleTowerText_PlayerLost_M5
	dw BattleTowerText_PlayerLost_M6
	dw BattleTowerText_PlayerLost_M7
	dw BattleTowerText_PlayerLost_M8
	dw BattleTowerText_PlayerLost_M9
	dw BattleTowerText_PlayerLost_M10
	dw BattleTowerText_PlayerLost_M11
	dw BattleTowerText_PlayerLost_M12
	dw BattleTowerText_PlayerLost_M13
	dw BattleTowerText_PlayerLost_M14
	dw BattleTowerText_PlayerLost_M15
	dw BattleTowerText_PlayerLost_M16
	dw BattleTowerText_PlayerLost_M17
	dw BattleTowerText_PlayerLost_M18
	dw BattleTowerText_PlayerLost_M19
	dw BattleTowerText_PlayerLost_M20
	dw BattleTowerText_PlayerLost_M21
	dw BattleTowerText_PlayerLost_M22
	dw BattleTowerText_PlayerLost_M23
	dw BattleTowerText_PlayerLost_M24
	dw BattleTowerText_PlayerLost_M25

.PlayerWon
	dw BattleTowerText_PlayerWon_M1
	dw BattleTowerText_PlayerWon_M2
	dw BattleTowerText_PlayerWon_M3
	dw BattleTowerText_PlayerWon_M4
	dw BattleTowerText_PlayerWon_M5
	dw BattleTowerText_PlayerWon_M6
	dw BattleTowerText_PlayerWon_M7
	dw BattleTowerText_PlayerWon_M8
	dw BattleTowerText_PlayerWon_M9
	dw BattleTowerText_PlayerWon_M10
	dw BattleTowerText_PlayerWon_M11
	dw BattleTowerText_PlayerWon_M12
	dw BattleTowerText_PlayerWon_M13
	dw BattleTowerText_PlayerWon_M14
	dw BattleTowerText_PlayerWon_M15
	dw BattleTowerText_PlayerWon_M16
	dw BattleTowerText_PlayerWon_M17
	dw BattleTowerText_PlayerWon_M18
	dw BattleTowerText_PlayerWon_M19
	dw BattleTowerText_PlayerWon_M20
	dw BattleTowerText_PlayerWon_M21
	dw BattleTowerText_PlayerWon_M22
	dw BattleTowerText_PlayerWon_M23
	dw BattleTowerText_PlayerWon_M24
	dw BattleTowerText_PlayerWon_M25

BTFemaleTrainerTexts:
	dw .Greetings
	dw .PlayerLost
	dw .PlayerWon

.Greetings
	dw BattleTowerText_Greeting_F1
	dw BattleTowerText_Greeting_F2
	dw BattleTowerText_Greeting_F3
	dw BattleTowerText_Greeting_F4
	dw BattleTowerText_Greeting_F5
	dw BattleTowerText_Greeting_F6
	dw BattleTowerText_Greeting_F7
	dw BattleTowerText_Greeting_F8
	dw BattleTowerText_Greeting_F9
	dw BattleTowerText_Greeting_F10
	dw BattleTowerText_Greeting_F11
	dw BattleTowerText_Greeting_F12
	dw BattleTowerText_Greeting_F13
	dw BattleTowerText_Greeting_F14
	dw BattleTowerText_Greeting_F15

.PlayerLost
	dw BattleTowerText_PlayerLost_F1
	dw BattleTowerText_PlayerLost_F2
	dw BattleTowerText_PlayerLost_F3
	dw BattleTowerText_PlayerLost_F4
	dw BattleTowerText_PlayerLost_F5
	dw BattleTowerText_PlayerLost_F6
	dw BattleTowerText_PlayerLost_F7
	dw BattleTowerText_PlayerLost_F8
	dw BattleTowerText_PlayerLost_F9
	dw BattleTowerText_PlayerLost_F10
	dw BattleTowerText_PlayerLost_F11
	dw BattleTowerText_PlayerLost_F12
	dw BattleTowerText_PlayerLost_F13
	dw BattleTowerText_PlayerLost_F14
	dw BattleTowerText_PlayerLost_F15

.PlayerWon
	dw BattleTowerText_PlayerWon_F1
	dw BattleTowerText_PlayerWon_F2
	dw BattleTowerText_PlayerWon_F3
	dw BattleTowerText_PlayerWon_F4
	dw BattleTowerText_PlayerWon_F5
	dw BattleTowerText_PlayerWon_F6
	dw BattleTowerText_PlayerWon_F7
	dw BattleTowerText_PlayerWon_F8
	dw BattleTowerText_PlayerWon_F9
	dw BattleTowerText_PlayerWon_F10
	dw BattleTowerText_PlayerWon_F11
	dw BattleTowerText_PlayerWon_F12
	dw BattleTowerText_PlayerWon_F13
	dw BattleTowerText_PlayerWon_F14
	dw BattleTowerText_PlayerWon_F15

PUSHS
SECTION "Debug Battle Tower", ROMX
BattleTower_DebugTeam::
	ldh a, [rSVBK]
	push af
	wbk BANK(wBTChoiceOfLvlGroup)
	ld a, 50
	ld [wBTChoiceOfLvlGroup], a
	pop af
	ldh [rSVBK], a
	; back up the party
	sbk BANK(sBattleTowerPartyBackup)
	ld hl, wPartyCount
	ld de, sBattleTowerPartyBackup
	ld bc, wPartyMonNicknamesEnd - wPartyCount
	rst CopyBytes
	scls

	; reset the party
	ld de, wPartyCount
	ld hl, DebugBTPartyData
	ld bc, 5
	rst CopyBytes ; exits with hl and de pointing to the end of the copies
	ld de, wPartyMon1
	ld bc, wPartyMon1End - wPartyMon1
	call .three_copies
	ld de, wPartyMonOT
	ld bc, NAME_LENGTH
	push bc
	call .three_copies
	ld de, wPartyMonNicknames
	pop bc
	call .three_copies

	ld bc, wPartyMon1
	callba Level50Cap
	ld bc, wPartyMon2
	callba Level50Cap
	ld bc, wPartyMon3
	jpba Level50Cap

.three_copies
	; makes three copies of hl at de, size bc
	; output: hl += bc, de += 3 * bc, bc clobbered
	rept 2
		push hl
		push bc
		rst CopyBytes
		pop bc
		pop hl
	endr
	rst CopyBytes
	ret

DebugBTPartyData:
	; header (party count, etc.)
	db 3
	db LUCARIO, LUCARIO, LUCARIO
	db $ff

	; mon data
	db LUCARIO
	db BLACKBELT
	db EARTHQUAKE, AURA_SPHERE, DRAIN_PUNCH, SWORDS_DANCE
	dw 09057
	dt 117360
	dw $FFFF ; hp
	dw $FFFF ; atk
	dw $FFFF ; def
	dw $FFFF ; spd
	dw $FFFF ; spc
	dw $FFFF ; dvs
	db $c0 | 16, $c0 | 32, $c0 | 16, $c0 | 32
	db 255
	db $00
	db 63, 00
	db 100
	db 0, 0
	bigdw 343
	bigdw 343
	bigdw 318
	bigdw 238
	bigdw 278
	bigdw 328
	bigdw 238

	; OT name
	db "DEBUG@@@@@@"

	; Nickname
	db "TEST MON@@@"
POPS
