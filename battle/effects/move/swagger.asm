BattleCommand_Swagger:
; We don't neccessarily want stat-up failure to result in
; not confusing. We also want to check for sub/etc
	; If we missed, abort the rest of the logic
	ld a, [wAttackMissed]
	and a
	jp nz, BattleCommand_FailureText

	call SwitchTurn
	ln b, 1, ATTACK
	ld hl, DoStatUpCheck
	ld de, DoStatDownCheck
	call ApplySimpleAndContrary

	; Don't do a failure animation for stat up failure
	ld a, [wFailedMessage]
	and a
	jr nz, .animation_done
	call SwitchTurn
	call BattleCommand_LowerSub
	call BattleCommand_StatUpAnim
	call BattleCommand_RaiseSub
	call SwitchTurn
.animation_done
	call BattleCommand_StatUpMessage
	call BattleCommand_StatUpFailText
	call SwitchTurn
	call ResetMiss
	jp BattleCommand_Confuse
