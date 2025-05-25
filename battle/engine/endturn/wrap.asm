EndTurn_Wrap:
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove
	ldh a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove

.got_addrs
	ld a, [hl]
	and a
	ret z

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz

	ld a, [de]
	ld [wd265], a
	ld [wFXAnimIDLo], a
	call GetMoveName
	dec [hl]
	jr z, .release_from_bounds

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	jr nz, .skip_anim

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [wFXAnimIDHi], a
	predef PlayBattleAnim
	call SwitchTurn

.skip_anim
	call GetEighthMaxHP
	call SubtractHPFromUser
	ld hl, BattleText_UsersHurtByStringBuffer1
	jr .print_text

.release_from_bounds
	ld hl, BattleText_UserWasReleasedFromStringBuffer1

.print_text
	jp StdBattleTextBox
