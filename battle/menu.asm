LoadBattleMenu:
	CheckEngine ENGINE_POKEMON_MODE
	ld hl, BattleMenuHeader
	jr z, .got_header
	ld hl, PokemonOnlyModeBattleMenuHeader
.got_header
	call LoadMenuHeader
	ld a, [wd0d2]
	ld [wMenuCursorBuffer], a
	call _2DMenu
	ld a, [wMenuCursorBuffer]
	ld [wd0d2], a
	jp ExitMenu

BattleMenuHeader:
	db $40 ; flags
	db 12, 08 ; start coords
	db 17, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 6 ; spacing
	dba .strings
	dbw BANK(.menudata2), 0

.strings
	db "Fight@"
	db "<PKMN>@"
	db "Pack@"
	db "Run@"

PokemonOnlyModeBattleMenuHeader:
	db $40 ; flags
	db 12, 07 ; start coords
	db 17, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 6 ; spacing
	dba .strings
	dbw BANK(.menudata2), 0

.strings
	db "Fight@"
	db "Team@"
	db "Guard@"
	db "Run@"
