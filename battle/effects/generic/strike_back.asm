BattleCommand_StrikeBack:
; checks for effects that occur in response to a move: destiny bond and contact abilities
	ld hl, wEnemyMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wBattleMonHP

.got_hp
	ld a, [hli]
	or [hl]
	jr nz, ContactAbilityEffect

	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVar
	bit SUBSTATUS_DESTINY_BOND, a
	jr z, .no_dbond

	ld hl, wEnemyMonMaxHP + 1
	bccoord 0, 2 ; hp bar
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_max_hp
	ld hl, wBattleMonMaxHP + 1
	bccoord 9, 9 ; hp bar

.got_max_hp
	xor 1
	ld [wWhichHPBar], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP], a
	or [hl]
	ld a, [hld]
	ld [wCurHPAnimMaxHP + 1], a
	jr z, .finish

	push bc
	push hl
	ld hl, TookDownWithItText
	call StdBattleTextBox
	pop hl

	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	xor a
	ld [hld], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	xor a
	ld [hl], a
	ld [wCurHPAnimNewHP], a
	ld [wCurHPAnimNewHP + 1], a
	pop hl
	predef AnimateHPBar
	call RefreshBattleHuds

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [wFXAnimIDHi], a
	inc a
	ld [wBattleAnimParam], a
	ld a, DESTINY_BOND
	call LoadAnim
	call SwitchTurn
	jr .finish

.no_dbond
	call ContactAbilityEffect
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_MULTI_HIT
	jr z, .multiple_hit_raise_sub
	cp EFFECT_DOUBLE_HIT
	jr z, .multiple_hit_raise_sub
	cp EFFECT_TWINEEDLE
	jr nz, .finish
.multiple_hit_raise_sub
	call BattleCommand_RaiseSub
.finish
	jp EndMoveEffect

ContactAbilityEffect:
	call CheckSubstituteOpp
	ret nz
	callba UsedContactMove
	ret nc
	call GetTargetAbility
	ld [wMoveIsAnAbility], a
	ld hl, .ContactAbilities
	ld de, 3
	call IsInArray
	jr nc, .skip
	ld a, [wMoveIsAnAbility]
	ld [wd265], a
	call GetAbilityName
	inc hl
	ld a, [wMoveIsAnAbility]
	cp ABILITY_AFTERMATH
	jr z, .skip_random
	call BattleRandomPercentage ; preserves hl
	cp 30
	jr nc, .skip
.skip_random
	push af
	call SwitchTurn
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call _hl_
	call SwitchTurn
.skip
	xor a
	ld [wMoveIsAnAbility], a
	ret

.ContactAbilities:
	dbw ABILITY_STATIC, BattleCommand_ParalyzeTarget_IgnoreSub
	dbw ABILITY_FLAME_BODY, BattleCommand_BurnTarget_IgnoreSub
	dbw ABILITY_POISON_POINT, BattleCommand_PoisonTarget_IgnoreSub
	dbw ABILITY_CUTE_CHARM, BattleCommand_Attract
	dbw ABILITY_EFFECT_SPORE, .EffectSpore
	dbw ABILITY_AFTERMATH, .Aftermath
	db -1

.EffectSpore:
	push af
	callba CheckForSafetyGoggles
	pop bc
	ld a, b
	ret c
	cp 9
	jp c, BattleCommand_PoisonTarget_IgnoreSub
	cp 19
	jp c, BattleCommand_ParalyzeTarget_IgnoreSub
	jp BattleCommand_SleepTarget_IgnoreSub

.Aftermath:
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonHP
	jr z, .got_own_hp
	ld hl, wEnemyMonHP
.got_own_hp
	ld a, [hli]
	or [hl]
	ret nz ; we didn't faint

	call SwitchTurn
	callba GetQuarterMaxHP
	callba SubtractHPFromUser
	call UpdateUserInParty
	ld hl, BattleText_UsersHurtByStringBuffer1
	call StdBattleTextBox
	jp SwitchTurn
