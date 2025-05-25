BattleStart_TrainerHuds:
	ld a, $e4
	ldh [rOBP0], a
	call LoadBallIconGFX
	call ShowPlayerMonsRemaining
	ld a, [wBattleMode]
	dec a
	ret z
	jr ShowOTTrainerMonsRemaining

EnemySwitch_TrainerHud:
	ld a, $e4
	ldh [rOBP0], a
	call LoadBallIconGFX
	jr ShowOTTrainerMonsRemaining

ShowPlayerMonsRemaining:
	call DrawPlayerPartyIconHUDBorder
	ld hl, wPartyMon1HP
	ld de, wPartyCount
	call StageBallTilesData
	ld a, 12 * 8
	ld hl, wPlaceBallsX
	ld [hli], a
	ld [hl], a
	ld a, 8
	ld [wPlaceBallsDirection], a
	ld hl, wSprites
	jp LoadTrainerHudOAM

ShowOTTrainerMonsRemaining:
	call DrawEnemyHUDBorder
	ld hl, wOTPartyMon1HP
	ld de, wOTPartyCount
	call StageBallTilesData
	ld hl, wPlaceBallsX
	ld a, 9 * 8
	ld [hli], a
	ld [hl], 4 * 8
	ld a, -8
	ld [wPlaceBallsDirection], a
	ld hl, wSprites + PARTY_LENGTH * 4
	jp LoadTrainerHudOAM

StageBallTilesData:
	ld a, [de]
	push af
	ld de, wTrainerHUD_BallIcons
	ld c, PARTY_LENGTH
	ld a, $34 ; empty slot
.loop1
	ld [de], a
	inc de
	dec c
	jr nz, .loop1
	pop af
	ld de, wTrainerHUD_BallIcons
.loop2
	push af
	call .GetHUDTile
	inc de
	pop af
	dec a
	jr nz, .loop2
	ret

.GetHUDTile
	ld a, [hli]
	and a
	jr nz, .got_hp
	ld a, [hl]
	and a
	ld b, $33 ; fainted
	jr z, .fainted

.got_hp
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	and a
	ld b, $32 ; statused
	jr nz, .load
	dec b ; normal
	jr .load

.fainted
	dec hl
	dec hl
	dec hl

.load
	ld a, b
	ld [de], a
	ld bc, PARTYMON_STRUCT_LENGTH + MON_HP - MON_STATUS
	add hl, bc
	ret

DrawEnemyHUDBorder:
	hlcoord 0, 3
	call PlaceHUDBorderTiles
	ld [hl], $78
	ret

DrawPlayerPartyIconHUDBorder:
	hlcoord 9, 11
	ld a, $74
	ld [hli], a

PlaceHUDBorderTiles:
	ld a, $77
	ld bc, 10
	jp ByteFill

LinkBattle_TrainerHuds:
	call LoadBallIconGFX
	ld hl, wPartyMon1HP
	ld de, wPartyCount
	call StageBallTilesData
	ld hl, wPlaceBallsX
	ld a, 10 * 8
	ld [hli], a
	ld [hl], 8 * 8
	ld a, 8
	ld [wPlaceBallsDirection], a
	ld hl, wSprites
	call LoadTrainerHudOAM

	ld hl, wOTPartyMon1HP
	ld de, wOTPartyCount
	call StageBallTilesData
	ld hl, wPlaceBallsX
	ld a, 10 * 8
	ld [hli], a
	ld [hl], 13 * 8
	ld hl, wSprites + PARTY_LENGTH * 4
	; fallthrough

LoadTrainerHudOAM:
	ld de, wTrainerHUD_BallIcons
	ld c, PARTY_LENGTH
.loop
	ld a, [wPlaceBallsY]
	ld [hli], a
	ld a, [wPlaceBallsX]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld a, 3
	ld [hli], a
	ld a, [wPlaceBallsX]
	ld b, a
	ld a, [wPlaceBallsDirection]
	add b
	ld [wPlaceBallsX], a
	inc de
	dec c
	jr nz, .loop
	ret

LoadBallIconGFX:
	ld de, .gfx
	ld hl, vObjTiles tile $31
	lb bc, BANK(LoadBallIconGFX), 4
	jp Get2bpp

.gfx: INCBIN "gfx/battle/balls.2bpp"

_ShowLinkBattleParticipants:
	call ClearBGPalettes
	call LoadFontsExtra
	hlcoord 2, 3
	lb bc, 9, 14
	call TextBox
	hlcoord 4, 5
	ld de, wPlayerName
	call PlaceString
	hlcoord 4, 10
	ld de, wOTPlayerName
	call PlaceString
	hlcoord 9, 8
	ld a, "<BOLDV>"
	ld [hli], a
	ld [hl], "<BOLDS>"
	callba LinkBattle_TrainerHuds ; no need to callba
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	ld a, $e4
	ldh [rOBP0], a
	ret
