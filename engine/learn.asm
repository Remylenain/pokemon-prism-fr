LearnMove:
	call LoadTileMapToTempTileMap
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

.loop
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld d, h
	ld e, l
	ld b, NUM_MOVES
; Get the first empty move slot.  This routine also serves to
; determine whether the Pokemon learning the moves already has
; all four slots occupied, in which case one would need to be
; deleted.
.next
	ld a, [hl]
	and a
	jr z, .learn
	inc hl
	dec b
	jr nz, .next
; If we're here, we enter the routine for forgetting a move
; to make room for the new move we're trying to learn.
	push de
	call ForgetMove
	pop de
	jr c, .cancel

	push hl
	push de
	ld [wd265], a

	ld b, a
	ld a, [wBattleMode]
	and a
	jr z, .not_disabled
	ld a, [wDisabledMove]
	cp b
	jr nz, .not_disabled
	xor a
	ld [wDisabledMove], a
	ld [wPlayerDisableCount], a
.not_disabled

	call GetMoveName
	ld a, 3
	ld [wcf64], a
	ld hl, .forgot_text
	call PrintText
	pop de
	pop hl

.learn
	ld a, [wPutativeTMHMMove]
	ld [hl], a
	ld bc, MON_PP - MON_MOVES
	add hl, bc

	push hl
	ld hl, Moves + MOVE_PP - MOVE_LENGTH
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop hl
	ld [hl], a

	ld hl, wMovesObtained
	ld a, [wPutativeTMHMMove]
	ld c, a
	ld b, SET_FLAG
	predef FlagAction

	ld a, [wBattleMode]
	and a
	jr z, .learned

	ld a, [wCurPartyMon]
	ld b, a
	ld a, [wCurBattleMon]
	cp b
	jr nz, .learned

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .learned

	ld h, d
	ld l, e
	ld de, wBattleMonMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	ld bc, wPartyMon1PP - (wPartyMon1Moves + NUM_MOVES)
	add hl, bc
	ld de, wBattleMonPP
	assert HIGH(wPartyMon1PP - (wPartyMon1Moves + NUM_MOVES)) == 0
	ld c, NUM_MOVES
	rst CopyBytes
.learned
	ld hl, .learned_text
	call PrintText
	ld b, 1
	ret

.cancel
	ld hl, .stop_learning_text
	call PrintText
	call YesNoBox
	jp c, .loop

	ld hl, .did_not_learn_text
	call PrintText
	ld b, 0
	ret

.forgot_text
	text "1, 2 and"
.dots
	text "<...>@"
	start_asm
.function
	ld a, [wcf64]
	dec a
	ld [wcf64], a
	jr nz, .more_dots
	push de
	push bc
	ld c, 32
	call DelayFrames
	pop bc
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	pop de
	ld hl, .poof
	ret

.more_dots
	push bc
	ld c, 16
	call DelayFrames
	pop bc
	ld hl, .dots
	ret

.poof
	ctxt " Poof!@"
	para "<MINB> forgot"
	line "<STRBF1>."

	para "And<...>"
	prompt

.learned_text
	ctxt "<MINB> learned"
	line "<STRBF2>!@"
	start_asm
	ld de, SFX_DEX_FANFARE_50_79
	jp Text_PlaySFXAndPrompt

.stop_learning_text
	ctxt "Stop learning"
	line "<STRBF2>?"
	done

.did_not_learn_text
	ctxt "<MINB>"
	line "did not learn"
	cont "<STRBF2>."
	prompt

ForgetMove:
	push hl
	ld hl, .trying_to_learn_text
	call PrintText
	call YesNoBox
	pop hl
	ret c
	ld bc, -NUM_MOVES
	add hl, bc
	push hl
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	rst CopyBytes
	pop hl
.loop
	push hl
	ld hl, .forget_which_move_text
	call PrintText
	ld hl, .MenuHeader
	call LoadMenuHeader
	call MenuBox
	call UpdateSprites
	call ApplyTilemap
	hlcoord 5 + 2, 2 + 2
	ld a, SCREEN_WIDTH * 2
	ld [wListMoves_Spacing], a
	predef ListMoves
	ld a, 4
	ld [w2DMenuCursorInitY], a
	ld a, 6
	ld [w2DMenuCursorInitX], a
	ld a, [wNumMoves]
	inc a
	ld [w2DMenuNumRows], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld [wMenuCursorY], a
	ld [wMenuCursorX], a
	ld a, 3
	ld [wMenuJoypadFilter], a
	ld a, $20
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a
	ld a, $20
	ld [w2DMenuCursorOffsets], a
	call DoMenuJoypadLoop
	push af
	call ExitMenu
	pop af
	pop hl
	bit 1, a
	scf
	ret nz
	push hl
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	push af
	push bc
	call IsHMMove
	pop bc
	pop de
	ld a, d
	jr c, .hmmove
	pop hl
	add hl, bc
	and a
	ret

.hmmove
	ld hl, .cannot_forget_HM_text
	call PrintText
	pop hl
	jr .loop

.MenuHeader
	db $40
	db 2, 5
	db 12, 19
	dw 0
	db 1

.trying_to_learn_text
	ctxt "<MINB> is"
	line "trying to learn"
	cont "<STRBF2>."

	para "But <MINB>"
	line "can't learn more"
	cont "than four moves."

	para "Delete an older"
	line "move to make room"
	cont "for <STRBF2>?"
	done

.forget_which_move_text
	ctxt "Which move should"
	line "be forgotten?"
	done

.cannot_forget_HM_text
	ctxt "HM moves can't be"
	line "forgotten now."
	prompt
