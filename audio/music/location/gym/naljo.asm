Music_NaljoGym:
	channelcount 4
	channel 1, Music_NaljoGym_Ch1
	channel 2, Music_NaljoGym_Ch2
	channel 3, Music_NaljoGym_Ch3
	channel 4, Music_NaljoGym_Ch4

Music_NaljoGym_Ch1:
	tempo 140
	dutycycle $1
	notetype $c, $c7
	octave 4
	note C_, 6
	octave 3
	note G_, 1
	octave 4
	note C_, 1
	octave 3
	note A#, 6
	note F_, 1
	note A#, 1
	note A_, 4
	octave 2
	note A_, 1
	note __, 1
	note A_, 10
	note __, 8
	octave 3
	note A_, 1
	octave 2
	note A_, 1
	octave 3
	note E_, 1
	note A_, 1
	note B_, 1
	octave 2
	note B_, 1
	octave 3
	note G_, 1
	note B_, 1
.loop
	octave 4
	note C_, 2
	callchannel .sub1
	note D_, 2
	octave 3
	note D_, 1
	note A#, 3
	note D_, 2
	octave 4
	note F_, 1
	note __, 1
	octave 3
	note F_, 1
	octave 4
	note D_, 2
	note __, 1
	octave 3
	note F_, 1
	note B_, 1
	octave 4
	note C_, 1
	note __, 1
	callchannel .sub1
	callchannel .sub2
	note A#, 2
	octave 3
	note F_, 1
	octave 4
	note F_, 4
	callchannel .sub3
	callchannel .sub2
	note A#, 2
	octave 3
	note F_, 1
	octave 4
	note F_, 3
	octave 3
	note F_, 1
	octave 4
	callchannel .sub3
	note F_, 1
	octave 3
	note F_, 1
	octave 4
	note D_, 1
	note F_, 1
	note A#, 2
	octave 3
	note F_, 1
	note A#, 1
	octave 4
	note D_, 2
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	note F_, 4
	dutycycle $3
	vibrato $11, $12
	octave 3
	callchannel .sub4
	note E_, 1
	note __, 1
	note E_, 1
	note F_, 1
	note G_, 3
	note __, 1
	octave 2
	note G_, 1
	octave 3
	note C_, 1
	note G_, 1
	note C_, 1
	octave 4
	note C_, 1
	octave 3
	note C_, 1
	note G_, 1
	note C_, 1
	callchannel .sub5
	callchannel .sub4
	sound_duty 0, 1, 1, 0
	intensity $c5
	vibrato $0, $0
	note E_, 1
	note __, 1
	note E_, 1
	note F_, 1
	note G_, 4
	note __, 2
	note G_, 1
	note A_, 1
	note A#, 2
	note __, 2
	octave 4
	note C_, 3
	note D_, 1
	note E_, 7
	note __, 1
	octave 3
	note A#, 4
	sound_duty 1, 1, 1, 1
	intensity $c7
	jumpchannel .loop

.sub1
	octave 3
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 4
	note C_, 4
	octave 3
	note C_, 1
	note __, 1
	note G_, 2
	octave 4
	note C_, 2
	endchannel

.sub2
	note F_, 2
	octave 3
	note F_, 1
	octave 4
	note D_, 2
	note __, 1
	octave 3
	note F_, 1
	note __, 1
	octave 4
	endchannel

.sub3
	note D_, 1
	note E_, 4
	octave 3
	note E_, 2
	octave 4
	note E_, 3
	note __, 1
	octave 3
	note E_, 2
	octave 4
	note D_, 1
	octave 3
	note D_, 1
	octave 4
	note E_, 1
	octave 3
	note E_, 1
	octave 4
	endchannel

.sub4
	note G_, 2
	note C_, 4
	octave 4
	note C_, 4
	octave 3
	note C_, 2
	note G_, 2
	note C_, 2
