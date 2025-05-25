; Battle animation command interpreter.

PlayBattleAnim:
	ld hl, rIE
	set LCD_STAT, [hl]
	ldh a, [rSVBK]
	push af
	wbk BANK(wActiveAnimObjects)

	ld c, 4
	call DelayFrames
	call BattleAnimAssignPals
	call BattleAnimRequestPals
	call DelayFrame

	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], 3
	call BattleAnimRunScript
	pop af
	ldh [hVBlank], a

	ld a, 1
	ldh [hBGMapMode], a
	ld c, 3
	call DelayFrames
	call WaitSFX
	pop af
	ldh [rSVBK], a
	ld hl, rIE
	res LCD_STAT, [hl]
	ret

BattleAnimRunScript:
	ld a, [wFXAnimIDHi]
	and a
	jr nz, .hi_byte

	call CheckBattleScene
	jr c, .disabled

	call BattleAnimClearHud
	call RunBattleAnimScript

	call BattleAnimAssignPals
	call BattleAnimRequestPals

	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call DelayFrame
	call BattleAnimRestoreHuds

.disabled
	ld a, [wNumHits]
	and a
	jr z, .done

	ld l, a
	ld h, 0
	ld de, ANIM_MISS
	add hl, de
	ld a, l
	ld [wFXAnimIDLo], a
	ld a, h
	ld [wFXAnimIDHi], a

.hi_byte
	call WaitSFX
	call PlayHitSound
	call RunBattleAnimScript

.done
	jp BattleAnim_RevertPals

RunBattleAnimScript:
	call ClearBattleAnims

.playframe
	call RunBattleAnimCommand
	callba ExecuteBGEffects
	call BattleAnim_UpdateOAM_All
	call RequestLYOverrides
	call BattleAnimRequestPals

	ldh a, [hDEDCryFlag]
	and a
	jr nz, .playDED

; Speed up Rollout's animation.
	ld a, [wFXAnimIDHi]
	and a
	jr nz, .not_rollout

	ld a, [wFXAnimIDLo]
	cp ROLLOUT
	jr nz, .not_rollout

	ld a, ANIM_BG_2E
	ld b, 5
	ld de, 4
	ld hl, wActiveBGEffects
.find
	cp [hl]
	jr z, .done
	add hl, de
	dec b
	jr nz, .find

.not_rollout
	call DelayFrame

.done
	ld a, [wBattleAnimFlags]
	rra
	jr nc, .playframe

	jp BattleAnim_ClearOAM

.playDED
	ld a, 2
	ldh [hRunPicAnim], a
	ld a, [wFXAnimIDLo]
	cp ROAR
	jr nz, .playCry
	ldh a, [rSVBK]
	push af
	wbk BANK(wPokeAnimCoord)
	ldh a, [hBattleTurn]
	and a
	coord de, 12, 0
	ld bc, vBGMap + 12
	jr z, .gotRoarCoords
	coord de, 0, 5
	ld c, 5 * BG_MAP_WIDTH ;vBGMap = $xx00, so this sets bc to vBGMap + 5 * BG_MAP_WIDTH
.gotRoarCoords
	ld hl, wPokeAnimCoord
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, wPokeAnimDestination
	ld a, c
	ld [hli], a
	ld [hl], b
	pop af
	ldh [rSVBK], a
.playCry
	ldh a, [hDEDCryFlag]
	call _PlayCry
	xor a
	ldh [hRunPicAnim], a
	jr .done

RunOneFrameOfGrowlOrRoarAnim:
	call RunBattleAnimCommand
	callba ExecuteBGEffects
	call BattleAnim_UpdateOAM_All
	call BattleAnimRequestPals
	ld a, [wBattleAnimFlags]
	bit 0, a
	ret z
	xor a
	ldh [hRunPicAnim], a

; fallthrough
BattleAnim_ClearOAM:
	ld a, [wBattleAnimFlags]
	bit 3, a
	call z, ClearSprites
	xor a
	ldh [hLYOverridesStart], a
	ldh [hLYOverridesEnd], a
	ld [wLCDCPointer], a
	ld hl, wLYOverrides
	ld bc, wLYOverridesEnd - wLYOverrides
	call ByteFill
	ld hl, wLYOverridesBackup
	ld bc, wLYOverridesBackupEnd - wLYOverridesBackup
	jp ByteFill

