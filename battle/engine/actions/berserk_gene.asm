HandleBerserkGene:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .reverse

	call .player
	jr .enemy

.reverse
	call .enemy
.player
	call SetPlayerTurn
	ld de, wPartyMon1Item
	ld a, [wCurBattleMon]
	ld b, a
	jr .go

.enemy
	call SetEnemyTurn
	ld de, wOTPartyMon1Item
	ld a, [wCurOTMon]
	ld b, a
.go
	push de
	push bc
	call GetUserItem
	ld a, [hl]
	ld [wd265], a
	sub BERSERK_GENE
	pop bc
	pop de
	ret nz

	ld [hl], a

	ld h, d
	ld l, e
	ld a, b
	call GetPartyLocation
	xor a
	ld [hl], a
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	push af
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_OWN_TEMPO
	jr z, .protected
	set SUBSTATUS_CONFUSED, [hl]
.protected
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	push hl
	push af
	xor a
	ld [hl], a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	callba BattleCommand_AttackUp2
	pop af
	pop hl
	ld [hl], a
	call GetItemName
	ld hl, BattleText_UsersStringBuffer1Activated
	call StdBattleTextBox
	callba BattleCommand_StatUpMessage
	pop af
	bit SUBSTATUS_CONFUSED, a
	ret nz
	call GetUserAbility_IgnoreMoldBreaker
	cp ABILITY_OWN_TEMPO
	ret z
	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn
	ld hl, BecameConfusedText
	jp StdBattleTextBox
