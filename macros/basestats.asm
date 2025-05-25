MACRO define_s
if !def(\1)
\1 equs \2
endc
ENDM

const_value = 0

MACRO add_tm
if !def(TM01)
TM01 = const_value
	enum_start 1
endc
	define_s _\@_1, "TM_\1"
	const _\@_1
	enum \1_TMNUM
ENDM

MACRO add_hm
if !def(HM01)
HM01 = const_value
endc
	define_s _\@_1, "HM_\1"
	const _\@_1
	enum \1_TMNUM
ENDM

MACRO add_mt
	enum \1_TMNUM
ENDM

MACRO tmhm
x = 0
y = 0
w = 0
v = 0
u = 0
	rept _NARG
	if def(\1_TMNUM)
		if \1_TMNUM < 25
x = x | (1 << ((\1_TMNUM) - 1))
		elif \1_TMNUM < 49
y = y | (1 << ((\1_TMNUM) - 1 - 24))
		elif \1_TMNUM < 73
w = w | (1 << ((\1_TMNUM) - 1 - 48))
		elif \1_TMNUM < 97
v = v | (1 << ((\1_TMNUM) - 1 - 72))
		else
u = u | (1 << ((\1_TMNUM) - 1 - 96))
		endc
	else
		fail "\1 is not a TM, HM, or move tutor move"
	endc

	shift
	endr

	rept 3
	db x & $ff
x = x >> 8
	endr
	rept 3
	db y & $ff
y = y >> 8
	endr
	rept 3
	db w & $ff
w = w >> 8
	endr
	rept 3
	db v & $ff
v = v >> 8
	endr
	db u & $ff
u = u >> 8
ENDM
