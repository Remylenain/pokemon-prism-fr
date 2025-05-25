BattleCommand_BellyDrum:
; bellydrum
	ld a, [wAttackMissed]
	and a
	jr nz, .failed

	callba GetHalfMaxHP
	callba CheckUserHasEnoughHP
	jp nc, FailedGeneric

	push bc
	call BattleCommand_AttackUp2
	pop bc
	ld a, [wAttackMissed]
	and a
.failed
	jp nz, FailedGeneric

	call AnimateCurrentMove
	callba SubtractHPFromUser
	call UpdateUserInParty
	ld a, 5

.max_attack_loop
	push af
	call BattleCommand_AttackUp2
	pop af
	dec a
	jr nz, .max_attack_loop

	xor a
	ld [wAttackMissed], a
	ld hl, BellyDrumText
	jp StdBattleTextBox
