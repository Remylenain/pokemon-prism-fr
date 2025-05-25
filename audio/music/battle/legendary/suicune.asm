Music_SuicuneBattle:
	channelcount 3
	channel 1, Music_SuicuneBattle_Ch1
	channel 2, Music_SuicuneBattle_Ch2
	channel 3, Music_SuicuneBattle_Ch3

Music_SuicuneBattle_Ch1:
	tempo 101
	volume $77
	dutycycle $3
	tone $0002
	vibrato $12, $15
	notetype $c, $b7
	octave 4
	note A_, 1
	note G#, 1
	note G_, 4
	note E_, 2
	note D#, 1
	note D_, 1
	note C#, 4
	octave 3
	note A#, 2
	note A_, 1
	note G#, 1
	note G_, 4
	note E_, 2
	note D#, 1
	note D_, 1
	note C#, 4
	octave 2
	note A#, 2
	intensity $b2
	note A_, 2
	jumpchannel .skip1
.repeat1
	intensity $b3
	octave 4
	note F_, 4
	note E_, 2
	intensity $b2
	octave 2
.skip1
	rept 3
		note A_, 4
		note A_, 2
		note A_, 2
	endr
	note A_, 2
	loopchannel 4, .repeat1
	note A_, 1
	note B_, 1
	octave 3
	note E_, 1
	note G#, 1
.loop
	intensity $b4
	callchannel .sub1
	note G_, 2
	note E_, 2
	octave 2
	note G_, 2
	octave 3
	note E_, 2
	note G_, 2
	note A_, 6
	note G_, 4
	note F_, 4
	note E_, 2
	note D_, 6
	callchannel .sub1
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note A_, 4
	note G_, 2
	note F_, 2
	note A_, 2
	note G_, 2
	note A_, 2
	note C_, 2
	octave 4
	note C_, 4
	octave 3
	note A_, 2
	note G_, 2
	note C_, 2
	callchannel .sub2
	note C_, 2
	octave 2
	note G_, 2
	note __, 2
	intensity $b6
	octave 3
	note G_, 10
	intensity $b3
	note C_, 2
	octave 2
	note G_, 2
	note __, 2
	intensity $b7
	octave 3
	note G_, 10
	callchannel .sub2
	note G_, 2
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note B_, 2
	note F#, 2
	note E_, 2
	octave 2
	note A_, 2
	octave 3
	note A_, 2
	note E_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	intensity $b2
	octave 2
	note B_, 2
	note B_, 6
	note B_, 2
	note B_, 6
	note B_, 2
	note B_, 6
	note B_, 2
	intensity $b4
	octave 3
	note C_, 6
	intensity $b2
.repeat2
	octave 2
	note B_, 2
	note B_, 2
	intensity $b5
	octave 1
	note F#, 4
	intensity $b2
	loopchannel 3, .repeat2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	octave 2
	note B_, 1
	octave 3
	note F#, 1
	note A_, 1
	octave 4
	note C_, 1
.repeat3
	octave 3
	note B_, 2
	note B_, 2
	intensity $b5
	octave 1
	note F#, 4
	intensity $b2
	loopchannel 3, .repeat3
	octave 3
	note B_, 2
	intensity $b5
	octave 4
	note C_, 6
	jumpchannel .skip2
.repeat4
	note B_, 2
	intensity $b4
	octave 1
	note F#, 4
.skip2
	intensity $b2
	octave 3
	note B_, 2
	loopchannel 4, .repeat4
	intensity $b5
	octave 4
	note C_, 6
	intensity $b7
	octave 2
	note B_, 8
	note E_, 8
	octave 3
	note C_, 8
	octave 2
	note A_, 8
	note B_, 8
	note E_, 8
	note F_, 10
	note C_, 2
	note D_, 2
	note C_, 2
	intensity $a0
	octave 1
	note F#, 8
	note B_, 8
	note G_, 8
	octave 2
	note C_, 8
	octave 1
	note B_, 8
	note E_, 8
	note F_, 8
	intensity $a7
	note F_, 8
.repeat5
	note __, 14
	loopchannel 14, .repeat5
	intensity $b2
	octave 3
.repeat6
	note D_, 8
	loopchannel 8, .repeat6
