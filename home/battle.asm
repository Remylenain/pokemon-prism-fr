UserPartyAttr::
	push af
	ldh a, [hBattleTurn]
	and a
	jr z, .battlemon
	pop af
	jr OTPartyAttr
.battlemon
	pop af
	; fallthrough

BattlePartyAttr::
; Get attribute a from the active battle mon's party struct.
	push bc
	ld c, a
	ld b, 0
	ld hl, wPartyMons
	add hl, bc
	ld a, [wCurBattleMon]
	call GetPartyLocation
	pop bc
	ret

OpponentPartyAttr::
	push af
	ldh a, [hBattleTurn]
	and a
	jr z, .ot
	pop af
	jr BattlePartyAttr
.ot
	pop af
	; fallthrough

OTPartyAttr::
; Get attribute a from the active enemy mon's party struct.
	push bc
	ld c, a
	ld b, 0
	ld hl, wOTPartyMon1Species
	add hl, bc
	ld a, [wCurOTMon]
	call GetPartyLocation
	pop bc
	ret

ResetDamage::
	push hl
	push bc
	xor a
	ld hl, wCurrentDamageData
	ld bc, wCurrentDamageDataEnd - wCurrentDamageData
	call ByteFill
	ld a, 1
	ld [wCurDamageDefense + 1], a ;prevent div0
	ld [wCurDamageMovePowerDenominator], a
	ld [wCurDamageModifierNumerator + 2], a
	ld [wCurDamageModifierDenominator + 1], a
	ld a, 100
	ld [wCurDamageItemModifier], a
	pop bc
	pop hl
	ret

ZeroDamage::
	; sets damage to 0 and fixed; exits with a = 0
	push hl
	ld hl, wCurDamageFixedValue + 1
	xor a
	ld [hld], a
	ld [hld], a
	assert wCurDamageFlags == wCurDamageFixedValue - 1
	ld [hl], $c0 ;fixed damage, dirty
	pop hl
	ret

SetDamageDirtyFlag::
	push hl
SetDamageDirtyFlag_PushedHL:
	ld hl, wCurDamageFlags
	set 6, [hl]
	pop hl
	ret

GetCurrentDamage::
	push hl
	ld hl, wCurDamageFlags
	bit 6, [hl]
	jr z, .clean
	res 6, [hl]
	push bc
	push de
	callba _GetCurrentDamage
	pop de
	pop bc
.clean
	pop hl
	ret

SetPlayerTurn::
	xor a
	ldh [hBattleTurn], a
	ret

UpdateOpponentInParty::
	ldh a, [hBattleTurn]
	and a
	jr nz, UpdateBattleMonInParty
	; fallthrough

UpdateEnemyMonInParty::
; Update level, status, current HP

; No wildmons.
	ld a, [wBattleMode]
	dec a
	ret z

	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, wEnemyMonLevel
	ld bc, wEnemyMonMaxHP - wEnemyMonLevel

	rst CopyBytes
	ret

UpdateUserInParty::
	ldh a, [hBattleTurn]
	and a
	jr nz, UpdateEnemyMonInParty
	; fallthrough

UpdateBattleMonInParty::
; Update level, status, current HP
	ld a, [wCurBattleMon]
UpdateBattleMon::
	ld hl, wPartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, wBattleMonLevel
	ld bc, wBattleMonMaxHP - wBattleMonLevel
	rst CopyBytes
	ret

RefreshBattleHuds::
	call UpdateBattleHuds
	call Delay2
	jp ApplyTilemapInVBlank

UpdateBattleHuds::
	jpba _UpdateBattleHuds

GetBattleVar::
; Preserves hl.
	push hl
	call GetBattleVarAddr
	pop hl
	ret

GetBattleVarAddr::
; Get variable from pair a, depending on whose turn it is.
; There are 21 variable pairs.

