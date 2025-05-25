BattleCommand_DamageVariation:
; Modify the damage spread between 85% and 100%.
; There were a lot of comments here explaining the various details (and inaccuracies) of this process, but they no longer apply.

	call BattleRandom
	and 15
	ld [wCurDamageRandomVariance], a ;variance is stored complemented -- a value of 3 indicates taking 3% away (so the attack does 97% damage)
	call SetDamageDirtyFlag

; Guarding takes the final damage, which happens to be the result of damagevariation
; therefore put the guard check here
; update: this is no longer relevant (exact calculations imply that factors are commutative), but there's no point in moving this elsewhere
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_GUARDING, a
	ret z
	ld a, [wCriticalHitOrOHKO]
	and a
	ret nz
	ld hl, wCurDamageShiftCount
	dec [hl]
	ret ;no need to call SetDamageDirtyFlag again

SturdyCheck:
	call GetTargetAbility
	cp ABILITY_STURDY
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	inc hl
	inc hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	ret nz
	ld a, [hl]
	cp c
	ret nz

	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	set SUBSTATUS_STURDY, [hl]
	ret

BattleCommand_FailureText:
; If the move missed or failed, load the appropriate text, and end the effects of multi-turn or multi-hit moves.
	ld a, [wAttackMissed]
	and a
	ret z

	call GetFailureResultText
	call .EndMultiturnMoves
	call .CheckAbilityImmunities
	jp EndMoveEffect

.EndMultiturnMoves
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr

	cp FLY
	jr z, .fly_dig
	cp DIG
	jr z, .fly_dig

; Move effect:
	inc hl
	ld a, [hl]

	cp EFFECT_MULTI_HIT
	jr z, .multihit
	cp EFFECT_DOUBLE_HIT
	jr z, .multihit
	cp EFFECT_TWINEEDLE
	ret nz
.multihit
	jp BattleCommand_RaiseSub

.fly_dig
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	jp AppearUserRaiseSub

.CheckAbilityImmunities
	; Protect overrides all of these
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	ret nz
	call GetTargetAbility
	cp ABILITY_FLASH_FIRE
	jr z, .FlashFire
	cp ABILITY_WATER_ABSORB
	jr z, .WaterAbsorb
	cp ABILITY_MOTOR_DRIVE
	jr z, .motor_drive_lightningrod
	cp ABILITY_VOLT_ABSORB
	jr z, .motor_drive_lightningrod
	cp ABILITY_LIGHTNINGROD
	ret nz
.motor_drive_lightningrod
; Last move was Electric
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp ELECTRIC
	ret nz
; Target is not Ground-type
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp CRYSTAL_BOLT
	jr z, .skip_ground_check
	ld hl, wBattleMonType
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_mon_types
	ld hl, wEnemyMonType
.got_mon_types
	ld a, GROUND
	cp [hl]
	jr z, .print_doesnt_affect_message
	inc hl
	cp [hl]
	jr z, .print_doesnt_affect_message
; Raise Special Attack (LR) or Speed (MD), or restore HP (VA)
.skip_ground_check
	call SwitchTurn
	call ResetMiss
	xor a
	ld [wEffectFailed], a
	ld a, b
	ld [wMoveIsAnAbility], a
	cp ABILITY_LIGHTNINGROD
	jr z, .lightningrod
	cp ABILITY_MOTOR_DRIVE
	jr z, .motor_drive
	; Volt Absorb
	call Ability_RestoreTargetHP
	jr .finish

.motor_drive
	call DoSpeedUpCommandWithStatUpMessage
	jr .finish

.lightningrod
	call BattleCommand_SpecialAttackUp
	call BattleCommand_StatUpMessage
.finish
	call SwitchTurn
	xor a
	ld [wMoveIsAnAbility], a
	ret

.FlashFire
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp FIRE
	ret nz
; Not already Flash-Fired
	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_FLASH_FIRE, [hl]
	ret nz
	set SUBSTATUS_FLASH_FIRE, [hl]
	ld hl, FlashFireText
.std_battle_text_box
	jp StdBattleTextBox

.WaterAbsorb
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp WATER
	ret nz
	call SwitchTurn
	ld a, b
	call Ability_RestoreTargetHP
	jp SwitchTurn

.print_doesnt_affect_message
	ld hl, DoesntAffectText
	jr .std_battle_text_box

