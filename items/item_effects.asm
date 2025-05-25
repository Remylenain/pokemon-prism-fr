_DoItemEffect::
	ld a, [wCurItem]
	ld [wd265], a
	call GetItemName
	call CopyName1
	ld a, 1
	ld [wItemEffectSucceeded], a
	ld a, [wCurItem]
	dec a
	jumptable
ItemEffects:
	dw ItemBall
	dw ItemBall
	dw ItemDoesNothing
	dw ItemBall
	dw ItemBall
	dw ItemDoesNothing
	dw Bicycle
	dw EvolutionItem ;8
	dw StatusCureItem
	dw StatusCureItem
	dw StatusCureItem
	dw StatusCureItem
	dw StatusCureItem
	dw FullRestore
	dw RecoverHPItem
	dw RecoverHPItem ;10
	dw RecoverHPItem
	dw RecoverHPItem
	dw EscapeRope
	dw Repel
	dw ElixirItem
	dw EvolutionItem
	dw EvolutionItem
	dw EvolutionItem ;18
	dw ItemDoesNothing
	dw VitaminItem
	dw VitaminItem
	dw VitaminItem
	dw VitaminItem
	dw ItemDoesNothing
	dw VitaminItem
	dw RareCandy ;20
	dw XBoostItem
	dw EvolutionItem
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw PokeDoll
	dw StatusCureItem
	dw ReviveItem
	dw ReviveItem ;28
	dw GuardSpec
	dw SuperRepel
	dw MaxRepel
	dw DireHit
	dw ItemDoesNothing
	dw RecoverHPItem
	dw RecoverHPItem
	dw RecoverHPItem ;30
	dw XBoostItem
	dw EvolutionItem
	dw XBoostItem
	dw XBoostItem
	dw XBoostItem
	dw CoinCase
	dw ItemfinderItem
	dw ItemDoesNothing ;38
	dw ItemDoesNothing
	dw OldRod
	dw GoodRod
	dw ItemDoesNothing
	dw SuperRod
	dw PPUP
	dw RecoverPPItem
	dw RecoverPPItem ;40
	dw ElixirItem
	dw ItemDoesNothing
	dw ItemDoesNothing ;Rijon Pass
	dw ItemDoesNothing ;Ferry Ticket
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw RecoverHPItem ;48
	dw ItemDoesNothing
	dw StatusCureItem
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw StatusCureItem
	dw StatusCureItem
	dw StatusCureItem ;50
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw BitterBerry
	dw StatusCureItem
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;58
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;60
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;68
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw StatusCureItem
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;70
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;78
	dw HerbelMedicine_HealHP
	dw HerbelMedicine_HealHP
	dw HealPowder
	dw RevivalHerb
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;80
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;88
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw RecoverHPItem
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;90
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemBall
	dw ItemDoesNothing
	dw RecoverPPItem
	dw ItemDoesNothing
	dw ItemDoesNothing ;98
	dw BlueFluteEffect
	dw XBoostItem
	dw ItemDoesNothing
	dw SacredAsh
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw OreCaseItem
	dw ItemBall ;a0
	dw ItemBall
	dw SmelterItem
	dw ItemDoesNothing
	dw ItemBall
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw HyperShareItem ;a8
	dw EvolutionItem
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw RecoverHPItem
	dw RecoverHPItem
	dw EvolutionItem
	dw ItemDoesNothing ;b0
	dw ItemBall
	dw IronPickaxeItem
	dw EvolutionItem
	dw ItemDoesNothing
	dw RedFluteEffect
	dw YellowFluteEffect
	dw BlackFluteEffect
	dw WhiteFluteEffect ;b8
	dw GreenFluteEffect
	dw OrangeFluteEffect
	dw SootSackEffect
	dw PurpleFluteEffect
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;c0
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;c8
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;d0
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw EvolutionItem
	dw ItemDoesNothing
	dw EvolutionItem ;d8
	dw ItemBall
	dw ItemDoesNothing
	dw RecoverHPItem
	dw ItemDoesNothing
	dw RecoverHPItem
	dw FossilCaseEffect
	dw ItemDoesNothing
	dw ItemDoesNothing ;e0
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing ;e8
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw OrphanCardEffect
	dw ItemDoesNothing
	dw ItemDoesNothing ;f0
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemDoesNothing
	dw ItemBall
	dw ItemBall
	dw ItemBall ;f8
	dw ItemBall
	dw ItemDoesNothing
	dw TimeMachineItem
	dw TokenTrackerItem
	dw ItemDoesNothing
	dw ItemDoesNothing

Bicycle:
	jpba BikeFunction

EvolutionItem:
	ld b, PARTYMENUACTION_EVO_STONE
	call UseItem_InitMonSelection
	callba PartyMenuSelect
	jr c, .decidedNotToUse
	ld a, MON_ITEM
	call GetPartyParamLocation

	ld a, 1
	ld [wForceEvolution], a
	callba EvolvePokemon

	ld a, [wMonTriedToEvolve]
	and a
	jp nz, UseDisposableItem
.noEffect
	call WontHaveAnyEffectMessage
.decidedNotToUse
	xor a
	ld [wItemEffectSucceeded], a
	ret

VitaminItem:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

_VitaminItem:
	call RareCandy_StatBooster_GetParameters

	call GetStatExpRelativePointer

	ld a, MON_STAT_EXP
	call GetPartyParamLocation

	add hl, bc
	ld a, [hl]
	cp 100
	jr nc, VitaminNoEffectMessage

	add 10
	ld [hl], a
	callba UpdatePkmnStats

	call GetStatExpRelativePointer

	ld hl, StatStrings
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wStringBuffer2
	ld bc, ITEM_NAME_LENGTH
	rst CopyBytes

	call Play_SFX_FULL_HEAL

	ld hl, Text_StatRose
	call PrintText

	ld c, HAPPINESS_USEDITEM
	callba ChangeHappiness

	jp UseDisposableItem

VitaminNoEffectMessage:
	ld hl, Text_WontHaveAnyEffect
	jp PrintText

Text_StatRose:
	; 's @  rose.
	text_jump FarText_MonStatRose

StatStrings:
	dw .health
	dw .attack
	dw .defense
	dw .speed
	dw .special

.health  db "Health@"
.attack  db "Attack@"
.defense db "Defense@"
.speed   db "Speed@"
.special db "Special@"

GetStatExpRelativePointer:
	ld a, [wCurItem]
	ld hl, VitaminStatExpOffsets
	ld e, 2
	call IsInArray
	inc hl
	ld c, [hl]
	ld b, 0
	ret

