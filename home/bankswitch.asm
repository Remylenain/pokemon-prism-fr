_GenericBankswitch::
	;this function expects that the calling code will be followed by a single byte, indicating what bankswitch to perform
	;$00 - $7f: ROM bankswitch
	;$80 - $8f: SRAM bankswitch/bank load (0-f)
	;$90 - $97: WRAM bankswitch/bank load (0-7)
	;$98 - $99: VRAM bankswitch/bank load (0-1)
	;$9a: SRAM close
	;$e0 - $e7: ROM bankswitch by register
	;$e8 - $ef: SRAM bankswitch by register
	;$f0 - $f7: WRAM bankswitch by register
	;$f8 - $ff: VRAM bankswitch by register
	;register bankswitches use the lower 3 bits to select the register, in the usual way (0 - 7 in order: b, c, d, e, h, l, [hl], a)
	;$9b - $df are undefined and should not be used
	push af
	push hl
	ld hl, sp + 4
	inc [hl]
	ld a, [hli]
	jr nz, .no_l_overflow
	inc [hl]
.no_l_overflow
	ld h, [hl]
	ld l, a
	dec hl
	ld a, [hl]
	pop hl
	cp $e0
	jr nc, .switch_by_register
	cp $80
	jr c, .ROM
	cp $90
	jr c, .SRAM
	cp $98
	jr c, .WRAM
	cp $9a
	jr c, .VRAM
	jr z, .SRAM_close
	pop af
	ldh [hCrashSavedA], a
	ld a, 12
	jp Crash

.ROM
	call Bankswitch
	pop af
	ret

.SRAM
	and $f
	call GetSRAMBank
	pop af
	ret

.WRAM
	ldh [rSVBK], a
	pop af
	ret

.VRAM
	ldh [rVBK], a
	pop af
	ret

.SRAM_close
	call CloseSRAM
	pop af
	ret

.switch_by_a
	ld hl, sp + 5
	ld h, [hl]
	jr .loaded_a

.switch_by_register
	push hl
	push af
	or $f8
	inc a
	jr z, .switch_by_a
	sub $99 ;converts the value in a to a "ld a, reg" instruction, where "reg" is given by the lower 3 bits of a
	ldh [hBankswitchLoadRoutine], a
	ld a, $c9
	ldh [hBankswitchLoadRoutine + 1], a
	call hBankswitchLoadRoutine
.loaded_a
	pop af
	swap a
	rlca
	and 3
	ld l, a
	ld a, h
	jr z, .ROM_from_reg
	dec l
	jr z, .SRAM_from_reg
	dec l
	jr z, .WRAM_from_reg

.VRAM_from_reg
	ldh [rVBK], a
	jr .done_reg

.SRAM_from_reg
	and $f
	call GetSRAMBank
	jr .done_reg

.WRAM_from_reg
	ldh [rSVBK], a
	jr .done_reg

.ROM_from_reg
	and $7f
	call Bankswitch

.done_reg
	pop hl
	pop af
	ret

GetSRAMBank::
; switch to sram bank a
	push af
; latch clock data
	ld a, 1
	ld [MBC3LatchClock], a
; enable sram/clock write
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
; select sram bank
	pop af
	ld [MBC3SRamBank], a
	ret

CloseSRAM::
	push af
	xor a
; reset clock latch for next time
	ld [MBC3LatchClock], a
; disable sram/clock write
	ld [MBC3SRamEnable], a
	pop af
	ret
