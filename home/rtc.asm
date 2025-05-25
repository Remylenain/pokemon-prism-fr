RTC::
; update time and time-sensitive palettes

; RTC enabled?
	ld a, [wSpriteUpdatesEnabled]
	and a
	ret z

	call UpdateTime

; obj update on?
	ld a, [wVramState]
	rra ; obj update
	ret nc

TimeOfDayPals::
	jpba _TimeOfDayPals
