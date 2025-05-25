CheckNickErrors::
; error-check monster nick before use
; input: de = nick location
	push bc
	push de
	ld b, PKMN_NAME_LENGTH
.check
	ld a, [de]
	cp "@"
	jr z, .end
	cp " "
	jr z, .ok
	add a, a
	jr c, .ok
	ld a, "?"
	ld [de], a
.ok
	inc de
	dec b
	jr nz, .check

; reached the end without finding a terminator -- change nick to "?@"
	pop de
	push de
	ld a, "?"
	ld [de], a
	inc de
	ld a, "@"
	ld [de], a
.end
	pop de
	pop bc
	ret
