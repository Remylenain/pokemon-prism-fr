Music_JohtoTrainerBattle:
	channelcount 4
	channel 1, Music_JohtoTrainerBattle_Ch1
	channel 2, Music_JohtoTrainerBattle_Ch2
	channel 3, Music_JohtoTrainerBattle_Ch3
	channel 4, Music_JohtoTrainerBattle_Ch4

Music_JohtoTrainerBattle_Ch1:
	tempo 102
	volume $77
	notetype $c, $c2
	dutycycle 1
	vibrato $12, $24
	note __, 8
	octave 3
	note G#, 1
	note G_, 1
	note F#, 1
	note G_, 1
	note C_, 1
	octave 2
	note B_, 1
	note A#, 1
	note B_, 1
	octave 3
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note D#, 1
	dutycycle 2
	callchannel .sub1
	note F_, 6
	intensity $c7
	note D_, 4
	intensity $c2
	note E_, 6
	note D_, 6
	note E_, 4
	note E_, 2
	note D_, 2
	note E_, 2
	note F_, 6
	intensity $c7
	note F_, 4
	callchannel .sub2
	note F_, 2
	octave 3
	note A_, 2
	note A#, 2
	intensity $c7
	note B_, 4
	callchannel .sub2
	note F_, 6
	intensity $c7
	note G_, 4
	stereopanning $f
.loop
	intensity $c2
	callchannel .sub3
	note A#, 4
	intensity $c2
	note G_, 1
	note F_, 1
	note E_, 1
	note G_, 1
	intensity $c7
	octave 4
	note C_, 4
	intensity $c2
	octave 3
	note A_, 1
	note G_, 1
	note F_, 1
	note A_, 1
	intensity $c7
	octave 4
	note D_, 4
	intensity $c2
	note C_, 1
	octave 3
	note A#, 1
	note A_, 1
	octave 4
	note C_, 1
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	callchannel .sub3
	note F_, 4
	intensity $c2
	note E_, 2
	note F_, 2
	intensity $c7
	octave 4
	note C_, 4
	intensity $c2
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	intensity $c7
	octave 3
	note F_, 16
	note A_, 6
	note E_, 6
	note A#, 4
	octave 4
	note D_, 6
	note F_, 4
	intensity $c2
	note E_, 2
	note D_, 2
	note F_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C#, 2
	octave 3
	note A#, 2
	note A_, 2
	note A#, 2
	intensity $c7
	note A_, 16
	note E_, 8
	note D_, 8
	note E_, 8
	note F_, 8
	note E_, 8
	note D_, 8
	note G_, 8
	note F_, 8
	note D_, 8
	note C_, 8
	note D_, 8
	note D#, 8
	note D_, 8
	note C_, 8
	note D_, 8
	note D#, 8
	note D_, 8
	note D#, 8
	note E_, 8
	note F_, 8
	intensity $c2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	note G#, 2
	note G_, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note G_, 2
	octave 4
	note C#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note C#, 2
	note C_, 2
	octave 3
	note A#, 2
	note D#, 2
	note D_, 2
	note D#, 4
	intensity $c7
	note C_, 8
	note D#, 4
	note D_, 4
	note C_, 4
	note D#, 4
	intensity $c2
	note E_, 2
	note D#, 2
	note E_, 4
	intensity $c7
	note C#, 8
	note F_, 4
	note D#, 4
	note C#, 4
	note F_, 4
	intensity $c2
	note F#, 2
	note F_, 2
	note F#, 4
	intensity $c7
	note D_, 8
	note F#, 4
	note E_, 4
	note D_, 4
	note F#, 4
	note G_, 8
	note D#, 8
	note A#, 8
	note G_, 8
	note D#, 16
	note __, 16
