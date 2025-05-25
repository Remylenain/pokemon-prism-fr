Music_JohtoGymBattle:
	channelcount 4
	channel 1, Music_JohtoGymBattle_Ch1
	channel 2, Music_JohtoGymBattle_Ch2
	channel 3, Music_JohtoGymBattle_Ch3
	channel 4, Music_JohtoGymBattle_Ch4

Music_JohtoGymBattle_Ch1:
	tempo 101
	volume $77
	dutycycle $3
	tone $0002
	vibrato $12, $15
	notetype $c, $b2
.repeat1
	octave 3
	note A#, 1
	note A_, 1
	note G#, 1
	note A_, 1
	loopchannel 4, .repeat1
.repeat2
	note C#, 1
	note C_, 1
	octave 2
	note A#, 1
	octave 3
	note C_, 1
	loopchannel 3, .repeat2
	intensity $4b
	note C#, 4
	intensity $b2
	note D_, 6
	note D#, 6
	note C_, 4
	note F_, 6
	note D_, 6
	note D#, 4
	note D_, 6
	note D#, 6
	note C_, 4
	note F_, 6
	note G_, 6
	intensity $b7
	note C_, 4
	intensity $b2
	note G_, 6
	note G#, 6
	note F_, 4
	note G#, 6
	note F_, 6
	note G#, 4
	note G_, 6
	note G#, 6
	note F_, 4
	note G#, 6
	octave 4
	note C_, 6
	octave 3
	note G#, 2
	note F_, 2
.loop
	stereopanning $f
	callchannel .sub
	note G#, 12
	intensity $b2
	note G_, 4
	intensity $b7
	octave 4
	note C#, 12
	intensity $b2
	note C_, 4
	octave 3
	callchannel .sub
	note G#, 8
	note G_, 8
	note F_, 8
	note D#, 8
	intensity $70
	note C_, 8
	intensity $77
	note C_, 8
	intensity $b4
	note D#, 2
	note E_, 2
	note F_, 6
	note G_, 2
	note D#, 4
	intensity $77
	octave 2
	note A#, 8
	note A#, 8
	intensity $c5
	octave 3
	note G_, 2
	note G#, 2
	note A#, 6
	note A#, 2
	note G#, 4
	intensity $c7
	note G_, 8
	note F_, 4
	note E_, 2
	note C#, 2
	intensity $a0
	note C_, 8
	intensity $a7
	note C_, 8
	intensity $b2
	note F_, 6
	note F_, 4
	note E_, 2
	note F_, 4
	note F_, 6
	note F_, 6
	note F_, 2
	note G#, 2
	note E_, 6
	note E_, 4
	note F_, 2
	note E_, 2
	note C#, 2
	note C_, 6
	note C_, 6
	note C_, 4
	note F_, 6
	note F_, 2
	note G#, 2
	note E_, 2
	note F_, 2
	note G#, 2
	note F_, 2
	note C_, 4
	note F_, 6
	note E_, 2
	note G#, 2
	note E_, 2
	note G_, 4
	note E_, 4
	note F_, 2
	note E_, 2
	note F_, 2
	note G_, 6
	note G_, 4
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note C_, 2
	note C_, 6
	note C_, 6
	note C_, 4
	note C#, 6
	note C#, 6
	note C#, 4
	note D_, 6
	note D_, 6
	note D_, 4
	note D#, 6
	note D#, 6
	note D#, 4
	intensity $80
	note G_, 16
	intensity $90
	note G#, 16
	intensity $a0
	note A_, 8
	note A#, 2
	note A_, 2
	note G#, 2
	note A_, 2
	intensity $b0
	note A#, 8
	note B_, 2
	note A#, 2
	note A_, 2
	octave 4
	note C#, 2
	intensity $b7
	note C_, 8
	note C#, 4
	note C_, 4
	octave 3
	note G#, 2
	octave 4
	note C_, 2
	octave 3
	note G#, 2
	octave 4
	note D#, 2
	octave 3
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note C_, 2
	note G#, 4
	note D#, 4
	note G#, 4
	note D#, 4
	note D#, 4
	octave 3
	note G#, 4
	octave 4
	note D#, 4
	octave 3
	note G#, 4
	note G#, 8
	note A_, 4
	note G#, 4
	note D#, 2
	note G#, 2
	note D#, 2
	octave 4
	note C#, 2
	octave 3
	note D#, 2
	note A_, 2
	note D#, 2
	note G_, 2
	octave 4
	note C#, 4
	octave 3
	note G#, 4
	octave 4
	note C#, 4
	octave 3
	note G#, 4
	note G#, 4
	note C#, 4
	note G#, 4
	note C#, 4
	note B_, 8
	note A_, 8
	note G#, 8
	note F#, 8
	intensity $b4
	note A_, 4
	octave 4
	note C#, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	intensity $92
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	intensity $b2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	intensity $c2
	note D#, 16
	intensity $50
	octave 3
	note C_, 16
	note F_, 16
	note E_, 16
	intensity $97
	note D#, 10
	intensity $b4
	octave 2
	note A#, 2
	octave 3
	note D#, 2
	note F#, 2
	jumpchannel .loop

