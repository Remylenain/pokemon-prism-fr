CanLearnTMHMMove:
	push de
	call .CanLearnTMHMMove
	pop de
	ret

.CanLearnTMHMMove:
	ld a, [wCurPartySpecies]
	dec a
	ld hl, TMHMLearnsets
	ld bc, 13
	rst AddNTimes

	ld a, BANK(TMHMLearnsets)
	ld bc, 13
	ld de, wCurBaseData
	call FarCopyBytes

	ld hl, wCurBaseData
	push hl

	ld a, [wPutativeTMHMMove]
	ld b, a
	ld c, 0
	ld hl, TMHMMoves
.loop
	ld a, [hli]
	and a
	jr z, .end
	cp b
	jr z, .found
	inc c
	jr .loop

.found
	pop hl
	ld b, CHECK_FLAG
	predef_jump FlagAction

.end
	pop hl
	ld c, 0
	ret

GetTMHMMove::
	ld a, [wCurTMHM]
	and $7f
	dec a
	ld hl, TMHMMoves
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	ret

INCLUDE "data/tmmoves.asm"
