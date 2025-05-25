MACRO trainerclass
	enum \1
const_value = 1
ENDM

MACRO trainer
	; flag, group, id, seen text, win text, lost text, talk-again text
	dw \1
	db \2, \3
	dw \4, \5
	IF _NARG > 5
		dw \6, \7
	ENDC
ENDM