.sub
	intensity $b5
	note D_, 6
	note G_, 6
	note F_, 2
	note G_, 2
	note G#, 4
	note G_, 4
	note F_, 4
	note G_, 4
	intensity $b7
	endchannel

Music_JohtoGymBattle_Ch2:
	dutycycle $3
	vibrato $8, $36
	tone $0001
	notetype $c, $c2
.repeat1
	octave 4
	note F#, 1
	note F_, 1
	note E_, 1
	note A#, 1
	loopchannel 4, .repeat1
.repeat2
	note F#, 1
	note F_, 1
	note F#, 1
	note A#, 1
	loopchannel 4, .repeat2
	note A_, 6
	octave 3
	note A#, 6
	note G_, 4
	octave 4
	note D_, 6
	octave 3
	note A_, 6
	note A#, 4
	note A_, 6
	note A#, 6
	note G_, 4
	octave 4
	note D_, 6
	note D#, 6
	intensity $b0
	octave 3
	note D#, 4
	callchannel .sub1
	note C_, 4
	note G_, 2
	intensity $92
	octave 3
	note D_, 2
	note D_, 2
	intensity $c2
	octave 4
	note D_, 4
	intensity $92
	octave 3
	note D_, 2
	intensity $c2
	octave 4
	note D#, 2
	intensity $92
	octave 3
	note D#, 2
	callchannel .sub1
	note C_, 2
	intensity $92
	octave 3
	note D#, 2
	intensity $c2
	octave 4
	note G_, 2
	callchannel .sub2
	note G#, 2
	callchannel .sub2
	note F#, 2
	intensity $b2
	octave 3
	stereopanning $f0
	note G#, 1
	note A_, 1
