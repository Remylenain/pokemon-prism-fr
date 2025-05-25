BattleCommand_Conversion:
	ld hl, wBattleMonMoves
	ld de, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_moves
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonType1
.got_moves
	push de
	ld c, 0
	ld de, wStringBuffer1
.copy_move_attributes_loop
	push hl
	ld b, 0
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .done_loading_move_attributes
	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_TYPE
	call GetMoveAttr
	and $3f
	ld [de], a
	inc de
	pop bc
	pop hl
	inc c
	assert NUM_MOVES == 4
	bit 2, c
	jr z, .copy_move_attributes_loop
.done_loading_move_attributes
	ld a, $ff
	ld h, d
	ld l, e
	pop de
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wStringBuffer1 - 1
.check_valid_move_loop
	inc hl
	ld a, [hl]
	cp CURSE_T
	jr z, .check_valid_move_loop
	cp PRISM_T
	jr z, .check_valid_move_loop
	inc a
	jp z, FailedGeneric
	ld a, [de]
	cp [hl]
	jr z, .check_valid_move_loop
	inc de
	ld a, [de]
	dec de
	cp [hl]
	jr z, .check_valid_move_loop

.select_move_loop
	call BattleRandom
	assert NUM_MOVES == 4 ;this doesn't work if NUM_MOVES isn't a power of 2
	and 3
	ld c, a
	ld b, 0
	ld hl, wStringBuffer1
	add hl, bc
	ld a, [hl]
	cp CURSE_T
	jr z, .select_move_loop
	cp PRISM_T
	jr z, .select_move_loop
	inc a
	jr z, .select_move_loop
	ld a, [de]
	cp [hl]
	jr z, .select_move_loop
	inc de
	ld a, [de]
	dec de
	cp [hl]
	jr z, .select_move_loop
	ld a, [hl]
	ld [de], a
	inc de
	ld [de], a
	ld [wNamedObjectIndexBuffer], a
	callba GetTypeName
	call AnimateCurrentMove
	ld hl, TransformedTypeText
	jp StdBattleTextBox

BattleCommand_Conversion2:
	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_type
	ld hl, wEnemyMonType1
.got_type
	; Save old types if we need to reset them
	ld a, [hli]
	ld b, a
	ld a, [hld]
	ld c, a
	push bc
	push hl

	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	jr z, .failed
	call SwitchTurn
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp CURSE_T
	jr z, .failed_switchturn

	; First, iterate through all types to ensure we have a type that resists in the first place. Then randomize.
	; !!! someone look through this code, as the validations are redundant and don't seem to match neither the comments nor pure common sense
	xor a
	jr .first_type
.loop
	ld a, b
.iteration_loop
	inc a
	jr z, .randomize
	cp TYPES_END
	jr nc, .failed_switchturn
.first_type
	call IsValidType
	jr c, .iteration_loop
	ld b, a
	jr .got_type_to_matchup
.randomize
	push bc
	call GenerateRandomType
	pop bc
.got_type_to_matchup
	pop hl
	push hl
	ld [hli], a
	ld [hld], a
	push bc
	call BattleCheckTypeMatchup
	pop bc
	ld a, [wTypeMatchup]
	cp 10
	jr nc, .loop

	; See if we reached a valid type by iteration or randomization
	ld a, b
	inc a
	ld b, $ff
	jr nz, .loop

	; Got type
	call SwitchTurn

	; Was saved in case we needed to reset type -- we don't
	pop hl
	pop bc

	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	predef GetTypeName
	call AnimateCurrentMove
	ld hl, TransformedTypeText
	jp StdBattleTextBox

.failed_switchturn
	call SwitchTurn
.failed
	call PrintDidntAffectWithMoveAnimDelay
	; Reset type
	pop hl
	pop bc
	ld [hl], b
	inc hl
	ld [hl], c
	ret
