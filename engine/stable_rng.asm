StableRandom::
	; in: hl: pointer to 8-byte RNG state
	; out: a: random value; other registers preserved
	push bc
	push de
	push hl
	call .advance_left_register
	call .check_right_register_cycles
	call .advance_right_register
	inc hl
	inc hl
	inc hl
	call .advance_selector_register
	pop hl
	push hl
	rlca
	rlca
	ld c, a
	and 3
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	pop hl
	push hl
	ld e, 5
	add hl, de
	ld a, c
	ld c, [hl]
	rlca
	rlca
	and 3
	call .combine_register_values
	pop hl
	pop de
	pop bc
	ret

.advance_left_register
	; in: hl: pointer to left register
	; out: hl: pointer to RIGHT register
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hld]
	ld b, a
	or c
	or d
	or e
	call z, .reseed_left_register
	ld a, e
	xor d
	ld e, a
	ld a, d
	xor c
	ld d, a
	ld a, c
	xor b
	ld c, a
	ld [hld], a
	ld a, d
	ld [hld], a
	ld [hl], e
	sla e
	rl d
	rl c
	inc hl
	ld a, [hl]
	xor e
	ld [hli], a
	ld a, [hl]
	xor d
	ld [hli], a
	ld a, [hl]
	xor c
	ld [hld], a
	ld b, a
	ld c, [hl]
	sla c
	rl b
	sbc a
	and 1
	dec hl
	xor [hl]
	ld [hld], a
	ld a, [hl]
	xor b
	ld [hli], a
	inc hl
	inc hl
	inc hl
	ret

.reseed_left_register
	; in: hl: pointer to left register + 2
	; out: hl preserved; bcde new seed
	ld de, 5
	push hl
	add hl, de
	call .advance_selector_register
	ld b, a
	call .advance_selector_register
	ld c, a
	call .advance_selector_register
	ld d, a
	call .advance_selector_register
	ld e, a
	pop hl
	inc hl
	ld a, b
	ld [hld], a ;only b needs to be written back, since the rest will be handled by the main function
	ret

.check_right_register_cycles
	; in: hl: pointer to right register
	; out: hl preserved
	inc hl
	inc hl
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld d, a
	or c
	ld e, [hl]
	push hl
	jr z, .check_long_cycles
	ld hl, .right_register_short_cycles - 1
	ld b, (.right_register_short_cycles_end - .right_register_short_cycles) / 3 + 1
.short_cycle_handle_loop
	inc hl
	dec b
	jr z, .pop_ret
.short_cycle_loop
	ld a, [hli]
	cp c
	ld a, [hli]
	jr nz, .short_cycle_handle_loop
	cp d
	jr nz, .short_cycle_handle_loop
	ld a, e
	cp [hl]
	jr nz, .short_cycle_handle_loop
	inc hl
.copy_right_register_state
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, [hl]
	pop hl
	inc hl
	ld [hli], a
	ld a, c
	ld [hld], a
	dec hl
	ld [hl], b
	ret

.check_long_cycles
	ld hl, .right_register_long_cycles
.long_cycle_loop
	ld a, [hli]
	and a
	jr z, .pop_ret
	cp e
	jr nz, .long_cycle_loop
	ld a, [hl]
	and a
	jr z, .start_short_cycles
	pop hl
	ld [hl], a
	ret

.start_short_cycles
	pop hl
	push hl
	inc hl
	inc hl
	inc hl
	call .advance_selector_register
	ld hl, .right_register_short_cycles
	jr .copy_right_register_state

.pop_ret
	pop hl
	ret

.right_register_short_cycles
	db $72, $4f, $9f
	db $7b, $1a, $7b
	db $84, $e5, $56
	db $8d, $b0, $32
.right_register_short_cycles_end
	db 0, 0
.right_register_long_cycles
	db 1, 2, 4, 8, 13, 17, 23, 26, 29, 58
	db 0

.advance_right_register
	; in: hl: pointer to right register
	; out: hl preserved
	ld a, [hli]
	cp 210
	jr c, .right_carry_OK
	sub 210
