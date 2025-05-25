BattleCommand_Charge:
	call BattleCommand_ClearText
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	jr z, .awake

	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSub
	call PrintButItFailed
	jp EndMoveEffect

.awake
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_CHARGED, [hl]

	ld hl, IgnoredOrders2Text
	ld a, [wAlreadyDisobeyed]
	and a
	call nz, StdBattleTextBox

	call BattleCommand_LowerSub
	xor a
	ld [wNumHits], a
	inc a
	ld [wBattleAnimParam], a
	call LoadMoveAnim
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .flying_or_underground
	cp DIG
	jr z, .flying_or_underground
	call BattleCommand_RaiseSub
	jr .not_flying

.flying_or_underground
	callba DisappearUser
.not_flying
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	cp FLY
	jr z, .set_flying
	cp DIG
	jr nz, .dont_set_digging
	set SUBSTATUS_UNDERGROUND, [hl]
	jr .dont_set_digging

.set_flying
	set SUBSTATUS_FLYING, [hl]

.dont_set_digging
	ld hl, .UsedText
	call BattleTextBox

	call ZeroDamage

	ld b, endturn_command
	jp EndMoveEffect

.UsedText
	text_far Battle_UserText ; "[USER]"
	start_asm
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp SOLARBEAM
	ld hl, .Solarbeam
	ret z

	cp SKY_ATTACK
	ld hl, .SkyAttack
	ret z

	cp FLY
	ld hl, .Fly
	ret z

	ld hl, .Dig
	ret

.Solarbeam
	text_jump Battle_SolarbeamText

.SkullBash
	text_jump Battle_SkullBashText

.SkyAttack
	text_jump Battle_SkyAttackText

.Fly
	text_jump Battle_FlyText

.Dig
	text_jump Battle_DigText