Ability_RestoreTargetHP:
	ld [wd265], a
	call GetAbilityName
	callba GetQuarterMaxHP
	callba RestoreUserHP
	ld hl, AbilityRestoreHPText
	jp StdBattleTextBox

ShellBellCheck:
	call GetUserItem
	ld a, b
	cp HELD_SHELL_BELL
	ret nz

	call BattleCommand_MoveDelay

	call GetCurrentDamage
	ld hl, wCurDamage
	ld a, [hli]
	ld c, [hl]
	ld b, a
	or c
	ret z

	; Divide by 8
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c

	; Floor at 1
	ld a, b
	or c
	jr nz, .okay_restore
	inc c
.okay_restore
	callba RestoreUserHP
	ld hl, HealedWithShellBellText
	jp StdBattleTextBox

GetFailureResultText:
	ld hl, DoesntAffectText
	ld d, h
	ld e, l
	ld a, [wTypeModifier]
	add a, a
	jr nz, .not_immunity_based_failure
	ld a, [wFailedMessage]
	cp 4
	jr nz, .got_text
	call GetTargetAbility
	cp ABILITY_LEVITATE
	ld de, .GroundTypeString
	jr z, .got_reason
	cp ABILITY_SOUNDPROOF
	ret nz
	ld de, .SoundBasedString
.got_reason
	push af
	call CopyName1
	pop af
	ld [wd265], a
	call GetAbilityName
	ld hl, AbilityMakesMovesMissText
	ld d, h
	ld e, l
	jr .got_text
.not_immunity_based_failure
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_FUTURE_SIGHT
	ld hl, ButItFailedText
	ld de, ItFailedText
	jr z, .got_text
	ld hl, AttackMissedText
	ld de, AttackMissedText
	ld a, [wCriticalHitOrOHKO]
	cp $ff
	jr nz, .got_text
	ld hl, UnaffectedText
.got_text
	call FailText_CheckOpponentProtect
	xor a
	ld [wCriticalHitOrOHKO], a

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_JUMP_KICK
	ret nz

	ld a, [wTypeModifier]
	and $7f
	ret z

	callba GetHalfMaxHP
	ld hl, wCurDamageFixedValue
	ld [hl], b
	inc hl
	ld [hl], c
	ld hl, wCurDamageFlags
	set 7, [hl] ;fixed damage
	set 6, [hl] ;dirty
	ld hl, CrashedText
	call StdBattleTextBox
	ld a, 1
	ld [wBattleAnimParam], a
	call LoadMoveAnim
	ld c, 1
	ldh a, [hBattleTurn]
	and a
	jp nz, EnemyHurtItself
	jp PlayerHurtItself

.GroundTypeString:
	db "Ground-type@"

.SoundBasedString:
	db "sound-based@"

FailText_CheckOpponentProtect:
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	jr z, .not_protected
	ld h, d
	ld l, e
.not_protected
	jp StdBattleTextBox

BattleCommand_CriticalText:
; Prints the message for critical hits.

; If there is no message to be printed, wait 20 frames.
	ld a, [wCriticalHitOrOHKO]
	and a
	jr z, .wait
	ld hl, CriticalHitText
	call StdBattleTextBox
	xor a
	ld [wCriticalHitOrOHKO], a
.wait
	ld c, 20
	jp DelayFrames

BattleCommand_SuperEffectiveLoopText:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_IN_LOOP, a
	ret nz
	; fallthrough

BattleCommand_SuperEffectiveText:
	ld a, [wTypeModifier]
	and $7f
	cp 10 ; 1.0
	ret z
	ld hl, SuperEffectiveText
	jr nc, .print
	ld hl, NotVeryEffectiveText
.print
	jp StdBattleTextBox

BattleCommand_BuildOpponentRage:
; buildopponentrage
	ld a, [wAttackMissed]
	and a
	ret nz

	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_RAGE, a
	ret z

	call SwitchTurn
	call BattleCommand_AttackUp
	ld hl, RageBuildingText
	call StdBattleTextBox
	jp SwitchTurn

BattleCommand_LockOn:
	call CheckSubstituteOpp
	jr nz, .fail

	ld a, [wAttackMissed]
	and a
	jr nz, .fail

	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	set SUBSTATUS_LOCK_ON, [hl]
	call AnimateCurrentMove

	ld hl, TookAimText
	jp StdBattleTextBox

.fail
	call AnimateFailedMove
	jp PrintDidntAffect

