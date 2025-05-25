	const_def
	const DAYCARETEXT_CHICK_INTRO
	const DAYCARETEXT_CHICK_EGG
	const DAYCARETEXT_DUDE_INTRO
	const DAYCARETEXT_DUDE_EGG
	const DAYCARETEXT_WHICH_ONE
	const DAYCARETEXT_DEPOSIT
	const DAYCARETEXT_CANT_BREED_EGG
	const DAYCARETEXT_LAST_MON
	const DAYCARETEXT_LAST_ALIVE_MON
	const DAYCARETEXT_COME_BACK_LATER
	const DAYCARETEXT_CANT_ACCEPT_THIS
	const DAYCARETEXT_GENIUSES
	const DAYCARETEXT_ASK_WITHDRAW
	const DAYCARETEXT_WITHDRAW
	const DAYCARETEXT_GOT_BACK_MON
	const DAYCARETEXT_TOO_SOON
	const DAYCARETEXT_PARTY_FULL
	const DAYCARETEXT_NOT_ENOUGH_MONEY
	const DAYCARETEXT_OH_FINE
	const DAYCARETEXT_COME_AGAIN
	const DAYCARETEXT_CHICK_EGG_EXISTS
	const DAYCARETEXT_DUDE_EGG_EXISTS

Special_DayCareMan:
	ld a, DAYCARETEXT_CHICK_EGG_EXISTS
	call TryPrintingEggExistsMessage
	ret nz
	ld hl, wDaycareMan
	bit 0, [hl]
	jr nz, .AskWithdrawMon
	ld a, DAYCARETEXT_CHICK_INTRO
	call DayCareCoupleIntroText
	jr c, .cancel
	call DayCareAskDepositPokemon
	jr c, .print_text
	callba DepositMonWithDaycareMan
	ld hl, wDaycareMan
	set 0, [hl]
	call DayCare_DepositPokemonText
	jp DayCare_InitBreeding

.AskWithdrawMon
	callba GetBreedMon1LevelGrowth
	ld hl, wBreedMon1Nick
	call GetPriceToRetrieveBreedmon
	call DayCare_AskWithdrawBreedMon
	jr c, .print_text
	callba RetrievePokemonFromDaycareMan
	call DayCare_TakeMoney_PlayCry
	ld hl, wDaycareMan
	res 0, [hl]
	res 5, [hl]
	jr .cancel

.print_text
	call PrintDayCareText

.cancel
	ld a, DAYCARETEXT_COME_AGAIN
	jp PrintDayCareText

Special_DayCareLady:
	ld a, DAYCARETEXT_DUDE_EGG_EXISTS
	call TryPrintingEggExistsMessage
	ret nz
	ld hl, wDaycareLady
	bit 0, [hl]
	jr nz, .AskWithdrawMon
	ld a, DAYCARETEXT_DUDE_INTRO
	call DayCareCoupleIntroText
	jr c, .cancel
	call DayCareAskDepositPokemon
	jr c, .print_text
	callba DepositMonWithDaycareLady
	ld hl, wDaycareLady
	set 0, [hl]
	call DayCare_DepositPokemonText
	jp DayCare_InitBreeding

.AskWithdrawMon
	callba GetBreedMon2LevelGrowth
	ld hl, wBreedMon2Nick
	call GetPriceToRetrieveBreedmon
	call DayCare_AskWithdrawBreedMon
	jr c, .print_text
	callba RetrievePokemonFromDaycareLady
	call DayCare_TakeMoney_PlayCry
	ld hl, wDaycareLady
	res 0, [hl]
	ld hl, wDaycareMan
	res 5, [hl]
	jr .cancel

.print_text
	call PrintDayCareText

.cancel
	ld a, DAYCARETEXT_COME_AGAIN
	jp PrintDayCareText

DayCareCoupleIntroText:
	bit 7, [hl]
	jr nz, .okay
	inc a
	set 7, [hl]
.okay
	call PrintDayCareText
	jp YesNoBox

TryPrintingEggExistsMessage:
	ld hl, wDaycareMan
	bit 6, [hl]
	ret z
	call PrintDayCareText
	ld a, 1
	and a
	ret