VitaminStatExpOffsets:
	db HP_UP,   MON_HP_EXP  - MON_STAT_EXP
	db PROTEIN, MON_ATK_EXP - MON_STAT_EXP
	db IRON,    MON_DEF_EXP - MON_STAT_EXP
	db CARBOS,  MON_SPD_EXP - MON_STAT_EXP
	db CALCIUM, MON_SPC_EXP - MON_STAT_EXP
	db $ff

RareCandy:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

_RareCandy:
	call RareCandy_StatBooster_GetParameters

	ld a, MON_LEVEL
	call GetPartyParamLocation

	ld a, [hl]
	cp MAX_LEVEL
	jp nc, VitaminNoEffectMessage

	inc a
	ld [hl], a
	ld [wCurPartyLevel], a
	push de
	ld d, a
	callba CalcExpAtLevel

	pop de
	ld a, MON_EXP
	call GetPartyParamLocation

	ldh a, [hMultiplicand]
	ld [hli], a
	ldh a, [hMultiplicand + 1]
	ld [hli], a
	ldh a, [hMultiplicand + 2]
	ld [hl], a

	callba UpdatePkmnStats_AllowReviving
	callba LevelUpHappinessMod

	ld a, PARTYMENUTEXT_LEVEL_UP
	call ItemActionText

	xor a ; PARTYMON
	ld [wMonType], a
	predef CopyPkmnToTempMon

	hlcoord 9, 0
	lb bc, 10, 9
	call TextBox

	hlcoord 11, 1
	ld bc, 4
	predef PrintTempMonStats

	call WaitPressAorB_BlinkCursor

	xor a ; PARTYMON
	ld [wMonType], a
	ld a, [wCurPartySpecies]
	ld [wd265], a
	predef LearnLevelMoves

	xor a
	ld [wForceEvolution], a
	callba EvolvePokemon

	jp UseDisposableItem

RareCandy_StatBooster_GetParameters:
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	ld [wd265], a
	ld a, MON_LEVEL
	call GetPartyParam
	ld [wCurPartyLevel], a
	call GetBaseData
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	jp GetNick

HealPowder:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

.function
	call UseStatusHealer
	and a
	jp nz, WontHaveAnyEffectMessage
	ld c, HAPPINESS_BITTERPOWDER

; fallthrough
ChangeHappinessAndPrintLooksBitterMessage:
	callba ChangeHappiness
	jp LooksBitterMessage

StatusCureItem:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon

.function
	call UseStatusHealer
	and a
	ret z
	jp WontHaveAnyEffectMessage

UseStatusHealer:
	call IsMonFainted
	ld a, 1
	ret z
	call GetItemHealingAction
	ld a, MON_STATUS
	call GetPartyParamLocation
	ld a, [hl]
	and c
	jr nz, .good
	call IsItemUsedOnConfusedMon
	ld a, 1
	ret nc
	ld b, PARTYMENUTEXT_HEAL_CONFUSION
.good
	xor a
	ld [hli], a
	ld [hl], a
	ld a, b
	ld [wPartyMenuActionText], a
	call HealStatus
	call Play_SFX_FULL_HEAL
	call ItemActionTextWaitButton
	call UseDisposableItem
	xor a
	ret

IsItemUsedOnConfusedMon:
	call IsItemUsedOnBattleMon
	jr nc, .nope
	ld a, [wPlayerSubStatus3]
	bit SUBSTATUS_CONFUSED, a
	jr z, .nope
	ld a, c
	cp $ff
	ccf
	ret

.nope
	and a
	ret

BattlemonRestoreHealth:
	call IsItemUsedOnBattleMon
	ret nc
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld [wBattleMonHP], a
	ld a, [hld]
	ld [wBattleMonHP + 1], a
	ret

HealStatus:
	call IsItemUsedOnBattleMon
	ret nc
	xor a
	ld [wBattleMonStatus], a
	ld hl, wBattleMonSemistatus
	res SEMISTATUS_TOXIC, [hl]
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	call GetItemHealingAction
	ld a, c
	inc a
	jr nz, .not_full_heal
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_CONFUSED, [hl]
.not_full_heal
	push bc
	callba CalcPlayerStats
	pop bc
	ret

GetItemHealingAction:
	push hl
	ld a, [wCurItem]
	ld hl, .healingactions
	ld bc, 3
.next
	cp [hl]
	jr z, .found_it
	add hl, bc
	jr .next

.found_it
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hl]
	ld c, a
	cp %11111111
	pop hl
	ret

.healingactions
; item, party menu action text, status
	db ANTIDOTE,     PARTYMENUTEXT_HEAL_PSN, 1 << PSN
	db BURN_HEAL,    PARTYMENUTEXT_HEAL_BRN, 1 << BRN
	db ICE_HEAL,     PARTYMENUTEXT_HEAL_FRZ, 1 << FRZ
	db AWAKENING,    PARTYMENUTEXT_HEAL_SLP, SLP
	db PARLYZ_HEAL,  PARTYMENUTEXT_HEAL_PAR, 1 << PAR
	db FULL_HEAL,    PARTYMENUTEXT_HEAL_ALL, %11111111
	db FULL_RESTORE, PARTYMENUTEXT_HEAL_ALL, %11111111
	db HEAL_POWDER,  PARTYMENUTEXT_HEAL_ALL, %11111111
	db PECHA_BERRY,  PARTYMENUTEXT_HEAL_PSN, 1 << PSN
	db CHERI_BERRY,  PARTYMENUTEXT_HEAL_PAR, 1 << PAR
	db ASPEAR_BERRY, PARTYMENUTEXT_HEAL_FRZ, 1 << FRZ
	db RAWST_BERRY,  PARTYMENUTEXT_HEAL_BRN, 1 << BRN
	db CHESTO_BERRY, PARTYMENUTEXT_HEAL_SLP, SLP
	db LUM_BERRY,    PARTYMENUTEXT_HEAL_ALL, %11111111
	db -1, 0, 0

RevivalHerb:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; end of function

.function
	call RevivePokemon
	and a
	jp nz, WontHaveAnyEffectMessage

	ld c, HAPPINESS_REVIVALHERB
	jp ChangeHappinessAndPrintLooksBitterMessage

ReviveItem:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

.function
	call RevivePokemon
	and a
	ret z
	jp WontHaveAnyEffectMessage

