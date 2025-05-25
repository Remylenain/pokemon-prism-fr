EndTurn_Abilities:
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	call GetUserAbility_IgnoreMoldBreaker
	and a
	ret z
	ld [wMoveIsAnAbility], a
	ld hl, .abilities
	ld e, 4
	call IsInArray
	call c, FarPointerCall_AfterIsInArray
	xor a
	ld [wMoveIsAnAbility], a
	ret

.abilities
	db ABILITY_MOODY
	dba BattleCommand_Moody
	db ABILITY_SPEED_BOOST
	dba DoSpeedUpCommandWithStatUpMessage
	db -1
