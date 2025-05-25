BattleCommand_EffectChance:
	xor a
	ld [wEffectFailed], a
	call CheckSubstituteOpp
	jr nz, .failed
	call GetTargetAbility
	cp ABILITY_SHIELD_DUST
	jr z, .failed

	push bc
	push hl
	ld hl, wPlayerMoveStruct + MOVE_CHANCE
	ldh a, [hBattleTurn]
	and a
	jr z, .got_move_chance
	ld hl, wEnemyMoveStruct + MOVE_CHANCE
.got_move_chance
	ld b, [hl]
	pop hl
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_SERENE_GRACE
	jr nz, .not_serene_grace
	sla b
	jr c, .skip_sample
.not_serene_grace
	call BattleRandomPercentage
	cp b
.skip_sample
	pop bc
	ret c

.failed
	ld a, 1
	ld [wEffectFailed], a
	and a
	ret
