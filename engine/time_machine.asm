TimeMachine:
	CheckEngine ENGINE_RTC_TIMERS_ENABLED
	jr nz, .continue
	ld a, 3
	ld [wItemEffectSucceeded], a
	ld hl, .recharge_text
	jp PrintText

.continue
	ld hl, .booted_up_text
	call PrintText
	ld de, SFX_BOOT_PC
	call PlayWaitSFX
	call ButtonSound
	; bring up clock interface; bail if player cancels
	ld hl, wJumptableIndex
	ld de, wJumptableIndexAndBufferVarsTemp
	ld bc, (wcf69 + 1) - wJumptableIndex
	push hl
	push de
	push bc
	rst CopyBytes
	callba CalendarTimeSetFromTimeMachine
	pop bc
	pop hl
	pop de
	push af
	rst CopyBytes
	pop af
	jr nc, .skip
	callba DoTimeMachine
	ld hl, .script
	jp QueueScript

.skip
	ld a, 4
	ld [wItemEffectSucceeded], a
	ret

.recharge_text
	ctxt "The Time Machine"
	line "needs to recharge!"
	prompt

.booted_up_text
	ctxt "<PLAYER> booted up"
	line "the Time Machine!"
	done

.script
	showtext .used_text
	playsound SFX_WARP_TO
	applymovement PLAYER, .TeleportFrom
	scriptstartasm
	ld c, 1
	call FadeToWhite
	ld c, 10
	call DelayFrames
	ld c, 1
	call FadeOutPals
	scriptstopasm
	playsound SFX_WARP_FROM
	applymovement PLAYER, .TeleportTo
	pause 5
	callasm .LoadNewTime
	jumptext .arrived_text

.TeleportFrom
	teleport_from
	step_end

.TeleportTo
	teleport_to
	step_end

.LoadNewTime
	ld hl, wStringBuffer2 + 1
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld bc, wStringBuffer1
	callba PrintHoursMins
	ld a, "@"
	ld [bc], a
	ld a, [wStringBuffer2]
	inc a
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	ld hl, wStringBuffer3
	and a
	jr z, .day_below_ten
	add a, "0"
	ld [hli], a
.day_below_ten
	ld a, c
	add a, "0"
	ld [hli], a
	ld a, " "
	ld [hli], a
	ld a, [wStringBuffer2 + 4]
	callba CopyMonthName
	ld a, " "
	ld [hli], a
	ld a, "2"
	ld [hli], a
	ld a, [wStringBuffer2 + 5]
	ld c, 100
	call SimpleDivide
	push bc
	ld c, 10
	call SimpleDivide
	ld c, a
	pop af
	add a, "0"
	ld [hli], a
	ld a, b
	add a, "0"
	ld [hli], a
	ld a, c
	add a, "0"
	ld [hli], a
	ld [hl], "@"
	ret

.used_text
	ctxt "<PLAYER> activated"
	line "the Time Machine!"
	sdone

.arrived_text
	ctxt "You've arrived at"
	line "the chosen time!"

	para "It is <STRBF1> on"
	line "<STRBF3>."
	done
