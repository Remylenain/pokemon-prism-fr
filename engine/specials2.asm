SpecialGiveNobusAggron:
; Adding to the party.
	xor a
	ld [wMonType], a

; Nobu's Aggron
	ld a, AGGRON
	ld [wCurPartySpecies], a
	ld a, 40
	ld [wCurPartyLevel], a

	predef TryAddMonToParty
	jr nc, .NotGiven

; Caught data.
	ld b, 0
	callba SetGiftPartyMonCaughtData

; Holding a Metal Coat.
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wPartyCount]
	dec a
	push af
	push bc
	ld hl, wPartyMon1Item
	rst AddNTimes
	ld [hl], METAL_COAT
	pop bc
	pop af

; OT ID.
	ld hl, wPartyMon1ID
	rst AddNTimes
	ld a, HIGH(00518)
	ld [hli], a
	ld [hl], LOW(00518)

; Nickname.
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld de, SpecialAggronNick
	call CopyName2

; OT.
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonOT
	call SkipNames
	ld de, SpecialAggronOT
	call CopyName2
	ld [hl], "F"

; Engine flag for this event.
	ld hl, wDailyFlags
	set 5, [hl]
; setflag ENGINE_SHUCKLE_GIVEN
	ld a, 1
	ldh [hScriptVar], a
	ret

.NotGiven
	xor a
	ldh [hScriptVar], a
	ret

SpecialAggronOT:
	db "Nobu@F"
SpecialAggronOTEnd:

SpecialAggronNick:
	db "Aggron@"

SpecialReturnNobusAggron:
	call _SpecialReturnNobusAggron
	ldh [hScriptVar], a
	ret

_SpecialReturnNobusAggron:
	callba SelectMonFromParty
	ld a, 1
	ret c ; refused

	ld a, [wCurPartySpecies]
	cp AGGRON
	jr nz, .DontReturn

	ld a, [wCurPartyMon]
	ld hl, wPartyMon1ID
	call GetPartyLocation

; OT ID
	ld a, [hli]
	cp HIGH(00518)
	jr nz, .DontReturn
	ld a, [hl]
	cp LOW(00518)
	jr nz, .DontReturn

; OT
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	call SkipNames
	ld de, SpecialAggronOT
	ld c, SpecialAggronOTEnd - SpecialAggronOT
	call StringCmp
	jr nz, .DontReturn ; not the correct mon
	callba CheckIfOnlyAliveMonIsCurPartyMon
	ld a, 3 ; fainted
	ret c
	xor a ; take from party
	ld [wPokemonWithdrawDepositParameter], a
	callba RemoveMonFromPartyOrBox
	ld a, 2 ; gave aggron back
	ret

.DontReturn
	xor a
	ret

Special_SelectMonFromParty::
	callba SelectMonFromParty
	jr c, .cancel
	callba CheckForSpecialGiftMon
	ld a, $ff
	jr c, .specialGiftMon
	ld a, [wCurPartySpecies]
	ldh [hScriptVar], a
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	jp CopyPokemonName_Buffer1_Buffer3

.cancel
	xor a
.specialGiftMon
	ldh [hScriptVar], a
	ret

Special_YoungerHaircutBrother:
	ld hl, Data_YoungerHaircutBrother
	jr MassageOrHaircut

Special_OlderHaircutBrother:
	ld hl, Data_OlderHaircutBrother

MassageOrHaircut:
	push hl
	callba SelectMonFromParty
	pop hl
	jr c, .nope
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	push hl
	call GetCurNick
	call CopyPokemonName_Buffer1_Buffer3
	pop hl
	call RandomPercentage
.loop
	sub [hl]
	jr c, .ok
	inc hl
	inc hl
	inc hl
	jr .loop

.ok
	inc hl
	ld a, [hli]
	ldh [hScriptVar], a
	ld c, [hl]
	jp ChangeHappiness

.nope
	xor a
	ldh [hScriptVar], a
	ret

.egg
	ld a, 1
	ldh [hScriptVar], a
	ret

Data_YoungerHaircutBrother:
	db 30, 2, HAPPINESS_YOUNGCUT1 ; 30% chance
	db 20, 3, HAPPINESS_YOUNGCUT2 ; 20% chance
	db 50, 4, HAPPINESS_YOUNGCUT3 ; 50% chance

Data_OlderHaircutBrother:
	db 60, 2, HAPPINESS_OLDERCUT1 ; 60% chance
	db 10, 3, HAPPINESS_OLDERCUT2 ; 10% chance
	db 30, 4, HAPPINESS_OLDERCUT3 ; 30% chance

CopyPokemonName_Buffer1_Buffer3:
	ld hl, wStringBuffer1
	ld de, wStringBuffer3
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret
