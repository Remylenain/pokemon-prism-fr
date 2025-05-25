Music_NaljoGymBattle:
	channelcount 3
	channel 1, Music_NaljoGymBattle_Ch1
	channel 2, Music_NaljoGymBattle_Ch2
	channel 3, Music_NaljoGymBattle_Ch3

Music_RijonElite4Battle:
	channelcount 3
	channel 1, Music_RijonElite4Battle_Ch1
	channel 2, Music_RijonElite4Battle_Ch2
	channel 3, Music_RijonElite4Battle_Ch3

Music_RijonElite4Battle_Ch1:
	forceoctave 2
Music_NaljoGymBattle_Ch1:
	tempo 101
	volume $77
	notetype $c, $b2
	dutycycle $3
	tone $0002
	vibrato $12, $15
	octave 2
	callchannel .sub1
	note F#, 1
	note F_, 1
	note F#, 1
	note G_, 1
	note G#, 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	note C#, 1
	callchannel .sub1
	intensity $b4
	callchannel .sub2
	note A#, 4
	callchannel .sub2
	intensity $b2
	note A#, 2
	octave 4
	note A_, 1
	octave 5
	note C_, 1
	intensity $b4
	callchannel .sub3
	note C_, 4
	note D#, 4
	callchannel .sub3
	note D#, 4
	note F_, 4
	intensity $b2
.loop
	stereopanning $f
	octave 3
	note F_, 2
	note D_, 2
	note F_, 2
	note A_, 4
	note F_, 2
	note D_, 2
	note D#, 2
	note F_, 2
	note D_, 2
	note F_, 2
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	note A_, 2
	octave 5
	note D_, 6
	octave 3
	note D_, 6
	note D_, 6
	note D_, 6
	note C_, 4
	note D#, 4
	note F_, 2
	note D_, 2
	note F_, 2
	note A_, 4
	note D#, 2
	note C_, 2
	note D#, 2
	octave 4
	note D_, 4
	octave 3
	note A_, 2
	octave 4
	note D_, 4
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	note D#, 2
	intensity $b7
	note F_, 16
	note __, 12
	intensity $b4
	note C_, 4
	octave 3
	note A#, 6
	note F_, 6
	note D_, 2
	note E_, 2
	note F_, 6
	note A#, 6
	note A#, 2
	octave 4
	note D_, 2
	note F_, 8
	note C_, 8
	note F_, 6
	note C_, 6
	note F_, 4
	intensity $b7
	octave 3
	note A#, 16
	note F_, 16
	octave 4
	note C_, 16
	octave 3
	note E_, 15
	octave 5
	note C_, 1
	note D_, 6
	intensity $b2
	octave 3
	callchannel .sub4
	note C_, 4
	note D#, 4
	octave 4
	note D_, 6
	intensity $b2
	octave 3
	note A_, 6
	intensity $b4
	note A_, 6
	intensity $b2
	note A_, 6
	note G_, 2
	note F_, 2
	note E_, 2
	note C_, 2
	intensity $b7
	note D_, 16
	note C_, 16
	octave 2
	note F_, 16
	note E_, 16
	note F_, 16
	note __, 16
	note F_, 16
	note E_, 14
	intensity $b2
	dutycycle $2
	octave 3
	note A_, 1
	octave 4
	note C_, 1
	note D_, 2
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 4
	note E_, 2
	note F_, 2
	note D_, 2
	note G_, 2
	note F_, 2
	note G_, 2
	note A_, 4
	note A#, 2
	note A_, 2
	note A#, 2
	intensity $b7
	octave 5
	note C_, 16
	note __, 16
	intensity $b4
	octave 3
	note A_, 8
	note G_, 8
	note F_, 8
	note E_, 8
	note C_, 8
	note D_, 8
	note E_, 8
	note G_, 8
	note A_, 2
	note G_, 2
	note F_, 2
	note G_, 2
	note A_, 4
	note F_, 2
	note G_, 2
	note A_, 4
	note F_, 4
	note D_, 4
	note A_, 4
	note A#, 2
	note A_, 2
	note G_, 2
	note A_, 2
	note A#, 4
	note G_, 2
	note A_, 2
	note A#, 4
	note F_, 4
	note D_, 4
	note A#, 4
	note A_, 2
	note G_, 2
	note F_, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 4
	note A_, 4
	octave 4
	note D_, 4
	note E_, 4
	intensity $b7
	note F_, 16
	note E_, 12
	intensity $b2
	dutycycle $3
	note F_, 2
	note E_, 2
	jumpchannel .loop

