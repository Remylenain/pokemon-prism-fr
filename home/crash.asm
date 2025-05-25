Crash::
	di
	ld b, b ; BGB source code breakpoint
	ldh [hCrashRST], a
	ldh a, [hCrashSavedA]
	ld [hCrashSP], sp
	ld sp, wCrashStack
	push hl
	push de
	push bc
	push af
	call DisableLCD
	xor a
	ldh [rVBK], a
	ld hl, vFontTiles
	call FarCopyFontToHL
	ld a, BANK(_Crash)
	ld [MBC3RomBank], a
	jp _Crash

CrashGetFarByteFromCrashBank::
	ldh a, [hROMBank]

CrashGetFarByte::
	ld [MBC3RomBank], a
	ld a, [hl]
	push af
	ld a, BANK(_Crash)
	ld [MBC3RomBank], a
	pop af
	ret
