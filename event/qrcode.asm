QRCodeScript:
	loadarray .Codes
	opentext
	readarrayhalfword 0
	scriptstartasm

	callba GetHalfwordVar
	call DecompressWRA6
	call RunFunctionInWRA6

	ld de, wDecompressScratch
	ld hl, vFontTiles
	lb bc, BANK(@), 16
	call Request1bpp ;DecompressRequest1bpp does not exist
	hlcoord 8, 13
	ld de, SCREEN_WIDTH - 4
	ld a, $80
	ld b, 4
.draw_outer_box
	ld c, 4
.draw_inner_box
	ld [hli], a
	inc a
	dec c
	jr nz, .draw_inner_box
	add hl, de
	dec b
	jr nz, .draw_outer_box
	scriptstopasm

	waitbutton
	checkitem QR_READER
	sif false
		closetextend
	refreshscreen ;reload font
	writetext .scanning_text
	playwaitsfx SFX_CALL
	waitbutton
	readarrayhalfword 2
	jumptext -1

.scanning_text
	ctxt "Scanning with the"
	line "QR Scanner<...>"
	done

.Codes
	dw QRCodeOxalis_GFX,    QRCodeOxalis_Text
.CodesEntrySizeEnd
	dw QRCodeBotan_GFX,     QRCodeBotan_Text
	dw QRCodeGoldenrod_GFX, QRCodeGoldenrod_Text
	dw QRCodeRoute65_GFX,   QRCodeRoute65_Text
	dw QRCodeRoute77_GFX,   QRCodeRoute77_Text
	dw QRCodeRoute80_GFX,   QRCodeRoute80_Text
	dw QRCodeSpurge_GFX,    QRCodeSpurge_Text

QRCodeOxalis_GFX:    INCBIN "gfx/qrcodes/oxalis.1bpp.lz"
QRCodeBotan_GFX:     INCBIN "gfx/qrcodes/botan.1bpp.lz"
QRCodeGoldenrod_GFX: INCBIN "gfx/qrcodes/goldenrod.1bpp.lz"
QRCodeRoute65_GFX:   INCBIN "gfx/qrcodes/route65.1bpp.lz"
QRCodeRoute77_GFX:   INCBIN "gfx/qrcodes/route77.1bpp.lz"
QRCodeRoute80_GFX:   INCBIN "gfx/qrcodes/route80.1bpp.lz"
QRCodeSpurge_GFX:    INCBIN "gfx/qrcodes/spurge.1bpp.lz"

QRCodeOxalis_Text:    INCLUDE "gfx/qrcodes/oxalis.asm"
QRCodeBotan_Text:     INCLUDE "gfx/qrcodes/botan.asm"
QRCodeGoldenrod_Text: INCLUDE "gfx/qrcodes/goldenrod.asm"
QRCodeRoute65_Text:   INCLUDE "gfx/qrcodes/route65.asm"
QRCodeRoute77_Text:   INCLUDE "gfx/qrcodes/route77.asm"
QRCodeRoute80_Text:   INCLUDE "gfx/qrcodes/route80.asm"
QRCodeSpurge_Text:    INCLUDE "gfx/qrcodes/spurge.asm"