BattleCommand_DestinyBond:
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	set SUBSTATUS_DESTINY_BOND, [hl]
	call AnimateCurrentMove
	ld hl, DestinyBondEffectText
	jp StdBattleTextBox

LeafGuardActive:
; returns z if opponent's leaf guard applies
	call GetTargetAbility
	cp ABILITY_LEAF_GUARD
	ret nz
	call GetWeatherAfterAbilities
	cp WEATHER_SUN
	ret

CheckMist:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ATTACK_DOWN
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN + 1
	jr c, .check_mist
	cp EFFECT_ATTACK_DOWN_2
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN_2 + 1
	jr c, .check_mist
	cp EFFECT_ATTACK_DOWN_HIT
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN_HIT + 1
	jr c, .check_mist
.dont_check_mist
	ld a, 1
	and a
	ret

.check_mist
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	and (1 << SUBSTATUS_MIST)
	cp (1 << SUBSTATUS_MIST)
	ret

DoSpeedUpCommandWithStatUpMessage:
	call BattleCommand_SpeedUp

; fallthrough
BattleCommand_StatUpMessage:
	ld a, [wFailedMessage]
	and a
	ret nz
	ld hl, DoStatUpMessage
	ld de, DoStatDownMessage
	jp ContraryCheckUser

DoStatUpMessage:
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, .stat
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .battle_text_box_if_zero
	cp ABILITY_MOODY
.battle_text_box_if_zero
	jp z, BattleTextBox
	call GetUserAbility_IgnoreMoldBreaker
	ld [wd265], a
	call GetAbilityName
	ld hl, AbilityStatUpText
	jp StdBattleTextBox
.stat
	text_far Battle_UsersStatText
	start_asm
	ld hl, .up
	ld a, [wLoweredStat]
	and $f0
	ret z
	swap a
	dec a
	ld hl, .wayup
	ret z
	ld hl, .drastically_up
	ret

.drastically_up
	text_jump Text_RoseDrastically

.wayup
	text_jump Battle_WayUpText

.up
	text_jump Battle_RoseText

BattleCommand_StatDownMessage:
	ld a, [wFailedMessage]
	and a
	ret nz
	ld hl, DoStatDownMessage
	ld de, DoStatUpMessage
	jp ContraryCheckOpp

DoStatDownMessage:
	call .Message
	ldh a, [hBattleTurn]
	ld hl, wBattleTurnTemp
	cp [hl]
	ret nz
	call GetTargetAbility_IgnoreMoldBreaker
	cp ABILITY_COMPETITIVE
	ret nz
	ld [wMoveIsAnAbility], a
	call SwitchTurn
	call BattleCommand_SpecialAttackUp2
	call BattleCommand_StatUpMessage
	xor a
	ld [wMoveIsAnAbility], a
	jp SwitchTurn

.Message
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, .stat
	ld a, [wMoveIsAnAbility]
	and a
	jr z, .battle_text_box_if_zero
	cp ABILITY_MOODY
.battle_text_box_if_zero
	jp z, BattleTextBox
	call GetUserAbility_IgnoreMoldBreaker
	ld [wd265], a
	call GetAbilityName
	ld hl, AbilityStatDropText
	jp StdBattleTextBox

.stat
	text_far Battle_TargetsStatText
	start_asm
	ld hl, .fell
	ld a, [wLoweredStat]
	and $f0
	ret z
	swap a
	dec a
	ld hl, .sharplyfell
	ret z
	ld hl, .severelyfell
	ret

.severelyfell
	text_jump Text_SeverelyFell

.sharplyfell
	text_jump Battle_HarshlyFellText
.fell
	text_jump Battle_FellText

BattleCommand_StatUpFailText:
	ld a, [wFailedMessage]
	and a
	ret z
	ld hl, DoStatUpFailText
	ld de, DoStatDownFailText
	jp ContraryCheckUser

DoStatUpFailText:
	call BattleCommand_MoveDelay
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	ld a, [wFailedMessage]
	dec a
	jp z, TryPrintButItFailed
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, WontRiseAnymoreText
	jp StdBattleTextBox

BattleCommand_StatDownFailText:
	ld a, [wFailedMessage]
	and a
	ret z ; 0
	ld hl, DoStatDownFailText
	ld de, DoStatUpFailText
	jp ContraryCheckOpp

