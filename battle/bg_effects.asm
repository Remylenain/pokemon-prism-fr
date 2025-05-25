	const_def
	const BGSQUARE_SIX
	const BGSQUARE_FOUR
	const BGSQUARE_TWO
	const BGSQUARE_SEVEN
	const BGSQUARE_FIVE
	const BGSQUARE_THREE

; BG effects for use in battle animations.

ExecuteBGEffects:
	ld hl, wActiveBGEffects
	ld e, 5
.loop
	ld a, [hl]
	and a
	jr z, .next
	ld c, l
	ld b, h
	push hl
	push de
	call DoBattleBGEffectFunction
	pop de
	pop hl
.next
	ld bc, 4
	add hl, bc
	dec e
	jr nz, .loop
	ret

QueueBGEffect:
	ld hl, wActiveBGEffects
	ld e, 5
.loop
	ld a, [hl]
	and a
	jr z, .load
	ld bc, 4
	add hl, bc
	dec e
	jr nz, .loop
	scf
	ret

.load
	ld c, l
	ld b, h
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld a, [wBattleAnimTemp0]
	ld [hli], a
	ld a, [wBattleAnimTemp1]
	ld [hli], a
	ld a, [wBattleAnimTemp2]
	ld [hli], a
	ld a, [wBattleAnimTemp3]
	ld [hl], a
	ret

BattleBGEffect_End:
EndBattleBGEffect:
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld [hl], 0
	ret

DoBattleBGEffectFunction:
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld a, [hl]
	jumptable

BattleBGEffects:
	dw BattleBGEffect_End
	dw BattleBGEffect_FlashInverted
	dw BattleBGEffect_FlashWhite
	dw BattleBGEffect_WhiteHues
	dw BattleBGEffect_BlackHues
	dw BattleBGEffect_AlternateHues
	dw BattleBGEffect_06
	dw BattleBGEffect_07
	dw BattleBGEffect_08
	dw BattleBGEffect_HideMon
	dw BattleBGEffect_ShowMon
	dw BattleBGEffect_EnterMon
	dw BattleBGEffect_ReturnMon
	dw BattleBGEffect_Surf
	dw BattleBGEffect_Whirlpool
	dw BattleBGEffect_Teleport
	dw BattleBGEffect_NightShade
	dw BattleBGEffect_FeetFollow
	dw BattleBGEffect_HeadFollow
	dw BattleBGEffect_DoubleTeam
	dw BattleBGEffect_AcidArmor
	dw BattleBGEffect_RapidFlash
	dw BattleBGEffect_16
	dw BattleBGEffect_17
	dw BattleBGEffect_18
	dw BattleBGEffect_19
	dw BattleBGEffect_1a
	dw BattleBGEffect_1b
	dw BattleBGEffect_1c
	dw BattleBGEffect_1d
	dw BattleBGEffect_1e
	dw BattleBGEffect_1f
	dw BattleBGEffect_20
	dw BattleBGEffect_21
	dw BattleBGEffect_BounceDown
	dw BattleBGEffect_Dig
	dw BattleBGEffect_Tackle
	dw BattleBGEffect_25
	dw BattleBGEffect_26
	dw BattleBGEffect_27
	dw BattleBGEffect_28
	dw BattleBGEffect_Psychic
	dw BattleBGEffect_2a
	dw BattleBGEffect_2b
	dw BattleBGEffect_2c
	dw BattleBGEffect_2d
	dw BattleBGEffect_2e
	dw BattleBGEffect_2f
	dw BattleBGEffect_30
	dw BattleBGEffect_31
	dw BattleAnim_ResetLCDStatCustom
	dw BattleBGEffect_VibrateMon
	dw BattleBGEffect_WobbleMon
	dw BattleBGEffect_35
	dw BattleBGEffect_SlideInMon
	dw BattleBGEffect_SlideOutMon

BattleBGEffects_AnonJumptable:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	jp Jumptable

BattleBGEffects_IncrementJumptable:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	inc [hl]
	ret

BattleBGEffect_FlashInverted:
	ld de, .inverted
	jr BattleBGEffect_FlashContinue

.inverted
	db %11100100 ; 3210
	db %00011011 ; 0123

BattleBGEffect_FlashWhite:
	ld de, .white
	jr BattleBGEffect_FlashContinue

.white
	db %11100100 ; 3210
	db %00000000 ; 0000

BattleBGEffect_FlashContinue:
; current timer, flash duration, number of flashes
	ld a, 1
	ld [wBattleAnimTemp0], a
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .init
	dec [hl]
	ret

.init
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jp z, EndBattleBGEffect
	dec a
	ld [hl], a
	and 1
	ld l, a
	ld h, 0
	add hl, de
	ld a, [hl]
	ld [wBGP], a
	ret

BattleBGEffect_WhiteHues:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	jp c, EndBattleBGEffect
	ld [wBGP], a
	ret

.Pals
	db %11100100
	db %11100000
	db %11010000
	db -1


BattleBGEffect_BlackHues:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	jp c, EndBattleBGEffect
	ld [wBGP], a
	ret

.Pals
	db %11100100
	db %11110100
	db %11111000
	db -1