RevivePokemon:
	call IsMonFainted
	ld a, 1
	ret nz
	ld a, [wBattleMode]
	and a
	jr z, .skip_to_revive

	ld a, [wCurPartyMon]
	ld c, a
	ld hl, wBattleParticipantsIncludingFainted
	ld b, CHECK_FLAG
	predef FlagAction
	ld a, c
	and a
	jr z, .skip_to_revive

	ld a, [wCurPartyMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, SET_FLAG
	predef FlagAction

.skip_to_revive
	xor a
	ld [wLowHealthAlarm], a
	ld a, [wCurItem]
	cp REVIVE
	jr z, .revive_half_hp

	call ReviveFullHP
	jr .finish_revive

.revive_half_hp
	call ReviveHalfHP

.finish_revive
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_REVIVE
	ld [wPartyMenuActionText], a
	call ItemActionTextWaitButton
	call UseDisposableItem
	xor a
	ret

FullRestore:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

.function
	call IsMonFainted
	jp z, WontHaveAnyEffectMessage

	call IsMonAtFullHealth
	jp nc, .useStatusHealer
; full restore
	xor a
	ld [wLowHealthAlarm], a
	call ReviveFullHP
	ld a, MON_STATUS
	call GetPartyParamLocation
	xor a
	ld [hli], a
	ld [hl], a
	call HealStatus
	call BattlemonRestoreHealth
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_HEAL_HP
	ld [wPartyMenuActionText], a
	call ItemActionTextWaitButton
	jp UseDisposableItem
.useStatusHealer
	call UseStatusHealer
	and a
	ret z
	jp WontHaveAnyEffectMessage

BitterBerry:
	ld hl, wPlayerSubStatus3
	bit SUBSTATUS_CONFUSED, [hl]
	jr z, .noEffect
	res SUBSTATUS_CONFUSED, [hl]
	xor a
	ldh [hBattleTurn], a
	call UseItemText
	ld hl, ConfusedNoMoreText
	call StdBattleTextBox
	jr .clearPalettes
.noEffect
	call WontHaveAnyEffectMessage
.clearPalettes
	jp ClearPalettes

RecoverHPItem:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

.function
	call ItemRestoreHP
	and a
	ret z
	jp WontHaveAnyEffectMessage

ItemRestoreHP:
	call IsMonFainted
	jr z, .fail

	call IsMonAtFullHealth
	jr nc, .fail

	xor a
	ld [wLowHealthAlarm], a
	call GetHealingItemAmount
	call RestoreHealth
	call BattlemonRestoreHealth
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_HEAL_HP
	ld [wPartyMenuActionText], a
	call ItemActionTextWaitButton
	call UseDisposableItem
	xor a
	ret
.fail
	ld a, 1
	ret

HealHP_SFX_GFX:
	push de
	ld de, SFX_POTION
	call WaitPlaySFX
	pop de
	ld a, [wCurPartyMon]
	hlcoord 9, 0
	ld bc, SCREEN_WIDTH * 2
	rst AddNTimes
	ld a, 2
	ld [wWhichHPBar], a
	predef_jump AnimateHPBar

HerbelMedicine_HealHP:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

.function
	call ItemRestoreHP
	and a
	jp nz, WontHaveAnyEffectMessage
	ld a, [wCurItem]
	cp ENERGYPOWDER
	ld c, HAPPINESS_BITTERPOWDER
	jr z, .gotHappinessModifier
	ld c, HAPPINESS_ENERGYROOT
.gotHappinessModifier
	jp ChangeHappinessAndPrintLooksBitterMessage

UseItem_SelectMon:
	pop hl
	ld a, l
	ld [wPartyMenuItemEffectPointer], a
	ld a, h
	ld [wPartyMenuItemEffectPointer + 1], a
	call UseItem_InitMonSelection
.loop
	callba PartyMenuSelect
	jp c, .exitedPartyMenu
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .canNotUseOnEgg
	ld a, [wBattleMode]
	and a
	jr nz, .oneUse
	ld hl, wPartyMenuItemEffectPointer
	call CallLocalPointer
	ld hl, wNumItems
	call CheckItem
	jr nc, .outOfItems
.redrawPartyMenu
	ld a, [wSavedPartyMenuActionText]
	ld [wPartyMenuActionText], a
	ld a, [wCurItem]
	cp RARE_CANDY
	jr z, .reInitEverything
	cp ETHER
	jr z, .reInitMenu
	cp PP_UP
	jr z, .reInitMenu
	cp LEPPA_BERRY
	jr z, .reInitMenu
	cp MAX_ETHER
	jr nz, .notMenuCreatingItems
.reInitMenu
	callba InitPartyMenuWithCancel
.notMenuCreatingItems
	callba RedrawPartyMenu
	jr .loop
.reInitEverything
	ld a, [wMonTriedToEvolve]
	and a
	jr z, .reInitMenu
	call ClearPalettes
	call SetUpMonSelectionPartyMenu
	jr .loop
.canNotUseOnEgg
	call CantUseOnEggMessage
	jr .loop
.outOfItems
	ld a, [wCurItem]
	ld [wd265], a
	call GetItemName
	call CopyName1
	ld hl, .YouUsedYourLastItemText
	call PrintText
	jr .clearPalettes
.oneUse
	ld hl, wPartyMenuItemEffectPointer
	call CallLocalPointer
; hardcode for ether/max ether
	ld a, [wCurItem]
	cp ETHER
	jr z, .checkForFailure
	cp LEPPA_BERRY
	jr z, .checkForFailure
	cp MAX_ETHER
	jr nz, .clearPalettes
.checkForFailure
	ld a, [wItemEffectSucceeded]
	dec a
	jr z, .redrawPartyMenu
	dec a
	jr nz, .clearPalettes
	ld a, 1
	jr .writeToItemEffectSucceededAndExit
.exitedPartyMenu
	xor a
.writeToItemEffectSucceededAndExit
	ld [wItemEffectSucceeded], a
.clearPalettes
	jp ClearPalettes

.YouUsedYourLastItemText
	text_jump YouUsedYourLastItemText

UseItem_InitMonSelection:
	ld a, b
	ld [wPartyMenuActionText], a
	ld [wSavedPartyMenuActionText], a
InitMonSelection_Softboiled:
	push hl
	push de
	push bc
	call ClearBGPalettes
	call SetUpMonSelectionPartyMenu
	jp PopOffBCDEHLAndReturn

SetUpMonSelectionPartyMenu:
	callba InitPartyMenuLayout
	call ApplyTilemapInVBlank
	call SetPalettes
	jp DelayFrame

ItemActionText:
	ld [wPartyMenuActionText], a
	ld a, [wCurPartySpecies]
	push af
	ld a, [wCurPartyMon]
	push hl
	push de
	push bc
	push af
	callba WritePartyMenuTilemap
	callba PrintPartyMenuActionText
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame
	pop af
	pop bc
	pop de
	pop hl
	ld [wCurPartyMon], a
	pop af
	ld [wCurPartySpecies], a
	ret

ItemActionTextWaitButton:
	ld a, [wPartyMenuActionText]
	call ItemActionText
	ld c, 10
	call DelayFrames
	jp ButtonSound

IsItemUsedOnBattleMon:
	ld a, [wBattleMode]
	and a
	ret z
	ld a, [wCurPartyMon]
	push hl
	ld hl, wCurBattleMon
	cp [hl]
	pop hl
	jr nz, .nope
	scf
	ret

.nope
	xor a
	ret

ReviveHalfHP:
	call LoadHPFromBuffer1
	srl d
	rr e
	jr ContinueRevive

ReviveFullHP:
	call LoadHPFromBuffer1
	; fallthrough

ContinueRevive:
	ld a, MON_HP
	call GetPartyParamLocation
	ld [hl], d
	inc hl
	ld [hl], e
	jp LoadCurHPIntoBuffer5

RestoreHealth:
	ld a, MON_HP + 1
	call GetPartyParamLocation
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hl], a
	jr c, .full_hp
	call LoadCurHPIntoBuffer5
	ld a, MON_HP + 1
	call GetPartyParamLocation
	ld d, h
	ld e, l
	ld a, MON_MAXHP + 1
	call GetPartyParamLocation
	ld a, [de]
	sub [hl]
	dec de
	dec hl
	ld a, [de]
	sbc [hl]
	ret c
