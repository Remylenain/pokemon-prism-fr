ClearJoypad::
	xor a
; Pressed this frame (delta)
	ldh [hJoyPressed], a
; Currently pressed
	ldh [hJoyDown], a
	ret

Joypad::
; Read the joypad register and translate it to something more
; workable for use in-game. There are 8 buttons, so we can use
; one byte to contain all player input.

; Updates:

; hJoypadReleased: released this frame (delta)
; hJoypadPressed: pressed this frame (delta)
; hJoypadDown: currently pressed
; hJoypadSum: pressed so far

; Any of these three bits can be used to disable input.
	ld a, [wDisableJoypad]
	and %11010000
	ret nz

; If we're saving, input is disabled.
	ld a, [wGameLogicPause]
	and a
	ret nz

; We can only get four inputs at a time.
; We take d-pad first for no particular reason.
	ld a, R_DPAD
	ld c, LOW(rJOYP)
	ldh [c], a
; Read twice to give the request time to take.
	ldh a, [c]
	ldh a, [c]

; The Joypad register output is in the lo nybble (inversed).
; We make the hi nybble of our new container d-pad input.
	cpl
	and $f
	swap a

; We'll keep this in b for now.
	ld b, a

; Buttons make 8 total inputs (A, B, Select, Start).
; We can fit this into one byte.
	ld a, R_BUTTONS
	ldh [c], a
; Wait for input to stabilize.
rept 6
	ldh a, [c]
endr
; Buttons take the lo nybble.
	cpl
	and $f
	or b
	ld b, a

; Reset the joypad register since we're done with it.
	ld a, $30
	ldh [c], a

IF 0
	;APRIL FOOLS: invert control scheme
	ld a, b
	rlca
	and $aa
	ld e, a
	ld a, b
	rrca
	and $55
	or e
	ld b, a
ENDC

; To get the delta we xor the last frame's input with the new one.
	ldh a, [hJoypadDown] ; last frame
	ld e, a
	xor b
	ld d, a
; Released this frame:
	and e
	ldh [hJoypadReleased], a
; Pressed this frame:
	ld a, d
	and b
	ldh [hJoypadPressed], a

; Add any new presses to the list of collective presses:
	ld c, a
	ldh a, [hJoypadSum]
	or c
	ldh [hJoypadSum], a

; Currently pressed:
	ld a, b
	ldh [hJoypadDown], a

; Now that we have the input, we can do stuff with it.

; For example, soft reset:
	and A_BUTTON | B_BUTTON | SELECT | START
	cp  A_BUTTON | B_BUTTON | SELECT | START
	jp z, Reset

; Or update input counters:
	ldh a, [hJoypadPressed]
	ld hl, wAButtonCount
	ld b, a
	ld c, 8
.loop
	srl b
	rept 4
		ld a, [hl]
		adc 0
		ld [hli], a
	endr
	dec c
	jr nz, .loop

	ret

GetJoypad::
; Update mirror joypad input from hJoypadDown (real input)

; hJoyReleased: released this frame (delta)
; hJoyPressed: pressed this frame (delta)
; hJoyDown: currently pressed

; bit 0 A
;     1 B
;     2 SELECT
;     3 START
;     4 RIGHT
;     5 LEFT
;     6 UP
;     7 DOWN

	push hl
	push de
	push bc
	push af

; To get deltas, take this and last frame's input.
	ldh a, [hJoypadDown] ; real input
	ld b, a
	ldh a, [hJoyDown] ; last frame mirror
	ld e, a

; Released this frame:
	xor b
	ld d, a
	and e
	ldh [hJoyReleased], a

; Pressed this frame:
	ld a, d
	and b
	ldh [hJoyPressed], a

; It looks like the collective presses got commented out here.
;	ld c, a

; Currently pressed:
	ld a, b
	ldh [hJoyDown], a ; frame input
.done
	jp PopOffRegsAndReturn

JoyTitleScreenInput::
	call JoyTextDelay

	ldh a, [hJoyDown]
	cp D_UP | SELECT | B_BUTTON
	jr z, .keyCombo
	ldh a, [hJoyLast]
	and START | A_BUTTON
	jr nz, .keyCombo

	call DelayFrame
	dec c
	jr nz, JoyTitleScreenInput
