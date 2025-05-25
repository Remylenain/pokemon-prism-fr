; result codes (in a):
; 0: pass
; 1: daa flags failed
; 2: DIV write failed
; 3: pop timing failed

CheckEmulator::
	ld hl, $0060
	push hl
	pop af
	daa
	push af
	pop hl
	ld a, l
	sub $40
	ld a, 1
	ret nz

	di
	ld a, 3
	ldh [rDIV], a
	ldh a, [rDIV]
	ei
	and a
	ld a, 2
	ret nz

	di
	ld d, 0
	ld hl, rDIV
	ld [hl], a

	ld a, 13           ; 0
.wait1
	dec a
	jr nz, .wait1
	nop                ; 53
	ld [hSPBuffer], sp ; 54
	ld sp, hl          ; 59
	pop bc             ; 61
	or c
	jr nz, .pop_fail
	ld [hl], a

	ld a, 14   ; 0
.wait2
	dec a
	jr nz, .wait2
	dec bc
	nop
	ld sp, hl  ; 60
	pop bc     ; 62
	dec c
	; a = 0 because of the .wait2 loop
	jr z, .skip2
.pop_fail
	ld a, 3
.skip2
	jp RestoreStackReti
