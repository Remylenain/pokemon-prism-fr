JR_C_OP      EQU $38
JP_C_OP      EQU $da
LD_B_XX_OP   EQU $06
RET_OP       EQU $c9
RET_C_OP     EQU $d8

LoadDEDCryHeader::
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

PlayDEDCry::
	jpba _PlayDEDCry

PlayDEDSamples::
	call StackCallInBankB
	; end of function

	call WriteDEDTreeToWRAM
	ld a, [hli] ; length
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, 8
	ldh [hCurSampVal], a
	ld c, 1 ; initialize the bit counter
	ld a, (1 << rTAC_ON) | rTAC_16384_HZ
	ldh [rTAC], a
	inc d
	inc e
	jr .handleLoop
.loop
	push de
	ld de, wDEDTempSamp
	ld a, 16
.loop2
	ldh [hLoopCounter], a
	push de
	ld e, 8
	ldh a, [hCurBitStream]
	call wGetDEDByte
	push af
	ldh a, [hCurSampVal]
	add b
	and $f
	ldh [hCurSampVal], a
	swap a
	ld d, a
	pop af
	call wGetDEDByte
	ldh [hCurBitStream], a
	ldh a, [hCurSampVal]
	add b
	and $f
	ldh [hCurSampVal], a
	or d
	pop de
	ld [de], a
	inc de
	ldh a, [hLoopCounter]
	dec a
	jr nz, .loop2
	ei
	xor	a ; reset carry
.haltLoop
	halt ; wait until timer interrupt hits
	jr nc, .haltLoop
	di
	ldh [rNR51], a
	ldh [rNR30], a
	push hl
	ld hl, wDEDTempSamp
CUR_WAVE = rWAVE
rept 16
	ld a, [hli]
	ldh [CUR_WAVE], a
CUR_WAVE = CUR_WAVE + 1
endr
	ld a, $80
	ldh [rNR30], a
	ld a, $87
	ldh [rNR34], a
	ldh a, [hDEDNR51Mask]
	ldh [rNR51], a

	pop hl
	pop de
.handleLoop
	dec e
.jumptoloop
	jr nz, .loop
	dec d
	jr nz, .jumptoloop ; jr out of range otherwise
	ret

WriteDEDTreeToWRAM:
	ld d, h
	ld e, l
	ld hl, wGetDEDByte
.loop
; control codes are styled as follows
; 1100 xxxx 0000 yyyy: leaf leaf, x if 1, y if 0
; 1000 xxxx: internal leaf, x if 1
; 0xxx xxxx: internal internal, x is jump offset
; 1111 1111: terminator, signifies end of stream
	ld a, [de]
	cp $ff
	jr z, .end
	add a
	jr nc, .huffhuff
	add a
	jr nc, .huffleaf
.leafleaf
	call .leafcommon
	ld a, LD_B_XX_OP
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, RET_OP
	ld [hli], a
	jr .loop
.huffleaf
	call .leafcommon
	jr .loop
.huffhuff
	call WriteInlineGetBit
	ld a, JR_C_OP
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop
.end
	inc de
	ld h, d
	ld l, e
	ret
.leafcommon
	call WriteInlineGetBit
	ld a, LD_B_XX_OP
	ld [hli], a
	ld a, [de]
	inc de
	and $f
	ld [hli], a
	ld a, RET_C_OP
	ld [hli], a
	ret

WriteInlineGetBit:
	ld bc, GetDEDBit
.loop
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, c
	cp LOW(GetDEDBit.end)
	jr nz, .loop
	ret

GetDEDBit:
	dec c
	jr nz, .skip
	ld a, [hli]
	ld c, e
.skip
	add a
.end
