RequestLYOverrides::
	ld a, [wLCDCPointer]
	and a
	ret z

	ld a, LOW(wLYOverridesBackup)
	ldh [hRequestedVTileSource], a
	ld a, HIGH(wLYOverridesBackup)
	ldh [hRequestedVTileSource + 1], a

	ld a, LOW(wLYOverrides)
	ldh [hRequestedVTileDest], a
	ld a, HIGH(wLYOverrides)
	ldh [hRequestedVTileDest + 1], a

	ld a, (wLYOverridesEnd - wLYOverrides) / 16
	ldh [hLYOverrideStackCopyAmount], a
	ret

CancelMapSign::
	ld a, $80
	ld [wMapSignRoutineIdx], a
	xor a
	ld [wMapSignTimer], a
	ld a, SCREEN_HEIGHT_PX
	ldh [rWY], a
	ldh [hWY], a
	ret

DMGCompatBGMapTransfer::
; transfer 6 rows instead of 9 rows so it'll be normal speed compatible
	ldh a, [hBGMapMode]
	push af
	ld a, 5
	ldh [hBGMapMode], a
	inc a ; 6
	ldh [hTilesPerCycle], a
	ldh [hBGMapHalf], a
	call DelayFrame
	xor a
	ldh [hBGMapHalf], a
	call DelayFrame
	ld a, 12
	ldh [hBGMapHalf], a
	call DelayFrame
	pop af
	ldh [hBGMapMode], a
	ret
