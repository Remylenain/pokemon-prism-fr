	enum_start
	enum tradeanim_next_command
MACRO tradeanim_next
	db tradeanim_next_command ; 00
ENDM

	enum tradeanim_show_givemon_data_command
MACRO tradeanim_show_givemon_data
	db tradeanim_show_givemon_data_command ; 01
ENDM

	enum tradeanim_show_getmon_data_command
MACRO tradeanim_show_getmon_data
	db tradeanim_show_getmon_data_command ; 02
ENDM

	enum tradeanim_enter_link_tube_command
MACRO tradeanim_enter_link_tube
	db tradeanim_enter_link_tube_command ; 03
ENDM

__enum__ = 5

	enum tradeanim_exit_link_tube_command
MACRO tradeanim_exit_link_tube
	db tradeanim_exit_link_tube_command ; 05
ENDM

	enum tradeanim_tube_to_ot_command
MACRO tradeanim_tube_to_ot
	db tradeanim_tube_to_ot_command ; 06
ENDM

__enum__ = $e

	enum tradeanim_tube_to_player_command
MACRO tradeanim_tube_to_player
	db tradeanim_tube_to_player_command ; 0e
ENDM

__enum__ = $16

	enum tradeanim_sent_to_ot_text_command
MACRO tradeanim_sent_to_ot_text
	db tradeanim_sent_to_ot_text_command ; 16
ENDM

	enum tradeanim_ot_bids_farewell_command
MACRO tradeanim_ot_bids_farewell
	db tradeanim_ot_bids_farewell_command ; 17
ENDM

	enum tradeanim_take_care_of_text_command
MACRO tradeanim_take_care_of_text
	db tradeanim_take_care_of_text_command ; 18
ENDM

	enum tradeanim_ot_sends_text_1_command
MACRO tradeanim_ot_sends_text_1
	db tradeanim_ot_sends_text_1_command ; 19
ENDM

	enum tradeanim_ot_sends_text_2_command
MACRO tradeanim_ot_sends_text_2
	db tradeanim_ot_sends_text_2_command ; 1a
ENDM

	enum tradeanim_setup_givemon_scroll_command
MACRO tradeanim_setup_givemon_scroll
	db tradeanim_setup_givemon_scroll_command ; 1b
ENDM

	enum tradeanim_do_givemon_scroll_command
MACRO tradeanim_do_givemon_scroll
	db tradeanim_do_givemon_scroll_command ; 1c
ENDM

	enum tradeanim_1d_command
MACRO tradeanim_1d
	db tradeanim_1d_command ; 1d
ENDM

	enum tradeanim_1e_command
MACRO tradeanim_1e
	db tradeanim_1e_command ; 1e
ENDM

	enum tradeanim_scroll_out_right_command
MACRO tradeanim_scroll_out_right
	db tradeanim_scroll_out_right_command ; 1f
ENDM

__enum__ = $21

	enum tradeanim_wait_80_command
MACRO tradeanim_wait_80
	db tradeanim_wait_80_command ; 21
ENDM

	enum tradeanim_wait_40_command
MACRO tradeanim_wait_40
	db tradeanim_wait_40_command ; 22
ENDM

	enum tradeanim_rocking_ball_command
MACRO tradeanim_rocking_ball
	db tradeanim_rocking_ball_command ; 23
ENDM

	enum tradeanim_drop_ball_command
MACRO tradeanim_drop_ball
	db tradeanim_drop_ball_command ; 24
ENDM

	enum tradeanim_wait_anim_command
MACRO tradeanim_wait_anim
	db tradeanim_wait_anim_command ; 25
ENDM

__enum__ = $27

	enum tradeanim_poof_command
MACRO tradeanim_poof
	db tradeanim_poof_command ; 27
ENDM

	enum tradeanim_bulge_through_tube_command
MACRO tradeanim_bulge_through_tube
	db tradeanim_bulge_through_tube_command ; 28
ENDM

	enum tradeanim_give_trademon_sfx_command
MACRO tradeanim_give_trademon_sfx
	db tradeanim_give_trademon_sfx_command ; 29
ENDM

	enum tradeanim_get_trademon_sfx_command
MACRO tradeanim_get_trademon_sfx
	db tradeanim_get_trademon_sfx_command ; 2a
ENDM

	enum tradeanim_end_command
MACRO tradeanim_end
	db tradeanim_end_command ; 2b
ENDM

	enum tradeanim_animate_frontpic_command
MACRO tradeanim_animate_frontpic
	db tradeanim_animate_frontpic_command ; 2c
ENDM

	enum tradeanim_wait_96_command
MACRO tradeanim_wait_96
	db tradeanim_wait_96_command ; 2d
ENDM

	enum tradeanim_wait_80_if_ot_egg_command
MACRO tradeanim_wait_80_if_ot_egg
	db tradeanim_wait_80_if_ot_egg_command ; 2e
ENDM

	enum tradeanim_wait_180_if_ot_egg_command
MACRO tradeanim_wait_180_if_ot_egg
	db tradeanim_wait_180_if_ot_egg_command ; 2f
ENDM
