MACRO anim_wait
	assert (\1) < $d0, "Move animation delay exceeds 207 frames"
	db \1
	ENDM

	enum_start $d0

	enum anim_obj_command ; d0
MACRO anim_obj
	db anim_obj_command
	db \1 ; obj
	db (((\2) & $1f) << 3) + (\3) ; x
	db (((\4) & $1f) << 3) + (\5) ; y
	db \6 ; param
ENDM

	enum anim_1gfx_command ; d1
MACRO anim_1gfx
	db anim_1gfx_command
	db \1 ; gfx1
ENDM

	enum anim_2gfx_command ; d2
MACRO anim_2gfx
	db anim_2gfx_command
	db \1 ; gfx1
	db \2 ; gfx2
ENDM

	enum anim_3gfx_command ; d3
MACRO anim_3gfx
	db anim_3gfx_command
	db \1 ; gfx1
	db \2 ; gfx2
	db \3 ; gfx3
ENDM

	enum anim_4gfx_command ; d4
MACRO anim_4gfx
	db anim_4gfx_command
	db \1 ; gfx1
	db \2 ; gfx2
	db \3 ; gfx3
	db \4 ; gfx4
ENDM

	enum anim_5gfx_command ; d5
MACRO anim_5gfx
	db anim_5gfx_command
	db \1 ; gfx1
	db \2 ; gfx2
	db \3 ; gfx3
	db \4 ; gfx4
	db \5 ; gfx5
ENDM

	enum anim_incobj_command ; d6
MACRO anim_incobj
	db anim_incobj_command
	db \1 ; id
ENDM

	enum anim_setobj_command ; d7
MACRO anim_setobj
	db anim_setobj_command
	db \1 ; id
	db \2 ; obj
ENDM

	enum anim_incbgeffect_command ; d8
MACRO anim_incbgeffect
	db anim_incbgeffect_command
	db \1 ; effect
ENDM

	enum anim_enemyfeetobj_command ; d9
MACRO anim_enemyfeetobj
	db anim_enemyfeetobj_command
ENDM

	enum anim_playerheadobj_command ; da
MACRO anim_playerheadobj
	db anim_playerheadobj_command
ENDM

	enum anim_checkpokeball_command ; db
MACRO anim_checkpokeball
	db anim_checkpokeball_command
ENDM

	enum anim_transform_command ; dc
MACRO anim_transform
	db anim_transform_command
ENDM

	enum anim_raisesub_command ; dd
MACRO anim_raisesub
	db anim_raisesub_command
ENDM

	enum anim_dropsub_command ; de
MACRO anim_dropsub
	db anim_dropsub_command
ENDM

	enum anim_resetobp0_command ; df
MACRO anim_resetobp0
	db anim_resetobp0_command
ENDM

	enum anim_sound_command ; e0
MACRO anim_sound
	db anim_sound_command
	db (\1 << 2) | \2 ; duration, tracks
	db \3 ; id
ENDM

	enum anim_cry_command ; e1
MACRO anim_cry
	db anim_cry_command
	db \1 ; pitch
ENDM

	enum anim_minimizeopp_command ; e2
MACRO anim_minimizeopp
	db anim_minimizeopp_command
ENDM

	enum anim_oamon_command ; e3
MACRO anim_oamon
	db anim_oamon_command
ENDM

	enum anim_oamoff_command ; e4
MACRO anim_oamoff
	db anim_oamoff_command
ENDM

	enum anim_clearobjs_command ; e5
MACRO anim_clearobjs
	db anim_clearobjs_command
ENDM

	enum skip ;e6

	enum anim_insobj_command ; e7
MACRO anim_insobj
	db anim_insobj_command
	db \1
	db \2 ; obj
	db (\3 << 3) + \4 ; x
	db (\5 << 3) + \6 ; y
	db \7 ; param
ENDM

	enum anim_updateactorpic_command ; e8
MACRO anim_updateactorpic
	db anim_updateactorpic_command
ENDM

	enum anim_minimize_command ; e9
MACRO anim_minimize
	db anim_minimize_command
ENDM

	enum anim_jumpifpmode_command ; ea
MACRO anim_jumpifpmode
	db anim_jumpifpmode_command
	dw \1 ; address
ENDM

	enum anim_checkcriticalcapture_command ; eb
MACRO anim_checkcriticalcapture
	db anim_checkcriticalcapture_command
ENDM

	enum anim_shakedelay_command ; ec
MACRO anim_shakedelay
	db anim_shakedelay_command
ENDM

	enum skip ; ed

	enum anim_jumpand_command ; ee
MACRO anim_jumpand
	db anim_jumpand_command
	db \1 ; value
	dw \2 ; address
ENDM

	enum anim_jumpuntil_command ; ef
MACRO anim_jumpuntil
	db anim_jumpuntil_command
	dw \1 ; address
ENDM

	enum anim_bgeffect_command ; f0
MACRO anim_bgeffect
	db anim_bgeffect_command
	db \1 ; effect
	db \2 ; unknown
	db \3 ; unknown
	db \4 ; unknown
ENDM

	enum anim_bgp_command ; f1
MACRO anim_bgp
	db anim_bgp_command
	if _NARG > 1
		db ((\1) << 6) | ((\2) << 4) | ((\3) << 2) | ((\4) << 0)
	else
		db \1 ; colors
	endc
ENDM

	enum anim_obp0_command ; f2
MACRO anim_obp0
	db anim_obp0_command
	if _NARG > 1
		db ((\1) << 6) | ((\2) << 4) | ((\3) << 2) | ((\4) << 0)
	else
		db \1 ; colors
	endc
ENDM

	enum anim_obp1_command ; f3
MACRO anim_obp1
	db anim_obp1_command
	if _NARG > 1
		db ((\1) << 6) | ((\2) << 4) | ((\3) << 2) | ((\4) << 0)
	else
		db \1 ; colors
	endc
ENDM

	enum anim_clearsprites_command ; f4
MACRO anim_clearsprites
	db anim_clearsprites_command
ENDM

	enum anim_darkenball_command ; f5
MACRO anim_darkenball
	db anim_darkenball_command
ENDM

	enum skip ; f6

	enum anim_clearfirstbgeffect_command ; f7
MACRO anim_clearfirstbgeffect
	db anim_clearfirstbgeffect_command
ENDM

	enum anim_jumpif_command ; f8
MACRO anim_jumpif
	db anim_jumpif_command
	db \1 ; value
	dw \2 ; address
ENDM

	enum anim_setvar_command ; f9
MACRO anim_setvar
	db anim_setvar_command
	db \1 ; value
ENDM

	enum anim_incvar_command ; fa
MACRO anim_incvar
	db anim_incvar_command
ENDM

	enum anim_jumpvar_command ; fb
MACRO anim_jumpvar
	db anim_jumpvar_command
	db \1 ; value
	dw \2 ; address
ENDM

	enum anim_jump_command ; fc
MACRO anim_jump
	db anim_jump_command
	dw \1 ; address
ENDM

	enum anim_loop_command ; fd
MACRO anim_loop
	db anim_loop_command
	db \1 ; count
	dw \2 ; address
ENDM

	enum anim_call_command ; fe
MACRO anim_call
	db anim_call_command
	dw \1 ; address
ENDM

	enum anim_ret_command ; ff
MACRO anim_ret
	db anim_ret_command
ENDM