.repeat1
	callchannel .sub4
	note F_, 4
	octave 2
	note A#, 4
	octave 3
	callchannel .sub4
	note F_, 4
	note F_, 4
	loopchannel 2, .repeat1
	note F_, 8
	note G_, 4
	note D#, 4
	note F_, 4
	intensity $c2
	note G#, 2
	note G_, 2
	intensity $c7
	note F_, 8
	callchannel .sub4
	note F_, 8
	callchannel .sub4
	note G#, 16
	octave 4
	note C_, 16
	intensity $c2
	octave 3
.repeat2
	note D#, 6
	note D#, 6
	note D#, 4
	note D#, 6
	note D#, 6
	note F_, 4
	loopchannel 2, .repeat2
	note G#, 6
	note G_, 6
	note F_, 4
	note D#, 4
	note F_, 4
	note G_, 4
	note D#, 4
.repeat3
	note F_, 4
	octave 4
	note C#, 2
	note C_, 2
	octave 3
	loopchannel 2, .repeat3
	note F_, 2
	note G_, 2
	note G#, 2
	octave 4
	note C_, 2
	note C#, 2
	note C_, 2
	octave 3
	note A#, 2
	note G#, 2
	note G_, 6
	note D#, 6
	note G_, 4
	octave 4
	note C#, 4
	note C_, 4
	octave 3
	note A#, 4
	note G#, 4
	note F_, 4
	note C#, 2
	note D#, 2
	note F_, 4
	note C#, 2
	note D#, 2
	note A#, 4
	note G#, 4
	note G_, 4
	note F_, 4
	intensity $c7
	octave 2
	note A#, 8
	octave 3
	note D#, 8
	octave 2
	note A#, 8
	octave 3
	note G_, 8
	note D#, 8
	note A#, 8
	note G_, 8
	octave 4
	note D#, 8
	octave 3
	note A#, 16
	note G_, 6
	note A#, 6
	intensity $c2
	note G#, 2
	note G_, 2
	intensity $c7
	note D#, 16
	note A#, 6
	intensity $c2
	note G_, 4
	note G_, 2
	intensity $c7
	note A#, 16
	note __, 16
	note __, 4
	octave 4
	note D_, 16
	note F_, 16
	jumpchannel .loop

.sub2
	intensity $c2
	octave 4
.sub1
	note E_, 6
	note E_, 6
	note E_, 4
	note E_, 2
	note D_, 2
	note E_, 2
	endchannel

.sub3
	octave 3
	note E_, 2
	note D_, 2
	note E_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note A_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note B_, 2
	note G_, 2
	note A_, 2
	note E_, 2
	note F_, 2
	note D_, 2
	intensity $c7
	endchannel

.sub4
	note F_, 8
	note G_, 4
	note D#, 4
	note F_, 4
	intensity $c2
	note G_, 2
	note D#, 2
	intensity $c7
	endchannel

Music_JohtoTrainerBattle_Ch2:
	notetype $c, $d2
	dutycycle 1
	vibrato $6, $36
	octave 4
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note G#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note G#, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note G#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note G#, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note G#, 1
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note G#, 1
	octave 3
	note B_, 1
	note A#, 1
	note B_, 1
	octave 4
	note G#, 1
	octave 3
	note A#, 1
	note A_, 1
	note A#, 1
	intensity $d7
	dutycycle 2
	octave 2
	jumpchannel .skip
.repeat1
	note E_, 2
.skip
	note A_, 1
	octave 1
	note A_, 1
	octave 2
	note E_, 2
	note G_, 2
	note E_, 2
	note A_, 1
	note A_, 1
	note E_, 2
	note G_, 2
	loopchannel 4, .repeat1
	note G#, 2
.repeat2
	octave 3
	note C_, 1
	octave 2
	note C_, 1
	note G_, 2
	note A#, 2
	note G_, 2
	octave 3
	note C_, 1
	note C_, 1
	octave 2
	note G_, 2
	note A#, 2
	note G_, 2
	loopchannel 4, .repeat2
.loop
	callchannel .sub1
	callchannel .sub1
	forceoctave 1
	callchannel .sub1
	callchannel .sub1
	forceoctave 0
	loopchannel 2, .loop
	octave 2