DayCareAskDepositPokemon:
	ld a, [wPartyCount]
	cp 2
	jr c, .OnlyOneMon
	ld a, DAYCARETEXT_WHICH_ONE
	call PrintDayCareText
	ld b, 6
	callba SelectTradeOrDaycareMon
	jr c, .Declined
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .Egg
	callba CheckForSpecialGiftMon
	jr c, .specialGiftMon
	callba CheckIfOnlyAliveMonIsCurPartyMon
	jr c, .OutOfUsableMons
	ld hl, wPartyMonNicknames
	ld a, [wCurPartyMon]
	call GetNick
	and a
	ret

.Declined
	ld a, DAYCARETEXT_OH_FINE
	scf
	ret

.Egg
	ld a, DAYCARETEXT_CANT_BREED_EGG
	scf
	ret

.OnlyOneMon
	ld a, DAYCARETEXT_LAST_MON
	scf
	ret

.OutOfUsableMons
	ld a, DAYCARETEXT_LAST_ALIVE_MON
	scf
	ret

.specialGiftMon
	ld a, DAYCARETEXT_CANT_ACCEPT_THIS
	scf
	ret

DayCare_DepositPokemonText:
	ld a, DAYCARETEXT_DEPOSIT
	call PrintDayCareText
	ld a, [wCurPartySpecies]
	call PlayCry
	ld a, DAYCARETEXT_COME_BACK_LATER
	jp PrintDayCareText

DayCare_AskWithdrawBreedMon:
	ld a, [wStringBuffer2 + 1]
	and a
	jr nz, .grew_at_least_one_level
	ld a, DAYCARETEXT_TOO_SOON
	call PrintDayCareText
	call YesNoBox
	jr c, .refused
	jr .check_money

.grew_at_least_one_level
	ld a, DAYCARETEXT_GENIUSES
	call PrintDayCareText
	call YesNoBox
	jr c, .refused
	ld a, DAYCARETEXT_ASK_WITHDRAW
	call PrintDayCareText
	call YesNoBox
	jr c, .refused

.check_money
	ld de, wMoney
	ld bc, wStringBuffer2 + 2
	callba CompareMoney
	jr c, .not_enough_money
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nc, .PartyFull
	and a
	ret

.refused
	ld a, DAYCARETEXT_OH_FINE
	scf
	ret

.not_enough_money
	ld a, DAYCARETEXT_NOT_ENOUGH_MONEY
	scf
	ret

.PartyFull
	ld a, DAYCARETEXT_PARTY_FULL
	scf
	ret

DayCare_TakeMoney_PlayCry:
	ld bc, wStringBuffer2 + 2
	ld de, wMoney
	callba TakeMoney
	ld a, DAYCARETEXT_WITHDRAW
	call PrintDayCareText
	ld a, [wCurPartySpecies]
	call PlayCry
	ld a, DAYCARETEXT_GOT_BACK_MON
	jp PrintDayCareText

GetPriceToRetrieveBreedmon:
	ld a, b
	ld [wStringBuffer2], a
	ld a, d
	ld [wStringBuffer2 + 1], a
	ld de, wStringBuffer1
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld hl, 0
	ld bc, 100
	ld a, [wStringBuffer2 + 1]
	rst AddNTimes
	ld de, 100
	add hl, de
	xor a
	ld [wStringBuffer2 + 2], a
	ld a, h
	ld [wStringBuffer2 + 3], a
	ld a, l
	ld [wStringBuffer2 + 4], a
	ret

PrintDayCareText:
	ld e, a
	ld d, 0
	ld hl, .TextTable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

