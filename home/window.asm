Script_refreshscreen::
RefreshScreen::
	call ClearWindowData
	anonbankpush AnchorBGMap

	call AnchorBGMap
	jr BGMapAnchorTopLeftAndLoadFont

Script_opentext::
OpenText::
	call IsScriptRunFromASM
	jr nz, OpenText_FromASM
	lda_coord 0, 12
	cp "┌"
	ret z
	call ClearWindowData
	anonbankpush AnchorBGMap

	call AnchorBGMap
	call SpeechTextBox
BGMapAnchorTopLeftAndLoadFont:
	call BGMapAnchorTopLeft
	jp LoadFont

OpenText_FromASM:
	ld hl, wScriptFlags
	bit 5, [hl]
	ret nz
	set 5, [hl]
	call LoadMenuTextBox
	bankpushjp AnchorBGMap, BGMapAnchorTopLeftAndLoadFont

CloseText::
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a

	call ClearWindowData
	xor a
	ldh [hBGMapMode], a
	call OverworldTextModeSwitch
	call BGMapAnchorTopLeft
	xor a
	ldh [hBGMapMode], a
	call SafeUpdateSprites
	ld a, $90
	ldh [hWY], a
	call ReplaceKrisSprite

	pop af
	ldh [hOAMUpdate], a
	ld hl, wVramState
	res 6, [hl]
	ret

BGMapAnchorTopLeft::
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a

	ld b, 0
	call SafeCopyTilemapAtOnce

	pop af
	ldh [hOAMUpdate], a
	ret

SafeUpdateSprites::
	ldh a, [hOAMUpdate]
	push af
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	inc a
	ldh [hOAMUpdate], a
	call UpdateSprites
	xor a
	ldh [hOAMUpdate], a
	call DelayFrame
	pop af
	ldh [hBGMapMode], a
	pop af
	ldh [hOAMUpdate], a
	ret