BattleBGEffect_AlternateHues:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	jp c, EndBattleBGEffect
	ld [wBGP], a
	ld [wOBP1], a
	ret

.Pals
	db %11100100
	db %11111000
	db %11111100
	db %11111000
	db %11100100
	db %10010000
	db %01000000
	db %10010000
	db -2

BattleBGEffect_06:
	ld de, .PalsCGB
	call BattleBGEffect_GetNthDMGPal
	ld [wOBP0], a
	ret

.PalsCGB
	db %11100100
	db %10010000
	db -2

BattleBGEffect_07:
	ld de, .PalsCGB
	call BattleBGEffect_GetNthDMGPal
	ld [wOBP0], a
	ret

.PalsCGB
	db %11100100
	db %11011000
	db -2

BattleBGEffect_08:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	ld [wBGP], a
	ret

.Pals
	db %00011011
	db %01100011
	db %10000111
	db -2

BattleBGEffect_HideMon:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw DisableBGUpdates_EndBattleBGEffect

.zero
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	hlcoord 12, 0
	lb bc, 7, 7
	jr z, .got_pointer
	hlcoord 2, 6
	lb bc, 6, 6
.got_pointer
	call ClearBox
	pop bc
	xor a
	ldh [hBGMapHalf], a
	ld a, 1
	ldh [hBGMapMode], a
	ret

DisableBGUpdates_EndBattleBGEffect:
	xor a
	ldh [hBGMapMode], a
	jp EndBattleBGEffect

BattleBGEffect_ShowMon:
	call BGEffect_CheckFlyDigStatus
	jp nz, EndBattleBGEffect
	call BGEffect_CheckBattleTurn
	ld de, .EnemyData
	jr z, .got_pointer
	ld de, .PlayerData
.got_pointer
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	jp BattleBGEffect_RunPicResizeScript

.PlayerData
	db  0, $31, 0
	db -1
.EnemyData
	db  3, $00, 3
	db -1

BattleBGEffect_FeetFollow:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw DisableBGUpdates_EndBattleBGEffect

.zero
	call BGEffect_CheckFlyDigStatus
	jr z, .not_flying_digging
	ld hl, wNumActiveBattleAnims
	inc [hl]
	jp EndBattleBGEffect

.not_flying_digging
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	ld a, ANIM_OBJ_PLAYERFEETFOLLOW
	ld [wBattleAnimTemp0], a
	ld a, 16 * 8 + 4
	jr .okay

.player_turn
	ld a, ANIM_OBJ_ENEMYFEETFOLLOW
	ld [wBattleAnimTemp0], a
	ld a, 6 * 8
.okay
	ld [wBattleAnimTemp1], a
	ld a, 8 * 8
	ld [wBattleAnimTemp2], a
	xor a
	ld [wBattleAnimTemp3], a
	callba QueueBattleAnimation
	pop bc
	ret

.one
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn_2
	hlcoord 12, 6
	lb bc, 1, 7
	jr .okay2

.player_turn_2
	hlcoord 2, 6
	lb bc, 1, 6
.okay2
	call ClearBox
	ld a, 1
	ldh [hBGMapMode], a
	pop bc
	ret

BattleBGEffect_HeadFollow:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw DisableBGUpdates_EndBattleBGEffect

.zero
	call BGEffect_CheckFlyDigStatus
	jr z, .not_flying_digging
	ld hl, wNumActiveBattleAnims
	inc [hl]
	jp EndBattleBGEffect

.not_flying_digging
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	ld a, ANIM_OBJ_PLAYERHEADFOLLOW
	ld [wBattleAnimTemp0], a
	ld a, 16 * 8 + 4
	jr .okay

.player_turn
	ld a, ANIM_OBJ_ENEMYHEADFOLLOW
	ld [wBattleAnimTemp0], a
	ld a, 6 * 8
.okay
	ld [wBattleAnimTemp1], a
	ld a, 8 * 8
	ld [wBattleAnimTemp2], a
	xor a
	ld [wBattleAnimTemp3], a
	callba QueueBattleAnimation
	pop bc
	ret

.one
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn_2
	hlcoord 12, 5
	lb bc, 2, 7
	jr .okay2

.player_turn_2
	hlcoord 2, 6
	lb bc, 2, 6
.okay2
	call ClearBox
	ld a, 1
	ldh [hBGMapMode], a
	pop bc
	ret

BattleBGEffect_27:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw .four

.zero
	call BattleBGEffects_IncrementJumptable
	call BGEffect_CheckBattleTurn
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	ld a, 8
	jr z, .okay
	inc a
.okay
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], a
	ret

.one
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	jr z, .user_2
	hlcoord 0, 6
	lb de, 8, 6
.row1
	push de
	push hl
.col1
	inc hl
	ld a, [hld]
	ld [hli], a
	dec d
	jr nz, .col1
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec e
	jr nz, .row1
	jr .okay2

.user_2
	hlcoord 19, 0
	lb de, 8, 7
.row2
	push de
	push hl
.col2
	dec hl
	ld a, [hli]
	ld [hld], a
	dec d
	jr nz, .col2
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec e
	jr nz, .row2