.TextTable
	dw .DayCareChickIntro ; DAYCARETEXT_CHICK_INTRO
	dw .DayCareChickExplainEggs ; DAYCARETEXT_CHICK_EGG
	dw .DayCareDudeIntro ; DAYCARETEXT_DUDE_INTRO
	dw .DayCareDudeExplainEggs ; DAYCARETEXT_DUDE_EGG
	dw .WhichOne ; DAYCARETEXT_WHICH_ONE
	dw .Deposited ; DAYCARETEXT_DEPOSIT
	dw .CantAcceptEgg ; DAYCARETEXT_CANT_BREED_EGG
	dw .JustOneMon ; DAYCARETEXT_LAST_MON
	dw .LastHealthyMon ; DAYCARETEXT_LAST_ALIVE_MON
	dw .ComeBackForItLater ; DAYCARETEXT_COME_BACK_LATER
	dw .CantAcceptThis ; DAYCARETEXT_CANT_ACCEPT_THIS
	dw .AreWeGeniusesOrWhat ; DAYCARETEXT_GENIUSES
	dw .AskRetrieveMon ; DAYCARETEXT_ASK_WITHDRAW
	dw .PerfectHeresYourMon ; DAYCARETEXT_WITHDRAW
	dw .GotBackMon ; DAYCARETEXT_GOT_BACK_MON
	dw .ImmediatelyWithdrawMon ; DAYCARETEXT_TOO_SOON
	dw .PartyFull ; DAYCARETEXT_PARTY_FULL
	dw .NotEnoughMoney ; DAYCARETEXT_NOT_ENOUGH_MONEY
	dw .OhFineThen ; DAYCARETEXT_OH_FINE
	dw .ComeAgain ; DAYCARETEXT_COME_AGAIN
	dw .DayCareChickFoundEgg ; DAYCARETEXT_CHICK_EGG_EXISTS
	dw .DayCareDudeFoundEgg ; DAYCARETEXT_DUDE_EGG_EXISTS

.DayCareChickIntro
	ctxt "What's happening?"

	para "I am the cool Day-"
	line "Care Chick!"

	para "Need me to raise a"
	line "#mon for you?"
	done

.DayCareChickExplainEggs
	ctxt "What's happening?"

	para "I am the cool Day-"
	line "Care Chick!"

	para "Did you know?"

	para "Sometimes, if you"
	line "leave two #mon"
	para "together, an Egg"
	line "will appear!"

	para "Fascinating, huh?"

	para "So, want me to"
	line "raise one of your"
	cont "#mon?"
	done

.DayCareDudeIntro
	ctxt "Hey, man."

	para "It's me, the Day-"
	line "Care Dude."

	para "Wanna let me raise"
	line "a #mon for you?"
	done

.DayCareDudeExplainEggs
	ctxt "It's me, the Day-"
	line "Care Dude!"

	para "Did you know that,"
	line "if two #mon are"
	para "left alone, an Egg"
	line "will appear?"

	para "Miracle of nature!"

	para "Should I raise a"
	line "#mon for you?"
	done

.WhichOne
	ctxt "What should I"
	line "raise for you?"
	prompt

.JustOneMon
	ctxt "Oh? But you have"
	line "just one #mon."
	prompt

.CantAcceptEgg
	ctxt "Sorry, but I can't"
	line "accept an Egg."
	prompt

.CantAcceptThis
	ctxt "Sorry, but I can't"
	line "accept this"
	cont "#mon."
	prompt

.LastHealthyMon
	ctxt "If you give me"
	line "that, what will"
	cont "you battle with?"
	prompt

.Deposited
	ctxt "OK. I'll raise your"
	line "<STRBF1>."
	prompt

.ComeBackForItLater
	ctxt "Come back for it"
	line "later."
	done

.AreWeGeniusesOrWhat
	ctxt "Are we geniuses or"
	line "what? Want to see"
	cont "your <STRBF1>?"
	done

.AskRetrieveMon
	ctxt "Your <STRBF1>"
	line "has grown a lot."

	para "By level, it's"
	line "grown by @"
	deciram wStringBuffer2 + 1, 1, 3
	ctxt "."

	para "If you want your"
	line "#mon back, it"
	cont "will cost ¥@"
	deciram wStringBuffer2 + 2, 3, 4
	ctxt "."
	done

.PerfectHeresYourMon
	ctxt "Perfect! Here's"
	line "your #mon."
	prompt

.GotBackMon
	ctxt "<PLAYER> got back"
	line "<STRBF1>."
	prompt

.ImmediatelyWithdrawMon
	ctxt "Huh? Back already?"
	line "Your <STRBF1>"
	para "needs a little"
	line "more time with us."

	para "If you want your"
	line "#mon back, it"
	cont "will cost ¥100."
	done

.PartyFull
	ctxt "You have no room"
	line "for it."
	prompt

.NotEnoughMoney
	ctxt "You don't have"
	line "enough money."
	prompt

.OhFineThen
	ctxt "Oh, fine then."
	prompt

.ComeAgain
	ctxt "Come again."
	done

