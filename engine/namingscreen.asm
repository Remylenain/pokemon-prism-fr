_NamingScreen:
	call DisableSpriteUpdates
	call NamingScreen
	jp ReturnToMapWithSpeechTextbox

NamingScreen:
	ld hl, wNamingScreenDestinationPointer
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, wNamingScreenType
	ld [hl], b
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a
	ldh a, [hInMenu]
	push af
	ld a, 1
	ldh [hInMenu], a
	call .SetUpNamingScreen
	call DelayFrame
.loop
	call NamingScreenJoypadLoop
	jr nc, .loop
	pop af
	ldh [hInMenu], a
	pop af
	ldh [hMapAnims], a
	pop af
	ld [wOptions], a
	jp ClearJoypad

.SetUpNamingScreen:
	call ClearBGPalettes
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call DisableLCD
	call LoadNamingScreenGFX
	call NamingScreen_InitText
	call EnableLCD
	ld a, $e3
	ldh [rLCDC], a
	call .GetNamingScreenSetup
	call ApplyTilemapInVBlank
	call WaitTop
	call SetPalettes
	jp NamingScreen_InitNameEntry

.GetNamingScreenSetup:
	ld a, [wNamingScreenType]
	and 7
	jumptable

	dw .Pokemon
	dw .Player
	dw .Rival
	dw GenericDummyFunction
	dw .Box
	dw GenericDummyFunction
	dw .Pokemon
	dw .Pokemon

.Pokemon:
	ld a, [wCurPartySpecies]
	ld [wd265], a
	ld e, 1
	callba LoadPokemonIconFromMem
	ld a, [wCurPartySpecies]
	ld [wd265], a
	call GetPokemonName
	hlcoord 5, 2
	call PlaceString
	ld l, c
	ld h, b
	ld de, .NicknameStrings
	call PlaceString
	inc de
	hlcoord 5, 4
	call PlaceString
	callba GetGender
	jr c, .genderless
	ld a, "♂"
	jr nz, .place_gender
	ld a, "♀"
.place_gender
	hlcoord 1, 2
	ld [hl], a
.genderless
	jp .StoreMonIconParams

.NicknameStrings:
	db "'s@"
	db "Nickname?@"

.Player:
	call GetPlayerIcon
	call .LoadSprite
	hlcoord 5, 2
	ld de, .PlayerNameString
	call PlaceText
	callba GetPlayerPalettePointer
	ldh a, [rSVBK]
	push af
	wbk BANK(wOriginalOBJPals)
	ld de, wOriginalOBJPals + 2
	ld bc, 4
	rst CopyBytes
	pop af
	ldh [rSVBK], a
	callba ApplyPals
	jp .StoreSpriteIconParams

.PlayerNameString:
	ctxt "Your name?"
	done

.Rival:
	ld hl, SilverSpriteGFX
	ld a, BANK(SilverSpriteGFX)
	call FarDecompressWRA6
	call .LoadSprite
	hlcoord 5, 2
	ld de, .RivalNameString
	call PlaceText
	jp .StoreSpriteIconParams

.RivalNameString:
	ctxt "Rival's Name?"
	done

.Box:
	ld hl, PokeBallSpriteGFX
	ld de, vObjTiles tile $00
	lb bc, BANK(PokeBallSpriteGFX), 4
	call DecompressRequest2bpp
	xor a
	ld hl, wSpriteAnimDict
	ld [hli], a
	ld [hl], a
	depixel 4, 4, 4, 0
	ld a, SPRITE_ANIM_INDEX_RED_WALK
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], 0
	hlcoord 5, 2
	ld de, .BoxNameString
	call PlaceText
	jp .StoreBoxIconParams

.BoxNameString:
	ctxt "Box Name?"
	done

.LoadSprite:
	ld de, wDecompressScratch
	ld hl, vObjTiles tile $00
	ld c, 4
	call Request2bppInWRA6
	ld de, wDecompressScratch + 12 tiles
	ld hl, vObjTiles tile $04
	ld c, 4
	call Request2bppInWRA6
	xor a
	ld hl, wSpriteAnimDict
	ld [hli], a
	ld [hl], a
	ld a, SPRITE_ANIM_INDEX_RED_WALK
	depixel 4, 4, 4, 0
	jp _InitSpriteAnimStruct

