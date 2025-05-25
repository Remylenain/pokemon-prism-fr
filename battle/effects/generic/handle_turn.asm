BattleCommand_DoTurn:
	ldh a, [hBattleTurn]
	ld [wBattleTurnTemp], a
	and a
	ld hl, wPlayerTurnsTaken
	jr z, .got_turns_taken
	ld hl, wEnemyTurnsTaken
.got_turns_taken
	; Don't place this on top, we need to set wBattleTurnTemp
	call CheckUserIsCharging
	ret nz

	; If we've gotten this far, this counts as a turn.
	inc [hl]
	jr nz, .no_overflow
	dec [hl]
.no_overflow
	call BattleConsumePP
	ret nz

	; Out of PP
	call BattleCommand_MoveDelay

	; Different message if continuous
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld hl, .continuous_moves
	call IsInSingularArray

	ld hl, HasNoPPLeftText
	jr nc, .print
	ld hl, NoPPLeftText
.print
	call StdBattleTextBox
	jp EndMoveEffect

.continuous_moves
	db EFFECT_RAZOR_WIND
	db EFFECT_SKY_ATTACK
	db EFFECT_SOLARBEAM
	db EFFECT_FLY
	db EFFECT_ROLLOUT
	db EFFECT_RAMPAGE
	db $ff

BattleCommand_Pressure:
	; Ignores Mold Breaker
	call GetTargetAbility
	cp ABILITY_PRESSURE
	ret nz
	; fallthrough
BattleConsumePP:
; Also used by DoTurn: return z if user has no PP left
	call CheckUserIsCharging
	ret nz

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp STRUGGLE
	jr z, .end

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_IN_LOOP | 1 << SUBSTATUS_RAMPAGE
	ret nz

	ldh a, [hBattleTurn]
	and a
	ld a, [wCurBattleMon]
	ld bc, wCurMoveNum
	ld de, wBattleMonPP
	ld hl, wPartyMon1PP
	jr z, .set_party_pp
	ld a, [wBattleMode]
	dec a
	ld a, [wCurOTMon]
	ld bc, wCurEnemyMoveNum
	ld de, wEnemyMonPP
	ld hl, wWildMonPP
	jr z, .pp_vars_ok
	ld hl, wOTPartyMon1PP
.set_party_pp
	push bc
	call GetPartyLocation
	pop bc
.pp_vars_ok
	ld a, [bc]
	ld c, a
	ld b, 0
	add hl, bc

	; Swap de and hl
	push de
	ld d, h
	ld e, l
	pop hl

	add hl, bc
	ld a, [hl]
	and $3f
	ret z
	dec [hl]

	; Don't mess with PP in party struct if transformed
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	and SUBSTATUS_TRANSFORMED
	ret nz
	ld a, [hl]
	ld [de], a
.end
	inc a ;a != $ff before this line, so this will clear zero
	ret

CheckTurn:
BattleCommand_CheckTurn:
; Repurposed as hardcoded turn handling. Useless as a command.

; Move $ff immediately ends the turn (Used if Pursuit procs during switch).
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	inc a
	jp z, EndTurn

	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld [wBattleAnimParam], a
	ld [wAlreadyDisobeyed], a
	ld [wAlreadyFailed], a
	ld [wSomeoneIsRampaging], a

	ld a, 10 ; 1.0
	ld [wTypeModifier], a

	ldh a, [hBattleTurn]
	and a
	jp nz, CheckEnemyTurn
	; fallthrough

CheckPlayerTurn:
	ld hl, wPlayerSubStatus4
	bit SUBSTATUS_RECHARGE, [hl]
	jr z, .no_recharge

	res SUBSTATUS_RECHARGE, [hl]
	ld hl, MustRechargeText
	jp .show_text_and_cant_move

.no_recharge
	ld hl, wBattleMonStatus
	ld a, [hl]
	and SLP
	jr z, .not_asleep

	dec a
	ld [hl], a
	and SLP
	jr z, .woke_up
	ld a, [wPlayerAbility]
	cp ABILITY_EARLY_BIRD
	jr nz, .skip_early_bird
	dec [hl]
	ld a, [hl]
	and SLP
	ld hl, WokeUpWithEarlyBirdText
	jr z, .woke_up_early_bird
.skip_early_bird

	xor a
	ld [wNumHits], a
	ld de, ANIM_SLP
	call PlayFXAnimIDIfNotSemiInvulnerable
	jr .fast_asleep

.woke_up
	ld hl, WokeUpText
.woke_up_early_bird
	call StdBattleTextBox
	call CantMove
	call UpdateBattleMonInParty
	callba UpdatePlayerHUD
	ld a, 1
	ldh [hBGMapMode], a
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	jr .not_asleep

