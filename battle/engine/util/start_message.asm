BattleStartMessage:
	ld a, [wBattleMode]
	dec a
	jr z, .wild

	ld de, SFX_SHINE
	call PlayWaitSFX

	ld c, 20
	call DelayFrames

	callba Battle_GetTrainerName

	ld hl, WantsToBattleText
	jr .place_start_text

.wild
	call BattleCheckEnemyShininess
	jr nc, .not_shiny

	xor a
	ld [wNumHits], a
	inc a
	ldh [hBattleTurn], a
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

.not_shiny
	callba CheckSleepingTreeMon
	jr c, .skip_cry

	hlcoord 12, 0
	lb de, 0, ANIM_MON_NORMAL
	predef AnimateFrontpic
	jr .skip_cry ; cry is played during the animation

.cry_no_anim
	call DelayFrame
	ld a, $f
	ld [wCryTracks], a
	ld a, [wTempEnemyMonSpecies]
	call PlayStereoCry

.skip_cry
	ld a, [wBattleType]
	cp BATTLETYPE_FISH
	jr nz, .not_fishing

	ld hl, HookedPokemonAttackedText
	jr .place_start_text

.not_fishing
	ld hl, PokemonFellFromTreeText
	cp BATTLETYPE_TREE
	jr z, .place_start_text
	ld hl, WildPokemonAppearedText

.place_start_text
	push hl
	callba BattleStart_TrainerHuds
	pop hl
	jp StdBattleTextBox
