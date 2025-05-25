BORDER_WIDTH   EQU 2
TEXTBOX_WIDTH  EQU SCREEN_WIDTH
TEXTBOX_INNERW EQU TEXTBOX_WIDTH - BORDER_WIDTH
TEXTBOX_HEIGHT EQU 6
TEXTBOX_INNERH EQU TEXTBOX_HEIGHT - BORDER_WIDTH
TEXTBOX_X      EQU 0
TEXTBOX_INNERX EQU TEXTBOX_X + 1
TEXTBOX_Y      EQU SCREEN_HEIGHT - TEXTBOX_HEIGHT
TEXTBOX_INNERY EQU TEXTBOX_Y + 2

TEXTBOX_PAL EQU 7

SpeechTextBox::
; Standard textbox.
	hlcoord TEXTBOX_X, TEXTBOX_Y
	lb bc, TEXTBOX_INNERH, TEXTBOX_INNERW

TextBox::
; Draw a text box at hl with room for
; b lines of c characters each.
; Places a border around the textbox,
; then switches the palette to the
; text black-and-white scheme.
	push bc
	push hl

	; Top
	push hl
	ld a, "┌"
	ld [hli], a
	inc a ; "─"
	call TextBox_PlaceChars
	inc a ; "┐"
	ld [hl], a
	pop hl

	; Middle
	ld de, SCREEN_WIDTH
	add hl, de
.row
	push hl
	ld a, "│"
	ld [hli], a
	ld a, " "
	call TextBox_PlaceChars
	ld [hl], "│"
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .row

	; Bottom
	ld a, "└"
	ld [hli], a
	ld a, "─"
	call TextBox_PlaceChars
	ld [hl], "┘"

	pop hl
	pop bc

TextBoxPalette::
; Fill text box width c height b at hl with pal 7
	ld de, wAttrMap - wTileMap
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, TEXTBOX_PAL
	jr FillBoxWithByte

TextBox_PlaceChars::
; Place char a c times.
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

ClearSpeechBox::
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	lb bc, TEXTBOX_INNERH - 1, TEXTBOX_INNERW

ClearBox::
; Fill a c*b box at hl with blank tiles.
	ld a, " "

FillBoxWithByte::
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

ClearTileMapAndWipeAttrMap:
	call ClearTileMapNoDelay

; fallthrough
ClearAttrMap::
	coord hl, 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	jp ByteFill

ClearScreen::
	call TextClearAttrMap

ClearTileMap::
; Fill wTileMap with blank tiles.

	call ClearTileMapNoDelay

	; Update the BG Map.
	ldh a, [rLCDC]
	bit 7, a
	ret z
	jp ApplyTilemapInVBlank

ClearTileMapNoDelay:
	hlcoord 0, 0
	ld a, " "
	ld bc, wTileMapEnd - wTileMap
	jp ByteFill

TextClearAttrMap:
	ld a, TEXTBOX_PAL
	hlcoord 0, 0, wAttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp ByteFill

PrintInstantText::
	call StorePrintTextSPAndBank
	ld a, [wOptions]
	push af
	set NO_TEXT_SCROLL, a
	ld [wOptions], a
	call PrintText
	pop af
	ld [wOptions], a
	ret

FarPrintText::
	call StorePrintTextSPAndBank
	call StackCallInBankA
	; pseudo-fallthrough - calls PrintText

PrintText::
	call SetUpTextBox
	push hl
	call ClearSpeechBox
	pop hl
	; fallthrough

PrintTextBoxText::
	bccoord TEXTBOX_INNERX, TEXTBOX_INNERY
ProcessTextCommands_::
	call StorePrintTextSPAndBank
	ld a, [wTextBoxFlags]
	push af
	set 1, a
	ld [wTextBoxFlags], a
	call SaveTextSourceDest
	call ProcessTextCommands
	call ClearPrintTextInitialSP
	pop af
	ld [wTextBoxFlags], a
	ret

StorePrintTextSPAndBank::
	ldh [hHeldA], a
	ld a, [wPrintTextInitialSP + 1]
	and a
	jr nz, .done
	ld [wPrintTextInitialSP], sp
	ldh a, [hROMBank]
	ld [wPrintTextInitialBank], a
.done
	ldh a, [hHeldA]
	ret