BattleAnimClearHud:
	call DelayFrame
	call WaitTop
	call ClearActorHud
	ld a, 1
	ldh [hBGMapMode], a
	call Delay2
	jp WaitTop

BattleAnimRestoreHuds:
	call DelayFrame
	call WaitTop

	ldh a, [rSVBK]
	push af
	wbk BANK(wEnemyMon)

	call UpdateBattleHuds

	pop af
	ldh [rSVBK], a

	ld a, 1
	ldh [hBGMapMode], a
	call Delay2
	jp WaitTop

BattleAnimRequestPals:
	ldh a, [rBGP]
	ld b, a
	ld a, [wBGP]
	cp b
	call nz, BattleAnim_SetBGPals

	ldh a, [rOBP0]
	ld b, a
	ld a, [wOBP0]
	cp b
	jp nz, BattleAnim_SetOBPals
	ret

ClearActorHud:
	ldh a, [hBattleTurn]
	and a
	lb bc, 3, 11
	jr z, .player

	hlcoord 0, 1
	jr .clearbox

.player
	hlcoord 9, 7
	ld b, 5
.clearbox
	jp ClearBox

RunBattleAnimCommand:
	call .CheckTimer
	ret nc

.loop
	call GetBattleAnimByte

	cp $ff
	jr nz, .not_done_with_anim

; Return from a subroutine.
	ld hl, wBattleAnimFlags
	bit 1, [hl]
	jr nz, .do_anim

	set 0, [hl]
	ret

.not_done_with_anim
	cp $d0
	jr nc, .do_anim

	ld [wBattleAnimDuration], a
	ret

.do_anim
	call .DoCommand
	ldh a, [hDEDCryFlag]
	and a
	jr z, .loop
	ret

.CheckTimer
	; if wBattleAnimDuration is zero, return carry; otherwise, decrement it
	ld a, [wBattleAnimDuration]
	sub 1 ; sets carry for 0
	ret c
	ld [wBattleAnimDuration], a
	ret

.DoCommand
; Execute battle animation command in [wBattleAnimByte].
	ld a, [wBattleAnimByte]
	sub $d0
	jumptable

BattleAnimCommands::
	dw BattleAnimCmd_Obj                     ;d0
	dw BattleAnimCmd_GFX
	dw BattleAnimCmd_GFX
	dw BattleAnimCmd_GFX
	dw BattleAnimCmd_GFX
	dw BattleAnimCmd_GFX
	dw BattleAnimCmd_IncObj
	dw BattleAnimCmd_SetObj
	dw BattleAnimCmd_IncBGEffect             ;d8
	dw BattleAnimCmd_EnemyFeetObj
	dw BattleAnimCmd_PlayerHeadObj
	dw BattleAnimCmd_CheckPokeball
	dw BattleAnimCmd_Transform
	dw BattleAnimCmd_RaiseSub
	dw BattleAnimCmd_DropSub
	dw BattleAnimCmd_ResetObp0
	dw BattleAnimCmd_Sound                   ;e0
	dw BattleAnimCmd_Cry
	dw BattleAnimCmd_MinimizeOpp
	dw BattleAnimCmd_OAMOn
	dw BattleAnimCmd_OAMOff
	dw BattleAnimCmd_ClearObjs
	dw GenericDummyFunction
	dw BattleAnimCmd_InsObj
	dw BattleAnimCmd_UpdateActorPic          ;e8
	dw BattleAnimCmd_Minimize
	dw BattleAnimCmd_JumpIfPMode
	dw BattleAnimCmd_CheckCriticalCapture
	dw BattleAnimCmd_ShakeDelay
	dw GenericDummyFunction
	dw BattleAnimCmd_JumpAnd
	dw BattleAnimCmd_JumpUntil
	dw BattleAnimCmd_BGEffect                ;f0
	dw BattleAnimCmd_BGP
	dw BattleAnimCmd_OBP0
	dw BattleAnimCmd_OBP1
	dw BattleAnimCmd_ClearSprites
	dw BattleAnimCmd_DarkenBall
	dw GenericDummyFunction
	dw BattleAnimCmd_ClearFirstBGEffect
	dw BattleAnimCmd_JumpIf                  ;f8
	dw BattleAnimCmd_SetVar
	dw BattleAnimCmd_IncVar
	dw BattleAnimCmd_JumpVar
	dw BattleAnimCmd_Jump
	dw BattleAnimCmd_Loop
	dw BattleAnimCmd_Call
	dw BattleAnimCmd_Ret

