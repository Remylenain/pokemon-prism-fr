GetPartymonItem:
	ld hl, wPartyMon1Item
	ld a, [wCurBattleMon]
	call GetPartyLocation
	ld bc, wBattleMonItem
	ret

GetOTPartymonItem:
	ld hl, wOTPartyMon1Item
	ld a, [wCurOTMon]
	call GetPartyLocation
	ld bc, wEnemyMonItem
	ret

ResetVarsForSubStatusRage:
	xor a
	ld [wEnemyFuryCutterCount], a
	ld [wEnemyProtectCount], a
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]
	ret

GetMoveEffect:
	ld a, b
	dec a
	ld hl, Moves + MOVE_EFFECT
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld b, a
	ret

StopDangerSound:
	xor a
	ld [wLowHealthAlarm], a
	ret

GetPartyMonDVs:
	ld hl, wBattleMonDVs
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	ret z
	ld hl, wPartyMon1DVs
	ld a, [wCurBattleMon]
	jp GetPartyLocation

GetEnemyMonDVs:
	ld hl, wEnemyMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	ret z
	ld hl, wEnemyBackupDVs
	ld a, [wBattleMode]
	dec a
	ret z
	ld hl, wOTPartyMon1DVs
	ld a, [wCurOTMon]
	jp GetPartyLocation

BreakAttraction:
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ret

LinkBattleSendReceiveAction:
	jpba _LinkBattleSendReceiveAction

_LoadHPBar:
	jpba LoadHPBar
