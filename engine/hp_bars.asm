DrawPlayerHP:
	ld a, 1
	jr DrawHP

DrawEnemyHP:
	ld a, 2

DrawHP:
	ld [wWhichHPBar], a
	push hl
	push bc
	ld a, [wMonType]
	cp BOXMON
	jr z, .has_HP

	ld a, [wTempMonHP]
	ld b, a
	ld a, [wTempMonHP + 1]
	ld c, a

; Any HP?
	or b
	jr nz, .has_HP

	xor a
	ld c, a
	ld e, a
	ld a, 7
	ld d, a
	jr .begin_drawing

.has_HP
	ld a, [wTempMonMaxHP]
	ld d, a
	ld a, [wTempMonMaxHP + 1]
	ld e, a
	ld a, [wMonType]
	cp BOXMON
	jr nz, .compute_pixels

	ld b, d
	ld c, e

.compute_pixels
	predef ComputeHPBarPixels
	ld a, 7
	ld d, a
	ld c, a

.begin_drawing
	ld a, c
	pop bc
	ld c, a
	pop hl
	push de
	push hl
	push hl
	call _DrawBattleHPBar
	pop hl

; Print HP
	ld bc, $17 ; move (3,1)
	add hl, bc
	ld de, wTempMonHP
	ld a, [wMonType]
	cp BOXMON
	jr nz, .not_boxmon
	ld de, wTempMonMaxHP
.not_boxmon
	lb bc, 2, 3
	call PrintNum

	ld a, "/"
	ld [hli], a

; Print max HP
	ld de, wTempMonMaxHP
	lb bc, 2, 3
	call PrintNum
	pop hl
	pop de
	ret

_DrawBattleHPBar:
	push hl
	push de
	push bc

	ld a, e
	dec a
	jr z, .skipHalf
	srl e
.skipHalf

; Place 'HP:'
	ld a, $70
	add b
	add b
	ld [hli], a
	ld a, $60
	ld [hli], a
	inc a
	ld [hli], a

; Draw a template
	push hl
	ld a, $62 ; empty bar
.template
	ld [hli], a
	dec d
	jr nz, .template
	ld a, $6b ; bar end
	add b
	ld [hl], a
	pop hl

; Safety check # pixels
	ld a, e
	and a
	jr nz, .fill
	ld a, c
	and a
	jr z, .done
	ld e, 1

.fill
; Keep drawing tiles until pixel length is reached
	ld a, e
	sub TILE_WIDTH
	jr c, .lastbar

	ld e, a
	ld a, $6a ; full bar
	ld [hli], a
	ld a, e
	and a
	jr z, .done
	jr .fill

.lastbar
	ld a, $62  ; empty bar
	add e      ; + e
	ld [hl], a

.done
	pop bc
	pop de
	pop hl
	ret
