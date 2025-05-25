MonMenuOptionStrings:
	db "Stats@"
	db "Switch@"
	db "Item@"
	db "Cancel@"
	db "Moves@"
	db "Mail@"
	db "Error!@"
	db "Item@"

MonMenuOptions:

; Moves
	db MONMENU_FIELD_MOVE, MONMENU_CUT,        CUT
	db MONMENU_FIELD_MOVE, MONMENU_FLY,        FLY
	db MONMENU_FIELD_MOVE, MONMENU_SURF,       SURF
	db MONMENU_FIELD_MOVE, MONMENU_STRENGTH,   STRENGTH
	db MONMENU_FIELD_MOVE, MONMENU_FLASH,      FLASH
	db MONMENU_FIELD_MOVE, MONMENU_DIG,        DIG
	db MONMENU_FIELD_MOVE, MONMENU_TELEPORT,   TELEPORT
	db MONMENU_FIELD_MOVE, MONMENU_SOFTBOILED, SOFTBOILED
	db MONMENU_FIELD_MOVE, MONMENU_HEADBUTT,   HEADBUTT
	db MONMENU_FIELD_MOVE, MONMENU_ROCKSMASH,  ROCK_SMASH
	db MONMENU_FIELD_MOVE, MONMENU_SWEETSCENT, SWEET_SCENT

; wOptions
	db MONMENU_MENUOPTION, MONMENU_STATS,      1 ; STATS
	db MONMENU_MENUOPTION, MONMENU_SWITCH,     2 ; SWITCH
	db MONMENU_MENUOPTION, MONMENU_ITEM,       3 ; ITEM
	db MONMENU_MENUOPTION, MONMENU_CANCEL,     4 ; CANCEL
	db MONMENU_MENUOPTION, MONMENU_MOVE,       5 ; MOVE
	db MONMENU_MENUOPTION, MONMENU_MAIL,       6 ; MAIL
	db MONMENU_MENUOPTION, MONMENU_ERROR,      7 ; ERROR!
	db MONMENU_MENUOPTION, MONMENU_PMODE_ITEM, 8 ; ITEM

	db -1

MonSubmenu:
	xor a
	ldh [hBGMapMode], a
	call GetMonSubmenuItems
	callba FreezeMonIcons
	ld hl, .MenuHeader
	call LoadMenuHeader
	call .GetTopCoord
	call PopulateMonMenu

	ld a, 1
	ldh [hBGMapMode], a
	call MonMenuLoop
	ld [wMenuSelection], a

	jp ExitMenu

.MenuHeader
	db $40 ; tile backup
	db 00, 06 ; start coords
	db 17, 19 ; end coords
	dw 0
	db 1 ; default option

.GetTopCoord
; TopCoord = 1 + BottomCoord - 2 * (NumSubmenuItems + 1)
	ld a, [wMonSubmenuItemsCount]
	inc a
	add a
	ld b, a
	ld a, [wMenuBorderBottomCoord]
	sub b
	inc a
	ld [wMenuBorderTopCoord], a
	jp MenuBox

MonMenuLoop:
.loop
	ld a, $a0 ; flags
	ld [wMenuDataFlags], a
	ld a, [wMonSubmenuItemsCount] ; items
	ld [wMenuDataItems], a
	call InitVerticalMenuCursor
	ld hl, w2DMenuFlags1
	set 6, [hl]
	call DoMenuJoypadLoop
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	ldh a, [hJoyPressed]
	bit A_BUTTON_F, a ; A
	jr nz, .select
	bit B_BUTTON_F, a ; B
	jr z, .loop
	ld a, MONMENU_CANCEL ; CANCEL
	ret

.select
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	ld hl, wMonSubmenuItems
	add hl, bc
	ld a, [hl]
	ret

PopulateMonMenu:
	call MenuBoxCoord2Tile
	ld bc, $2a ; 42
	add hl, bc
	ld de, wMonSubmenuItems
.loop
	ld a, [de]
	inc de
	cp -1
	ret z
	push de
	push hl
	call GetMonMenuString
	pop hl
	call PlaceString
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop de
	jr .loop

