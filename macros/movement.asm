	enum_start

	enum movement_turn_head_down
MACRO turn_head_down
	db movement_turn_head_down ; $00
	ENDM

	enum movement_turn_head_up
MACRO turn_head_up
	db movement_turn_head_up ; $01
	ENDM

	enum movement_turn_head_left
MACRO turn_head_left
	db movement_turn_head_left ; $02
	ENDM

	enum movement_turn_head_right
MACRO turn_head_right
	db movement_turn_head_right ; $03
	ENDM

	enum movement_turn_step_down
MACRO turn_step_down
	db movement_turn_step_down ; $04
	ENDM

	enum movement_turn_step_up
MACRO turn_step_up
	db movement_turn_step_up ; $05
	ENDM

	enum movement_turn_step_left
MACRO turn_step_left
	db movement_turn_step_left ; $06
	ENDM

	enum movement_turn_step_right
MACRO turn_step_right
	db movement_turn_step_right ; $07
	ENDM

	enum movement_slow_step_down
MACRO slow_step_down
	db movement_slow_step_down ; $08
	ENDM

	enum movement_slow_step_up
MACRO slow_step_up
	db movement_slow_step_up ; $09
	ENDM

	enum movement_slow_step_left
MACRO slow_step_left
	db movement_slow_step_left ; $0a
	ENDM

	enum movement_slow_step_right
MACRO slow_step_right
	db movement_slow_step_right ; $0b
	ENDM

	enum movement_step_down
MACRO step_down
	db movement_step_down ; $0c
	ENDM

	enum movement_step_up
MACRO step_up
	db movement_step_up ; $0d
	ENDM

	enum movement_step_left
MACRO step_left
	db movement_step_left ; $0e
	ENDM

	enum movement_step_right
MACRO step_right
	db movement_step_right ; $0f
	ENDM

	enum movement_big_step_down
MACRO big_step_down
	db movement_big_step_down ; $10
	ENDM

	enum movement_big_step_up
MACRO big_step_up
	db movement_big_step_up ; $11
	ENDM

	enum movement_big_step_left
MACRO big_step_left
	db movement_big_step_left ; $12
	ENDM

	enum movement_big_step_right
MACRO big_step_right
	db movement_big_step_right ; $13
	ENDM

	enum movement_slow_slide_step_down
MACRO slow_slide_step_down
	db movement_slow_slide_step_down ; $14
	ENDM

	enum movement_slow_slide_step_up
MACRO slow_slide_step_up
	db movement_slow_slide_step_up ; $15
	ENDM

	enum movement_slow_slide_step_left
MACRO slow_slide_step_left
	db movement_slow_slide_step_left ; $16
	ENDM

	enum movement_slow_slide_step_right
MACRO slow_slide_step_right
	db movement_slow_slide_step_right ; $17
	ENDM

	enum movement_slide_step_down
MACRO slide_step_down
	db movement_slide_step_down ; $18
	ENDM

	enum movement_slide_step_up
MACRO slide_step_up
	db movement_slide_step_up ; $19
	ENDM

	enum movement_slide_step_left
MACRO slide_step_left
	db movement_slide_step_left ; $1a
	ENDM

	enum movement_slide_step_right
MACRO slide_step_right
	db movement_slide_step_right ; $1b
	ENDM

	enum movement_fast_slide_step_down
MACRO fast_slide_step_down
	db movement_fast_slide_step_down ; $1c
	ENDM

	enum movement_fast_slide_step_up
MACRO fast_slide_step_up
	db movement_fast_slide_step_up ; $1d
	ENDM

	enum movement_fast_slide_step_left
MACRO fast_slide_step_left
	db movement_fast_slide_step_left ; $1e
	ENDM

	enum movement_fast_slide_step_right
MACRO fast_slide_step_right
	db movement_fast_slide_step_right ; $1f
	ENDM

	enum movement_turn_away_down
MACRO turn_away_down
	db movement_turn_away_down ; $20
	ENDM

	enum movement_turn_away_up
MACRO turn_away_up
	db movement_turn_away_up ; $21
	ENDM

	enum movement_turn_away_left
MACRO turn_away_left
	db movement_turn_away_left ; $22
	ENDM

	enum movement_turn_away_right
MACRO turn_away_right
	db movement_turn_away_right ; $23
	ENDM

	enum movement_turn_in_down
MACRO turn_in_down
	db movement_turn_in_down ; $24
	ENDM

	enum movement_turn_in_up
MACRO turn_in_up
	db movement_turn_in_up ; $25
	ENDM

	enum movement_turn_in_left
MACRO turn_in_left
	db movement_turn_in_left ; $26
	ENDM

	enum movement_turn_in_right
MACRO turn_in_right
	db movement_turn_in_right ; $27
	ENDM

	enum movement_turn_waterfall_down
MACRO turn_waterfall_down
	db movement_turn_waterfall_down ; $28
	ENDM

	enum movement_turn_waterfall_up
MACRO turn_waterfall_up
	db movement_turn_waterfall_up ; $29
	ENDM

	enum movement_turn_waterfall_left
MACRO turn_waterfall_left
	db movement_turn_waterfall_left ; $2a
	ENDM

	enum movement_turn_waterfall_right
MACRO turn_waterfall_right
	db movement_turn_waterfall_right ; $2b
	ENDM

	enum movement_slow_jump_step_down
MACRO slow_jump_step_down
	db movement_slow_jump_step_down ; $2c
	ENDM

	enum movement_slow_jump_step_up
MACRO slow_jump_step_up
	db movement_slow_jump_step_up ; $2d
	ENDM

	enum movement_slow_jump_step_left
