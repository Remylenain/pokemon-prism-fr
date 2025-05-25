BattleIntroSlidingPics:
	ld hl, rIE
	set LCD_STAT, [hl]
	ldh a, [rSVBK]
	push af
	wbk BANK(wLYOverrides)
	call .InitSlidingIntro
	ld a, LOW(rSCX)
	ld [wLCDCPointer], a
	call .LoopSlidingIntro
	xor a
	ld [wLCDCPointer], a
	pop af
	ldh [rSVBK], a
	ld hl, rIE
	res LCD_STAT, [hl]
	ret

.InitSlidingIntro
	call .ClearLYOverrides
	ld a, $90
	ldh [hSCX], a
	ld a, %11100100
	call DmgToCgbBGPals
	lb de, %11100100, %11100100
	jp DmgToCgbObjPals

.LoopSlidingIntro
	lb de, $90, $72
	ld a, $49 ; 73
.loop1
	push af
	ld c, LOW(rLY)
.loop2
	ldh a, [c]
	cp $60 ; 96
	jr c, .loop2
	ld a, d
	ldh [hSCX], a
	call .SlideEnemyPic
	inc e
	inc e
	dec d
	dec d
	pop af
	dec a
	push af
	call nz, .SlidePlayerPic
	call DelayFrame
	pop af
	jr nz, .loop1
	ret

.SlidePlayerPic
	push de
	ld hl, wSprites + 1 ; x pixel
	ld c, $12 ; 3 * 6
	ld de, $4
.loop3
	dec [hl]
	dec [hl]
	add hl, de
	dec c
	jr nz, .loop3
	pop de
	ret

.ClearLYOverrides
	ld hl, wLYOverrides
	ld a, $90
	ld bc, SCREEN_HEIGHT_PX
	jp ByteFill

.SlideEnemyPic
	ld hl, wLYOverrides
	ld a, d
	ld c, $3e ; 0-61
.loop4
	ld [hli], a
	dec c
	jr nz, .loop4
	ld a, e
	ld c, $22 ; 62-95
.loop5
	ld [hli], a
	dec c
	jr nz, .loop5
	xor a
	ld c, $30 ; 96-143
.loop6
	ld [hli], a
	dec c
	jr nz, .loop6
	ret
