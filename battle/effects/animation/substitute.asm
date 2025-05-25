BattleCommand_LowerSub:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret z

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CHARGED, a
	jr nz, .already_charged

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld hl, .charging_moves
	call IsInSingularArray
	jr c, .charge_turn

.already_charged
	call .Rampage
	jr z, .charge_turn

	call CheckUserIsCharging
	ret nz

.charge_turn
	call CheckBattleScene
	jr c, .mimic_anims

	xor a
	ld [wNumHits], a
	ld [wFXAnimIDHi], a
	inc a
	ld [wBattleAnimParam], a
	ld a, SUBSTITUTE
	jp LoadAnim

.mimic_anims
	call BattleCommand_LowerSubNoAnim
	jp BattleCommand_MoveDelay

.Rampage
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ROLLOUT
	jr z, .rollout_rampage
	cp EFFECT_RAMPAGE
	jr z, .rollout_rampage

	ld a, 1
	and a
	ret

.rollout_rampage
	ld a, [wSomeoneIsRampaging]
	and a
	ld a, 0
	ld [wSomeoneIsRampaging], a
	ret

.charging_moves
	db EFFECT_RAZOR_WIND
	db EFFECT_SKY_ATTACK
	db EFFECT_SOLARBEAM
	db EFFECT_FLY
	db -1

BattleCommand_LowerSubNoAnim:
	ld hl, DropPlayerSub
	ldh a, [hBattleTurn]
	and a
	jr z, .playerTurn
	ld hl, DropEnemySub
.playerTurn
	xor a
	ldh [hBGMapMode], a
	ld a, BANK(BattleCore)
	call FarCall_hl
	jp ApplyTilemapInVBlank

BattleCommand_RaiseSub:
; raisesub

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret z

	call CheckBattleScene
	jp c, BattleCommand_RaiseSubNoAnim

	xor a
	ld [wNumHits], a
	ld [wFXAnimIDHi], a
	ld a, 2
	ld [wBattleAnimParam], a
	ld a, SUBSTITUTE
	jp LoadAnim

AppearUserRaiseSub:
	call BattleCommand_RaiseSubNoAnim
	jpba AppearUser

AppearUserLowerSub:
	call BattleCommand_LowerSubNoAnim
	jpba AppearUser