; a key combo wasn't pressed
	and a
	ret
.keyCombo
	scf
	ret

JoyWaitAorB::
	call GetJoypad
	ldh a, [hJoyPressed]
	and A_BUTTON | B_BUTTON
	ret nz
	call CheckHoldToMashButtonHeld
	ret nz
	call RTC
	call DelayFrame
	jr JoyWaitAorB

Script_waitbutton::
; script command 0x54
	ld a, [wTextBoxFlags]
	push af
	set 1, a
	ld [wTextBoxFlags], a
	call WaitButton
	pop af
	ld [wTextBoxFlags], a
	ret

WaitButton::
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	call ApplyTilemapInVBlank
	call JoyWaitAorB
	pop af
	ldh [hOAMUpdate], a
	ret

Script_endtext::
; will crash if not called in scripting bank
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	call ApplyTilemapInVBlank
	jr .handleLoop

.loop
	call RTC
	call DelayFrame
.handleLoop
	call GetJoypad
	ldh a, [hJoyPressed]
	and A_BUTTON | B_BUTTON | D_PAD
	jr nz, .pressed
	call CheckHoldToMashButtonHeld
	jr z, .loop
.pressed
	pop af
	ldh [hOAMUpdate], a
	call Script_closetext
	jp Script_end

JoyTextDelay::
	call GetJoypad
	ldh a, [hInMenu]
	and a
	ldh a, [hJoyPressed]
	jr z, .notInMenu
	ldh a, [hJoyDown]
.notInMenu
	ldh [hJoyLast], a
	ldh a, [hJoyPressed]
	and a
	jr z, .checkFrameDelay
	ld a, 15
	ld [wTextDelayFrames], a
	ret

.checkFrameDelay
	ld a, [wTextDelayFrames]
	and a
	jr z, .restartFrameDelay
	xor a
	ldh [hJoyLast], a
	ret

.restartFrameDelay
	ld a, 5
	ld [wTextDelayFrames], a
	ret

CheckIfAOrBPressed:
	call JoyTextDelay
	ldh a, [hJoyLast]
_Autoscroll:
	and A_BUTTON | B_BUTTON
	ret nz

; fallthrough
CheckHoldToMashButtonHeld:
; checks if the hold to mash setting button is held
	ld a, [wOptions2]
	and %11
	ret z

	dec a
	ldh a, [hJoyDown]
	jr z, .start

	; Check A+B. If both are held, autoscroll for both A&B and A|B.
	; Otherwise, autoscroll if the option is set to A or B, not A and B
	and A_BUTTON | B_BUTTON
	ret z
	cp A_BUTTON | B_BUTTON
	jr z, _Autoscroll
	ld a, [wOptions2]
	; nz if A or B, z if A and B
	and 1
	ret

.start
	and START
	ret

WaitPressAorB_BlinkCursor::
	call BlinkCursor
	call CheckIfAOrBPressed
	ret nz
	call DelayFrame
	jr WaitPressAorB_BlinkCursor

SimpleWaitPressAorB::
	call CheckIfAOrBPressed
	ret nz
	call DelayFrame
	jr SimpleWaitPressAorB

ButtonSound::
	ld a, [wLinkMode]
	and a
	jr nz, .linkMode
	call .doInputLoop
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

.linkMode
	ld c, 65
	jp DelayFrames

.doInputLoop
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
.inputWaitLoop
	call BlinkCursor
	call CheckIfAOrBPressed
	jr nz, .receivedInput
	call RTC
	ld a, 1
	ldh [hBGMapMode], a
	call DelayFrame
	jr .inputWaitLoop

.receivedInput
	pop af
	ldh [hOAMUpdate], a
	ret

BlinkCursor:
	ldh a, [hVBlankCounter]
	bit 4, a ; change cursor state every 16 frames
	ld a, "▼"
	jr nz, .cursorOn
	lda_coord 17, 17
.cursorOn
	ldcoord_a 18, 17
	ret
