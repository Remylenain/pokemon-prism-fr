BattleCommand_Teleport:
	ld a, [wBattleType]
	cp BATTLETYPE_SHINY
	jr z, .failed
	cp BATTLETYPE_TRAP
	jr z, .failed
	cp BATTLETYPE_CELEBI
	jr z, .failed
	cp BATTLETYPE_SUICUNE
	jr z, .failed

	ldh a, [hBattleTurn]
	and a
	ld hl, CheckEnemyAbilityPreventsEscaping
	jr z, .check_ability
	ld hl, CheckPlayerAbilityPreventsEscaping
.check_ability
	ld a, BANK(CheckPlayerAbilityPreventsEscaping)
	call FarCall_hl
	jr c, .failed

	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVar
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .failed

	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .failed
; Only need to check these next things if it's your turn
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy_turn
; Can't teleport from a trainer battle
	ld a, [wBattleMode]
	dec a
	jr nz, .failed
; If your level is greater than the opponent's, you run without fail.
	ld a, [wCurPartyLevel]
	ld b, a
	ld a, [wBattleMonLevel]
	cp b
	jr nc, .run_away
; Generate a random number no greater than the sum of your level and your opponent's.
	add a, b
	ld c, a
	inc c
.loop_player
	call BattleRandom
	cp c
	jr nc, .loop_player
; If that number is greater than 4 times your level, run away.
	srl b
	srl b
	cp b
	jr nc, .run_away
.failed
	jp FailedGeneric

.enemy_turn
	ld a, [wBattleMode]
	dec a
	jr nz, .failed
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wCurPartyLevel]
	cp b
	jr nc, .run_away
	add b
	ld c, a
	inc c
.loop_enemy
	call BattleRandom
	cp c
	jr nc, .loop_enemy
	srl b
	srl b
	cp b
	jr nc, .run_away
.run_away
	call UpdateBattleMonInParty
	xor a
	ld [wNumHits], a
	inc a
	ld [wForcedSwitch], a
	ld [wBattleAnimParam], a
	call SetBattleDraw
	call BattleCommand_LowerSub
	call LoadMoveAnim
	ld c, 20
	call DelayFrames
	call SetBattleDraw

	ld hl, FledFromBattleText
	jp StdBattleTextBox
