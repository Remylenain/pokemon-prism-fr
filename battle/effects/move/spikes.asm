BattleCommand_Spikes:
; spikes
	ld hl, wEnemyScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wPlayerScreens
.okay

; Fails if spikes are already down!
	ld a, [hl]
	or $fc ;checks for lower two bits set while saving a byte from and 3; cp 3
	inc a
	jp z, PrintDidntAffectWithMoveAnimDelay

; Nothing else stops it from working.
	inc [hl]
	call AnimateCurrentMove
	ld hl, SpikesText
	jp StdBattleTextBox

BattleCommand_LavaPool:
; lavapool
	ld hl, wEnemyScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wPlayerScreens
.okay
	bit SCREENS_LAVA_POOL, [hl]
	jp nz, PrintDidntAffectWithMoveAnimDelay

	set SCREENS_LAVA_POOL, [hl]
	call AnimateCurrentMove
	ld hl, LavaPoolText
	jp StdBattleTextBox
