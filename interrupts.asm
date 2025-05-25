SECTION "Interrupts", ROM0

	assert @ == $40 ; vblank
	jp VBlank

GetFarWRAMByte::
	call StackCallInWRAMBankA

	ld a, [hl]
	ret

	assert @ == $48 ; STAT
	jp wLCD

GetFarByte::
	; retrieve a single byte from a:hl, and return it in a.
	; bankswitch to new bank
	call StackCallInBankA

	ld a, [hl]
	ret

	assert @ == $50 ; timer
	scf
	reti

PlayStereoCry::
	call PlayStereoCry2
	jp WaitSFX

	assert @ == $58 ; serial
	jp Serial

FarCopyWRAM::
	call StackCallInWRAMBankA

	rst CopyBytes
	ret

	assert @ == $60 ; joypad
	reti
