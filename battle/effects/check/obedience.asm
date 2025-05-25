BattleCommand_CheckObedience:
	call CheckUserIsCharging
	ret nz

	; Enemy can't disobey unless truant
	ldh a, [hBattleTurn]
	and a
	jr z, .normal_checks

	; If we've already checked this turn
	ld a, [wEnemyAlreadyDisobeyed]
	and a
	ret nz

	; Truant!!
	ld a, [wEnemyAbility]
	cp ABILITY_TRUANT
	ret nz

	ld a, [wEnemyTurnsTaken]
	bit 0, a
	ret z
	inc a
	ld [wEnemyTurnsTaken], a

	ld hl, LoafingAroundText
	call StdBattleTextBox
	xor a
	ld [wLastEnemyMove], a
	ld [wLastPlayerCounterMove], a

	; Break Encore too.
	ld hl, wEnemySubStatus5
	res SUBSTATUS_ENCORED, [hl]
	xor a
	ld [wEnemyEncoreCount], a

	jp EndMoveEffect

.normal_checks
	; If we've already checked this turn
	ld a, [wAlreadyDisobeyed]
	and a
	ret nz

	; Truant!!
	ld a, [wPlayerAbility]
	cp ABILITY_TRUANT
	jr nz, .not_truant

	ld a, [wPlayerTurnsTaken]
	bit 0, a
	jr z, .not_truant
	inc a
	ld [wPlayerTurnsTaken], a
	ld hl, LoafingAroundText
	jp .printDisobeyText

.not_truant
	; No obedience in link battles
	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wInBattleTowerBattle]
	rra
	ret c
	; If the monster's id doesn't match the player's,
	; some conditions need to be met.
	ld a, MON_ID
	call BattlePartyAttr

	ld a, [wPlayerID]
	cp [hl]
	jr nz, .obeylevel
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	ret z

.obeylevel
	; The maximum obedience level is constrained by owned badges:
	; min(100, 20 + 10 * #badges)
	ld hl, wNaljoBadges
	ld b, 3
	ld a, 20
.loop
	ld c, 8
	ld d, [hl]
.loop2
	srl d
	jr nc, .next
	add 10
	cp MAX_LEVEL
	jr nc, .getlevel
.next
	dec c
	jr nz, .loop2
	inc hl
	dec b
	jr nz, .loop
.getlevel
; c = obedience level
; d = monster level
; b = c + d

	ld b, a
	ld c, a

	ld a, [wBattleMonLevel]
	ld d, a

	add b
	ld b, a

; No overflow (this should never happen)
	jr nc, .checklevel
	ld b, $ff

.checklevel
; If the monster's level is lower than the obedience level, it will obey.
	ld a, c
	cp d
	ret nc

; Random number from 0 to obedience level + monster level
.rand1
	call BattleRandom
	cp b
	jr nc, .rand1

; The higher above the obedience level the monster is,
; the more likely it is to disobey.
	cp c
	ret c

; Sleep-only moves have separate handling, and a higher chance of
; being ignored. Lazy monsters like their sleep.
	call IgnoreSleepOnly
	ret c

; Another random number from 0 to obedience level + monster level
.rand2
	call BattleRandom
	cp b
	jr nc, .rand2

; A second chance.
	cp c
	jr c, .monUsedInstead

; No hope of using a move now.

; b = number of levels the monster is above the obedience level
	ld a, d
	sub c
	ld b, a

; The chance of napping is the difference out of 256.
	call BattleRandom
	sub b
	jr c, .monNaps

; The chance of not hitting itself is the same.
	cp b
	jr nc, .monDoesNothing

	ld hl, WontObeyText
	call StdBattleTextBox
	callba HitConfusion
	jp .endDisobedience

.monNaps
	call BattleRandom
	and SLP
	jr z, .monNaps

	ld [wBattleMonStatus], a

	ld hl, BeganToNapText
	jr .printDisobeyText

.monDoesNothing
	call BattleRandom
	and 3

	ld hl, LoafingAroundText
	jr z, .printDisobeyText

	ld hl, WontObeyText
	dec a
	jr z, .printDisobeyText

	ld hl, TurnedAwayText
	dec a
	jr z, .printDisobeyText

	ld hl, IgnoredOrdersText

.printDisobeyText
	call StdBattleTextBox
	jp .endDisobedience

.monUsedInstead

; Can't use another move if the monster only has one!
	ld a, [wBattleMonMoves + 1]
	and a
	jr z, .monDoesNothing

; Don't bother trying to handle Disable.
	ld a, [wDisabledMove]
	and a
	jr nz, .monDoesNothing

	ld hl, wBattleMonPP
	ld de, wBattleMonMoves
	lb bc, 0, NUM_MOVES

.getTotalPPLoop
	ld a, [hli]
	and $3f ; exclude pp up
	add b
	ld b, a

	dec c
	jr z, .checkMovePP

; Stop at undefined moves.
	inc de
	ld a, [de]
	and a
	jr nz, .getTotalPPLoop

.checkMovePP
	ld hl, wBattleMonPP
	ld a, [wCurMoveNum]
	ld e, a
	ld d, 0
	add hl, de

; Can't use another move if only one move has PP.
	ld a, [hl]
	and $3f
	cp b
	jr z, .monDoesNothing

; Make sure we can actually use the move once we get there.
	ld a, 1
	ld [wAlreadyDisobeyed], a

	ld a, [w2DMenuNumRows]
	ld b, a

; Save the move we originally picked for afterward.
	ld a, [wCurMoveNum]
	ld c, a
	push af

.randomMoveLoop
	call BattleRandom
	and 3 ; TODO NUM_MOVES

	cp b
	jr nc, .randomMoveLoop

; Not the move we were trying to use.
	cp c
	jr z, .randomMoveLoop

; Make sure it has PP.
	ld [wCurMoveNum], a
	ld hl, wBattleMonPP
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	and $3f
	jr z, .randomMoveLoop

; Use it.
	ld a, [wCurMoveNum]
	ld c, a
	ld b, 0
	ld hl, wBattleMonMoves
	add hl, bc
	ld a, [hl]
	ld [wCurPlayerMove], a

	call SetPlayerTurn
	callba UpdateMoveDataAndDoMove

; Restore original move choice.
	pop af
	ld [wCurMoveNum], a

.endDisobedience
	xor a
	ld [wLastPlayerMove], a
	ld [wLastEnemyCounterMove], a

	; Break Encore too.
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_ENCORED, [hl]
	xor a
	ld [wPlayerEncoreCount], a

	jp EndMoveEffect

IgnoreSleepOnly:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	sub SLEEP_TALK
	and a
	ret nz
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	ret z

; 'ignored orders…sleeping!'
	ld hl, IgnoredSleepingText
	call StdBattleTextBox

	call EndMoveEffect

	scf
	ret
