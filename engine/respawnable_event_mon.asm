DoRespawnableEventMonFlagActionFromScript::
	ldh a, [hScriptVar]
	ld c, a
	ld b, CHECK_FLAG
	call DoRespawnableEventMonFlagAction
	ld a, 0
	ret z
	inc a
	ret

DoRespawnableEventMonFlagAction:
	ld a, b
	ld b, 0
	dec c
	ld hl, RespawnableEventMonFlags
	add hl, bc
	add hl, bc
	ld b, a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	predef_jump EventFlagAction

RespawnableEventMonFlags:
	dw EVENT_CAUGHT_PHANCERO
	dw EVENT_CAUGHT_ARTICUNO
	dw EVENT_CAUGHT_ZAPDOS
	dw EVENT_CAUGHT_MOLTRES
	dw EVENT_CAUGHT_FAMBACO
	dw EVENT_CAUGHT_LIBABEEL
	dw EVENT_CAUGHT_RAIWATO
	dw EVENT_CAUGHT_VARANEOUS
	dw EVENT_CAUGHT_MEW