.full_hp
	jp ReviveFullHP

RemoveHP:
	ld a, MON_HP + 1
	call GetPartyParamLocation
	ld a, [hl]
	sub e
	ld [hld], a
	ld a, [hl]
	sbc d
	ld [hl], a
	jr nc, .okay
	xor a
	ld [hld], a
	ld [hl], a
.okay
	jp LoadCurHPIntoBuffer5

IsMonFainted:
	push de
	call LoadMaxHPToBuffer1
	call LoadCurHPToBuffer3
	call LoadHPFromBuffer3
	ld a, d
	or e
	pop de
	ret

IsMonAtFullHealth:
	call LoadHPFromBuffer3
	ld h, d
	ld l, e
	call LoadHPFromBuffer1
	ld a, l
	sub e
	ld a, h
	sbc d
	ret

LoadCurHPIntoBuffer5:
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld [wCurHPAnimNewHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimNewHP], a
	ret

LoadHPIntoBuffer5:
	ld a, d
	ld [wCurHPAnimNewHP + 1], a
	ld a, e
	ld [wCurHPAnimNewHP], a
	ret

LoadHPFromBuffer5:
	ld a, [wCurHPAnimNewHP + 1]
	ld d, a
	ld a, [wCurHPAnimNewHP]
	ld e, a
	ret