.StoreMonIconParams:
	ld a, PKMN_NAME_LENGTH - 1
	hlcoord 5, 6
	jr .StoreParams

.StoreSpriteIconParams:
	ld a, PLAYER_NAME_LENGTH - 1
	hlcoord 5, 6
	jr .StoreParams

.StoreBoxIconParams:
	ld a, BOX_NAME_LENGTH - 1
	hlcoord 5, 4
	; fallthrough

.StoreParams:
	ld [wNamingScreenMaxNameLength], a
	ld a, l
	ld [wNamingScreenStringEntryCoord], a
	ld a, h
	ld [wNamingScreenStringEntryCoord + 1], a
	ret

NamingScreen_IsTargetBox:
	push bc
	push af
	ld a, [wNamingScreenType]
	sub 3
	ld b, a
	pop af
	dec b
	pop bc
	ret

NamingScreen_InitText:
	call WaitTop
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $60
	call ByteFill
	hlcoord 1, 1
	lb bc, 6, 18
	call NamingScreen_IsTargetBox
	jr nz, .not_box
	lb bc, 4, 18

.not_box
	call ClearBox
	ld de, NameInputUpper
NamingScreen_ApplyTextInputMode:
	call NamingScreen_IsTargetBox
	jr nz, .not_box
	ld hl, BoxNameInputLower - NameInputLower
	add hl, de
	ld d, h
	ld e, l

.not_box
	push de
	hlcoord 1, 8
	lb bc, 7, 18
	call NamingScreen_IsTargetBox
	jr nz, .not_box_2
	hlcoord 1, 6
	lb bc, 9, 18

.not_box_2
	call ClearBox
	hlcoord 1, 16
	lb bc, 1, 18
	call ClearBox
	pop de
	hlcoord 2, 8
	ld b, 5
	call NamingScreen_IsTargetBox
	jr nz, .row
	hlcoord 2, 6
	inc b

.row
	ld c, $11
.col
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .col
	push de
	ld de, 2 * SCREEN_WIDTH - $11
	add hl, de
	pop de
	dec b
	jr nz, .row
	ret

NamingScreenJoypadLoop:
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .quit
	call .RunJumptable
	callba PlaySpriteAnimationsAndDelayFrame
	call .UpdateStringEntry
	call DelayFrame
	and a
	ret

.quit
	callba ClearSpriteAnims
	call ClearSprites
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	scf
	ret

.UpdateStringEntry:
	xor a
	ldh [hBGMapMode], a
	hlcoord 1, 5
	call NamingScreen_IsTargetBox
	jr nz, .got_coords
	hlcoord 1, 3

.got_coords
	lb bc, 1, 18
	call ClearBox
	ld hl, wNamingScreenDestinationPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wNamingScreenStringEntryCoord
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PlaceString
	ld a, 1
	ldh [hBGMapMode], a
	ret

.RunJumptable:
	ld a, [wJumptableIndex]
	jumptable

	dw .InitCursor
	dw .ReadButtons

.InitCursor:
	depixel 10, 3
	call NamingScreen_IsTargetBox
	jr nz, .got_cursor_position
	ld d, 8 * 8
.got_cursor_position
	ld a, SPRITE_ANIM_INDEX_NAMING_SCREEN_CURSOR
	call _InitSpriteAnimStruct
	ld a, c
	ld [wNamingScreenCursorObjectPointer], a
	ld a, b
	ld [wNamingScreenCursorObjectPointer + 1], a
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_0E
	add hl, bc
	ld [hl], a
	ld hl, wJumptableIndex
	inc [hl]
	ret

.ReadButtons:
	ld hl, hJoyPressed
	ld a, [hl]
	and A_BUTTON
	jr nz, .a
	ld a, [hl]
	and B_BUTTON
	jr nz, .delete_character
	ld a, [hl]
	and START
	jr nz, .start
	ld a, [hl]
	and SELECT
	jr nz, .select
	ret