.repeat3
	note E_, 1
	note E_, 1
	note A_, 1
	note A_, 1
	note E_, 2
	note A_, 2
	note E_, 1
	octave 1
	note E_, 1
	octave 2
	note A_, 1
	octave 1
	note A_, 1
	octave 2
	note E_, 2
	note A_, 2
	loopchannel 3, .repeat3
	note A_, 2
	octave 3
	note F_, 2
	note E_, 2
	note D_, 2
	octave 2
	note A_, 2
	note G#, 2
	note A_, 2
	note A#, 2
	forceoctave 2
	callchannel .sub2
	forceoctave 0
	note A_, 2
	octave 3
	note D_, 2
	note C_, 2
	octave 2
	note A#, 2
	note A_, 2
	note G_, 2
	note A_, 2
	note A#, 2
	callchannel .sub2
	note G_, 2
	octave 3
	note C_, 2
	octave 2
	note A#, 2
	note G#, 2
	note G_, 2
	note F_, 2
	note D#, 2
	note D_, 2
	callchannel .sub3
	octave 1
	note F_, 1
	note F_, 1
	octave 2
	note F_, 6
	octave 1
	note E_, 1
	note E_, 1
	octave 2
	note E_, 6
	octave 1
	note D#, 1
	note D#, 1
	octave 2
	note D#, 6
.repeat4
	octave 1
	note A#, 1
	note A#, 1
	octave 3
	note D#, 2
	octave 2
	note D#, 2
	note A#, 2
	octave 3
	note D#, 2
	octave 1
	note D#, 1
	note D#, 1
	octave 2
	note A#, 2
	octave 3
	note D#, 2
	loopchannel 2, .repeat4
	callchannel .sub4
	forceoctave 1
	callchannel .sub4
	forceoctave 2
	callchannel .sub4
	forceoctave 3
	callchannel .sub4
	forceoctave 0
.repeat5
	note G_, 1
	note G_, 1
	octave 3
	note A#, 2
	note G_, 2
	octave 2
	note A#, 2
	loopchannel 4, .repeat5
.repeat6
	callchannel .sub5
	note D#, 2
	note F_, 1
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 4
	callchannel .sub5
	octave 3
	note C_, 2
	octave 2
	note A#, 1
	note A#, 1
	note __, 1
	note A#, 1
	note A#, 4
	loopchannel 2, .repeat6
	note C#, 1
	note C#, 1
	octave 3
	note C#, 6
	octave 2
	note C_, 1
	note C_, 1
	octave 3
	note C_, 6
	callchannel .sub6
	callchannel .sub7
	forceoctave 3
	callchannel .sub7
	forceoctave 0
	callchannel .sub7
	octave 1
	note G#, 2
	octave 2
	note G#, 2
	note D#, 2
	note G#, 2
	octave 3
	note C_, 8
	octave 2
	note C_, 2
	octave 3
	note C_, 4
	note D#, 2
	note D#, 8
	octave 2
	note A#, 2
	note G#, 2
	note G_, 2
	note F_, 2
	forceoctave 2
	callchannel .sub8
	callchannel .sub8
	callchannel .sub8
	forceoctave 0
	callchannel .sub8
	forceoctave 2
	callchannel .sub8
	forceoctave 0
	callchannel .sub8
	octave 1
	note D#, 1
	note D#, 1
	octave 2
	note D#, 6
	octave 1
	note C#, 1
	note C#, 1
	octave 2
	note C#, 6
	octave 1
	note C_, 1
	note C_, 1
	octave 2
	note C_, 7
	octave 1
	note A#, 1
	note A#, 6
	callchannel .sub6
	callchannel .sub3
	octave 1
	note F_, 1
	note F_, 1
	octave 2
	note F_, 6
	forceoctave 1
	callchannel .sub9
	callchannel .sub10
	forceoctave $15
	callchannel .sub9
	forceoctave $11
	callchannel .sub9
	forceoctave $17
	callchannel .sub9
	forceoctave $1a
	callchannel .sub9
	callchannel .sub10
	forceoctave 0
	callchannel .sub9
	jumpchannel .loop

