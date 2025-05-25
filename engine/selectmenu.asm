CheckRegisteredItem::
	ld a, [wWhichRegisteredItem]
	and a
	jr z, .NoRegisteredItem
	and REGISTERED_POCKET
	rlca
	rlca
	jumptable

.Pockets
	dw .CheckItem
	dw .CheckBall
	dw .CheckKeyItem

.CheckItem
	ld hl, wNumItems
	call .CheckRegisteredNo
	jr c, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	jr c, .NoRegisteredItem
	and a
	ret

.CheckKeyItem
	ld a, [wRegisteredItem]
	ld hl, wKeyItems
	call IsInSingularArray
	jr nc, .NoRegisteredItem
	ld a, [wRegisteredItem]
	ld [wCurItem], a
	and a
	ret

.CheckBall
	ld hl, wNumBalls
	call .CheckRegisteredNo
	jr nc, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	ret nc
.NoRegisteredItem
	xor a
	ld [wWhichRegisteredItem], a
	ld [wRegisteredItem], a
.NotEnoughItems
.NotSameItem
	scf
	ret

.CheckRegisteredNo
	ld a, [wWhichRegisteredItem]
	and REGISTERED_NUMBER
	dec a
	cp [hl]
	jr nc, .NotEnoughItems
	ld [wCurItemQuantity], a
	and a
	ret

.IsSameItem
	ld a, [wRegisteredItem]
	cp [hl]
	jr nz, .NotSameItem
	ld [wCurItem], a
	and a
	ret

SelectMenu::
UseRegisteredItem:
	callba CheckItemMenu
	ld a, [wItemAttributeParamBuffer]
	jumptable

.SwitchTo
	dw .CantUse
	dw GenericDummyFunction
	dw .Overworld
	dw .PartyOrReload
	dw .Current
	dw .PartyOrReload
	dw .Close

.Overworld
	call RefreshScreen
	xor a
	ldh [hMenuReturn], a
	inc a
	ld [wUsingItemWithSelect], a
	call DoItemEffect
	xor a
	ld [wUsingItemWithSelect], a
	ldh a, [hMenuReturn]
	and a
	ret z
	scf
	ret

.PartyOrReload
	call RefreshScreen
	call FadeToMenu
	ld a, 1
	ld [wUsingItemWithSelect], a
	call DoItemEffect
	xor a
	ld [wUsingItemWithSelect], a
	call CloseSubmenu
	jr .close_text_and_end

.Current
	call OpenText
	call DoItemEffect
.close_text_and_end
	call CloseText
	and a
	ret

.Close
	call RefreshScreen
	ld a, 1
	ld [wUsingItemWithSelect], a
	call DoItemEffect
	xor a
	ld [wUsingItemWithSelect], a
	ld a, [wItemEffectSucceeded]
	cp 1
	jr nz, .close_text_and_end
	scf
	ld a, HMENURETURN_SCRIPT
	ldh [hMenuReturn], a
	ret

.CantUse
	call RefreshScreen
	jr .close_text_and_end
