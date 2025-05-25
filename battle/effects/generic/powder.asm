BattleCommand_CheckPowder:
	ld a, [wAttackMissed]
	and a
	ret nz
	call PowderCheck
	ret nc
	ld a, 1
	ld [wAttackMissed], a
	ret

PowderCheck:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	ld hl, PowderMoves
.loop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr nz, .loop
; check for safety goggles
CheckForSafetyGoggles:
	call GetOpponentItem
	ld a, b
	cp HELD_SAFE_GOGGLES
	jp nz, CheckForGrassTyping
	scf
	ret
CheckForGrassTyping:
	ld hl, wEnemyMonType
	ldh a, [hBattleTurn]
	and a
	jr z, .got_type
	ld hl, wBattleMonType
.got_type
	ld a, [hli]
	cp GRASS
	jr z, .grass
	ld a, [hl]
	cp GRASS
	jr z, .grass
	and a
	ret

.grass
	scf
	ret

PowderMoves:
	db COTTON_SPORE
	db POISONPOWDER
	db SLEEP_POWDER
	db STUN_SPORE
	db $ff
