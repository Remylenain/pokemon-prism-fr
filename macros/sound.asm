MACRO note
	dn (\1), (\2) - 1
	ENDM

MACRO sound
	note \1, \2
	db \3 ; intensity
	dw \4 ; frequency
	ENDM

MACRO noise
	note \1, \2 ; duration
	db \3 ; intensity
	db \4 ; frequency
	ENDM

MACRO channelcount
nchannels = \1 - 1
ENDM

MACRO channel
	dn (nchannels << 2), \1 - 1
	dw \2
nchannels = 0
	ENDM

MACRO cry_header
IF _NARG == 3
	db \1
	dw \2, \3
ELSE
	db $ff
	dba \2 ; bank/address
	db \1 - 1 ; species (padding)
ENDC
	ENDM

	enum_start $d8
	enum notetype_cmd
MACRO octave
	db notetype_cmd - (\1)
	ENDM

MACRO notetype
	db notetype_cmd
	db \1 ; note_length
	if _NARG >= 2
	db \2 ; intensity
	endc
	ENDM

	enum forceoctave_cmd
MACRO forceoctave
	db forceoctave_cmd
	db \1 ; octave
	ENDM

	enum tempo_cmd
MACRO tempo
	db tempo_cmd
	bigdw \1 ; tempo
	ENDM

	enum dutycycle_cmd
MACRO dutycycle
	db dutycycle_cmd
	db \1 ; duty_cycle
	ENDM

	enum intensity_cmd
MACRO intensity
	db intensity_cmd
	db \1 ; intensity
	ENDM

	enum soundinput_cmd
MACRO soundinput
	db soundinput_cmd
	db \1 ; input
	ENDM

	enum sound_duty_cmd
MACRO sound_duty
	db sound_duty_cmd
	db \1 | (\2 << 2) | (\3 << 4) | (\4 << 6) ; duty sequence
	ENDM

	enum togglesfx_cmd
MACRO togglesfx
	db togglesfx_cmd
	ENDM

	enum slidepitchto_cmd
MACRO slidepitchto
	db slidepitchto_cmd
	db \1 - 1 ; duration
	dn \2, \3 - 1 ; octave, pitch
	ENDM

	enum vibrato_cmd
MACRO vibrato
	db vibrato_cmd
	db \1 ; delay
	db \2 ; extent
	ENDM

	enum skip

	enum togglenoise_cmd
MACRO togglenoise
	db togglenoise_cmd
	if _NARG > 0
		db \1 ; id
	else
		db -1
	endc
	ENDM

	enum panning_cmd
MACRO panning
	db panning_cmd
	db \1 ; tracks
	ENDM

	enum volume_cmd
MACRO volume
	db volume_cmd
	db \1 ; volume
	ENDM

	enum tone_cmd
MACRO tone
	db tone_cmd
	bigdw \1 ; tone
	ENDM

	enum inc_octave_cmd
MACRO inc_octave
	db inc_octave_cmd
	ENDM

	enum dec_octave_cmd
MACRO dec_octave
	db dec_octave_cmd
	ENDM

	enum tempo_relative_cmd
MACRO tempo_relative
	db tempo_relative_cmd
	bigdw \1 ; value
	ENDM

	enum restartchannel_cmd
MACRO restartchannel
	db restartchannel_cmd
	dw \1 ; address
	ENDM

	enum newsong_cmd
MACRO newsong
	db newsong_cmd
	bigdw \1 ; id
	ENDM

	enum sfxpriorityon_cmd
MACRO sfxpriorityon
	db sfxpriorityon_cmd
	ENDM

	enum sfxpriorityoff_cmd
MACRO sfxpriorityoff
	db sfxpriorityoff_cmd
	ENDM

	enum skip

	enum stereopanning_cmd
MACRO stereopanning
	db stereopanning_cmd
	db \1 ; tracks
	ENDM

	enum sfxtogglenoise_cmd
MACRO sfxtogglenoise
	db sfxtogglenoise_cmd
	db \1 ; id
	ENDM

	enum customwave_cmd
MACRO customwave
	db customwave_cmd
	dw \1
	ENDM

	enum arp_cmd
MACRO arp
	db arp_cmd
	dn \1, \2
	ENDM

	enum portaup_cmd
MACRO portaup
	db portaup_cmd
	db \1
	ENDM

	enum portadown_cmd
MACRO portadown
	db portadown_cmd
	db \1
	ENDM

	enum toneporta_cmd
MACRO toneporta
	db toneporta_cmd
	db \1
	ENDM

	enum notetype0_cmd
MACRO notetype0
	db notetype0_cmd
	db \1
	ENDM

	enum notetype1_cmd
MACRO notetype1
	db notetype1_cmd
	db \1
	ENDM

	enum notetype2_cmd
MACRO notetype2
	db notetype2_cmd
	db \1
	ENDM

	enum noisesampleset_cmd
MACRO noisesampleset
	db noisesampleset_cmd
	db \1 ; noise
	ENDM

	enum setcondition_cmd
MACRO setcondition
	db setcondition_cmd
	db \1 ; condition
	ENDM

	enum jumpif_cmd
MACRO jumpif
	db jumpif_cmd
	db \1 ; condition
	dw \2 ; address
	ENDM

	enum jumpchannel_cmd
MACRO jumpchannel
	db jumpchannel_cmd
	dw \1 ; address
	ENDM

	enum loopchannel_cmd
MACRO loopchannel
	assert (\1) > 0, "'loopchannel 0, \2' is not valid; use 'jumpchannel \2' instead"
	db loopchannel_cmd
	db (\1) - 1 ; count
	dw \2 ; address
	ENDM

	enum callchannel_cmd
MACRO callchannel
	db callchannel_cmd
	dw \1 ; address
	ENDM

	enum endchannel_cmd
MACRO endchannel
	db endchannel_cmd
	ENDM
