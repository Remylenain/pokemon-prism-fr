BattleCommand_Attract:
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	call GetTargetAbility
	cp ABILITY_OBLIVIOUS
	jr z, .failed
	call CheckOppositeGender
	jr c, .failed
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_IN_LOVE, [hl]
	jr nz, .failed

	set SUBSTATUS_IN_LOVE, [hl]
	call AnimateCurrentMove

; 'fell in love!'
	ld hl, FellInLoveText
	ld a, [wMoveIsAnAbility]
	and a
	jp z, StdBattleTextBox
	ld hl, CuteCharmText
	jp StdBattleTextBox

.failed
	ld a, [wMoveIsAnAbility]
	and a
	ret nz
	jp PrintDidntAffectWithMoveAnimDelay


CheckOppositeGender: ; 377f5
	ld a, MON_SPECIES
	call BattlePartyAttr
	ld a, [hl]
	ld [wCurPartySpecies], a

	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	xor a
	ld [wMonType], a

	callba GetGender
	jr c, .genderless_samegender

	ld b, 1
	jr nz, .got_gender
	dec b

.got_gender
	push bc
	ld a, [wTempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld hl, wEnemyMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .not_transformed
	ld hl, wEnemyBackupDVs
.not_transformed
	ld a, [hli]
	ld [wTempMonDVs], a
	ld a, [hl]
	ld [wTempMonDVs + 1], a
	ld a, 3 ; tempmon
	ld [wMonType], a
	callba GetGender
	pop bc
	jr c, .genderless_samegender

	ld a, 1
	jr nz, .got_enemy_gender
	dec a

.got_enemy_gender
	xor b
	jr z, .genderless_samegender

	and a
	ret

.genderless_samegender
	scf
	ret
