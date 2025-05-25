BattleCommand_AttackUp:
	ln b, 0, ATTACK
	jr BattleCommand_StatUp

BattleCommand_DefenseUp:
	ln b, 0, DEFENSE
	jr BattleCommand_StatUp

BattleCommand_SpeedUp:
	ln b, 0, SPEED
	jr BattleCommand_StatUp

BattleCommand_SpecialAttackUp:
	ln b, 0, SP_ATTACK
	jr BattleCommand_StatUp

BattleCommand_SpecialDefenseUp:
	ln b, 0, SP_DEFENSE
	jr BattleCommand_StatUp

BattleCommand_AccuracyUp:
	ln b, 0, ACCURACY
	jr BattleCommand_StatUp

BattleCommand_EvasionUp:
	ln b, 0, EVASION
	jr BattleCommand_StatUp

BattleCommand_AttackUp2:
	ln b, 1, ATTACK
	jr BattleCommand_StatUp

BattleCommand_DefenseUp2:
	ln b, 1, DEFENSE
	jr BattleCommand_StatUp

BattleCommand_SpeedUp2:
	ln b, 1, SPEED
	jr BattleCommand_StatUp

BattleCommand_SpecialAttackUp2:
	ln b, 1, SP_ATTACK
	jr BattleCommand_StatUp

BattleCommand_SpecialDefenseUp2:
	ln b, 1, SP_DEFENSE
	jr BattleCommand_StatUp

BattleCommand_AccuracyUp2:
	ln b, 1, ACCURACY
	jr BattleCommand_StatUp

BattleCommand_EvasionUp2:
	ln b, 1, EVASION
BattleCommand_StatUp:
	ld hl, DoStatUp
	ld de, DoStatDown
	jp ApplySimpleAndContrary

BattleCommand_AllStatsUp:
; Attack
	call ResetMiss
	call BattleCommand_AttackUp
	call BattleCommand_StatUpMessage

; Defense
	call ResetMiss
	call BattleCommand_DefenseUp
	call BattleCommand_StatUpMessage

; Speed
	call ResetMiss
	call DoSpeedUpCommandWithStatUpMessage

; Special Attack
	call ResetMiss
	call BattleCommand_SpecialAttackUp
	call BattleCommand_StatUpMessage

; Special Defense
	call ResetMiss
	call BattleCommand_SpecialDefenseUp
	jp BattleCommand_StatUpMessage

BattleCommand_AttackDown:
	ln b, 0, ATTACK
	jr BattleCommand_StatDown

BattleCommand_DefenseDown:
	ln b, 0, DEFENSE
	jr BattleCommand_StatDown

BattleCommand_SpeedDown:
	ln b, 0, SPEED
	jr BattleCommand_StatDown

BattleCommand_SpecialAttackDown:
	ln b, 0, SP_ATTACK
	jr BattleCommand_StatDown

BattleCommand_SpecialDefenseDown:
	ln b, 0, SP_DEFENSE
	jr BattleCommand_StatDown

BattleCommand_AccuracyDown:
	ln b, 0, ACCURACY
	jr BattleCommand_StatDown

BattleCommand_EvasionDown:
	ln b, 0, EVASION
	jr BattleCommand_StatDown

BattleCommand_AttackDown2:
	ln b, 1, ATTACK
	jr BattleCommand_StatDown

BattleCommand_DefenseDown2:
	ln b, 1, DEFENSE
	jr BattleCommand_StatDown

BattleCommand_SpeedDown2:
	ln b, 1, SPEED
	jr BattleCommand_StatDown

BattleCommand_SpecialAttackDown2:
	ln b, 1, SP_ATTACK
	jr BattleCommand_StatDown

BattleCommand_SpecialDefenseDown2:
	ln b, 1, SP_DEFENSE
	jr BattleCommand_StatDown

BattleCommand_AccuracyDown2:
	ln b, 1, ACCURACY
	jr BattleCommand_StatDown

BattleCommand_EvasionDown2:
	ln b, 1, EVASION
	; fallthrough

BattleCommand_StatDown:
	ld hl, DoStatDownCheck
	ld de, DoStatUpCheck
	jp ApplySimpleAndContraryOpp
