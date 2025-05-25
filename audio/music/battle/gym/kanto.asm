Music_KantoGymBattle:
	channelcount 3
	channel 1, Music_KantoGymBattle_Ch1
	channel 2, Music_KantoGymBattle_Ch2
	channel 3, Music_KantoGymBattle_Ch3

Music_KantoGymBattle_Ch1:
	tempo 104
	volume $77
	dutycycle 3
	vibrato 8, $34
	notetype 12, $b3
	note __, 6
	octave 3
	callchannel Music_KantoGymBattle_Common
	note C_, 1
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	octave 1
	note G#, 1
	note A_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note B_, 1
	octave 2
	callchannel .sub1
	note F_, 6
	callchannel .sub1
	note A_, 6
.loop
	stereopanning $f
	callchannel .sub2
	callchannel .sub2
	note __, 2
	octave 1
	callchannel .sub3
	octave 2
	note C#, 2
	octave 1
	note B_, 1
	note __, 1
	callchannel .sub3
	note B_, 1
	note __, 1
	octave 2
	note C#, 2
	octave 1
	note B_, 2
	note A_, 2
	octave 2
	note C#, 2
	octave 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
.repeat1
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	note A_, 1
	note B_, 1
	loopchannel 11, .repeat1
	note __, 16
	octave 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
.repeat2
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	note A_, 1
	note B_, 1
	loopchannel 15, .repeat2
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	intensity $b5
	octave 3
	note C#, 12
	intensity $b3
	callchannel .sub4
	note D#, 4
	note C#, 4
	note D#, 4
	note E_, 2
	note F#, 4
	octave 2
	note B_, 2
	octave 3
	note C#, 2
	note F#, 2
	note B_, 2
	note F#, 2
	note D#, 2
	note F#, 2
	callchannel .sub4
	note C#, 1
	octave 2
	note B_, 1
	octave 3
	note C#, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note F#, 1
	note A_, 1
	note G#, 1
	note F#, 1
	note E_, 1
	note F#, 1
	note E_, 1
	note D#, 1
	note C#, 1
	intensity $b5
	note D#, 4
	note E_, 4
	note C#, 2
	note D#, 6
	note F#, 4
	note E_, 2
	note D#, 4
	note C#, 6
	note __, 16
	note __, 10
	note E_, 6
	note D#, 4
	note E_, 4
	note C#, 2
	note D#, 6
	note E_, 4
	note D#, 2
	note C#, 4
	octave 2
	note B_, 6
	octave 3
	note D#, 4
	note E_, 4
	note C#, 2
	note D#, 6
	note F#, 4
	note A_, 2
	note G#, 4
	note E_, 6
	jumpchannel .loop

.sub1
	note F#, 1
	note __, 15
	note F#, 1
	note __, 9
	note G_, 6
	note F#, 1
	note __, 15
	note F#, 1
	note __, 9
	endchannel

.sub2
	note F#, 1
	octave 3
.repeat3
	note C#, 1
	note F#, 1
	note E_, 1
	loopchannel 10, .repeat3
	note C#, 1
	octave 2
	note E_, 1
	note A_, 1
.repeat4
	octave 3
	note C#, 1
	octave 2
	note B_, 1
	note A_, 1
	loopchannel 10, .repeat4
	endchannel

.repeat5
	note B_, 1
	note __, 1
	octave 2
	note E_, 4
	octave 1
	note B_, 1
	note __, 1
.sub3
	note B_, 1
	note __, 1
	octave 2
	note D_, 4
	octave 1
	note B_, 1
	note __, 1
	loopchannel 2, .repeat5
	endchannel

.sub4
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	intensity $b5
	octave 3
	note A_, 12
	intensity $b3
	endchannel

Music_KantoGymBattle_Ch2:
	dutycycle 3
	vibrato 8, $25
	notetype 12, $c3
	octave 4
	note F_, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	note __, 5
	callchannel Music_KantoGymBattle_Common
	callchannel .sub1
	note A#, 6
	octave 3
	callchannel .sub1
	octave 4
	note C#, 6