.repeat7
	note F_, 8
	loopchannel 7, .repeat7
	note F_, 4
	note E_, 8
.repeat8
	note __, 16
	loopchannel 10, .repeat8
	vibrato $8, $24
	dutycycle $2
	intensity $96
	octave 4
	note E_, 6
	note F#, 6
	octave 3
	note A_, 4
	octave 4
	note A_, 16
	vibrato $12, $15
	dutycycle $3
	jumpchannel .loop

.sub1
	octave 2
	note A_, 2
	note B_, 2
	note E_, 2
	octave 3
	note E_, 4
	octave 2
	note B_, 2
	note A_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	note A_, 4
	note E_, 2
	note D_, 2
	note E_, 2
	octave 3
	jumpchannel .skip3
.repeat9
	note A_, 2
	note E_, 2
.skip3
	note D_, 2
	octave 2
	note A_, 2
	octave 3
	note D_, 2
	note E_, 2
	loopchannel 3, .repeat9
	note C_, 2
	note D_, 2
	octave 2
	note G_, 2
	octave 3
	note G_, 4
	note D_, 2
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note C_, 2
	note D_, 2
	octave 2
	note G_, 2
	octave 3
	note F_, 4
	note E_, 2
	note D_, 2
	note F_, 2
	endchannel

.sub2
	intensity $b3
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note __, 2
	note E_, 4
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	note B_, 2
	octave 3
	note C_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	note A_, 2
	note B_, 2
	octave 3
	endchannel

Music_SuicuneBattle_Ch2:
	dutycycle $3
	vibrato $14, $34
	tone $0001
	notetype $c, $c3
.repeat1
	octave 5
	note E_, 1
	octave 4
	note E_, 1
	note A_, 2
	loopchannel 7, .repeat1
	octave 5
	note E_, 1
	octave 4
	note E_, 1
	note A_, 6
	intensity $c2
	callchannel .sub1
	callchannel .sub1
	callchannel .sub2
	note E_, 8
	note E_, 8
	note E_, 8
	note E_, 4
.loop
	intensity $c7
	octave 3
	note A_, 8
	note B_, 8
	note D_, 8
	intensity $b0
	octave 4
	note D_, 8
	intensity $b6
	note D_, 8
	vibrato $10, $24
	intensity $a4
	callchannel .sub3
	intensity $b0
	note E_, 10
	intensity $b7
	note E_, 6
	intensity $a5
	octave 2
	note G_, 4
	note A_, 4
	note G_, 4
	note B_, 4
	intensity $c7
	octave 3
	note A_, 8
	note B_, 8
	note D_, 8
	octave 4
	note D_, 8
	intensity $4c
	note D_, 4
	intensity $c6
	note D_, 4
	intensity $a4
	vibrato $8, $24
	callchannel .sub3
	intensity $4c
	note E_, 8
	intensity $c7
	note E_, 8
	intensity $c6
	note C_, 8
	note G_, 8
	intensity $c2
	octave 3
	callchannel .sub4
	note G_, 2
	note C_, 2
	note __, 2
	intensity $c7
	octave 4
	note C_, 10
	intensity $c3
	note G_, 2
	note C_, 2
	note __, 2
	intensity $c7
	octave 5
	note C_, 10
	intensity $c3
	octave 4
	callchannel .sub4
	intensity $c7
	note G_, 8
	note F#, 8
	note E_, 8
	note G_, 8
	intensity $c2
	octave 3
	note F#, 2
	note F#, 6
	note F#, 2
	note F#, 6
	note F#, 2
	note F#, 6
	note F#, 2
	intensity $b7
	note G_, 6