.fast_asleep
	ld hl, FastAsleepText
	call StdBattleTextBox

	; Snore and Sleep Talk bypass sleep.
	ld a, [wCurPlayerMove]
	cp SLEEP_TALK
	jp nz, .cant_move

.not_asleep
	ld hl, wBattleMonStatus
	bit FRZ, [hl]
	jr z, .not_frozen

	; Flame Wheel and Sacred Fire thaw the user.
	ld a, [wCurPlayerMove]
	cp FLAME_WHEEL
	jr z, .thaw
	cp FLARE_BLITZ
	jr z, .thaw
	cp SACRED_FIRE
	jr z, .thaw

	; 20% to thaw
	ld a, 5
	call BattleRandomRange
	and a
	jr z, .thaw

	ld hl, FrozenSolidText
	jp .show_text_and_cant_move

.thaw
	call BattleCommand_Defrost
.not_frozen
	ld hl, wPlayerSubStatus3
	bit SUBSTATUS_FLINCHED, [hl]
	jr z, .not_flinched

	res SUBSTATUS_FLINCHED, [hl]
	call GetPlayerAbility
	cp ABILITY_INNER_FOCUS
	ld hl, FlinchedText
	jr z, .inner_focus
	push af
	call StdBattleTextBox

	call CantMove
	pop af
	cp ABILITY_STEADFAST
	jr nz, .not_steadfast
	ld [wMoveIsAnAbility], a
	call DoSpeedUpCommandWithStatUpMessage
.not_steadfast
	jp EndTurn

.inner_focus
	ld hl, InnerFocusText
	call StdBattleTextBox
.not_flinched

	ld hl, wPlayerDisableCount
	ld a, [hl]
	and a
	jr z, .not_disabled

	dec a
	ld [hl], a
	and $f
	jr nz, .not_disabled

	ld [hl], a
	ld [wDisabledMove], a
	ld hl, DisabledNoMoreText
	call StdBattleTextBox

.not_disabled
	ld a, [wPlayerSubStatus3]
	add a
	jr nc, .not_confused
	ld hl, wPlayerConfuseCount
	dec [hl]
	jr nz, .confused

	ld hl, wPlayerSubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	call StdBattleTextBox
	jr .not_confused

.confused
	ld hl, IsConfusedText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 33% chance of hitting itself
	ld a, 3
	call BattleRandomRange
	and a
	jr nz, .not_confused

	; clear confusion-dependent substatus
	ld hl, wPlayerSubStatus3
	ld a, [hl]
	and 1 << SUBSTATUS_CONFUSED
	ld [hl], a

	call HitConfusion
.cant_move
	call CantMove
	jp EndTurn

.not_confused
	ld a, [wPlayerSubStatus1]
	add a ; bit SUBSTATUS_ATTRACT
	jr nc, .not_infatuated

	ld hl, InLoveWithText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_LOVE
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 50% chance of infatuation
	call BattleRandom
	add a, a
	jr nc, .not_infatuated

	ld hl, InfatuationText
.show_text_and_cant_move
	call StdBattleTextBox
	jr .cant_move

.not_infatuated
	; We can't disable a move that doesn't exist.
	ld a, [wDisabledMove]
	and a
	jr z, .no_disabled_move

	; Are we using the disabled move?
	ld hl, wCurPlayerMove
	cp [hl]
	jr nz, .no_disabled_move

	call MoveDisabled
	jr .cant_move

.no_disabled_move
	ld hl, wBattleMonStatus
	bit PAR, [hl]
	jr z, .not_paralyzed

	; 25% chance to be fully paralyzed
	call BattleRandom
	and $c0
	jr nz, .not_paralyzed

	ld hl, FullyParalyzedText
	jr .show_text_and_cant_move

.not_paralyzed
	ld hl, wPlayerSubStatus2
	bit SUBSTATUS_GUARDING, [hl]
	ret z
	ld hl, IsGuardingText
	jr .show_text_and_cant_move

CheckEnemyTurn:
	ld hl, wEnemySubStatus4
	bit SUBSTATUS_RECHARGE, [hl]
	jr z, .no_recharge

	res SUBSTATUS_RECHARGE, [hl]
	ld hl, MustRechargeText
	jr .show_text_and_cant_move

.no_recharge
	ld hl, wEnemyMonStatus
	ld a, [hl]
	and SLP
	jr z, .not_asleep

	dec a
	ld [hl], a
	and a
	jr z, .woke_up
	ld a, [wEnemyAbility]
	cp ABILITY_EARLY_BIRD
	jr nz, .skip_early_bird
	dec [hl]
	ld a, [hl]
	and SLP
	ld hl, WokeUpWithEarlyBirdText
	jr z, .woke_up_early_bird
.skip_early_bird

	ld hl, FastAsleepText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_SLP
	call PlayFXAnimIDIfNotSemiInvulnerable
	jr .fast_asleep

.woke_up
	ld hl, WokeUpText
