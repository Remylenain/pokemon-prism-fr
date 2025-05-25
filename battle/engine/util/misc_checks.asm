CheckAmuletCoin:
	ld hl, wBattleMonItem
	ld de, wPlayerAbility
	ld b, a
	call GetItemHeldEffect
	ld a, b
	cp HELD_AMULET_COIN
	ret nz
	ld a, 1
	ld [wAmuletCoin], a
	ret

BattleCheckPlayerShininess:
	call GetPartyMonDVs
	jpba CheckShininessHL

BattleCheckEnemyShininess:
	call GetEnemyMonDVs
	jpba CheckShininessHL

CheckDanger:
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr z, .no_danger
	ld a, [wBattleLowHealthAlarm]
	and a
	ret nz
	ld a, [wPlayerHPPal]
	cp HP_RED
	jr z, .danger

.no_danger
	ld hl, wLowHealthAlarm
	ld [hl], 0
	ret

.danger
	ld hl, wLowHealthAlarm
	set 7, [hl]
	ret

CheckPlayerLockedIn:
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_RECHARGE, a
	jr nz, .quit

	ld hl, wEnemySubStatus3
	res SUBSTATUS_FLINCHED, [hl]
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_FLINCHED, [hl]
	ld a, [hld]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE
	jr nz, .quit
	ld a, [hld]
	bit SUBSTATUS_GUARDING, a
	jr nz, .quit
	bit SUBSTATUS_ROLLOUT, [hl]
	jr nz, .quit

	and a
	ret

.quit
	scf
	ret

CheckEnemyLockedIn:
	ld a, [wEnemySubStatus4]
	and 1 << SUBSTATUS_RECHARGE
	ret nz

	ld hl, wEnemySubStatus3
	ld a, [hl]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE
	ret nz

	ld hl, wEnemySubStatus1
	bit SUBSTATUS_ROLLOUT, [hl]
	ret

CheckIfCurPartyMonIsStillAlive:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	ret nz

	ld a, [wBattleHasJustStarted]
	and a
	jr nz, .no_text
	ld hl, wPartySpecies
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp EGG
	ld hl, BattleText_AnEGGCantBattle
	jr z, .print_text

	ld hl, BattleText_TheresNoWillToBattle

.print_text
	call StdBattleTextBox

.no_text
	xor a
	ret

CheckEnemyTrainerDefeated:
	ld a, [wOTPartyCount]
	ld b, a
	xor a
	ld hl, wOTPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH

.loop
	or [hl]
	inc hl
	or [hl]
	dec hl
	add hl, de
	dec b
	jr nz, .loop

	and a
	ret

CheckPlayerPartyForFitPkmn:
; Has the player any Pkmn in his Party that can fight?
	ld a, [wPartyCount]
	ld e, a
	xor a
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - (wPartyMon1 + 1)
.loop
	or [hl]
	inc hl
	or [hl]
	add hl, bc
	dec e
	jr nz, .loop
	ld d, a
	ret
