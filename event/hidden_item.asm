HiddenItemScript::
	opentext
	copybytetovar wCurSignpostItemID
	itemtotext 0, 0
	writetext .found_text
	giveitem ITEM_FROM_MEM
	sif false, then
		buttonsound
		jumptext .no_room_text
	sendif
	callasm .set_event
	playwaitsfx SFX_ITEM
	itemnotify
	endtext

.found_text
	; found @ !
	text_jump Text_FoundHiddenItem

.no_room_text
	; But   has no space left…
	text_jump Text_NoSpaceForHiddenItem

.set_event
	ld hl, wCurSignpostItemFlag
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld b, SET_FLAG
	predef_jump EventFlagAction