.woke_up_early_bird
	call StdBattleTextBox
	call CantMove
	call UpdateEnemyMonInParty
	callba UpdateEnemyHUD
	ld a, 1
	ldh [hBGMapMode], a
	ld hl, wEnemySubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	jr .not_asleep

.fast_asleep
	; Snore and Sleep Talk bypass sleep.
	ld a, [wCurEnemyMove]
	cp SLEEP_TALK
	jr nz, .cant_move

.not_asleep
	ld hl, wEnemyMonStatus
	bit FRZ, [hl]
	jr z, .not_frozen
	ld a, [wCurEnemyMove]
	cp FLAME_WHEEL
	jr z, .thaw
	cp FLARE_BLITZ
	jr z, .thaw
	cp SACRED_FIRE
	jr z, .thaw

	; 20% to thaw
	ld a, 5
	call BattleRandomRange
	and a
	jr z, .thaw

	ld hl, FrozenSolidText
.show_text_and_cant_move
	call StdBattleTextBox
.cant_move
	call CantMove
	jp EndTurn

.thaw
	call BattleCommand_Defrost
.not_frozen
	ld hl, wEnemySubStatus3
	bit SUBSTATUS_FLINCHED, [hl]
	jr z, .not_flinched

	res SUBSTATUS_FLINCHED, [hl]
	call GetEnemyAbility
	cp ABILITY_INNER_FOCUS
	ld hl, FlinchedText
	jr z, .inner_focus

	push af
	ld hl, FlinchedText
	call StdBattleTextBox

	call CantMove
	pop af
	cp ABILITY_STEADFAST
	call z, BattleCommand_SpeedUp
	jp EndTurn

.inner_focus
	ld hl, InnerFocusText
	call StdBattleTextBox
.not_flinched

	ld hl, wEnemyDisableCount
	ld a, [hl]
	and a
	jr z, .not_disabled

	dec a
	ld [hl], a
	and $f
	jr nz, .not_disabled

	ld [hl], a
	ld [wEnemyDisabledMove], a

	ld hl, DisabledNoMoreText
	call StdBattleTextBox

.not_disabled
	ld a, [wEnemySubStatus3]
	add a ; bit SUBSTATUS_CONFUSED
	jr nc, .not_confused

	ld hl, wEnemyConfuseCount
	dec [hl]
	jr nz, .confused

	ld hl, wEnemySubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	call StdBattleTextBox
	jr .not_confused

.confused
	ld hl, IsConfusedText
	call StdBattleTextBox

	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 33% chance of hitting itself
	ld a, 3
	call BattleRandomRange
	and a
	jr nz, .not_confused

	; clear status bits other than confusion
	ld a, 1 << SUBSTATUS_CONFUSED
	ld [wEnemySubStatus3], a

	ld hl, HurtItselfText
	call StdBattleTextBox
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
	ld a, [wEnemySubStatus3]
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, PlayFXAnimID

	ld c, 1
	call EnemyHurtItself
	call BattleCommand_RaiseSub
	jp .cant_move

.not_confused
	ld a, [wEnemySubStatus1]
	add a ; bit SUBSTATUS_ATTRACT
	jr nc, .not_infatuated

	ld hl, InLoveWithText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_LOVE
	call PlayFXAnimIDIfNotSemiInvulnerable

	; 50% chance of infatuation
	call BattleRandom
	add a, a
	jr nc, .not_infatuated

	ld hl, InfatuationText
	jp .show_text_and_cant_move

.not_infatuated
	; We can't disable a move that doesn't exist.
	ld a, [wEnemyDisabledMove]
	and a
	jr z, .no_disabled_move

	; Are we using the disabled move?
	ld hl, wCurEnemyMove
	cp [hl]
	jr nz, .no_disabled_move

	call MoveDisabled
	jp .cant_move

.no_disabled_move
	ld hl, wEnemyMonStatus
	bit PAR, [hl]
	ret z

	; 25% chance to be fully paralyzed
	call BattleRandom
	and $c0
	ret nz

	ld hl, FullyParalyzedText
	jp .show_text_and_cant_move

MoveDisabled:
	; Make sure any charged moves fail
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_CHARGED, [hl]

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName

	ld hl, DisabledMoveText
	jp StdBattleTextBox

CantMove:
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_ROLLOUT, [hl]

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	ld a, [hl]
	and ~(1 << SUBSTATUS_RAMPAGE + 1 << SUBSTATUS_CHARGED)
	ld [hl], a

	call ResetFuryCutterCount

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .fly_dig

	cp DIG
	ret nz

.fly_dig
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	jp AppearUserRaiseSub

OpponentCantMove:
	call SwitchTurn
	call CantMove
	jp SwitchTurn

EndTurn:
	ld a, 1
	ld [wTurnEnded], a
	jp ResetDamage
