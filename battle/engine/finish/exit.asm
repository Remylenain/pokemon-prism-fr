ExitBattle:
	call .handle_end_of_battle
	call BattleEnd_HandleRoamMons
	xor a
	ld [wLowHealthAlarm], a
	ld [wBattleMode], a
	ld [wBattleType], a
	ld [wAttackMissed], a
	ld [wTempWildMonSpecies], a
	ld [wOtherTrainerClass], a
	ld [wFailedToFlee], a
	ld [wNumFleeAttempts], a
	ld [wForcedSwitch], a
	ld [wPartyMenuCursor], a
	ld [wKeyItemsPocketCursor], a
	ld [wItemsPocketCursor], a
	ld [wd0d2], a
	ld [wCurMoveNum], a
	ld [wBallsPocketCursor], a
	ld [wLastPocket], a
	ld [wMenuScrollPosition], a
	ld [wKeyItemsPocketScrollPosition], a
	ld [wItemsPocketScrollPosition], a
	ld [wBallsPocketScrollPosition], a
	ld [wRespawnableEventMonBaseIndex], a
	ld hl, wPlayerSubStatus1
	ld b, wEnemyFuryCutterCount - wPlayerSubStatus1
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	jp WaitSFX

.handle_end_of_battle
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	call ShowLinkBattleParticipantsAfterEnd
	ld c, 150
	call DelayFrames
	jp HandleLinkBattleResult

.not_linked
	call PostBattleUpdateParty
	xor a
	ld [wForceEvolution], a
	callba EvolveAfterBattle
	jpba GivePokerusAndConvertBerries

PostBattleUpdateParty:
; Does party updates after battle -- Natural Cure status heal and Stat Exp recalculation
	ld a, [wPartyCount]
.loop
	dec a
	push af
	ld [wCurPartyMon], a
	xor a
	call GetPartyParamLocation
	call CalcPartyMonAbility
	cp ABILITY_NATURAL_CURE
	jr nz, .natural_cure_done
	ld a, MON_STATUS
	call GetPartyParamLocation
	ld [hl], 0
.natural_cure_done
	callba UpdatePkmnStats
	pop af
	jr nz, .loop
	ret

BattleEnd_HandleRoamMons:
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .not_roaming
	ld a, [wBattleResult]
	and $f
	jr z, .caught_or_defeated_roam_mon
	ld hl, wRoamMon1HP
	ld a, [wEnemyMonHP]
	ld [hli],  a
	ld a, [wEnemyMonHP + 1]
	ld [hl], a
	jr .update_roam_mons

.caught_or_defeated_roam_mon
	ld hl, wRoamMon1HP
	xor a
	ld [hli], a
	ld [hl], a
	dec a
	ld hl, wRoamMon1MapGroup
	ld [hl], a
	ld hl, wRoamMon1MapNumber
	ld [hl], a
	inc a
	ld hl, wRoamMon1Species
	ld [hl], a
	ret

.not_roaming
	call BattleRandom
	and $f
	ret nz
.update_roam_mons
	jpba UpdateRoamMons