; Enemy turn uses the second byte instead.
; This lets battle variable calls be side-neutral.
	ld l, a
	ldh a, [hBattleTurn]
	add l
	add l
	add LOW(.battlevarpairs)
	ld l, a
	adc HIGH(.battlevarpairs)
	sub l
	ld h, a

; get variable ID * 2, index into list of addresses
	ld a, [hl]
	add LOW(.vars)
	ld l, a
	adc HIGH(.vars)
	sub l
	ld h, a

	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hl]

	ret

.battlevarpairs
MACRO battlevarpair
	db \1 * 2, \2 * 2
ENDM
;                       player                     enemy
	battlevarpair PLAYER_SUBSTATUS_1,    ENEMY_SUBSTATUS_1    ; BATTLE_VARS_SUBSTATUS1
	battlevarpair PLAYER_SUBSTATUS_2,    ENEMY_SUBSTATUS_2    ; BATTLE_VARS_SUBSTATUS2
	battlevarpair PLAYER_SUBSTATUS_3,    ENEMY_SUBSTATUS_3    ; BATTLE_VARS_SUBSTATUS3
	battlevarpair PLAYER_SUBSTATUS_4,    ENEMY_SUBSTATUS_4    ; BATTLE_VARS_SUBSTATUS4
	battlevarpair PLAYER_SUBSTATUS_5,    ENEMY_SUBSTATUS_5    ; BATTLE_VARS_SUBSTATUS5
	battlevarpair ENEMY_SUBSTATUS_1,     PLAYER_SUBSTATUS_1   ; BATTLE_VARS_SUBSTATUS1_OPP
	battlevarpair ENEMY_SUBSTATUS_2,     PLAYER_SUBSTATUS_2   ; BATTLE_VARS_SUBSTATUS2_OPP
	battlevarpair ENEMY_SUBSTATUS_3,     PLAYER_SUBSTATUS_3   ; BATTLE_VARS_SUBSTATUS3_OPP
	battlevarpair ENEMY_SUBSTATUS_4,     PLAYER_SUBSTATUS_4   ; BATTLE_VARS_SUBSTATUS4_OPP
	battlevarpair ENEMY_SUBSTATUS_5,     PLAYER_SUBSTATUS_5   ; BATTLE_VARS_SUBSTATUS5_OPP
	battlevarpair PLAYER_STATUS,         ENEMY_STATUS         ; BATTLE_VARS_STATUS
	battlevarpair ENEMY_STATUS,          PLAYER_STATUS        ; BATTLE_VARS_STATUS_OPP
	battlevarpair PLAYER_SEMISTATUS,     ENEMY_SEMISTATUS     ; BATTLE_VARS_SEMISTATUS
	battlevarpair ENEMY_SEMISTATUS,      PLAYER_SEMISTATUS    ; BATTLE_VARS_SEMISTATUS_OPP
	battlevarpair PLAYER_MOVE_ANIMATION, ENEMY_MOVE_ANIMATION ; BATTLE_VARS_MOVE_ANIM
	battlevarpair PLAYER_MOVE_EFFECT,    ENEMY_MOVE_EFFECT    ; BATTLE_VARS_MOVE_EFFECT
	battlevarpair PLAYER_MOVE_POWER,     ENEMY_MOVE_POWER     ; BATTLE_VARS_MOVE_POWER
	battlevarpair PLAYER_MOVE_TYPE,      ENEMY_MOVE_TYPE      ; BATTLE_VARS_MOVE_TYPE
	battlevarpair PLAYER_CUR_MOVE,       ENEMY_CUR_MOVE       ; BATTLE_VARS_MOVE
	battlevarpair PLAYER_COUNTER_MOVE,   ENEMY_COUNTER_MOVE   ; BATTLE_VARS_LAST_COUNTER_MOVE
	battlevarpair ENEMY_COUNTER_MOVE,    PLAYER_COUNTER_MOVE  ; BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	battlevarpair PLAYER_LAST_MOVE,      ENEMY_LAST_MOVE      ; BATTLE_VARS_LAST_MOVE
	battlevarpair ENEMY_LAST_MOVE,       PLAYER_LAST_MOVE     ; BATTLE_VARS_LAST_MOVE_OPP

