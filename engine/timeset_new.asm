SetClockGUI:
	ld a, [Options]
	push af
	set NO_TEXT_SCROLL, a
	ld [Options], a
.loop_back
	ld hl, .SetTimeText
	call PrintText
.loop
	call ClockJoypadAction
	push af
	call UpdateHourHand
	call UpdateMinuteHand
	call DelayFrame
	pop af
	jr nc, .loop
	ld hl, .IsThisTimeOkayText
	call PrintText
	call YesNoBox
	jr c, .loop_back
	pop af
	ld [Options], a
	ret

.SetTimeText
	text "◀/▶: Move hands"
	line "  A: Confirm"
	done

.IsThisTimeOkayText
	start_asm
	ld a, [wInitHourBuffer]
	ld d, a
	ld a, [wInitMinuteBuffer]
	ld e, a
	callba PrintHoursMins
	ld hl, .finish
	ret

.finish
	text ""
	line "Is this correct?"
	done

ClockJoypadAction_loop:
	call DelayFrame
ClockJoypadAction:
	call GetJoypad
	ldh a, [hJoyPressed]
	and A_BUTTON | D_LEFT | D_RIGHT
	jr z, ClockJoypadAction_loop
	bit D_LEFT_F, a
	jr nz, .left
	bit D_RIGHT_F, a
	jr nz, .right
	scf
	ret

.left
	ld a, [wInitMinuteBuffer]
	sub 1 ; sets carry for 0
	jr nc, .okay_left_minute
	ld a, 59
.okay_left_minute
	ld [wInitMinuteBuffer], a
	ret nc
	ld a, [wInitHourBuffer]
	sub 1 ; sets carry for 0
	jr nc, .okay_left_hour
	ld a, 23
.okay_left_hour
	ld [wInitHourBuffer], a
	and a
	ret

.right
	ld a, [wInitMinuteBuffer]
	cp 60
	jr c, .okay_right_minute
	ld a, -1
.okay_right_minute
	add a, 1 ; sets carry for -1
	ld [wInitMinuteBuffer], a
	ret nc
	ld a, [wInitHourBuffer]
	cp 24
	jr c, .okay_right_hour
	ld a, -1
.okay_right_hour
	inc a
	ld [wInitHourBuffer], a
	and a
	ret

UpdateHourHand:
	call GetHourHandAngle
	ld e, a
	ld [wHourHandAngle], a
	call GetClockHandTile
	ld [wHourHandTile], a
	call GetClockHandOAMFlags
	ld [wHourHandFlags], a
	ld c, 2
	ld hl, wSprites
.loop
	ld d, c
	swap d
	srl d
	ld a, [wHourHandAngle]
	ld e, a
	push de
	push hl
	call Sine
	ld a, [wClockCenterY]
	add h
	pop hl
	ld [hli], a
	pop de
	push hl
	call Cosine
	ld a, [wClockCenterX]
	add h
	pop hl
	ld [hli], a
	ld a, [wHourHandTile]
	ld [hli], a
	ld a, [wHourHandFlags]
	ld [hli], a
	dec c
	jr nz, .loop
	ret

UpdateMinuteHand:
	call GetMinuteHandAngle
	ld e, a
	ld [wMinuteHandAngle], a
	call GetClockHandTile
	ld [wMinuteHandTile], a
	call GetClockHandOAMFlags
	ld [wMinuteHandFlags], a
	ld c, 4
	ld hl, wSprites + 2 * 4
.loop
	ld d, c
	swap d
	srl d
	ld a, [wMinuteHandAngle]
	ld e, a
	push de
	push hl
	call Sine
	ld a, [wClockCenterY]
	add h
	pop hl
	ld [hli], a
	pop de
	push hl
	call Cosine
	ld a, [wClockCenterX]
	add h
	pop hl
	ld [hli], a
	ld a, [wMinuteHandTile]
	ld [hli], a
	ld a, [wMinuteHandFlags]
	ld [hli], a
	dec c
	jr nz, .loop
	ret

GetMinuteHandAngle:
; returns to e, value in 0..63
	ld a, [wInitMinuteBuffer]
	swap a
	ld b, a
	and $f
	ldh [hDividend], a
	ld a, b
	and $f0
	ldh [hDividend + 1], a
	ld a, 15
	jr FinishGetAngle

GetHourHandAngle:
; returns to a, value in 0..63
	push hl
	ld a, [wInitMinuteBuffer]
	ld l, a
	ld h, 0
	ld a, [wInitHourBuffer]
	cp 12
	jr c, .okay
	sub 12
.okay
	ld bc, 240
	rst AddNTimes
	ld a, h
	ldh [hDividend], a
	ld a, l
	ldh [hDividend + 1], a
	pop hl
	ld a, 45
FinishGetClockHandAngle:
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ldh a, [hQuotient + 2]
	ret

GetClockHandOAMFlags:
; angle in e, return to a
	push de
	push hl
	ld a, e
	swap a
	and 3
	ld e, a
	ld d, 0
	ld hl, .flags
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	ret

.flags
	db 0
	db OAM_Y_FLIP
	db OAM_X_FLIP | OAM_Y_FLIP
	db OAM_X_FLIP

GetClockHandTile:
; angle in a, return to a
	and $1f
	cp $10
	ret c
	ret z
	cpl
	inc a
	and $f
	ret
