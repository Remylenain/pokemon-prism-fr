InitMG_Mobile_LinkTradePalMap:
	hlcoord 0, 0, wAttrMap
	lb bc, 16, 2
	ld a, 4
	call MG_Mobile_Layout_FillBox
	ld a, 3
	ldcoord_a 0, 1, wAttrMap
	ldcoord_a 0, 14, wAttrMap
	hlcoord 2, 0, wAttrMap
	lb bc, 8, 18
	ld a, 5
	call MG_Mobile_Layout_FillBox
	hlcoord 2, 8, wAttrMap
	lb bc, 8, 18
	ld a, 6
	call MG_Mobile_Layout_FillBox
	hlcoord 0, 16, wAttrMap
	lb bc, 2, SCREEN_WIDTH
	ld a, 4
	call MG_Mobile_Layout_FillBox
	ld a, 3
	lb bc, 6, 1
	hlcoord 6, 1, wAttrMap
	call MG_Mobile_Layout_FillBox
	ld a, 3
	lb bc, 6, 1
	hlcoord 17, 1, wAttrMap
	call MG_Mobile_Layout_FillBox
	ld a, 3
	lb bc, 6, 1
	hlcoord 6, 9, wAttrMap
	call MG_Mobile_Layout_FillBox
	ld a, 3
	lb bc, 6, 1
	hlcoord 17, 9, wAttrMap
	call MG_Mobile_Layout_FillBox
	ld a, 2
	hlcoord 2, 16, wAttrMap
	ld [hli], a
	ld a, 7
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, 2
	ld [hl], a
	hlcoord 2, 17, wAttrMap
	inc a
	ld bc, 6
	jp ByteFill

MG_Mobile_Layout_FillBox:
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

_LinkBattleSendReceiveAction:
	call .StageForSend
	push af
	call PlaceWaitingText

	pop af
	ld [wPlayerLinkAction], a
	ld a, $ff
	ld [wOtherPlayerLinkAction], a
.waiting
	call LinkTransfer
	call DelayFrame
	ld a, [wOtherPlayerLinkAction]
	inc a
	jr z, .waiting

	ld b, 10
.receive
	call DelayFrame
	call LinkTransfer
	dec b
	jr nz, .receive

	ld b, 10
.acknowledge
	call DelayFrame
	call LinkDataReceived
	dec b
	jr nz, .acknowledge

	ld a, [wOtherPlayerLinkAction]
	ld [wBattleAction], a
	ret

.StageForSend
	ld a, [wBattlePlayerAction]
	and a
	jr nz, .switch
	ld a, [wCurPlayerMove]
	ld b, BATTLEACTION_STRUGGLE
	cp STRUGGLE
	jr z, .struggle
	ld b, BATTLEACTION_SKIPTURN
	cp $ff
	jr z, .struggle
	ld a, [wCurMoveNum]
	jr .use_move

.switch
	ld a, [wCurPartyMon]
	add BATTLEACTION_SWITCH1
	jr .use_move

.struggle
	ld a, b

.use_move
	and $0f
	ret

Function49811:
	ld hl, Palette_49826
	ld de, wOriginalBGPals + 2 palettes
	ld bc, 6 palettes
	ld a, BANK(wOriginalBGPals)
	call FarCopyWRAM
	jpba ApplyPals

Palette_49826:
	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 31, 00, 00
	RGB 31, 31, 31

	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 15, 23, 30
	RGB 31, 31, 31

	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 16, 16, 16
	RGB 31, 31, 31

	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 25, 07, 04
	RGB 31, 31, 31

	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 03, 22, 08
	RGB 31, 31, 31

	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 29, 28, 09
	RGB 31, 31, 31

PlaceWaitingText::
	hlcoord 3, 10
	lb bc, 1, 11

	ld a, [wBattleMode]
	and a
	jr z, .notinbattle

	call TextBox
	jr .proceed

.notinbattle
	predef Predef_LinkTextbox

.proceed
	hlcoord 4, 11
	ld de, .Waiting
	call PlaceText
	ld c, 50
	jp DelayFrames

.Waiting
	ctxt "Waiting<...>!"
	done
