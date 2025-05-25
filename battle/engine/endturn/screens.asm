EndTurn_Safeguard:
	call CheckSpeed
	jr z, .player_first
	call .CheckEnemy
.CheckPlayer
	ld a, [wPlayerScreens]
	bit SCREENS_SAFEGUARD, a
	ret z
	ld hl, wPlayerSafeguardCount
	dec [hl]
	ret nz
	res SCREENS_SAFEGUARD, a
	ld [wPlayerScreens], a
	xor a
	jr .print

.player_first
	call .CheckPlayer
.CheckEnemy
	ld a, [wEnemyScreens]
	bit SCREENS_SAFEGUARD, a
	ret z
	ld hl, wEnemySafeguardCount
	dec [hl]
	ret nz
	res SCREENS_SAFEGUARD, a
	ld [wEnemyScreens], a
	ld a, 1

.print
	ldh [hBattleTurn], a
	ld hl, BattleText_SafeguardFaded
	jp StdBattleTextBox

EndTurn_Screens:
	call CheckSpeed
	jr z, .player_first
	call .CheckEnemy
.CheckPlayer
	call SetPlayerTurn
	ld de, .Your
	call .Copy
	ld hl, wPlayerScreens
	ld de, wPlayerLightScreenCount
	jr .TickScreens

.player_first
	call .CheckPlayer
.CheckEnemy
	call SetEnemyTurn
	ld de, .Enemy
	call .Copy
	ld hl, wEnemyScreens
	ld de, wEnemyLightScreenCount

.TickScreens
	bit SCREENS_LIGHT_SCREEN, [hl]
	call nz, .LightScreenTick
	bit SCREENS_REFLECT, [hl]
	ret z
.ReflectTick
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_REFLECT, [hl]
	ld hl, BattleText_PkmnReflectFaded
	jp StdBattleTextBox

.Copy
	ld hl, wStringBuffer1
	jp CopyName2

.Your
	db "Your@"
.Enemy
	db "Enemy@"

.LightScreenTick
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_LIGHT_SCREEN, [hl]
	push hl
	push de
	ld hl, BattleText_PkmnLightScreenFell
	call StdBattleTextBox
	pop de
	pop hl
	ret
