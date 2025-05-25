HitConfusion:
	ld hl, HurtItselfText
	call StdBattleTextBox

	xor a
	ld [wCriticalHitOrOHKO], a

	call HitSelfInConfusion
	call BattleCommand_DamageCalc
	ld a, 100
	ld [wCurDamageItemModifier], a
	call SetDamageDirtyFlag
	call BattleCommand_LowerSub

	xor a
	ld [wNumHits], a

	; Flicker the monster pic unless flying or underground.
	ld de, ANIM_HIT_CONFUSION
	ld a, [wPlayerSubStatus3]
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, PlayFXAnimID

	callba UpdatePlayerHUD
	ld a, 1
	ldh [hBGMapMode], a
	ld c, a
	call PlayerHurtItself
	jp BattleCommand_RaiseSub

HitSelfInConfusion:
	call ResetDamage
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wBattleMonLevel]
	push af
	ld a, [wPlayerScreens]
	ld hl, wBattleMonAttack
	jr .go
.enemy
	ld a, [wEnemyMonLevel]
	push af
	ld a, [wEnemyScreens]
	ld hl, wEnemyMonAttack
.go
	bit SCREENS_REFLECT, a
	; bc = attack, de = defense
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	jr z, .no_screen
	sla e
	rl d
.no_screen
	ld hl, wCurDamageMovePowerNumerator
	xor a
	ld [hli], a
	ld [hl], 40
	inc hl ;wCurDamageMovePowerDenominator
	inc a
	ld [hli], a
	; hl = wCurDamageLevel
	pop af
	ld [hl], a
	ld hl, wCurDamageAttack
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	; hl = wCurDamageDefense
	ld a, d
	ld [hli], a
	ld [hl], e
	call SetDamageDirtyFlag
	call LightBallBoost
	call PhysicalAbilityModifiers
	call SwitchTurn
	call CheckEviolite
	call SwitchTurn
	jp DittoMetalPowder
