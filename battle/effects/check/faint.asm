BattleCommand_CheckFaint:
	; also deals damage

	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_STURDY, [hl]
	res SUBSTATUS_STURDY, [hl]
	jr nz, .sturdy

	dec hl
	bit SUBSTATUS_ENDURE, [hl]
	jr z, .not_enduring
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .okay
	inc b
	jr .okay

.sturdy
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .okay
	ld b, 3
	jr .okay

.not_enduring
	call GetOpponentItem
	ld a, b
	cp HELD_FOCUS_BAND
	ld b, 0
	jr nz, .okay
	call BattleRandomPercentage
	cp c
	jr nc, .okay
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .okay
	ld b, 2
.okay
	push bc
	call .check_sub
	ld c, 0
	ldh a, [hBattleTurn]
	and a
	jr nz, .damage_player
	call EnemyHurtItself
	jr .done_damage

.damage_player
	call PlayerHurtItself

.done_damage
	call ShellBellCheck
	pop af
	and a
	ret z
	dec a
	ld hl, EnduredText
	jp z, StdBattleTextBox

	dec a
	jr nz, .ability_prevented_faint
	call GetOpponentItem
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName

	ld hl, HungOnText
	jp StdBattleTextBox

.ability_prevented_faint
	call GetTargetAbility
	ld [wNamedObjectIndexBuffer], a
	call GetAbilityName

	ld hl, HungOnText
	jp StdBattleTextBox

.check_sub
	call CheckSubstituteOpp
	ret nz

	ld hl, wPlayerDamageTaken + 1
	ldh a, [hBattleTurn]
	and a
	jr nz, .damage_taken
	ld hl, wEnemyDamageTaken + 1

.damage_taken
	call GetCurrentDamage
	ld a, [wCurDamage + 1]
	ld [wSavedDamage + 1], a
	add a, [hl]
	ld [hld], a
	ld a, [wCurDamage]
	ld [wSavedDamage], a
	adc [hl]
	ld [hl], a
	ret nc
	ld a, $ff
	ld [hli], a
	ld [hl], a
	ret
