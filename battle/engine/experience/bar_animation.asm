AnimateExpBar:
	ld hl, wCurPartyMon
	ld a, [wCurBattleMon]
	cp [hl]
	ret nz

	ld a, [wBattleMonLevel]
	cp MAX_LEVEL
	ret nc

	push bc
	ldh a, [hProduct + 3]
	ld [wBattleTempExpPoints + 2], a
	push af
	ldh a, [hProduct + 2]
	ld [wBattleTempExpPoints + 1], a
	push af
	xor a
	ld [wBattleTempExpPoints], a
	assert PARTYMON == 0
	ld [wMonType], a
	predef CopyPkmnToTempMon
	ld a, [wTempMonLevel]
	ld b, a
	ld e, a
	push de
	ld de, wTempMonExp + 2
	push de
	call CalcExpBar
	pop hl
	push bc
	ld a, [wBattleTempExpPoints + 2]
	add [hl]
	ld [hld], a
	ld a, [wBattleTempExpPoints + 1]
	adc [hl]
	ld [hld], a
	jr nc, .no_overflow
	inc [hl]
	jr nz, .no_overflow
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
.no_overflow
	ld d, MAX_LEVEL
	callba CalcExpAtLevel
	ldh a, [hProduct + 1]
	ld b, a
	ldh a, [hProduct + 2]
	ld c, a
	ldh a, [hProduct + 3]
	ld d, a
	ld hl, wTempMonExp + 2
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .already_at_max_exp
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a
.already_at_max_exp
	callba CalcLevel
	ld a, d
	pop bc
	pop de
	ld d, a
	cp e
	jr nc, .level_up_loop
	ld a, e
	ld d, a

.level_up_loop
	ld a, e
	cp MAX_LEVEL
	jr nc, .done_leveling_up
	cp d
	jr z, .done_leveling_up
	inc a
	ld [wTempMonLevel], a
	ld [wCurPartyLevel], a
	ld [wBattleMonLevel], a
	push de
	call .play_exp_bar_sound
	ld c, $48
	call .loop_exp_bar_animation
	call PrintPlayerHUD
	ld hl, wBattleMonNick
	ld de, wStringBuffer1
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	call TerminateExpBarSound
	ld de, SFX_HIT_END_OF_EXP_BAR
	call PlaySFX
	callba AnimateEndOfExpBar
	call WaitSFX
	ld hl, BattleText_StringBuffer1GrewToLevel
	call StdBattleTextBox
	ld de, SFX_DEX_FANFARE_50_79
	call PlayWaitSFX
	pop de
	inc e
	ld b, 0
	jr .level_up_loop

.done_leveling_up
	push bc
	ld b, d
	ld de, wTempMonExp + 2
	call CalcExpBar
	ld a, b
	pop bc
	ld c, a
	call .play_exp_bar_sound
	call .loop_exp_bar_animation
	call TerminateExpBarSound
	pop af
	ldh [hProduct + 2], a
	pop af
	ldh [hProduct + 3], a
	pop bc
	ret

.play_exp_bar_sound
	push bc
	call WaitSFX
	ld de, SFX_EXP_BAR
	call PlaySFX
	ld c, 10
	call DelayFrames
	pop bc
	ret

.loop_exp_bar_animation
	ld d, 3
	dec b
.anim_loop
	inc b
	push bc
	push de
	hlcoord 18, 11
	call PlaceExpBar
	pop de
	call .delay
	pop bc
	ld a, c
	cp b
	jr z, .end_animation
	inc b
	push bc
	push de
	hlcoord 18, 11
	call PlaceExpBar
	pop de
	call .delay
	dec d
	jr nz, .valid_number_of_frames
	inc d
.valid_number_of_frames
	pop bc
	ld a, c
	cp b
	jr nz, .anim_loop
.end_animation
	ld a, 1
	ldh [hBGMapMode], a
	ret

.delay
	xor a
	ldh [hCGBPalUpdate], a
	inc a
	ldh [hBGMapMode], a
	ldh [hBGMapHalf], a
	ld c, d
	call DelayFrames
	xor a
	ldh [hBGMapMode], a
	inc a
	ldh [hCGBPalUpdate], a
	ret
