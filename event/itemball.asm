FindItemInBallScript::
	callasm .TryReceiveItem
	iffalse .no_room
	disappear LAST_TALKED
	opentext
	callasm .CheckforPlural
	iftrue .FindItemInBallScriptPlural
	writetext .text_found
	killsfx
	playwaitsfx SFX_ITEM
	itemnotify
	endtext

.no_room
	opentext
	writetext .text_found
	waitbutton
	writetext .text_bag_full
	endtext

.text_found
	start_asm
	ld hl, .PlayerFoundItemText
	ld de, .MonFoundItemText
	jr .GetTextBasedOnTreasureBagFlag

.text_found_plural
	start_asm
	ld hl, .FoundItemTextPlural
	ld de, .MonFoundItemTextPlural
	jr .GetTextBasedOnTreasureBagFlag

.text_bag_full
	start_asm
	ld hl, .PlayerCantCarryAnyMoreItems
	ld de, .MonCantCarryAnyMoreItems
.GetTextBasedOnTreasureBagFlag
	CheckEngine ENGINE_USE_TREASURE_BAG
	ret z
	push de
	ld a, [wPartyMon1HP]
	ld d, a
	ld a, [wPartyMon1HP + 1]
	or d
	ld de, wPartyMonNicknames
	jr nz, .gotName
	ld de, wPartyMonNicknames + NAME_LENGTH
.gotName
	call CopyName1
	pop hl
	ret

.PlayerFoundItemText
	ctxt "<PLAYER> found"
	line "<STRBF3>!"
	done

.MonFoundItemText
	ctxt "<STRBF2> found"
	line "<STRBF3>!"
	done

.FoundItemTextPlural
	ctxt "<PLAYER> found @"
	deciram wItemQuantityChangeBuffer, 1, 2
	text ""
	line "<STRBF3>."
	done

.MonFoundItemTextPlural
	ctxt "<STRBF2> found"
	line "@"
	deciram wItemQuantityChangeBuffer, 1, 2
	text " <STRBF3>."
	done

.PlayerCantCarryAnyMoreItems
	ctxt "But <PLAYER> can't"
	line "carry any more"
	cont "items."
	done

.MonCantCarryAnyMoreItems
	ctxt "But <STRBF2>"
	line "can't carry any"
	cont "more items."
	done

.TryReceiveItem
	ld a, [wCurItemBallContents]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, wStringBuffer3
	call CopyName2
	ld a, [wCurItemBallContents]
	ld [wCurItem], a
	ld a, [wCurItemBallQuantity]
	ld [wItemQuantityChangeBuffer], a
	callba GiveItemCheckPluralBuffer3
	ld hl, wNumItems
	call ReceiveItem
	sbc a
	and 1
	ldh [hScriptVar], a
	ret

.FindItemInBallScriptPlural
	writetext .text_found_plural
	killsfx
	playwaitsfx SFX_ITEM
	callasm ItemNotifyFromMem
	endtext

.CheckforPlural
	xor a
	ldh [hScriptVar], a
	ld a, [wItemQuantityChangeBuffer]
	dec a
	ret z
	ld a, 1
	ldh [hScriptVar], a
	ld hl, wStringBuffer3
	ld de, wStringBuffer1
	ld bc, 15
	rst CopyBytes
	ret

FindTMorHMScript:
	callasm .TryReceiveTM
	iffalse .no_room
	disappear LAST_TALKED
	opentext
	writetext .text_found
	killsfx
	playwaitsfx SFX_GET_TM
	jumptext .text_put_tm_in_pocket

.no_room
	opentext
	writetext .text_found
	waitbutton
	jumptext .text_bag_full

.text_found
	ctxt "<PLAYER> found <STRBF1>"
	line "<STRBF3>!"
	done

.text_put_tm_in_pocket
	ctxt "<PLAYER> put the"
	line "<STRBF1> in the"
	cont "TM Pocket."
	done

.text_bag_full
	ctxt "But <PLAYER> has"
	line "a <STRBF1> already."
	done

.TryReceiveTM:
	xor a
	ldh [hScriptVar], a
	ld a, [wCurItemBallContents]
	ld [wd265], a
	predef GetTMHMMove
	call GetMoveName
	ld hl, wStringBuffer3
	call CopyName2

	ld hl, wStringBuffer1
	ld a, [wCurItemBallContents]
	ld [wCurItem], a
	cp NUM_TMS + 1
	ld a, "T"
	jr c, .okay
	ld a, [wCurItemBallContents]
	sub NUM_TMS
	ld [wCurItemBallContents], a
	ld a, "H"
.okay
	ld [hli], a
	ld [hl], "M"
	inc hl
	ld de, wCurItemBallContents
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ld [hl], "@"
	ld a, [wCurItem]
	dec a
	ld c, a
	ld hl, wTMsHMs
	ld b, CHECK_FLAG
	predef FlagAction
	ld a, c
	and a
	ret nz
	ld a, [wCurItem]
	dec a
	ld c, a
	ld hl, wTMsHMs
	ld b, SET_FLAG
	predef FlagAction
	ld a, 1
	ldh [hScriptVar], a
	ret
