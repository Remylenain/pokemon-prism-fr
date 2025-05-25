ReinitBattleAnimFrameset:
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], 0
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], -1
	ret

GetBattleAnimFrame:
.loop
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next_frame
	dec [hl]
	call .get_pointer
	ld a, [hli]
	push af
	jr .okay

.next_frame
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	inc [hl]
	call .get_pointer
	ld a, [hli]
	cp -2
	jr z, .restart
	cp -1
	jr z, .repeat_last
	push af
	ld a, [hl]
	push hl
	and $3f
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a
	pop hl

.okay
	ld a, [hl]
	and $c0
	srl a
	ld [wBattleAnimTemp7], a
	pop af
	ret

.repeat_last
	xor a
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	dec [hl]
	dec [hl]
	jr .loop

.restart
	xor a
	ld hl, BATTLEANIMSTRUCT_DURATION
	add hl, bc
	ld [hl], a
	dec a
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld [hl], a
	jr .loop

.get_pointer
	ld hl, BATTLEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, BattleAnimFrameData
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, BATTLEANIMSTRUCT_FRAME
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, de
	ret

GetBattleAnimOAMPointer:
	ld l, a
	ld h, 0
	ld de, BattleAnimOAMData
	add hl, hl
	add hl, hl
	add hl, de
	ret

LoadBattleAnimObj:
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, AnimObjGFX
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	or c
	jr z, .pokeball
	pop de
	push bc
	call DecompressRequest2bpp
	pop bc
	ret
.pokeball
	ld c, 10
	ldh a, [rSVBK]
	push af
	wbk BANK(wCurItem)
	ld a, [wCurItem]
	ld e, a
	pop af
	ldh [rSVBK], a
	ld a, e

; fallthrough
GetBallGFX_continue:
	ld hl, PokeBallArray
	call IsInSingularArray
	jr c, .exists
	ld b, 3
.exists
	ld l, b
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	ld de, PokeballGFX
	add hl, de
	ld b, BANK(PokeballGFX)
	ld d, h
	ld e, l
	pop hl
	call Request2bpp
	ld c, 10
	ret

BagMenu_GetBallGFX:
	push hl
	ld c, 2
	ld a, [wMenuSelection]
	jr GetBallGFX_continue

GetBallAnimPal:
	push bc
	ldh a, [rSVBK]
	push af
	wbk BANK(wBalls)
	callba GetBallAnimPal_
	pop af
	ldh [rSVBK], a
	ld hl, BATTLEANIMSTRUCT_PALETTE
	pop bc
	add hl, bc
	ld [hl], 2
	ret
