MoveDeletion:
	ld hl, .IntroText
	call PrintText
	call YesNoBox
	jr c, .declined
	ld hl, .AskWhichMonText
	call PrintText
	callba SelectMonFromParty
	jr c, .declined
	ld a, [wCurPartySpecies]
	cp EGG
	ld hl, .EggText
	jr z, .print_text_and_exit
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Moves + 1
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	ld a, [hl]
	and a
	ld hl, .OnlyOneMoveText
	jr z, .print_text_and_exit
	ld hl, .AskWhichMoveText
	call PrintText
	call LoadStandardMenuHeader
	callba ChooseMoveToDelete
	push af
	call ReturnToMapWithSpeechTextbox
	pop af
	jr c, .declined
	ld a, [wMenuCursorY]
	push af
	ld a, [wCurSpecies]
	ld [wd265], a
	call GetMoveName
	ld hl, .ConfirmDeleteText
	call PrintText
	call YesNoBox
	pop bc
	jr c, .declined
	call .DeleteMove
	call WaitSFX
	ld de, SFX_MOVE_DELETED
	call PlayWaitSFX
	ld hl, .MoveDeletedText
	jr .print_text_and_exit

.declined
	ld hl, .DeclinedDeletionText
.print_text_and_exit
	jp PrintText

.OnlyOneMoveText
	ctxt "That #mon knows"
	line "only one move."
	done

.ConfirmDeleteText
	ctxt "Oh, make it forget"
	line "<STRBF1>?"
	done

.MoveDeletedText
	ctxt "Done! Your #mon"
	line "forgot the move."
	done

.EggText
	ctxt "An Egg doesn't know"
	line "any moves!"
	done

.DeclinedDeletionText
	ctxt "No? Then, come"
	line "visit me again."
	done

.AskWhichMoveText
	ctxt "Which move should"
	line "it forget, then?"
	prompt

.IntroText
	ctxt "Um<...> Oh, yes, I'm"
	line "the Move Deleter."

	para "I can make #mon"
	line "forget moves."

	para "Shall I make a"
	line "#mon forget?"
	done

.AskWhichMonText
	ctxt "Which #mon?"
	prompt

.DeleteMove
	ld a, b
	push bc
	dec a
	ld c, a
	ld b, 0
	ld hl, wPartyMon1Moves
	add hl, bc
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	pop bc
	push bc
	inc b
.loop
	ld a, b
	cp NUM_MOVES + 1
	jr z, .okay
	inc hl
	ld a, [hld]
	ld [hl], a
	inc hl
	inc b
	jr .loop

.okay
	xor a
	ld [hl], a
	pop bc

	ld a, b
	push bc
	dec a
	ld c, a
	ld b, 0
	ld hl, wPartyMon1PP
	add hl, bc
	ld a, [wCurPartyMon]
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	pop bc
	inc b
.loop2
	ld a, b
	cp NUM_MOVES + 1
	jr z, .done
	inc hl
	ld a, [hld]
	ld [hl], a
	inc hl
	inc b
	jr .loop2

.done
	xor a
	ld [hl], a
	ret
