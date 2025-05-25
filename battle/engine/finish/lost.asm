LostBattle:
	ld a, 1
	ld [wBattleEnded], a

	ld a, [wInBattleTowerBattle]
	rra
	jr c, .battle_tower

	ld a, [wBattleType]
	cp BATTLETYPE_CANLOSE
	jr nz, .not_canlose

	call .remove_enemy_from_screen

	ld a, [wMonStatusFlags]
	rra
	jp nc, PrintWinLossText
	ret

.battle_tower
	call .remove_enemy_from_screen

	call EmptyBattleTextBox
	ld c, 2
	callba BattleTowerText
	call WaitPressAorB_BlinkCursor
	call ClearTileMap
	jp ClearBGPalettes

.not_canlose
	ld a, [wLinkMode]
	and a
	jr nz, .lost_link_battle

; Greyscale
	ld b, SCGB_BATTLE_GRAYSCALE
	predef GetSGBLayout
	call SetPalettes
	scf
	ret

.lost_link_battle
	call UpdateEnemyMonInParty
	call CheckEnemyTrainerDefeated
	jr nz, .not_tied
	ld hl, TiedAgainstText
	ld a, [wBattleResult]
	and $c0
	add 2
	ld [wBattleResult], a
	jr .text

.not_tied
	ld hl, LostAgainstText
.text
	call StdBattleTextBox
	scf
	ret

.remove_enemy_from_screen
	hlcoord 0, 0
	lb bc, 8, 21
	call ClearBox
	call BattleWinSlideInEnemyTrainerFrontpic
	ld c, 40
	jp DelayFrames
