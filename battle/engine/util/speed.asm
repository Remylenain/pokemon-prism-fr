CheckSpeedWithQuickClaw:
; Does CheckSpeed, but Quick Claw overrides speed
	ldh a, [hBattleTurn]
	push af

	; Figure out what quick claw message if applicable to give first
	call SetPlayerTurn
	call CheckSpeed
	call nz, SetEnemyTurn

	ld d, 0
	call .do_it
	call SwitchTurn
	call .do_it
	pop af
	ldh [hBattleTurn], a
	ld a, d ; +1: player, -1: enemy, 0: both/neither
	and a
	jr z, CheckSpeed
	dec a
	ret
.do_it
	push de
	call GetUserItem
	pop de
	ld a, b
	cp HELD_QUICK_CLAW
	ret nz
	call BattleRandom
	cp c
	ret nc
	push de
	call SwitchTurn
	call ItemRecoveryAnim
	call SwitchTurn
	call GetUserItem
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, BattleText_UserItemLetItMoveFirst
	call StdBattleTextBox
	pop de
	inc d
	ldh a, [hBattleTurn]
	and a
	ret z
	dec d
	dec d
	ret

CheckSpeed:
; Compares speed stat, applying items and stat changes, and see who ends up on top.
; Returns z if player goes first, nz if enemy goes first, randomly on a tie (which also
; sets carry). If Quick Claw checks are relevant, use CheckSpeedWithQuickClaw.
	; Stall overrides everything else here
	ld b, 0
	call GetPlayerAbility
	cp ABILITY_STALL
	jr nz, .no_player_stall
	inc b
.no_player_stall
	call GetEnemyAbility
	cp ABILITY_STALL
	jr nz, .no_enemy_stall
	dec b
.no_enemy_stall
	ld a, b
	dec b
	jr z, .enemy_first
	inc a
	jr z, .player_first

	; Now check in general
	ldh a, [hBattleTurn]
	push af
	call SetPlayerTurn
	call GetSpeed
	push bc
	call SetEnemyTurn
	call GetSpeed
	pop de
	pop af

	; restore turn
	ldh [hBattleTurn], a

	; bc is enemy speed, de player
	ld a, b
	cp d
	jr c, .player_first
	jr nz, .enemy_first
	ld a, c
	cp e
	jr c, .player_first
	jr nz, .enemy_first

	; Speed is equal, so randomize. Account for linking.
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	ld b, 0
	jr z, .secondary_player
	ld b, 1
.secondary_player
	call BattleRandom
	and 1
	xor b
	scf
	ret
.player_first
	xor a
	ret
.enemy_first
	or 1
	ret

GetSpeed:
; Set bc to speed. Stat changes and paralysis has already been taken care of.
; This can be called if an user is fainted, by design and intentionally.
	push hl
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonSpeed
	ld de, wBattleMonItem
	jr z, .got_speed
	ld hl, wEnemyMonSpeed
	ld de, wEnemyMonItem
.got_speed
	ld a, [hli]
	ld b, a
	ld c, [hl]

	; Apply Unburden
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_UNBURDEN, a
	jr z, .unburden_done
	sla b
	rl c
.unburden_done
	ld a, [de]
	cp MACHO_BRACE
	jr nz, .not_macho_brace
	srl b
	rr c
.not_macho_brace

	call GetUserAbility_IgnoreMoldBreaker
	ld hl, .abilities
	ld e, 3
	push bc
	call IsInArray
	pop bc
	call c, CallLocalPointer_AfterIsInArray
	pop hl
	ret

.abilities
	dbw ABILITY_SWIFT_SWIM, .swift_swim
	dbw ABILITY_CHLOROPHYLL, .chlorophyll
	dbw ABILITY_QUICK_FEET, .quick_feet
	db -1

.swift_swim
	ld h, WEATHER_RAIN
	jr .weather_ability
.chlorophyll
	ld h, WEATHER_SUN
.weather_ability
	call GetWeatherAfterAbilities
	cp h
	ret nz
	sla b
	rl c
	ret

.quick_feet
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	ret z
	ld h, b
	ld l, c
	srl b
	rr c
	add hl, bc
	ld b, h
	ld c, l
	ret

SetFastestTurn:
	call CheckSpeed
	jp nz, SetEnemyTurn
	jp SetPlayerTurn