DoStatDownFailText:
	call BattleCommand_MoveDelay
	ld a, [wFailedMessage]
	cp 4
	jr z, .HyperCutterCheck
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	ld a, [wFailedMessage]
	dec a
	jp z, TryPrintButItFailed ; 1
	dec a
	ld hl, ProtectedByMistText
	jp z, StdBattleTextBox ; 2
	dec a
	jr nz, .HyperCutterCheck ; 4
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, WontDropAnymoreText
	jp StdBattleTextBox

.HyperCutterCheck
	call GetTargetAbility
	ld [wd265], a
	call GetAbilityName
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, AbilityPreventsStatDownsText
	call StdBattleTextBox
	xor a
	ret

BattleCommand_TriStatusChance:
	call BattleCommand_EffectChance
.loop
	call BattleRandom
	and 3
	jr z, .loop
; jump
	dec a
	jr StatusFunctionJumptable

BattleCommand_FreezeBurnStatusChance:
	call BattleCommand_EffectChance
	call BattleRandom
	and 1
StatusFunctionJumptable:
	jumptable
	; Freeze Burn uses the first two; Tri Attack uses all of them
	dw BattleCommand_FreezeTarget ; freeze
	dw BattleCommand_BurnTarget ; burn
	dw BattleCommand_ParalyzeTarget ; paralyze

BattleCommand_Curl:
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	set SUBSTATUS_CURLED, [hl]
	ret

BattleCommand_CheckRampage:
	ld de, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld de, wEnemyRolloutCount
.player
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_RAMPAGE, [hl]
	ret z
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .continue_rampage

	res SUBSTATUS_RAMPAGE, [hl]
	call SwitchTurn
	call SafeCheckSafeguard
	push af
	call SwitchTurn
	pop af
	jr nz, .continue_rampage

	call GetUserAbility_IgnoreMoldBreaker ; preserves hl
	cp ABILITY_OWN_TEMPO
	jr z, .continue_rampage

; if mon is already confused, don't apply fatigue
	bit SUBSTATUS_CONFUSED, [hl]
	jr nz, .continue_rampage
	set SUBSTATUS_CONFUSED, [hl]
	call BattleRandom
	and 1
	add a, 2
	inc de ; ConfuseCount
	ld [de], a
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	set SUBSTATUS_FATIGUE, [hl]
.continue_rampage
	ld b, rampage_command
	jp SkipToBattleCommand

BattleCommand_FatigueText:
; if rampage led to confusion, print special text
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	bit SUBSTATUS_FATIGUE, [hl]
	ret z
	res SUBSTATUS_FATIGUE, [hl]
	ld hl, IsFatiguedText
	jp StdBattleTextBox

BattleCommand_Rampage:
; No rampage during Sleep Talk.
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	ret nz

	ld de, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wEnemyRolloutCount
.ok
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_RAMPAGE, [hl]
; Rampage for 1 or 2 more turns
	call BattleRandom
	and 1
	inc a
	ld [de], a
	ld a, 1
	ld [wSomeoneIsRampaging], a
	ret

BattleCommand_FlinchTarget:
	call CheckSubstituteOpp
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and 1 << FRZ | SLP
	ret nz

	call CheckOpponentWentFirst
	ret nz

	ld a, [wEffectFailed]
	and a
	ret nz
	; fallthrough

FlinchTarget:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	set SUBSTATUS_FLINCHED, [hl]
	jp EndRechargeOpp

CheckOpponentWentFirst:
; Returns a=0, z if user went first
; Returns a=1, nz if opponent went first
	push bc
	ld a, [wEnemyGoesFirst] ; 0 if player went first
	ld b, a
	ldh a, [hBattleTurn] ; 0 if it's the player's turn
	xor b ; 1 if opponent went first
	pop bc
	ret

BattleCommand_KingsRock:
	ld a, [wAttackMissed]
	and a
	ret nz

	call GetUserItem
	ld a, b
	cp HELD_FLINCH ; Only King's Rock has this effect
	ret nz

	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	ld d, h
	ld e, l
	call BattleRandomPercentage
	cp c
	ret nc
	call EndRechargeOpp
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	set SUBSTATUS_FLINCHED, [hl]
	ret

BattleCommand_Mist:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_MIST, [hl]
	jr nz, .already_mist
	set SUBSTATUS_MIST, [hl]
	call AnimateCurrentMove
	ld hl, MistText
	jp StdBattleTextBox

.already_mist
	call AnimateFailedMove
	jp PrintButItFailed

