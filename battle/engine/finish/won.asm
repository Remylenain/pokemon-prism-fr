WinTrainerBattle:
; Player won the battle
	call StopDangerSound
	ld a, 1
	ld [wBattleLowHealthAlarm], a
	ld [wBattleEnded], a
	ld a, [wLinkMode]
	and a
	ld a, b
	call z, PlayVictoryMusic
	callba Battle_GetTrainerName
	ld hl, BattleText_EnemyWasDefeated
	call StdBattleTextBox

	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wInBattleTowerBattle]
	rra
	jr c, .battle_tower

	call BattleWinSlideInEnemyTrainerFrontpic
	ld c, 40
	call DelayFrames
	ld a, [wBattleType]
	cp BATTLETYPE_CANLOSE
	jr nz, .skip_heal
	ld a, [wInBattleTowerBattle]
	bit 2, a
	jr nz, .skip_heal
	predef HealParty
.skip_heal
	ld a, [wMonStatusFlags]
	rra
	call nc, PrintWinLossText
	ld a, [wInBattleTowerBattle]
	bit 2, a
	ret nz
	callba CheckPickup
	jr .give_money

.battle_tower
	call BattleWinSlideInEnemyTrainerFrontpic
	ld c, 40
	call DelayFrames
	call EmptyBattleTextBox
	ld c, 3
	callba BattleTowerText
	call WaitPressAorB_BlinkCursor
	call ClearTileMap
	jp ClearBGPalettes

.give_money
	CheckEngine ENGINE_POKEMON_MODE
	ret nz
	CheckEngine ENGINE_HYPER_SHARE_ENABLED
	ret nz
	ld a, [wAmuletCoin]
	and a
	call nz, .double_reward
	call .check_bank_money_maxed_out
	push af
	ld a, 0
	jr nc, .got_bank_fraction
	ld a, [wBankSavingMoney]
	and 7
	cp 3
	jr nz, .got_bank_fraction
	inc a

.got_bank_fraction
	ld b, a
	ld c, 4
.bank_sending_loop
	ld a, b
	and a
	jr z, .wallet_increasing_loop
	call .send_money_to_bank
	dec c
	dec b
	jr .bank_sending_loop

.wallet_increasing_loop
	ld a, c
	and a
	jr z, .done
	call .add_money_to_wallet
	dec c
	jr .wallet_increasing_loop

.done
	call .double_reward
	call .double_reward
	pop af
	jr nc, .print_kept_all_money_text
	ld a, [wBankSavingMoney]
	and 7
	jr z, .print_kept_all_money_text
	ld hl, .sent_money_to_bank_texts
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .battle_text_box

.print_kept_all_money_text
	ld hl, GotMoneyForWinningText
.battle_text_box
	jp StdBattleTextBox

.send_money_to_bank
	ld de, wBankMoney + 2
	jr .add_money_to_account

.add_money_to_wallet
	ld de, wMoney + 2
.add_money_to_account
	push bc
	ld hl, wBattleReward + 2
	call AddBattleMoneyToAccount
	pop bc
	ret

.double_reward
	ld hl, wBattleReward + 2
	sla [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	ret nc
	sbc a ; since carry is set, sbc a sets a to $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.sent_money_to_bank_texts
	dw SentSomeToBankText
	dw SentHalfToBankText
	dw SentAllToBankText

.check_bank_money_maxed_out
	ld hl, wBankMoney + 2
	ld a, [hld]
	cp MAX_MONEY % $100
	ld a, [hld]
	sbc MAX_MONEY / $100 % $100
	ld a, [hl]
	sbc MAX_MONEY / $10000 % $100
	ret

AddBattleMoneyToAccount:
	ld c, 3
	and a
	push de
	push hl
	push bc
	ld b, h
	ld c, l
	pop bc
	pop hl
.bank_sending_loop
	ld a, [de]
	adc [hl]
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, .bank_sending_loop
	pop hl
	ld a, [hld]
	cp MAX_MONEY % $100
	ld a, [hld]
	sbc MAX_MONEY / $100 % $100
	ld a, [hl]
	sbc MAX_MONEY / $10000 % $100
	ret c
	ld [hl], MAX_MONEY / $10000 % $100
	inc hl
	ld [hl], MAX_MONEY / $100 % $100
	inc hl
	ld [hl], MAX_MONEY % $100
	ret
