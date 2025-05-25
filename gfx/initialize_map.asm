AnchorBGMap::
	ldh a, [hOAMUpdate]
	push af

	ld a, 1
	ldh [hOAMUpdate], a
	ldh a, [hBGMapMode]
	push af

	xor a
	ldh [hBGMapMode], a
	ld [wLCDCPointer], a
	ld a, $90
	ldh [hWY], a
	call OverworldTextModeSwitch

	ld a, HIGH(vWindowMap) ; window
	ldh [hBGMapAddress + 1], a
	xor a
	ldh [hBGMapAddress], a
	call BGMapAnchorTopLeft
	callba LoadOW_BGPal7
	callba ApplyPals
	xor a
	ldh [hBGMapMode], a
	ldh [hWY], a
	ldh [hBGMapAddress], a
	ld [wBGMapAnchor], a
	ldh [hSCX], a
	ldh [hSCY], a
	inc a
	ldh [hCGBPalUpdate], a
	ld a, HIGH(vBGMap) ; overworld
	ldh [hBGMapAddress + 1], a
	ld [wBGMapAnchor + 1], a
	call ReanchorOverworldSprites

	pop af
	ldh [hBGMapMode], a
	pop af
	ldh [hOAMUpdate], a
	ld hl, wVramState
	set 6, [hl]
	ret

LoadFont::
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a

	call LoadStandardFont
	ld a, $90
	ldh [hWY], a
	call SafeUpdateSprites

	pop af
	ldh [hOAMUpdate], a
	ret