StorePlaceStringSPAndBank::
	ldh [hHeldA], a
	ld a, [wPlaceStringInitialSP + 1]
	and a
	jr nz, .done
	ld [wPlaceStringInitialSP], sp
	ldh a, [hROMBank]
	ld [wPlaceStringInitialBank], a
.done
	ldh a, [hHeldA]
	ret

SetUpTextBox::
	push hl
	call SpeechTextBox
	call UpdateSprites
	call ApplyTilemap
	pop hl
	ret

SaveTextSourceDest::
	ld a, l
	ld [wPrintTextSavedSource], a
	ld a, h
	ld [wPrintTextSavedSource + 1], a
	ld a, c
	ld [wPrintTextSavedDest], a
	ld a, b
	ld [wPrintTextSavedDest + 1], a
	ret

PlaceFarString::
	call StorePlaceStringSPAndBank
	call StackCallInBankA
	; pseudo-fallthrough - calls PlaceString

PlaceString::
; Process string at de into hl.
	call StorePlaceStringSPAndBank
	ld a, e
	ld [wPlaceStringSavedSource], a
	ld a, d
	ld [wPlaceStringSavedSource + 1], a
	ld a, l
	ld [wPlaceStringSavedDest], a
	ld a, h
	ld [wPlaceStringSavedDest + 1], a
	call _PlaceString
	push hl
	xor a
	ld hl, wPlaceStringInitialSP
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
	ret

_PlaceString::
	push hl
	jr PlaceNextChar

NextChar::
	inc de
PlaceNextChar::
	ld a, [de]
	cp "@"
	jr nz, CheckDict
	ld b, h
	ld c, l
	pop hl
	ret

CheckDict::
	cp LEAST_PLACEABLE_CHAR
	jr nc, .notDict
	sub LEAST_CONTROL_CHAR
	jr c, InvalidChar

	; Stack manip
	push hl
	push hl
	push de
	ld hl, TextControlCodeJumptable
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld hl, sp + 4
	ld [hli], a
	ld [hl], d
	pop de
	pop hl
	ld a, [de]
	ret
.notDict
	ld [hli], a
	call PrintLetterDelay
	jr NextChar

InvalidChar::
	ldh [hCrashSavedA], a
	ld a, 3
	jp Crash

TextControlCodeJumptable::
	dw PlaceEnemyMonNick        ; "<EMON>"
	dw PlaceStringBuffer1       ; "<STRBF1>"
	dw PlaceStringBuffer2       ; "<STRBF2>"
	dw PlaceStringBuffer3       ; "<STRBF3>"
	dw PlaceStringBuffer4       ; "<STRBF4>"
	dw PlaceEnemysName          ; "<ENEMY>"
	dw PlaceBattleMonNick       ; "<BMON>"
	dw PlacePKMN                ; "<PKMN>"
	dw ScrollText               ; "<SCROLL>"
	dw PlacePOKE                ; "<POKE>"
	dw NextLineChar             ; "<NEXT>"
	dw LineChar                 ; "<LINE>"
	dw PlaceNextChar            ; "@"
	dw Paragraph                ; "<PARA>"
	dw PrintPlayerName          ; "<PLAYER>"
	dw PrintRivalName           ; "<RIVAL>"
	dw PlacePOKe                ; "#"
	dw ContText                 ; "<CONT>"
	dw SDoneText                ; "<SDONE>"
	dw DoneText                 ; "<DONE>"
	dw PromptText               ; "<PROMPT>"
	dw PlaceMoveTargetsName     ; "<TARGET>"
	dw PlaceMoveUsersName       ; "<USER>"
	dw PlaceMonOrItemNameBuffer ; "<MINB>"
	dw SixDotsChar              ; "<......>"
	dw TrainerChar              ; "<TRNER>"
	dw RocketChar               ; "<ROCKET>"
	dw LinebreakText            ; "<LNBRK>"

MACRO print_name
	push de
	ld de, \1
	jp PlaceCommandCharacter
ENDM

PrintPlayerName: print_name wPlayerName
PrintRivalName:  print_name wRivalName
PlaceMonOrItemNameBuffer: print_name wMonOrItemNameBuffer
PlaceStringBuffer1: print_name wStringBuffer1
PlaceStringBuffer2: print_name wStringBuffer2
PlaceStringBuffer3: print_name wStringBuffer3
PlaceStringBuffer4: print_name wStringBuffer4
PlaceEnemyMonNick:  print_name wEnemyMonNick
PlaceBattleMonNick: print_name wBattleMonNick

