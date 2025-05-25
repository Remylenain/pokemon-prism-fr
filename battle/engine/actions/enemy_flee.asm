TryEnemyFlee:
	ld a, [wBattleMode]
	dec a
	and a
	ret nz

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	ret nz

	ld a, [wEnemySubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	ret nz

	ld a, [wEnemyWrapCount]
	and a
	ret nz

	ld a, [wEnemyMonStatus]
	and 1 << FRZ | SLP
	ret nz

	call CheckPlayerAbilityPreventsEscaping
	ccf
	ret nc

	CheckEngine ENGINE_PARK_MINIGAME
	jr nz, .check_park_minigame_flee

	ld a, [wTempEnemyMonSpecies]
	ld hl, .flee_mon_list
	ld e, 2
	call IsInArray
	ret nc

	inc hl
	call RandomPercentage ; no need for BattleRandom since this is a wild battle
	cp [hl]
	ret ;carry if the mon flees

.check_park_minigame_flee
	ld a, [wLastBallShakes]
	sub -5
	ret nc ; if the subtraction doesn't carry (i.e., the addition would have), [wLastBallShakes] wasn't positive to begin with, meaning no ball was used
	ld hl, hMultiplier
	ld [hld], a
	ld a, [wEnemyMonCatchRate]
	ld [hld], a
	ld [hl], 3
	push hl
	predef Multiply
	pop hl
	call Random ; no need for BattleRandom since this is a wild battle
	cp [hl]
	ret nz
	inc hl
	call Random
	cp [hl]
	ret

.flee_mon_list
	;  species,     %
	db MAGNEMITE,   5
	db TANGELA,     5
	db -1

EnemyTriesToFlee:
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	ld a, [wBattleAction]
	cp BATTLEACTION_FORFEIT
	jr z, .forfeit

.not_linked
	and a
	ret

.forfeit
	call WildFled_EnemyFled_LinkBattleCanceled
	scf
	ret

WildFled_EnemyFled_LinkBattleCanceled:
	call Call_LoadTempTileMapToTileMap
	ld a, [wBattleResult]
	and $c0
	add a, 2
	ld [wBattleResult], a
	ld a, [wLinkMode]
	and a
	ld hl, BattleText_WildFled
	jr z, .print_text

	ld a, [wBattleResult]
	and $c0
	ld [wBattleResult], a
	ld hl, BattleText_EnemyFled

.print_text
	call StdBattleTextBox
	call StopDangerSound

	ld de, SFX_RUN
	call PlaySFX

	call SetPlayerTurn
	ld a, 1
	ld [wBattleEnded], a
	ret