.okay2
	xor a
	ldh [hBGMapHalf], a
	inc a
	ldh [hBGMapMode], a
	call BattleBGEffects_IncrementJumptable
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	dec [hl]
	ret

.four
	xor a
	ldh [hBGMapMode], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jp z, EndBattleBGEffect
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], 1
	ret

BattleBGEffect_EnterMon:
	call BGEffect_CheckBattleTurn
	ld de, .EnemyData
	jr z, .gotData
	ld de, .PlayerData
.gotData
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	jp BattleBGEffect_RunPicResizeScript

.PlayerData
	db  2, $31, 2
	db  1, $31, 1
	db  0, $31, 0
	db -1
.EnemyData
	db  5, $00, 5
	db  4, $00, 4
	db  3, $00, 3
	db -1

BattleBGEffect_ReturnMon:
	call BGEffect_CheckBattleTurn
	ld de, .EnemyData
	jr z, .gotData
	ld de, .PlayerData
.gotData
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	jp BattleBGEffect_RunPicResizeScript

.PlayerData
	db  0, $31, 0
	db -2, $66, 0
	db  1, $31, 1
	db -2, $44, 1
	db  2, $31, 2
	db -2, $22, 2
	db -3, $00, 0
	db -1
.EnemyData
	db  3, $00, 3
	db -2, $77, 3
	db  4, $00, 4
	db -2, $55, 4
	db  5, $00, 5
	db -2, $33, 5
	db -3, $00, 0
	db -1

BattleBGEffect_SlideInMon:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	xor 1
	ld [hl], a
	ret z ; delay an extra frame
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	cp 8
	jr z, .end
	push bc
	ld e, a
	ld d, 0
	inc a
	ld [hl], a
	hlcoord 0, 6
	add hl, de
	ld d, 7 * 7 + 6 * 5
	ld e, a
	ld bc, SCREEN_WIDTH
.columnLoop
	push hl
	push de
	ld e, 6
.placeTileLoop
	ld a, d
	cp 7 * 7
	jr nc, .okay
	ld a, " "
.okay
	ld [hl], a
	add hl, bc
	inc d
	dec e
	jr nz, .placeTileLoop
	pop de
	pop hl
	dec hl
	ld a, d
	sub 6
	ld d, a
	dec e
	jr nz, .columnLoop
	pop bc
.wait
	xor a
	ldh [hBGMapHalf], a
	inc a
	ldh [hBGMapMode], a
	ret
.end
	xor a
	ldh [hBGMapMode], a
	jp EndBattleBGEffect

BattleBGEffect_SlideOutMon:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	xor 1
	ld [hl], a
	ret z ; delay an extra frame
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp 8
	jr z, .end
	coord hl, 0, 6
	push bc
	ld b, 6
	ld de, SCREEN_WIDTH
.loop
	push hl
	ld c, 8
.loop2
	inc hl
	ld a, [hld]
	ld [hli], a
	dec c
	jr nz, .loop2
	pop hl
	add hl, de
	dec b
	jr nz, .loop
	pop bc
.wait
	xor a
	ldh [hBGMapHalf], a
	inc a
	ldh [hBGMapMode], a
	ret
.end
	xor a
	ldh [hBGMapMode], a
	jp EndBattleBGEffect

BattleBGEffect_RunPicResizeScript:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw .restart
	dw DisableBGUpdates_EndBattleBGEffect

.clear
	call .ClearBox
.zero
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld e, [hl]
	ld d, 0
	inc [hl]
	ld a, [wBattleAnimTemp1]
	ld l, a
	ld a, [wBattleAnimTemp2]
	ld h, a
	add hl, de
	add hl, de
	add hl, de
	ld a, [hl]
	inc a
	jp z, DisableBGUpdates_EndBattleBGEffect
	inc a
	jr z, .clear
	inc a
	call nz, .PlaceGraphic
	call BattleBGEffects_IncrementJumptable
	ld a, 1
	ldh [hBGMapMode], a
	ret

.restart
	xor a
	ldh [hBGMapMode], a
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], 0
	ret

.ClearBox
; get dims
	push bc
	inc hl
	ld a, [hli]
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	ld b, a
; get coords
	ld e, [hl]
	ld d, 0
	ld hl, .Coords
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ClearBox
	pop bc
	ret

.PlaceGraphic
; get dims
	push bc
	push hl
	ld e, [hl]
	ld d, 0
	ld hl, .BGSquares
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	ld b, a
; store pointer
	ld a, [hli]
	ld e, a
	ld d, [hl]
; get byte
	pop hl
	inc hl
	ld a, [hli]
	ld [wBattleAnimTemp0], a
; get coord
	push de
	ld e, [hl]
	ld d, 0
	ld hl, .Coords
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
; fill box
.row
	push bc
	push hl
	ld a, [wBattleAnimTemp0]
	ld b, a
.col
	ld a, [de]
	add b
	ld [hli], a
	inc de
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	pop bc
	ret

.Coords
	dwcoord  2,  6
	dwcoord  3,  8
	dwcoord  4, 10
	dwcoord 12,  0
	dwcoord 13,  2
	dwcoord 14,  4