.repeat2
	intensity $c2
	note F#, 2
	note F#, 2
	intensity $c7
	octave 1
	note B_, 4
	octave 3
	loopchannel 3, .repeat2
	intensity $c2
	note F#, 2
	intensity $c7
	note G_, 6
	callchannel .sub5
	callchannel .sub5
	intensity $b0
	octave 3
	note F#, 8
	octave 2
	note B_, 8
	octave 3
	note G_, 8
	note E_, 8
	note F#, 8
	octave 2
	note B_, 8
	octave 3
	note C_, 8
	intensity $b7
	note C_, 8
	intensity $c7
	octave 1
	note B_, 8
	octave 2
	note E_, 8
	note C_, 8
	note F_, 8
	note E_, 8
	octave 1
	note B_, 8
	intensity $b0
	octave 2
	note C_, 10
	intensity $b7
	note C_, 6
	intensity $c3
	forceoctave $20
	callchannel .sub6
	forceoctave $10
	callchannel .sub6
	forceoctave $13
	callchannel .sub6
	forceoctave 0
	callchannel .sub6
	forceoctave 3
	callchannel .sub6
	forceoctave 0
	intensity $c2
	note A_, 8
	intensity $c3
	callchannel .sub7
	forceoctave 3
	callchannel .sub7
	forceoctave 0
	callchannel .sub7
	jumpchannel .loop

.sub1
	octave 2
.sub2
	note E_, 8
	note E_, 8
	note E_, 8
	intensity $c3
	octave 4
	note A#, 4
	intensity $c2
	note A_, 4
	endchannel

.sub3
	dutycycle $2
	octave 5
	note A_, 6
	note B_, 6
	note D_, 4
	octave 6
	note D_, 8
	vibrato $14, $34
	dutycycle $3
	intensity $c7
	octave 4
	note C_, 8
	note D_, 8
	octave 3
	note G_, 8
	octave 4
	note F_, 8
	endchannel

.sub4
	note F#, 2
	note G_, 2
	note __, 2
	note B_, 4
	note A_, 2
	note G_, 2
	note F#, 2
	note F#, 2
	note G_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note E_, 2
	note F#, 2
	endchannel

.sub5
	intensity $c2
	octave 4
	note F#, 2
	note F#, 2
	intensity $c7
	octave 1
	note B_, 4
	loopchannel 3, .sub5
	intensity $c2
	octave 4
	note F#, 2
	intensity $c7
	note G_, 6
	endchannel

.sub6
	octave 3
	note B_, 2
	octave 4
	note E_, 2
	octave 3
	note F_, 2
	octave 4
	note F_, 4
	note E_, 2
	octave 3
	note B_, 2
	note F_, 2
	note B_, 2
	octave 4
	note E_, 2
	note F_, 2
	note E_, 2
	octave 3
	note B_, 2
	note F_, 2
	note B_, 2
	octave 4
	note E_, 2
	loopchannel 2, .sub6
	endchannel

.sub7
	octave 2
.subrepeat
	note A_, 2
	note B_, 2
	note E_, 2
	octave 3
	note E_, 4
	octave 2
	note B_, 2
	note A_, 2
	note E_, 2
	note A_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	note A_, 2
	note E_, 2
	note A_, 2
	note B_, 2
	loopchannel 2, .subrepeat
	endchannel

Music_SuicuneBattle_Ch3:
	notetype $c, $18
	note __, 16
	note __, 4
	octave 2
	note A_, 4
	note D_, 2
	note E_, 2
	note A#, 2
	note G_, 2
.repeat1
	callchannel .sub1
	note A_, 2
	note E_, 2
	note D_, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	note E_, 2
	callchannel .sub1
	note A_, 4
	note E_, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	note E_, 2
	loopchannel 2, .repeat1
	intensity $16
.loop
	callchannel .sub2
	callchannel .sub3
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	octave 3
	note C_, 4
	octave 2
	note G_, 2
	note F_, 2
	note D_, 2
	callchannel .sub2
	callchannel .sub3
.repeat2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	loopchannel 5, .repeat2
	note C_, 2
	note G_, 2
	note C_, 2
	octave 3
	note C_, 4
	octave 2
	note G_, 2
	note C_, 2
	note G_, 2
.repeat3
	octave 1
	note B_, 2
	octave 2
	note F#, 2
	note B_, 2
	note F#, 2
	octave 1
	note B_, 2
	octave 2
	note F#, 2
	octave 1
	note B_, 2
	octave 2
	note F#, 2
	loopchannel 2, .repeat3
	note C_, 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 4
	note C_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