BattleAnimCmd_CheckCriticalCapture:
	ldh a, [rSVBK]
	push af
	wbk BANK(wCatchMon_Critical)
	ld a, [wCatchMon_Critical]
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	ld [wBattleAnimVar], a
	ret

BattleAnimCmd_ShakeDelay:
	ldh a, [rSVBK]
	push af
	wbk BANK(wCatchMon_NumShakes)
	ld a, [wCatchMon_NumShakes]
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	add a ;*2
	add b ;*3
	add a ;*6
	add a ;*12
	add $30
	ld [wBattleAnimDuration], a
	; Hack to break out of the loop
	pop hl
	ret

BattleAnimCmd_Ret:
	ld hl, wBattleAnimFlags
	res 1, [hl]
	ld hl, wBattleAnimParent
	ld a, [hli]
	ld b, [hl]
	ld hl, wBattleAnimAddress
	ld [hli], a
	ld [hl], b
	ret

BattleAnimCmd_Call:
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	push de
	ld hl, wBattleAnimAddress
	ld a, [hli]
	ld d, [hl]
	ld hl, wBattleAnimParent
	ld [hli], a
	ld [hl], d
	pop de
	ld hl, wBattleAnimAddress
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, wBattleAnimFlags
	set 1, [hl]
	ret

BattleAnimCmd_SetVar:
	call GetBattleAnimByte
	ld [wBattleAnimVar], a
	ret

BattleAnimCmd_IncVar:
	ld hl, wBattleAnimVar
	inc [hl]
	ret

BattleAnimCmd_Loop:
	call GetBattleAnimByte
	ld hl, wBattleAnimFlags
	bit 2, [hl]
	jr nz, .continue_loop
	and a
	jr z, BattleAnimCmd_Jump
	dec a
	set 2, [hl]
	ld [wBattleAnimLoops], a
.continue_loop
	ld hl, wBattleAnimLoops
	ld a, [hl]
	and a
	jr z, .return_from_loop
	dec [hl]
	jr BattleAnimCmd_Jump

.return_from_loop
	ld hl, wBattleAnimFlags
	res 2, [hl]
	jr BattleAnimCmdHelper_SkipHalfword

BattleAnimCmd_JumpUntil:
	ld hl, wBattleAnimParam
	ld a, [hl]
	and a
	jr z, BattleAnimCmdHelper_SkipHalfword
	dec [hl]
	jr BattleAnimCmd_Jump

BattleAnimCmd_JumpVar:
	call GetBattleAnimByte
	ld hl, wBattleAnimVar
	jr BattleAnimCmdHelper_CompareAndJumpIfEqual

BattleAnimCmd_JumpIf:
	call GetBattleAnimByte
	ld hl, wBattleAnimParam
BattleAnimCmdHelper_CompareAndJumpIfEqual:
	cp [hl]
BattleAnimCmdHelper_JumpIfZero:
	jr z, BattleAnimCmd_Jump
	jr BattleAnimCmdHelper_SkipHalfword

BattleAnimCmd_JumpAnd:
	call GetBattleAnimByte
	ld e, a
	ld a, [wBattleAnimParam]
	and e
BattleAnimCmdHelper_JumpIfNonZero:
	jr nz, BattleAnimCmd_Jump
BattleAnimCmdHelper_SkipHalfword:
	ld a, 2
BattleAnimCmdHelper_SkipBytes:
	; skips a bytes from the battle animation command data
	ld hl, wBattleAnimAddress
	add a, [hl]
	ld [hli], a
	ret nc
	inc [hl]
	ret

BattleAnimCmd_Jump:
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld hl, wBattleAnimAddress + 1
	ld [hld], a
	ld [hl], e
	ret

BattleAnimCmd_JumpIfPMode:
	ldh a, [hBattleTurn]
	and a
	jr nz, BattleAnimCmdHelper_SkipHalfword
	call CheckPokemonOnlyMode
	jr BattleAnimCmdHelper_JumpIfNonZero

