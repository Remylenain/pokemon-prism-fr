BattleCommand_Synchronize:
	callba UseHeldStatusHealingItem
	ret nz
	; Only proceed if the statused target has Synchronize...
	call GetTargetAbility
	cp ABILITY_SYNCHRONIZE
	ret nz
	; ... the user isn't statused...
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	ret nz
	; ... the user hasn't just fainted...
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonHP
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	ld a, [hli]
	or [hl]
	ret z
	; ... and the target's status is either paralysis, poisoning, or burn.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and (1 << PAR) | (1 << PSN) | (1 << BRN)
	ret z
	; Don't activate if, for whatever reason, the target has multiple statuses.
	; This should never happen.
	; This routine also gets the battle command that confers the new status
	; onto the user.
	ld hl, .Pointers
	ld e, 3
	call IsInArray
	ret nc
	; Tell the battle command that it's being called by an ability.
	ld a, ABILITY_SYNCHRONIZE
	ld [wMoveIsAnAbility], a
	ld [wd265], a
	call GetAbilityName
	call SwitchTurn
	call CallLocalPointer_AfterIsInArray
	xor a
	ld [wMoveIsAnAbility], a
	jp SwitchTurn

.Pointers:
	dbw (1 << PAR), BattleCommand_ParalyzeTarget_IgnoreSub
	dbw (1 << BRN), BattleCommand_BurnTarget_IgnoreSub
	dbw (1 << PSN), BattleCommand_PoisonTarget_IgnoreSub
	db $ff
