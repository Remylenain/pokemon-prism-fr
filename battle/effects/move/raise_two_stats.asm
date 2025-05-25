BattleCommand_BulkUp:
	lb bc, ATTACK, DEFENSE
	jr BattleCommand_DoubleUp
BattleCommand_CalmMind:
	lb bc, SP_ATTACK, SP_DEFENSE
	jr BattleCommand_DoubleUp
BattleCommand_CosmicPower:
	lb bc, DEFENSE, SP_DEFENSE
	jr BattleCommand_DoubleUp
BattleCommand_DragonDance:
	lb bc, ATTACK, SPEED
	jr BattleCommand_DoubleUp
BattleCommand_Growth:
	lb bc, ATTACK, SP_ATTACK
	call GetWeatherAfterAbilities
	cp WEATHER_SUN
	jr nz, BattleCommand_DoubleUp
	lb bc, ($10 | ATTACK), ($10 | SP_ATTACK)
BattleCommand_DoubleUp:
; stats to raise are in bc
	push bc ; StatUp clobbers c (via CheckIfStatCanBeRaised), which we want to retain
	call ResetMiss
	call BattleCommand_StatUp
	ld a, [wFailedMessage]
	ld d, a ; note for 2nd stat
	ld e, 0	; track if we've shown animation
	and a
	call z, .msg_animate
	pop bc
	ld b, c
	push de
	call ResetMiss
	call BattleCommand_StatUp
	pop de
	ld a, [wFailedMessage]
	and a
	jr z, .msg_animate
	and d ; if this result in a being nonzero, we want to give a failure message
	ret z
	ld b, ABILITY + 1
	call GetStatName
	call AnimateFailedMove
	ld hl, WontRiseAnymoreText
	jp StdBattleTextBox

.msg_animate
	ld a, e
	and a
	push de
	jr nz, .statupmessage
	inc a
	ld [wBattleAnimParam], a
	call AnimateCurrentMove
	pop de
	inc e
	push de
.statupmessage
	call BattleCommand_StatUpMessage
	pop de
	ret