PURGE battlevarpair

.vars
	dw wPlayerSubStatus1,             wEnemySubStatus1
	dw wPlayerSubStatus2,             wEnemySubStatus2
	dw wPlayerSubStatus3,             wEnemySubStatus3
	dw wPlayerSubStatus4,             wEnemySubStatus4
	dw wPlayerSubStatus5,             wEnemySubStatus5
	dw wBattleMonStatus,              wEnemyMonStatus
	dw wBattleMonSemistatus,          wEnemyMonSemistatus
	dw wPlayerMoveStructAnimation,    wEnemyMoveStructAnimation
	dw wPlayerMoveStructEffect,       wEnemyMoveStructEffect
	dw wPlayerMoveStructPower,        wEnemyMoveStructPower
	dw wPlayerMoveStructType,         wEnemyMoveStructType
	dw wCurPlayerMove,                wCurEnemyMove
	dw wLastEnemyCounterMove,         wLastPlayerCounterMove
	dw wLastPlayerMove,               wLastEnemyMove

StdBattleTextBox::
; Open a textbox and print battle text at 20:hl.
	anonbankpush BattleText

BattleTextBox::
; Open a textbox and print text at hl.
	push hl
	call SpeechTextBox
	call UpdateSprites
	call ApplyTilemap
	pop hl
	jp PrintTextBoxText

GetBattleAnimPointer::
	anonbankpush BattleAnimations
	; end of function

	ld a, [hli]
	ld [wBattleAnimAddress], a
	ld a, [hl]
	ld [wBattleAnimAddress + 1], a
	ret

GetBattleAnimByte::
	anonbankpush BattleAnimations
	; end of function

	push hl
	push de

	ld hl, wBattleAnimAddress
	ld a, [hli]
	ld d, [hl]
	ld e, a

	ld a, [de]
	ld [wBattleAnimByte], a
	inc de

	ld a, d
	ld [hld], a
	ld [hl], e

	pop de
	pop hl

	ld a, [wBattleAnimByte]
	ret

ApplyBattleMonRingEffect::
	ld hl, wPlayerStatLevels
	ld a, [wBattleMonItem]
	callba ApplyHeldRingEffect
	jpba CalcPlayerStats

ApplyEnemyMonRingEffect::
	ld hl, wEnemyStatLevels
	ld a, [wEnemyMonItem]
	callba ApplyHeldRingEffect
	jpba CalcEnemyStats

CheckPokemonOnlyMode::
	ldh a, [rSVBK]
	ldh [hBuffer], a
	wbk BANK(wStatusFlags)
	CheckEngine ENGINE_POKEMON_MODE
	ldh a, [hBuffer]
	ldh [rSVBK], a
	ret

PokedexEntryBanks::
	db BANK(PokedexEntries1)
	db BANK(PokedexEntries2)
	db BANK(PokedexEntries3)
	db BANK(PokedexEntries4)

CalcUserAbility:
	ldh a, [hBattleTurn]
	and a
	jr z, CalcPlayerAbility
CalcEnemyAbility:
	push hl
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	ld hl, wEnemyMonDVs
	ld a, [wBattleMode]
	cp 2
	jr z, .calctrainer
	callba CalcMonAbility
	jr .calcdone
.calctrainer
	callba CalcTrainerMonAbility
.calcdone
	ld [wEnemyAbility], a
	pop hl
	ret

CalcTargetAbility:
	ldh a, [hBattleTurn]
	and a
	jr z, CalcEnemyAbility
