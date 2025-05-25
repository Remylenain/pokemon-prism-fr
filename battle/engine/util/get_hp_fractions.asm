GetSixteenthMaxHP:
	call GetQuarterMaxHP
	; quarter result
	srl c
	srl c
	; round up
	ld a, c
	and a
	ret nz
	inc c
	ret

GetEighthMaxHP:
; output: bc
	call GetQuarterMaxHP
; assumes nothing can have 1024 or more hp
; halve result
	srl c
; round up
	ld a, c
	and a
	ret nz
	inc c
	ret

GetThirdMaxHP:
	call GetMaxHP
	ld a, b
	ldh [hDividend], a
	ld a, c
	ldh [hDividend + 1], a
	ld a, 3
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ldh a, [hQuotient + 1]
	ld b, a
	ldh a, [hQuotient + 2]
	ld c, a
	or b
	ret nz
	inc c
	ret

GetQuarterMaxHP:
; output: bc
	call GetMaxHP

; quarter result
	srl b
	rr c
	srl b
	rr c

; assumes nothing can have 1024 or more hp
; round up
	ld a, c
	and a
	ret nz
	inc c
	ret

GetHalfMaxHP:
; output: bc
	call GetMaxHP

; halve result
	srl b
	rr c

; floor = 1
	ld a, c
	or b
	ret nz
	inc c
	ret

GetMaxHP:
; output: bc, wCurHPAnimMaxHP

	ld hl, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonMaxHP
.ok
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld b, a

	ld a, [hl]
	ld [wCurHPAnimMaxHP], a
	ld c, a
	ret
