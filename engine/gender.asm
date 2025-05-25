GetGender:
; Return the gender of a given monster (wCurPartyMon/wCurOTMon/wWildMon).
; When calling this function, a should be set to an appropriate wMonType value.

; return values:
; a = 1: f = nc|nz; male
; a = 0: f = nc|z;  female
;        f = c:  genderless

; This is determined by comparing the Attack and Speed DVs
; with the species' gender ratio.

; We need the gender ratio to do anything.
	ld a, [wCurPartySpecies]
	dec a
	ld hl, BaseData + wBaseGender - wCurBaseData
	ld bc, BaseData1 - BaseData
	rst AddNTimes
	ld a, BANK(BaseData)
	call GetFarByte

; If it is one of the special values ($00, $fe, $ff), we know the answer. Don't calculate anything.
	add a, 1 ;$ff becomes 0 and carry
	ret c
	inc a ;$fe (original value) becomes 0 w/o carry
	ret z
	sub 2 ;restore the original value; $00 will obviously set the zero flag
	jr z, .male

; Otherwise, just store it for later.
	push af

; Figure out what type of monster struct we're looking at.

; 0: party mon
	ld hl, wPartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wMonType]
	and a
	jr z, .PartyMon

; 1: OT party mon
	ld hl, wOTPartyMon1DVs
	dec a
	jr z, .PartyMon

; 2: box mon (in sBox)
	ld hl, sBoxMon1DVs
	ld bc, BOXMON_STRUCT_LENGTH
	dec a
	jr z, .sBoxMon

; 3: temp mon (in wTempMon)
	ld hl, wTempMonDVs
	dec a
	jr z, .DVs

; else: wild mon
	ld hl, wEnemyMonDVs
	jr .DVs

.sBoxMon
; sBoxMon data is read directly from SRAM.
	sbk BANK(sBox)

; Get our place in the party/box.
.PartyMon
	ld a, [wCurPartyMon]
	rst AddNTimes

.DVs
; Attack DV
	ld a, [hli]
	and $f0
	ld b, a
; Speed DV
	ld a, [hl]
	and $f0
	swap a
; Put our DVs together.
	or b
	ld b, a

; Close SRAM just in case. Closing it when it's closed is a no-op.
	scls

; The higher the ratio, the more likely the monster is to be female. Values above the ratio are male, and the rest are female.
	pop af
	cp b
	jr c, .male
	xor a
	ret

.male
	ld a, 1
	and a
	ret
