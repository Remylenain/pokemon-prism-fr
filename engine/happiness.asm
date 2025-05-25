GetFirstPokemonHappiness:
	ld hl, wPartyMon1Happiness
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wPartySpecies
.loop
	ld a, [de]
	cp EGG
	jr nz, .done
	inc de
	add hl, bc
	jr .loop

.done
	ld [wd265], a
	ld a, [hl]
	ldh [hScriptVar], a
	call GetPokemonName
	jp CopyPokemonName_Buffer1_Buffer3

CheckFirstMonIsEgg:
	ld a, [wPartySpecies]
	ld [wd265], a
	cp EGG
	ld a, 1
	jr z, .egg
	xor a

.egg
	ldh [hScriptVar], a
	call GetPokemonName
	jp CopyPokemonName_Buffer1_Buffer3

ChangeHappiness:
; Perform happiness action c on wCurPartyMon

	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	cp EGG
	ret z

	push bc
	ld hl, wPartyMon1Happiness
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	pop bc

	ld d, h ; de = happiness
	ld e, l

	push de
	ld a, [de]
	cp 100
	ld e, 0
	jr c, .ok
	inc e
	cp 200
	jr c, .ok
	inc e

.ok
	dec c
	ld b, 0
	ld hl, .Actions
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, e
	add hl, bc
	pop de ; de = happiness
	bit 7, [hl]
	jr nz, .negative

	push hl
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	call GetItemHeldEffect_IgnoreKlutz
	pop hl
	ld a, b
	cp HELD_FRIENDSHIP_BOOST
	ld a, [hl]
	jr nz, .got_increase
	srl a
	add a, [hl]
.got_increase
	ld c, a
	ld a, [de]
	add a, c
	jr nc, .done
	ld a, $ff
	jr .done

.negative
	ld a, [de]
	add a, [hl]
	jr c, .done
	xor a

.done
	ld [de], a
	ld a, [wBattleMode]
	and a
	ret z
	ld a, [wCurPartyMon]
	ld b, a
	ld a, [wPartyMenuCursor]
	cp b
	ret nz
	ld a, [de]
	ld [wBattleMonHappiness], a
	ret

.Actions
	db  +5,  +3,  +2 ; Gained a level
	db  +5,  +3,  +2 ; Vitamin
	db  +1,  +1,  +0 ; X Item
	db  +3,  +2,  +1 ; Battled a Gym Leader
	db  +1,  +1,  +0 ; Learned a move
	db  -1,  -1,  -1 ; Lost to an enemy
	db  -5,  -5, -10 ; Fainted due to poison
	db  -5,  -5, -10 ; Lost to a much stronger enemy
	db  +1,  +1,  +1 ; Haircut (Y1)
	db  +3,  +3,  +1 ; Haircut (Y2)
	db  +5,  +5,  +2 ; Haircut (Y3)
	db  +1,  +1,  +1 ; Haircut (O1)
	db  +3,  +3,  +1 ; Haircut (O2)
	db +10, +10,  +4 ; Haircut (O3)
	db  -5,  -5, -10 ; Used Heal Powder or Energypowder (bitter)
	db -10, -10, -15 ; Used Energy Root (bitter)
	db -15, -15, -20 ; Used Revival Herb (bitter)
	db  +3,  +3,  +1 ; Grooming
	db +10,  +6,  +4 ; Gained a level in the place where it was caught

StepHappiness::
; Raise the party's happiness by 1 point every other step cycle.

	ld hl, wHappinessStepCount
	ld a, [hl]
	xor 1
	ld [hl], a

	ld de, wPartyCount
	ld a, [de]
	and a
	ret z

	ld hl, wPartyMon1Happiness
.loop
	inc de
	ld a, [de]
	cp EGG
	jr z, .next
	inc a
	ret z
	ld a, [wHappinessStepCount]
	and a
	jr z, .no_soothe_bell_check
	push hl
	ld bc, wPartyMon1Item - wPartyMon1Happiness
	add hl, bc
	call GetItemHeldEffect_IgnoreKlutz
	pop hl
	ld a, b
	cp HELD_FRIENDSHIP_BOOST
	jr nz, .next
.no_soothe_bell_check
	inc [hl]
	jr nz, .next
	dec [hl]

.next
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	jr .loop
