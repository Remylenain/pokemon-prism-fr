Music_ChampionBattle:
	channelcount 3
	channel 1, Music_ChampionBattle_Ch1
	channel 2, Music_ChampionBattle_Ch2
	channel 3, Music_ChampionBattle_Ch3

Music_ChampionBattle_Ch1:
	tempo 98
	volume $77
	dutycycle $3
	tone $0002
	vibrato $12, $15
	notetype $c, $b2
	octave 2
	note A#, 8
	note A#, 8
	note A#, 8
	note A#, 4
	intensity $b7
	note B_, 4
	jumpchannel .skip1
.repeat1
	note D#, 4
.skip1
	intensity $b2
	octave 2
	note A#, 2
	note A#, 6
	note A#, 2
	note A#, 6
	note A#, 2
	note A#, 6
	note A#, 2
	note A#, 2
	intensity $b7
	octave 3
	loopchannel 3, .repeat1
	note E_, 4
.repeat2
	callchannel .sub1
	note D#, 4
	loopchannel 3, .repeat2
	callchannel .sub1
	octave 2
	note B_, 4
.repeat3
	callchannel .sub1
	note D#, 4
	loopchannel 7, .repeat3
	callchannel .sub1
	octave 2
	note B_, 4
	callchannel .sub1
	note D#, 4
	callchannel .sub1
	note E_, 4
	callchannel .sub1
	note F#, 4
	callchannel .sub1
	note G#, 4
	intensity $a0
	note A#, 8
	octave 2
	note A#, 8
	octave 3
	note B_, 12
	intensity $b2
	note A#, 1
	note B_, 1
	octave 4
	note C_, 1
	note C#, 1
.loop
	stereopanning $f
	callchannel .sub2
	note F#, 4
	callchannel .sub3
	note G#, 4
	callchannel .sub3
	note G#, 4
	callchannel .sub3
	note B_, 4
	callchannel .sub2
	note F#, 4
	callchannel .sub3
	note G#, 4
	callchannel .sub3
	note B_, 4
	callchannel .sub3
	octave 4
	note E_, 4
	callchannel .sub4
	note B_, 4
	note G#, 4
	callchannel .sub4
	octave 4
	note D_, 4
	note D_, 4
	intensity $a0
	octave 3
	note A#, 8
	octave 2
	note A#, 8
	octave 3
	note F#, 8
	octave 2
	note F#, 8
	intensity $60
	note B_, 16
	intensity $70
	note B_, 16
	intensity $80
	octave 3
	note C#, 16
	intensity $a0
	note D#, 16
	intensity $b4
	octave 4
	note F#, 4
	note F_, 4
	note E_, 4
	note D#, 4
	note D_, 4
	note C#, 4
	note F#, 4
	note F#, 4
	note F#, 4
	note F_, 4
	note E_, 4
	note D#, 4
	note F#, 2
	note G#, 2
	note D#, 2
	note E_, 2
	note F#, 4
	note F#, 4
	note __, 16
	intensity $90
	octave 3
	note F#, 8
	intensity $b4
	note E_, 4
	note E_, 4
	intensity $90
	note D#, 16
	note C#, 16
.repeat4
	callchannel .sub1
	note D#, 4
	loopchannel 4, .repeat4
	callchannel .sub5
	note D#, 4
	callchannel .sub5
	note D#, 4
	callchannel .sub5
	note F#, 4
	callchannel .sub5
	note G#, 4
	jumpchannel .skip2
.repeat5
	note B_, 4
.skip2
	callchannel .sub6
	note A#, 4
	callchannel .sub6
	note B_, 4
	callchannel .sub6
	octave 4
	note C#, 4
	octave 3
	callchannel .sub6
	loopchannel 2, .repeat5
	octave 4
	note D_, 4
	jumpchannel .loop

.sub1
	intensity $b2
	octave 2
	note A#, 2
	note A#, 2
	intensity $b7
	octave 3
	endchannel

