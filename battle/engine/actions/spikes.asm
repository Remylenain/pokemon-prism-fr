SpikesDamage_CheckMoldBreaker:
; Called when a Pokémon with Mold Breaker uses Roar/Whirlwind. This
; is neccessary because it negates Levitate but can't be checked
; unconditionally since other kind of switches ignore MB as usual.
	call GetUserAbility
	jr SpikesDamage_GotUserAbility
SpikesDamage:
	call GetUserAbility_IgnoreMoldBreaker
SpikesDamage_GotUserAbility:
	cp ABILITY_LEVITATE
	ret z
	ld hl, wPlayerScreens
	ld de, wBattleMonType
	ld bc, UpdatePlayerHUD
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyScreens
	ld de, wEnemyMonType
	ld bc, UpdateEnemyHUD
.ok
	bit SCREENS_LAVA_POOL, [hl]
	jr z, .spikes
	push hl
	push de
	push bc

	ld a, [de]
	cp FIRE
	jr z, .no_pool
	cp FLYING
	jr z, .no_pool
	inc de
	ld a, [de]
	cp FIRE
	jr z, .no_pool
	cp FLYING
	jr z, .no_pool

	call GetUserItem
	ld a, b
	cp HELD_PREVENT_BURN
	jr z, .no_pool

	callba SafeCheckSafeguard
	jr nz, .no_pool

	; already statused
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	jr nz, .no_pool

	; Lava Pool residual animation
	call SwitchTurn
	ld de, LAVA_POOL
	ld a, 1
	ld [wBattleAnimParam], a
;	xor a
;	ld [wNumHits], a
	call Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn

	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	set BRN, [hl]
	call UpdateUserInParty
	call ApplyBrnEffectOnAttack
	ld de, ANIM_BRN
	call Call_PlayBattleAnim_OnlyIfVisible

	ld hl, BattleText_UserBurnedByLavaPool
	call StdBattleTextBox

	pop hl
	push hl
	call _hl_
	call ApplyTilemapInVBlank

.no_pool
	pop bc
	pop de
	pop hl
.spikes
	ld a, [hl]
	and 3
	ret z

	; Flying-types aren't affected by Spikes.
	ld a, [de]
	cp FLYING
	ret z
	inc de
	ld a, [de]
	cp FLYING
	ret z

	ld a, [hl]
	and 3

	push bc
	push af

	ld hl, BattleText_UserHurtBySpikes ; "hurt by SPIKES!"
	call StdBattleTextBox

	pop af
	add a
	cpl
	add 11
	ldh [hDivisor], a
	call GetMaxHP
	ld a, b
	ldh [hDividend], a
	ld a, c
	ldh [hDividend + 1], a
	ld b, 2
	predef Divide
	ldh a, [hQuotient + 1]
	ld b, a
	ldh a, [hQuotient + 2]
	ld c, a
	or b
	jr nz, .damage
	inc c
.damage
	call SubtractHPFromUser

	pop hl
	call _hl_

	jp ApplyTilemapInVBlank
