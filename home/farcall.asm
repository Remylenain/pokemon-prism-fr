IF !DEF(GBS)
FarCall_Pointer::
; Call a:[hl]
; Preserves other registers
	ldh [hBuffer], a
	ldh a, [hROMBank]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr FarCall_RetrieveBankAndCallFunction

FarCall_hl::
; Call a:hl
; Preserves other registers
	ldh [hBuffer], a
	ldh a, [hROMBank]
	push af
	jr FarCall_RetrieveBankAndCallFunction

FarPointerCall_AfterIsInArray::
	inc hl

; fallthrough
FarPointerCall::
	ldh a, [hROMBank]
	push af
	ld a, [hli]
	ldh [hBuffer], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr FarCall_RetrieveBankAndCallFunction
ENDC

StackFarCall::
; Call the following dba pointer on the stack
; Preserves a, bc, de, hl
	ldh [hFarCallSavedA], a
	ld a, l
	ldh [hPredefTemp], a
	ld a, h
	ldh [hPredefTemp + 1], a

	pop hl
	ld a, [hli]
	ldh [hBuffer], a
	add a
	jr c, .noPush
	inc hl
	inc hl
	push hl
	dec hl
	dec hl
.noPush
	ldh a, [hROMBank]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a

; fallthrough
FarCall_RetrieveBankAndCallFunction:
	ldh a, [hBuffer]
	and $7f
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	call RetrieveHLAndCallFunction

; fallthrough
ReturnFarCall::
; We want to retain the contents of f.
; To do this, we use tricky kewl stack manip!!11!!1!.
	ldh [hBuffer], a
	push af
	push hl
	ld hl, sp + 2 ; flags of a
	ld a, [hli] ; read
	inc l ; inc hl
	ld [hl], a ; and write to the flags of the saved bank
	pop hl
	pop af
	pop af
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	ldh a, [hBuffer]
	ret

IF !DEF(GBS)
StackCallInBankB:
	ld a, b
	jr StackCallInBankA

ProtectedBankStackCall:
	ldh a, [hROMBank]
ENDC

; fallthrough
StackCallInBankA:
	ldh [hBuffer], a
	ld a, h
	ldh [hPredefTemp + 1], a
	ld a, l
	ldh [hPredefTemp], a
	pop hl
	ldh a, [hROMBank]
	push af
	jr FarCall_RetrieveBankAndCallFunction

IF !DEF(GBS)
StackCallInMapScriptHeaderBank::
	ld a, [wMapScriptHeaderBank]
	jr StackCallInBankA

SafeStackCallInWramBankA:
	ldh [hBuffer], a
	jr StackCallInWRAMBankA_continue

ProtectedWRAMBankStackCall::
	ldh a, [rSVBK]
	jr StackCallInWRAMBankA

RunFunctionInWRA6::
	ld a, BANK(wDecompressScratch)

; fallthrough
StackCallInWRAMBankA:
	ldh [hBuffer], a
	ld a, h
	ldh [hPredefTemp + 1], a
	ld a, l
	ldh [hPredefTemp], a

; fallthrough
StackCallInWRAMBankA_continue:
	pop hl
	ldh a, [rSVBK]
	push af
	ldh a, [hBuffer]
	ldh [rSVBK], a
	call RetrieveHLAndCallFunction
	ldh [hBuffer], a
	pop af
	ldh [rSVBK], a
	ldh a, [hBuffer]
	ret
ENDC

RetrieveHLAndCallFunction:
	push hl
	ld hl, hPredefTemp
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hFarCallSavedA]
	ret

IF !DEF(GBS)
StackCallInVBK1:
	ld a, h
	ldh [hPredefTemp + 1], a
	ld a, l
	ldh [hPredefTemp], a

; fallthrough
SafeStackCallInVBK1:
	pop hl
	ldh a, [rVBK]
	push af
	ld a, 1
	ldh [rVBK], a
	call RetrieveHLAndCallFunction
	pop af
	ldh [rVBK], a
	ret
ENDC