CalcPlayerAbility:
	push hl
	ld a, [wBattleMonSpecies]
	ld [wCurSpecies], a
	ld hl, wBattleMonDVs
	callba CalcMonAbility
	ld [wPlayerAbility], a
	pop hl
	ret

CalcPartyMonAbility:
; pointer to party struct in hl
	ld a, [hl]
	ld [wCurSpecies], a
	push hl
	push bc
	ld bc, MON_DVS
	add hl, bc
	pop bc
	callba CalcMonAbility
	pop hl
	ret

CheckHiddenOpponent:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret

CheckSubstituteOpp:
	call IsSoundBasedMove
	jr nc, .not_sound_based
	xor a
	ret
.not_sound_based
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret

CheckUserIsCharging:
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerCharging] ; player
	jr z, .end
	ld a, [wEnemyCharging] ; enemy
.end
	and a
	ret

CheckBattleScene:
; Return carry if battle scene is turned off.
	ld a, [wOptions]
	and 1 << BATTLE_SCENE
	ret z
	scf
	ret

BattleCommand_RaiseSubNoAnim:
	ld hl, GetMonBackpic
	ldh a, [hBattleTurn]
	and a
	jr z, .PlayerTurn
	ld hl, GetMonFrontpic
.PlayerTurn
	xor a
	ldh [hBGMapMode], a
	ld a, BANK(BattleCore)
	call FarCall_hl
	jp ApplyTilemapInVBlank

BattleCommand_ClearText:
; cleartext

; Used in multi-hit moves.
	ld hl, GenericDummyString
	jp BattleTextBox

TryPrintButItFailed:
	ld a, [wAlreadyFailed]
	and a
	ret nz
PrintButItFailed:
; 'but it failed!'
	ld hl, ButItFailedText
	jp StdBattleTextBox

EndMoveEffect:
	ld hl, wBattleScriptBufferLoc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

GetUserItem:
; Return the effect of the user's item in bc, and its id at hl.
	ld hl, wBattleMonItem
	ld de, wPlayerAbility
	ldh a, [hBattleTurn]
	and a
	jr z, GetItemHeldEffect
	ld hl, wEnemyMonItem
	ld de, wEnemyAbility
	jr GetItemHeldEffect

GetOpponentItem:
; Return the effect of the opponent's item in bc, and its id at hl.
	ld hl, wEnemyMonItem
	ld de, wEnemyAbility
	ldh a, [hBattleTurn]
	and a
	jr z, GetItemHeldEffect
	ld hl, wBattleMonItem
	ld de, wPlayerAbility
GetItemHeldEffect:
; Return the effect of item [hl] in bc, unless [de] is ABILITY_KLUTZ, then return HELD_NONE
	ld a, [de]
	cp ABILITY_KLUTZ
	jr z, SetBCToZero
GetItemHeldEffect_IgnoreKlutz:
	ld a, [hl]
	and a
	jr z, SetBCToZero
	push hl
	ld hl, ItemAttributes + ITEMATTR_EFFECT
	dec a
	ld c, a
	ld b, 0
	ld a, NUM_ITEMATTRS
	rst AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarHalfword
	ld b, l
	ld c, h
	pop hl
	ret

SetBCToZero:
	ld bc, 0
	ret

SwitchTurn:
	ldh a, [hBattleTurn]
	xor 1
	ldh [hBattleTurn], a
	ret

GetTargetAbility:
	ldh a, [hBattleTurn]
	and a
	jr z, GetEnemyAbility
GetPlayerAbility:
	push bc
	ld a, [wPlayerAbility]
	ld b, a
	ld a, [wEnemyAbility]
	jr GetAbility_CheckMoldBreaker
	;exits with bc pushed

GetUserAbility:
	ldh a, [hBattleTurn]
	and a
	jr z, GetPlayerAbility
GetEnemyAbility:
	push bc
	ld a, [wEnemyAbility]
	ld b, a
	ld a, [wPlayerAbility]