.loop
	callchannel .sub3
	note F_, 6
	intensity $b7
	note F_, 6
	intensity $c2
	note D#, 4
	intensity $b0
	note G#, 6
	intensity $b7
	note G#, 6
	intensity $c2
	note F_, 4
	octave 3
	callchannel .sub3
	note C#, 16
	intensity $b7
	note C#, 16
	intensity $a4
	octave 3
	note F_, 6
	note D#, 6
	note F_, 4
	intensity $c6
	octave 4
	note C_, 6
	octave 3
	note A#, 6
	octave 4
	note C_, 4
	intensity $a4
	octave 3
	note C#, 6
	note C_, 6
	note C#, 4
	intensity $c6
	octave 4
	note C#, 6
	note C_, 6
	note C#, 4
	intensity $3c
	note C_, 10
	intensity $b7
	note C_, 6
	intensity $b0
	note E_, 8
	intensity $b7
	note E_, 8
	intensity $b0
	octave 3
	note C#, 16
	octave 2
	note A#, 8
	octave 3
	note C#, 6
	note D#, 2
	note C_, 16
	note E_, 16
	intensity $a0
	octave 5
	note C#, 4
	intensity $a7
	octave 5
	note C#, 12
	intensity $b7
	octave 4
	note A#, 8
	octave 5
	note C#, 6
	note D#, 2
	intensity $a0
	note C_, 8
	intensity $a7
	note C_, 8
	intensity $3e
	note E_, 6
	intensity $a6
	note E_, 10
	intensity $c2
	octave 3
	note F_, 6
	note F_, 6
	note F_, 4
	note F#, 6
	note F#, 6
	note F#, 4
	note G_, 6
	note G_, 6
	note G_, 4
	note G#, 6
	note G#, 6
	note G#, 4
	intensity $90
	octave 4
	note C_, 16
	intensity $a0
	note C#, 16
	intensity $b0
	note D_, 16
	intensity $b7
	note D#, 8
	intensity $4c
	note D#, 6
	intensity $c2
	note F#, 1
	note G_, 1
	intensity $c7
	note G#, 8
	note A_, 2
	note G#, 2
	note F#, 2
	note A_, 2
	note G#, 4
	octave 5
	note C_, 4
	octave 4
	note A_, 4
	note G#, 4
	octave 5
	note D#, 4
	octave 4
	note G#, 4
	octave 5
	note D#, 4
	octave 4
	note G#, 4
	octave 5
	note D#, 2
	note C#, 2
	note C_, 2
	note C#, 2
	note C_, 2
	octave 4
	note A_, 2
	note G#, 2
	note A_, 2
	note D#, 8
	note E_, 2
	note D#, 2
	note C#, 2
	note E_, 2
	note D#, 4
	note G#, 4
	note E_, 4
	note C#, 4
	note G#, 4
	note C#, 4
	note G#, 4
	note C#, 4
	note A_, 2
	note G#, 2
	note F#, 2
	note E_, 2
	note D#, 2
	note E_, 2
	note D#, 2
	note C#, 2
	note D#, 8
	note C#, 8
	octave 3
	note B_, 8
	note A_, 8
	octave 4
	note D#, 4
	note G#, 4
	note E_, 4
	note A_, 4
	intensity $c0
	note G#, 8
	intensity $c7
	note G#, 8
	intensity $c2
	note G#, 16
	intensity $80
	octave 3
	note F_, 16
	octave 4
	note C_, 16
	octave 3
	note B_, 16
	note G_, 16
	jumpchannel .loop

.sub1
	intensity $c2
	octave 4
	note D_, 2
	intensity $92
	octave 3
	note D_, 2
	note D_, 2
	intensity $c2
	octave 4
	note D#, 4
	intensity $92
	octave 3
	note D_, 2
	intensity $c2
	octave 4
	endchannel

.sub2
	intensity $92
	octave 3
	note F_, 2
	note F_, 2
	intensity $c2
	octave 4
	endchannel

.sub3
	intensity $c7
	note A#, 8
	intensity $c4
	octave 4
	note D_, 2
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	intensity $c7
	note C#, 8
	intensity $c4
	note F_, 2
	note D#, 2
	note C#, 2
	note D#, 2
	intensity $b0
	endchannel

Music_JohtoGymBattle_Ch3:
	notetype $c, $19
	octave 4
	note F_, 1
	note __, 1
	octave 3
	note A_, 2
	octave 4
	note F_, 1
	note __, 1
	octave 3
	note G#, 2
	octave 4
	note F_, 1
	note __, 1
	octave 3
	note G_, 2
	octave 4
	note F_, 1
	note __, 1
	octave 3
	note F#, 2
	octave 4
	note G#, 1
	note __, 1
	octave 3
	note F_, 2
	octave 4
	note G#, 1
	note __, 1
	octave 3
	note E_, 2
	note F_, 2
	note G_, 2
	note G#, 4
	callchannel .sub1
	note D#, 2
	note F#, 4
	callchannel .sub1
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	note G#, 2
.loop
	callchannel .sub2
.repeat1
	note C#, 2
	note G#, 2
	loopchannel 6, .repeat1
	note C#, 2
	note A#, 2
	note A_, 2
	note G#, 2
	callchannel .sub3
	note G#, 2
	note G_, 2
.repeat2
	note C#, 2
	note G#, 2
	loopchannel 8, .repeat2
	note C_, 2
	note G_, 2
	note A#, 2
	note C_, 2
	note D#, 2
	note F_, 2
	note G_, 2
	note A#, 2
