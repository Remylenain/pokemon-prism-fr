BattleCommand_TrapTarget:
	ld a, [wAttackMissed]
	and a
	ret nz
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove
	ldh a, [hBattleTurn]
	and a
	jr z, .got_trap
	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove

.got_trap
	ld a, [hl]
	and a
	ret nz
	call CheckSubstituteOpp
	ret nz
	call BattleRandom
	and 3
	add 3
	ld [hl], a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld [de], a
	ld b, a
	ld hl, .Traps - 2

.find_trap_text
	inc hl
	inc hl
	ld a, [hli]
	cp b
	jr nz, .find_trap_text

.found_trap_text
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.Traps
	dbw WRAP,      WrappedByText     ; 'was WRAPPED by'
	dbw FIRE_SPIN, WasTrappedText    ; 'was trapped!'