BattleAnimCmd_InsObj:
	call GetBattleAnimByte
	; RAM lookup
	call BattleAnimCmdHelper_FindObjIdx
	jr c, BattleAnimCmd_Obj ; If the lookup fails, append the object.
	; Do we have room for this?
	dec e
	ld a, 4
	jr z, BattleAnimCmdHelper_SkipBytes ; If not, skip spawning (don't waste time in QueueBattleAnimation)

	; Loop to shift the memory array down
	ld hl, wAnimObject09
	ld de, wAnimObject10
.loop
	push bc
	push hl
	push de
	ld bc, BATTLEANIMSTRUCT_LENGTH
	rst CopyBytes
	pop de
	pop hl
	pop bc
	ld a, l
	cp c
	jr z, .done
	push hl
	ld de, -BATTLEANIMSTRUCT_LENGTH
	add hl, de
	pop de
	jr .loop

.done
	xor a
	ld [hl], a
BattleAnimCmd_Obj:
; index, x, y, param
	call BattleAnimCmdHelper_LoadFourByteParams
	jp QueueBattleAnimation

BattleAnimCmd_BGEffect:
	call BattleAnimCmdHelper_LoadFourByteParams
	jpba QueueBGEffect

BattleAnimCmdHelper_LoadFourByteParams:
	ld hl, wBattleAnimTemp0
	call GetBattleAnimByte
	ld [hli], a
	call GetBattleAnimByte
	ld [hli], a
	call GetBattleAnimByte
	ld [hli], a
	call GetBattleAnimByte
	ld [hli], a
	ret

BattleAnimCmd_BGP:
	call GetBattleAnimByte
	ld [wBGP], a
	ret

BattleAnimCmd_OBP0:
	call GetBattleAnimByte
	ld [wOBP0], a
	ret

BattleAnimCmd_OBP1:
	call GetBattleAnimByte
	ld [wOBP1], a
	ret

BattleAnimCmd_ResetObp0:
	ld a, $e0
	ld [wOBP0], a
	ret

BattleAnimCmd_ClearObjs:
	ld hl, wActiveAnimObjects
	ld a, $a0
.loop
	ld [hl], 0
	inc hl
	dec a
	jr nz, .loop
	ret

BattleAnimCmd_GFX:
	; low nibble of the command's value determines the number of GFX
	ld a, [wBattleAnimByte]
	and $f
	ld c, a
	ld hl, wBattleAnimTileDict
	xor a
	ld [wBattleAnimTemp0], a
.loop
	ld a, [wBattleAnimTemp0]
	cp (vFontTiles - vObjTiles) / $10 - $31
	ret nc
	call GetBattleAnimByte
	ld [hli], a
	ld a, [wBattleAnimTemp0]
	ld [hli], a
	push bc
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, vObjTiles tile $31
	add hl, de
	ld a, [wBattleAnimByte]
	call LoadBattleAnimObj
	ld a, [wBattleAnimTemp0]
	add c
	ld [wBattleAnimTemp0], a
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

BattleAnimCmd_IncObj:
	call GetBattleAnimByte
	call BattleAnimCmdHelper_FindObjIdx
	ret c
	ld hl, BATTLEANIMSTRUCT_ANON_JT_INDEX
	add hl, bc
	inc [hl]
	ret

BattleAnimCmd_IncBGEffect:
	call GetBattleAnimByte
	call BattleAnimCmd_FindBGIdx
	ret c
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	inc [hl]
	ret

BattleAnimCmd_SetObj:
	call GetBattleAnimByte
	call BattleAnimCmdHelper_FindObjIdx
	jp c, GetBattleAnimByte
	call GetBattleAnimByte
	ld hl, BATTLEANIMSTRUCT_ANON_JT_INDEX
	add hl, bc
	ld [hl], a
	ret

BattleAnimCmd_EnemyFeetObj:
	ld hl, wBattleAnimTileDict
.loop
	ld a, [hl]
	and a
	jr z, .okay
	inc hl
	inc hl
	jr .loop

.okay
	ld a, $28
	ld [hli], a
	ld a, $42
	ld [hli], a
	ld a, $29
	ld [hli], a
	ld a, $49
	ld [hl], a

	ld hl, vObjTiles tile $73
	ld de, vBGTiles tile $06
	ld a, $70
	ld [wBattleAnimTemp0], a
	ld a, 7
	call .LoadFootprint
	ld de, vBGTiles tile $31
	ld a, $60
	ld [wBattleAnimTemp0], a
	ld a, 6
	; fallthrough

.LoadFootprint
	push af
	push hl
	push de
	lb bc, BANK(BattleAnimCmd_EnemyFeetObj), 1
	call Request2bpp
	pop de
	ld a, [wBattleAnimTemp0]
	ld l, a
	ld h, 0
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld bc, 1 tiles
	add hl, bc
	pop af
	dec a
	jr nz, .LoadFootprint
	ret

BattleAnimCmd_PlayerHeadObj:
	ld hl, wBattleAnimTileDict
.loop
	ld a, [hl]
	and a
	jr z, .okay
	inc hl
	inc hl
	jr .loop

.okay
	ld a, $28
	ld [hli], a
	ld a, $35
	ld [hli], a
	ld a, $29
	ld [hli], a
	ld a, $43
	ld [hl], a

	ld hl, vObjTiles tile $66
	ld de, vBGTiles tile $05
	ld a, $70
	ld [wBattleAnimTemp0], a
	ld a, 7
	call .LoadHead
	ld de, vBGTiles tile $31
	ld a, $60
	ld [wBattleAnimTemp0], a
	ld a, 6
.LoadHead
	push af
	push hl
	push de
	lb bc, BANK(BattleAnimCmd_EnemyFeetObj), 2
	call Request2bpp
	pop de
	ld a, [wBattleAnimTemp0]
	ld l, a
	ld h, 0
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld bc, 2 tiles
	add hl, bc
	pop af
	dec a
	jr nz, .LoadHead
	ret

BattleAnimCmd_CheckPokeball:
	callba GetPokeBallWobble
	ld a, c
	ld [wBattleAnimVar], a
	ret

BattleAnimCmd_Transform:
	ldh a, [rSVBK]
	push af
	wbk BANK(wCurPartySpecies)
	ld a, [wCurPartySpecies]
	push af

	ld de, vObjTiles tile $00
	ldh a, [hBattleTurn]
	and a
	jr z, .player

	ld a, [wTempBattleMonSpecies]
	ld [wCurPartySpecies], a
	predef GetFrontpic
	jr .done
.player
	ld a, [wTempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	predef GetBackpic

.done
	pop af
	ld [wCurPartySpecies], a
	pop af
	ldh [rSVBK], a
	ret

BattleAnimCmd_UpdateActorPic:
	ld de, vObjTiles tile $00
	lb bc, 0, 7 * 7
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld hl, vBGTiles tile $00
	jr .done
.player
	ld hl, vBGTiles tile $31
	ld c, 6 * 6
.done
	jp Request2bpp

BattleAnimCmd_RaiseSub:
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)

	ld hl, wDecompressScratch
	ld bc, 7 * 7 tiles
	xor a
	call ByteFill

	ld de, wDecompressScratch

	ldh a, [hBattleTurn]
	and a
	jr z, .player

	ld hl, vBGTiles
	ld c, 49
	call Request2bpp

	call .DecompressSubSprite

	ld hl, vBGTiles tile (19)
	ld de, wDecompressScratch
	call .CopyTile

	ld hl, vBGTiles tile (20)
	ld de, wDecompressScratch + 2 tiles
	call .CopyTile

	ld hl, vBGTiles tile (26)
	ld de, wDecompressScratch + 1 tiles
	call .CopyTile

	ld hl, vBGTiles tile (27)
	ld de, wDecompressScratch + 3 tiles
	jr .finish

.player
	ld hl, vBGTiles tile (7 * 7)
	ld c, 36
	call Request2bpp

	call .DecompressSubSprite

	ld hl, vBGTiles tile (7 * 7 + 16)
	ld de, wDecompressScratch + 4 tiles
	call .CopyTile

	ld hl, vBGTiles tile (7 * 7 + 17)
	ld de, wDecompressScratch + 6 tiles
	call .CopyTile

	ld hl, vBGTiles tile (7 * 7 + 22)
	ld de, wDecompressScratch + 5 tiles
	call .CopyTile

	ld hl, vBGTiles tile (7 * 7 + 23)
	ld de, wDecompressScratch + 7 tiles
.finish
	call .CopyTile
	pop af
	ldh [rSVBK], a
	ret

.DecompressSubSprite
	ld hl, MonsterSpriteGFX
	ld de, wDecompressScratch
	ld a, BANK(MonsterSpriteGFX)
	jp FarDecompress

.CopyTile
	ld c, 1
	jp Request2bpp

BattleAnimCmd_MinimizeOpp:
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)
	call GetMinimizePic
	call Request2bpp
	pop af
	ldh [rSVBK], a
	ret