.a
	call .GetCursorPosition
	dec a
	jr z, .select
	dec a
	jr z, .delete_character
	dec a
	jr z, .end
	call NamingScreen_GetLastCharacter
	ld a, [wNamingScreenMaxNameLength]
	ld c, a
	ld a, [wNamingScreenCurrNameLength]
	cp c
	ret nc

	ld a, [wNamingScreenLastCharacter]
	call NamingScreen_GetTextCursorPosition
	ld [hl], a

	ld hl, wNamingScreenCurrNameLength
	inc [hl]
	call NamingScreen_GetTextCursorPosition
	ld a, [hl]
	cp "@"
	jr z, .start
	ld [hl], $f2
	ld a, [wNamingScreenCurrNameLength]
	dec a
	ret nz
	jr .xor_then_set_keyboard

.start
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld [hl], 8
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld [hl], 4
	call NamingScreen_IsTargetBox
	ret nz
	inc [hl]
	ret

.end
	call NamingScreen_StoreEntry
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

.select
	ld a, [wNamingScreenShift]
.xor_then_set_keyboard
	xor 1
.set_keyboard
	ld [wNamingScreenShift], a
	ld de, NameInputUpper
	jr z, .got_keyboard
	ld de, NameInputLower
.got_keyboard
	jp NamingScreen_ApplyTextInputMode

.delete_character
	ld hl, wNamingScreenCurrNameLength
	ld a, [hl]
	and a
	ret z
	dec [hl]
	call NamingScreen_GetTextCursorPosition
	ld [hl], $f2
	inc hl
	ld a, [hl]
	cp $f2
	ret nz ; only at the character at the end
	ld [hl], $eb
	ld a, [wNamingScreenCurrNameLength]
	and a
	jr z, .set_keyboard
	ret

.GetCursorPosition:
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]

NamingScreen_GetCursorBottomRowPosition:
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	push bc
	ld b, 4
	call NamingScreen_IsTargetBox
	jr nz, .not_box
	inc b
.not_box
	cp b
	pop bc
	jr nz, .not_bottom_row
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld a, [hl]
	cp 3
	jr c, .case_switch
	cp 6
	jr c, .delete
	ld a, 3
	ret

.case_switch
	ld a, 1
	ret

.delete
	ld a, 2
	ret

.not_bottom_row
	xor a
	ret

NamingScreen_AnimateCursor:
	call .GetDPad
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	ld e, a
	swap e
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], e
	ld d, 4
	call NamingScreen_IsTargetBox
	jr nz, .ok
	inc d
.ok
	cp d
	ld de, .LetterEntries
	ld a, 0
	jr nz, .ok2
	ld de, .CaseDelEnd
	inc a
.ok2
	ld hl, SPRITEANIMSTRUCT_0E
	add hl, bc
	add [hl]
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, de
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

.LetterEntries:
	db $00, $10, $20, $30, $40, $50, $60, $70, $80

.CaseDelEnd:
	db $00, $00, $00, $30, $30, $30, $60, $60, $60

.GetDPad:
	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .up
	ld a, [hl]
	and D_DOWN
	jr nz, .down
	ld a, [hl]
	and D_LEFT
	jr nz, .left
	ld a, [hl]
	and D_RIGHT
	ret z
.right
	call NamingScreen_GetCursorBottomRowPosition
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	and a
	jr nz, .bottom_row_move_right
	ld a, [hl]
	cp 8
	jr nc, .move_to_zero
	inc [hl]
	ret

.bottom_row_move_right
	cp 3
	jr nc, .move_to_zero
.move_in_bottom_row
	ld e, a
	add a, a
	add a, e
	ld [hl], a
	ret

.left
	call NamingScreen_GetCursorBottomRowPosition
	ld hl, SPRITEANIMSTRUCT_0C
	add hl, bc
	and a
	jr nz, .bottom_row_move_left
	ld a, [hl]
	and a
	jr z, .move_to_right_edge
	dec [hl]
	ret

.move_to_right_edge
	ld [hl], 8
	ret

.bottom_row_move_left
	dec a
	jr nz, .not_bottom_left
	ld a, 3
.not_bottom_left
	dec a
	jr .move_in_bottom_row

.down
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	cp 4
	jr z, .check_screen_type
	jr nc, .move_to_zero
.move_forwards
	inc [hl]
	ret