.sub1
	octave 1
	note A_, 1
	note A_, 1
	octave 3
	note E_, 2
	octave 2
	note E_, 2
	note A_, 2
	octave 3
	note E_, 2
	octave 1
	note E_, 1
	note E_, 1
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	endchannel

.sub2
	note C_, 1
	note C_, 1
	note G_, 1
	note G_, 1
	note C_, 2
	note G_, 2
	note C_, 1
	octave 1
	note C_, 1
	octave 2
	note G_, 1
	octave 1
	note G_, 1
	octave 2
	note C_, 2
	note G_, 2
	loopchannel 3, .sub2
	endchannel

.sub7
	octave 1
	note F_, 1
	note F_, 1
	octave 2
	note F_, 6
.sub3
	octave 1
	note G_, 1
	note G_, 1
	octave 2
	note G_, 6
	endchannel

.sub4
	octave 1
	note C_, 1
	note C_, 1
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	note C_, 2
	loopchannel 4, .sub4
	endchannel

.sub5
	note A#, 1
	note A#, 1
	note A#, 2
	note D#, 2
	note A#, 2
	octave 3
	note C#, 2
	note C_, 2
	octave 2
	note A#, 2
	note G#, 2
	note G_, 1
	note G#, 1
	note G_, 1
	note G#, 1
	note A#, 2
	endchannel

.sub6
	octave 1
	note A#, 1
	note A#, 1
	octave 2
	note A#, 6
	octave 1
	note G#, 1
	note G#, 1
	octave 2
	note G#, 6
	endchannel

.sub8
	octave 1
	note G#, 1
	note G#, 1
	octave 3
	note C#, 2
	note G#, 2
	note C#, 2
	octave 2
	note G#, 2
	octave 1
	note C#, 1
	note C#, 1
	octave 2
	note G#, 2
	octave 3
	note C#, 2
	loopchannel 2, .sub8
	endchannel

.sub10
	forceoctave $18
.sub9
	octave 3
	note D_, 2
	note D_, 2
	octave 4
	note D_, 6
	octave 2
	note D_, 2
	octave 3
	note D_, 4
	endchannel

Music_JohtoTrainerBattle_Ch3:
	notetype $c, $15
	vibrato $12, $23
	octave 2
	note D_, 1
	octave 4
	note D_, 1
	octave 3
	note D_, 2
	octave 2
	note C#, 1
	octave 4
	note C#, 1
	octave 3
	note C#, 2
	octave 2
	note C_, 1
	octave 4
	note C_, 1
	octave 3
	note C_, 2
	octave 1
	note B_, 1
	octave 3
	note B_, 1
	octave 2
	note B_, 2
	octave 1
	note A#, 1
	octave 3
	note A#, 1
	octave 2
	note A#, 2
	octave 1
	note A_, 1
	octave 3
	note A_, 1
	octave 2
	note A_, 2
	octave 1
	note G#, 1
	octave 3
	note G#, 1
	octave 2
	note G#, 2
	note G_, 1
	note G#, 1
	note A_, 2
	intensity $18
	forceoctave $29
	octave 7
	callchannel .sub1
	callchannel .sub1
	forceoctave 0
	callchannel .sub1
	note C_, 2
	octave 4
	note E_, 2
	note A_, 2
	octave 6
	note C_, 2
	octave 4
	note E_, 2
	note A_, 2
	octave 6
	note C_, 2
	octave 4
	note E_, 2
	octave 6
	note C_, 2
	octave 4
	note E_, 2
	note B_, 2
	octave 6
	note C_, 2
	octave 5
	note C_, 2
	note E_, 2
	note B_, 4
	stereopanning $f0
