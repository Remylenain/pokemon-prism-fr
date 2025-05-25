Music_Route119:
	channelcount 4
	channel 1, Music_Route119_Ch1
	channel 2, Music_Route119_Ch2
	channel 3, Music_Route119_Ch3
	channel 4, Music_Route119_Ch4

Music_Route119_Ch1:
	tempo 190
	dutycycle 0
	stereopanning $f0
	vibrato $12, $15
	tone $0001
	notetype $6, $22
	octave 2
	note F#, 1
	note G#, 1
	intensity $32
	note A_, 1
	note G#, 1
	intensity $42
	note A_, 1
	note B_, 1
	intensity $52
	note A_, 1
	note B_, 1
	intensity $62
	octave 3
	note C#, 1
	octave 2
	note B_, 1
	intensity $72
	octave 3
	note C#, 1
	note D_, 1
	intensity $77
	note E_, 8
	octave 2
	intensity $72
	note A_, 2
	note A_, 2
	note A_, 4
	octave 3
	intensity $75
	note E_, 8
	octave 2
	note A_, 2
	note G#, 2
	note A_, 2
	octave 3
	note C#, 2
	note C_, 2
	note C#, 2
	note B_, 4
	octave 4
	note C#, 2
	octave 3
	note G_, 2
	octave 4
	note C#, 2
	octave 3
	note A_, 2
	octave 4
	intensity $82
.repeat1
	note D_, 2
	note C#, 2
	note C#, 2
	loopchannel 4, .repeat1
	intensity $72
	octave 2
	note A_, 4
	octave 3
	note D_, 2
	intensity $74
	note F_, 6
	octave 2
	intensity $72
	note B_, 4
	octave 3
	note D_, 2
	intensity $74
	note G_, 6
	intensity $72
	note E_, 2
	octave 2
	note A_, 2
	note A_, 2
	note A_, 4
	note A_, 2
	note A_, 2
	note A_, 1
	note A_, 1
	octave 3
	intensity $77
	note E_, 8
	intensity $77
	note G_, 6
	note F#, 6
	intensity $81
	note C#, 1
	octave 2
	note B_, 1
	octave 3
	note C#, 1
	note E_, 1
	note C#, 1
	note E_, 1
	intensity $92
	note G_, 2
	octave 4
	note C#, 2
	note A_, 2
	callchannel .sub1
	octave 2
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	octave 3
	note D_, 1
	note D_, 1
	intensity $97
	note F_, 6
	octave 2
	intensity $91
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 1
	octave 3
	note D_, 1
	note D_, 1
.loop
	dutycycle 2
	intensity $77
	octave 3
	note G_, 4
	note F#, 1
	note F_, 1
.repeat2
	note C#, 2
	note E_, 2
	loopchannel 5, .repeat2
	note D_, 2
	callchannel .sub2
	callchannel .sub2
	octave 2
	note B_, 2
	intensity $a2
	octave 3
	note E_, 2
	note A_, 2
	octave 4
	note C#, 2
	note E_, 2
	note G#, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note E_, 2
	note D_, 2
	intensity $77
.repeat3
	octave 2
	note F#, 2
	octave 3
	note C#, 2
	loopchannel 5, .repeat3
	octave 2
	note B_, 2
	note A_, 2
.repeat4
	octave 2
	note G#, 2
	octave 3
	note E_, 2
	loopchannel 5, .repeat4
	note D_, 2
	octave 2
	note B_, 2