.DayCareChickFoundEgg
	ctxt "Hey, guess what we"
	line "found in the"
	cont "garden?"

	para "That's right!"

	para "We found an Egg!"

	para "You should take a"
	line "look outside for"
	cont "yourself!"
	done

.DayCareDudeFoundEgg
	ctxt "It's amazing!"

	para "Right in the"
	line "garden, we found"
	cont "an Egg!"

	para "It just suddenly"
	line "appeared like that"
	cont "out of nowhere!"

	para "Just see for"
	line "yourself!"
	done

Special_DayCareManOutside:
	ld hl, wDaycareMan
	bit 6, [hl]
	jr nz, .AskGiveEgg
	ld hl, .no_egg_text
	jp PrintText

.AskGiveEgg
	ld hl, .egg_text
	call PrintText
	call YesNoBox
	jr c, .Declined
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nc, .PartyFull
	call DayCare_GiveEgg
	ld hl, wDaycareMan
	res 6, [hl]
	call DayCare_InitBreeding
	ld hl, .GotEggText
	call PrintText
	ld de, SFX_GET_EGG_FROM_DAYCARE_LADY
	call PlaySFX
	ld c, 120
	call DelayFrames
	xor a
	ldh [hScriptVar], a
	ret

.Declined
	ld hl, .prompt_discard_text
	call PrintText
	call YesNoBox
	ld hl, .left_behind_text
	jr c, .PrintAndFail
	ld hl, .discarded_text
	call PrintText
	xor a
	ldh [hScriptVar], a
	ret

.PartyFull
	ld hl, .party_full_text
.PrintAndFail
	call PrintText
	ld a, 1
	ldh [hScriptVar], a
	ret

.no_egg_text
	ctxt "Not yet<...>"
	done

.egg_text
	ctxt "Wow, it's an Egg!"

	para "Do you want to"
	line "take it?"
	done

.GotEggText
	ctxt "<PLAYER> received"
	line "the Egg!"
	done

.discarded_text
	ctxt "The Egg was left"
	line "for the Day-Care"
	cont "Couple to pick up."
	done

.party_full_text
	ctxt "You have no room"
	line "in your party."
	cont "Come back later."
	done

.prompt_discard_text
	ctxt "Do you want to"
	line "leave the Egg for"
	para "the Day-Care"
	line "Couple?"
	done

.left_behind_text
	ctxt "The Egg was left"
	line "in the garden."
	done

