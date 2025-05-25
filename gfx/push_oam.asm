LoadPushOAM::
	ld hl, PushOAMCode
	lb bc, (PushOAMCodeEnd - PushOAMCode), LOW(hPushOAM)
.loop
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .loop
	ret

PushOAMCode:
	ldh [c], a
.loop
	dec b
	jr nz, .loop
	ret
PushOAMCodeEnd:
