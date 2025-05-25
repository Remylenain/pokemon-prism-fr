Music_TunodGymBattle:
	channelcount 4
	channel 1, Music_TunodGymBattle_Ch1
	channel 2, Music_TunodGymBattle_Ch2
	channel 3, Music_TunodGymBattle_Ch3
	channel 4, Music_TunodGymBattle_Ch4

Music_TunodGymBattle_Ch1:
	tempo 100
	dutycycle 1
	tone $0001
	notetype $c, $c4
	vibrato $12, $15
	octave 5
	stereopanning $f
	note C_, 1
	octave 4
	note B_, 1
	note A#, 1
	note A_, 1
	stereopanning $f0
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	stereopanning $f
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	stereopanning $f0
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	stereopanning $f
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	stereopanning $f0
	note C_, 1
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
	stereopanning $f
	octave 4
	note C_, 1
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
	stereopanning $f0
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	stereopanning $ff
	callchannel .sub1
	note C#, 4
	callchannel .sub1
	octave 4
	note C#, 4
	octave 5
	note C_, 2
	note __, 4
	note C#, 2
	note __, 4
	octave 4
	callchannel .sub2
	note C#, 4
	octave 5
	note C_, 2
	note __, 4
	note C#, 2
	note __, 4
	octave 4
	note G_, 2
	note __, 2
	octave 5
	note C_, 2
	note __, 4
	note C#, 2
	note __, 4
	note D#, 4
.loop
	stereopanning $f0
	dutycycle 1
	intensity $c7
	callchannel .sub3
	note G_, 8
	intensity $c7
	note G_, 8
	callchannel .sub4
	note D_, 4
	intensity $c0
	note C_, 8
	intensity $c7
	note C_, 8
	vibrato $11, $26
	callchannel .sub3
	note G_, 4
	intensity $c7
	note G_, 6
	note G_, 2
	octave 5
	note C_, 2
	note __, 2
	octave 4
	callchannel .sub4
	note C_, 4
	intensity $c0
	note G_, 6
	intensity $c7
	note G_, 10
	dutycycle 3
	octave 3
	intensity $c4
	note C_, 6
	octave 2
	note A#, 6
	octave 3
	note C_, 4
	note D_, 6
	octave 2
	note A#, 6
	octave 3
	note D_, 4
	intensity $c0
	note C_, 4
	intensity $c4
	note C_, 12
	note __, 16
	note __, 16
	note __, 16
	intensity $90
	octave 3
	callchannel Music_TunodGymBattle_Common_1
	octave 2
	note A#, 2
	octave 3
	note C#, 16
	note D#, 16
	note C_, 16
	octave 4
	intensity $a0
	note C_, 11
	notetype $3, $a0
	note C_, 3
	note __, 1
	notetype $c, $a0
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C#, 16
	note D#, 16
.repeat
	note F_, 16
	loopchannel 6, .repeat
	intensity $a0
	octave 3
	note C_, 8
	intensity $a7
	note C_, 8
	octave 2
	note A#, 7
	octave 3
	note C_, 1
	note D_, 8
	intensity $a0
	octave 2
	note G_, 8
	intensity $a7
	note G_, 8
	intensity $a0
	octave 3
	note C_, 8
	intensity $a7
	note C_, 8
	intensity $a0
	note C#, 8
	intensity $a7
	note C#, 8
	octave 2
	note A#, 8
	octave 3
	note C#, 6
	note E_, 2
	intensity $a0
	note C_, 8
	intensity $a7
	note C_, 8
	intensity $a0
	note E_, 8
	intensity $a7
	note E_, 8
	jumpchannel .loop

.sub1
	octave 4
	note C_, 2
	note __, 4
	note C#, 2
	note __, 4
	octave 3
.sub2
	note C_, 2
	note __, 2
	note G_, 2
	note __, 4
	note G#, 2
	note __, 4
	endchannel

.sub3
	octave 4
	note C_, 8
	octave 3
	note A#, 8
	octave 4
	note D_, 6
	octave 3
	note G_, 2
	note __, 2
	note G_, 2
	note A#, 2
	octave 4
	note D_, 2
	intensity $c0
	note E_, 6
	intensity $c7
	note E_, 6
	note D_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note __, 2
	note C_, 10
	note A#, 8
	note A_, 8
	note G_, 4
	note A_, 4
	note G_, 4
	note F_, 4
	intensity $c0
	note E_, 6
	intensity $c7
	note E_, 6
	note C_, 4
	intensity $c0
	endchannel