GetMonMenuString:
	ld hl, MonMenuOptions + 1
	ld e, 3
	call IsInArray
	dec hl
	ld a, [hli]
	dec a
	jr z, .NotMove
	inc hl
	ld a, [hl]
	ld [wd265], a
	jp GetMoveName

.NotMove
	inc hl
	ld a, [hl]
	dec a
	ld hl, MonMenuOptionStrings
	call GetNthString
	ld d, h
	ld e, l
	ret

GetMonSubmenuItems:
	call ResetMonSubmenu
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	ld a, [wLinkMode]
	and a
	jr nz, .skip_moves
	ld a, MON_MOVES
	call GetPartyParamLocation
	ld d, h
	ld e, l
	ld c, NUM_MOVES
.loop
	push bc
	push de
	ld a, [de]
	and a
	jr z, .next
	push hl
	call IsFieldMove
	pop hl
	call c, AddMonMenuItem
.next
	pop de
	inc de
	pop bc
	dec c
	jr nz, .loop

.skip_moves
	ld a, MONMENU_STATS
	call AddMonMenuItem
	ld a, MONMENU_SWITCH
	call AddMonMenuItem
	ld a, MONMENU_MOVE
	call AddMonMenuItem
	ld a, [wLinkMode]
	and a
	jr nz, .skip2
	CheckEngine ENGINE_POKEMON_MODE
	ld a, MONMENU_PMODE_ITEM
	jr nz, .pokemonOnlyMode
	ld a, MONMENU_ITEM
.pokemonOnlyMode
	call AddMonMenuItem
.skip2
	ld a, [wMonSubmenuItemsCount]
	cp NUM_MON_SUBMENU_ITEMS
	jr z, .ok2
.add_cancel_and_exit
	ld a, MONMENU_CANCEL
	call AddMonMenuItem
.ok2
	jp TerminateMonSubmenu

.egg
	ld a, MONMENU_STATS
	call AddMonMenuItem
	ld a, MONMENU_SWITCH
	call AddMonMenuItem
	jr .add_cancel_and_exit

IsFieldMove:
	ld b, a
	ld hl, MonMenuOptions
.next
	ld a, [hli]
	cp -1
	ret z
	cp MONMENU_MENUOPTION
	ret z
	ld d, [hl]
	inc hl
	ld a, [hli]
	cp b
	jr nz, .next
	ld a, d
	scf
	ret

ResetMonSubmenu:
	xor a
	ld [wMonSubmenuItemsCount], a
	ld hl, wMonSubmenuItems
	ld bc, NUM_MON_SUBMENU_ITEMS + 1
	jp ByteFill

TerminateMonSubmenu:
	ld a, [wMonSubmenuItemsCount]
	ld e, a
	ld d, 0
	ld hl, wMonSubmenuItems
	add hl, de
	ld [hl], -1
	ret

AddMonMenuItem:
	push hl
	push de
	push af
	ld a, [wMonSubmenuItemsCount]
	ld e, a
	inc a
	ld [wMonSubmenuItemsCount], a
	ld d, 0
	ld hl, wMonSubmenuItems
	add hl, de
	pop af
	ld [hl], a
	pop de
	pop hl
	ret

BattleMonMenu:
	ld hl, BattleMonMenuHeader
	call CopyMenuHeader
	xor a
	ldh [hBGMapMode], a
	call MenuBox
	call UpdateSprites
	call PlaceVerticalMenuItems
	call ApplyTilemapInVBlank
	call CopyMenuData2
	ld a, [wMenuDataFlags]
	cp $80
	ret c
	call InitVerticalMenuCursor
	ld hl, w2DMenuFlags1
	set 6, [hl]
	call DoMenuJoypadLoop
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	ldh a, [hJoyPressed]
	and B_BUTTON
	ret z
	scf
	ret

BattleMonMenuHeader:
	db $00 ; flags
	db 11, 11 ; start coords
	db 17, 19 ; end coords
	dw .menu_data_2
	db 1 ; default option

.menu_data_2
	db $c0 ; flags
	db 3 ; items
	db "Switch@"
	db "Stats@"
	db "Cancel@"
