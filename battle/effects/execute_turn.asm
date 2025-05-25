DoPlayerTurn:
	call SetPlayerTurn
	ld a, [wBattlePlayerAction]
	and a
	ret nz
	jr DoTurn

DoEnemyTurn:
	call SetEnemyTurn
	ld a, [wLinkMode]
	and a
	jr z, DoTurn
	ld a, [wBattleAction]
	cp BATTLEACTION_STRUGGLE
	jr z, DoTurn
	cp BATTLEACTION_SWITCH1
	ret nc
DoTurn:
; Read in and execute the user's move effects for this turn.

	xor a
	ld [wTurnEnded], a
	ld [wMoveIsAnAbility], a
	ld [wFailedMessage], a

	; Effect command checkturn is called for every move.
	call CheckTurn

	ld a, [wTurnEnded]
	and a
	ret nz
UpdateMoveDataAndDoMove:
	call UpdateMoveData
DoMove:
; Get the user's move effect.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld c, a
	ld b, 0
	ld hl, MoveEffectsPointers
	add hl, bc
	add hl, bc
	ld a, BANK(MoveEffectsPointers)
	call GetFarHalfword

	ld de, wBattleScriptBuffer

.GetMoveEffect
	ld a, BANK(MoveEffects)
	call GetFarByteAndIncrement
	ld [de], a
	inc de
	cp $ff
	jr nz, .GetMoveEffect

; Start at the first command.
	ld hl, wBattleScriptBuffer
	ld a, l
	ld [wBattleScriptBufferLoc], a
	ld a, h
	ld [wBattleScriptBufferLoc + 1], a

.ReadMoveEffectCommand

	ld hl, wBattleScriptBufferLoc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hli]

	push af
	ld a, l
	ld [wBattleScriptBufferLoc], a
	ld a, h
	ld [wBattleScriptBufferLoc + 1], a
	pop af

; endturn_command (-2) is used to terminate branches without ending the read cycle.
	cp endturn_command
	jr nc, CheckPowerHerb

	; The rest of the commands (01-af) are read from BattleCommandPointers.
	push bc
	dec a
	ld c, a
	ld b, 0
	ld hl, BattleCommandPointers
	add hl, bc
	add hl, bc
; 3-byte pointers
	add hl, bc
	ld a, BANK(BattleCommandPointers)
	call GetFarByteHalfword
	pop bc
	call .CallEffectCommand
	jr .ReadMoveEffectCommand

.CallEffectCommand
	cp BANK(@)
	jp nz, FarCall_hl
	jp hl

CheckPowerHerb:
	callba HasUserFainted
	ret z

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CHARGED, a
	ret z

	call GetUserItem
	ld a, b
	cp HELD_POWER_HERB
	ret nz

	call SwitchTurn
	callba UseOpponentItem
	call SwitchTurn
	jpba ResetTurn_PowerHerb