.sub4
	note A#, 8
	note A_, 8
	note A#, 4
	note A_, 4
	octave 5
	note D_, 4
	note F_, 4
	intensity $c0
	note E_, 6
	intensity $c7
	note E_, 6
	endchannel

Music_TunodGymBattle_Ch2:
	tone $0001
	dutycycle 2
	notetype $c, $94
	vibrato $12, $15
	octave 5
.repeat1
	note G_, 1
	note G#, 1
	note G_, 2
	loopchannel 8, .repeat1
	intensity $70
	octave 3
	note C_, 8
	octave 2
	note C_, 8
	note G_, 8
	note C#, 8
	octave 3
	note C_, 8
	note G_, 8
	octave 4
	note C_, 8
	octave 3
	note C#, 8
	dutycycle 1
	intensity $90
	note C_, 8
	octave 2
	note C_, 8
	note G_, 8
	note C#, 8
	octave 3
	note C_, 8
	octave 2
	note C_, 8
	octave 3
	note C#, 8
	octave 2
	note D#, 8
.loop
	stereopanning $f
	dutycycle 3
	intensity $c7
	octave 3
	note G_, 8
	note F_, 7
	note G#, 1
	note G_, 6
	note C_, 2
	note __, 2
	note C_, 2
	note D_, 2
	note F_, 2
	note G_, 6
	octave 4
	note C_, 6
	octave 3
	note A#, 2
	note A_, 2
	note A#, 2
	octave 4
	note C_, 2
	note __, 2
	octave 3
	intensity $97
	octave 3
	note E_, 2
	note E_, 2
	note E_, 2
	note E_, 2
	note E_, 2
	callchannel .sub1
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	octave 5
	note C_, 2
	note F_, 4
	note E_, 2
	note D_, 2
	note C_, 2
	octave 4
	note A#, 2
	note F_, 2
	note A#, 2
	octave 5
	note D_, 4
	note C_, 2
	octave 4
	note A#, 2
	octave 5
	note D_, 2
	note E_, 6
	note C_, 6
	note D_, 2
	note E_, 2
	note F_, 2
	octave 5
	note E_, 2
	note __, 2
	note C_, 10
	dutycycle 3
	callchannel .sub1
	dutycycle 3
	intensity $a4
	octave 3
	note G_, 6
	note F_, 6
	note G_, 4
	note A_, 6
	note F_, 6
	note A_, 4
	intensity $a0
	note G_, 4
	intensity $a4
	note G_, 12
	intensity $90
	octave 2
	callchannel Music_TunodGymBattle_Common_2
	jumpchannel .skip
.repeat2
	callchannel Music_TunodGymBattle_Common_1
.skip
	octave 1
	note A#, 2
	octave 2
	note C#, 16
	note D#, 16
	loopchannel 3, .repeat2
	octave 1
	note A#, 16
	note A#, 16
	dutycycle 0
	octave 3
	intensity $a7
	note A#, 2
	note A#, 2
	note A#, 6
	note A#, 2
	note A#, 2
	note A#, 2
	note F_, 2
	note F_, 2
	note F_, 6
	note F_, 2
	note F_, 2
	note F_, 2
	note D#, 2
	note D#, 2
	note D#, 6
	note D#, 2
	note D#, 2
	note D#, 2
	note D_, 2
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 2
	note D_, 2
	intensity $84
.repeat3
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	note G_, 2
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	loopchannel 2, .repeat3
	callchannel .sub2
	dutycycle 0
.repeat4
	note G#, 2
	note C#, 2
	note G#, 2
	octave 4
	note C#, 2
	note G#, 2
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	loopchannel 2, .repeat4
	callchannel .sub2
	jumpchannel .loop

.sub1
	intensity $c7
	octave 4
	note D_, 8
	note C_, 8
	octave 3
	note A#, 4
	octave 4
	note C_, 4
	octave 3
	note A#, 4
	note A_, 4
	intensity $c0
	note G_, 6
	intensity $c7
	note G_, 6
	note E_, 4
	octave 4
	intensity $c0
	note C_, 4
	intensity $c7
	note C_, 6
	intensity $a7
	dutycycle 0
	note E_, 2
	note C_, 2
	octave 3
	note G_, 2