.sub1
	note D_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note F_, 1
	endchannel

.sub2
	note A_, 6
	intensity $b2
	note A_, 6
	intensity $b4
	loopchannel 2, .sub2
	note G_, 4
	endchannel

.sub3
	note D_, 6
	intensity $b2
.sub4
	note D_, 6
	intensity $b4
	loopchannel 2, .sub3
	endchannel

Music_RijonElite4Battle_Ch2:
	forceoctave 2
Music_NaljoGymBattle_Ch2:
	notetype $c, $c2
	dutycycle $3
	vibrato $8, $36
	tone $0001
.repeat
	octave 5
	note D_, 1
	note C#, 1
	note C_, 1
	octave 4
	note B_, 1
	loopchannel 8, .repeat
	note D_, 6
	note D_, 6
	note D_, 6
	note D_, 6
	note C_, 4
	note D#, 4
	note D_, 6
	note D_, 6
	note D_, 6
	note D_, 6
	note D#, 4
	note C_, 4
	note A_, 6
	note A_, 6
	note A_, 6
	note A_, 6
	note G_, 4
	note A#, 4
	note A_, 6
	note A_, 6
	note A_, 6
	note A_, 6
	note G_, 4
	note A#, 2
	stereopanning $f0
	octave 3
	note A_, 1
	octave 4
	note C_, 1
.loop
	intensity $c7
	note D_, 6
	note D#, 6
	note F_, 4
	note G_, 6
	note A_, 6
	note D#, 4
	note D_, 16
	note __, 14
	octave 3
	note A_, 1
	octave 4
	note C_, 1
	note D_, 6
	note D#, 6
	note F_, 4
	note G_, 6
	note A_, 6
	note A#, 4
	note A_, 16
	note __, 12
	note F_, 2
	note E_, 2
	note D_, 6
	octave 3
	note A#, 6
	note F_, 4
	note A#, 6
	octave 4
	note D_, 6
	note F_, 2
	note G_, 2
	note A_, 4
	note G_, 4
	note F_, 4
	note G_, 4
	note A_, 6
	note G_, 6
	note F_, 4
	note D_, 16
	note __, 14
	note E_, 1
	note F_, 1
	note E_, 16
	note __, 12
	note F_, 2
	note E_, 2
	intensity $c3
	note D_, 6
	octave 3
	note A_, 6
	note A_, 6
	note A_, 6
	note A#, 2
	note A_, 2
	note G_, 2
	note A#, 2
	octave 5
	note D_, 6
	octave 3
	note D_, 6
	note D_, 6
	note D_, 6
	note D#, 4
	note C_, 4
	intensity $c7
	octave 2
	note A_, 16
	note G_, 16
	note A#, 16
	note A_, 12
	note F_, 2
	note G_, 2
	note A_, 16
	note __, 16
	note A_, 16
	note __, 16
	octave 3
	note A_, 8
	note G_, 8
	note F_, 8
	note E_, 8
	note C_, 16
	note __, 4
	intensity $c3
	note D_, 4
	note E_, 4
	note G_, 4
	note A_, 2
	note F_, 2
	note D_, 2
	note A_, 4
	note F_, 2
	note D_, 2
	note A_, 2
	note A#, 2
	note F_, 2
	note D_, 2
	note A#, 4
	note F_, 2
	note D_, 2
	note A#, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note E_, 2
	octave 4
	note C_, 4
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	note D_, 2
	intensity $c7
	note E_, 16
	note D_, 16
	note D_, 12
	note D_, 2
	note E_, 2
	note F_, 16
	note F_, 12
	note F_, 2
	note G_, 2
	note A_, 16
	note A_, 12
	note A_, 2
	note A#, 2
	note A_, 16
	note G_, 16
	jumpchannel .loop