.repeat3
	note C_, 2
	note G_, 2
	loopchannel 4, .repeat3
	callchannel .sub4
	note G_, 2
	note G#, 2
	note F_, 2
	callchannel .sub5
	note C_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	callchannel .sub4
	note C_, 2
	note C#, 2
	note G#, 2
	callchannel .sub5
	note F_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	callchannel .sub4
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note G#, 2
	callchannel .sub6
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	note G_, 2
	note F_, 2
	note G_, 2
	callchannel .sub7
	note __, 2
	callchannel .sub8
	octave 4
	note C#, 2
	callchannel .sub9
	note __, 2
	note D#, 2
	note A#, 2
	octave 4
	note D#, 2
	octave 3
	note D#, 2
	note A#, 2
	octave 4
	note D#, 2
	octave 3
	note D#, 2
	octave 4
	note D#, 2
	callchannel .sub7
	note G_, 2
	callchannel .sub8
	note G#, 2
	callchannel .sub9
	note A_, 2
	octave 4
	note D#, 2
	octave 3
	note A#, 2
	note D#, 2
	octave 4
	note D#, 2
	octave 3
	note D#, 2
	octave 4
	note D#, 2
	note D_, 4
	octave 3
	callchannel .sub10
	octave 4
	note C#, 2
	octave 3
	note D#, 2
	note A_, 2
	note D#, 2
	note G#, 2
	callchannel .sub11
	note A_, 2
	note G#, 2
	note F#, 2
.repeat4
	note C#, 2
	note F#, 2
	loopchannel 5, .repeat4
	note C#, 2
	octave 4
	note C#, 2
	octave 3
	note C#, 2
	note A_, 2
	note C#, 2
	note G_, 2
.repeat5
	note C#, 2
	note F#, 2
	loopchannel 6, .repeat5
	note C#, 2
	note D#, 2
	note E_, 2
	note A_, 2
	callchannel .sub11
	note G#, 2
	note A_, 2
	octave 4
	note C#, 2
	octave 3
	note D#, 2
	note G#, 2
	note D#, 2
	note A_, 2
	note D#, 2
	note B_, 2
	note D#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	note D#, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note G#, 2
	note D#, 2
	note F#, 2
	note G#, 2
	note F#, 2
	note F#, 2
	note E_, 2
	note F#, 2
	callchannel .sub12
	note D#, 2
	note C#, 2
	note D#, 2
	callchannel .sub12
	note F#, 2
	note F_, 2
	note D#, 2
	jumpchannel .loop

.subrepeat
	note F_, 2
	note F_, 2
	note D#, 2
	note F_, 2
.sub1
	note G_, 2
	note D_, 2
	note F_, 2
	note G_, 2
	note G#, 2
	note G#, 2
	note G_, 2
	note F_, 2
	note G_, 2
	note D_, 2
	note F_, 2
	note G_, 2
	loopchannel 2, .subrepeat
	note G#, 2
	endchannel

.sub2
	note D_, 2
	note G_, 2
.sub3
	loopchannel 8, .sub2
	endchannel

.sub4
	note C#, 2
	note G#, 2
	loopchannel 4, .sub4
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	endchannel

.sub5
	note C_, 2
	note G_, 2
.sub6
	loopchannel 6, .sub5
	endchannel

.sub7
	octave 3
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	loopchannel 2, .sub7
	octave 3
	note C_, 2
	endchannel

.sub8
	note C#, 2
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	loopchannel 2, .sub8
	note C#, 2
	endchannel

.sub9
	octave 3
	note D_, 2
	note A_, 2
	octave 4
	note D_, 2
	loopchannel 2, .sub9
	octave 3
	note D_, 2
	endchannel

.sub11
	note D#, 2
	note G#, 2
.sub10
	loopchannel 6, .sub11
	note D#, 2
	endchannel

.sub12
	note F_, 2
	note C_, 2
	note D#, 2
	note F_, 2
	note F#, 2
	note F#, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note C_, 2
	note D#, 2
	note F_, 2
	note D#, 2
	endchannel

Music_JohtoGymBattle_Ch4:
	togglenoise 3
	notetype $C
	note C_, 2
	note __, 2
	note C_, 2
	note __, 2
	note C_, 2
	note __, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 1
	note C_, 1
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note B_, 4
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
Music_JohtoGymBattle_Ch4_loop:
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 1
	note C_, 1
	note B_, 4
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 1
	note C_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note B_, 4
	note __, 4
	note B_, 4
	note __, 4
	note B_, 4
	note __, 4
	note B_, 4
	note D_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note D#, 2
	note D#, 2
	note G#, 2
	note G#, 2
	note D_, 2
	note D_, 2
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note G#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note G_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	jumpchannel Music_JohtoGymBattle_Ch4_loop