.BGSquares
MACRO bgsquare
	dn \1,\2
	dw \3
ENDM

	bgsquare 6, 6, .SixBySix
	bgsquare 4, 4, .FourByFour
	bgsquare 2, 2, .TwoByTwo
	bgsquare 7, 7, .SevenBySeven
	bgsquare 5, 5, .FiveByFive
	bgsquare 3, 3, .ThreeByThree

.SixBySix
	db $00, $06, $0c, $12, $18, $1e
	db $01, $07, $0d, $13, $19, $1f
	db $02, $08, $0e, $14, $1a, $20
	db $03, $09, $0f, $15, $1b, $21
	db $04, $0a, $10, $16, $1c, $22
	db $05, $0b, $11, $17, $1d, $23

.FourByFour
	db $00, $0c, $12, $1e
	db $02, $0e, $14, $20
	db $03, $0f, $15, $21
	db $05, $11, $17, $23

.TwoByTwo
	db $00, $1e
	db $05, $23

.SevenBySeven
	db $00, $07, $0e, $15, $1c, $23, $2a
	db $01, $08, $0f, $16, $1d, $24, $2b
	db $02, $09, $10, $17, $1e, $25, $2c
	db $03, $0a, $11, $18, $1f, $26, $2d
	db $04, $0b, $12, $19, $20, $27, $2e
	db $05, $0c, $13, $1a, $21, $28, $2f
	db $06, $0d, $14, $1b, $22, $29, $30

.FiveByFive
	db $00, $07, $15, $23, $2a
	db $01, $08, $16, $24, $2b
	db $03, $0a, $18, $26, $2d
	db $05, $0c, $1a, $28, $2f
	db $06, $0d, $1b, $29, $30

.ThreeByThree
	db $00, $15, $2a
	db $03, $18, $2d
	db $06, $1b, $30

BattleBGEffect_Surf:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	lb de, 2, 2
	call InitSurfWaves

.one
	ld a, [wLCDCPointer]
	and a
	ret z
	push bc
	call .RotatewSurfWaveBGEffect
	pop bc
	ret

.RotatewSurfWaveBGEffect
	ld hl, wSurfWaveBGEffect
	ld de, wSurfWaveBGEffect + 1
	ld c, wSurfWaveBGEffectEnd - wSurfWaveBGEffect - 1
	ld a, [hl]
	push af
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ld [hl], a
	ld de, wLYOverridesBackup
	ld hl, wSurfWaveBGEffect
	ld bc, 0
.loop2
	ldh a, [hLYOverridesStart]
	cp e
	jr nc, .load_zero
	push hl
	add hl, bc
	ld a, [hl]
	pop hl
	jr .okay

.load_zero
	xor a
.okay
	ld [de], a
	ld a, c
	inc a
	and $3f
	ld c, a
	inc de
	ld a, e
	cp $5f
	jr c, .loop2
	ret

BattleBGEffect_Whirlpool:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffect_WavyScreenFX
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	ld [wLCDCPointer], a
	xor a
	ldh [hLYOverridesStart], a
	ld a, $5e
	ldh [hLYOverridesEnd], a
	lb de, 2, 2
	jp BattleBGEffect_SineWave

BattleBGEffect_30:
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	jp EndBattleBGEffect

BattleBGEffect_31:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld e, a
	add a, 4
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and $f0
	swap a
	cpl
	add a, 4
	ld d, a
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTemp0], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cp $20
	jr nc, .done
	inc [hl]
	inc [hl]
	jp BattleBGEffect_LocalizedSineWave

.done
	call BattleBGEffects_ClearLYOverrides
	jp EndBattleBGEffect

BattleBGEffect_Psychic:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	ld [wLCDCPointer], a
	xor a
	ldh [hLYOverridesStart], a
	ld a, $5f
	ldh [hLYOverridesEnd], a
	lb de, 6, 5
	call BattleBGEffect_SineWave
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
	and 3
	ret nz
	jp BattleBGEffect_WavyScreenFX

BattleBGEffect_Teleport:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffect_WavyScreenFX
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	lb de, 6, 5
	jp BattleBGEffect_SineWave

BattleBGEffect_NightShade:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffect_WavyScreenFX
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld e, [hl]
	ld d, 2
	jp BattleBGEffect_SineWave

BattleBGEffect_DoubleTeam:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw GenericDummyFunction
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], 0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $10
	jp nc, BattleBGEffects_IncrementJumptable
	inc [hl]
	jr .UpdateLYOverrides

.three
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $ff
	jp z, BattleBGEffects_IncrementJumptable
	dec [hl]
	jr .UpdateLYOverrides

.two
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld d, 2
	call Sine
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	add [hl]
	call .UpdateLYOverrides
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	add a, 4
	ld [hl], a
	ret

.UpdateLYOverrides
	ld e, a
	cpl
	inc a
	ld d, a
	ld h, HIGH(wLYOverridesBackup)
	ldh a, [hLYOverridesStart]
	ld l, a
	ldh a, [hLYOverridesEnd]
	sub l
	srl a
	push af
.loop
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	dec a
	jr nz, .loop
	pop af
	ret nc
	ld [hl], e
	ret