.sub5
	note A#, 2
	octave 2
	note A#, 2
	octave 3
	note A_, 2
	octave 2
	note A_, 2
	octave 3
	note G_, 2
	octave 2
	note G_, 2
	octave 3
	note F_, 2
	octave 2
	note F_, 2
	octave 3
	endchannel

Music_NaljoGym_Ch2:
	dutycycle $0
	stereopanning $f
	notetype $c, $c7
	vibrato $9, $12
	octave 3
	note G_, 8
	note F_, 8
	note E_, 4
	octave 2
	note E_, 1
	note __, 1
	note E_, 10
	note __, 8
	octave 3
	note E_, 2
	octave 2
	note A_, 2
	octave 3
	note G_, 2
	octave 2
	note B_, 2
.loop
	octave 3
	note G_, 3
	note __, 1
	octave 4
	note E_, 2
	octave 3
	note G_, 4
	note E_, 1
	note __, 1
	note E_, 2
	note G_, 2
	note A#, 2
	note __, 1
	note G_, 3
	note A#, 2
	note D_, 1
	octave 2
	note A#, 1
	octave 3
	note F_, 1
	octave 2
	note A#, 1
	octave 3
	note G_, 1
	octave 2
	note A#, 1
	octave 3
	note D_, 1
	note F_, 1
	note E_, 6
	note G_, 4
	note E_, 4
	note G_, 2
	note F_, 3
	note G_, 1
	note A#, 4
	octave 4
	note D_, 2
	note __, 1
	octave 3
	note A#, 1
	note F_, 1
	note A#, 1
	octave 4
	note D_, 1
	octave 3
	note A#, 1
	octave 4
	note C_, 10
	note __, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	note D_, 2
	note __, 1
	note A#, 3
	note __, 2
	note F_, 2
	note __, 1
	note G#, 4
	note __, 1
	note G_, 4
	note C_, 2
	note G_, 4
	note __, 2
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A#, 1
	note __, 1
	note G_, 1
	note A_, 1
	note D_, 2
	note F_, 4
	note D_, 1
	note F_, 1
	octave 3
	note A#, 4
	dutycycle $2
	intensity $b7
	vibrato $0, $0
	note C_, 1
	note E_, 1
	note G_, 1
	octave 4
	note C_, 1
	note E_, 1
	note G_, 1
	callchannel .sub
	note A#, 1
	octave 5
	note D_, 1
	sound_duty 0, 1, 1, 0
	dutycycle $3
	intensity $c5
	octave 4
	note C_, 1
	note __, 1
	note C_, 1
	note D_, 1
	note E_, 4
	note __, 2
	sound_duty 1, 1, 1, 1
	dutycycle $0
	intensity $a2
	octave 3
	note G_, 1
	note E_, 1
	note G_, 1
	note __, 1
	octave 4
	note C_, 1
	note __, 1
	note A#, 1
	note F_, 1
	note D_, 1
	note F_, 1
	note A_, 1
	note F_, 1
	note D_, 1
	note F_, 1
	note G_, 1
	note F_, 1
	note D_, 1
	note F_, 1
	note D_, 1
	note C_, 1
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	dutycycle $2
	intensity $b7
	note C_, 1
	note __, 1
	note C_, 1
	note D_, 1
	note E_, 2
	callchannel .sub
	octave 3
	note A#, 1
	octave 4
	note D_, 1
	sound_duty 0, 1, 1, 0
	dutycycle $3
	intensity $c5
	note C_, 1
	note __, 1
	note C_, 1
	note D_, 1
	note E_, 5
	note __, 1
	note E_, 1
	note F_, 1
	note G_, 2
	note __, 2
	sound_duty 1, 1, 1, 1
	dutycycle $2
	intensity $b7
	note E_, 1
	note G_, 1
	octave 5
	note C_, 1
	note D_, 1
	note E_, 1
	note C_, 1
	octave 4
	note G_, 1
	note C_, 1
	octave 3
	note G_, 1
	note C_, 1
	note E_, 1
	note G_, 1
	note A#, 1
	note E_, 1
	note G_, 1
	note E_, 1
	dutycycle $0
	intensity $c7
	jumpchannel .loop