.repeat5
	octave 2
	note F#, 2
	octave 3
	note D_, 2
	loopchannel 5, .repeat5
	note C#, 2
	note D_, 2
	intensity $a2
	note G#, 2
	note B_, 2
	octave 4
	note D_, 2
	note F#, 1
	note G#, 1
	note F#, 1
	note G#, 1
	note F#, 1
	note E_, 1
	note D_, 1
	note E_, 1
	note D_, 1
	note E_, 1
	note D_, 1
	octave 3
	note B_, 1
	note G#, 1
	note B_, 1
	note G#, 1
	note F#, 1
	note E_, 1
	note D_, 1
	note A_, 2
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note G#, 2
	note F#, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note D_, 2
	note F#, 2
	octave 4
	note A_, 2
	octave 3
	note D_, 2
	note F#, 2
	note A_, 2
	note D_, 2
	note F#, 2
	octave 4
	note A_, 2
	octave 3
	note D_, 2
	note A_, 2
	octave 4
	note D_, 2
	note E_, 2
	note D_, 2
	note C#, 2
	note D_, 2
	note C#, 2
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	octave 3
	note B_, 2
	note E_, 2
	note A_, 2
	note B_, 2
	octave 4
	note C#, 2
	callchannel .sub3
	octave 4
	note E_, 2
	callchannel .sub3
	intensity $a4
	note E_, 4
	note F#, 4
	note G#, 4
	intensity $a2
	note A_, 2
	note B_, 2
	octave 4
	note C#, 2
	note D_, 2
	note E_, 2
	note F_, 2
	intensity $a7
	note F#, 8
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 6
	octave 3
	intensity $a2
	note B_, 2
	octave 4
	note C#, 2
	octave 3
	note B_, 2
	note B_, 2
	octave 4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 2
	octave 3
	note B_, 2
	octave 4
	note C#, 4
	note D_, 2
	note G#, 2
	note E_, 2
	octave 3
	note B_, 2
	octave 4
	note E_, 2
	note G#, 2
	note E_, 2
	note A_, 2
	note F_, 2
	note C_, 2
	note F_, 2
	note A_, 2
	note F_, 2
	intensity $b1
.repeat6
	note A#, 1
	note F#, 1
	note C#, 1
	note F#, 1
	loopchannel 3, .repeat6
.repeat7
	note B_, 1
	note G_, 1
	note D_, 1
	note G_, 1
	loopchannel 3, .repeat7
	intensity $71
	octave 3
	note A_, 1
	octave 4
	note D_, 1
	note E_, 1
	note D_, 1
	note E_, 1
	note B_, 1
	note E_, 1
	note B_, 1
	octave 5
	note D_, 1
	octave 4
	note A_, 1
	note B_, 1
	octave 5
	note E_, 1
	note B_, 1
	note E_, 1
	note D_, 1
	octave 4
	note A_, 1
	octave 5
	note E_, 1
	note D_, 1
	octave 4
	note A_, 1
	octave 5
	note D_, 1
	octave 4
	note G#, 1
	note E_, 1
	note G#, 1
	note D_, 1
	intensity $97
	octave 3
	note G#, 8
	intensity $92
	note C_, 2
	note C_, 2
	note C_, 4
	intensity $97
	note G#, 6
	note D#, 2
	octave 4
	note C_, 8
	octave 3
	intensity $92
	note D#, 2
	note D#, 2
	note D#, 4
	octave 4
	intensity $97
	note C_, 6
	octave 3
	note D#, 2
	dutycycle 0
	intensity $a3
	octave 4
	note C#, 4
	note F_, 2
	intensity $a0
	note G#, 6
	intensity $a7
	note G#, 12
	note __, 6
	octave 2
	dutycycle 2
	intensity $72
	note F_, 4
	note G#, 2
	intensity $77
	note F#, 6
	note A#, 6
	intensity $72
	note G#, 4
	note A#, 2
	octave 3
	intensity $70
	note C_, 4
	intensity $77
	note C_, 8
	intensity $72
	note C_, 4
	note C#, 2
	intensity $70
	note D#, 4
	intensity $77
	note D#, 8
	intensity $72
	note D#, 2
	note F_, 2
	intensity $77
	note F#, 8
	intensity $92
	octave 4
.repeat8
	note A_, 2
	octave 3
	note A_, 4
	octave 4
	note A_, 4
	note A_, 2
	loopchannel 2, .repeat8
	octave 5
	note C#, 2
	octave 4
	note E_, 4
	octave 5
	note C#, 4
	note C#, 2
	note C#, 2
	note D_, 2
	note E_, 2
	note E_, 2
	note D_, 2
	note C#, 2
	note D_, 2
	octave 4
	note F#, 2
	octave 5
	note D_, 2
	note D_, 4
	note D_, 2
	note D_, 2
	octave 4
	note F#, 4
	octave 5
	note D_, 4
	note D_, 2
	octave 4
	note G_, 2
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note F#, 2
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note E_, 2
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note G_, 2
	note E_, 2
	note C_, 2
	dutycycle 0
	octave 3
	intensity $a7
	note G#, 10
	intensity $a2
	note C#, 2
	note C#, 2
	note C#, 1
	note C#, 1
	intensity $a7
	note G#, 8
	note G_, 6
	note F#, 6
	note E_, 6
	note C#, 6
	intensity $93
	callchannel .sub1
	intensity $93
	octave 2
	note A_, 2
	note A_, 2
	octave 3
	note D_, 2
	intensity $97
	note F_, 6
	octave 2
	intensity $93
	note B_, 2
	note B_, 2
	octave 3
	note D_, 2
	jumpchannel .loop

.sub1
	octave 5
	note D_, 2
	note C#, 2
	note C#, 2
	note D_, 2
	note C#, 2
	note C#, 2
	intensity $91
	note D_, 1
	note C#, 1
	octave 4
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	note C#, 1
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	endchannel

.sub2
	octave 2
	note B_, 2
.subrepeat
	octave 2
	note A_, 2
	octave 3
	note D_, 2
	loopchannel 5, .subrepeat
	note C#, 2
	endchannel

.sub3
	octave 3
	note E_, 2
	note A_, 2
	octave 4
	note A_, 2
	octave 3
	note E_, 2
	note A_, 2
	endchannel

Music_Route119_Ch2:
	dutycycle $3
	vibrato $12, $15
	tone $0001
	notetype $6, $42
	octave 3
	note D#, 1
	note E_, 1
	intensity $52
	note F#, 1
	note E_, 1
	intensity $62
	note F#, 1
	note G#, 1
	intensity $72
	note F#, 1
	note G#, 1
	intensity $82
	note A_, 1
	note G#, 1
	intensity $92
	note A_, 1
	note B_, 1
	intensity $a7
	octave 4
	note C#, 8
	octave 3
	intensity $a2
	note E_, 2
	note E_, 2
	note E_, 4
	octave 4
	intensity $a7
	note C#, 8
	intensity $a5
	note E_, 6
	note D_, 6
	note C#, 6
	note E_, 6
	intensity $a7
	note D_, 10
	octave 3
	note A_, 1
	note __, 1
	note A_, 12
	intensity $a2
	note F_, 4
	note G_, 2
	intensity $a7
	note A_, 6
	intensity $a2
	note G_, 4
	note A_, 2
	intensity $a7
	note B_, 6
	octave 4
	note C#, 2
	octave 3
	intensity $a2
	note E_, 2
	note E_, 2
	note E_, 4
	note E_, 2
	note E_, 2
	note E_, 1
	note E_, 1
	octave 4
	intensity $a7
	note C#, 8
	intensity $a5
	note E_, 6
	note D_, 6
	intensity $a3
	note C#, 4
	intensity $a7
	note E_, 8
	note D_, 10
	octave 3
	note A_, 1
	note __, 1
	note A_, 12
	intensity $a2
	note F_, 2
	note F_, 2
	note G_, 2
	intensity $a7
	note A_, 6
	intensity $a2
	note G_, 2
	note G_, 2
	note A_, 2
	dutycycle 0
	intensity $a0
	octave 4
	note G_, 4
	note F#, 1
	note F_, 1
	note E_, 6
	intensity $a7
	vibrato $0, $36
	note E_, 10
	vibrato $8, $15
	intensity $a2
	note D_, 2
	note C#, 4
	note E_, 2
.loop
	intensity $a7
	vibrato $6, $36
	note D_, 12
	vibrato $8, $15
	octave 3
	note A_, 6
	octave 4
	note D_, 2
	note C#, 2
	octave 3
	note B_, 2
	octave 4
	intensity $a0
	note D_, 6
	intensity $a7
	vibrato $6, $36
	note D_, 10
	vibrato $6, $15
	note C#, 2
	octave 3
	note B_, 2
	note G#, 2
	note B_, 2
	octave 4
	vibrato $6, $36
	note C#, 12
	vibrato $6, $15
	note E_, 6
	intensity $87
	octave 3
	note A_, 2
	intensity $97
	note B_, 2
	octave 4
	intensity $a7
	note C_, 2
	intensity $a0
	note C#, 6
	vibrato $6, $36
	intensity $a7
	note C#, 10
	vibrato $6, $15
	octave 3
	intensity $a2
	note B_, 2
	note A_, 4
	octave 4
	note C#, 2
	octave 3
	intensity $a7
	vibrato $6, $36
	note B_, 12
	vibrato $6, $15
	note F#, 6
	note G#, 6
	intensity $a2
	note G#, 2
	note A_, 4
	note A_, 4
	note A_, 4
	note A_, 2
	note D_, 2
	intensity $a7
	note G#, 4
	note A_, 2
	octave 4
	intensity $a0
	note E_, 6
	vibrato $0, $46
	intensity $a7
	note E_, 12
	intensity $b7
	vibrato $12, $15
	note E_, 2
	note D_, 2
	note C#, 2
	intensity $b2
	note E_, 16
	note D_, 2
	note C#, 4
	note E_, 2
	intensity $b7
	note D_, 12
	octave 3
	note A_, 6
	note E_, 2
	note A_, 2
	octave 4
	note C#, 2
	intensity $b2
	note D_, 16
	note C#, 2
	octave 3
	note B_, 4
	octave 4
	note D_, 2
	intensity $b7
	note C#, 12
	note E_, 2
	octave 3
	note E_, 2
	note A_, 2
	note B_, 4
	note B_, 2
	note A_, 4
	note B_, 4
	octave 4
	note C#, 4
	intensity $b4
	note D_, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note A#, 2
	intensity $b7
	note B_, 8
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 6
	note G#, 6
	intensity $b2
	note A_, 2
	note A_, 4
	note A_, 4
	note A_, 4
	note A_, 2
	note F#, 2
	intensity $b7
	note G#, 4
	note A_, 2
	note B_, 12
	octave 5
	note C_, 12
	intensity $b2
	note C#, 2
	note C#, 4
	note C#, 4
	note C#, 1
	note C#, 1
	note D_, 2
	note D_, 4
	note D_, 4
	note D_, 1
	note D_, 1
	octave 3
	intensity $b0
	note E_, 12
	intensity $b7
	note E_, 12
	dutycycle 3
	octave 4
	intensity $a7
	note C_, 8
	octave 3
	intensity $a2
	note D#, 2
	note D#, 2
	note D#, 4
	octave 4
	intensity $a7
	note C_, 8
	note D#, 6
	note C#, 6
	note C_, 6
	note D#, 6
	note F_, 10
	octave 3
	intensity $a2
	note G#, 2
	intensity $a7
	note G#, 6
	intensity $a2
	note F_, 4
	note G#, 2
	intensity $a7
	note F#, 6
	note F_, 6
	note D#, 6
	note C#, 6
	intensity $a2
	note C_, 4
	note C#, 2
	intensity $a0
	note D#, 4
	intensity $a7
	note D#, 8
	intensity $a2
	note D#, 4
	note F_, 2
	intensity $a0
	note F#, 4
	intensity $a7
	note F#, 8
	intensity $a2
	note G#, 2
	note A#, 2
	octave 4
	intensity $a7
	note C_, 8
	note C#, 8
	octave 3
	intensity $a2
	note E_, 2
	note E_, 2
	note E_, 4
	octave 4
	intensity $a7
	note C#, 8
	note E_, 6
	note D_, 6
	note C#, 6
	note E_, 6
	note D_, 10
	octave 3
	intensity $a2
	note A_, 2
	intensity $a7
	note A_, 12
	note G_, 6
	note F#, 6
	note E_, 6
	note G_, 6
	octave 4
	note F_, 10
	octave 3
	intensity $a2
	note G#, 2
	note G#, 2
	intensity $a1
	note G#, 1
	note G#, 1
	octave 4
	intensity $a7
	note F_, 8
	note E_, 6
	note D_, 6
	note C#, 6
	octave 3
	note A_, 6
	intensity $a2
	note F#, 4
	note G_, 2
	intensity $a0
	note A_, 6
	intensity $a7
	note A_, 12
	intensity $a2
	note F_, 2
	note F_, 2
	note G_, 2
	intensity $a7
	note A_, 6
	dutycycle 0
	intensity $b2
	note B_, 4
	octave 4
	note D_, 2
	intensity $b4
	note G_, 6
	intensity $60
	note G_, 10
	intensity $6f
	note G_, 6
	intensity $b7
	note F#, 1
	note F_, 1
	note E_, 2
	note D_, 2
	note C#, 2
	jumpchannel .loop

Music_Route119_Ch3:
	stereopanning $f
	notetype $6, $14
	octave 2
	note __, 6
	note E_, 4
	callchannel .sub1
	note F_, 2
	note F#, 2
	note G_, 7
	note __, 1
	note G_, 2
	callchannel .sub1
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note G_, 7
	note __, 1
	note G_, 4
.loop
	octave 3
	callchannel .sub2
	note __, 2
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	note __, 2
	callchannel .sub2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	note __, 2
	octave 2
	note B_, 2
	note __, 2
	note B_, 2
	octave 3
	note B_, 2
	note __, 2
	octave 2
	note B_, 1
	note __, 1
	note B_, 2
	note __, 2
	note B_, 2
	octave 3
	note B_, 2
	octave 2
	note B_, 2
	note __, 2
	note A_, 2
	note __, 2
	note A_, 2
	octave 3
	note A_, 2
	note __, 2
	octave 2
	note A_, 1
	note __, 1
	note A_, 2
	note __, 2
	note A_, 2
	octave 3
	note A_, 2
	octave 2
	note A_, 2
	note __, 2
	note F#, 2
	note __, 2
	note F#, 2
	octave 3
	note F#, 2
	note __, 2
	octave 2
	note F#, 1
	note __, 1
	note F#, 2
	note __, 2
	note F#, 2
	octave 3
	note F#, 2
	octave 2
	note F#, 2
	note __, 2
	callchannel .sub3
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	note __, 2
	octave 3
	note D_, 2
	note __, 2
	note D_, 2
	octave 4
	note D_, 2
	note __, 2
	note D_, 2
	octave 3
	note D_, 2
	callchannel .sub4
	note E_, 2
	note __, 2
	note E_, 2
	octave 4
	note E_, 2
	note D_, 2
	octave 3
	note E_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	note __, 2
	note D_, 4
	note __, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	note __, 2
	note D_, 2
	note __, 2
	note D_, 1
	note __, 1
	note D_, 2
	note __, 2
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 1
	note __, 1
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	note __, 2
	note D_, 2
	note __, 2
	note D_, 2
	note B_, 2
	octave 2
	note B_, 2
	note __, 2
	note B_, 2
	note __, 2
	note B_, 2
	octave 3
	note B_, 2
	octave 2
	note B_, 2
	note __, 2
	note B_, 2
	note __, 2
	octave 3
	note B_, 2
	octave 2
	note A_, 2
	note __, 2
	note A_, 2
	octave 3
	note A_, 2
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note A_, 2
	octave 2
	note A_, 2
	note __, 2
	note A_, 2
	note __, 2
	note A_, 2
	note F#, 2
	note __, 2
	note F#, 2
	octave 3
	note F#, 2
	note __, 2
	octave 2
	note F#, 2
	octave 3
	note F#, 2
	octave 2
	note F#, 2
	note __, 2
	note F#, 2
	note __, 2
	note F#, 2
	callchannel .sub3
	note __, 2
	note E_, 2
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	note __, 2
	octave 3
	callchannel .sub2
	callchannel .sub4
	note F_, 2
	note __, 2
	note F_, 2
	octave 4
	note F_, 2
	note D#, 2
	octave 3
	note F_, 2
	note F#, 1
	note __, 1
	note F#, 2
	note __, 2
	octave 4
	note F#, 2
	note E_, 2
	octave 3
	note F#, 2
	note G_, 1
	note __, 1
	note G_, 2
	note __, 2
	octave 4
	note G_, 2
	note F_, 2
	octave 3
	note G_, 1
	octave 2
	note E_, 1
	octave 3
	note B_, 8
	intensity $24
	note B_, 16
	octave 2
	intensity $14
	note G#, 10
	note __, 2
	note G#, 2
	note __, 2
	note G#, 4
	note __, 2
	note G_, 2
	note F#, 10
	note __, 2
	note F#, 2
	note __, 2
	note F#, 4
	note __, 2
	octave 3
	note C_, 2
	note C#, 12
	intensity $24
	note C#, 12
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	note __, 2
	intensity $14
	octave 4
	note D#, 1
	note __, 1
	note F_, 1
	note __, 1
	note F#, 1
	note __, 1
	note E_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 5
	note C#, 1
	note __, 1
	note E_, 2
	note __, 2
	note D_, 2
	note C#, 2
	note __, 2
	octave 4
	note B_, 2
	note A_, 2
	note __, 2
	octave 5
	note C#, 2
	octave 4
	note G_, 1
	note __, 1
	note B_, 1
	note __, 1
	octave 5
	note D_, 1
	note __, 1
	note G_, 2
	note __, 2
	note F#, 2
	note E_, 2
	note __, 2
	note D_, 2
	note C#, 2
	note __, 2
	note E_, 2
	octave 4
	note F#, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 5
	note F#, 1
	note __, 1
	note A_, 6
	intensity $24
	note A_, 6
	intensity $34
	note A_, 6
	intensity $14
	octave 3
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note B_, 8
	octave 4
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note C_, 2
	octave 3
	note C_, 6
	note C#, 6
	note __, 10
	note C#, 6
	note __, 2
	octave 2
	note G_, 6
	note __, 10
	note G_, 6
	note F#, 1
	note __, 1
	note F#, 6
	note __, 16
	note __, 2
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 6
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 6
	jumpchannel .loop

.sub1
	note G#, 2
	note A_, 15
	note __, 1
	note A_, 8
	note G_, 15
	note __, 1
	note G_, 8
	note F#, 15
	note __, 1
	note F#, 8
	note F_, 7
	note __, 1
	endchannel

.sub2
	note D_, 2
	note __, 2
	note D_, 2
	octave 4
	note D_, 2
	note __, 2
	octave 3
	note D_, 1
	note __, 1
	note D_, 2
	endchannel

.sub3
	note E_, 2
	note __, 2
	note E_, 2
	octave 3
	note E_, 2
	note __, 2
	octave 2
	note E_, 1
	note __, 1
	note E_, 2
	endchannel

.sub4
	note __, 2
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	note __, 2
	note E_, 2
	octave 4
	note E_, 2
	octave 3
	note E_, 2
	octave 4
	note E_, 2
	octave 3
	note E_, 2
	note __, 2
	endchannel

Music_Route119_Ch4:
	togglenoise $3
	notetype $6
	note __, 6
	note A_, 1
	note A_, 1
	note A_, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note B_, 6
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 2
	note C_, 4
	note D#, 2
	callchannel .sub1
	callchannel .sub2
	note B_, 8
	note C_, 2
	note C_, 1
	note C_, 1
	note B_, 6
	note A_, 1
	note A_, 1
	note C_, 4
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 2
	note C_, 1
	note C_, 1
	note B_, 8
	callchannel .sub2
.loop
	note C_, 2
	note D#, 2
	note D#, 2
	note B_, 4
	note D_, 1
	note D_, 1
	note C_, 2
	note D#, 2
	note D#, 2
	note B_, 4
	note D_, 1
	note D_, 1
	note B_, 12
.repeat1
	note __, 12
	loopchannel 11, .repeat1
	callchannel .sub3
	note C_, 2
	note G#, 2
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	callchannel .sub4
.repeat2
	callchannel .sub3
	note C_, 2
	note G#, 2
	note C_, 2
	note B_, 6
	note C_, 2
	note G#, 2
	note C_, 2
	note B_, 6
	loopchannel 2, .repeat2
	callchannel .sub4
	note C_, 2
	note D_, 2
	note C_, 2
	note C_, 2
	note D#, 2
	note C_, 2
	callchannel .sub4
	callchannel .sub4
	callchannel .sub3
.repeat3
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 4
	note C_, 2
	loopchannel 4, .repeat3
	note B_, 12
	note __, 12
	note C_, 4
	note G#, 2
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 2
	note C_, 2
	note G#, 1
	note G#, 1
	note D#, 2
	callchannel .sub1
	callchannel .sub2
	note B_, 8
	note D#, 4
	note D#, 12
	note B_, 6
	callchannel .sub1
	note G#, 4
	note G#, 2
	note G#, 4
	note G#, 2
	note G#, 4
	note G#, 2
	callchannel .sub1
	note G#, 2
	note G#, 2
	note G#, 2
	note G#, 4
	note G#, 2
	note C_, 4
	note G#, 2
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 2
	note C_, 2
	note G#, 1
	note G#, 1
	note D#, 2
	callchannel .sub1
	callchannel .sub2
.repeat4
	note C_, 2
	note C_, 2
	note C_, 2
	rept 6
		note D_, 1
	endr
	loopchannel 2, .repeat4
	note B_, 6
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 2
	note C_, 1
	note C_, 1
	note B_, 8
	note C_, 6
	note G#, 1
	note G#, 1
	note C_, 4
	note C_, 4
	note C_, 6
	note G#, 1
	note G#, 1
	note C_, 6
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 4
	note C_, 8
	jumpchannel .loop

.sub1
	note G#, 1
	loopchannel 6, .sub1
	endchannel

.sub2
	note C_, 2
	note G#, 2
	note G#, 1
	note G#, 1
	note G#, 2
	note C_, 2
	note G#, 2
	note C_, 2
	note G#, 2
	note D#, 2
	note G#, 4
	note G#, 2
	note C_, 2
	note G#, 2
	note G#, 2
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note D#, 2
	note C_, 4
	note C_, 2
.repeat5
	note C_, 1
	loopchannel 6, .repeat5
	endchannel

.sub3
	note D#, 2
	rept 4
		note C_, 2
		note G#, 2
	endr
	note C_, 2
	note C_, 2
	note C_, 2
	endchannel

.sub4
	note C_, 2
	note G#, 2
	note C_, 2
.repeat6
	note D_, 1
	loopchannel 6, .repeat6
	endchannel
