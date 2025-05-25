InitializePokerusTimer:
	ld hl, wRTCBaseDay
	ld de, wPokerusTimerDay
	ld bc, wStartDateEnd - wPokerusTimerDay
	rst CopyBytes
	ret

CheckRTCTimers:
	ld hl, RTCTimers
	jr .handleLoop
.loop
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop af
	call CheckTimerDependentEvent
	CheckEngine ENGINE_RTC_TIMERS_ENABLED
	ret z
.handleLoop
	ld a, [hli]
	and a
	jr nz, .loop
	ret

MACRO rtctimer
	db \1 ; time unit basepoint
	dw \2 ; timer pointer
	dw \3 ; function pointer
	rept 7 - \1
		shift
		db \3 ; time to compare by
	endr
ENDM

RTCTimers:
	rtctimer RTC_TIMER_SECONDS, wTimeMachineTimer, EnableTimeMachine, 0, 0, 1, 0, 0, 0
RTCTimersExcludingTimeMachineTimer:
	rtctimer RTC_TIMER_DAYS, wDailyResetTimer, ResetDailyFlags, 0, 0, 1
	rtctimer RTC_TIMER_DAYS, wPokerusTimerDay, ApplyPokerusTick, 0, 0, 1
	db 0

CheckTimerDependentEvent:
; bc = function
; de = timer
; hl = time comparison
	push de
	push bc
	push af
	push hl
	ld h, d
	ld l, e
	ld b, a
	call CalcTimeSince
	pop hl
	pop af
	; a = 7 - a
	cpl
	add 7 + 1
	ld c, a
	call CompareTimeSinceWithTimeRequiredToPass
	pop de ; function
	pop bc ; timer
	ret c

	push hl ; end address
	push bc
	call _de_
	pop hl ; timer
	call CopyCurrentTimeToTimer
	pop hl ; end address
	ret

CompareTimeSinceWithTimeRequiredToPass:
; Return no carry if enough time has passed
	ld de, wYearsSince
	call StringCmp
	push af
	ld b, 0
	add hl, bc
	pop af
	ret

UpdateTimerStatusesIfResetTime:
	call CheckRTCStatus
	add a
	ret nc

DoTimeMachine:
	ld a, $ff
	ld [wDailyFlags], a
	ResetEngine ENGINE_RTC_TIMERS_ENABLED
	ld hl, wTimeMachineTimer

CopyCurrentTimeToTimer:
	push hl
	call UpdateTime
	pop hl
	ld a, [wCurDay]
	ld [hli], a
	ldh a, [hHours]
	ld [hli], a
	ldh a, [hMinutes]
	ld [hli], a
	ldh a, [hSeconds]
	ld [hli], a
	ld a, [wCurYear]
	ld [hli], a
	ld a, [wCurMonth]
	ld [hl], a
	ret

ResetDailyFlags:
	xor a
	ld [wDailyFlags], a
	ret

ApplyPokerusTick:
	ld b, MAX_POKERUS_DAYS
	ld a, [wYearsSince]
	and a
	jr nz, .do_apply_pokerus_tick
	ld a, [wMonthsSince]
	and a
	jr nz, .do_apply_pokerus_tick
	ld a, [wDaysSince]
	ld b, a
.do_apply_pokerus_tick
	jpba _ApplyPokerusTick

EnableTimeMachine:
	CheckEngine ENGINE_RTC_TIMERS_ENABLED
	ret nz
	ld hl, RTCTimersExcludingTimeMachineTimer
	jr .handleLoop
.loop
	push af
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CopyCurrentTimeToTimer
	pop hl
	pop af
	ld bc, 4
	add hl, bc
	; a = 7 - a
	cpl
	add 7 + 1
	add l
	ld l, a
	adc h
	sub l
	ld h, a
.handleLoop
	ld a, [hli]
	and a
	jr nz, .loop
	SetEngine ENGINE_RTC_TIMERS_ENABLED
	ret

CalcTimeSince:
; calc time since using the index in b as a basepoint
	push hl
	push bc
	xor a
	ld hl, wYearsSince
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	call UpdateTime
	pop bc
	pop hl

	and a
	inc hl
	inc hl
	inc hl
	ld d, h
	ld e, l
	dec b
	jr z, .FromSecs
	dec b
	jr z, .FromMins
	dec hl
	dec b
	jr z, .FromHours
	dec hl
	dec b
	jr z, .FromDays
	push hl
	ld c, e
	ld a, [wCurMonth]
	ld e, a
	ld h, d
	ld a, [wCurYear]
	ld d, a
	ld a, h
	pop hl
	dec b
	jr z, .FromMonths
	ld h, a
	ld l, c
	inc hl
	dec b
	jr z, .FromYears
	ret

.FromSecs
	ldh a, [hSeconds]
	sub [hl]
	jr nc, .no_seconds_carry
	add 60
.no_seconds_carry
	ld [wSecondsSince], a ; seconds since
.FromMins
	dec hl
	ldh a, [hMinutes]
	sbc [hl]
	jr nc, .no_minutes_carry
	add 60
.no_minutes_carry
	ld [wMinutesSince], a ; minutes since
.FromHours
	dec hl
	ldh a, [hHours]
	sbc [hl]
	jr nc, .no_hours_carry
	add 24
.no_hours_carry
	ld [wHoursSince], a ; hours since
.FromDays
	dec hl
	ld a, [wCurMonth]
	ld e, a
	ld a, [wCurYear]
	ld d, a
	ld a, [wCurDay]
	sbc [hl]
	jr nc, .no_days_carry
	push hl
	push af
	push de
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hli]
	ld d, a
	ld e, [hl]
	call GetMaxDateTableEntryBasedOnMonthAndYear
	pop de
	pop af
	add [hl]
	pop hl
.no_days_carry
	ld [wDaysSince], a
.FromMonths
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, e
	sbc [hl]
	jr nc, .no_months_carry
	add 12
.no_months_carry
	ld [wMonthsSince], a
	dec hl
.FromYears
	ld a, d
	sbc [hl]
	ld [wYearsSince], a
	ret