DayCare_GiveEgg:
	ld a, [wEggMonLevel]
	ld [wCurPartyLevel], a
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nc, .PartyFull
	inc a
	ld [hl], a

	ld c, a
	ld b, 0
	add hl, bc
	ld a, EGG
	ld [hli], a
	ld a, [wEggMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	ld a, -1
	ld [hl], a

	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call DayCare_GetCurrentPartyMember
	ld hl, wEggNick
	rst CopyBytes

	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call DayCare_GetCurrentPartyMember
	ld hl, wEggOT
	rst CopyBytes

	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	call DayCare_GetCurrentPartyMember
	ld hl, wEggMon
	ld bc, wEggMonEnd - wEggMon
	rst CopyBytes

	call GetBaseData
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld b, h
	ld c, l
	ld hl, MON_ID + 1
	add hl, bc
	push hl
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push bc
	ld b, 0
	predef CalcPkmnStats
	pop bc
	ld hl, MON_HP
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	and a
	ret

.PartyFull
	scf
	ret

DayCare_GetCurrentPartyMember:
	ld a, [wPartyCount]
	dec a
	rst AddNTimes
	ld d, h
	ld e, l
	ret

DayCare_InitBreeding:
	ld a, [wDaycareLady]
	bit 0, a
	ret z
	ld a, [wDaycareMan]
	bit 0, a
	ret z
	callba CheckBreedmonCompatibility
	and a
	ret z
	inc a
	ret z
	ld hl, wDaycareMan
	set 5, [hl]
.loop
	call Random
	cp 150
	jr c, .loop
	ld [wStepsToEgg], a

	xor a
	ld hl, wEggMon
	ld bc, wEggMonEnd - wEggMon
	call ByteFill
	ld hl, wEggNick
	ld bc, PKMN_NAME_LENGTH
	call ByteFill
	ld hl, wEggOT
	ld bc, NAME_LENGTH
	call ByteFill
	ld a, [wBreedMon1DVs]
	ld [wTempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [wTempMonDVs + 1], a
	ld a, [wBreedMon1Species]
	ld [wCurPartySpecies], a
	ld a, 3
	ld [wMonType], a
	ld a, [wBreedMon1Species]
	cp DITTO
	ld a, 1
	jr z, .LoadWhichBreedmonIsTheMother
	ld a, [wBreedMon2Species]
	cp DITTO
	ld a, 0
	jr z, .LoadWhichBreedmonIsTheMother
	callba GetGender
	ld a, 0
	jr z, .LoadWhichBreedmonIsTheMother
	inc a

.LoadWhichBreedmonIsTheMother
	ld [wBreedMotherOrNonDitto], a
	and a
	ld a, [wBreedMon1Species]
	jr z, .GotMother
	ld a, [wBreedMon2Species]

.GotMother
	ld [wCurPartySpecies], a
	callba GetEggSpecies
	ld a, EGG_LEVEL
	ld [wCurPartyLevel], a

; Illumise and Volbeat can have eggs of either species
	ld a, [wCurPartySpecies]
	cp ILLUMISE
	jr z, .illumise_or_volbeat
	cp VOLBEAT
	jr nz, .got_species
.illumise_or_volbeat
	call Random
	add a, a
	; a = carry ? VOLBEAT : ILLUMISE
	assert VOLBEAT == ILLUMISE - 1
	sbc a
	add ILLUMISE
.got_species
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	ld [wEggMonSpecies], a

	call GetBaseData
	ld hl, wEggNick
	ld de, .String_EGG
	call CopyName2
	ld hl, wPlayerName
	ld de, wEggOT
	ld bc, NAME_LENGTH
	rst CopyBytes
	xor a
	ld [wEggMonItem], a
	ld de, wEggMonMoves
	xor a
	ld [wFillMoves_IsPartyMon], a
	predef FillMoves
	callba InitEggMoves
	ld hl, wEggMonID
	ld a, [wPlayerID]
	ld [hli], a
	ld a, [wPlayerID + 1]
	ld [hl], a
	ld a, [wCurPartyLevel]
	ld d, a
	callba CalcExpAtLevel
	ld hl, wEggMonExp
	ldh a, [hMultiplicand]
	ld [hli], a
	ldh a, [hMultiplicand + 1]
	ld [hli], a
	ldh a, [hMultiplicand + 2]
	ld [hl], a
	xor a
	ld b, wEggMonDVs - wEggMonStatExp
	ld hl, wEggMonStatExp
.loop2
	ld [hli], a
	dec b
	jr nz, .loop2
	ld hl, wEggMonDVs
	call Random
	ld [hli], a
	ld [wTempMonDVs], a
	call Random
	ld [hld], a
	ld [wTempMonDVs + 1], a
	ld de, wBreedMon1DVs
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .GotDVs
	ld de, wBreedMon2DVs
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .GotDVs
	ld a, BREEDMON
	ld [wMonType], a
	push hl
	callba GetGender
	pop hl
	ld de, wBreedMon1DVs
	ld bc, wBreedMon2DVs
	jr c, .SkipDVs
	jr z, .ParentCheck2
	ld a, [wBreedMotherOrNonDitto]
	and a
	jr z, .GotDVs
	ld d, b
	ld e, c
	jr .GotDVs

.ParentCheck2
	ld a, [wBreedMotherOrNonDitto]
	and a
	jr nz, .GotDVs
	ld d, b
	ld e, c

.GotDVs
	ld a, [de]
	inc de
	and $f
	ld b, a
	ld a, [hl]
	and $f0
	add b
	ld [hli], a
	ld a, [de]
	and 7
	ld b, a
	ld a, [hl]
	and $f8
	add b
	ld [hl], a

.SkipDVs
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld hl, wEggMonMoves
	ld de, wEggMonPP
	predef FillPP
	ld hl, wMonOrItemNameBuffer
	ld de, wStringBuffer1
	ld bc, NAME_LENGTH
	rst CopyBytes
	ld a, [wBaseEggSteps]
	ld hl, wEggMonHappiness
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, [wCurPartyLevel]
	ld [wEggMonLevel], a
	ret

.String_EGG
	db "Egg@"