.repeat4
	note D_, 2
	note A_, 2
	octave 3
	note D_, 2
	octave 2
	note A_, 2
	note D_, 2
	note A_, 2
	note D_, 2
	note A_, 2
	loopchannel 2, .repeat4
	note C_, 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	octave 1
	note B_, 2
	octave 2
	note F#, 2
	octave 1
	note B_, 2
	octave 2
	note F#, 2
	octave 1
	note A_, 2
	octave 2
	note E_, 2
	note A_, 2
	note E_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
.repeat5
	note F#, 2
	note F#, 2
	note __, 4
	loopchannel 3, .repeat5
	note F#, 2
	note G_, 6
.repeat6
	note F#, 2
	note F#, 2
	note __, 4
	loopchannel 3, .repeat6
	note F#, 2
	note G_, 6
.repeat7
	note B_, 2
	note B_, 2
	octave 1
	note B_, 4
	octave 2
	loopchannel 3, .repeat7
	note B_, 2
	octave 3
	note C_, 6
.repeat8
	note F#, 2
	note F#, 2
	octave 1
	note B_, 4
	octave 3
	loopchannel 3, .repeat8
	note F#, 2
	note G_, 6
	octave 2
	note F#, 8
	octave 1
	note B_, 8
	octave 2
	note G_, 8
	note E_, 8
	note F#, 8
	octave 1
	note B_, 8
	octave 2
	note C_, 10
	note C_, 2
	note D_, 2
	note C_, 2
	octave 1
	note B_, 8
	octave 2
	note E_, 8
	note C_, 8
	note F_, 8
	note E_, 8
	octave 1
	note B_, 8
	octave 2
	note C_, 16
	octave 1
.repeat9
	note __, 4
	note B_, 2
	note __, 2
	loopchannel 8, .repeat9
	callchannel .sub4
	note B_, 2
	octave 2
	note F_, 2
	note B_, 2
	note F_, 2
	note B_, 2
	note F_, 2
	octave 1
	note B_, 2
	octave 2
	note F_, 2
.repeat10
	note D_, 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note G#, 2
	loopchannel 3, .repeat10
	note D_, 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note G#, 2
	note D_, 2
	note G#, 2
.repeat11
	note B_, 2
	note F_, 2
	octave 1
	note B_, 2
	octave 2
	note B_, 2
	note F_, 2
	octave 1
	note B_, 2
	octave 2
	note B_, 2
	note F_, 2
	loopchannel 2, .repeat11
	callchannel .sub5
.repeat12
	octave 3
	note D_, 2
	octave 2
	note G#, 2
	note D_, 2
	octave 3
	note D_, 2
	octave 2
	note G#, 2
	note D_, 2
	octave 3
	note D_, 2
	octave 2
	note G#, 2
	loopchannel 2, .repeat12
	note D_, 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note G#, 2
	note D_, 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note G#, 2
	octave 3
	note D_, 2
	octave 2
	note G#, 2
	note D_, 2
	note G#, 2
	note A_, 4
	note __, 4
	callchannel .sub2
	note D_, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
.repeat13
	note C_, 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 2
	note G_, 2
	loopchannel 4, .repeat13
.repeat14
	octave 1
	note A_, 2
	octave 2
	note E_, 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note E_, 2
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note E_, 2
	loopchannel 3, .repeat14
	octave 1
	note A_, 2
	octave 2
	note E_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 4
	note E_, 2
	note D_, 2
	note E_, 2
	jumpchannel .loop

.sub1
	note D_, 2
	note E_, 2
	octave 1
	note A_, 2
	octave 2
	note A_, 4
	note E_, 2
	note D_, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	note E_, 2
	endchannel

.repeat15
	note A_, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
.sub2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	octave 1
	note A_, 2
	octave 2
	loopchannel 3, .repeat15
	note D_, 2
	note A_, 2
.repeat16
	note D_, 2
	octave 1
	note A_, 2
	octave 2
	loopchannel 3, .repeat16
	endchannel

.sub3
	note A_, 2
	note D_, 2
	note A_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	octave 3
	note C_, 2
	octave 2
	endchannel

.sub4
	note B_, 2
	octave 2
	note F_, 2
	note B_, 2
	octave 1
	note B_, 2
	octave 2
	note F_, 2
	note B_, 2
	octave 1
	note B_, 2
	octave 2
	note F_, 2
.sub5
	octave 1
	loopchannel 3, .sub4
	endchannel
