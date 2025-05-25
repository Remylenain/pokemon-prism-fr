HyperCutterCheck:
	call GetTargetAbility
	cp ABILITY_HYPER_CUTTER
	ret

KeenEyeCheck:
	call GetTargetAbility
	cp ABILITY_KEEN_EYE
	ret

WhiteSmokeCheck:
	call GetTargetAbility
	cp ABILITY_WHITE_SMOKE
	ret z
	cp ABILITY_CLEAR_BODY
	ret