MACRO slow_jump_step_left
	db movement_slow_jump_step_left ; $2e
	ENDM

	enum movement_slow_jump_step_right
MACRO slow_jump_step_right
	db movement_slow_jump_step_right ; $2f
	ENDM

	enum movement_jump_step_down
MACRO jump_step_down
	db movement_jump_step_down ; $30
	ENDM

	enum movement_jump_step_up
MACRO jump_step_up
	db movement_jump_step_up ; $31
	ENDM

	enum movement_jump_step_left
MACRO jump_step_left
	db movement_jump_step_left ; $32
	ENDM

	enum movement_jump_step_right
MACRO jump_step_right
	db movement_jump_step_right ; $33
	ENDM

	enum movement_fast_jump_step_down
MACRO fast_jump_step_down
	db movement_fast_jump_step_down ; $34
	ENDM

	enum movement_fast_jump_step_up
MACRO fast_jump_step_up
	db movement_fast_jump_step_up ; $35
	ENDM

	enum movement_fast_jump_step_left
MACRO fast_jump_step_left
	db movement_fast_jump_step_left ; $36
	ENDM

	enum movement_fast_jump_step_right
MACRO fast_jump_step_right
	db movement_fast_jump_step_right ; $37
	ENDM

	enum movement_stop_sliding
MACRO stop_sliding
	db movement_stop_sliding ; $38
	ENDM

	enum movement_start_sliding
MACRO start_sliding
	db movement_start_sliding ; $39
	ENDM

	enum movement_remove_fixed_facing
MACRO remove_fixed_facing
	db movement_remove_fixed_facing ; $3a
	ENDM

	enum movement_fix_facing
MACRO fix_facing
	db movement_fix_facing ; $3b
	ENDM

	enum movement_show_person
MACRO show_person
	db movement_show_person ; $3c
	ENDM

	enum movement_hide_person
MACRO hide_person
	db movement_hide_person ; $3d
	ENDM

	enum movement_step_sleep_1
MACRO step_sleep_1
	db movement_step_sleep_1 ; $3e
	ENDM

	enum movement_step_sleep_2
MACRO step_sleep_2
	db movement_step_sleep_2 ; $3f
	ENDM

	enum movement_step_sleep_3
MACRO step_sleep_3
	db movement_step_sleep_3 ; $40
	ENDM

	enum movement_step_sleep_4
MACRO step_sleep_4
	db movement_step_sleep_4 ; $41
	ENDM

	enum movement_step_sleep_5
MACRO step_sleep_5
	db movement_step_sleep_5 ; $42
	ENDM

	enum movement_step_sleep_6
MACRO step_sleep_6
	db movement_step_sleep_6 ; $43
	ENDM

	enum movement_step_sleep_7
MACRO step_sleep_7
	db movement_step_sleep_7 ; $44
	ENDM

	enum movement_step_sleep_8
MACRO step_sleep_8
	db movement_step_sleep_8 ; $45
	ENDM

	enum movement_step_sleep
MACRO step_sleep
	db movement_step_sleep ; $46
	db \1 ; duration
	ENDM

	enum movement_step_end
MACRO step_end
	db movement_step_end ; $47
	ENDM

	enum skip

	enum movement_remove_person
MACRO remove_person
	db movement_remove_person ; $49
	ENDM

	enum movement_step_loop
MACRO step_loop
	db movement_step_loop ; $4a
	ENDM

	enum movement_step_stop
MACRO step_stop
	db movement_step_wait ; $4b
	ENDM

	enum movement_teleport_from
MACRO teleport_from
	db movement_teleport_from ; $4c
	ENDM

	enum movement_teleport_to
MACRO teleport_to
	db movement_teleport_to ; $4d
	ENDM

	enum movement_skyfall
MACRO skyfall
	db movement_skyfall ; $4e
	ENDM

	enum movement_step_dig
MACRO step_dig
	db movement_step_dig ; $4f
	db \1
	ENDM

	enum movement_step_bump
MACRO step_bump
	db movement_step_bump ; $50
	ENDM

	enum movement_fish_got_bite
MACRO fish_got_bite
	db movement_fish_got_bite ; $51
	ENDM

	enum movement_fish_cast_rod
MACRO fish_cast_rod
	db movement_fish_cast_rod ; $52
	ENDM

	enum movement_hide_emote
MACRO hide_emote
	db movement_hide_emote ; $53
	ENDM

	enum movement_show_emote
MACRO show_emote
	db movement_show_emote ; $54
	ENDM

	enum movement_step_shake
MACRO step_shake
	db movement_step_shake ; $55
	db \1 ; displacement
	ENDM

	enum movement_tree_shake
MACRO tree_shake
	db movement_tree_shake ; $56
	ENDM

	enum movement_rock_smash
MACRO rock_smash
	db movement_rock_smash ; $57
	db \1
	ENDM

	enum movement_return_dig
MACRO return_dig
	db movement_return_dig ; $58
	db \1
	ENDM

	enum movement_skyfall_top
MACRO skyfall_top
	db movement_skyfall_top ; $59
	ENDM

	enum movement_run_step_down
MACRO run_step_down
	db movement_run_step_down ; $5a
	ENDM

	enum movement_run_step_up
MACRO run_step_up
	db movement_run_step_up ; $5b
	ENDM

	enum movement_run_step_left
MACRO run_step_left
	db movement_run_step_left ; $5c
	ENDM

	enum movement_run_step_right
MACRO run_step_right
	db movement_run_step_right ; $5d
	ENDM

	enum movement_field_move
MACRO field_move
	db movement_field_move ; $5e
	ENDM
