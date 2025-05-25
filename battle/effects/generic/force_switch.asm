BattleCommand_ForceSwitch:
	call GetTargetAbility
	cp ABILITY_SUCTION_CUPS
	jr z, .fail
	ld a, [wBattleType]
	cp BATTLETYPE_SHINY
	jr z, .fail
	cp BATTLETYPE_TRAP
	jr z, .fail
	cp BATTLETYPE_CELEBI
	jr z, .fail
	cp BATTLETYPE_SUICUNE
	jr z, .fail
	ld a, [wAttackMissed]
	and a
	jr nz, .fail
	ld a, [wBattleMode]
	dec a
	jp z, .wild
	ldh a, [hBattleTurn]
	and a
	jr nz, .force_player_switch
	call FindAliveEnemyMons
	jr c, .fail
	ld a, [wEnemyGoesFirst]
	and a
	jr z, .fail
	call UpdateEnemyMonInParty
	call .animate_move_and_delay
	hlcoord 1, 0
	lb bc, 4, 10
	call .clear_box_and_delay
	ld a, [wOTPartyCount]
	ld b, a
	ld a, [wCurOTMon]
	ld c, a
.select_enemy_mon
	call .select_random_mon_to_switch
	ld hl, wOTPartyMon1HP
	call .check_mon_is_alive
	jr z, .select_enemy_mon
	ld a, d
	inc a
	ld [wEnemySwitchMonIndex], a
	callba ForceEnemySwitch

	ld hl, DraggedOutText
	call StdBattleTextBox

	callba SpikesDamage_CheckMoldBreaker
	jpba EnemyAbilityOnMonEntrance

.fail
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSub
	jp PrintButItFailed

.force_player_switch
	call CheckPlayerHasMonToSwitchTo
	jr c, .fail

	ld a, [wEnemyGoesFirst]
	cp 1
	jr z, .fail

	call UpdateBattleMonInParty
	call .animate_move_and_delay
	hlcoord 9, 7
	lb bc, 5, 11
	call .clear_box_and_delay
	ld a, [wPartyCount]
	ld b, a
	ld a, [wCurBattleMon]
	ld c, a
.select_party_mon
	call .select_random_mon_to_switch
	ld hl, wPartyMon1HP
	call .check_mon_is_alive
	jr z, .select_party_mon

	ld a, d
	ld [wCurPartyMon], a
	callba SwitchPlayerMon

	ld hl, DraggedOutText
	call StdBattleTextBox

	callba SpikesDamage_CheckMoldBreaker
	jpba PlayerAbilityOnMonEntrance

.wild
	ld a, [wCurPartyLevel]
	ld b, a
	ld a, [wBattleMonLevel]
	ld c, a
	ldh a, [hBattleTurn]
	and a
	jr z, .wild_player_turn
	ld a, b
	ld b, c
	ld hl, wEnemyMoveStructAnimation
	jr .got_wild_values
.wild_player_turn
	ld a, c
	ld hl, wPlayerMoveStructAnimation
.got_wild_values
	call .check_wild_success
	jr c, .fail
	push hl
	call UpdateBattleMonInParty
	pop hl
	xor a
	ld [wNumHits], a
	inc a
	ld [wForcedSwitch], a
	ld a, [hl]
	; fallthrough

.succeed
	push af
	call SetBattleDraw
	call .animate_move_and_delay
	pop af

	ld hl, FledInFearText
	cp ROAR
	jr z, .do_text
	ld hl, BlownAwayText
.do_text
	jp StdBattleTextBox

.select_random_mon_to_switch
	call BattleRandom
	and 7
	cp b
	jr nc, .select_random_mon_to_switch
	cp c
	jr z, .select_random_mon_to_switch
	ret

.check_wild_success
	; a: target's level, b: user's level; returns nc if success, carry if failure
	; if a >= b, it always succeeds
	; otherwise, generate a random number no greater than a+b; succeed if result*4 >= b
	cp b
	ret nc
	add a, b
	inc a
	call BattleRandomRange
	cp $40 ; check if shifts will overflow
	ret nc
	add a, a
	add a, a
	cp b
	ret

.check_mon_is_alive
	push af
	push bc
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	pop bc
	pop de
	ret

.animate_move_and_delay
	ld a, 1
	ld [wBattleAnimParam], a
	call AnimateCurrentMove
.delay_20
	ld c, 20
	jp DelayFrames

.clear_box_and_delay
	call ClearBox
	jr .delay_20
