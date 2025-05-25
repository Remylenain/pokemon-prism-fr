BattleCommand_Nightmare:
	call CheckHiddenOpponent
	call z, CheckSubstituteOpp
	jr nz, .failed_non_zero

	; Only works on a sleeping opponent.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and SLP
	jp z, FailedGeneric

	; Bail if the opponent is already having a nightmare.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_NIGHTMARE, [hl]
.failed_non_zero
	jp nz, FailedGeneric

	; Otherwise give the opponent a nightmare.
	set SUBSTATUS_NIGHTMARE, [hl]
	call AnimateCurrentMove
	ld hl, StartedNightmareText
	jp StdBattleTextBox
