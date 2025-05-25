BattleRandomPercentage::
	; same idea as RandomPercentage, but using BattleRandom
	call BattleRandom
	cp 200
	jr nc, .not_in_range
	srl a
	ret
.not_in_range
	cp 250
	jr nc, BattleRandomPercentage
	push bc
	ld b, a
	call BattleRandom
	add a, a
	ld a, b
	pop bc
	rla
	sub 144
	ret

SkipToBattleCommand:
; Skip over commands until reaching command b.
	ld hl, wBattleScriptBufferLoc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, h
	ld [wBattleScriptBufferLoc + 1], a
	ld a, l
	ld [wBattleScriptBufferLoc], a
	ret

GetMoveAttr:
; Assuming hl = Moves + x, return attribute x of move a.
	push bc
	ld bc, MOVE_LENGTH
	rst AddNTimes
	call GetMoveByte
	pop bc
	ret

GetMoveData:
; Copy move struct a to de.
	ld hl, Moves
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	jp FarCopyBytes

GetMoveByte:
	ld a, BANK(Moves)
	jp GetFarByte

GenerateRandomType:
	push hl
.loop
	call BattleRandom
	and $1f
	call IsValidType
	jr c, .loop
	pop hl
	ret

IsValidType:
	cp TYPES_END
	ccf
	ret c
	push af
	ld hl, .invalid_types
	call IsInSingularArray
	pop hl
	ld a, h
	ret

.invalid_types
	db BIRD
	db TYPE_12
	db TYPE_16
	db TYPE_17
	db TYPE_18
	db CURSE_T
	db -1

UpdateMoveData:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	ld d, h
	ld e, l

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld [wCurMove], a
	ld [wNamedObjectIndexBuffer], a

	dec a
	call GetMoveData
	call GetMoveName
	jp CopyName1

GetStatName:
	ld hl, .names
	ld c, "@"
	jr .handle_loop
.loop
	ld a, [hli]
	cp c
	jr nz, .loop
.handle_loop
	dec b
	jr nz, .loop
	ld de, wStringBuffer2
	ld c, wStringBuffer3 - wStringBuffer2 ;b must be 0 here
	rst CopyBytes
	ret

.names
	db "Attack@"
	db "Defense@"
	db "Speed@"
	db "Sp. Atk@"
	db "Sp. Def@"
	db "Accuracy@"
	db "Evasion@"
	db "stats@"

ResetMiss:
	xor a
	ld [wAttackMissed], a
	ret

FailedGeneric:
	call AnimateFailedMove
	jp PrintButItFailed

SetBattleDraw:
	ld a, [wBattleResult]
	and $c0
	or 2
	ld [wBattleResult], a
	ret