.check_screen_type
	call NamingScreen_IsTargetBox
	jr z, .move_forwards
.move_to_zero
	ld [hl], 0
	ret

.up
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld a, [hl]
	and a
	jr z, .move_to_bottom
	dec [hl]
	ret

.move_to_bottom
	ld [hl], 4
	call NamingScreen_IsTargetBox
	ret nz
	inc [hl]
	ret

NamingScreen_GetTextCursorPosition:
	push af
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wNamingScreenCurrNameLength]
	ld e, a
	ld d, 0
	add hl, de
	pop af
	ret

NamingScreen_InitNameEntry:
; load $f2, ($eb * [wNamingScreenMaxNameLength]), $50 into the dw address at wNamingScreenDestinationPointer
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $f2
	inc hl
	ld a, [wNamingScreenMaxNameLength]
	dec a
	ld c, a
	ld a, $eb
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [hl], "@"
	ret

NamingScreen_StoreEntry:
	ld hl, wNamingScreenDestinationPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wNamingScreenMaxNameLength]
	ld c, a
.loop
	ld a, [hl]
	cp $eb
	jr z, .terminator
	cp $f2
	jr nz, .not_terminator
.terminator
	ld [hl], "@"
.not_terminator
	inc hl
	dec c
	jr nz, .loop
	ret

NamingScreen_GetLastCharacter:
	ld hl, wNamingScreenCursorObjectPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	add [hl]
	rra
	rra
	rra
	dec a
	and $1f
	ld e, a
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, [hl]
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	add [hl]
	rra
	rra
	rra
	sub 2
	and $1f
	ld d, a
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
.loop
	ld a, d
	and a
	jr z, .done
	add hl, bc
	dec d
	jr .loop

.done
	add hl, de
	ld a, [hl]
	ld [wNamingScreenLastCharacter], a
	ret

LoadNamingScreenGFX:
	call ClearSprites
	callba ClearSpriteAnims
	call LoadStandardFont

	ld de, NamingScreenGFX_EntryCursor
	ld hl, vFontTiles tile $6b
	lb bc, BANK(NamingScreenGFX_EntryCursor), 1
	call Get1bpp

	ld de, NamingScreenGFX_EmptyCharacter
	ld hl, vFontTiles tile $72
	lb bc, BANK(NamingScreenGFX_EmptyCharacter), 1
	call Get1bpp

	ld de, vBGTiles tile $60
	ld hl, NamingScreenGFX_Border
	ld bc, 1 tiles
	ld a, BANK(NamingScreenGFX_Border)
	call FarCopyBytes

	ld de, vObjTiles tile $7e
	ld hl, NamingScreenGFX_Cursor
	ld bc, 2 tiles
	ld a, BANK(NamingScreenGFX_Cursor)
	call FarCopyBytes

	ld a, 5
	ld hl, wSpriteAnimDict + 9 * 2
	ld [hli], a
	ld [hl], $7e
	xor a
	ldh [hSCY], a
	ld [wGlobalAnimYOffset], a
	ldh [hSCX], a
	ld [wGlobalAnimXOffset], a
	ld [wJumptableIndex], a
	ld [wNamingScreenShift], a
	ldh [hBGMapMode], a
	ld [wNamingScreenCurrNameLength], a
	ld a, 7
	ldh [hWX], a
	ret

NameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "× ( ) : ; [ ] <PK> <MN>"
	db "UPPER  DEL   END "

BoxNameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "é 'd 'l 'm 'r 's 't 'v 0"
	db "1 2 3 4 5 6 7 8 9"
	db "UPPER  DEL   END "

NameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "- ? ! / . ,      "
	db "lower  DEL   END "

BoxNameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "× ( ) : ; [ ] <PK> <MN>"
	db "- ? ! ♂ ♀ / . , &"
	db "lower  DEL   END "

NamingScreenGFX_Border: INCBIN "gfx/naming_screen/border.2bpp"
NamingScreenGFX_Cursor: INCBIN "gfx/naming_screen/cursor.2bpp"
NamingScreenGFX_EntryCursor: INCBIN "gfx/naming_screen/entry_cursor.1bpp"
NamingScreenGFX_EmptyCharacter: INCBIN "gfx/naming_screen/blank.1bpp"
