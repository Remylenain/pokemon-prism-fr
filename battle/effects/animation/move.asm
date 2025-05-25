PlayFXAnimIDIfNotSemiInvulnerable:
; play animation de

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret nz
	; fallthrough

PlayFXAnimID:
	ld a, e
	ld [wFXAnimIDLo], a
	ld a, d
	ld [wFXAnimIDHi], a
	call Delay2
	jpba PlayBattleAnim

AnimateCurrentMoveEitherSide:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	push hl
	push de
	push bc
	ld a, [wBattleAnimParam]
	push af
	call BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a
	call PlayDamageAnim
	call BattleCommand_RaiseSub
	pop bc
	pop de
	pop hl
	ret

AnimateCurrentMove:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	push hl
	push de
	push bc
	ld a, [wBattleAnimParam]
	push af
	call BattleCommand_LowerSub
	pop af
	ld [wBattleAnimParam], a
	call LoadMoveAnim
	call BattleCommand_RaiseSub
	pop bc
	pop de
	pop hl
	ret

PlayDamageAnim:
	xor a
	ld [wFXAnimIDHi], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	ret z

	ld [wFXAnimIDLo], a

	ldh a, [hBattleTurn]
	and a
	ld a, BATTLEANIM_ENEMY_DAMAGE
	jr z, .player
	ld a, BATTLEANIM_PLAYER_DAMAGE

.player
	ld [wNumHits], a

	jr PlayUserBattleAnim

LoadMoveAnim:
	xor a
	ld [wNumHits], a
	ld [wFXAnimIDHi], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	ret z
LoadAnim:
	ld [wFXAnimIDLo], a
PlayUserBattleAnim:
	push hl
	push de
	push bc
	callba PlayBattleAnim
	pop bc
	pop de
	pop hl
	ret

PlayOpponentBattleAnim:
	ld a, e
	ld [wFXAnimIDLo], a
	ld a, d
	ld [wFXAnimIDHi], a
	xor a
	ld [wNumHits], a

	push hl
	push de
	push bc
	call SwitchTurn

	callba PlayBattleAnim

	call SwitchTurn
	pop bc
	pop de
	pop hl
	ret

AnimateFailedMove:
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	jp BattleCommand_RaiseSub

PlaySubstituteAnim:
	ld a, SUBSTITUTE
	ld [wFXAnimIDLo], a
	jr PlayUserBattleAnim