GetAbility_CheckMoldBreaker:
	; WARNING: called with bc pushed
	cp ABILITY_MOLD_BREAKER
	jr z, .check_mold_breaker
	ld a, b
	pop bc
	ret

.check_mold_breaker
	push hl
	ld hl, .Abilities
.loop
	ld a, [hli]
	cp $ff
	jr z, .not_broken
	cp b
	jr nz, .loop
	xor a ; ABILITY_NONE
	jr .done

.not_broken
	ld a, b
.done
	pop hl
	pop bc
	ret

.Abilities
	db ABILITY_BATTLE_ARMOR
	db ABILITY_CLEAR_BODY
	db ABILITY_DRY_SKIN
	db ABILITY_FLASH_FIRE
	db ABILITY_HEATPROOF
	db ABILITY_HYPER_CUTTER
	db ABILITY_IMMUNITY
	db ABILITY_INNER_FOCUS
	db ABILITY_INSOMNIA
	db ABILITY_KEEN_EYE
	db ABILITY_LEAF_GUARD
	db ABILITY_LEVITATE
	db ABILITY_LIGHTNINGROD
	db ABILITY_LIMBER
	db ABILITY_MAGMA_ARMOR
	db ABILITY_MARVEL_SCALE
	db ABILITY_MOTOR_DRIVE
	db ABILITY_OBLIVIOUS
	db ABILITY_OWN_TEMPO
	db ABILITY_SAND_VEIL
	db ABILITY_SHIELD_DUST
	db ABILITY_SIMPLE
	db ABILITY_SNOW_CLOAK
	db ABILITY_SOLID_ROCK
	db ABILITY_SOUNDPROOF
	db ABILITY_STURDY
	db ABILITY_SUCTION_CUPS
	db ABILITY_TANGLED_FEET
	db ABILITY_THICK_FAT
	db ABILITY_VITAL_SPIRIT
	db ABILITY_VOLT_ABSORB
	db ABILITY_WATER_ABSORB
	db ABILITY_WATER_VEIL
	db ABILITY_WHITE_SMOKE
	db ABILITY_CONTRARY
	db $ff

GetUserAbility_IgnoreMoldBreaker:
	ldh a, [hBattleTurn]
	and a
	jr nz, GetEnemyAbility_IgnoreMoldBreaker
GetPlayerAbility_IgnoreMoldBreaker:
	ld a, [wPlayerAbility]
	ret

GetTargetAbility_IgnoreMoldBreaker:
	ldh a, [hBattleTurn]
	and a
	jr nz, GetPlayerAbility_IgnoreMoldBreaker
GetEnemyAbility_IgnoreMoldBreaker:
	ld a, [wEnemyAbility]
	ret

GetWeatherAfterAbilities:
; sets a to current weather, or 0 if an ability negates it
; Returns: z if negated by an ability, otherwise nz
	ld a, [wPlayerAbility]
	xor ABILITY_AIR_LOCK
	ret z
	ld a, [wEnemyAbility]
	xor ABILITY_AIR_LOCK
	ret z
	ld a, [wWeather]
	ret

CheckPlayerNaturalCure:
	ld a, [wPlayerAbility]
	cp ABILITY_NATURAL_CURE
	ret nz
	ld a, [wLastPlayerMon]
	ld hl, wPartyMon1Status
	call GetPartyLocation
	ld [hl], 0
	ret

IsSoundBasedMove:
	; carry if true
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	sub BUG_BUZZ
	jr z, .return_carry ; 0 < 1, so it will carry
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	sub SOUND
.return_carry
	cp 1
	ret

CheckIfInEagulouParkBattle:
	ld a, [wBattleMode]
	dec a
	ret nz
	ld a, [wMapGroup]
	cp GROUP_EAGULOU_CITY
	ret nz
	ld a, [wMapNumber]
	sub MAP_EAGULOU_PARK_1
	ret z
	dec a
	ret z
	dec a
	ret
