VariableBlocks::
	; in: de: pointer to varblock array, b: bank
	; out: void, no registers preserved
	; varblock array is one byte count followed by varblock macros (macros/varblocks.asm)
	call .next_byte
	ld c, a
	inc c
	jr .handle_main_loop
.main_loop
	call .next_halfword ;first byte in l, second in h
	xor a
	rrc h
	sla h
	rla
	rrc l
	sla l
	rla
	call .get_block_location
	call .handle_block
.handle_main_loop
	dec c
	jr nz, .main_loop
	jp BufferScreen

.next_byte
	ld a, b
	push hl
	ld h, d
	ld l, e
	call GetFarByte
	pop hl
	inc de
	ret

.next_halfword
	push af
	ld a, b
	ld h, d
	ld l, e
	inc de
	inc de
	call GetFarHalfword
	pop af
	ret

.get_block_location
	push af
	push bc
	push de
	ld a, l
	add a, 4
	ld d, a
	ld a, h
	add a, 4
	ld e, a
	call GetBlockLocation
	pop de
	pop bc
	pop af
	ret

.handle_block
	jr z, .handle_flag_list_block
	push bc
	push af
	push hl
	ld c, 0
.flag_loop
	call .next_halfword
	call .check_event
	rl c
	dec a
	jr nz, .flag_loop
	ld a, b
	ld b, 0
	ld h, d
	ld l, e
	add hl, bc
	call GetFarByte
	pop hl
	call .apply
	pop bc
	ld a, 1
.bit_loop
	add a, a
	dec b
	jr nz, .bit_loop
	pop bc
	add a, e
	ld e, a
	ret nc
	inc d
	ret

.handle_flag_list_block
	push hl
.list_loop
	call .next_halfword
	ld a, h
	inc a
	jr z, .do_else
	call .check_event
	jr c, .found_event
	inc de
	jr .list_loop
.do_else
	ld a, l
	pop hl
.apply
	cp -1
	ret z
	ld [hl], a
	ret
.found_event
	call .next_byte
	pop hl
	call .apply
.exit_loop
	inc de
	call .next_byte
	inc a
	ret z
	inc de
	jr .exit_loop

.check_event
	push bc
	push de
	ld d, h
	ld e, l
	ld c, 0
	ld b, a
	sla d
	rl c
	srl d
	push bc
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld a, c
	pop bc
	cp 1
	sbc a
	inc a
	xor c
	rra
	ld a, b
	pop de
	pop bc
	ret
