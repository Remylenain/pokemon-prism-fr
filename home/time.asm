LatchClock::
; latch clock counter data
	xor a
	ld [MBC3LatchClock], a
	inc a
	ld [MBC3LatchClock], a
	ret

UpdateTime::
	CheckEngine ENGINE_TIME_ENABLED
	ret z
ForceUpdateTime::
	call GetClock
	call FixTime
	jpba GetTimeOfDay

GetClock::
; store clock data in hRTCDayHi-hRTCSeconds

; enable clock r/w
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a

; clock data is 'backwards' in hram

	call LatchClock
	ld hl, MBC3SRamBank
	ld de, MBC3RTC

	ld [hl], RTC_S
	ld a, [de]
	and $3f
	ldh [hRTCSeconds], a

	ld [hl], RTC_M
	ld a, [de]
	and $3f
	ldh [hRTCMinutes], a

	ld [hl], RTC_H
	ld a, [de]
	and $1f
	ldh [hRTCHours], a

	ld [hl], RTC_DL
	ld a, [de]
	ldh [hRTCDayLo], a

	ld [hl], RTC_DH
	ld a, [de]
	ldh [hRTCDayHi], a

; unlatch clock / disable clock r/w
	jp CloseSRAM

FixTime::
; add ingame time (set at newgame) to current time
;                   yr       mo       day     hr       min       sec
; store time in wCurYear, wCurMonth, wCurDay, hHours, hMinutes, hSeconds

	ldh a, [hRTCDayHi] ; DH
	bit 7, a
	ret nz ; don't update if rtc overflowed
	ld b, 60
; second
	ldh a, [hRTCSeconds] ; S
	ld c, a
	ld a, [wRTCBaseSeconds]
	add c
	sub b
	jr nc, .updatesec
	add b
.updatesec
	ldh [hSeconds], a

; minute
	ccf ; complement carry so that a second overflow would apply to minutes
	ldh a, [hRTCMinutes] ; M
	ld c, a
	ld a, [wRTCBaseMinutes]
	adc c
	sub b
	jr nc, .updatemin
	add b
.updatemin
	ldh [hMinutes], a

; hour
	ccf ; rotate carry
	ldh a, [hRTCHours] ; H
	ld c, a
	ld a, [wRTCBaseHours]
	adc c
	sub 24
	jr nc, .updatehr
	add 24
.updatehr
	ldh [hHours], a
	ccf
	push af
	ldh a, [hRTCDayHi]
	and %1
	ld b, a
	ldh a, [hRTCDayLo]
	ld c, a
	pop af
	ld a, [wRTCBaseDay]
	adc c
	ld c, a
	adc b
	sub c
	ld b, a
	ld a, [wRTCBaseYear]
	ld d, a
	ld a, [wRTCBaseMonth]
	ld e, a
	call AddDayOffsetToMonthAndYear
	ld a, c
	ld [wCurDay], a
	ld a, e
	ld [wCurMonth], a
	ld a, d
	ld [wCurYear], a
	ret

AddDayOffsetToMonthAndYear:
	call GetMaxDateTableEntryBasedOnMonthAndYear
.convertDayToYearLoop
	call SubtractBCByValueInHLIfBCIsGreaterThanValueInHL
	ret c
	inc hl
	inc e
	ld a, e
	cp 12
	jr c, .convertDayToYearLoop
	ld e, 0
	inc d
	ld a, d
	call GetMaxDateTableBasedOnYear
	jr .convertDayToYearLoop

SubtractDayOffsetFromMonthAndYear:
	call GetMaxDateTableEntryBasedOnMonthAndYear
.convertDayToYearLoop
	call SubtractBCByValueInHLIfBCIsGreaterThanValueInHL
	ret c
	dec hl
	dec e
	ld a, e
	inc a
	jr nz, .convertDayToYearLoop
	ld e, 11
	dec d
	ld a, d
	call GetMaxDateTableBasedOnYear
	ld a, e
	add l
	ld l, a
	jr nc, .convertDayToYearLoop
	inc h
	jr .convertDayToYearLoop

SubtractBCByValueInHLIfBCIsGreaterThanValueInHL:
	ld a, [hl]
	push bc
	call .SubtractBCByA
	pop bc
	ret c
	ld a, [hl]
	call .SubtractBCByA
	and a
	ret

.SubtractBCByA
	push de
	ld e, a
	ld d, 0
	ld a, c
	sub e
	ld c, a
	ld a, b
	sbc d
	ld b, a
	pop de
	ret

GetMaxDateTableEntryBasedOnMonthAndYear:
	ld a, d
	call GetMaxDateTableBasedOnYear
	ld a, e
	add l
	ld l, a
	ret nc
	inc h
	ret

GetMaxDateTableBasedOnYear:
	call IsLeapYear
	ld hl, MaxDatesCommon
	ret nc
	ld hl, MaxDatesLeap
	ret

MaxDatesCommon::
	; jan feb mar apr may jun jul aug sep oct nov dec
	db 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
MaxDatesLeap::
	db 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

IsLeapYear::
; return carry if year 2000+a is a leap year
; in the Gregorian calendar, 2100 and 2200 are not leap years
	cp 100
	ret z
	cp 200
	ret z
	and 3
	ret nz
	scf
	ret

InitTime::
	jpba _InitTime

ClearhRTC:
	xor a
	ldh [hRTCSeconds], a
	ldh [hRTCMinutes], a
	ldh [hRTCHours], a
	ldh [hRTCDayLo], a
	ldh [hRTCDayHi], a
	ret

PanicResetClock::
	call ClearhRTC

SetClock::
; set clock data from hram

; enable clock r/w
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a

; set clock data
; stored 'backwards' in hram

	call LatchClock
	ld hl, MBC3SRamBank
	ld de, MBC3RTC

; seconds
	ld [hl], RTC_S
	ldh a, [hRTCSeconds]
	ld [de], a
; minutes
	ld [hl], RTC_M
	ldh a, [hRTCMinutes]
	ld [de], a
; hours
	ld [hl], RTC_H
	ldh a, [hRTCHours]
	ld [de], a
; day lo
	ld [hl], RTC_DL
	ldh a, [hRTCDayLo]
	ld [de], a
; day hi
	ld [hl], RTC_DH
	ldh a, [hRTCDayHi]
	res 6, a ; make sure timer is active
	ld [de], a

; cleanup
	jp CloseSRAM ; unlatch clock, disable clock r/w

ClearRTCStatus::
; clear sRTCStatusFlags
	xor a
	push af
	sbk BANK(sRTCStatusFlags)
	pop af
	ld [sRTCStatusFlags], a
	jp CloseSRAM

RecordRTCStatus::
; append flags to sRTCStatusFlags
	ld hl, sRTCStatusFlags
	push af
	sbk BANK(sRTCStatusFlags)
	pop af
	or [hl]
	ld [hl], a
	jp CloseSRAM

CheckRTCStatus::
; check sRTCStatusFlags
	sbk BANK(sRTCStatusFlags)
	ld a, [sRTCStatusFlags]
	jp CloseSRAM
