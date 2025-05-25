EndTurn_ResidualDamage:
; Return z if the user fainted before
; or as a result of residual damage.
; For Sandstorm damage, see HandleWeather.
	call SetFastestTurn
	call .do_it
	call SwitchTurn

.do_it
	call HasUserFainted
	ret z

	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_SHED_SKIN
	jr nz, .skip_shed_skin

	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	and a
	jp z, .did_psn_brn

	callba BattleRandomPercentage
	cp 30
	jr nc, .skip_shed_skin

	ld [hl], 0
	call UpdateUserInParty
	call UpdateBattleHUDs
	ld hl, ShedSkinText
	call StdBattleTextBox
	jp .did_psn_brn

.skip_shed_skin
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and 1 << PSN | 1 << BRN
	jp z, .did_psn_brn

	ld hl, HurtByPoisonText
	ld de, ANIM_PSN
	and 1 << BRN
	jr nz, .check_brn
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_POISON_HEAL
	jr nz, .got_anim
	ld hl, PoisonHealText
	ld de, NO_MOVE
	jr .got_anim

.check_brn
	ld hl, HurtByBurnText
	ld de, ANIM_BRN
.got_anim

	push de
	call StdBattleTextBox
	pop de

	xor a
	ld [wNumHits], a
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetEighthMaxHP
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	bit BRN, a
	jr nz, .burn
	ld de, wPlayerToxicCount
	ldh a, [hBattleTurn]
	and a
	jr z, .check_toxic
	ld de, wEnemyToxicCount
.check_toxic

	ld a, BATTLE_VARS_SEMISTATUS
	call GetBattleVar
	bit SEMISTATUS_TOXIC, a
	jr z, .psn_check_poison_heal
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_POISON_HEAL
	push af
	ld a, [de]
	inc a
	ld [de], a
	pop af
	jr z, .heal

	srl b
	rr c
	ld a, b
	or c
	jr nz, .okay_toxic
	inc c
.okay_toxic
	ld a, [de]
	ld hl, 0
	rst AddNTimes
	ld b, h
	ld c, l
	jr .deal_damage

.psn_check_poison_heal
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_POISON_HEAL
	jr z, .heal
	jr .deal_damage

.burn
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_HEATPROOF
	jr nz, .deal_damage
	srl b
	rr c
	ld a, b
	or c
	jr nz, .deal_damage
	inc c
.deal_damage
	call SubtractHPFromUser
	jr .did_psn_brn

.heal
	call RestoreUserHP
.did_psn_brn
	call HasUserFainted
	jp z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr z, .not_seeded

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld de, ANIM_SAP
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn

	call GetEighthMaxHP
	call SubtractHPFromUser
	ld a, 1
	ldh [hBGMapMode], a
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_LIQUID_OOZE
	ld de, RestoreOpponentHP
	ld hl, LeechSeedSapsText
	jr nz, .print
	ld de, SubtractHPFromTarget
	ld hl, LiquidOozeHurtsText
.print
	push hl
	call _de_
	pop hl
	call StdBattleTextBox
.not_seeded

	call HasUserFainted
	jr z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	bit SUBSTATUS_NIGHTMARE, [hl]
	jr z, .not_nightmare
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_NIGHTMARE
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetQuarterMaxHP
	call SubtractHPFromUser
	ld hl, HasANightmareText
	call StdBattleTextBox
.not_nightmare

	call HasUserFainted
	jr z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	bit SUBSTATUS_CURSE, [hl]
	jr z, .not_cursed

	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_NIGHTMARE
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetQuarterMaxHP
	call SubtractHPFromUser
	ld hl, HurtByCurseText
	call StdBattleTextBox

.not_cursed
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .check_fainted
	ld hl, wEnemyMonHP

.check_fainted
	ld a, [hli]
	or [hl]
	ret nz

.fainted
	call RefreshBattleHuds
	ld c, 20
	call DelayFrames
	xor a
	ret