GetMinimizePic:
	ld hl, wDecompressScratch
	ld bc, (7 * 7) tiles
	xor a
	call ByteFill

	ldh a, [hBattleTurn]
	and a
	jr z, .player

	ld de, wDecompressScratch tile (3 * 7 + 5)
	call CopyMinimizePic
	ld hl, vBGTiles tile $00
	lb bc, BANK(GetMinimizePic), 7 * 7
	jr .done

.player
	ld de, wDecompressScratch tile (3 * 6 + 4)
	call CopyMinimizePic
	ld hl, vBGTiles tile (7 * 7)
	lb bc, BANK(GetMinimizePic), 6 * 6
.done
	ld de, wDecompressScratch
	ret

CopyMinimizePic:
	ld hl, MinimizePic
	ld bc, 1 tiles
	rst CopyBytes
	ret

MinimizePic: INCBIN "gfx/battle/minimize.2bpp"

BattleAnimCmd_Minimize:
	ldh a, [rSVBK]
	push af
	wbk BANK(wDecompressScratch)
	call GetMinimizePic
	ld hl, vObjTiles tile $00
	call Request2bpp
	pop af
	ldh [rSVBK], a
	ret

BattleAnimCmd_DropSub:
	ldh a, [rSVBK]
	push af
	wbk BANK(wCurPartySpecies)

	ld a, [wCurPartySpecies]
	push af
	ldh a, [hBattleTurn]
	and a
	ld hl, DropPlayerSub
	jr z, .farcall
	ld hl, DropEnemySub