.sub2
	intensity $b5
	octave 3
	note D#, 2
	note A#, 2
	note D#, 2
	note F#, 4
	note F_, 2
	note E_, 2
	note B_, 2
	note F#, 2
	note A#, 2
	note F_, 2
	note A_, 2
	note E_, 2
	note G#, 2
	note D#, 2
	note G_, 2
.sub3
	intensity $b2
	note E_, 2
	note E_, 2
	intensity $b7
	endchannel

.sub4
	intensity $b2
	octave 3
	note A#, 2
	note A#, 4
	note A#, 4
	note A#, 4
	note A#, 4
	note A#, 4
	note A#, 2
	intensity $b7
	endchannel

.sub5
	intensity $b2
	note C_, 2
	note C_, 2
	intensity $b7
	endchannel

.sub6
	intensity $b2
	note D#, 2
	note D#, 2
	intensity $b7
	endchannel

Music_ChampionBattle_Ch2:
	dutycycle $3
	vibrato $8, $36
	tone $0001
	notetype $c, $c2
	octave 3
	note D#, 8
	note D#, 8
	note D#, 8
	note D#, 4
	intensity $c7
	note D_, 4
	callchannel .sub1
	note A#, 4
	callchannel .sub1
	note B_, 4
	callchannel .sub1
	octave 4
	note C#, 4
	callchannel .sub2
	note D_, 4
	callchannel .sub2
	note F_, 4
	callchannel .sub2
	note D_, 4
	callchannel .sub3
	note B_, 4
	callchannel .sub4
	octave 4
	note C_, 4
	callchannel .sub4
	octave 4
	note C#, 4
	note D#, 8
	octave 3
	note D#, 8
	octave 4
	note E_, 8
	intensity $3c
	note E_, 8
.loop
	stereopanning $f0
	callchannel .sub5
	note A#, 4
	intensity $c7
	note B_, 8
	octave 4
	note E_, 8
	intensity $c2
	octave 3
	note G#, 2
	note G#, 2
	intensity $c7
	note B_, 4
	intensity $c2
	note G#, 2
	note G#, 2
	intensity $c7
	octave 4
	note C#, 4
	callchannel .sub5
	note A#, 2
	note B_, 2
	intensity $c7
	octave 4
	note E_, 8
	note G#, 8
	note E_, 8
	note B_, 8
	callchannel .sub6
	note E_, 4
	note E_, 4
	callchannel .sub6
	note F#, 4
	note F#, 4
	intensity $c7
	note D#, 8
	octave 3
	note D#, 8
	octave 4
	note C#, 8
	octave 3
	note C#, 8
	intensity $b0
	note D#, 16
	note D#, 16
	note F_, 16
	note F#, 16
	intensity $c4
.repeat
	octave 5
	note D#, 4
	note D_, 4
	note C#, 4
	note C_, 4
	note D#, 2
	note D_, 2
	note C#, 2
	note C_, 2
	octave 4
	note B_, 4
	note B_, 4
	loopchannel 2, .repeat
	intensity $b0
	octave 3
	note D#, 16
	note B_, 16
	note A#, 16
	note G#, 16
	callchannel .sub2
	note A_, 4
	callchannel .sub3
	note B_, 4
	callchannel .sub4
	octave 4
	note C#, 4
	callchannel .sub4
	octave 4
	note D_, 4
	intensity $b0
	note D#, 8
	note E_, 8
	note F#, 8
	note E_, 8
	note D#, 8
	note E_, 8
	note F#, 8
	note G#, 8
	jumpchannel .loop

.sub1
	intensity $c2
	note D#, 2
	note D#, 6
	note D#, 2
	note D#, 6
	note D#, 2
	note D#, 6
	note D#, 2
	note D#, 2
	intensity $c7
	endchannel

.subrepeat
	note B_, 4
.sub2
	octave 3
	intensity $c2
	note D#, 2
	note D#, 2
	intensity $c7
	note A#, 4
	intensity $c2
	note D#, 2
	note D#, 2
	intensity $c7
	loopchannel 2, .subrepeat
	endchannel

.sub3
	loopchannel 2, .sub2

.sub4
	octave 3
	intensity $c2
	note D#, 2
	note D#, 2
	intensity $c7
	endchannel

