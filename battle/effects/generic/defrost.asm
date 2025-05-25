BattleCommand_Defrost:
; Thaw the user.

	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	bit FRZ, [hl]
	ret z
	res FRZ, [hl]

; Don't update the enemy's party struct in a wild battle.

	ldh a, [hBattleTurn]
	and a
	jr z, .party

	ld a, [wBattleMode]
	dec a
	jr z, .done

.party
	ld a, MON_STATUS
	call UserPartyAttr
	res FRZ, [hl]

.done
	call RefreshBattleHuds
	ld hl, WasDefrostedText
	jp StdBattleTextBox

BattleCommand_DefrostFoe:
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp FIRE
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret z
	; fallthrough

Defrost:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz

	bit FRZ, [hl]
	ret z
	ld [hl], 0

	ldh a, [hBattleTurn]
	and a
	ld hl, wPartyMon1Status
	ld a, [wCurBattleMon]
	jr nz, .ok
	ld a, [wBattleMode]
	dec a
	jr z, .msg
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status

.ok
	call GetPartyLocation
	xor a
	ld [hl], a
	call UpdateOpponentInParty

.msg
	ld hl, DefrostedOpponentText
	jp StdBattleTextBox
