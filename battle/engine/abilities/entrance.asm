AbilityOnMonEntrance:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .reverse

	call PlayerAbilityOnMonEntrance
	jr EnemyAbilityOnMonEntrance

.reverse
	call EnemyAbilityOnMonEntrance
	; fallthrough

PlayerAbilityOnMonEntrance:
	call SetPlayerTurn
	ld hl, wPlayerJustSentMonOut
	jr CheckAbilityOnMonEntrance

EnemyAbilityOnMonEntrance:
	call SetEnemyTurn
	ld hl, wEnemyJustSentMonOut
	; fallthrough

CheckAbilityOnMonEntrance:
	ld a, [hl]
	and a
	ld [hl], 0
	jr nz, .do_check

	; If we have Trace, check anyway. This allows a mon that failed to trace an ability
	; earlier to do so later on in the match (this is how Trace is supposed to work).
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_TRACE
	ret nz

.do_check
	; Maybe we fainted from Spikes/etc
	call HasUserFainted
	ret z

	ld a, [wBattleTurnTemp]
	push af
	ldh a, [hBattleTurn]
	ld [wBattleTurnTemp], a
	call GetUserAbility_IgnoreMoldBreaker
	ld [wMoveIsAnAbility], a
	call HasOpponentFainted
	ld hl, .abilities
	jr nz, .got_ability_table
	ld hl, .abilities_fainted
.got_ability_table
	ld a, [wMoveIsAnAbility]
	ld e, 3
	call IsInArray
	call c, CallLocalPointer_AfterIsInArray
	xor a
	ld [wMoveIsAnAbility], a
	pop af
	ld [wBattleTurnTemp], a
	ret

.abilities
; Only run these if opponent isn't fainted
	dbw ABILITY_INTIMIDATE, .intimidate
	dbw ABILITY_FRISK, .frisk
	dbw ABILITY_DOWNLOAD, .download
	dbw ABILITY_TRACE, .trace
	; fallthrough
.abilities_fainted
	dbw ABILITY_PRESSURE, .pressure
	dbw ABILITY_DRIZZLE, .drizzle
	dbw ABILITY_DROUGHT, .drought
	dbw ABILITY_SAND_STREAM, .sand_stream
	dbw ABILITY_SNOW_WARNING, .snow_warning
	dbw ABILITY_MOLD_BREAKER, .mold_breaker
	dbw ABILITY_AIR_LOCK, .air_lock
	dbw ABILITY_NATURAL_CURE, .natural_cure
	db -1

.trace
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerAbility
	ld de, wEnemyAbility
	jr z, .got_trace_ability
	push hl
	ld h, d
	ld l, e
	pop de
.got_trace_ability
	ld a, [de]
	and a
	call z, CalcTargetAbility
	cp ABILITY_TRACE
	ret z
	ld [hl], a
	ld [wd265], a
	ld [wMoveIsAnAbility], a
	call GetAbilityName
	ld hl, TraceText
	call StdBattleTextBox
	jr .do_check

.natural_cure
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld [hl], 0
	jp UpdateUserInParty

.intimidate
	; This is safe with up to Gen VII moves
	xor a
	ld [wEffectFailed], a

	callba BattleCommand_AttackDown
	callba BattleCommand_StatDownMessage
	jpba BattleCommand_StatDownFailText

.pressure
	ld hl, PressureText
	jr .std_battle_text_box

.mold_breaker
	ld hl, BreaksTheMoldText
	jr .std_battle_text_box

.frisk
	call GetOpponentItem
	ld a, [hl]
	and a
	ret z
	ld [wd265], a
	call GetItemName
	ld hl, FriskText
.std_battle_text_box
	jp StdBattleTextBox

.download
	ld hl, wEnemyMonDefense + 1
	ld de, wEnemyMonSpclDef + 1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_enemy_defs
	ld hl, wBattleMonDefense + 1
	ld de, wBattleMonSpclDef + 1
.got_enemy_defs
	ld a, [de]
	cp [hl]
	jr c, .boost_special
	jr nz, .boost_physical
	dec de
	dec hl
	ld a, [de]
	cp [hl]
	jr c, .boost_special
	jr nz, .boost_physical
.boost_special
	callba BattleCommand_SpecialAttackUp
	jr .done_boosting_stat
.boost_physical
	callba BattleCommand_AttackUp
.done_boosting_stat
	ld a, [wFailedMessage]
	and a
	ret nz
	ld a, [wMoveIsAnAbility]
	ld [wd265], a
	call GetAbilityName
	jpba BattleCommand_StatUpMessage

.air_lock
	ld hl, AirLockText
	jr .std_battle_text_box

.drizzle
	jpba DrizzleFunction

.drought
	jpba DroughtFunction

.sand_stream
	jpba SandStreamFunction

.snow_warning
	jpba SnowWarningFunction