BattleCommand_FocusEnergy:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_FOCUS_ENERGY, [hl]
	jr nz, .already_pumped
	set SUBSTATUS_FOCUS_ENERGY, [hl]
	call AnimateCurrentMove
	ld hl, GettingPumpedText
	jp StdBattleTextBox

.already_pumped
	call AnimateFailedMove
	jp PrintButItFailed

CheckMoveTypeMatchesTarget:
; Compare move type to opponent type.
; Return z if matching the opponent type.

	push hl

	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wBattleMonType1
.ok

	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp [hl]
	jr z, .return
	inc hl
	cp [hl]
.return
	pop hl
	ret

BattleCommand_RechargeNextTurn:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_RECHARGE, [hl]
	ret

EndRechargeOpp:
	push hl
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	res SUBSTATUS_RECHARGE, [hl]
	pop hl
	ret

BattleCommand_Rage:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_RAGE, [hl]
	ret

BattleCommand_DoubleFlyingDamage:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_FLYING, a
	jr BattleCommand_DoubleDamageIfFlag_ContinueCheck

BattleCommand_DoubleUndergroundDamage:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_UNDERGROUND, a
BattleCommand_DoubleDamageIfFlag_ContinueCheck:
	ret z
	jp DoubleDamage

BattleCommand_DoubleMinimizeDamage:
	ld hl, wEnemyMinimized
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wPlayerMinimized
.ok
	ld a, [hl]
	and a
	jr BattleCommand_DoubleDamageIfFlag_ContinueCheck

BattleCommand_LeechSeed:
	ld a, [wEffectFailed]
	and a
	ret nz
	ld a, [wAttackMissed]
	and a
	jr nz, .evaded
	call CheckSubstituteOpp
	jr nz, .evaded

	ld de, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wBattleMonType1
.ok

	ld a, [de]
	cp GRASS
	jr z, .grass
	inc de
	ld a, [de]
	cp GRASS
	jr z, .grass

	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr nz, .evaded
	set SUBSTATUS_LEECH_SEED, [hl]

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp SPRING_BUDS
	call nz, AnimateCurrentMove
	ld hl, WasSeededText
	jp StdBattleTextBox

.grass
	call AnimateFailedMove
	jp PrintDoesntAffect

.evaded
	call AnimateFailedMove
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerMoveStructPower]
	jr z, .enemy_evaded
	ld a, [wEnemyMoveStructPower]
.enemy_evaded
	and a
	ret nz ; if the move deals damage, don't print the "evaded the attack" text
	ld hl, EvadedText
	jp StdBattleTextBox

BattleCommand_Splash:
	call AnimateCurrentMove
	jp PrintNothingHappened

BattleCommand_ResetStats:
	ld a, 7 ; neutral
	ld hl, wPlayerStatLevels
	call .Fill
	ld hl, wEnemyStatLevels
	call .Fill

	ldh a, [hBattleTurn]
	push af

	call SetPlayerTurn
	call CalcPlayerStats
	call SetEnemyTurn
	call CalcEnemyStats

	pop af
	ldh [hBattleTurn], a

	call AnimateCurrentMove

	ld hl, EliminatedStatsText
	jp StdBattleTextBox

.Fill
	ld b, wPlayerStatLevelsEnd - wPlayerStatLevels - 1
.next
	ld [hli], a
	dec b
	jr nz, .next
	ret

BattleCommand_Heal:
	callba CheckFullHP
	jr z, .hp_full
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp REST
	jr nz, .not_rest
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_INSOMNIA
	jp z, FailedGeneric

	push hl
	push de
	push af
	call BattleCommand_MoveDelay
	ld a, BATTLE_VARS_SEMISTATUS
	call GetBattleVarAddr
	res SEMISTATUS_TOXIC, [hl]
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld a, [hl]
	and SLP
	jp nz, .already_sleeping
	ld a, [hl]
	and a
	ld [hl], REST_TURNS + 1
	ld hl, WentToSleepText
	jr z, .no_status_to_heal
	ld hl, RestedText
.no_status_to_heal
	call StdBattleTextBox
	ldh a, [hBattleTurn]
	and a
	jr nz, .calc_enemy_stats
	call CalcPlayerStats
	jr .got_stats
.calc_enemy_stats
	call CalcEnemyStats
.got_stats
	pop af
	pop de
	pop hl

	callba GetMaxHP
	jr .finish
