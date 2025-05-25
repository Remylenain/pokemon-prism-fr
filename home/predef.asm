_Predef::
; Call predefined function on the stack.
; Preserves bc, de, hl.
	ld a, h
	ldh [hPredefTemp+1], a
	ld a, l
	ldh [hPredefTemp], a
	pop hl
	ld a, [hli]
	ldh [hBuffer], a
	add a
	jr c, .predefJump
	push hl
.predefJump
	ldh a, [hROMBank]
	push af
	ld a, BANK(PredefPointers)
	call Bankswitch
	push de
	ldh a, [hBuffer]
	and $7f
	ld e, a
	ld d, 0
	ld hl, PredefPointers
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, d
	pop de
	and a
	jr nz, .bankswitch
	pop af
	push af
.bankswitch
	call Bankswitch
	call RetrieveHLAndCallFunction
	jr ReturnFarCall