BattleBGEffect_AcidArmor:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld e, [hl]
	ld d, 2
	call BattleBGEffect_SineWave
	ld h, HIGH(wLYOverridesBackup)
	ldh a, [hLYOverridesEnd]
	ld l, a
	ld [hl], 0
	dec l
	ld [hl], 0
	ret

.one
	ldh a, [hLYOverridesEnd]
	ld l, a
	ld h, HIGH(wLYOverridesBackup)
	ld e, l
	ld d, h
	dec de
.loop
	ld a, [de]
	dec de
	ld [hld], a
	ldh a, [hLYOverridesStart]
	cp l
	jr nz, .loop
	ld [hl], $90
	ldh a, [hLYOverridesEnd]
	ld l, a
	ld a, [hl]
	and a
	jr z, .okay
	cp $90
	jr z, .okay
	ld [hl], 0
.okay
	dec l
	ld a, [hl]
	cp 2
	ret c
	cp $90
	ret z
	ld [hl], 0
	ret

BattleBGEffect_21:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], 1
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and $3f
	ld d, a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cp d
	ret nc
	call BattleBGEffect_PushScreenDown
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	and 3
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	add [hl]
	ld [hl], a
	ret

BattleBGEffect_Dig:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], 2
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next
	dec [hl]
	ret

.next
	ld [hl], $10
	call BattleBGEffects_IncrementJumptable
.two
	ldh a, [hLYOverridesStart]
	ld l, a
	ldh a, [hLYOverridesEnd]
	sub l
	dec a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	cp [hl]
	ret c
	ld a, [hl]
	push af
	and 7
	jr nz, .skip
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	dec [hl]
.skip
	pop af
	call BattleBGEffect_PushScreenDown
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	inc [hl]
	inc [hl]
	ret

BattleBGEffect_Tackle:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw BGEffect2d_2f_zero
	dw Tackle_BGEffect25_2d_one
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

BattleBGEffect_25:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw Tackle_BGEffect25_2d_one
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms2
	jr BGEffect25_2d_2f_zero_finish

BGEffect2d_2f_zero:
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
BGEffect25_2d_2f_zero_finish:
	call BattleBGEffects_IncrementJumptable
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	call BGEffect_CheckBattleTurn
	ld a, -2
	jr nz, .okay
	ld a, 2
.okay
	ld [hl], a
	ret

Tackle_BGEffect25_2d_one:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp -8
	jr z, .reached_limit
	cp 8
	jr nz, .finish
.reached_limit
	call BattleBGEffects_IncrementJumptable
.finish
	call FillLYOverridesBackup_HandleRollout
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	add [hl]
	ld [hl], a
	ret

Tackle_BGEffect25_2d_two:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	call z, BattleBGEffects_IncrementJumptable
	call FillLYOverridesBackup_HandleRollout
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	add [hl]
	ld [hl], a
	ret

FillLYOverridesBackup_HandleRollout:
	push af
	ld a, [wFXAnimIDHi]
	and a
	jr nz, .not_rollout
	ld a, [wFXAnimIDLo]
	cp ROLLOUT
	jr z, .rollout
.not_rollout
	pop af
	jp FillLYOverridesBackup

.rollout
	ldh a, [hLYOverridesStart]
	ld d, a
	ldh a, [hLYOverridesEnd]
	sub d
	ld d, a
	ld h, HIGH(wLYOverridesBackup)
	ldh a, [hSCY]
	and a
	jr nz, .skip1
	ldh a, [hLYOverridesStart]
	and a
	jr z, .skip2
	dec a
	ld l, a
	ld [hl], 0
	jr .skip2

.skip1
	ldh a, [hLYOverridesEnd]
	dec a
	ld l, a
	ld [hl], 0
.skip2
	ldh a, [hSCY]
	ld l, a
	ldh a, [hLYOverridesStart]
	sub l
	jr nc, .skip3
	xor a
	dec d
.skip3
	ld l, a
	pop af
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

BattleBGEffect_2d:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw BGEffect2d_2f_zero
	dw Tackle_BGEffect25_2d_one
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

BattleBGEffect_2f:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw BGEffect2d_2f_zero
	dw Tackle_BGEffect25_2d_one
	dw GenericDummyFunction
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

BattleBGEffect_26:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld d, 8
	call Sine
	call FillLYOverridesBackup
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	add a, 4
	ld [hl], a
	ret

BattleBGEffect_2c:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	xor a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hli], a
	ld [hl], a
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld d, 6
	call Sine
	push af
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld d, 2
	call Sine
	ld e, a
	pop af
	add e
	call FillLYOverridesBackup
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	add a, 8
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	inc [hl]
	inc [hl]
	ret

BattleBGEffect_28:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	jp BattleBGEffect_SetLCDStatCustoms1

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $20
	ret nc
	inc [hl]
	ld d, a
	ld e, 4
	jp BattleBGEffect_SineWave

.two
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jp z, BattleAnim_ResetLCDStatCustom
	dec [hl]
	ld d, a
	ld e, 4
	jp BattleBGEffect_SineWave

BattleBGEffect_BounceDown:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms2
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], 1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $20
	ret

