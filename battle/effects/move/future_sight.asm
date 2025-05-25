BattleCommand_CheckFutureSight:
; checkfuturesight
	ld hl, wPlayerFutureSightCount
	ld de, wPlayerFutureSightUsersSpAtk
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyFutureSightCount
	ld de, wEnemyFutureSightUsersSpAtk
.ok

	ld a, [hl]
	cp 1
	ret nz

	dec [hl]
	ld a, [de]
	inc de
	ld [wCurDamageFixedValue], a
	ld a, [de]
	ld [wCurDamageFixedValue + 1], a
	ld a, $c0 ;fixed damage, dirty
	ld [wCurDamageFlags], a
	ld b, futuresight_command
	jp SkipToBattleCommand

BattleCommand_FutureSight:
; futuresight

	call CheckUserIsCharging
	jr nz, .already_charging
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr
	ld [hl], b
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	ld [hl], b
.already_charging
	ld hl, wPlayerFutureSightCount
	ld de, wBattleMonLevel
	ldh a, [hBattleTurn]
	and a
	jr z, .got_count
	ld hl, wEnemyFutureSightCount
	ld de, wEnemyMonLevel
.got_count
	ld a, [hl]
	and a
	jr nz, .failed
	ld a, 4
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ld de, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld de, wEnemyMonType1
.got_types
	ld a, [de]
	cp PSYCHIC
	jr z, .stab
	inc de
	ld a, [de]
	cp PSYCHIC
	jr nz, .no_stab
.stab
	set 7, [hl]
.no_stab
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	ld hl, ForesawAttackText
	call StdBattleTextBox
	call BattleCommand_RaiseSub
	ld hl, wBattleMonSpclAtk
	ld de, wPlayerFutureSightUsersSpAtk
	ldh a, [hBattleTurn]
	and a
	jr z, .store_damage
	ld hl, wEnemyMonSpclAtk
	ld de, wEnemyFutureSightUsersSpAtk
.store_damage
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	jp EndMoveEffect

.failed
	pop bc
	call ResetDamage
	call FailedGeneric
	jp EndMoveEffect