TrainerChar:  print_name TrainerCharText
TMChar:       print_name TMCharText
RocketChar:   print_name RocketCharText
PlacePOKe:    print_name PlacePOKeText
SixDotsChar:  print_name SixDotsCharText
PlacePKMN:    print_name PlacePKMNText
PlacePOKE:    print_name PlacePOKEText

PlaceMoveTargetsName::
	ldh a, [hBattleTurn]
	xor 1
	jr PlaceMoveTargetsName_5A

PlaceMoveUsersName::
	ldh a, [hBattleTurn]
	; fallthrough

PlaceMoveTargetsName_5A:
	push de
	and a
	jr nz, .enemy

	ld de, wBattleMonNick
	jr PlaceCommandCharacter

.enemy
	ld de, EnemyText ; Enemy
	ld a, [wBattleMode]
	dec a
	jr nz, .place
	ld de, WildText ; Wild
.place
	call _PlaceString
	ld h, b
	ld l, c
	ld de, wEnemyMonNick
	jr PlaceCommandCharacter

PlaceEnemysName::
	push de

	ld a, [wLinkMode]
	and a
	jr nz, .linkbattle

	ld a, [wTrainerClass]
	cp RIVAL1
	jr z, .rival

	ld de, wOTClassName
	call _PlaceString
	ld h, b
	ld l, c
	ld de, .SpaceString
	call _PlaceString
	push bc
	callba Battle_GetTrainerName
	pop hl
	ld de, wStringBuffer1
	jr PlaceCommandCharacter

.rival
	ld de, wRivalName
	jr PlaceCommandCharacter

.linkbattle
	ld de, wOTClassName
	jr PlaceCommandCharacter

.SpaceString
	db " "
TerminatorText:
	db "@"

PlaceCommandCharacter::
	call _PlaceString
	ld h, b
	ld l, c
	pop de
	jp NextChar

TMCharText:: db "TM@"
TrainerCharText:: db "Trainer@"
PCCharText:: db "PC@"
RocketCharText:: db "Rocket@"
PlacePOKeText:: db "Poké@"
SixDotsCharText:: db "……@"
EnemyText:: db "Enemy @"
WildText:: db "Wild @"
PlacePKMNText:: db "<PK><MN>@" ; PK MN
PlacePOKEText:: db "<PO><KE>@" ; PO KE

NextLineChar::
	pop hl
	ld bc, SCREEN_WIDTH * 2
	jr LineFeedContinue

LinebreakText::
	pop hl
	ld bc, SCREEN_WIDTH
LineFeedContinue:
	add hl, bc
PushAndNextChar:
	push hl
	jp NextChar

LineChar::
	pop hl
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY + 2
	jr PushAndNextChar

Paragraph::
	push de

	ld a, [wLinkMode]
	cp LINK_COLOSSEUM
	call nz, LoadBlinkingCursor
	call WaitUpdateOAM
	call ButtonSound
	call ClearSpeechBox
	call UnloadBlinkingCursor
	ld c, 20
	call DelayFrames
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	pop de
	jp NextChar

ContText::
	ld a, [wLinkMode]
	and a
	call z, LoadBlinkingCursor

	call WaitUpdateOAM

	push de
	call ButtonSound
	pop de

	ld a, [wLinkMode]
	and a
	call z, UnloadBlinkingCursor
	push de
	jr ScrollText_Break

ScrollText::
	push de
	ld e, 20
.loop
	call DelayFrame
	call GetJoypad
	ldh a, [hJoyDown]
	and A_BUTTON | B_BUTTON
	jr nz, ScrollText_Break
	dec e
	jr nz, .loop
ScrollText_Break:
	call TextScroll
	call TextScroll
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY + 2
	pop de
	jp NextChar

SDoneText:
	push hl
	call WaitButton
	jr DoneText_NoPush

Text_PlaySFXAndPrompt:
	ld hl, TerminatorText
	push hl
	call PlayWaitSFX

; fallthrough
PromptText::
	push hl
	ld a, [wLinkMode]
	cp LINK_COLOSSEUM
	call nz, LoadBlinkingCursor
	call WaitUpdateOAM
	call ButtonSound
	ld a, [wLinkMode]
	cp LINK_COLOSSEUM
	jr z, DoneText_NoPush
	call UnloadBlinkingCursor
	pop hl ; compensate the push hl below (shorter and just as fast as jumping over it)
