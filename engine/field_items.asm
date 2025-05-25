FishFunction:
	ld a, e
	push af
	call ClearFieldMoveBuffer
	pop af
	ld [wRodType], a
.loop
	ld hl, .FishTable
	call FieldMoveJumptable
	jr nc, .loop
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.FishTable
	dw .TryFish
	dw .FishNoBite
	dw .FishGotSomething
	dw .FailFish
	dw .FishNoFish

.TryFish
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .fail
	cp PLAYER_SURF_PIKA
	jr z, .fail
	call GetFacingTileCoord
	call GetTileCollision
	dec a
	jr z, .facingwater
.fail
	ld a, 3
	ret

.facingwater
	call GetFishingGroup
	and a
	jr nz, .goodtofish
	ld a, 4
	ret

.goodtofish
	ld d, a
	ld a, [wRodType]
	ld e, a
	callba SelectFishedMon
	ld a, d
	and a
	jr z, .nonibble
	ld [wTempWildMonSpecies], a
	ld a, e
	ld [wCurPartyLevel], a
	ld a, BATTLETYPE_FISH
	ld [wBattleType], a
	ld a, 2
	ret

.nonibble
	ld a, 1
	ret

.FailFish
	ld a, $80
	ret

.FishGotSomething
	ld a, 1
	ld [wFishResponse], a
	ld hl, Script_GotABite
	jr .queue_script_and_end

.FishNoBite
	ld a, 2
	jr .not_even_a_nibble

.FishNoFish
	xor a
.not_even_a_nibble
	ld [wFishResponse], a
	ld hl, Script_NotEvenANibble
.queue_script_and_end
	call QueueScript
	ld a, $81
	ret

Script_NotEvenANibble:
	scall Script_FishCastRod
	farwritetext Fishing_Nope_Text
	loademote EMOTE_SHADOW
	callasm PutTheRodAway
	closetextend

Script_GotABite:
	scall Script_FishCastRod
	callasm Fishing_CheckFacingUp
	sif true, then
		applymovement PLAYER, .Movement_FacingUp
	selse
		applymovement PLAYER, .Movement_NotFacingUp
	sendif
	pause 40
	applymovement PLAYER, .Movement_RestoreRod
	farwritetext Fishing_Bite_Text
	callasm PutTheRodAway
	closetext
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

.Movement_NotFacingUp
	fish_got_bite
	fish_got_bite
	fish_got_bite
	fish_got_bite
	show_emote
	step_end

.Movement_FacingUp
	fish_got_bite
	fish_got_bite
	fish_got_bite
	fish_got_bite
	step_sleep_1
	show_emote
	step_end

.Movement_RestoreRod
	hide_emote
	step_end

Fishing_CheckFacingUp:
	ld a, [wPlayerDirection]
	and $c
	cp OW_UP
	ld a, 1
	jr z, .up
	xor a
.up
	ldh [hScriptVar], a
	ret

Script_FishCastRod:
	reloadmappart
	loadvar hBGMapMode, 0
	special UpdateTimePals
	callasm LoadFishingGFX
	loademote EMOTE_SHOCK
	applymovement PLAYER, .Movement
	end

.Movement
	fish_cast_rod
	step_end

PutTheRodAway:
	xor a
	ldh [hBGMapMode], a
	ld a, PERSON_ACTION_STAND
	ld [wPlayerAction], a
	ld hl, wScriptFlags2
	res 0, [hl]
	call UpdateSprites
	jp ReplaceKrisSprite

BikeFunction:
	call .TryBike
	and $7f
	ld [wFieldMoveSucceeded], a
	ret

.TryBike
	ld a, [wTileset]
	cp TILESET_SIDESCROLL
	jr z, .CannotUseBike
	call .CheckEnvironment
	jr c, .CannotUseBike
	ld a, [wPlayerState]
	and a ; PLAYER_NORMAL
	jr z, .GetOnBike
	cp PLAYER_BIKE
	jr nz, .CannotUseBike

.GetOffBike
	ld hl, wBikeFlags
	bit 1, [hl]
	jr nz, .CantGetOffBike
	ld hl, Script_GetOffBike
	ld de, Script_GetOffBike_Register
	call .CheckIfRegistered
	ld a, BANK(Script_GetOffBike)
	jr .done

.CannotUseBike
	xor a
	ret

.GetOnBike
	ld hl, Script_GetOnBike
	ld de, Script_GetOnBike_Register
	call .CheckIfRegistered
	call QueueScript
	ld a, MUSIC_BICYCLE
	ld [wMapMusic], a
	ld [wMusicFadeID], a
	xor a
	ld [wMusicFadeID + 1], a
	ld a, 8
	ld [wMusicFade], a
	ld a, 1
	ret

.CantGetOffBike
	ld hl, Script_CantGetOffBike
.done
	call QueueScript
	ld a, 1
	ret

.CheckIfRegistered
	ld a, [wUsingItemWithSelect]
	and a
	ret z
	ld h, d
	ld l, e
	ret

.CheckEnvironment
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .ok
	cp CAVE
	jr z, .ok
	cp GATE
	jr nz, .nope
.ok
	call GetPlayerStandingTile
	and $f ; can't use our bike in a wall or on water
	ret z
.nope
	scf
	ret

Script_GetOnBike:
	reloadmappart
	special UpdateTimePals
	writecode VAR_MOVEMENT, PLAYER_BIKE
	farwritetext Bike_GotOn_Text
	jump Script_GetOnBike_AfterSettingMovement

Script_GetOnBike_Register:
	writecode VAR_MOVEMENT, PLAYER_BIKE
Script_GetOnBike_AfterSettingMovement:
	closetext
	special ReplaceKrisSprite
	end

Script_GetOffBike:
	reloadmappart
	special UpdateTimePals
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	farwritetext Bike_GotOff_Text
FinishGettingOffBike:
	closetext
	special ReplaceKrisSprite
	fadetomapmusic 8
	end

Script_GetOffBike_Register:
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	jump FinishGettingOffBike

Script_CantGetOffBike:
	farjumptext Bike_CantGetOff_Text
