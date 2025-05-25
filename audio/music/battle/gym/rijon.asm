Music_RijonGymBattle:
	channelcount 4
	channel 1, Music_RijonGymBattle_Ch1
	channel 2, Music_RijonGymBattle_Ch2
	channel 3, Music_RijonGymBattle_Ch3
	channel 4, Music_RijonGymBattle_Ch4

Music_RijonGymBattle_Ch1:
	tempo 101
	volume $77
	dutycycle $3
	tone $0002
	vibrato $12, $15
	notetype $c, $b2
	octave 3
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note G_, 1
	note F#, 1
	note F_, 1
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
	note C_, 1
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	note A#, 1
	note B_, 1
	callchannel .sub1
	note B_, 2
	callchannel .sub1
	octave 3
	note E_, 2
	octave 2
	callchannel .sub1
	note B_, 2
	intensity $b2
	note A#, 2
	note A#, 6
	note A#, 2
	note A#, 6
	note A#, 2
	intensity $b4
	octave 3
	note E_, 4
	note E_, 4
	note E_, 2
.loop
	stereopanning $f
	callchannel .sub2
	octave 2
	note A#, 2
	intensity $b7
	note G#, 8
	note B_, 8
	octave 3
	note D#, 10
	note E_, 6
	callchannel .sub2
	note D#, 2
	intensity $b7
	note C#, 8
	octave 2
	note B_, 8
	note G#, 10
	octave 3
	note E_, 6
	callchannel .sub3
	note D#, 2
	intensity $b7
	note E_, 2
	callchannel .sub3
	note G#, 2
	intensity $b5
	note B_, 2
	callchannel .sub4
	note D#, 2
	note A#, 2
	octave 3
	note C#, 2
	intensity $b7
	octave 2
	note B_, 8
	note A#, 8
	note G#, 10
	note B_, 6
	intensity $b5
	octave 3
	callchannel .sub4
	note G#, 2
	note A#, 2
	octave 3
	note C#, 2
	intensity $b7
	note E_, 8
	note F#, 8
	note G_, 16
	intensity $b2
	octave 2
	note G#, 2
	note G#, 2
	intensity $b7
	octave 3
	note C#, 12
	intensity $b2
	note G#, 2
	note F_, 4
	intensity $b5
	octave 2
	note F_, 4
	note G_, 2
	note G#, 2
	note A#, 2
	intensity $b2
	note A#, 2
	note A#, 2
	intensity $b7
	octave 3
	note D#, 12
	intensity $b2
	note A#, 2
	note G_, 4
	intensity $b7
	octave 4
	note D#, 6
	intensity $4c
	octave 3
	note D_, 4
	jumpchannel .loop

.sub1
	intensity $b2
	note A#, 2
	note A#, 6
	note A#, 2
	note A#, 6
	note A#, 2
	note A#, 8
	intensity $b7
	endchannel

.sub2
	intensity $b5
	note D#, 2
	octave 2
	note A#, 2
	octave 3
	note D#, 2
	note E_, 4
	note D#, 2
	note C#, 2
	octave 2
	note A#, 2
	note D#, 2
	note G#, 2
	note A#, 2
	octave 3
	note D#, 2
	note E_, 2
	note D#, 2
	note C#, 2
	endchannel

.sub3
	intensity $b2
	note D#, 2
	note D#, 2
	note G_, 1
	note E_, 1
	note D#, 1
	note G_, 1
	note D#, 2
	note D#, 2
	note A#, 1
	note G#, 1
	note E_, 1
	note A#, 1
	note D#, 2
	note D#, 2
	note B_, 1
	note A#, 1
	note G#, 1
	note B_, 1
	endchannel

.sub4
	note D#, 2
	note C#, 2
	octave 2
	note A#, 4
	note D#, 2
	note G#, 2
	note B_, 2
	octave 3
	note E_, 2
	note D#, 4
	note C#, 2
	octave 2
	note A#, 2
	note A#, 2
	endchannel

Music_RijonGymBattle_Ch2:
	dutycycle $3
	vibrato $8, $36
	tone $0001
	notetype $c, $c2
.repeat1
	octave 4
	note A#, 1
	note G#, 1
	note A#, 1
	octave 5
	note D#, 1
	loopchannel 8, .repeat1
	octave 3
.repeat2
	callchannel .sub1
	note D_, 2
	intensity $c7
	note E_, 2
	intensity $c2
	callchannel .sub1
	note G#, 2
	intensity $c7
	note B_, 2
	intensity $c2
	octave 4
	loopchannel 2, .repeat2
.loop
	stereopanning $f0
	callchannel .sub2
	note G#, 6
	callchannel .sub2
	octave 4
	note E_, 6
	note D#, 8
	intensity $b7
	note D#, 8
	intensity $a2
	note __, 6
	octave 5
	note E_, 4
	note E_, 4
	note E_, 2
	intensity $a0
	note D#, 8
	intensity $a7
	note D#, 8
	note __, 12
	octave 3
	callchannel .sub3
	note E_, 4
	intensity $b0
	note D#, 8
	note D#, 16
	intensity $b7
	note D#, 12
	callchannel .sub3
	note B_, 4
	intensity $b0
	note A#, 8
	intensity $b7
	note A#, 8
	intensity $b0
	octave 4
	note D#, 8
	intensity $b7
	note D#, 8
	intensity $c2
	octave 3
	note C#, 2
	note C#, 2
	intensity $c7
	note F_, 8
	intensity $c2
	octave 4
	note C#, 4
	note F_, 2
	note C#, 4
	intensity $c7
	note G#, 4
	note G_, 2
	note F_, 2
	note D#, 2
	intensity $c2
	octave 3
	note D#, 2
	note D#, 2
	intensity $c7
	note G_, 8
	intensity $c2
	octave 4
	note D#, 4
	note G_, 2
	note D#, 4
	intensity $c7
	note A#, 6
	octave 3
	note A_, 4
	jumpchannel .loop

