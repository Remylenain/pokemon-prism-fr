CalcMonAbility::
	; species in [wCurSpecies]
	; DV pointer in hl
	push bc
	push de
	call GetMonAbilities ; preserves hl
	; Determine the parity of the DVs
	; Use the DVs to determine which of the two abilities to use.
	ld b, 2
	call CountSetBits

CalcMonAbility_Done:
	rra
	ld hl, wBaseAbilities ; First 2 bytes of the 4-byte padding
	jr nc, .load
	inc hl
.load
	ld a, [hl]
	pop de
	pop bc
	ret

CalcTrainerMonAbility::
	; trainer mons' abilities are defined by StableRandom, to produce some level of variation
	; input state: species, trainer class, level, trainer ID, party position (high nibble) + size (low nibble), atk/def DV, spd/spc DV, first move
	; roll five times and keep low byte of result
	push de
	push bc
	call GetMonAbilities ; preserves hl
	ld a, [hli]
	ld b, a
	ld e, [hl]
	ld a, [wEnemyMonMoves]
	ld d, a
	ld a, [wCurOTMon]
	ld c, a
	swap c
	ld a, [wOTPartyCount]
	add a, c
	ld c, a
	push de
	push bc
	ld a, [wOtherTrainerClass]
	ld b, a
	ld a, [wOtherTrainerID]
	ld d, a
	ld a, [wEnemyMonLevel]
	ld e, a
	ld a, [wEnemyMonSpecies]
	ld c, a
	push de
	push bc
	ld hl, sp + 0
	ld c, 5
.loop
	callba StableRandom
	dec c
	jr nz, .loop
	add sp, 8
	jr CalcMonAbility_Done

GetMonAbilities:
	push hl
	; note: the below "- (BaseData1 - BaseData0)" term accounts for the fact that species is 1-based but base data is 0-based. DO. NOT. REMOVE. IT.
	ld hl, BaseData + (wBaseAbilities - wCurBaseData) - (BaseData1 - BaseData0)
	ld bc, BaseData1 - BaseData0
	ld a, [wCurSpecies]
	rst AddNTimes
	ld a, [hli]
	ld [wBaseAbility1], a
	ld a, [hl]
	ld [wBaseAbility2], a
	pop hl
	ret
