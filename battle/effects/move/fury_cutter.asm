BattleCommand_FuryCutter:
	ld hl, wPlayerFuryCutterCount
	ldh a, [hBattleTurn]
	and a
	jr z, .go
	ld hl, wEnemyFuryCutterCount

.go
	ld a, [wAttackMissed]
	and a
	jr nz, ResetFuryCutterCount

	inc [hl]

; Damage capped at 3 turns' worth (4x).
	ld a, [hl]
	cp 4
	jr c, .double
	ld a, 3
	ld [hl], a

.double
	dec a
	ld hl, wCurDamageShiftCount
	add a, [hl]
	ld [hl], a
	jp SetDamageDirtyFlag

ResetFuryCutterCount:
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	xor a
	ld [wEnemyFuryCutterCount], a
	ret

.player
	; a = 0 here
	ld [wPlayerFuryCutterCount], a
	ret
