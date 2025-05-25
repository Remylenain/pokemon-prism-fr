AI_SwitchOrTryItem:
	and a

	ld a, [wBattleMode]
	dec a
	ret z

	ld a, [wLinkMode]
	and a
	ret nz

	callba CheckEnemyLockedIn
	ret nz

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, AI_TryItem

	ld a, [wEnemySubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, AI_TryItem

	ld a, [wEnemyWrapCount]
	and a
	jr nz, AI_TryItem

	callba CheckPlayerAbilityPreventsEscaping
	jr z, AI_TryItem

	ld hl, TrainerClassAttributes + TRNATTR_AI_ITEM_SWITCH
	ld a, [wInBattleTowerBattle] ; Load always the first trainer class for Battle Tower trainers
	rrca
	jr c, .ok

	ld a, [wTrainerClass]
	dec a
	ld bc, 7
	rst AddNTimes
.ok
	push hl
	callba CheckAbleToSwitch
	pop hl
	ld a, [wEnemySwitchMonParam]
	swap a
	and $f
	jr z, AI_TryItem
	bit 3, a
	jr nz, AI_TryItem ;overflow check
	bit 2, a
	jr z, .go
	ld a, 3
.go
	bit SWITCH_OFTEN_F, [hl]
	jr nz, SwitchOften
	bit SWITCH_SOMETIMES_F, [hl]
	jr nz, SwitchSometimes
	bit SWITCH_RARELY_F, [hl]
	jr nz, SwitchRarely
	jr AI_TryItem

SwitchOften:
	; chances: 10/12/15 in 16
	add a, a
	cp 6
	sbc -9 ;add 9 - carry
	jr AI_CheckSwitch

SwitchSometimes:
	; chances: 4/8/12 in 16
	add a, a
	add a, a
	; fallthrough

SwitchRarely:
	; chances: 1/2/3 in 16
	; fallthrough
AI_CheckSwitch:
	ld l, a
	call Random
	and $f
	cp l
	jr nc, AI_TryItem

	ld a, [wEnemySwitchMonParam]
	and $f
	inc a
	; In register 'a' is the number (1-6) of the Pkmn to switch to
	ld [wEnemySwitchMonIndex], a
	jp AI_TrySwitch

CheckSubStatusCantRun:
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	ret nz
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	ret

AI_TryItem:
	; items are not allowed in the BattleTower
	ld a, [wInBattleTowerBattle]
	and 5
	ret nz

	ld a, [wEnemyTrainerItem1]
	ld b, a
	ld a, [wEnemyTrainerItem2]
	or b
	ret z

	call .IsHighestLevel
	ret nc

	ld a, [wTrainerClass]
	dec a
	ld hl, TrainerClassAttributes + TRNATTR_AI_ITEM_SWITCH
	ld bc, NUM_TRAINER_ATTRIBUTES
	rst AddNTimes
	ld b, h
	ld c, l
	ld hl, AI_Items
.loop
	ld de, wEnemyTrainerItem1
	ld a, [hl]
	and a
	inc a
	ret z

	ld a, [de]
	cp [hl]
	jr z, .has_item
	inc de
	ld a, [de]
	cp [hl]
	jr z, .has_item

	inc hl
	inc hl
	inc hl
	jr .loop

.has_item
	inc hl

	push hl
	push de
	call CallLocalPointer
	pop de
	pop hl

	inc hl
	inc hl
	jr c, .loop

.used_item
	call ZeroDamage ; exits with a = 0
	ld [de], a
	ld [wEnemyFuryCutterCount], a
	ld [wEnemyProtectCount], a
	ld [wLastPlayerCounterMove], a
	inc a
	ld [wEnemyGoesFirst], a

	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]

	scf
	ret

.IsHighestLevel
	ld a, [wOTPartyCount]
	ld d, a
	ld e, 0
	ld hl, wOTPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
.next
	ld a, [hl]
	cp e
	jr c, .ok
	ld e, a
.ok
	add hl, bc
	dec d
	jr nz, .next

	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Level
	rst AddNTimes
	ld a, [hl]
	cp e
	ccf
	ret

AI_Items:
	dbw FULL_RESTORE, .full_restore
	dbw MAX_POTION,   .max_potion
	dbw HYPER_POTION, .hyper_potion
	dbw SUPER_POTION, .super_potion
	dbw POTION,       .potion
	dbw FULL_HEAL,    .full_heal
	dbw LUM_BERRY,    .lum_berry
	dbw GUARD_SPEC,   .guard_spec
	dbw DIRE_HIT,     .dire_hit
	dbw X_ATTACK,     .x_attack
	dbw X_DEFEND,     .x_defend
	dbw X_SPEED,      .x_speed
	dbw X_SP_ATK,    .x_sp_atk
	dbw X_SP_DEF,     .x_sp_def
	dbw X_ACCURACY,   .x_accuracy
	db $ff

.full_heal
	call .status
	ret c
	call EnemyUsedFullHeal
	and a
	ret

.lum_berry
	call .status
	ret c
	call EnemyUsedLumBerry
	and a
	ret