.right_carry_OK
	ld d, a
	ld a, [hli]
	ld e, a
	ld c, [hl]
	or c
	or d
	jr z, .right_register_needs_reseed
	ld a, c
	and e
	inc a
	jr nz, .right_register_OK
	ld a, d
	cp 209
	jr nz, .right_register_OK
.right_register_needs_reseed
	call .reseed_right_register
.right_register_OK
	ld a, e
	ld [hld], a
	push hl
	ld b, 0
	ld h, b
	ld l, d
	ld a, 210
	rst AddNTimes
	ld a, l
	ld b, h
	pop hl
	ld [hld], a
	ld [hl], b
	ret

.reseed_right_register
	; in: hl: pointer to right register + 2
	; out: hl preserved, cde new seed
	inc hl
	call .advance_selector_register
	ld c, a
	call .advance_selector_register
	ld d, a
	sub 210
	jr c, .carry_reseed_OK
	ld d, a
.carry_reseed_OK
	call .advance_selector_register
	ld e, a
	dec hl
	ret

.advance_selector_register
	; in: hl: pointer to selector register
	; out: all registers but a preserved; a = new selector
	push bc
	ld a, [hl]
	ld b, 0
	rra
	rr b
	rra
	rr b
	ld a, [hl]
	swap a
	rrca
	and $f8
	add a, b
	add a, [hl]
	add a, 29
	ld [hl], a
	pop bc
	ret

.combine_register_values
	and a
	jr z, .add_registers
	dec a
	jr z, .xor_registers
	dec a
	jr z, .subtract_registers
	ld a, c
	sub b
	ret
.subtract_registers
	ld a, b
	sub c
	ret
.add_registers
	ld a, b
	add a, c
	ret
.xor_registers
	ld a, b
	xor c
	ret

Generate8ByteSeedWithMixing_DefaultValue::
	ld c, 5

; generate an 8 byte seed for stable RNG, then mix it 5 times
Generate8ByteSeedWithMixing::
	push hl
	call Generate8ByteSeed
	pop hl
.loop
	call StableRandom
	dec c
	jr nz, .loop
	ret

Generate8ByteSeed::
	ld d, 8
.outerLoop
	lb bc, 0, 2
.innerLoop
	call Random
	rrca
	rl b
	ldh a, [hRandomAdd]
	rrca
	rl b
	ldh a, [rDIV]
	rrca
	rl b
	dec c
	jr nz, .innerLoop
	ldh a, [rSTAT]
	and %11
	cp 1
	push af
	call DelayFrame
	ldh a, [rTIMA]
	rrca
	rl b
	pop af
	ld a, b
	rla
	ld [hli], a
	dec d
	jr nz, .outerLoop
	ret

VariableStableRandom::
; input: stable RNG index in e
; output: random value in a
	ld a, [wSaveFileExists]
	and a
	jp z, Random
	push hl
	push de
	push bc
	call .VariableStableRandom
	pop bc
	pop de
	pop hl
	ret

.VariableStableRandom:
	push de
	callba CompareLoadedAndSavedPlayerID
	pop de
	jp nz, Random
	ld a, BANK(wStableRNGData)
	call StackCallInWRAMBankA
	; end of function

	ld hl, wStableRNGData
	ld bc, (wStableRNGDataEntryEnd - wStableRNGDataEntry)
	ld a, e
	rst AddNTimes
	ld a, [hli]
	or [hl]
	inc hl
	push af
	call StableRandom
	ld d, a
	pop af
	jr nz, .decrementCurrentStableRNG
	ld a, e
	ld hl, sStableRNGData
	rst AddNTimes
	sbk BANK(sStableRNGData)
	inc [hl]
	jr nz, .noOverflow
	inc hl
	inc [hl]
.noOverflow
	scls
	ld a, d
	ret
.decrementCurrentStableRNG
	dec hl
	ld a, [hld]
	ld c, [hl]
	ld b, a
	dec bc
	ld a, c
	ld [hli], a
	ld [hl], b
	ld a, d
	ret
