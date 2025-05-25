DisableSpriteUpdates::
	xor a
	ldh [hMapAnims], a
	ld [wSpriteUpdatesEnabled], a
	ld a, [wVramState]
	res 0, a
	ld [wVramState], a
	ret

EnableSpriteUpdates::
	ld a, 1
	ld [wSpriteUpdatesEnabled], a
	ldh [hMapAnims], a
	ld a, [wVramState]
	set 0, a
	ld [wVramState], a
	ret

ClearSprites::
; Erase OAM data
	ld hl, wSprites
	ld b, wSpritesEnd - wSprites
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

HideSprites::
; Set all OAM y-positions to 160 to hide them offscreen
	ld hl, wSprites
	ld b, (wSpritesEnd - wSprites) / 4 ; number of OAM structs
HideBSpritesFromHL:
	ld de, 4 ; length of an OAM struct
	ld a, 8 * 20 ; y
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

ReplaceKrisSprite::
	jpba _ReplaceKrisSprite

_InitSpriteAnimStruct::
	jpba InitSpriteAnimStruct_IDToBuffer
