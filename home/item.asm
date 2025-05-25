DoItemEffect::
	jpba _DoItemEffect

CheckTossableItem::
	push hl
	push de
	push bc
	callba _CheckTossableItem
	jp PopOffBCDEHLAndReturn

TossItem::
	push hl
	push de
	push bc
	callba _TossItem
	jp PopOffBCDEHLAndReturn

ReceiveItem::
	push hl
	push de
	push bc
	callba _ReceiveItem
	jp PopOffBCDEHLAndReturn

CheckItem::
	push hl
	push de
	push bc
	callba _CheckItem
	jp PopOffBCDEHLAndReturn

GetItemPocket::
	; in: a: item
	; out: a: pocket
	inc a
	ret z
	dec a
	ret z
	anonbankpush ItemAttributes

	push hl
	push bc
	ld hl, ItemAttributes + ITEMATTR_POCKET - NUM_ITEMATTRS
	ld bc, NUM_ITEMATTRS
	rst AddNTimes
	ld a, [hl]
	pop bc
	pop hl
	ret

IsValidItemMenuType:
; returns carry if valid
	callba CheckItemMenu
	ld a, [wItemAttributeParamBuffer]
	cp ITEMMENU_CLOSE + 1
	ret nc
	scf
	dec a ; invalid index 1
	ret nz
	and a
	ret