DoneText::
	push hl
DoneText_NoPush:
	ld hl, wTextEndPointer
	inc de
	ld a, e
	ld [hli], a
	ld [hl], d
	pop hl
	ld b, h
	ld c, l
	pop hl
	ld de, TerminatorText - 1
	ret

TextScroll::
	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY
	decoord TEXTBOX_INNERX, TEXTBOX_INNERY - 1
	ld b, TEXTBOX_INNERH - 1

.col
	ld c, TEXTBOX_INNERW

.row
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .row

	inc de
	inc de
	inc hl
	inc hl
	dec b
	jr nz, .col

	hlcoord TEXTBOX_INNERX, TEXTBOX_INNERY + 2
	ld a, " "
	ld bc, TEXTBOX_INNERW
	call ByteFill
	ld c, 5
	jp DelayFrames

WaitUpdateOAM::
	push bc
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a

	call ApplyTilemapInVBlank

	pop af
	ldh [hOAMUpdate], a
	pop bc
	ret

LoadBlinkingCursor::
	ld a, "▼"
WriteToBlinkingCursorPosition:
	ldcoord_a 18, 17
	ret

UnloadBlinkingCursor::
	lda_coord 17, 17
	jr WriteToBlinkingCursorPosition

FarPlaceTextInBankB::
	ld a, b

; fallthrough
FarPlaceText::
	call StorePrintTextSPAndBank
	call StackCallInBankA
	; pseudo-fallthrough - calls PlaceText

PlaceText::
	; similar to PlaceString, places text from de to hl, using standard text commands instead of db's
	; exits with hl pointing after the text and bc pointing to the next position to write
	call StorePrintTextSPAndBank
	ld b, h
	ld c, l
	ld h, d
	ld l, e
	call SaveTextSourceDest
	callba GetCurrentColumn
	ld [wInitialTextColumn], a
	call ProcessTextCommands

; fallthrough
ClearPrintTextInitialSP::
	xor a
	push hl
	ld hl, wPrintTextInitialSP
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
	ret

ProcessNextTextCommands:
	call NextTextCommand
ProcessTextCommands::
	ld a, [hli]
	cp "@"
	jr nz, ProcessNextTextCommands
	ld hl, wTextEndPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

NextTextCommand:
	cp LEAST_CONTROL_CHAR
	jr nc, Text_TX
	cp LEAST_CONTROL_CHAR - $40 ; lowest PlaceString char minus minimum value to represent a byte of TX_FAR
	jr nc, Text_TX_FAR

	push hl
	push bc
	ld c, a
	ld b, 0
	ld hl, TextCommands
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop bc
	pop hl

_de_::
	push de
	ret

TextCommands::
	dw Text_TX_RAM
	dw Text_START_ASM
	dw Text_TX_NUM
	dw Text_TX_COMPRESSED
TextCommandsEnd:

Text_TX::
; TX
; write text until "@"
; ["...@"]
	dec hl

	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceString
	ld h, d
	ld l, e
	inc hl
	ret

Text_TX_RAM::
; text_from_ram
; write text from a ram address
; little endian
; [$00][addr]

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	ret

Text_TX_FAR::
; text_far
; write text from a different bank
; little endian
; [upper byte of addr][addr][bank]
	add $40 - (LEAST_CONTROL_CHAR - $40)
	ld d, a

	ld a, [hli]
	ld e, a ; lower byte
	ld a, [hli] ; bank

	bit 7, a
	jr z, .text_far
	res 7, a
	ld hl, TerminatorText
.text_far
	call StackCallInBankA
	; end of function

	push hl
	ld h, d
	ld l, e
	call ProcessTextCommands
	pop hl
	ret

Text_START_ASM::
; TX_ASM

	bit 7, h
	jr nz, .not_rom
	jp hl

.not_rom
	ldh [hCrashSavedA], a
	ld a, 4
	jp Crash

Text_TX_NUM::
; TX_NUM
; [$02][addr][hi:bytes lo:digits]
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld b, a
	and $f
	ld c, a
	ld a, b
	and $f0
	swap a
	set PRINTNUM_LEFTALIGN_F, a
	ld b, a
	call PrintNum
	ld b, h
	ld c, l
	pop hl
	ret

Text_TX_COMPRESSED::
	ldh a, [hROMBank]
	jpba PrintCompressedString
