BattleCommand_Recoil:
	ld hl, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonMaxHP
.got_hp
	ld a, [hli]
	ld b, a
	ld a, [hld]
	ld c, a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp STRUGGLE
	jr z, .Struggle
	call GetUserAbility
	cp ABILITY_ROCK_HEAD
	ret z
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp DOUBLE_EDGE
	jr z, .ThirdRecoil
	cp FLARE_BLITZ
	jr z, .ThirdRecoil
	cp BRAVE_BIRD
	jr z, .ThirdRecoil
	call GetCurrentDamage
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
; get 1/4 damage or 1 HP, whichever is greater
	srl b
	rr c
	srl b
	rr c
	ld a, b
.check_min_damage
	or c
	jr nz, .min_damage
	inc c
.min_damage
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP], a
	dec hl
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	sub c
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .dont_ko
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wCurHPAnimNewHP
	ld [hli], a
	ld [hl], a
.dont_ko
	hlcoord 9, 9
	ldh a, [hBattleTurn]
	and a
	ld a, 1
	jr z, .animate_hp_bar
	hlcoord 0, 2
	xor a
.animate_hp_bar
	ld [wWhichHPBar], a
	predef AnimateHPBar
	call RefreshBattleHuds
	ld hl, RecoilText
	jp StdBattleTextBox

.Struggle
	callba GetQuarterMaxHP
	callba SubtractHPFromUser
	call UpdateUserInParty
	ld hl, RecoilText
	jp StdBattleTextBox

.ThirdRecoil ;1/3 of HP instead of 1/4
	call GetCurrentDamage
	ld a, [wCurDamage]
	ldh [hDividend], a
	ld a, [wCurDamage + 1]
	ldh [hDividend + 1], a
	ld a, 3
	ldh [hDivisor], a
	ld b, 2
	predef Divide
	ldh a, [hQuotient + 2]
	ld c, a
	ldh a, [hQuotient + 1]
	ld b, a
	jr .check_min_damage