Music_RijonElite4Battle_Ch3:
	forceoctave 2
Music_NaljoGymBattle_Ch3:
	notetype $4, $19
	octave 3
.repeat1
	note D_, 11
	note __, 1
	note D_, 3
	note __, 1
	note D_, 3
	note __, 1
	note D_, 3
	note __, 1
	loopchannel 2, .repeat1
	notetype $c, $19
	note D_, 8
	note D#, 8
	callchannel .sub1
	callchannel .sub2
	callchannel .sub1
	callchannel .sub2
.loop
	callchannel .sub1
	callchannel .sub2
	callchannel .sub1
.repeat2
	note D_, 2
	note A_, 2
	loopchannel 7, .repeat2
	note C_, 2
	note G_, 2
	callchannel .sub3
.repeat3
	note C_, 2
	note F_, 2
	loopchannel 8, .repeat3
	callchannel .sub4
	octave 2
	note B_, 2
	octave 3
	note F_, 2
.repeat4
	note C_, 2
	note G_, 2
	loopchannel 5, .repeat4
	note C_, 2
	note C_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note G_, 2
.repeat5
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	loopchannel 20, .repeat5
.repeat6
	octave 1
	note G_, 2
	octave 2
	note C_, 2
	loopchannel 4, .repeat6
	octave 1
.repeat7
	note F_, 2
	note A#, 2
	loopchannel 4, .repeat7
.repeat8
	note E_, 2
	note A_, 2
	loopchannel 4, .repeat8
.repeat9
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	loopchannel 10, .repeat9
	note D_, 2
	note A_, 2
	note D_, 2
	note A_, 2
	note A_, 2
	octave 3
	note D_, 2
	octave 2
	note A_, 2
	octave 3
	note D_, 2
	octave 2
	note A_, 2
	note D_, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	octave 3
.repeat10
	note D_, 2
	note A_, 2
	loopchannel 8, .repeat10
	callchannel .sub5
	callchannel .sub6
	callchannel .sub5
	note D_, 2
	note A_, 2
	note D_, 2
	note D_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note A_, 2
	callchannel .sub7
	octave 2
	note A#, 2
	note A#, 2
	octave 3
	note F_, 2
	note E_, 2
	note D_, 2
	note F_, 2
.repeat11
	note D_, 2
	note A_, 2
	loopchannel 5, .repeat11
	note D_, 2
	note D_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note G_, 2
.repeat12
	note C_, 2
	note F_, 2
	loopchannel 4, .repeat12
.repeat13
	note C_, 2
	note G_, 2
	loopchannel 4, .repeat13
	jumpchannel .loop

.sub1
	note D_, 2
	note A_, 2
	loopchannel 6, .sub1
	note D_, 2
	note F_, 2
	note A_, 2
	note F_, 2
	endchannel

.sub2
	note D_, 2
	note A_, 2
	loopchannel 5, .sub2
	note A_, 2
	note D_, 2
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note F_, 2
	endchannel

.sub3
	octave 2
	note A#, 2
	octave 3
	note F_, 2
.sub4
	loopchannel 8, .sub3
	endchannel

.sub5
	note C_, 2
	note G_, 2
	loopchannel 8, .sub5
.subrepeat
	note D_, 2
	note A_, 2
	loopchannel 4, .subrepeat
	endchannel

.sub7
	octave 2
	note A#, 2
	octave 3
	note F_, 2
.sub6
	loopchannel 5, .sub7
	endchannel