.one
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cp $38
	ret nc
	push af
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld d, $10
	call Cosine
	add $10
	ld d, a
	pop af
	add d
	call BattleBGEffect_PushScreenDown
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	inc [hl]
	inc [hl]
	ret

BattleBGEffect_2a:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw GenericDummyFunction
	dw .two
	dw .three
	dw GenericDummyFunction
	dw BattleBGEffects_ResetVideoHRAM

.zero
	call BattleBGEffects_IncrementJumptable
	ld a, %11100100
	call BattleBGEffects_SetLYOverrides
	ld a, LOW(rBGP) ; huh? we're not on DMG...
	call BattleBGEffect_SetLCDStatCustoms1
	ldh a, [hLYOverridesEnd]
	inc a
	ldh [hLYOverridesEnd], a
	ldh a, [hLYOverridesStart]
	ld l, a
	ld h, HIGH(wLYOverridesBackup)
.loop
	ldh a, [hLYOverridesEnd]
	cp l
	jr z, .done
	xor a
	ld [hli], a
	jr .loop

.done
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	ret

.two
	call .GetLYOverride
	jr c, .SetLYOverridesBackup

.next
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	ldh a, [hLYOverridesStart]
	inc a
	ldh [hLYOverridesStart], a
.finish
	jp BattleBGEffects_IncrementJumptable

.three
	call .GetLYOverride
	jr nc, .finish
	call .SetLYOverridesBackup
	ldh a, [hLYOverridesEnd]
	dec a
	ld l, a
	ld [hl], e
	ret

.SetLYOverridesBackup
	ld e, a
	ldh a, [hLYOverridesStart]
	ld l, a
	ldh a, [hLYOverridesEnd]
	sub l
	srl a
	ld h, HIGH(wLYOverridesBackup)
.loop2
	ld [hl], e
	inc hl
	inc hl
	dec a
	jr nz, .loop2
	ret

.GetLYOverride
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
	swap a
	rlca
	and $1f
	ld e, a
	ld d, 0
	ld hl, .data
	add hl, de
	ld a, [hl]
	cp $ff
	ret

.data
	db $00, $40, $90, $e4
	db -1

BattleBGEffect_2b:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], $40
	ret

.one
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	jp z, BattleAnim_ResetLCDStatCustom
	dec [hl]
	swap a
	rlca
	and $f
	ld d, a
	ld e, a
	jp BattleBGEffect_SineWave

BattleBGEffect_1c:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	jumptable

.Jumptable
	dw .cgb_zero
	dw .cgb_one
	dw .cgb_two

.cgb_zero
	call BattleBGEffects_IncrementJumptable
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	ret

.cgb_one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld e, a
	and 7
	ret nz
	ld a, e
	and $18
	add a, a
	swap a
	add a, a
	ld e, a
	ld d, 0
	call BGEffect_CheckBattleTurn
	jr nz, .player_2
	ld hl, .CGB_DMGEnemyData
	add hl, de
	ld a, [hli]
	push hl
	call BGEffects_LoadBGPal1_OBPal0
	pop hl
	ld a, [hl]
	jp BGEffects_LoadBGPal0_OBPal1

.player_2
	ld hl, .CGB_DMGEnemyData
	add hl, de
	ld a, [hli]
	push hl
	call BGEffects_LoadBGPal0_OBPal1
	pop hl
	ld a, [hl]
	jp BGEffects_LoadBGPal1_OBPal0

.cgb_two
	ld a, %11100100
	call BGEffects_LoadBGPal0_OBPal1
	ld a, %11100100
	call BGEffects_LoadBGPal1_OBPal0
	jp EndBattleBGEffect

.CGB_DMGEnemyData
	db $e4, $e4
	db $f8, $90
	db $fc, $40
	db $f8, $90
.DMG_PlayerData
	db $e4, $e4
	db $90, $f8
	db $40, $fc
	db $90, $f8

BattleBGEffect_VibrateMon:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, LOW(rSCX)
	call BattleBGEffect_SetLCDStatCustoms1
	ld hl, hLYOverridesEnd
	inc [hl]
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], 1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $20
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jp z, BattleAnim_ResetLCDStatCustom
	dec [hl]
	and 1
	ret nz
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	jp FillLYOverridesBackup

BattleBGEffect_WobbleMon:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	ld [wLCDCPointer], a
	xor a
	ldh [hLYOverridesStart], a
	ld a, $37
	ldh [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $40
	jp nc, BattleAnim_ResetLCDStatCustom
	ld d, 6
	call Sine
	call FillLYOverridesBackup
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	inc [hl]
	inc [hl]
	ret

BattleBGEffect_2e:
	call BattleBGEffect_DecrementJumptableSwapTurns
	jr c, .xor_a
	bit 7, a
	jr z, .okay
.xor_a
	xor a
.okay
	push af
	call DelayFrame
	pop af
	ldh [hSCY], a
	cpl
	inc a
	ld [wAnimObject01_YOffset], a
	ret

BattleBGEffect_1f:
	call BattleBGEffect_DecrementJumptableSwapTurns
	jr nc, .skip
	xor a
.skip
	ldh [hSCX], a
	ret

BattleBGEffect_20:
	call BattleBGEffect_DecrementJumptableSwapTurns
	jr nc, .skip
	xor a
.skip
	ldh [hSCY], a
	ret

BattleBGEffect_DecrementJumptableSwapTurns:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .okay
	call EndBattleBGEffect
	scf
	ret

.okay
	dec [hl]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .reload_frame_counter
	dec [hl]
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	ret

.reload_frame_counter
	ld a, [hl]
	swap a
	or [hl]
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	and a
	ret

BattleBGEffect_35:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $40
	jr nc, .finish
	ld d, 6
	call Sine
	ldh [hSCX], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	inc [hl]
	inc [hl]
	ret

.finish
	xor a
	ldh [hSCX], a
	ret

BattleBGEffect_GetNthDMGPal:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .zero
	dec [hl]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	jp BattleBGEffect_GetNextDMGPal

.zero
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], a
	jp BattleBGEffect_GetFirstDMGPal

