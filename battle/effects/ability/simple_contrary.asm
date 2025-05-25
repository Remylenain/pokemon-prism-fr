ContraryCheckUser:
	call GetUserAbility_IgnoreMoldBreaker
	jr ContraryCheck

ContraryCheckOpp:
	call GetTargetAbility
	; fallthrough
ContraryCheck:
	cp ABILITY_CONTRARY
	jr ContraryCheckDone

ApplySimpleAndContrary:
	call GetUserAbility_IgnoreMoldBreaker
	jr SimpleAndContraryCheck

ApplySimpleAndContraryOpp:
	call GetTargetAbility
	; fallthrough
SimpleAndContraryCheck:
	cp ABILITY_SIMPLE
	jr nz, .not_simple

	; double stat boost/reduction
	bit 4, b
	set 4, b
	jr z, .not_simple
	set 5, b

.not_simple
	cp ABILITY_CONTRARY
	ld a, b
	ld [wLoweredStat], a
	; fallthrough

ContraryCheckDone:
	jp nz, _hl_
	call SwitchTurn
	call _de_
	jp SwitchTurn
