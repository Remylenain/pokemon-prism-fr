HallOfFame_SaveTheGame:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call LoadStandardFont
	call LoadFontsBattleExtra
	hlbgcoord 0, 0
	ld bc, vWindowMap - vBGMap
	ld a, " "
	call ByteFill
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	xor a
	ldh [hSCY], a
	ldh [hSCX], a
	call EnableLCD
	ld hl, .SavingRecordDontTurnOff
	call PrintText
	call ApplyAttrAndTilemapInVBlank
	jp SetPalettes

.SavingRecordDontTurnOff
	text "SAVING RECORD<...>"
	line "DON'T TURN OFF!"
	done

RedCredits_PrepVideoData:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call LoadStandardFont
	call LoadFontsBattleExtra
	hlbgcoord 0, 0
	ld bc, vWindowMap - vBGMap
	ld a, " "
	call ByteFill
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	ld hl, wd000 ; wOriginalBGPals
	ld c, 4 tiles
.load_white_palettes
	ld a, LOW(palred 31 + palgreen 31 + palblue 31)
	ld [hli], a
	ld a, HIGH(palred 31 + palgreen 31 + palblue 31)
	ld [hli], a
	dec c
	jr nz, .load_white_palettes
	xor a
	ldh [hSCY], a
	ldh [hSCX], a
	call EnableLCD
	call ApplyAttrAndTilemapInVBlank
	jp SetPalettes

HallOfFame_WipeBGMap:
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)
	ld hl, wDecompressScratch
	ld bc, wBackupAttrMap - wDecompressScratch
	ld a, " "
	call ByteFill
	hlbgcoord 0, 0
	ld de, wDecompressScratch
	lb bc, 0, 40
	call Request2bpp
	pop af
	ldh [rSVBK], a
	ret