.status
	ld a, [wEnemyMonStatus]
	and a
	scf
	ret z

	ld a, [bc]
	bit CONTEXT_USE_F, a
	jr nz, .status_check_context
	and ALWAYS_USE
	ret nz ;and clears carry
	jr .twenty_percent

.status_check_context
	ld a, [wEnemyMonSemistatus]
	bit SEMISTATUS_TOXIC, a
	jr z, .not_toxic
	ld a, [wEnemyToxicCount]
	cp 4
	jr c, .not_toxic
	call Random
	add a, a
	ret c
.not_toxic
	ld a, [wEnemyMonStatus]
	and 1 << FRZ | SLP
	ret nz ;and clears carry
	scf
	ret

.full_restore
	call .heal_item
	jr nc, .use_full_restore
	ld a, [bc]
	bit CONTEXT_USE_F, a
	scf
	ret z
	call .status
	ret c
.use_full_restore
	call EnemyUsedFullRestore
	and a
	ret

.max_potion
	call .heal_item
	ret c
	call EnemyUsedMaxPotion
	and a
	ret

.heal_item
	ld a, [bc]
	bit CONTEXT_USE_F, a
	jr nz, .check_HP_below_half
	callba AICheckEnemyHalfHP
	ret c
	ld a, [bc]
	bit UNKNOWN_USE_F, a
	jr nz, .check_HP_below_quarter
	callba AICheckEnemyQuarterHP
	ret nc
	call Random
	add a, a
	ret

.check_HP_below_quarter
	callba AICheckEnemyQuarterHP
	ret c
	call RandomPercentage
	cp 20
	ret

.check_HP_below_half
	callba AICheckEnemyHalfHP
	ret c
	callba AICheckEnemyQuarterHP
	ret nc
.twenty_percent
	call RandomPercentage
	cp 80
	ret

.hyper_potion
	call .heal_item
	ret c
	ld b, 200
	call EnemyUsedHyperPotion
	and a
	ret

.super_potion
	call .heal_item
	ret c
	ld b, 50
	call EnemyUsedSuperPotion
	and a
	ret

.potion
	call .heal_item
	ret c
	ld b, 20
	call EnemyUsedPotion
	and a
	ret

.x_item
	ld a, [wEnemyTurnsTaken]
	and a
	jr nz, .not_first_turn_out
	ld a, [bc]
	bit ALWAYS_USE_F, a
	ret nz ;carry is cleared here (due to and a)
	call Random
	add a, a
	ret c
	ld a, [bc]
	bit CONTEXT_USE_F, a
	ret nz ;carry is cleared here (due to ret c above)
	call Random
	add a, a
	ret
.not_first_turn_out
	ld a, [bc]
	bit ALWAYS_USE_F, a
	jr nz, .twenty_percent
	scf
	ret

.guard_spec
	call .x_item
	ret c
	call EnemyUsedGuardSpec
	and a
	ret

.dire_hit
	call .x_item
	ret c
	call EnemyUsedDireHit
	and a
	ret

.x_attack
	call .x_item
	ret c
	call EnemyUsedXAttack
	and a
	ret

.x_defend
	call .x_item
	ret c
	call EnemyUsedXDefend
	and a
	ret

.x_speed
	call .x_item
	ret c
	call EnemyUsedXSpeed
	and a
	ret

.x_sp_atk
	call .x_item
	ret c
	call EnemyUsedXSpAtk
	and a
	ret

.x_sp_def
	call .x_item
	ret c
	call EnemyUsedXSpDef
	and a
	ret

.x_accuracy
	call .x_item
	ret c
	call EnemyUsedXAccuracy
	and a
	ret

AIUpdateHUD:
	call UpdateEnemyMonInParty
	callba UpdateEnemyHUD
	ld a, 1
	ldh [hBGMapMode], a
	ld hl, wEnemyItemState
	dec [hl]
	scf
	ret

AIUsedItemSound:
	push de
	ld de, SFX_FULL_HEAL
	call PlaySFX
	pop de
	ret

EnemyUsedLumBerry:
	ld a, LUM_BERRY
	jr EnemyUsedStatusHealingItem

EnemyUsedFullHeal:
	ld a, FULL_HEAL
EnemyUsedStatusHealingItem:
	push af
	call AIUsedItemSound
	call AI_HealStatus
	pop af
	jp PrintText_UsedItemOn_AND_AIUpdateHUD

EnemyUsedMaxPotion:
	ld a, MAX_POTION
	ld [wAI_CurrentItem], a
	jr FullRestoreContinue

EnemyUsedFullRestore:
	call AI_HealStatus
	ld a, FULL_RESTORE
	ld [wAI_CurrentItem], a
	ld hl, wEnemySubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	xor a
	ld [wEnemyConfuseCount], a
	; fallthrough

FullRestoreContinue:
	ld de, wCurHPAnimOldHP
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, wEnemyMonMaxHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld [wCurHPAnimMaxHP], a
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wCurHPAnimMaxHP + 1], a
	ld [wEnemyMonHP], a
	jr EnemyPotionFinish

