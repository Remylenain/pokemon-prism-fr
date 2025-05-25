HandleEndTurnEffects:
	ld a, [wBattleHasJustStarted]
	and a
	ret nz
	call HandleFaint
	ret c
	call EndTurn_ResidualDamage
	call HandleFaint
	ret c
	call EndTurn_FutureSight
	call HandleFaint
	ret c
	call HandleWeather
	call HandleFaint
	ret c
	call EndTurn_Wrap
	call HandleFaint
	ret c
	call EndTurn_PerishSong
	call HandleFaint
	ret c

	call EndTurn_Leftovers
	call EndTurn_LeppaBerry
	call EndTurn_Safeguard
	call EndTurn_Screens
	call EndTurn_HealingItems
	call EndTurn_Abilities
	call UpdateBattleMonInParty
	call UpdateEnemyMonInParty
	call LoadTileMapToTempTileMap
	jp EndTurn_Encore

HandleFaint:
	call SetPlayerTurn
	call CheckSpeed
	jr nz, .enemy_first

	call HasPlayerFainted
	jr nz, .player_not_fainted
	call HandlePlayerMonFaint
	ld a, [wBattleEnded]
	and a
	jr nz, .battle_over

.player_not_fainted
	call HasEnemyFainted ;always clears carry
	ret nz
	call HandleEnemyMonFaint
.do_check
	ld a, [wBattleEnded]
	and a
	ret z
.battle_over
	scf
	ret

.enemy_first
	call HasEnemyFainted
	jr nz, .enemy_not_fainted
	call HandleEnemyMonFaint
	ld a, [wBattleEnded]
	and a
	jr nz, .battle_over

.enemy_not_fainted
	call HasPlayerFainted ;always clears carry
	ret nz
	call HandlePlayerMonFaint
	jr .do_check