.sub
	note A#, 1
	octave 5
	note C_, 1
	octave 4
	note G_, 1
	note A#, 1
	note E_, 1
	note G_, 1
	note C_, 1
	note E_, 1
	octave 3
	note G_, 1
	octave 4
	note C_, 1
	note D_, 1
	octave 3
	note G_, 1
	note A#, 1
	octave 4
	note E_, 1
	note F_, 1
	note D_, 1
	octave 3
	note A_, 1
	octave 4
	note D_, 1
	note G_, 1
	note F_, 1
	note D_, 1
	note G_, 1
	note F_, 1
	note G_, 1
	endchannel

Music_NaljoGym_Ch3:
	stereopanning $f0
	notetype $c, $19
	octave 4
	note C_, 2
	octave 3
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	note A#, 2
	note A_, 2
	octave 2
	note A_, 2
	note A_, 1
	note __, 1
	note A_, 10
	note __, 8
	note A_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
.loop
	note C_, 3
	note __, 1
	note C_, 1
	note __, 1
	note C_, 4
	note G_, 2
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
.repeat1
	note D_, 2
	octave 2
	note A#, 1
	note __, 3
	octave 3
	note D_, 2
	note F_, 3
	note G_, 3
	note D_, 2
	note E_, 2
	callchannel .sub1
	loopchannel 2, .repeat1
.repeat2
	note D_, 1
	note __, 1
	note D_, 4
	note E_, 2
	note F_, 1
	note __, 1
	note F_, 2
	note G#, 2
	note F_, 1
	note G#, 1
	note G_, 2
	callchannel .sub1
	loopchannel 2, .repeat2
	octave 2
	callchannel .sub2
	note C_, 2
	note D_, 2
	note G_, 2
	note F_, 2
	note D_, 2
	note F_, 4
	note E_, 2
	note D_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note E_, 2
	note __, 2
	note C_, 4
	octave 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	callchannel .sub2
	note A_, 1
	note A#, 1
	note G_, 2
	note A#, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note __, 2
	note C_, 6
	octave 2
	note A#, 4
	octave 3
	jumpchannel .loop

.sub1
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note C_, 4
	note G_, 2
	note C_, 2
	note G_, 2
	endchannel

.sub2
	note A#, 2
	octave 3
	note D_, 2
	note F_, 4
	octave 2
	note A_, 2
	octave 3
	note C_, 2
	note D_, 2
	note F_, 2
	note G_, 2
	note E_, 2
	note __, 2
	note G_, 4
	endchannel

Music_NaljoGym_Ch4:
	notetype $c
	togglenoise $4
	rept 2
		note C#, 1
		note C#, 1
		note C#, 1
		note C#, 5
	endr
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D#, 2
	note D#, 1
	note D#, 1
	note D#, 16
	note D#, 1
	note D#, 1
	note E_, 2
	note D#, 1
	note D#, 1
	note E_, 2
.loop
	callchannel .sub
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	callchannel .sub
	note D_, 1
	note D_, 1
	note E_, 2
.repeat
	note D#, 3
	note D#, 3
	note C#, 1
	note D#, 1
	note D#, 2
	note D#, 2
	note C#, 2
	note D#, 2
	note D#, 3
	note D#, 3
	note C#, 1
	note D#, 3
	note C#, 2
	note D#, 2
	note C#, 2
	loopchannel 3, .repeat
	note E_, 4
	note D#, 2
	note E_, 4
	note D#, 2
	note E_, 2
	note D#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D#, 4
	note D#, 4
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	jumpchannel .loop

.subrepeat
	note D#, 1
	note G#, 1
	note G#, 1
	note G#, 1
.sub
	note D#, 1
	note D#, 1
	note G#, 2
	note D#, 1
	note D#, 1
	note G#, 2
	note D#, 2
	note G#, 2
	loopchannel 4, .subrepeat
	endchannel