.loop
	stereopanning $f0
	callchannel .sub2
	octave 3
	note A_, 8
	octave 4
	note C#, 8
	note E_, 8
	note C#, 8
	dutycycle 3
	callchannel .sub2
	note C#, 8
	octave 3
	note B_, 8
	note A_, 8
	intensity $c3
	octave 4
	note E_, 4
	note E_, 2
	note C#, 2
	intensity $c5
	dutycycle 3
	octave 1
	note B_, 1
	note __, 3
	octave 3
	callchannel .sub3
	note __, 2
	note E_, 1
	note C#, 1
	note E_, 1
	note __, 1
	note F_, 1
	note __, 1
	callchannel .sub3
	note E_, 1
	note __, 1
	note C#, 1
	note __, 1
	note D_, 1
	note __, 1
	note C#, 1
	note __, 1
	note F#, 1
	note __, 1
	note E_, 1
	note __, 1
	octave 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	callchannel .sub4
	note G_, 4
	note F#, 8
	intensity $b7
	note F#, 8
	intensity $c3
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	note A_, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 1
	note A_, 1
	note B_, 1
	callchannel .sub4
	octave 4
	note C_, 4
	octave 3
	note B_, 16
	intensity $3f
	octave 4
	note F#, 16
	dutycycle 3
	callchannel .sub5
	octave 3
	note A_, 12
	callchannel .sub5
	octave 4
	note C#, 12
	intensity $b0
	note D#, 16
	intensity $b7
	note D#, 16
	callchannel .sub5
	octave 4
	note C#, 12
	intensity $c0
	note A_, 8
	note E_, 8
	note B_, 16
	intensity $c7
	note B_, 16
	intensity $c4
	octave 3
	note D#, 4
	note E_, 4
	note C#, 2
	note D#, 6
	note F#, 4
	note A_, 2
	note G#, 4
	note __, 2
	note B_, 1
	octave 4
	note D#, 1
	note F#, 1
	note A#, 1
	intensity $c0
	note B_, 16
	note F#, 16
	note A_, 16
	octave 5
	note C#, 8
	note __, 2
	intensity $c3
	octave 4
	note A_, 6
	jumpchannel .loop

.sub1
	note B_, 1
	note __, 15
	note B_, 1
	note __, 9
	octave 4
	note C_, 6
	octave 3
	note B_, 1
	note __, 15
	note B_, 1
	note __, 9
	endchannel

.sub2
	intensity $c5
	note D#, 4
	note C#, 4
	note D#, 4
	note E_, 2
	note F#, 4
	note E_, 4
	note D#, 2
	note C#, 2
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	note D#, 2
	intensity $b7
	dutycycle 2
	endchannel

.sub3
	note D_, 1
	note C#, 1
	octave 2
	note B_, 1
	octave 3
	note D_, 1
	note __, 4
	note E_, 1
	note D_, 1
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	note __, 4
	note F#, 1
	note E_, 1
	note C#, 1
	note F#, 1
	endchannel

.sub4
	intensity $b0
	octave 3
.subrepeat
	note B_, 4
	octave 4
	note C_, 4
	octave 3
	note A_, 4
	loopchannel 2, .subrepeat
	endchannel

.sub5
	intensity $c3
	octave 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	intensity $c7
	endchannel

Music_KantoGymBattle_Common:
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	endchannel

Music_KantoGymBattle_Ch3:
	vibrato 0, $20
	notetype 12, $13
	note __, 12
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note F_, 1
	note F#, 1
	callchannel .sub1
	note C_, 6
	callchannel .sub1
	note F_, 6
	callchannel .sub1
	note C_, 6
	callchannel .sub1
	note C#, 6
	intensity $14
.loop
	callchannel .sub2
	callchannel .sub2
	callchannel .sub3
	octave 4
	note C#, 2
	callchannel .sub3
	note B_, 1
	note __, 1
	octave 4
	note C#, 2
	octave 3
	note B_, 2
	note A_, 2
	octave 4
	note C#, 2
	octave 3
.repeat1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 13
	loopchannel 8, .repeat1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 4
	note C#, 12
	octave 3
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 4
	note E_, 12
	note D#, 16
	octave 3
	note B_, 16
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 4
	note E_, 12
	note C#, 8
	note E_, 8
	callchannel .sub4
	note E_, 6
	callchannel .sub4
	note G_, 6
	callchannel .sub4
	note C_, 6
	callchannel .sub4
	note G_, 6
	jumpchannel .loop

.repeat2
	note F#, 1
	note __, 1
.sub1
	octave 3
	note B_, 1
	note __, 1
	octave 4
	loopchannel 7, .repeat2
	endchannel

.sub2
	octave 3
	note B_, 2
	octave 4
	note F#, 2
	loopchannel 8, .sub2
.repeat3
	octave 3
	note A_, 2
	octave 4
	note E_, 2
	loopchannel 8, .repeat3
	endchannel

.repeat4
	note B_, 1
	note __, 1
	octave 4
	note E_, 4
.sub3
	octave 3
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	octave 4
	note D_, 4
	octave 3
	note B_, 1
	note __, 1
	loopchannel 2, .repeat4
	endchannel

.repeat5
	note F#, 2
.sub4
	octave 3
	note B_, 2
	octave 4
	loopchannel 7, .repeat5
	endchannel
