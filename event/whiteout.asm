Script_BattleWhiteout::
	callasm BattleBGMap
	jump Script_Whiteout

Script_OverworldWhiteout::
	refreshscreen $0
	callasm OverworldBGMap
	loadvar wWhiteOutFlags, 0
Script_Whiteout:
	checkflag ENGINE_POKEMON_MODE
	sif false
		writetext .WhitedOutText
	special Special_FadeOutMusic
	special FadeOutPalettes
	pause 40
	special HealParty
	callasm GetWhiteoutSpawn
	newloadmap MAPSETUP_WARP
	end_all

.WhitedOutText
	; is out of useable #mon!  whited out!
	text_far WhiteoutText
	start_asm
	ldh a, [rSVBK]
	push af
	wbk BANK(wSoundStackSize)
	xor a
	ld [wSoundStackSize], a
	pop af
	ldh [rSVBK], a
	call Gen6Payout
	ld hl, wWhiteOutFlags
	bit 0, [hl]
	ld [hl], 0
	jr z, .wild_panic
	ld hl, .PaidToWinnerText
	jr .okay

.wild_panic
	ld hl, .PanickedAndDroppedText
.okay
	call PrintText
	ld hl, .FinishWhiteOutText
	ret

.PaidToWinnerText
	text_jump PaidToWinnerText

.PanickedAndDroppedText
	text_jump PanickedAndDroppedText

.FinishWhiteOutText
	text_jump FinishWhiteOutText

OverworldBGMap:
	ld c, 1
	call FadeOutPals
	call ClearPalettes
	call ClearScreen
	call ApplyAttrAndTilemapInVBlank
	jp HideSprites

BattleBGMap:
	ld b, SCGB_BATTLE_GRAYSCALE
	predef GetSGBLayout
	jp SetPalettes

Gen6Payout:
	ld hl, wBadges
	ld b, 2
	call CountSetBits
	cp 8
	jr c, .less_than_8_badges
	ld a, 120
	jr .got_base

.less_than_8_badges
	add LOW(.Payouts)
	ld l, a
	adc HIGH(.Payouts)
	sub l
	ld h, a
	ld a, [hl]
.got_base
	ldh [hMultiplier], a
	ld hl, wPartyMon1Level
	ld a, [wPartyCount]
	ld e, a
	ld d, 1
	jr .loop

.next
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
.loop
	ld a, [hl]
	cp d
	jr c, .skip
	ld d, a
.skip
	dec e
	jr nz, .next
	ld a, d
	ldh [hMultiplicand + 2], a
	xor a
	ldh [hMultiplicand + 1], a
	ldh [hMultiplicand], a
	predef Multiply
	ldh a, [hProduct + 1]
	ldh [hMoneyTemp], a
	ldh a, [hProduct + 2]
	ldh [hMoneyTemp + 1], a
	ldh a, [hProduct + 3]
	ldh [hMoneyTemp + 2], a
	ld bc, hMoneyTemp
	ld de, wMoney
	callba CompareMoney
	jr c, .zero_out
	ld bc, hMoneyTemp
	ld de, wMoney
	jpba TakeMoney

.zero_out
	ld hl, wMoney
	ld a, [hli]
	ldh [hMoneyTemp], a
	ld a, [hli]
	ldh [hMoneyTemp + 1], a
	ld a, [hl]
	ldh [hMoneyTemp + 2], a
	xor a
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ret

.Payouts:
	db 8, 16, 24, 36, 64, 80, 100, 120

GetWhiteoutSpawn:
	ld a, [wLastSpawnMapGroup]
	ld d, a
	ld a, [wLastSpawnMapNumber]
	ld e, a
	callba IsSpawnPoint
	ld a, c
	jr c, .yes
	xor a ; SPAWN_HOME

.yes
	ld [wd001], a
	ret
