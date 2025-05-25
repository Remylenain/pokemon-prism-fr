_Diploma::
	call ShowDiploma
	jp WaitPressAorB_BlinkCursor

ShowDiploma:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	ld hl, DiplomaTiles
	ld de, vBGTiles
	call Decompress
	ld hl, DiplomaFullscreenTilemap
	decoord 0, 0
	call Decompress
	ld de, .string_player
	hlcoord 2, 5
	call PlaceText
	ld de, wPlayerName
	hlcoord 9, 5
	call PlaceString
	ld de, .congratulations
	hlcoord 2, 8
	call PlaceText
	call EnableLCD
	call ApplyTilemapInVBlank
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	jp DelayFrame

.string_player
	text "Player"
	done

.congratulations
	ctxt "This certifies"
	next "that you have"
	next "completed the"
	next "Prism #dex."
	next "Congratulations!"
	done

PrintDiplomaPlayTimeAndSignature:
	ld hl, DiplomaPrinterTilemap
	decoord 0, 0
	call Decompress
	ld de, .signature_text
	hlcoord 6, 0
	call PlaceText
	ld de, .play_time_text
	hlcoord 3, 15
	call PlaceText
	hlcoord 12, 15
	ld de, wGameTimeHours
	lb bc, 2, 4
	call PrintNum
	ld [hl], $67
	inc hl
	ld de, wGameTimeMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	jp PrintNum

.play_time_text
	ctxt "Play Time"
	done

.signature_text
	ctxt "RainbowDevs"
	done

DiplomaTiles: INCBIN "gfx/misc/diploma_tiles.2bpp.lz"

DiplomaFullscreenTilemap:
	lzdata $17
	lzrepeat 4, $19, $18
	lzdata $00, $01, $02, $03, $04, $05, $06, $07, $08, $09
	lzcopy reversed, 5, -11
	lzdata $27
	lzrepeat 18, $34
	lzdata $27, $22, $34, $34, $10, $11, $18, $13, $14, $15, $16, $68, $69, $6a, $6b, $18, $10, $11
	lzcopy reversed, 6, -15
	lzdata $20, $21, $18, $23, $24, $25, $26, $6c, $6d, $6e, $6f, $18, $20, $21
	lzcopy normal, 4, -40
	lzrepeat 18, $34
	lzcopy reversed, 20, -59
	lzcopy normal, 3, -40
	lzrepeat 16, $30
	lzcopy reversed, 42, -17
	lzcopy normal, 180, -40
	lzend

DiplomaPrinterTilemap:
	lzdata $22
	lzrepeat 18, $34
	lzdata $22, $27
	lzrepeat 18, $34
	lzcopy reversed, 20, -19
	lzcopy normal, 26, -40
	lzdata $31, $32, $33, $34, $35, $36, $37
	lzcopy normal, 12, -40
	lzdata $40, $41, $42, $43, $44, $45, $46, $47
	lzcopy normal, 12, -40
	lzdata $50, $51, $52, $53, $54, $55, $56, $57, $58
	lzcopy normal, 11, -40
	lzdata $59, $5a, $5b, $5c, $5d, $5e, $5f, $0b, $0c, $0d, $0e, $0f
	lzcopy normal, 8, -40
	lzdata $62, $63, $64, $65, $66, $66, $3f, $1b, $1c, $1d, $1e, $1f
	lzcopy reversed, 10, -53
	lzdata $28, $66, $66, $29, $2a, $2b, $2c, $2d, $2e, $2f
	lzcopy reversed, 10, -53
	lzdata $38, $66, $66, $39, $3a, $3b, $3c, $3d, $3e
	lzcopy normal, 11, $000f
	lzdata $48, $1a, $0a, $49, $4a, $34, $4c, $4d, $4e, $4f
	lzcopy reversed, 104, $0067
	lzdata $17
	lzrepeat 4, $19, $18
	lzdata $00, $01, $02, $03, $04, $05, $06, $07, $08, $09
	lzcopy reversed, 5, -11
	lzend