.farcall
	ld a, BANK(DropEnemySub)
	call FarCall_hl
	pop af
	ld [wCurPartySpecies], a
	pop af
	ldh [rSVBK], a
	ret

BattleAnimCmd_OAMOn:
	xor a
	ldh [hOAMUpdate], a
	ret

BattleAnimCmd_OAMOff:
	ld a, 1
	ldh [hOAMUpdate], a
	ret

BattleAnimCmd_DarkenBall:
	jpba DarkenBall

BattleAnimCmd_ClearSprites:
	ld hl, wBattleAnimFlags
	set 3, [hl]
	ret

BattleAnimCmd_Sound:
	call GetBattleAnimByte
	ld e, a
	srl a
	srl a
	ld [wSFXDuration], a
	call .GetCryTrack
	and 3
	ld [wCryTracks], a ; CryTracks

	rra
	sbc a
	xor $f0 ;$f0 if a was even, $0f if a was odd
	ld [wStereoPanningMask], a

	call GetBattleAnimByte
	ld e, a
	ld d, 0
	cp SFX_THROW_BALL
	jr nz, .play
	ld a, [wFXAnimIDHi]
	and a
	jr z, .play
	ld a, [wFXAnimIDLo]
	cp LOW(ANIM_THROW_POKE_BALL)
	jr nz, .play
	ldh a, [rSVBK]
	push af
	wbk BANK(wCatchMon_Critical)
	ld a, [wCatchMon_Critical]
	and a
	jr z, .not_critical
	ld e, SFX_KINESIS
.not_critical
	pop af
	ldh [rSVBK], a
.play
	jpba PlayStereoSFX

.GetCryTrack
	ldh a, [hBattleTurn]
	and a
	ld a, e
	ret z
	xor 1
	ret

BattleAnimCmd_Cry:
	call GetBattleAnimByte
	ld c, a ; length offset
	ldh a, [rSVBK]
	push af
	wbk BANK(wEnemyMonSpecies)

	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonSpecies
	ld a, $f0
	jr z, .done_cry_tracks

	ld hl, wEnemyMonSpecies
	ld a, $f

.done_cry_tracks
	ld [wCryTracks], a
	ld a, [hl]
	ld b, a
	push bc
	call LoadCryHeader
	pop bc
	jr c, .ded
	ld hl, wCryLength
	ld a, c
	add [hl]
	ld [hli], a
	jr nc, .noCarry
	inc [hl]
.noCarry

	ld a, 1
	ld [wStereoPanningMask], a

	callba _PlayCryHeader