.sub1
	note D#, 2
	note D#, 2
	note F#, 1
	note E_, 1
	note D#, 1
	note F#, 1
	note D#, 2
	note D#, 2
	note A#, 1
	note G#, 1
	note F#, 1
	note A#, 1
	note D#, 2
	note D#, 2
	note B_, 1
	note A#, 1
	note G#, 1
	note B_, 1
	endchannel

.subrepeat
	intensity $d1
	note G#, 2
	intensity $a2
	note G#, 2
.sub2
	dutycycle $2
	octave 3
	intensity $d1
	note A#, 2
	intensity $a2
	note A#, 2
	loopchannel 2, .subrepeat
	intensity $c5
	note B_, 2
	octave 4
	note C#, 2
	note C#, 2
	octave 3
	note B_, 4
	note A#, 2
	note G#, 2
	note F#, 2
	note G#, 2
	note A#, 2
	dutycycle $3
	intensity $b0
	note E_, 8
	note G#, 8
	note B_, 10
	endchannel

.sub3
	intensity $c5
	note A#, 4
	note B_, 4
	note G#, 4
	note A#, 4
	note B_, 4
	note G#, 4
	endchannel

Music_RijonGymBattle_Ch3:
	notetype $c, $19
	octave 2
	note E_, 1
	note __, 1
.repeat1
	note B_, 3
	note __, 1
	loopchannel 6, .repeat1
	note B_, 2
	note G#, 2
	note B_, 2
.repeat2
	callchannel .sub1
	note D_, 1
	note __, 1
	note F_, 2
	callchannel .sub1
	note D_, 1
	note __, 1
	note E_, 2
	loopchannel 2, .repeat2
.loop
	octave 2
.repeat3
	note D#, 2
	note A#, 2
	loopchannel 8, .repeat3
.repeat4
	note E_, 2
	note B_, 2
	loopchannel 4, .repeat4
	octave 1
	note B_, 2
	octave 2
	note E_, 2
	octave 1
	note B_, 2
	octave 2
	note E_, 4
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	callchannel .sub2
.repeat5
	note E_, 2
	note B_, 2
	loopchannel 7, .repeat5
	octave 3
	note E_, 2
	octave 2
	note B_, 2
.repeat6
	callchannel .sub3
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note A#, 4
	note D#, 1
	note __, 1
	note E_, 2
	loopchannel 2, .repeat6
.repeat7
	note D#, 2
	note A#, 2
	loopchannel 7, .repeat7
	octave 3
	note C#, 2
	octave 2
	note A#, 2
.repeat8
	note E_, 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	loopchannel 2, .repeat8
.repeat9
	note E_, 2
	note B_, 2
	loopchannel 5, .repeat9
	callchannel .sub4
	note A#, 2
	octave 3
	note C#, 2
	octave 2
	note E_, 2
	note A#, 2
	octave 3
	note E_, 2
	note F#, 2
	note G#, 2
	note F#, 2
	note E_, 2
	note C#, 2
	octave 2
.repeat10
	note D#, 2
	note A#, 2
	loopchannel 4, .repeat10
.repeat11
	note C#, 2
	note G#, 2
	loopchannel 8, .repeat11
.repeat12
	note D#, 2
	note A#, 2
	loopchannel 4, .repeat12
	octave 3
	note D#, 2
	octave 2
	note A#, 2
	note D#, 2
	note D_, 2
	note D_, 2
	note A#, 2
	octave 3
	note D#, 2
	note F_, 2
	jumpchannel .loop

.sub1
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note F#, 4
.sub3
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
	endchannel

.sub2
	note F#, 2
	octave 3
	note C#, 2
	octave 2
.sub4
	loopchannel 8, .sub2
	endchannel

Music_RijonGymBattle_Ch4:
	togglenoise 4
	notetype $C
	note D#, 1
	note __, 3
	note D#, 1
	note __, 3
	note D#, 1
	note __, 3
	note D#, 1
	note __, 3
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 1
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note G_, 2
	note G_, 2
	note E_, 2
	note D#, 2
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
Music_RijonGymBattle_Ch4_loop:
	note B_, 4
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note B_, 4
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note __, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note B_, 4
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note B_, 12
	note __, 12
	note D#, 2
	note D#, 2
	note B_, 12
	note __, 12
	note D#, 4
	note D#, 2
	note D#, 2
	note B_, 12
	note __, 16
	note D#, 2
	note D#, 2
	note B_, 12
	note D#, 2
	note D#, 2
	note B_, 4
	note G_, 4
	note E_, 4
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note G_, 2
	note D#, 2
	note D#, 2
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	jumpchannel Music_RijonGymBattle_Ch4_loop
