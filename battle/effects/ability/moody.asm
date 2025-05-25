BattleCommand_Moody:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	ld a, [hl]
	push af
	push hl
	res SUBSTATUS_MIST, [hl]
	ld bc, -1
	call .Sample
	ld b, a
	call .Sample
	ld c, a
	call .Sample
	push bc
	ld b, a
	call SwitchTurn
	call BattleCommand_StatDown
	call BattleCommand_StatDownMessage
	call SwitchTurn
	pop bc
	push bc
	call BattleCommand_StatUp
	call BattleCommand_StatUpMessage
	pop bc
	ld b, c
	call BattleCommand_StatUp
	call BattleCommand_StatUpMessage
	pop hl
	pop af
	ld [hl], a
	ret

.Sample
	call BattleRandom
	and 7
	jr z, .Sample
	dec a
	cp b
	jr z, .Sample
	cp c
	jr z, .Sample
	ret