.loop
	intensity $15
	callchannel .sub2
	note A#, 4
	note __, 2
	note A#, 4
	note __, 2
	note A#, 4
	intensity $14
	callchannel .sub2
	note D_, 4
	octave 4
	note A#, 2
	octave 5
	note D_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	note A#, 2
	note A_, 2
	note A#, 2
	octave 6
	note D_, 2
	note C#, 12
	octave 5
	note A#, 4
	note A_, 4
	octave 4
	note A_, 2
	octave 5
	note A_, 4
	octave 4
	note A_, 2
	octave 5
	note A_, 4
	note A_, 16
	intensity $18
	octave 4
	forceoctave 2
	callchannel .sub3
	note G_, 1
	callchannel .sub4
	intensity $15
	forceoctave 0
	callchannel .sub3
	note F_, 1
	callchannel .sub4
	intensity $18
	note G_, 4
	note D_, 2
	octave 5
	note D_, 6
	note C_, 2
	note D_, 2
	note F_, 4
	note E_, 4
	note D_, 4
	note C_, 4
	note D#, 16
	note G_, 16
	intensity $15
	octave 4
	note F_, 2
	note D#, 2
	note F_, 4
	note D#, 4
	note F_, 4
	note G_, 4
	note F_, 4
	note D#, 4
	note G_, 4
	note G#, 2
	note G_, 2
	note G#, 4
	note F_, 4
	note G_, 4
	note G#, 4
	note G_, 4
	note F_, 4
	note G#, 4
	note A_, 2
	note G#, 2
	note A_, 4
	note F#, 4
	note G#, 4
	note A_, 4
	note G#, 4
	note F#, 4
	note A_, 4
	note A#, 4
	note __, 2
	note A#, 4
	note __, 2
	note A#, 4
	octave 5
	note D#, 4
	note __, 2
	note D#, 4
	note __, 2
	note D#, 4
	intensity $24
.repeat
	octave 4
	note A#, 1
	octave 3
	note A#, 1
	octave 4
	note D#, 1
	octave 3
	note A#, 1
	octave 5
	note D#, 1
	octave 3
	note A#, 1
	octave 4
	note D#, 1
	octave 3
	note A#, 1
	loopchannel 4, .repeat
	callchannel .sub5
	intensity $25
	callchannel .sub5
	intensity $18
	octave 5
	callchannel .sub6
	octave 4
	note A#, 2
	octave 5
	note C_, 8
	callchannel .sub6
	note G_, 2
	note F_, 8
	callchannel .sub6
	octave 4
	note A#, 2
	octave 5
	note C_, 16
	note D#, 16
	intensity $15
	octave 4
	note G_, 2
	note F_, 2
	note D#, 2
	note G_, 6
	note G_, 4
	note G_, 4
	note D#, 2
	note G_, 6
	note G#, 4
	note G_, 2
	note F_, 2
	note D#, 2
	note G_, 6
	note G_, 4
	note G_, 6
	note G_, 6
	note G#, 4
	intensity $18
	octave 5
	callchannel .sub7
	note F_, 4
	note __, 2
	note F_, 4
	note __, 2
	note F_, 4
	note G#, 4
	note __, 2
	note G#, 4
	note __, 2
	note G#, 4
	callchannel .sub7
	note C#, 4
	note __, 2
	note C#, 4
	note __, 2
	note C#, 4
	note C#, 4
	note C_, 4
	intensity $15
	octave 4
	note A#, 4
	note G#, 4
	note G_, 1
	note __, 1
	note G_, 4
	note D#, 2
	note A#, 8
	note A#, 1
	note __, 1
	note A#, 4
	note G_, 2
	octave 5
	note D#, 8
	note D#, 1
	note __, 1
	note D#, 4
	octave 4
	note A#, 2
	octave 5
	note G_, 8
	note G_, 1
	note __, 1
	note G_, 4
	note D#, 2
	note A#, 8
	note G_, 2
	octave 4
	note G_, 2
	octave 5
	note G_, 2
	callchannel .sub8
	intensity $14
	note D#, 2
	octave 4
	note D#, 2
	octave 5
	note D#, 2
	callchannel .sub8
	octave 4
	note A_, 4
	octave 3
	note A_, 2
	octave 5
	note E_, 6
	note D_, 2
	note E_, 2
	note G_, 2
	octave 4
	note G_, 2
	octave 5
	note F#, 4
	note E_, 4
	note D_, 4
	note F_, 4
	note __, 2
	note F_, 4
	note __, 2
	note F_, 4
	note A#, 4
	note __, 2
	note A#, 4
	note __, 2
	note A#, 4
	jumpchannel .loop