.repeat5
	note F_, 2
	note A#, 2
	octave 4
	note D_, 2
	note F_, 2
	note A_, 2
	note F_, 2
	note D_, 2
	octave 3
	note A#, 2
	loopchannel 2, .repeat5
.repeat6
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	note E_, 2
	note G_, 2
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	note E_, 2
	note C_, 2
	loopchannel 2, .repeat6
	endchannel

.sub2
	dutycycle 1
.repeat7
	note G_, 2
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	note E_, 2
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	loopchannel 2, .repeat7
	endchannel

Music_TunodGymBattle_Common_1:
	note C_, 16
Music_TunodGymBattle_Common_2:
	note C_, 11
	notetype $3, $90
	note C_, 3
	note __, 1
	notetype $c, $90
	note C_, 2
	endchannel

Music_TunodGymBattle_Ch3:
	stereopanning $ff
	notetype $c, $19
	octave 3
	note C_, 4
	octave 2
	note C_, 4
	note A#, 4
	note C#, 4
	note G#, 4
	note A#, 2
	note G#, 2
	note G_, 2
	note F_, 2
	note D#, 2
	note C#, 2
.repeat1
	callchannel .sub1
	note F_, 2
	callchannel .sub1
	note C#, 2
	loopchannel 4, .repeat1
.loop
	callchannel .sub2
	note C_, 2
	note D_, 2
	callchannel .sub3
	note G_, 2
	note C_, 2
	note D_, 2
	note C_, 2
	callchannel .sub4
	octave 1
	note A#, 2
	note B_, 2
	octave 2
	callchannel .sub2
	note E_, 2
	note G_, 2
	callchannel .sub5
	callchannel .sub2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
.repeat2
	note C_, 2
	note G_, 2
	loopchannel 13, .repeat2
	note __, 2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 2
	note D_, 2
	note C_, 2
	callchannel .sub4
	octave 1
	note A#, 2
	note B_, 2
	octave 2
	callchannel .sub2
	note E_, 2
	note C_, 2
	callchannel .sub5
	callchannel .sub2
	note E_, 2
	note G_, 2
	callchannel .sub6
.repeat3
	callchannel .sub6
	rept 4
		note C#, 2
		note G#, 2
	endr
	rept 4
		note D#, 2
		note A#, 2
	endr
	loopchannel 3, .repeat3
.repeat4
	octave 1
	note A#, 2
	octave 2
	note F_, 2
	loopchannel 24, .repeat4
.repeat5
	note C_, 2
	note G_, 2
	loopchannel 16, .repeat5
	callchannel .sub5
	callchannel .sub6
	jumpchannel .loop

.sub1
	note C_, 2
	note F#, 2
	note F_, 2
	note D#, 2
	note F#, 2
	note D#, 1
	note __, 1
	note D#, 2
	endchannel

.sub6
	note C_, 2
	note G_, 2
.sub2
	note C_, 2
	note G_, 2
.sub3
	rept 6
		note C_, 2
		note G_, 2
	endr
	endchannel

.sub5
	octave 1
	note A#, 2
	octave 2
	note F_, 2
.sub4
	loopchannel 8, .sub5
	endchannel


Music_TunodGymBattle_Ch4:
	togglenoise $3
	notetype $c
	note C_, 6
	note C_, 8
	note D#, 4
	note C_, 6
	note C_, 4
	note D#, 4
.repeat1
	note C_, 6
	note C_, 10
	loopchannel 8, .repeat1
.loop
	callchannel .sub
	callchannel .sub
	note C_, 6
	note C_, 10
	note C_, 6
	note C_, 8
	note D#, 2
	note C_, 6
	note C_, 10
.repeat2
	note C_, 6
	note C_, 8
	note D#, 2
	loopchannel 17, .repeat2
.repeat3
	note C_, 8
	note C_, 2
	note C_, 4
	note C_, 2
	loopchannel 6, .repeat3
	note __, 4
	note C_, 4
	note C_, 2
	note C_, 4
	note C_, 2
	note C_, 8
	note C_, 2
	note C_, 6
	jumpchannel .loop

.sub
	note C_, 6
	note C_, 8
	note D#, 2
	loopchannel 11, .sub
	note C_, 6
	note C_, 10
	endchannel
