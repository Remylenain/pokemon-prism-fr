QueueScript::
; Push pointer hl in the current bank to wQueuedScriptBank.
	ldh a, [hROMBank]

FarQueueScript::
; Push pointer a:hl to wQueuedScriptBank.
	ld [wQueuedScriptBank], a
	ld a, l
	ld [wQueuedScriptAddr], a
	ld a, h
	ld [wQueuedScriptAddr + 1], a
	ret

IsScriptRunFromASM:
	push hl
	ld hl, wScriptFlags
	bit 4, [hl]
	pop hl
	ret

Script_getnthstring:
	call GetScriptHalfwordOrVar_HL
	ld a, [wScriptBank]
	call StackCallInBankA

	ldh a, [hScriptVar]
	call GetNthString
	ld a, h
	ldh [hScriptHalfwordVar], a
	ld a, l
	ldh [hScriptHalfwordVar + 1], a
	ld d, h
	ld e, l
	call GetScriptByte
	cp $ff
	ret z
	call GetNthStringBuffer
	jr CopyName2

CopyName1::
; Copies the name from de to wStringBuffer2
	ld hl, wStringBuffer2
	; fallthrough

CopyName2::
; Copies the name from de to hl
	push bc
	ld b, "@"
.loop
	ld a, [de]
	inc de
	ld [hli], a
	cp b
	jr nz, .loop
	pop bc
	ret
