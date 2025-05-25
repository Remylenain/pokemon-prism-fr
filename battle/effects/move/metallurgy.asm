BattleCommand_Vaporize:
; vaporize
	lb bc, WATER, 1
	jr BattleCommand_ChangeType

BattleCommand_Metallurgy:
; metallurgy
	lb bc, STEEL, 0
BattleCommand_ChangeType:
; c: target (0=USER, 1=TARGET)
; b: type

; If not part (type b), change second type to (type b)
; If part (type b), change to pure (type b)
; If pure (type b), the move fails
	ldh a, [hBattleTurn]
	xor c
	ld hl, wBattleMonType1
	jr z, .ok
	ld hl, wEnemyMonType1
.ok
	ld de, 0
	ld a, [hli]
	cp b
	jr z, .is_primary_type
	ld a, [hld]
	cp b
	jr z, .change_type
	ld e, .partial_type_texts - .whole_type_texts
	inc hl
	jr .change_type

.is_primary_type
	ld a, [hl]
	cp b
	jp z, FailedGeneric
.change_type
	ld a, b
	ld [hl], a
	ld [wd265], a
	push de
	push bc
	predef GetTypeName
	call AnimateCurrentMove
	pop bc
	pop de
	ld hl, .whole_type_texts
	add hl, de
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.whole_type_texts
	dw UserBecameTypeText
	dw TargetBecameTypeText
.partial_type_texts
	dw UserBecameTypePartialText
	dw TargetBecameTypePartialText
