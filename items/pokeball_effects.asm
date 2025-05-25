ItemBall:
	ld a, [wBattleMode]
	dec a
	jp nz, UseBallInTrainerBattle

	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nz, .room_in_party

	sbk BANK(sBoxCount)
	ld a, [sBoxCount]
	cp MONS_PER_BOX
	scls
	jp z, Ball_BoxIsFullMessage

.room_in_party
	xor a
	ld [wWildMon], a
	ld a, [wCurItem]
	call ReturnToBattle_UseBall

	ld hl, wOptions
	res NO_TEXT_SCROLL, [hl]
	ld hl, Text_UsedItem
	call PrintText

	ld a, [wCurItem]
	cp MASTER_BALL
	jr z, .catch_without_fail
	call CalculateModifiedCatchRate
	ld hl, hProduct
	ld a, [hli]
	ld b, a
	ld a, [hli]
	or [hl]
	or b
	jr z, .notCaught
.catch_without_fail
	ld a, [wEnemyMonSpecies]
	ld [wWildMon], a
.notCaught
	ldh a, [hProduct + 3]
	and a
	jr nz, .notZero
	inc a
.notZero
	ld [wCatchMon_CatchRate], a
	call IsCriticalCapture
	ld [wCatchMon_Critical], a
	ld c, 20
	call DelayFrames

	ld a, [wCurItem]
	ld [wBattleAnimParam], a

	ld de, ANIM_THROW_POKE_BALL
	ld a, e
	ld [wFXAnimIDLo], a
	ld a, d
	ld [wFXAnimIDHi], a
	xor a
	ldh [hBattleTurn], a
	ld [wCatchMon_NumShakes], a
	ld [wNumHits], a
	predef PlayBattleAnim

	ld a, [wWildMon]
	and a
	jr nz, .caught
	ld a, [wCatchMon_NumShakes]
	dec a
	ld [wLastBallShakes], a
	ld hl, .no_shakes_text
	jp z, .printBrokeFreeText
	dec a
	ld hl, .one_shake_text
	jp z, .printBrokeFreeText
	dec a
	ld hl, .two_shakes_text
	jp z, .printBrokeFreeText
	dec a
	ld hl, .three_shakes_text
	jp z, .printBrokeFreeText
.caught
	ld hl, wEnemyMonStatus
	ld a, [hli]
	push af ; save status
	inc hl
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc ; save hp
	ld a, [wEnemyMonItem]
	push af ; save item
	ld hl, wEnemySubStatus5
	ld a, [hl] ; save status
	push af
	bit SUBSTATUS_TRANSFORMED, a
	set SUBSTATUS_TRANSFORMED, [hl]
	jr nz, .load_data

	ld hl, wEnemyBackupDVs
	ld a, [wEnemyMonDVs]
	ld [hli], a
	ld a, [wEnemyMonDVs + 1]
	ld [hl], a

.load_data
	ld a, [wTempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wEnemyMonLevel]
	ld [wCurPartyLevel], a
	callba LoadEnemyMon

	pop af
	ld [wEnemySubStatus5], a

	pop af
	ld [wEnemyMonItem], a
	pop bc
	ld hl, wEnemyMonHP + 1 ; restore saved HP
	ld a, c
	ld [hld], a
	ld a, b
	ld [hld], a
	dec hl ; hl = enemy status
	pop af
	ld [hl], a

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .Transformed
	ld hl, wWildMonMoves
	ld de, wEnemyMonMoves
	ld bc, NUM_MOVES
	push bc
	rst CopyBytes

	ld hl, wWildMonPP
	ld de, wEnemyMonPP
	pop bc
	rst CopyBytes
.Transformed

	ld a, [wBattleType]

	ld hl, .caught_text
	call PrintText
	ld c, 1
	call FadeOBJToWhite
	call ClearSprites

	callba CatchPokemon_GiveExperience

	ld a, [wEnemyMonLevel]
	ld [wCurPartyLevel], a
	ld a, [wEnemyMonSpecies]
	ld [wWildMon], a
	ld [wCurPartySpecies], a
	ld [wd265], a

	dec a
	call CheckCaughtMon
	push af
	ld a, [wd265]
	dec a
	call SetSeenAndCaughtMon
	pop af
	jr nz, .skip_pokedex

	CheckEngine ENGINE_POKEDEX
	jr z, .skip_pokedex

	ld hl, .added_to_pokedex_text
	call PrintText

	call ClearSprites

	ld a, [wEnemyMonSpecies]
	ld [wd265], a
	predef NewPokedexEntry

.skip_pokedex
	ld a, [wBattleType]
	cp BATTLETYPE_CELEBI
	jr nz, .not_celebi
	ld hl, wBattleResult
	set 6, [hl]
.not_celebi
	ld a, [wRespawnableEventMonBaseIndex]
	and a
	jr z, .notRespawnableEventMon
	ld b, SET_FLAG
	ld c, a
	call DoRespawnableEventMonFlagAction
	xor a
	ld [wRespawnableEventMonBaseIndex], a
.notRespawnableEventMon

	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jp z, .SendToPC

	xor a ; PARTYMON
	ld [wMonType], a
	call ClearSprites

	predef TryAddMonToParty

	callba SetCaughtData

	ld a, [wCurItem]
	cp SHINY_BALL
	jr z, .shiny_ball_partymon
	cp FRIEND_BALL
	jr nz, .SkipPartyMonFriendBall

	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Happiness
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes

	ld a, FRIEND_BALL_HAPPINESS
	ld [hl], a
	jr .SkipPartyMonFriendBall

.shiny_ball_partymon
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld b, h
	ld c, l

	ld hl, MON_DVS
	add hl, bc
	call .apply_shiny_ball_DVs
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_STAT_EXP - 1
	add hl, bc

	; Needs to be preserved since we're in a battle
	ld a, [wCurPartyMon]
	push af
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	callba UpdatePkmnStats
	pop af
	ld [wCurPartyMon], a

	ld a, $aa ;So it appears shiny in nickname menu
	ld hl, wTempMon + MON_DVS
	ld [hli], a
	ld [hl], a

.SkipPartyMonFriendBall
	ld hl, .ask_nickname_text
	call PrintText

	ld a, [wCurPartySpecies]
	ld [wd265], a
	call GetPokemonName

	call YesNoBox
	jp c, .return_from_capture

	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	rst AddNTimes

	ld d, h
	ld e, l
	push de
	xor a ; PARTYMON
	ld [wMonType], a
	ld b, a
	callba NamingScreen

	ld c, 1
	call FadeToLightestColor

	call LoadStandardFont

	pop hl
	ld de, wStringBuffer1
	call InitName

	jp .return_from_capture

.SendToPC
	call ClearSprites
	callba SentPkmnIntoBox
	callba SetBoxMonCaughtData
	sbk BANK(sBoxCount)
	ld a, [sBoxCount]
	cp MONS_PER_BOX
	jr nz, .BoxNotFullYet
	ld hl, wBattleResult
	set 7, [hl]
.BoxNotFullYet
	ld a, [wCurItem]
	cp SHINY_BALL
	jr z, .shiny_ball_boxmon
	cp FRIEND_BALL
	jr nz, .SkipBoxMonFriendBall

	ld a, FRIEND_BALL_HAPPINESS
	ld [sBoxMon1Happiness], a
	jr .SkipBoxMonFriendBall

.shiny_ball_boxmon
	ld hl, sBoxMon1DVs
	call .apply_shiny_ball_DVs
.SkipBoxMonFriendBall
	scls

	ld hl, .ask_nickname_text
	call PrintText

	ld a, [wCurPartySpecies]
	ld [wd265], a
	call GetPokemonName

	call YesNoBox
	jr c, .SkipBoxMonNickname

	xor a
	ld b, a
	ld [wCurPartyMon], a
	ld a, BOXMON
	ld [wMonType], a
	ld de, wMonOrItemNameBuffer
	callba NamingScreen

	sbk BANK(sBoxMonNicknames)
	ld hl, wMonOrItemNameBuffer
	ld de, sBoxMonNicknames
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld hl, sBoxMonNicknames
	ld de, wStringBuffer1
	call InitName
	scls

.SkipBoxMonNickname
	sbk BANK(sBoxMonNicknames)
	ld hl, sBoxMonNicknames
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	scls

	callba CopyCurBoxName
	ld hl, .sent_to_PC_text
	call PrintText

	ld c, 1
	call FadeToLightestColor
	call LoadStandardFont
	jr .return_from_capture

.apply_shiny_ball_DVs
	push bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push hl
	push bc
	ld hl, sp + 0
	ld b, 2
	call CountSetBits
	pop hl
	pop hl
	ld [hl], $aa
	dec hl
	ld c, a
	ld a, [hl]
	and $c0
	ld b, a
	or $2a
	ld [hl], a
	ld a, b
	sub $40
	add a, a
	sbc a
	add a, c
	pop bc
	rra
	ret nc
	set 4, [hl]
	ret

.printBrokeFreeText
	push hl
	ld b, SCGB_BATTLE_COLORS
	predef GetSGBLayout
	call SetPalettes
	ld a, [wEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wEnemyMonStatus]
	and (1 << FRZ) | SLP
	jr nz, .skip_cry
	call CheckBattleScene
	jr c, .cry_no_anim
	hlcoord 12, 0
	lb de, 0, ANIM_MON_SLOW
	predef AnimateFrontpic
	jr .skip_cry

.cry_no_anim
	ld a, $f
	ld [wCryTracks], a
	ld a, [wEnemyMonSpecies]
	call PlayStereoCry

.skip_cry
	pop hl
	call PrintText
	call ClearSprites

.return_from_capture
	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	ret z

	ld a, [wWildMon]
	and a
	jr z, .toss

	call ClearBGPalettes
	call ClearTileMap

.toss
	ld hl, wNumItems
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	jp TossItem

.no_shakes_text
	ctxt "Oh no! The #mon"
	line "broke free!"
	prompt

.one_shake_text
	ctxt "Aww! It appeared"
	line "to be caught!"
	prompt

.two_shakes_text
	ctxt "Aargh!"
	line "Almost had it!"
	prompt

.three_shakes_text
	ctxt "Shoot! It was so"
	line "close too!"
	prompt

.caught_text
	ctxt "Gotcha! <EMON>"
	line "was caught!@"
	start_asm
	push bc
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, SFX_CAUGHT_MON
	call PlayWaitSFX
	ld de, MUSIC_CAPTURE
	call PlayMusic
	pop bc
	ld hl, .prompt
	ret

.sent_to_PC_text
	ctxt "<MINB> was"
	line "sent to <STRBF1>"
	cont "in Bill's PC!@"
	start_asm
	sbk BANK(sBoxCount)
	ld a, [sBoxCount]
	cp MONS_PER_BOX
	scls
	ld hl, .prompt
	ret nz
	ld hl, .filled_box_text
	ret

.filled_box_text
	ctxt ""
	para "You've completely"
	line "filled <STRBF1>!@"
.prompt
	prompt

.added_to_pokedex_text
	ctxt "<EMON>'s data"
	line "was newly added to"
	cont "the #dex.@"
	start_asm
	ld de, SFX_SLOT_MACHINE_START
	jp Text_PlaySFXAndPrompt

.ask_nickname_text
	ctxt "Give a nickname to"
	line "<STRBF1>?"
	done

CalculateModifiedCatchRate:
; use gen 4's catch rate formula which is less buggy
; (((3M - 2H) * C * B) / 3M) * S
; M = max HP
; H = cur HP
; C = catch rate
; B = ball bonus
; S = status

	ld a, [wEnemyMonCatchRate]
	ldh [hMultiplier], a

; first, calculate 3M - 2H
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
; bc = curHP
; de = maxHP
	sla c
	rl b
; bc = curHP * 2
	ld h, d
	ld l, e
	add hl, de
	add hl, de
	ld d, h
	ld e, l
; de = maxHP * 3

	ld hl, hMultiplicand + 2
	ld a, e
	sub c
	ld [hld], a
	ld a, d
	sbc b
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], a
	predef Multiply

	push de
	ld a, [wCurItem]
	ld c, a
	ld hl, BallMultiplierFunctionTable
	ld e, 3
	call IsInArray
	call c, CallLocalPointer_AfterIsInArray
	pop de
	ld a, e
	ldh [hDivisor + 1], a
	ld a, d
	ldh [hDivisor], a
	predef DivideLong

; Use Gen 4 status bonus
	ld a, [wEnemyMonStatus]
	and (1 << FRZ) | SLP
	call nz, SleepFreezeStatusMultiplier
	ld a, [wEnemyMonStatus]
	and (1 << PSN) | (1 << BRN) | (1 << PAR)
	call nz, PoisonBurnParalyzeStatusMultiplier

	; during the park minigame, catch rate is increased
	CheckEngine ENGINE_PARK_MINIGAME
	ret z
GreatBallMultiplier:
PoisonBurnParalyzeStatusMultiplier:
ParkMinigameMultiplier:
; multiply catch rate by 1.5
	ld hl, hProduct
	ld a, [hli]
	srl a
	ld b, a
	ld a, [hli]
	rra
	ld c, a
	ld a, [hli]
	rra
	ld d, a
	ld a, [hl]
	ld e, a
	rra
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hld], a
	ld a, [hl]
	adc c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	ret