.done
	pop af
	ldh [rSVBK], a
	ret

.ded
	ld a, b
	ldh [hDEDCryFlag], a
	jr .done

PlayHitSound:
	ld a, [wNumHits]
	cp 4
	jr z, .okay
	dec a
	ret nz

.okay
	ld a, [wTypeModifier]
	and $7f
	ret z

	cp 10
	assert HIGH(SFX_DAMAGE) == 0
	ld de, SFX_DAMAGE
	jr z, .play

	assert HIGH(SFX_SUPER_EFFECTIVE) == 0
	ld e, SFX_SUPER_EFFECTIVE
	jr nc, .play

	assert HIGH(SFX_NOT_VERY_EFFECTIVE) == 0
	ld e, SFX_NOT_VERY_EFFECTIVE
.play
	jp PlaySFX

BattleAnimAssignPals:
	ld a, %11100100
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	call DmgToCgbBGPals
	lb de, %11100100, %11100100
	jp DmgToCgbObjPals

ClearBattleAnims:
; Clear animation block
	ld hl, wLYOverrides
	ld bc, wBattleAnimEnd - wLYOverrides
	xor a
	call ByteFill

	ld hl, wFXAnimIDLo
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, BattleAnimations
	add hl, de
	add hl, de
	call GetBattleAnimPointer
	call BattleAnimAssignPals
	jp DelayFrame

BattleAnim_RevertPals:
	call WaitTop
	call BattleAnimAssignPals
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call DelayFrame
	ld a, 1
	ldh [hBGMapMode], a
	ret

BattleAnim_SetBGPals:
	ldh [rBGP], a
	ldh a, [rSVBK]
	push af
	wbk BANK(wBGPals)
	ld hl, wBGPals
	ld de, wOriginalBGPals
	ldh a, [rBGP]
	ld b, a
	ld c, 7
	call CopyPals
	ld hl, wOBPals
	ld de, wOriginalOBJPals
	ldh a, [rBGP]
BattleAnim_ContinuePalUpdate:
	ld b, a
	ld c, 2
	call CopyPals
	pop af
	ldh [rSVBK], a
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

BattleAnim_SetOBPals:
	ldh [rOBP0], a
	ldh a, [rSVBK]
	push af
	wbk BANK(wOBPals)
	ld hl, wOBPals + $10
	ld de, wOriginalOBJPals + $10
	ldh a, [rOBP0]
	jr BattleAnim_ContinuePalUpdate

BattleAnim_UpdateOAM_All:
	xor a
	ld [wBattleAnimOAMPointerLo], a
	ld hl, wActiveAnimObjects
	ld e, 10
.update_loop
	ld a, [hl]
	and a
	jr z, .next
	ld c, l
	ld b, h
	push hl
	push de
	call DoBattleAnimFrame
	call BattleAnimOAMUpdate
	pop de
	pop hl
	ret c

.next
	ld bc, BATTLEANIMSTRUCT_LENGTH
	add hl, bc
	dec e
	jr nz, .update_loop
	ld a, [wBattleAnimOAMPointerLo]
	ld l, a
	ld h, HIGH(wSprites)
.clear_loop
	ld a, l
	cp LOW(wSpritesEnd)
	ret nc
	xor a
	ld [hli], a
	jr .clear_loop

BattleAnimCmdHelper_FindObjIdx:
	ld e, 10
	ld bc, wActiveAnimObjects
.loop
	ld hl, BATTLEANIMSTRUCT_INDEX
	add hl, bc
	ld d, [hl]
	ld a, [wBattleAnimByte]
	cp d
	ret z
	ld hl, BATTLEANIMSTRUCT_LENGTH
	add hl, bc
	ld c, l
	ld b, h
	dec e
	jr nz, .loop
	scf
	ret

BattleAnimCmd_FindBGIdx:
	ld e, 5
	ld bc, wActiveBGEffects
.loop
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld d, [hl]
	ld a, [wBattleAnimByte]
	cp d
	ret z
	ld hl, BG_EFFECT_STRUCT_LENGTH
	add hl, bc
	ld c, l
	ld b, h
	dec e
	jr nz, .loop
	scf
	ret

BattleAnimCmd_ClearFirstBGEffect:
	xor a
	ld [wActiveBGEffects], a
	ret