.sub5
	intensity $c5
	note D#, 6
	octave 3
	note A#, 6
	octave 4
	note D#, 2
	note D_, 2
	note C#, 4
	note C_, 4
	octave 3
	note B_, 4
	endchannel

.sub6
	intensity $c1
	note D#, 2
	note D#, 4
	note D#, 4
	note D#, 4
	note D#, 4
	note D#, 4
	note D#, 2
	intensity $c5
	endchannel

Music_ChampionBattle_Ch3:
	notetype $c, $14
	octave 3
	note D#, 1
	note __, 7
	note D#, 1
	note __, 7
	note D#, 1
	note __, 7
	note D#, 1
	note __, 3
	note E_, 4
	callchannel .sub1
	callchannel .sub1
	callchannel .sub1
	callchannel .sub2
	note A#, 4
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note D_, 4
	callchannel .sub2
	note A#, 4
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note A_, 4
	callchannel .sub2
	note A#, 4
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note D_, 4
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note A#, 4
	callchannel .sub2
	octave 4
	note C#, 4
	note D#, 8
	octave 3
	note D#, 8
	note B_, 4
	note G_, 2
	note B_, 2
	note F#, 2
	note A#, 2
	note F_, 2
	note A_, 2
.loop
	callchannel .sub3
	callchannel .sub4
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note B_, 2
	note G_, 2
	note A_, 2
	callchannel .sub3
.repeat1
	note E_, 2
	note B_, 2
	loopchannel 8, .repeat1
	callchannel .sub5
	note E_, 2
	note D#, 2
	note E_, 2
	note D#, 2
	octave 4
	note D_, 2
	note C#, 2
	note C_, 2
	callchannel .sub5
	note A#, 2
	note D#, 2
	note A#, 2
	note D#, 2
	octave 4
	note D_, 2
	note C#, 2
	note C_, 2
	octave 3
	note A#, 8
	note D#, 8
	note B_, 8
	note D#, 8
.repeat2
	note D#, 2
	note F#, 2
	loopchannel 16, .repeat2
	callchannel .sub6
	octave 3
	callchannel .sub7
	note F#, 2
	octave 3
	callchannel .sub8
	callchannel .sub6
	octave 3
	callchannel .sub9
.repeat3
	note D#, 2
	note A#, 2
	loopchannel 5, .repeat3
	note B_, 2
	octave 4
	note D#, 2
	octave 3
	note D#, 2
	note __, 2
	note D#, 2
	note __, 2
	callchannel .sub4
	octave 4
	note C#, 2
	note E_, 2
	octave 3
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
.repeat4
	note D#, 2
	note G#, 2
	loopchannel 8, .repeat4
	callchannel .sub10
	note B_, 2
	note A#, 2
.repeat5
	octave 3
	note D#, 2
	note A#, 2
	octave 4
	note D_, 2
	note D#, 2
	loopchannel 7, .repeat5
	note C#, 2
	octave 3
	note B_, 2
	note A#, 2
	note G#, 2
	jumpchannel .loop

.repeat6
	note __, 5
.sub1
	note D#, 1
	note __, 1
	note D#, 1
	loopchannel 4, .repeat6
	note __, 1
	note B_, 4
	endchannel

.sub2
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note A#, 4
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note B_, 4
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	endchannel

.sub3
	note D#, 2
	note A#, 2
.sub10
	loopchannel 8, .sub3
	endchannel

.sub4
	note E_, 2
	note B_, 2
.sub9
	loopchannel 5, .sub4
	endchannel

.sub5
	octave 3
	note D#, 2
	note F#, 2
	note D#, 2
	note F#, 2
	note D#, 2
	octave 4
	note D_, 2
	note C#, 2
	note C_, 2
	octave 3
	note D#, 2
	endchannel

.sub6
	octave 3
	note E_, 2
	note B_, 2
	note E_, 2
	note B_, 2
.sub7
	note E_, 2
.sub8
	note B_, 2
	octave 4
	note D#, 2
	note E_, 2
	endchannel