EnemyUsedPotion:
	ld a, POTION
	ld b, 20
	jr EnemyPotionContinue

EnemyUsedSuperPotion:
	ld a, SUPER_POTION
	ld b, 50
	jr EnemyPotionContinue

EnemyUsedHyperPotion:
	ld a, HYPER_POTION
	ld b, 200
	; fallthrough

EnemyPotionContinue:
	ld [wAI_CurrentItem], a
	ld hl, wEnemyMonHP + 1
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	add b
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .ok
	inc a
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a
.ok
	inc hl
	ld a, [hld]
	ld b, a
	ld de, wEnemyMonMaxHP + 1
	ld a, [de]
	dec de
	ld [wCurHPAnimMaxHP], a
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	ld [wCurHPAnimMaxHP + 1], a
	sbc b
	jr nc, EnemyPotionFinish
	inc de
	ld a, [de]
	dec de
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [de]
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a
	; fallthrough

EnemyPotionFinish:
	call PrintText_UsedItemOn
	hlcoord 0, 2
	xor a
	ld [wWhichHPBar], a
	call AIUsedItemSound
	predef AnimateHPBar
	jp AIUpdateHUD

AI_TrySwitch:
; Determine whether the AI can switch based on how many Pokemon are still alive.
; If it can switch, it will.
	ld a, [wOTPartyCount]
	ld c, a
	ld hl, wOTPartyMon1HP
	ld d, 0
.SwitchLoop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .fainted
	inc d
.fainted
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec c
	jr nz, .SwitchLoop

	ld a, d
	cp 2
	ccf
	ret nc
	; fallthrough

AI_Switch:
	ld a, 1
	ld [wEnemyIsSwitching], a
	ld [wEnemyGoesFirst], a
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]
	xor a
	ldh [hBattleTurn], a
	callba PursuitSwitch

	push af
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, wEnemyMonStatus
	ld bc, MON_MAXHP - MON_STATUS
	rst CopyBytes
	pop af

	ld hl, TextJump_EnemyWithdrew
	call nc, PrintText

	ld a, 1
	ld [wBattleHasJustStarted], a
	callba NewEnemyMonStatus
	callba ResetEnemyStatLevels
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	callba EnemySwitch
	callba ResetBattleParticipants
	call SetEnemyTurn
	callba SpikesDamage
	callba EnemyAbilityOnMonEntrance
	xor a
	ld [wBattleHasJustStarted], a
	ld a, [wLinkMode]
	and a
	ret nz
	scf
	ret

TextJump_EnemyWithdrew:
	text_jump Text_EnemyWithdrew

AI_HealStatus:
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	xor a
	ld [hl], a
	ld [wEnemyMonStatus], a
	ld hl, wEnemyMonSemistatus
	res SEMISTATUS_TOXIC, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	ld hl, wEnemySubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	ret

EnemyUsedGuardSpec:
	call AIUsedItemSound
	ld hl, wEnemySubStatus4
	set SUBSTATUS_MIST, [hl]
	ld a, GUARD_SPEC
	jr PrintText_UsedItemOn_AND_AIUpdateHUD

EnemyUsedDireHit:
	call AIUsedItemSound
	ld hl, wEnemySubStatus4
	set SUBSTATUS_FOCUS_ENERGY, [hl]
	ld a, DIRE_HIT
	jr PrintText_UsedItemOn_AND_AIUpdateHUD

EnemyUsedXAttack:
	ld b, ATTACK
	ld a, X_ATTACK
	jr EnemyUsedXItem

EnemyUsedXDefend:
	ld b, DEFENSE
	ld a, X_DEFEND
	jr EnemyUsedXItem

EnemyUsedXSpeed:
	ld b, SPEED
	ld a, X_SPEED
	jr EnemyUsedXItem

EnemyUsedXSpAtk:
	ld b, SP_ATTACK
	ld a, X_SP_ATK
	jr EnemyUsedXItem

EnemyUsedXSpDef:
	ld b, SP_DEFENSE
	ld a, X_SP_DEF
	jr EnemyUsedXItem

EnemyUsedXAccuracy:
	ld b, ACCURACY
	ld a, X_ACCURACY
	; fallthrough

EnemyUsedXItem:
	; in: a: item, b: stat
	ld [wAI_CurrentItem], a
	push bc
	call PrintText_UsedItemOn
	pop bc
	callba BattleCommand_StatUp
	jp AIUpdateHUD

PrintText_UsedItemOn_AND_AIUpdateHUD:
	; in: a: item
	ld [wAI_CurrentItem], a
	call PrintText_UsedItemOn
	jp AIUpdateHUD

PrintText_UsedItemOn:
	ld a, [wAI_CurrentItem]
	ld [wd265], a
	call GetItemName
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, ITEM_NAME_LENGTH
	rst CopyBytes
	ld hl, TextJump_EnemyUsedOn
	jp PrintText

TextJump_EnemyUsedOn:
	text_jump Text_EnemyUsedOn
