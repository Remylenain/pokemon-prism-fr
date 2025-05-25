BattleCommand_Endure:
	call ProtectChance
	ret c

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	set SUBSTATUS_ENDURE, [hl]

	call AnimateCurrentMove

	ld hl, BracedItselfText
	jp StdBattleTextBox

BattleCommand_Protect:
	call ProtectChance
	ret c

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	set SUBSTATUS_PROTECT, [hl]

	call AnimateCurrentMove

	ld hl, ProtectedItselfText
	jp StdBattleTextBox

ProtectChance:
	ld hl, wPlayerProtectCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_address
	ld hl, wEnemyProtectCount
.got_address

	call CheckOpponentWentFirst
	jr nz, .failed

; Can't have a substitute.
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .failed

; Halve the chance of a successful Protect for each consecutive use.
; (Player|Enemy)ProtectCount should cap at 255. That gives a chance of 1.7272e-77 of success, which we can just call zero. It won't happen.
	inc [hl]
	ld b, [hl]
	call BattleRandom
	ld c, a
	and a

.loop
	dec b
	ret z
	ld a, b
	and 7
	jr nz, .no_new_random
	call BattleRandom
	ld c, a
.no_new_random
	srl c
	jr nc, .loop

.failed
	ld [hl], 0
	call FailedGeneric
	scf
	ret
