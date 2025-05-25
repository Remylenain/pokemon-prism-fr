GetWeekday_SwitchWRAMBank::
	ld a, BANK(wCurYear)
	call StackCallInWRAMBankA

GetWeekday::
	ld a, [wCurMonth]
	inc a
	inc a
	ld b, a
	cp 4
	jr nc, .nosub
	add 12
	ld b, a
	scf
.nosub
	ld a, [wCurYear]
	sbc 0
	lb de, 99, 3
	jr c, .donevars
.mod100
	sub 100
	inc e
	jr nc, .mod100
	add 100
	ld d, a
.donevars
	ld a, b
	ld bc, 666 ; ⌈2.6*256⌉
	ld hl, 0
	rst AddNTimes
	ld a, [wCurDay]
_GetWeekday::
	add h
	add d
	srl d
	srl d
	add d
	sla e
	sub e
	srl e
	srl e
	srl e
	add e
	add 7 ; underflow prevention
.mod7
	ld d, a
	and 7
	srl d
	srl d
	srl d
	add a, d
	cp 7
	ret c
	jr nz, .mod7
	xor a
	ret
