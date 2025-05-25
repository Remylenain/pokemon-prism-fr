ResetGameTime::
	xor a
	ld hl, wGameTimeCap
	ld bc, wGameTimeFrames - wGameTimeCap + 1
	jp ByteFill

GameTimer:
	ld c, (wTextDelayFrames - wGenericDelay) + 1
	ld hl, wGenericDelay
.delayCountersLoop
; handle delay counters
	ld a, [hl]
	and a
	jr z, .noDelay
	dec [hl]
.noDelay
	inc hl
	dec c
	jr nz, .delayCountersLoop
	ldh a, [rSVBK]
	push af
	call UpdateGameTimer
	call UpdateStopwatches
	pop af
	ldh [rSVBK], a
	ret

UpdateGameTimer::
; Increment the game timer by one frame.
; The game timer is capped at 9999:59:59.00.

; Note that this time will be off by ~16.35 seconds per hour (6 min 32.4 sec/day, about three orders of magnitude worse than usual clock tolerances).
; This results from assuming 60 fps when the exact (i.e., spec) value is 262144/4389 (~59.73).

; Don't update if game logic is paused.
	ld a, [wGameLogicPause]
	and a
	ret nz

; Is the timer paused?
	ld hl, wGameTimerPause
	bit 0, [hl]
	ret z

	ld a, BANK(wGameTimeCap)
	ldh [rSVBK], a

; Is the timer already capped?
	ld hl, wGameTimeCap
	bit 0, [hl]
	ret nz
	ld a, 60
	ld b, a

; +1 frame
	ld hl, wGameTimeFrames
	inc [hl]
	sub [hl]
	ret nz
	ld [hld], a
; +1 second
	ld a, b
	inc [hl]
	sub [hl]
	ret nz
	ld [hld], a
; +1 minute
	ld a, b
	inc [hl]
	sub [hl]
	ret nz
	ld [hld], a
; +1 hour
	ld a, [hld]
	ld d, [hl]
	ld e, a
	inc de
; Cap the timer after 10000 hours.
	ld a, d
	cp HIGH(10000)
	jr c, .ok

	ld a, e
	cp LOW(10000)
	jr nc, .maxIGT
.ok
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

.maxIGT
	ld hl, wGameTimeCap
	set 0, [hl]

	ld a, b ; 9999:59:59.00
	ld [wGameTimeMinutes], a
	ld [wGameTimeSeconds], a
	ret