BattleBGEffect_RapidFlash:
	ld de, .FlashPals
	jr BGEffect_RapidCyclePals

.FlashPals
	db $e4, $6c, $fe

BattleBGEffect_16:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $e4, $90, $40, $ff

BattleBGEffect_17:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $e4, $f8, $fc, $ff

BattleBGEffect_18:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $e4, $90, $40, $90, $fe

BattleBGEffect_19:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $e4, $f8, $fc, $f8, $fe

BattleBGEffect_1a:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $e4, $f8, $fc, $f8, $e4, $90, $40, $90, $fe

BattleBGEffect_1b:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $e4, $fc, $e4, $00, $fe

BattleBGEffect_1d:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $e4, $90, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $90, $e4, $ff

BattleBGEffect_1e:
	ld de, .Pals
	jr BGEffect_RapidCyclePals

.Pals
	db $00, $40, $90, $e4, $ff

BGEffect_RapidCyclePals:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	jumptable

.Jumptable_CGB
	dw .zero_cgb
	dw .one_cgb
	dw .two_cgb
	dw .three_cgb
	dw .four_cgb

.zero_cgb
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn_cgb
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_IncrementJumptable
.player_turn_cgb
	call BattleBGEffects_IncrementJumptable
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld [hl], 0
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], a
	ret

.one_cgb
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .okay_1_cgb
	dec [hl]
	ret

.okay_1_cgb
	ld a, [hl]
	swap a
	or [hl]
	ld [hl], a
	call BattleBGEffect_GetFirstDMGPal
	jp nc, BGEffects_LoadBGPal0_OBPal1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	dec [hl]
	ret

.two_cgb
	ld a, %11100100
	call BGEffects_LoadBGPal0_OBPal1
	jp EndBattleBGEffect

.three_cgb
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .okay_3_cgb
	dec [hl]
	ret

.okay_3_cgb
	ld a, [hl]
	swap a
	or [hl]
	ld [hl], a
	call BattleBGEffect_GetFirstDMGPal
	jp nc, BGEffects_LoadBGPal1_OBPal0
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	dec [hl]
	ret

.four_cgb
	ld a, %11100100
	call BGEffects_LoadBGPal1_OBPal0
	jp EndBattleBGEffect

BGEffects_LoadBGPal0_OBPal1:
	ld h, a
	ldh a, [rSVBK]
	push af
	wbk BANK(wBGPals)
	ld a, h
	push bc
	ld hl, wBGPals
	ld de, wOriginalBGPals
	ld b, a
	ld c, 1
	push bc
	call CopyPals
	ld hl, wOBPals + 8
	ld de, wOriginalOBJPals + 8
	pop bc
	call CopyPals
	pop bc
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

BGEffects_LoadBGPal1_OBPal0:
	ld h, a
	ldh a, [rSVBK]
	push af
	wbk BANK(wOBPals)
	ld a, h
	push bc
	ld hl, wBGPals + 8
	ld de, wOriginalBGPals + 8
	ld b, a
	ld c, 1
	push bc
	call CopyPals
	ld hl, wOBPals
	ld de, wOriginalOBJPals
	pop bc
	call CopyPals
	pop bc
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

BattleBGEffect_GetFirstDMGPal:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
BattleBGEffect_GetNextDMGPal:
	ld l, a
	ld h, 0
	add hl, de
	ld a, [hl]
	cp -1
	jr z, .quit
	cp -2
	jr nz, .repeat
	ld a, [de]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], 0
.repeat
	and a
	ret

.quit
	scf
	ret

BattleBGEffects_ResetVideoHRAM:
	xor a
	ld [wLCDCPointer], a
	ld a, %11100100
	ldh [rBGP], a
	ld [wBGP], a
	ld [wOBP1], a
	ldh [hLYOverridesStart], a
	ldh [hLYOverridesEnd], a
	; fallthrough

BattleBGEffects_ClearLYOverrides:
	xor a
BattleBGEffects_SetLYOverrides:
	ld hl, wLYOverrides
	ld e, $99
.loop1
	ld [hli], a
	dec e
	jr nz, .loop1
	ld hl, wLYOverridesBackup
	ld e, $91
.loop2
	ld [hli], a
	dec e
	jr nz, .loop2
	ret