LoadCurHPToBuffer3:
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld [wCurHPAnimOldHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	ret

LoadHPFromBuffer3:
	ld a, [wCurHPAnimOldHP + 1]
	ld d, a
	ld a, [wCurHPAnimOldHP]
	ld e, a
	ret

LoadMaxHPToBuffer1:
	push hl
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	pop hl
	ret

LoadHPFromBuffer1:
	ld a, [wCurHPAnimMaxHP + 1]
	ld d, a
	ld a, [wCurHPAnimMaxHP]
	ld e, a
	ret

GetOneFifthMaxHP:
	push bc
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld a, 5
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ldh a, [hQuotient + 1]
	ld d, a
	ldh a, [hQuotient + 2]
	ld e, a
	pop bc
	ret

GetHealingItemAmount:
	push hl
	ld a, [wCurItem]
	ld hl, .Healing - 1
	ld d, a
.next
	inc hl
	ld a, [hli]
	cp d
	jr z, .got_value
	add a, 1 ;carries on -1
	jr nc, .next
.got_value
	ld e, [hl]
	ld d, 0
	jr c, .done
	ld a, e
	cp 5
	jr nc, .done

	ld a, [wCurPartyMon]
	ld hl, wPartyMon1MaxHP
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	pop bc
	ld a, [hli]
	ld d, a
	ld a, e
	ld e, [hl]
	jr .handle_shift_loop
.shift_loop
	srl d
	rr e
	dec a
.handle_shift_loop
	and a ;needed to clear carry
	jr nz, .shift_loop
.done
	pop hl
	ret

.Healing
	; healing amounts below five are considered to be shift amounts over the max HP
	db FRESH_WATER,   50
	db SODA_POP,      60
	db LEMONADE,      80
	db HYPER_POTION, 200
	db SUPER_POTION,  50
	db POTION,        20
	db MAX_POTION,     0
	db FULL_RESTORE,   0
	db MOOMOO_MILK,  100
	db ORAN_BERRY,    10
	db BERRY_JUICE,   20
	db BURGER,        80
	db FRIES,         30
	db KEG_OF_BEER,   50
	db ENERGYPOWDER,  50
	db ENERGY_ROOT,  200
	db SITRUS_BERRY,   2
	db -1,             0

Softboiled_MilkDrinkFunction:
; Softboiled/Milk Drink in the field
	ld a, [wPartyMenuCursor]
	dec a
	ld b, a
	call .select
	jr c, .skip
	ld a, b
	ld [wCurPartyMon], a
	call IsMonFainted
	call GetOneFifthMaxHP
	call RemoveHP
	push bc
	call HealHP_SFX_GFX
	pop bc
	call GetOneFifthMaxHP
	ld a, c
	ld [wCurPartyMon], a
	call IsMonFainted
	call RestoreHealth
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_HEAL_HP
	call ItemActionText
	call JoyWaitAorB
.skip
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	ret

.select
	push bc
	ld a, PARTYMENUACTION_HEALING_ITEM
	ld [wPartyMenuActionText], a
	call InitMonSelection_Softboiled
	callba PartyMenuSelect
	pop bc
	ret c
	ld a, [wPartyMenuCursor]
	dec a
	ld c, a
	ld a, b
	cp c
	jr z, .cant_use ; chose the same mon as user
	ld a, c
	ld [wCurPartyMon], a
	call IsMonFainted
	jr z, .cant_use
	call IsMonAtFullHealth
	jr nc, .cant_use
	xor a
	ret

.cant_use
	push bc
	ld hl, .text
	call MenuTextBoxBackup
	pop bc
	jr .select

.text
	ctxt "That can't be used"
	line "on this #mon."
	prompt

EscapeRope:
	xor a
	ld [wItemEffectSucceeded], a
	callba EscapeRopeFunction

	ld a, [wItemEffectSucceeded]
	cp 1
	jp z, UseDisposableItem
	ret

SuperRepel:
	ld b, 200 / 2
	jr UseRepel

MaxRepel:
	ld b, 300 / 2
	jr UseRepel

Repel:
	ld b, 100 / 2
UseRepel:
	ld hl, wRepelEffect
	ld a, [hli]
	or [hl]
	jr nz, .print_text

	xor a
	sla b
	rla
	ld [hld], a
	ld [hl], b
	ld a, [wCurItem]
	ld [wLastRepelUsed], a
	jr UseItemText2

.print_text
	ld hl, .text
	jp PrintText

.text
	ctxt "The Repel used"
	line "earlier is still"
	cont "in effect."
	prompt

PokeDoll:
	ld a, [wBattleMode]
	dec a
	jr nz, .not_wild_battle
	inc a
	ld [wForcedSwitch], a
	ld a, [wBattleResult]
	and 3 << 6
	or 2
	ld [wBattleResult], a
	jr UseItemText2

.not_wild_battle
	xor a
	ld [wItemEffectSucceeded], a
	ret

GuardSpec:
	ld hl, wPlayerSubStatus4
	bit SUBSTATUS_MIST, [hl]
	jp nz, WontHaveAnyEffect_NotUsedMessage
	set SUBSTATUS_MIST, [hl]
	jr UseItemText2

DireHit:
	ld hl, wPlayerSubStatus4
	bit SUBSTATUS_FOCUS_ENERGY, [hl]
	jp nz, WontHaveAnyEffect_NotUsedMessage
	set SUBSTATUS_FOCUS_ENERGY, [hl]
UseItemText2:
	;simply to allow jr instead of jp
	jp UseItemText

XBoostItem:
	call UseItemText

	ld a, [wCurItem]
	ld hl, .x_item_table

.loop
	cp [hl]
	jr z, .got_it
	inc hl
	inc hl
	jr .loop

.got_it
	inc hl
	ld b, [hl]
	xor a
	ldh [hBattleTurn], a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	callba BattleCommand_StatUp
	call WaitSFX

	callba BattleCommand_StatUpMessage
	callba BattleCommand_StatUpFailText

	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	ld c, HAPPINESS_USEDXITEM
	jpba ChangeHappiness

.x_item_table
	db X_ATTACK,   ATTACK
	db X_DEFEND,   DEFENSE
	db X_SPEED,    SPEED
	db X_SP_ATK,   SP_ATTACK
	db X_SP_DEF,   SP_DEFENSE
	db X_ACCURACY, ACCURACY

CoinCase:
	ld hl, .text
	jp MenuTextBoxWaitButton

.text
	ctxt "Coins:"
	line "@"
	deciram wCoins, 2, 4
	text ""
	done

OldRod:
	ld e, 0
	jr _FishFunction

GoodRod:
	ld e, 1
	jr _FishFunction

SuperRod:
	ld e, 2
_FishFunction:
	jpba FishFunction

ItemfinderItem:
	jpba ItemfinderFunction

ElixirItem:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; end of function

.function
	ld a, [wCurItem]
	ld [wd002], a
	ld hl, wMenuCursorY
	ld a, [hli]
	ld c, [hl]
	ld b, a
	push bc
	xor a
	ld [hld], a
	ld [hl], a
	ld b, NUM_MOVES
.moveLoop
	push bc
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetMthMoveOfNthPartymon
	ld a, [hl]
	and a
	jr z, .next

	call RestorePP
	jr z, .next
	ld hl, wMenuCursorX
	inc [hl]
.next
	ld hl, wMenuCursorY
	inc [hl]
	pop bc
	dec b
	jr nz, .moveLoop
	ld a, [wMenuCursorX]
	and a
	pop bc
	ld a, b
	ld [wMenuCursorY], a
	ld a, c
	ld [wMenuCursorX], a
	jp nz, BattleRestorePP
	jp WontHaveAnyEffectMessage

PPUP:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
	; NOT fallthrough

.function
	ld hl, .which_move
.loop
	call PrintPPMessageAndSelectMove
	ret nz
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	ld a, [hl]
	cp 3 << 6 ; have 3 PP Ups already been used?
	jr nc, .used3PPUps
	ld a, [hl]
	add 1 << 6 ; increase PP Up count by 1
	ld [hl], a
	ld a, 1
	ld [wd265], a
	call ApplyPPUp
	call Play_SFX_FULL_HEAL
	ld hl, .increased
	call PrintText
	jp UseDisposableItem

.used3PPUps
	ld hl, .maxed
	call PrintText
	jr .loop

.which_move
	ctxt "Raise the PP of"
	line "which move?"
	done

.increased
	ctxt "<STRBF2>'s PP"
	line "increased."
	prompt

.maxed
	ctxt "<STRBF2>'s PP"
	line "is maxed out."
	prompt

RecoverPPItem:
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; function end

.function
	ld a, [wCurItem]
	ld [wd002], a
	ld hl, .which_move
	call PrintPPMessageAndSelectMove
	ret nz
	call RestorePP
	jp z, WontHaveAnyEffectMessage
	call BattleRestorePP
	ld a, 2
	ld [wItemEffectSucceeded], a
	ret

.which_move
	ctxt "Restore the PP of"
	line "which move?"
	done

BattleRestorePP:
	ld a, [wBattleMode]
	and a
	jr z, .not_in_battle
	ld a, [wCurPartyMon]
	ld b, a
	ld a, [wCurBattleMon]
	cp b
	jr nz, .not_in_battle
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	call z, .UpdateBattleMonPP

.not_in_battle
	call Play_SFX_FULL_HEAL
	ld hl, .text
	call PrintText
	jp UseDisposableItem

.text
	ctxt "PP was restored."
	prompt

.UpdateBattleMonPP
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld de, wBattleMonMoves
	ld b, NUM_MOVES
.loop
	ld a, [de]
	and a
	ret z
	cp [hl]
	jr nz, .next
	push hl
	push de
	push bc

	push hl
	ld hl, wBattleMonPP - wBattleMonMoves
	add hl, de
	ld d, h
	ld e, l
	pop hl

	ld bc, MON_PP - MON_MOVES
	add hl, bc
	ld a, [hl]
	ld [de], a
	pop bc
	pop de
	pop hl

.next
	inc hl
	inc de
	dec b
	jr nz, .loop
	ret

RestorePP:
	xor a ; PARTYMON
	ld [wMonType], a
	call GetMaxPPOfMove
	ld hl, wPartyMon1PP
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetMthMoveOfNthPartymon
	ld a, [wd265]
	ld b, a
	ld a, [hl]
	and (1 << 6) - 1
	cp b
	jr nc, .dont_restore

	ld a, [wd002]
	cp MAX_ELIXIR
	jr z, .restore_all
	cp MAX_ETHER
	jr z, .restore_all

	ld c, 5
	cp LEPPA_BERRY
	jr z, .restore_some

	ld c, 10

.restore_some
	ld a, [hl]
	and (1 << 6) - 1
	add c
	cp b
	jr nc, .restore_all
	ld b, a

.restore_all
	ld a, [hl]
	and 3 << 6
	or b
	ld [hl], a
	ret

.dont_restore
	xor a
	ret

PrintPPMessageAndSelectMove:
	ld a, [wCurMoveNum]
	push af
	xor a
	ld [wCurMoveNum], a
	ld a, 2
	ld [wMoveSelectionMenuType], a
	callba MoveSelectionScreen
	pop bc

	ld a, b
	ld [wCurMoveNum], a
	ret nz
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetMthMoveOfNthPartymon

	push hl
	ld a, [hl]
	ld [wd265], a
	call GetMoveName
	call CopyName1
	pop hl
	xor a
	ret

SacredAsh:
	callba _SacredAsh
	ld a, [wItemEffectSucceeded]
	cp 1
	ret nz
	jp UseDisposableItem

TimeMachineItem:
	jpba TimeMachine

TokenTrackerItem:
	jpba UseTokenTrackerItem

OreCaseItem:
	jpba OpenOreCaseMenu

SmelterItem:
	ld a, [wUsingItemWithSelect]
	and a
	ld a, BANK(SmeltingScript)
	ld hl, SmeltingScript
	jr z, .notRanWithSelect
	call FarQueueScript
	ld a, HMENURETURN_SCRIPT
	ldh [hMenuReturn], a
	ret
.notRanWithSelect
	ld b, a
	ld d, h
	ld e, l
	jp RunScriptFromASM

IronPickaxeItem:
	call SpeechTextBox
	call LoadStandardMenuHeader
	ld a, [wSpriteUpdatesEnabled]
	push af
	ld a, 1
	ld [wSpriteUpdatesEnabled], a
	ld hl, .choose_mode
	call PrintText
	ld a, [wMiningPickaxeMode]
	inc a
	ld [wMiningPickaxeModePlusOne], a
	coord hl, 0, 0
	lb bc, 1, 7
	call TextBox
	coord hl, 1, 1
	ld de, .current_mode
	call PlaceText
	coord hl, 0, 3
	lb bc, 3, 7
	call TextBox
	coord hl, 1, 4
	ld de, .current_charge
	call PlaceText
	ld hl, .MenuHeader
	call CopyMenuHeader
	call InitScrollingMenu
	call UpdateSprites
	ld a, [wMiningPickaxeModePlusOne]
	ld [wMenuCursorBuffer], a
	call ScrollingMenu
	push af
	xor a
	ldh [hBGMapMode], a
	ld b, 3
	call ApplyTilemap
	pop af
	cp B_BUTTON
	ld hl, .mode_not_changed
	jr z, .cancelled
	ld a, [wMenuSelection]
	dec a
	ld [wMiningPickaxeMode], a
	ld hl, .mode_changed
.cancelled
	call PrintText
	call CloseWindow
	pop af
	ld [wSpriteUpdatesEnabled], a
	ret

.CurrentModeTextBoxMenuHeader:
	db %01000010 ; flags
	db 01, 01 ; start coords
	db 02, 08 ; end coords
	dw NULL
	db 1 ; default option

.MenuHeader
	db %01000010 ; flags
	db 01, 10 ; start coords
	db 08, 18 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db %110000 ; flags
	db 4, 0 ; rows, quantity spacing
	db 1 ; num bytes per entry
	dba .items
	dba .PrintPickaxeMode
	dba GenericDummyFunction
	dba .PrintModeDescription

.items
	db 3
	db 1
	db 2
	db 3
	db $ff

.PrintPickaxeMode:
	ld h, d
	ld l, e
	ld de, .new_mode
	jp PlaceText

.PrintModeDescription:
	coord hl, 0, 10
	lb bc, 6, TEXTBOX_INNERW
	call TextBox
	ld a, [wMenuSelection]
	inc a
	ret z
	add a, a
	; -4 because a is now 2-based (1-based menu entries plus 1 from inc a) and the array indices are 0-based
	add a, LOW(.mode_descriptions - 4)
	ld l, a
	adc HIGH(.mode_descriptions - 4)
	sub l
	ld h, a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	coord hl, 1, 12
	jp PlaceText

.mode_descriptions
	dw .mode1
	dw .mode2
	dw .mode3

.mode1
	ctxt "Mining will only"
	next "use the Iron"
	next "Pickaxe."
	done

.mode2
	ctxt "Defaults to Mining"
	next "Picks if Iron Pick"
	next "is not charged up."
	done

.mode3
	ctxt "Mining will only"
	next "use up Mining"
	next "Picks."
	done

.current_mode
	text "Mode @"
	deciram wMiningPickaxeModePlusOne, 1, 1
	db "@"

.new_mode
	text "Mode @"
	deciram wMenuSelection, 1, 1
	db "@"

.current_charge
	text "Charge:"
	nl "@"
	start_asm
	ld a, [wIronPickaxeStepCount]
	cp 100
	call c, .print_space
	cp 10
	call c, .print_space
	ld hl, .continue
	ret
.continue
	deciram wIronPickaxeStepCount, 1, 3
	ctxt "/250"
	nl "  steps"
	done

.print_space
	ld e, a
	ld a, " "
	ld [bc], a
	inc bc
	ld a, e
	ret

.choose_mode
	ctxt "Please select the"
	line "mining mode."
	prompt

.mode_changed
	ctxt "Mining mode has"
	line "been changed to"
	cont "Mode @"
	deciram wMenuSelection, 1, 1
	text "."
	prompt

.mode_not_changed
	ctxt "Mining mode has"
	line "been kept as"
	cont "Mode @"
	deciram wMiningPickaxeModePlusOne, 1, 1
	text "."
	prompt

HyperShareItem:
	CheckAndResetEngine ENGINE_HYPER_SHARE_ENABLED
	ld de, .disabled
	jr nz, .ok
	SetEngineForceReuseHL ENGINE_HYPER_SHARE_ENABLED
	ld de, .enabled
.ok
	ld h, d
	ld l, e
	jp PrintText

.disabled
	ctxt "The Hyper Share"
	line "has been disabled."
	prompt

.enabled
	ctxt "The Hyper Share"
	line "has been enabled."
	prompt

BlueFluteEffect:
	ld a, [wBattleMonStatus]
	and SLP
	jr nz, .go
	ld a, [wEnemyMonStatus]
	and SLP
	jp z, InBattleFlute_PrintCatchyTuneText
.go
	ld hl, wBattleMonStatus
	ld a, [hl]
	and $f8
	ld [hl], a

	ld hl, wEnemyMonStatus
	ld a, [hl]
	and $f8
	ld [hl], a

	call UsedFluteText
	ld hl, .text
	jp PrintText

.text
	text_jump AllWokeUpText

RedFluteEffect:
	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_IN_LOVE, a
	jr nz, .go
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_IN_LOVE, a
	jp z, InBattleFlute_PrintCatchyTuneText
.go
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	call UseItemTextNoToss
	ld hl, .text
	jp PrintText

.text
	text_jump AllCameToSensesText

YellowFluteEffect:
	ld hl, wPlayerSubStatus3
	bit SUBSTATUS_CONFUSED, [hl]
	jr nz, .go
	ld hl, wEnemySubStatus3
	bit SUBSTATUS_CONFUSED, [hl]
	jp z, InBattleFlute_PrintCatchyTuneText ; Both are false so do nothing.
	ld hl, wPlayerSubStatus3 ; Reload player status.
.go
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, wEnemySubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	call UsedFluteText
	ld hl, .text
	jp PrintText

.text
	text_jump AllConfusedNoMoreText

OrangeFluteEffect:
	ld hl, wWeather
	ld a, [hli]
	and a
	jp z, InBattleFlute_PrintCatchyTuneText
	ld [hl], 1
	call UseItemTextNoToss
	jpba HandleWeather

GreenFluteEffect:
	ld a, [wPlayerSubStatus1]
	bit SUBSTATUS_NIGHTMARE, a
	jr nz, .go
	ld a, [wEnemySubStatus1]
	bit SUBSTATUS_NIGHTMARE, a
	jr nz, .go
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_LEECH_SEED, a
	jr nz, .go
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_LEECH_SEED, a
	jp z, InBattleFlute_PrintCatchyTuneText
.go
	call UsedFluteText

	ld hl, wPlayerSubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_LEECH_SEED, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	ld hl, wEnemySubStatus4
	res SUBSTATUS_LEECH_SEED, [hl]

	ld hl, .text
	jp PrintText

.text
	text_jump EndNightmaresLeechSeedText

PurpleFluteEffect:
	ld hl, wPlayerScreens
	ld a, [hli]
	and (1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN)
	jr nz, .erase
	ld a, [hl] ; enemy screens
	and (1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN)
	jp z, InBattleFlute_PrintCatchyTuneText
.erase
	ld hl, wPlayerScreens
	ld a, [hl]
	and ~((1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN))
	ld [hli], a
	ld a, [hl]
	and ~((1 << SCREENS_REFLECT) | (1 << SCREENS_LIGHT_SCREEN))
	ld [hli], a

	inc hl
	xor a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	ld [hli], a
	ld [hli], a

	ld hl, .text
	jp PrintText

.text
	text_jump EndWallsText

InBattleFlute_PrintCatchyTuneText:
	ld hl, PlayedTheFluteText
	call PrintText
	ld hl, .text
	jp PrintText

.text
	ctxt "Now, that's a"
	line "catchy tune!"
	prompt

UsedFluteText:
	ld hl, PlayedTheFluteText
	call PrintText
	ld de, SFX_POKEFLUTE
	call WaitPlaySFX
	jp WaitSFX

PlayedTheFluteText:
	ctxt "Played the"
	line "<STRBF2>."
	prompt

EncounterRateFlute_NothingHappened:
	ld hl, PlayedTheFluteText
	call PrintText
	ld hl, .text
	call PrintText
	ld a, 2
	ld [wItemEffectSucceeded], a
	ret

.text
	ctxt "The wild #mon"
	line "were unaffected by"
	cont "the flute's melody<...>"
	prompt

BlackFluteEffect:
; half encounter rate if white flute isn't in effect
; normalize encounter rate if white flute is in effect
	ld hl, wEncounterRateStage
	ld a, [hl]
	and a
	jr z, EncounterRateFlute_NothingHappened
	dec [hl]
	jr EncounterRateFlute_UseFlute

WhiteFluteEffect:
	ld hl, wEncounterRateStage
	ld a, [hl]
	cp 2
	jr nc, EncounterRateFlute_NothingHappened
	inc [hl]
EncounterRateFlute_UseFlute:
	callba LoadWildMonData_KeepFlutes
	ld hl, PlayedTheFluteText
	call PrintText
	ld a, [wEncounterRateStage]
	and a
	ld hl, .less_likely
	jr z, .ok
	dec a
	ld hl, .more_likely
	jr nz, .ok
	ld a, [wCurItem]
	xor BLACK_FLUTE ^ WHITE_FLUTE
	call GetItemName
	ld hl, .cancel
.ok
	jp PrintText

.less_likely
	ctxt "Wild #mon are"
	line "less likely to"
	cont "appear."
	prompt

.more_likely
	ctxt "Wild #mon are"
	line "more likely to"
	cont "appear."
	prompt

.cancel
	ctxt "The effects of the"
	line "<STRBF1> have"
	cont "subsided."

	para "Wild #mon will"
	line "now appear as"
	cont "normal."
	prompt

Play_SFX_FULL_HEAL:
	push de
	ld de, SFX_FULL_HEAL
	call WaitPlaySFX
	pop de
	ret

UseItemTextNoToss:
	ld hl, Text_UsedItem
	call PrintText
	call Play_SFX_FULL_HEAL
	jp WaitPressAorB_BlinkCursor

Text_UsedItem:
	ctxt "<PLAYER> used the"
	line "<STRBF2>."
	done

UseItemText:
	call UseItemTextNoToss
UseDisposableItem:
	ld hl, wNumItems
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	jp TossItem

Ball_BoxIsFullMessage:
	ld hl, .text
	jr ItemWasNotUsed

.text
	ctxt "The #mon Box"
	line "is full. That"
	cont "can't be used now."
	prompt

WontHaveAnyEffect_NotUsedMessage:
	ld hl, Text_WontHaveAnyEffect
ItemWasNotUsed:
	call PrintText
	ld a, 2
	ld [wItemEffectSucceeded], a
	ret

CantUseOnEggMessage:
	ld hl, .text
	jr CantUseItemMessage

.text
	ctxt "That can't be used"
	line "on an egg."
	prompt

ItemDoesNothing:
	ld hl, Text_IsntTheTime
CantUseItemMessage:
	xor a
	ld [wItemEffectSucceeded], a
	jp PrintText

WontHaveAnyEffectMessage:
	ld hl, Text_WontHaveAnyEffect
	jr CantUseItemMessage

BelongsToSomeoneElseMessage:
	ld hl, .text
	jr CantUseItemMessage

.text
	ctxt "That belongs to"
	line "someone else!"
	prompt

CyclingIsntAllowedMessage:
	ld hl, .text
	jr CantUseItemMessage

.text
	ctxt "Cycling isn't"
	line "allowed here."
	prompt

CantGetOnYourBikeMessage:
	ld hl, .text
	jr CantUseItemMessage

.text
	ctxt "Can't get on your"
	line "<STRBF1> now."
	prompt

Text_IsntTheTime::
	ctxt "This isn't the"
	line "time to use that!"
	prompt

Text_WontHaveAnyEffect:
	ctxt "It won't have any"
	line "effect."
	prompt

LooksBitterMessage:
	ld hl, .text
	jp PrintText

.text
	ctxt "It looks bitter<...>"
	prompt

ApplyPPUp:
	ld a, MON_MOVES
	call GetPartyParamLocation
	push hl
	ld de, wPPUpPPBuffer
	predef FillPP
	pop hl
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	ld de, wPPUpPPBuffer
	ld b, 0
.loop
	inc b
	ld a, b
	cp NUM_MOVES + 1
	ret z
	ld a, [wd265]
	dec a
	jr nz, .use
	ld a, [wMenuCursorY]
	inc a
	cp b
	jr nz, .skip

.use
	ld a, [hl]
	and 3 << 6
	call nz, ComputeMaxPP

.skip
	inc hl
	inc de
	jr .loop

ComputeMaxPP:
	push bc
	; Divide the base PP by 5.
	ld a, [de]
	ld c, 5
	call SimpleDivide
	ld a, b
	ldh [hQuotient + 2], a ; we'll keep using this as a buffer
	; Get the number of PP Ups, which are bits 6 and 7 of the PP value stored in RAM.
	ld a, [hl]
	ld b, a
	rlca
	rlca
	and 3
	ld c, a
	; If this value is 0, we are done
	and a
	jr z, .NoPPUp

.loop
	ld a, b
	push af
	ldh a, [hQuotient + 2]
	add a, b
	ld b, a
	pop af
	or 63
	sub b
	cp 64
	jr c, .no_carry_into_PP_ups
	add a, b
	or 63
	ld b, a
.no_carry_into_PP_ups
	ld a, [wd265]
	dec a
	jr z, .NoPPUp
	dec c
	jr nz, .loop

.NoPPUp
	ld [hl], b
	pop bc
	ret

RestoreAllPP:
	ld a, MON_PP
	call GetPartyParamLocation
	push hl
	ld a, MON_MOVES
	call GetPartyParamLocation
	pop de
	xor a ; PARTYMON
	ld [wMenuCursorY], a
	ld [wMonType], a
	ld c, NUM_MOVES
.loop
	ld a, [hli]
	and a
	ret z
	push hl
	push de
	push bc
	call GetMaxPPOfMove
	pop bc
	pop de
	ld a, [de]
	and 3 << 6
	ld b, a
	ld a, [wd265]
	add b
	ld [de], a
	inc de
	ld hl, wMenuCursorY
	inc [hl]
	pop hl
	dec c
	jr nz, .loop
	ret

GetMaxPPOfMove:
	ld hl, wStringBuffer1
	ld a, [hli]
	ld l, [hl]
	ld h, a
	push hl

	ld a, [wMonType]
	and a

	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	jr z, .got_partymon ; PARTYMON

	ld hl, wOTPartyMon1Moves
	dec a
	jr z, .got_partymon ; OTPARTYMON

	ld hl, wTempMonMoves
	dec a
	jr z, .got_nonpartymon ; BOXMON

	dec a
	jr z, .got_nonpartymon ; BREEDMON

	ld hl, wBattleMonMoves ; WILDMON

.got_nonpartymon ; BOXMON, BREEDMON, WILDMON
	call GetMthMoveOfCurrentMon
	jr .gotdatmove

.got_partymon ; PARTYMON, OTPARTYMON
	call GetMthMoveOfNthPartymon

.gotdatmove
	ld a, [hl]
	dec a

	push hl
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld b, a
	ld de, wStringBuffer1
	ld [de], a
	pop hl

	push bc
	ld bc, MON_PP - MON_MOVES
	ld a, [wMonType]
	cp WILDMON
	jr nz, .notwild
	ld bc, wEnemyMonPP - wEnemyMonMoves
.notwild
	add hl, bc
	ld a, [hl]
	and 3 << 6
	pop bc

	or b
	ld hl, wStringBuffer1 + 1
	ld [hl], a
	xor a
	ld [wd265], a
	call ComputeMaxPP
	ld a, [hl]
	and (1 << 6) - 1
	ld [wd265], a

	pop bc
	ld hl, wStringBuffer1
	ld a, b
	ld [hli], a
	ld [hl], c
	ret

GetMthMoveOfNthPartymon:
	ld a, [wCurPartyMon]
	rst AddNTimes
GetMthMoveOfCurrentMon:
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	add hl, bc
	ret

SootSackEffect:
	ld hl, .text
	jp MenuTextBoxWaitButton

.text
	ctxt "Holding @"
	deciram wSootSackAsh, 2, 5
	ctxt ""
	line "grams of ash."
	done

OrphanCardEffect:
	ld hl, .text
	jp MenuTextBoxWaitButton

.text
	ctxt "Orphan Points:"
	line "@"
	deciram wOrphanPoints, 2, 5
	text ""
	done

FossilCaseEffect:
	ld hl, .text
	jp MenuTextBoxWaitButton

.text
	ctxt "Fossils: @"
	deciram wFossilCaseCount, 1, 2
	text ""
	done