BallMultiplierFunctionTable:
; table of routines that increase or decrease the catch rate based on
; which ball is used in a certain situation.
	dbw ULTRA_BALL,    UltraBallMultiplier
	dbw GREAT_BALL,    GreatBallMultiplier
	dbw DIVE_BALL,     DiveBallMultiplier
	dbw FAST_BALL,     FastBallMultiplier
	dbw QUICK_BALL,    QuickBallMultiplier
	dbw DUSK_BALL,     DuskBallMultiplier
	dbw REPEAT_BALL,   RepeatBallMultiplier
	dbw TIMER_BALL,    TimerBallMultiplier
	dbw EAGULOU_BALL,  GreatBallMultiplier
	dbw SHINY_BALL,    UltraBallMultiplier
	db $ff

RepeatBallMultiplier:
	ld a, [wEnemyMonSpecies]
	dec a
	call CheckCaughtMon
	ret z
	ld a, 6
	jr MultiplyCatchRate

DuskBallMultiplier:
	ld a, [wPermission]
	cp CAVE
	jr z, .multiply
	cp DUNGEON
	jr z, .multiply
	ld a, [wTimeOfDay]
	cp NITE
	ret c ; night or darkness
.multiply
	ld a, 7
	call MultiplyCatchRate
	ld a, 2
DivideCatchRate:
	ldh [hDivisor], a
	ld b, 4
	predef_jump Divide

TimerBallMultiplier:
	ld a, [wBattleTurns]
	cp 21
	jr nc, QuadrupleCatchRate
	add 7
	call MultiplyCatchRate
	ld a, 7
	jr DivideCatchRate

FastBallMultiplier:
	ld a, [wEnemyMonBaseStats + 3]
	cp 100
	ret c

QuadrupleCatchRate:
	ld a, 4
	jr MultiplyCatchRate

QuickBallMultiplier:
	ld a, [wBattleTurns]
	and a
	ret nz
	ld a, 5
	jr MultiplyCatchRate

SleepFreezeStatusMultiplier:
UltraBallMultiplier:
DoubleCatchRate:
; multiply catch rate by 2
	ld a, 2
MultiplyCatchRate:
	ldh [hMultiplier], a
	predef_jump Multiply

DiveBallMultiplier:
; multiply catch rate by 3 if this is a fishing rod battle
	ld a, [wBattleType]
	cp BATTLETYPE_FISH
	jr z, .tripleCatchRate
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .tripleCatchRate
	cp PLAYER_SURF_PIKA
	ret nz
.tripleCatchRate
	ld a, 3
	jr MultiplyCatchRate

IsCriticalCapture:
; Critical capture is based on how many Pokemon you've caught.
; This formula is adapted to the smaller Pokedex in Gen 2.
	ld hl, wPokedexCaught
	ld b, wEndPokedexCaught - wPokedexCaught
	call CountSetBits ; returns to a, c, and wd265
	cp $ff
	jr z, .max
	ld b, 0
	ld hl, .CriticalCatchMultipliers
.loop
	cp [hl]
	jr c, .okay
	inc hl
	inc b
	jr .loop

.max
	ld a, 5
	jr .multiply

.okay
	ld a, b
	and a
	ret z
.multiply
	ldh [hMultiplier], a
	predef Multiply
	ld a, 12
	ldh [hDivisor], a
	ld b, 4
	predef Divide
	ld hl, hQuotient
	ld a, [hli]
	or [hl]
	ld a, 1
	ret nz
	ldh a, [hQuotient + 2]
	and a
	ret z
	ld c, a
	callba BallRandomBasedOnBall
	cp c
	ld a, 1
	ret c
	xor a
	ret

.CriticalCatchMultipliers
	; 0.0, 0.5, 1.0, 1.5, 2.0, 2.5
	db 31, 101, 151, 201, 231, 255

ReturnToBattle_UseBall:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	callba GetMonBackpic
	callba GetMonFrontpic
	callba LoadBattleFontsHPBar
	ld b, SCGB_RAM
	predef GetSGBLayout
	call CloseWindow
	call LoadStandardMenuHeader
	call ApplyTilemapInVBlank
	jp SetPalettes

UseBallInTrainerBattle:
	call ReturnToBattle_UseBall
	ld de, ANIM_THROW_POKE_BALL
	ld a, e
	ld [wFXAnimIDLo], a
	ld a, d
	ld [wFXAnimIDHi], a
	xor a
	ld [wBattleAnimParam], a
	ldh [hBattleTurn], a
	ld [wNumHits], a
	ld [wCatchMon_Critical], a
	predef PlayBattleAnim
	ld hl, .text
	jp PrintText

.text
	ctxt "The trainer"
	line "blocked the Ball!"

	para "Don't be a thief!"
	prompt
