RIJON_LATITUDE EQU 33.2 ; don't set this too high
EARTH_AXIAL_TILT EQU 23.43712

GetNthDayOfYear:
	ld a, [wCurYear]
	call IsLeapYear
	ld de, MaxDatesCommon
	jr nc, .common
	ld de, MaxDatesLeap
.common
	ld hl, 0
	ld b, l
.loop
	ld a, [wCurMonth]
	cp b
	jr z, .done
	push bc
	ld a, [de]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	inc b
	inc de
	jr .loop
.done
	ld b, 0
	ld a, [wCurDay]
	ld c, a
	add hl, bc
	ret

GetTimeOfDay::
	call GetNthDayOfYear
	inc hl
	ld c, l
	ld b, h
	ld hl, wSunriseOffsetDate
	ld a, [hli]
	cp c
	jr nz, .calcsunrise
	ld a, [hl]
	cp b
	jp z, .skipsunrisecalc
	; recalculate sunrise time again if the saved date is different
.calcsunrise
	; -tan(lat)*tan(arcsin(sin(-eat)*cos(n+10/365)))
	ld a, b
	ld [hld], a
	ld [hl], c
	ld l, c
	ld h, b
	ld bc, 9 ; offset this from winter solstice (Dec 21) instead
	add hl, bc
	xor a
	ldh [hDividend], a
	ldh [hDividend + 3], a
	ld a, h
	ldh [hDividend + 1], a
	ld a, l
	ldh [hDividend + 2], a
	ld a, HIGH(366) ; == HIGH(365)
	ldh [hDivisor], a
	ld a, [wCurYear]
	call IsLeapYear
	; a = carry ? LOW(366) : LOW(365)
	ccf
	sbc a
	add LOW(366)
	ldh [hDivisor + 1], a
	predef DivideLong
	ldh a, [hLongQuotient + 3]
	add $40 ; cos
	call GetDemoSine
	cp $80
	push af ; store sign
	jr c, .plus1
	cpl
.plus1
	add a
	ld c, a
	ld b, 0
	ld de, SIN(DIV(EARTH_AXIAL_TILT, 360.0))
	call Multiply16
	; tan(arcsin(x)) = x/√(1-x^2)
	ld a, c
	ldh [hDividend], a
	ld a, b ; should be 0
	ldh [hDividend + 1], a
	ld hl, 0
	rst AddNTimes
	xor a
	sub l
	ld e, a
	xor a
	sbc h
	ld d, a
	callba GetSquareRoot
	ld a, b
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ldh a, [hQuotient]
	ld b, a
	ldh a, [hQuotient + 1]
	ld c, a
	ld de, TAN(DIV(RIJON_LATITUDE, 360.0))
	call Multiply16
	srl b
	rr c
	ld a, b
	and a
	jr nz, .max
	pop af
	ld a, c
	jr c, .plus2
	xor a
	sub c
.plus2
	ld [wSunriseOffset], a
	jr .skipsunrisecalc
.max
	pop af
	; a = carry ? $7f : $80
	sbc a
	add $80
	ld [wSunriseOffset], a
.skipsunrisecalc
	ldh a, [hHours]
	push af
	ld bc, 60
	ld h, b
	ld l, b
	rst AddNTimes
	ldh a, [hMinutes]
	ld c, a
	add hl, bc
	ld d, b
	rept 3
	srl h
	rr l
	rr d
	endr
	ld a, h
	ldh [hDividend], a
	ld a, l
	ldh [hDividend + 1], a
	ld a, d
	ldh [hDividend + 2], a
	ld a, 1440 / 8
	ldh [hDivisor], a
	ld b, 3
	predef Divide
	ldh a, [hQuotient + 2]
	sub $40
	call GetDemoSine
	ld b, a
	pop af
	cp 12
	jr nc, .pm
	ld a, [wSunriseOffset]
	sub 11
	call .compare
	jr c, .nite
	ld a, [wSunriseOffset]
	add 44
	call .compare
	jr c, .morn
	jr .day
.pm
	ld a, [wSunriseOffset]
	call .compare
	jr c, .nite
.day
	ld a, DAY
	ld [wTimeOfDay], a
	ret
.morn
	ld a, MORN
	ld [wTimeOfDay], a
	ret
.nite
	ld a, NITE
	ld [wTimeOfDay], a
	ret

.compare
	ld c, a
	cp $80
	jr nc, .minus
	ld a, b
	cp $80
	jr nc, .cc
	cp c
	ret
.minus
	ld a, b
	cp $80
	jr c, .cc
	cp c
	ret
.cc
	ccf
	ret

StageRTCTimeForSave:
	sbk BANK(sRTC)
	ld hl, sRTC
	ld de, wRTC
	ld bc, sRTCEnd - sRTC
	rst CopyBytes
StageRTCTimeForSave_NoLoadFromSRAM:
	call GetClock
	call FixTime
	ld hl, wRTC
	push hl
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
	pop hl
	sbk BANK(sRTC)
	ld de, sRTC
	ld bc, sRTCEnd - sRTC
	rst CopyBytes
	jp CloseSRAM

SaveRTC:
	ld a, $a
	ld [MBC3SRamEnable], a
	call LatchClock
	ld hl, MBC3RTC
	ld a, $c
	ld [MBC3SRamBank], a
	res 7, [hl]
	ld a, BANK(sRTCStatusFlags)
	ld [MBC3SRamBank], a
	xor a
	ld [sRTCStatusFlags], a
	jp CloseSRAM

StartClock::
	call GetClock
	call CheckForBadRTC
	call RecordRTCStatus

StartRTC:
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	call LatchClock
	ld a, RTC_DH
	ld [MBC3SRamBank], a
	ld a, [MBC3RTC]
	res 6, a ; halt
	ld [MBC3RTC], a
	jp CloseSRAM

CheckForBadRTC:
	ld a, %10000000
	ld hl, hRTCDayHi
	bit 7, [hl]
	ret nz
	bit 6, [hl]
	ret nz
	xor a
	ret

_InitTime::
	call GetClock
	ld hl, hRTCSeconds
	ld de, wRTCBaseSeconds

	ld a, [wStringBuffer2 + 3]
	sub [hl]
	dec hl
	jr nc, .okay_secs
	add 60
.okay_secs
	ld [de], a
	dec de

	ld a, [wStringBuffer2 + 2]
	sbc [hl]
	dec hl
	jr nc, .okay_mins
	add 60
.okay_mins
	ld [de], a
	dec de

	ld a, [wStringBuffer2 + 1]
	sbc [hl]
	jr nc, .okay_hrs
	add 24
.okay_hrs
	ld [de], a

	push af
	ld a, [hld]
	and 1
	ld b, a
	ld c, [hl]
	pop af
	ld a, [wStringBuffer2]
	adc c
	ld c, a
	jr nc, .noCarry
	inc b
.noCarry
	ld a, [wStringBuffer2 + 5]
	ld d, a
	ld a, [wStringBuffer2 + 4]
	ld e, a
	call SubtractDayOffsetFromMonthAndYear
	ld a, c
	ld [wRTCBaseDay], a
	ld a, e
	ld [wRTCBaseMonth], a
	ld a, d
	ld [wRTCBaseYear], a
	ret
