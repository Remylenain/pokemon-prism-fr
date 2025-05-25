BattleCommand_HitTarget:
	call BattleCommand_LowerSub
	call BattleCommand_HitTargetNoSub
	jp BattleCommand_RaiseSub

BattleCommand_HitTargetNoSub:
	ld a, [wAttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	call SturdyCheck

	ldh a, [hBattleTurn]
	and a
	ld de, wPlayerRolloutCount
	ld a, BATTLEANIM_ENEMY_DAMAGE
	jr z, .got_rollout_count
	ld de, wEnemyRolloutCount
	ld a, BATTLEANIM_PLAYER_DAMAGE

.got_rollout_count
	ld [wNumHits], a
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_MULTI_HIT
	jr z, .multihit
	cp EFFECT_CONVERSION
	jr z, .conversion
	cp EFFECT_DOUBLE_HIT
	jr z, .doublehit
	cp EFFECT_TWINEEDLE
	jr z, .twineedle
	xor a
	ld [wBattleAnimParam], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	call PlayFXAnimID

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .fly_dig
	cp DIG
	ret nz
.fly_dig
	; clear sprite
	jp AppearUserLowerSub

.multihit
.conversion
.doublehit
.twineedle
	ld a, [wBattleAnimParam]
	rra
	sbc a
	inc a
	ld [wBattleAnimParam], a
	ld a, [de]
	dec a
	push af
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	pop af
	jr z, .no_clearing_hits
	xor a
	ld [wNumHits], a
.no_clearing_hits
	jp PlayFXAnimID
