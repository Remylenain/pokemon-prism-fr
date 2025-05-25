GetSwitchScores:
; e: Score of current mon out
; wEnemyAISwitchScore: Score of optimal switch choice (7 is lowest valid, 0 = can't switch)
; wEnemySwitchMonParam: Index of best switch choice
; Currently uses type matchups only to figure out score, but is designed to be possible
; to change
	xor a
	ld [wEnemySwitchMonParam], a
	ld [wEnemyAISwitchScore], a

	; Store active mon's ability since we overwrite it for matchup checks
	ld a, [wEnemyAbility]
	ld [wTempAIAbility], a

	ld hl, wOTPartyMon1
	ld a, [wOTPartyCount]
	ld b, a
	ld c, 0
	ld e, c

.loop
	push bc
	push de
	push hl

	; Is this mon alive?
	ld bc, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .next

	; Get ability and base stats
	call CalcPartyMonAbility ; calls GetBaseData
	ld [wEnemyAbility], a

	; Give a type matchup score
	ld bc, MON_MOVES
	pop hl
	push hl
	add hl, bc
	ld bc, wBaseType
	call AICheckMatchupForEnemyMon

.next
	; Checks below are safe if we arrived due to 0HP -- score will be 0 which is never
	; better, and we can use this to check for lack of switch choice ("best score" = 0)
	pop hl
	pop de
	pop bc
	ld d, a ; score

	; Is this the mon that's currently out?
	ld a, [wCurOTMon]
	cp c
	jr nz, .not_active_mon
	ld e, d
	jr .next2

.not_active_mon
	ld a, [wEnemyAISwitchScore]
	cp d
	jr nc, .next2

	; Target mon is a better switch-in
	ld a, d
	ld [wEnemyAISwitchScore], a
	ld a, c
	ld [wEnemySwitchMonParam], a

.next2
	dec b
	jr z, .reset_ability_and_return
	inc c
	push bc
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	pop bc
	jr .loop
.reset_ability_and_return
	ld a, [wTempAIAbility]
	ld [wEnemyAbility], a
	ret


CheckPlayerMoveTypeMatchups:
	ld hl, wEnemyMonMoves
	ld bc, wEnemyMonType
	; fallthrough
AICheckMatchupForEnemyMon:
; Check type matchups. Returns a number between 7-13 to a, lower is worse for the enemy.
; Scoring is +1 for SE, -1 for NVE, -2 for ineffective for enemy vs player, and vice versa.
; Lack of offensive moves count as neutral.
; Input is hl (enemy mon moves), bc (enemy mon types). Assumes wEnemyAbility is set
	; Player moves vs enemy
	push hl
	push bc
	ld hl, wPlayerUsedMoves
	call .check_matchups
	ld a, d
	and a
	pop hl
	jr z, .unknown_moves_done

	; Less than 4 known moves
	; Assume player has STAB and check those type matchups
	res 2, e
	ld a, [wBattleMonType1]
	push hl
	call .set_matchup
	ld a, [wBattleMonType2]
	pop hl
	call .set_matchup

	; fallthrough
.unknown_moves_done
	pop hl
	call .score_result
	add 10 ; use 10 rather than 0 as baseline
	push af

	; Now do enemy moves vs player
	ld bc, wBattleMonType
	call .check_matchups
	call .score_result
	ld b, a
	pop af
	sub b
	ret

.check_matchups
	; e is %0000ABCD, A = has 0.5x, B = no offensive moves, C = has 1x, D = has 2x
	lb de, NUM_MOVES, %00000100
.loop
	ld a, [hli]
	and a
	ret z
	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_POWER
	call GetMoveAttr
	and a
	jr z, .next

	; We have an attacking move, so reset relevant bit
	res 2, e
	; Set a to move type, hl is currently (move)'s power
	inc hl ; Type comes after power in the move attributes
	call GetMoveByte

	pop hl
	push hl
	call .set_matchup
.next
	pop bc
	pop hl
	dec d
	jr nz, .loop
	ret

.set_matchup
	call CheckTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ret z ; no effect
	set 3, e
	cp 10
	ret c ; not very effective
	set 1, e
	ret z ; neutral
	set 0, e
	ret ; super effective

.score_result
	; 2x
	ld a, -1
	srl e
	ret c
	; 1x
	inc a
	srl e
	ret c
	; No attacking moves
	srl e
	ret c
	; 0.5x
	inc a
	srl e
	ret c
	; 0x
	inc a
	ret

CheckAbleToSwitch:
	call GetSwitchScores
	ld a, [wEnemyAISwitchScore]
	and a
	ret z ; We can't switch

	ld a, [wEnemyPerishCount]
	cp 1
	ld a, [wEnemyAISwitchScore]
	jr nz, .no_perish

	; Perish count is 1
	cp 8
	ret c ; Bad or no choices, sacrifice active mon instead...
	ld b, $30
	jr .set_switch_score

.no_perish
	; Figure out the difference between active and best choice
	sub e
	add 7 ; Make the number easier to work with (changes worst from -6 to +1)
	cp 8
	ret c ; No reason to switch, no switch choice would be better than active mon
	; huge improvement
	ld b, $30
	cp 12
	jr nc, .set_switch_score
	; decent improvement
	ld b, $20
	cp 11
	jr nc, .set_switch_score
	; little improvement
	ld b, $10
	cp 10
	; No reason to switch
	ret c

.set_switch_score
	ld a, [wEnemySwitchMonParam]
	add b
	ld [wEnemySwitchMonParam], a
	ret

FindAliveEnemyMons:
; Returns carry if enemy only has 1 alive mon
	ld a, [wOTPartyCount]
	cp 2
	ret c

	lb bc, 1 << (PARTY_LENGTH - 1), 0
	ld d, a
	ld e, c
	ld hl, wOTPartyMon1HP

.loop
	ld a, [wCurOTMon]
	cp e
	jr z, .next

	push bc
	ld b, [hl]
	inc hl
	ld a, [hld]
	or b
	pop bc
	jr z, .next

	ld a, c
	or b
	ld c, a

.next
	srl b
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	inc e
	dec d
	jr nz, .loop

	ld a, c
	cp 1
	ret