BattleBGEffect_SetLCDStatCustoms1:
	ld [wLCDCPointer], a
	call BGEffect_CheckBattleTurn
	lb de, $2f, $5e
	jr nz, .okay
	lb de, $00, $36
.okay
	ld a, d
	ldh [hLYOverridesStart], a
	ld a, e
	ldh [hLYOverridesEnd], a
	ret

BattleBGEffect_SetLCDStatCustoms2:
	ld [wLCDCPointer], a
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	lb de, $00, $36
	jr .okay

.player_turn
	lb de, $2d, $5e
.okay
	ld a, d
	ldh [hLYOverridesStart], a
	ld a, e
	ldh [hLYOverridesEnd], a
	ret

BattleAnim_ResetLCDStatCustom:
	xor a
	ldh [hLYOverridesStart], a
	ldh [hLYOverridesEnd], a
	call BattleBGEffects_ClearLYOverrides
	xor a
	ld [wLCDCPointer], a
	jp EndBattleBGEffect

BattleBGEffect_SineWave:
	push bc
	xor a
	ld [wBattleAnimTemp0], a
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	ld a, $80
	ld [wBattleAnimTemp3], a
	ld bc, wLYOverridesBackup
.loop
	ldh a, [hLYOverridesStart]
	cp c
	jr nc, .next
	ldh a, [hLYOverridesEnd]
	cp c
	jr c, .next
	ld a, [wBattleAnimTemp2]
	ld d, a
	ld a, [wBattleAnimTemp0]
	call Sine
	ld [bc], a
.next
	inc bc
	ld a, [wBattleAnimTemp1]
	ld hl, wBattleAnimTemp0
	add [hl]
	ld [hl], a
	ld hl, wBattleAnimTemp3
	dec [hl]
	jr nz, .loop
	pop bc
	ret

InitSurfWaves:
	push bc
	xor a
	ld [wBattleAnimTemp0], a
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	ld a, $40
	ld [wBattleAnimTemp3], a
	ld bc, wSurfWaveBGEffect
.loop
	ld a, [wBattleAnimTemp2]
	ld d, a
	ld a, [wBattleAnimTemp0]
	call Sine
	ld [bc], a
	inc bc
	ld a, [wBattleAnimTemp1]
	ld hl, wBattleAnimTemp0
	add [hl]
	ld [hl], a
	ld hl, wBattleAnimTemp3
	dec [hl]
	jr nz, .loop
	pop bc
	ret

BattleBGEffect_LocalizedSineWave:
	push bc
	ld [wBattleAnimTemp3], a
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	ldh a, [hLYOverridesStart]
	ld e, a
	ld a, [wBattleAnimTemp0]
	add a, e
	ld c, a
	ld b, HIGH(wLYOverridesBackup)
	ld l, a
	ld h, b
.loop
	ld a, [wBattleAnimTemp3]
	and a
	jr z, .done
	dec a
	ld [wBattleAnimTemp3], a
	push af
	ld a, [wBattleAnimTemp2]
	ld d, a
	ld a, [wBattleAnimTemp1]
	push hl
	call Sine
	ld e, a
	pop hl
	ldh a, [hLYOverridesEnd]
	cp c
	jr c, .skip1
	ld a, e
	ld [bc], a
	inc bc
.skip1
	ldh a, [hLYOverridesStart]
	cp l
	jr nc, .skip2
	ld [hl], e
	dec hl
.skip2
	ld a, [wBattleAnimTemp1]
	add 4
	ld [wBattleAnimTemp1], a
	pop af
	jr .loop

.done
	pop bc
	and a
	ret

BattleBGEffect_WavyScreenFX:
	push bc
	ldh a, [hLYOverridesStart]
	ld l, a
	inc a
	ld e, a
	ld h, HIGH(wLYOverridesBackup)
	ld d, h
	ldh a, [hLYOverridesEnd]
	sub l
	and a
	jr z, .done
	ld c, a
	ld a, [hl]
	push af
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ld [hl], a
.done
	pop bc
	ret

FillLYOverridesBackup:
	push af
	ld h, HIGH(wLYOverridesBackup)
	ldh a, [hLYOverridesStart]
	ld l, a
	ldh a, [hLYOverridesEnd]
	sub l
	ld d, a
	pop af
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

BattleBGEffect_PushScreenDown:
	push af
	ld e, a
	ldh a, [hLYOverridesStart]
	ld l, a
	ldh a, [hLYOverridesEnd]
	sub l
	sub e
	ld d, a
	ld h, HIGH(wLYOverridesBackup)
	ld a, SCREEN_HEIGHT_PX
.loop
	ld [hli], a
	dec e
	jr nz, .loop
	pop af
	cpl
.inverted_loop
	ld [hli], a
	dec d
	jr nz, .inverted_loop
	ret

BGEffect_CheckBattleTurn:
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ldh a, [hBattleTurn]
	and 1
	xor [hl]
	ret

BGEffect_CheckFlyDigStatus:
	call BGEffect_CheckBattleTurn
	ld a, [wPlayerSubStatus3]
	jr nz, .loaded
	ld a, [wEnemySubStatus3]
.loaded
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret
