PrintLetterDelay::
; Wait before printing the next letter.

; The text speed setting in wOptions is actually a frame count:
; 	fast: 1 frame
; 	mid:  3 frames
; 	slow: 5 frames

; wTextBoxFlags[!0] and A or B override text speed with a one-frame delay.
; wOptions[4] and wTextBoxFlags[!1] disable the delay.
; non-scrolling text?

	ld a, [wTextBoxFlags]
	bit 1, a
	ret z
	bit 0, a
	jr z, .forceFastScroll

	ld a, [wOptions]
	bit NO_TEXT_SCROLL, a
	ret nz
	and %11
	ret z
	ld a, 1
	ldh [hBGMapHalf], a
.forceFastScroll
	push hl
	push de
	push bc
; force fast scroll?
	ld a, [wTextBoxFlags]
	bit 0, a
	ld a, 2
	jr z, .updateDelay
; text speed
	ld a, [wOptions]
	and %11
	rlca
.updateDelay
	dec a
	ld [wTextDelayFrames], a
.textDelayLoop
	ld a, [wTextDelayFrames]
	and a
	jr z, .done
	call DelayFrame
	call GetJoypad
; Finish execution if A or B is pressed
	ldh a, [hJoyDown]
	and A_BUTTON | B_BUTTON
	jr z, .textDelayLoop
.done
	jp PopOffBCDEHLAndReturn

PrintNum::
	jpba _PrintNum

PrintBCDNumber::
	jpba _PrintBCDNumber