.not_rest
	callba GetHalfMaxHP
.finish
	call AnimateCurrentMove
	callba RestoreUserHP
	call UpdateUserInParty
	call RefreshBattleHuds
	ld hl, RegainedHealthText
	jp StdBattleTextBox

.hp_full
	call AnimateFailedMove
	ld hl, HPIsFullText
	jp StdBattleTextBox

.already_sleeping
	pop af
	pop de
	pop hl
	jp FailedGeneric

PrintDoesntAffect:
; 'it doesn't affect'
	ld hl, DoesntAffectText
	jp StdBattleTextBox

PrintNothingHappened:
; 'but nothing happened!'
	ld hl, NothingHappenedText
	jp StdBattleTextBox

PrintDidntAffectWithMoveAnimDelay:
	call AnimateFailedMove
	; fallthrough

PrintDidntAffect:
; 'it didn't affect'
	ld hl, DidntAffect1Text
	jp StdBattleTextBox

BattleCommand_SelfDestruct:
	ld a, BATTLEANIM_PLAYER_DAMAGE
	ld [wNumHits], a
	ld c, 2
	call DelayFrames
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	xor a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hl], a
	inc a
	ld [wBattleAnimParam], a
	call BattleCommand_LowerSub
	call LoadMoveAnim
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	res SUBSTATUS_LEECH_SEED, [hl]
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	call CheckBattleScene
	ret nc
	callba DrawPlayerHUD
	callba DrawEnemyHUD
	call ApplyTilemapInVBlank
	jp RefreshBattleHuds

BattleCommand_ArenaTrap:
; Doesn't work on an absent opponent.

	call CheckHiddenOpponent
	jr nz, .failed

; Don't trap if the opponent is already trapped.

	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .failed

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	bit SUBSTATUS_CANT_RUN, [hl]
.failed
	jp nz, FailedGeneric

; Otherwise trap the opponent.

	set SUBSTATUS_CANT_RUN, [hl]
	call AnimateCurrentMove
	ld hl, CantEscapeNowText
	jp StdBattleTextBox

BattleCommand_Pursuit:
; Double damage if the opponent is switching.

	ld hl, wEnemyIsSwitching
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wPlayerIsSwitching
.ok
	ld a, [hl]
	and a
	ret z
	jp DoubleDamage

BattleCommand_ClearHazards:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr z, .not_leeched
	res SUBSTATUS_LEECH_SEED, [hl]
	ld hl, ShedLeechSeedText
	call StdBattleTextBox
.not_leeched

	ld hl, wPlayerScreens
	ld de, wPlayerWrapCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens_wrap
	ld hl, wEnemyScreens
	ld de, wEnemyWrapCount
.got_screens_wrap
	bit SCREENS_SPIKES, [hl]
	jr z, .no_spikes
	res SCREENS_SPIKES, [hl]
	ld hl, BlewSpikesText
	push de
	call StdBattleTextBox
	pop de
.no_spikes

	ld a, [de]
	and a
	ret z
	xor a
	ld [de], a
	ld hl, ReleasedByText
	jp StdBattleTextBox

BattleCommand_SkipSunCharge:
	call GetWeatherAfterAbilities
	cp WEATHER_SUN
	ret nz
	ld b, charge_command
	jp SkipToBattleCommand

BattleCommand_ThunderAccuracy:
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	and $3f
	inc hl
	call GetWeatherAfterAbilities
	cp WEATHER_RAIN
	jr z, .rain
	cp WEATHER_SUN
	ret nz
	ld [hl], 50
	ret

.rain
	; Redundant with CheckHit guranteeing hit
	ld [hl], 100
	ret

BattleCommand_LaughingGas:
	ld a, [wAttackMissed]
	and a
	ret nz
	xor a
	ld [wEffectFailed], a
	call ResetMiss
	call BattleCommand_AttackDown
	call BattleCommand_StatDownMessage

	call ResetMiss
	call BattleCommand_SpecialAttackDown
	jp BattleCommand_StatDownMessage

BattleCommand_ThunderFang:
	call CheckSubstituteOpp
	ret nz

	ld a, [wEffectFailed]
	and a
	jr nz, .check_flinch

	call BattleCommand_ParalyzeTarget

.check_flinch
	call BattleCommand_EffectChance

	ld a, [wEffectFailed]
	and a
	ret nz

	jp BattleCommand_FlinchTarget
