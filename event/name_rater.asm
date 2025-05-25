NameRater:
	ld hl, .intro_text
	call PrintText
	call YesNoBox
	jp c, .cancel
	ld hl, .select_mon_text
	call PrintText
	callba SelectMonFromParty
	jr c, .cancel
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	call GetCurNick
	call CheckIfMonIsYourOT
	jr c, .traded
	ld hl, .offer_name_change_text
	call PrintText
	call YesNoBox
	jr c, .cancel
	ld hl, .ask_new_name_text
	call PrintText
	call NameRaterCopyPartyPokemonToTemp

	assert PARTYMON == 0
	xor a
	ld [wMonType], a
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ld [wCurSpecies], a
	call GetBaseData
	ld b, 0
	ld de, wStringBuffer2
	callba _NamingScreen
	call IsNewNameEmpty
	ld hl, .same_name_text
	jr c, .samename
	call CompareNewToOld
	ld hl, .same_name_text
	jr c, .samename
	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld e, l
	ld d, h
	ld hl, wStringBuffer2
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ld hl, .after_renaming_text
.samename
	push hl
	call GetCurNick
	ld hl, .confirm_new_name_text
	call PrintText
	pop hl
.done
	jp PrintText

.egg
	ld hl, .egg_text
	jr .done

.traded
	ld hl, .traded_text
	jr .done

.cancel
	ld hl, .cancel_text
	jr .done

.intro_text
	ctxt "Hello, hello! I'm"
	line "the Name Rater."

	para "I rate the names"
	line "of #mon."

	para "Would you like me"
	line "to rate names?"
	done

.select_mon_text
	ctxt "Which #mon's"
	line "nickname should I"
	cont "rate for you?"
	prompt

.offer_name_change_text
	ctxt "Hm<...> <STRBF1><...>"
	line "That's a fairly"
	cont "decent name."

	para "But, how about a"
	line "slightly better"
	cont "nickname?"

	para "Want me to give it"
	line "a better name?"
	done

.ask_new_name_text
	ctxt "All right. What"
	line "name should we"
	cont "give it, then?"
	prompt

.confirm_new_name_text
	ctxt "All right. This"
	line "#mon is now"
	cont "named <STRBF1>."
	prompt

.after_renaming_text
	ctxt "That's a better"
	line "name than before!"

	para "Well done!"
	done

.same_name_text
	ctxt "It might look the"
	line "same as before,"
	para "but this new name"
	line "is much better!"

	para "Well done!"
	done

.egg_text
	ctxt "Whoa… That's just"
	line "an egg."
	done

.traded_text
	ctxt "Hm<...> <STRBF1>?"
	line "What a great name!"
	cont "It's perfect."

	para "Treat <STRBF1>"
	line "with loving care."
	done

.cancel_text
	ctxt "OK, then. Come"
	line "again sometime."
	done

NameRaterCopyPartyPokemonToTemp:
	push hl
	push de
	push bc
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wTempMon
	call CopyNthStruct
	pop bc
	pop de
	pop hl
	ret

CheckIfMonIsYourOT::
; Checks to see if the partymon loaded in [wCurPartyMon] has the different OT as you.  Returns carry if not.
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld de, wPlayerName
	ld c, NAME_LENGTH
	call StringCmp
	jr nz, .nope

	ld hl, wPartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld de, wPlayerID
	ld c, 2 ; number of bytes in which your ID is stored
	call StringCmp
	jr nz, .nope
	ld a, MON_CAUGHTLOCATION
	call GetPartyParam
	rlca
	ld hl, wPlayerGender
	xor [hl]
	and 1
	ret z
.nope
	scf
	ret

IsNewNameEmpty:
; Checks to see if the nickname loaded in wStringBuffer2 is empty.  If so, return carry.
	ld hl, wStringBuffer2
	ld c, PKMN_NAME_LENGTH - 1
.loop
	ld a, [hli]
	cp "@"
	jr z, .terminator
	cp " "
	jr nz, .nonspace
	dec c
	jr nz, .loop

.terminator
	scf
	ret

.nonspace
	and a
	ret

CompareNewToOld:
; Compares the nickname in wStringBuffer2 to the previous nickname.  If they are the same, return carry.
	ld hl, wPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	push hl
	call GetNicknameLength
	ld b, c
	ld hl, wStringBuffer2
	call GetNicknameLength
	pop hl
	ld a, c
	cp b
	jr nz, .different
	ld de, wStringBuffer2
.loop
	ld a, [de]
	cp "@"
	jr z, .terminator
	cp [hl]
	jr nz, .different
	inc hl
	inc de
	jr .loop

.different
	and a
	ret

.terminator
	scf
	ret

GetNicknameLength:
; Gets the length of the name starting at hl and returns it in c.
	ld c, 0
.loop
	ld a, [hli]
	cp "@"
	ret z
	inc c
	ld a, c
	cp PKMN_NAME_LENGTH - 1
	jr nz, .loop
	ret