.sub1
	note C_, 4
	octave 5
	note C_, 2
	octave 6
	note C_, 4
	octave 5
	note C_, 2
	octave 6
	note C_, 4
	note C_, 2
	octave 5
	note C_, 4
	octave 6
	note C_, 6
	note C#, 4
	endchannel

.sub2
	octave 4
	note A_, 6
	octave 5
	note E_, 6
	note D_, 2
	note E_, 2
	note G_, 4
	note F#, 4
	note E_, 4
	note D_, 4
	note F_, 4
	note __, 2
	note F_, 4
	note __, 2
	note F_, 4
	endchannel

.sub3
	note G_, 2
	note F_, 2
	note G_, 2
	note G#, 4
	note G_, 2
	note F_, 2
	note G#, 2
	loopchannel 3, .sub3
	endchannel

.sub4
	note __, 1
	octave 5
	note C_, 1
	note __, 1
	octave 4
	note A#, 1
	note __, 1
	note G#, 1
	note __, 1
	note G_, 1
	note __, 1
	note F_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G#, 1
	note __, 1
	endchannel

.sub5
	octave 5
	note D#, 1
	octave 4
	note D#, 1
	note A#, 1
	note D#, 1
	octave 5
	note G_, 1
	octave 4
	note D#, 1
	note A#, 1
	note D#, 1
	loopchannel 8, .sub5
	endchannel

.sub6
	note F_, 2
	octave 4
	note F_, 2
	note A#, 2
	octave 5
	note F_, 2
	note G#, 2
	note G_, 2
	note F_, 2
	note D#, 2
	note D_, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note F_, 2
	endchannel

.sub7
	note D#, 2
	octave 4
	note D#, 2
	octave 5
	note D#, 2
	note A#, 6
	note G#, 2
	note G_, 2
	note G#, 2
	octave 4
	note G#, 2
	octave 5
	note G_, 4
	note F_, 4
	note D#, 4
	endchannel

.sub8
	note A#, 6
	note G#, 2
	note G_, 2
	note D#, 4
	note __, 2
	note D#, 4
	note __, 2
	note D#, 4
	endchannel

Music_JohtoTrainerBattle_Ch4:
	togglenoise 3
	notetype $C
	note C_, 2
	note __, 2
	note C_, 2
	note __, 2
	note C_, 2
	note D_, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note C_, 2
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note B_, 4
	note B_, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
Music_JohtoTrainerBattle_Ch4_loop:
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 12
	note C_, 2
	note C_, 2
	note B_, 8
	note C_, 4
	note C_, 2
	note C_, 1
	note C_, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 4
	note D#, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 8
	note B_, 8
	note B_, 8
	note B_, 4
	note C_, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 8
	note B_, 8
	note B_, 4
	note C_, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 8
	note B_, 8
	note B_, 8
	note B_, 4
	note C_, 2
	note C_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note C#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	note B_, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 4
	note B_, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
	note B_, 4
	note B_, 2
	note B_, 4
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 12
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 12
	note C_, 2
	note C#, 1
	note C#, 1
	note B_, 4
	note C_, 2
	note C#, 2
	note D_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note B_, 2
	note D#, 2
	note C_, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note D_, 1
	note B_, 16
	note C_, 2
	note C_, 2
	note D#, 2
	note D#, 2
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	jumpchannel Music_JohtoTrainerBattle_Ch4_loop
