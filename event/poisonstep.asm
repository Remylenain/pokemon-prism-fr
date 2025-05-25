DoPoisonStep::
	ld a, [wPartyCount]
	and a
	ret z
	xor a
	ld [wEngineBuffer1], a
	ld [wCurPartyMon], a
.loop_check_poison
	call .DamageMonIfPoisoned
	jr nc, .not_poisoned
	ld hl, wEngineBuffer1
	inc [hl]
.not_poisoned
	ld a, [wPartyCount]
	ld hl, wCurPartyMon
	inc [hl]
	cp [hl]
	jr nz, .loop_check_poison
	ld a, [wEngineBuffer1]
	and a
	ret z
	ld de, SFX_POISON
	call PlaySFX
	ld b, 2
	call LoadPoisonBGPals
	jp DelayFrame

.DamageMonIfPoisoned
; check if mon is poisoned, return if not
	ld a, MON_STATUS
	call GetPartyParam
	and 1 << PSN
	ret z

; check if mon is already fainted, return if so
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld b, a
	ld c, [hl]
	or c
	ret z

; check if mon has poison heal ability, return if so
	push hl
	push bc
	ld hl, wPartySpecies
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurSpecies], a
	ld a, MON_DVS
	call GetPartyParamLocation
	callba CalcMonAbility
	cp ABILITY_POISON_HEAL
	pop bc
	pop hl
	ret z

; do 1 HP damage
	dec bc
	ld a, b
	or c
	ret z ; don't faint the mon or handle poison FX

; set carry and return
	ld a, c
	ld [hld], a
	ld [hl], b
	scf
	ret

LoadPoisonBGPals:
	ldh a, [rSVBK]
	push af
	wbk BANK(wBGPals)
	ld hl, wBGPals
	ld c, $20
.loop
; RGB 31, 21, 28
	ld a, LOW(palred 31 + palgreen 21 + palblue 28)
	ld [hli], a
	ld a, HIGH(palred 31 + palgreen 21 + palblue 28)
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	ld c, 4
	call DelayFrames
	jp UpdateTimePals
