TryToRunAwayFromBattle:
; Run away from battle, with or without item
	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jr z, .always_can_escape
	cp BATTLETYPE_TRAP
	jr z, .never_can_escape
	cp BATTLETYPE_CELEBI
	jr z, .never_can_escape
	cp BATTLETYPE_SHINY
	jr z, .never_can_escape
	cp BATTLETYPE_SUICUNE
.never_can_escape
	jp z, .cant_escape
	call CheckIfInEagulouParkBattle
.always_can_escape
	jp z, .can_escape

	ld a, [wLinkMode]
	and a
	jr nz, .cant_escape_nonzero

	ld a, [wBattleMode]
	dec a
	jp nz, .cant_run_from_trainer

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .cant_escape_nonzero
	ld a, [wPlayerSubStatus2]
	bit SUBSTATUS_FINAL_CHANCE, a
	jr nz, .cant_escape_nonzero

	call CheckEnemyAbilityPreventsEscaping
	jp c, .cant_escape

	ld a, [wPlayerWrapCount]
	and a
.cant_escape_nonzero
	jp nz, .cant_escape

	push hl
	push de
	ld a, [wBattleMonItem]
	ld [wd265], a
	ld b, a
	call GetItemHeldEffect
	ld a, b
	cp HELD_ESCAPE
	pop de
	pop hl
	jr nz, .no_flee_item

	call GetItemName
	jr .flee_using_text

.no_flee_item
	ld a, [wPlayerAbility]
	ld [wd265], a
	cp ABILITY_RUN_AWAY
	jr nz, .no_flee_ability
	call GetAbilityName
.flee_using_text
	call SetPlayerTurn
	ld hl, BattleText_UserFledUsingItsStringBuffer1
	call StdBattleTextBox
	jp .can_escape

.no_flee_ability
	ld a, [wNumFleeAttempts]
	inc a
	ld [wNumFleeAttempts], a

	ld a, [hli]
	ld l, [hl]
	ld h, a

	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld e, a
	ld d, b
; hl = player speed
; de = enemy speed

	push hl
	push de
	call Call_LoadTempTileMapToTileMap
	pop de
	pop hl

; compare hl and de
	ld a, l
	sub e
	ld a, h
	sbc d
	jr nc, .can_escape
; multiply player speed by 32
	add hl, hl ; x2
	add hl, hl ; x4
	add hl, hl ; x8
	add hl, hl ; x16
	add hl, hl ; x32

; store PSpeed*32 into dividend
	ld a, h
	ldh [hDividend], a
	ld a, l
	ldh [hDividend + 1], a

; divide ESpeed by 4
	srl d
	rr e
	srl d
	rr e
	ld a, e
	and a ; prevent division by 0
	jr z, .can_escape
; calculate PSpeed*32/(ESpeed/4)
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ldh a, [hQuotient + 1]
	and a ; player can escape if result is greater than 255
	jr nz, .can_escape
	ld a, [wNumFleeAttempts]
	ld c, a
	ldh a, [hQuotient + 2]
	jr .handle_loop
.loop
	add 30
	jr c, .can_escape
.handle_loop
	dec c
	jr nz, .loop
	ld c, a
	call BattleRandom
	ld b, a
	ld a, c
	cp b
	jr nc, .can_escape
	ld a, 1
	ld [wBattlePlayerAction], a
	ld hl, BattleText_CantEscape
	jr .print_inescapable_text

.cant_escape
	ld hl, BattleText_CantEscape
	jr .print_inescapable_text

.cant_run_from_trainer
	ld a, [wInBattleTowerBattle]
	and 5
	jr nz, .ask_forfeit
.dont_ask_forfeit
	ld hl, BattleText_TheresNoEscapeFromTrainerBattle

.print_inescapable_text
	call StdBattleTextBox
.didnt_flee
	ld a, 1
	ld [wFailedToFlee], a
	call LoadTileMapToTempTileMap
	and a
	ret

.ask_forfeit
	ld hl, BattleText_ForfeitChallenge
	call StdBattleTextBox
	call YesNoBox
	jr c, .didnt_flee

.can_escape
	ld a, [wLinkMode]
	and a
	ld a, DRAW
	jr z, .fled
	call LoadTileMapToTempTileMap
	xor a
	ld [wBattlePlayerAction], a
	ld a, $f
	ld [wCurMoveNum], a
	xor a
	ld [wCurPlayerMove], a
	call LinkBattleSendReceiveAction
	call Call_LoadTempTileMapToTileMap

	; Got away safely
	ld a, [wBattleAction]
	cp BATTLEACTION_FORFEIT
	ld a, DRAW
	jr z, .fled
	dec a
.fled
	ld b, a
	ld a, [wBattleResult]
	and $c0
	add b
	ld [wBattleResult], a
	call StopDangerSound
	ld a, [wInBattleTowerBattle]
	and a
	jr nz, .forfeited
	push de
	ld de, SFX_RUN
	call WaitPlaySFX
	pop de
	call WaitSFX
	ld hl, BattleText_GotAwaySafely
	call StdBattleTextBox
	call WaitSFX
.forfeited
	call LoadTileMapToTempTileMap
	scf
	ret
