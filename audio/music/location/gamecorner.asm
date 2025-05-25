Music_GameCorner:
	channelcount 4
	channel 1, Music_GameCorner_Ch1
	channel 2, Music_GameCorner_Ch2
	channel 3, Music_GameCorner_Ch3
	channel 4, Music_GameCorner_Ch4

Music_GameCorner_Ch1:
	tempo 147
	volume $77
	stereopanning $f
	notetype $c, $91
	note __, 8
.loop
	intensity $91
	callchannel .sub1
	note __, 16
	callchannel .sub1
	octave 3
	note __, 2
	note G#, 3
	note G#, 3
	note A#, 2
	note A#, 2
	note G#, 2
	note G_, 2
	intensity $71
	callchannel .sub2
.repeat1
	octave 4
	note D#, 1
	note G_, 1
	octave 5
	note C_, 1
	octave 4
	note G_, 1
	loopchannel 4, .repeat1
.repeat2
	octave 4
	note F_, 1
	note A_, 1
	octave 5
	note C_, 1
	octave 4
	note A_, 1
	loopchannel 4, .repeat2
	callchannel .sub2
.repeat3
	octave 4
	note B_, 1
	octave 5
	note D_, 1
	note G_, 1
	note D_, 1
	loopchannel 4, .repeat3
	octave 3
	note D_, 1
	note D_, 1
	note D_, 3
	note F_, 2
	note F_, 9
	jumpchannel .loop

.sub1
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	jumpchannel .skip
.repeat4
	note __, 2
	note G#, 3
	note G#, 3
	note A#, 2
	note A#, 2
	note G#, 1
	note A#, 3
.skip
	note __, 2
	octave 4
	note A#, 3
	note G_, 3
	note D#, 3
	octave 3
	note F_, 3
	note F_, 2
	loopchannel 4, .repeat4
	endchannel

.sub2
	octave 4
	note G#, 1
	octave 5
	note C_, 1
	note F_, 1
	note C_, 1
	loopchannel 4, .sub2
.repeat5
	octave 4
	note A#, 1
	octave 5
	note D_, 1
	note G_, 1
	note D_, 1
	loopchannel 4, .repeat5
	endchannel

Music_GameCorner_Ch2:
	stereopanning $ff
	vibrato $8, $24
	notetype $c, $92
	note __, 8
.loop
	dutycycle $1
	callchannel .sub
	octave 1
	note F_, 2
	octave 3
	note G#, 2
	octave 1
	note F_, 1
	octave 3
	note G#, 2
	intensity $a4
	note G#, 3
	intensity $92
	note G_, 2
	note A#, 1
	octave 4
	note C_, 3
	callchannel .sub
	octave 4
	note F_, 2
	note D#, 2
	note F_, 1
	note D#, 2
	intensity $a4
	note G_, 3
	note F_, 4
	dutycycle $2
	intensity $c7
	octave 3
	note D#, 1
	note F_, 1
	note G_, 6
	note F_, 6
	note C_, 4
	note D_, 6
	note D#, 6
	note F_, 4
	note D_, 6
	note C_, 6
	octave 2
	note A#, 4
	note A_, 4
	note __, 10
	octave 3
	note D#, 1
	note F_, 1
	note G_, 6
	note F_, 6
	note C_, 4
	note D_, 6
	note D#, 6
	note F_, 2
	note D#, 1
	note F_, 1
	note G_, 16
	intensity $92
	note G_, 1
	note G_, 1
	note G_, 3
	note A#, 2
	note A#, 9
	jumpchannel .loop

.sub
	octave 1
	note C_, 2
	octave 3
	note D#, 3
	note D#, 3
	note D#, 3
	note F_, 3
	note F_, 2
	octave 1
	note C_, 2
	octave 3
	note D#, 3
	note D#, 3
	note F_, 2
	note F_, 2
	note D#, 1
	note F_, 3
	octave 1
	note C_, 2
	octave 3
	note D#, 3
	note D#, 3
	note D#, 3
	note F_, 3
	note F_, 2
	octave 1
	note C_, 2
	octave 3
	note D#, 3
	note D#, 3
	note F_, 2
	note C_, 2
	note D#, 1
	note F_, 3
	octave 1
	note C_, 2
	octave 5
	note D_, 3
	octave 4
	note A#, 3
	note G_, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note F_, 2
	note D#, 2
	note F_, 1
	note D#, 2
	intensity $a4
	note F_, 3
	note G_, 4
	intensity $92
	note F#, 1
	note F_, 1
	octave 1
	note C_, 2
	octave 5
	note D_, 3
	octave 4
	note A#, 3
	note G_, 2
	note C_, 2
	note D_, 2
	note D#, 2
	octave 1
	note F_, 1
	octave 4
	note F_, 1
	note D#, 2
	note G_, 1
	note D#, 2
	intensity $a4
	note A#, 3
	note A_, 2
	intensity $92
	note A#, 1
	octave 5
	note C_, 3
	octave 1
	note C_, 2
	octave 5
	note D_, 3
	octave 4
	note A#, 3
	note G_, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note F_, 2
	note D#, 2
	note F_, 1
	note D#, 2
	intensity $a4
	note F_, 3
	note G_, 4
	intensity $92
	note F#, 1
	note F_, 1
	octave 1
	note C_, 2
	octave 5
	note D_, 3
	octave 4
	note A#, 3
	note G_, 2
	note C_, 2
	note D_, 2
	note D#, 2
	endchannel

Music_GameCorner_Ch3:
	vibrato $8, $22
	notetype $c, $14
	note __, 8
.loop
	stereopanning $ff
	notetype $c, $14
	callchannel .sub1
	callchannel .sub2
	octave 4
	note G_, 1
	note A_, 3
	callchannel .sub1
	callchannel .sub2
	octave 4
	note A#, 1
	octave 5
	note C_, 3
	stereopanning $f0
	callchannel .sub1
	callchannel .sub3
	note D_, 3
	callchannel .sub1
	callchannel .sub3
	note D_, 1
	octave 3
	note F_, 1
	note __, 1
	callchannel .sub1
	callchannel .sub3
	note D_, 3
	callchannel .sub1
	stereopanning $ff
	octave 2
	note F_, 1
	octave 3
	note F_, 1
	octave 5
	note C_, 1
	octave 4
	note F_, 1
	octave 2
	note F_, 1
	octave 5
	note C_, 1
	octave 3
	note F_, 1
	octave 5
	note D#, 3
	note D_, 1
	note __, 1
	note D#, 1
	note F_, 1
	note __, 2
	callchannel .sub1
	callchannel .sub2
	octave 4
	note G_, 1
	note A_, 3
	callchannel .sub1
	callchannel .sub2
	octave 4
	note A#, 1
	octave 5
	note C_, 3
	stereopanning $f0
	callchannel .sub1
	callchannel .sub3
	note D_, 3
	callchannel .sub1
	callchannel .sub3
	note D_, 1
	octave 3
	note F_, 1
	note __, 1
	callchannel .sub1
	callchannel .sub3
	note D_, 3
	callchannel .sub1
	octave 2
	note F_, 1
	octave 3
	note F_, 1
	octave 5
	note C_, 1
	octave 4
	note F_, 1
	octave 3
	note F_, 1
	octave 5
	note C_, 1
	octave 4
	note F_, 1
	octave 3
	note F_, 1
	octave 5
	note D#, 1
	note __, 1
	note D_, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 4
	note A#, 1
	note __, 1
	intensity $15
	callchannel .sub4
	octave 2
	note C_, 2
	note __, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 2
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 2
	note C_, 2
	octave 3
	note C_, 1
	octave 2
	note C_, 1
	note __, 1
	octave 3
	note C_, 1
	octave 2
	note F_, 2
	note __, 1
	note F_, 1
	octave 3
	note F_, 1
	octave 2
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	octave 3
	note F_, 1
	octave 2
	note F_, 2
	octave 3
	note F_, 1
	octave 2
	note F_, 1
	note __, 1
	octave 3
	note F_, 1
	callchannel .sub4
	octave 2
	note G_, 2
	note __, 1
	note G_, 1
	octave 3
	note G_, 1
	octave 2
	note G_, 1
	note __, 1
	note G_, 1
	note G_, 1
	octave 3
	note G_, 1
	octave 2
	note G_, 2
	octave 3
	note G_, 1
	octave 2
	note G_, 1
	note __, 1
	octave 3
	note G_, 1
	octave 2
	note B_, 1
	note B_, 1
	note B_, 1
	note __, 2
	note B_, 1
	note __, 1
	note B_, 1
	note __, 4
	notetype $6, $15
	octave 3
	note D_, 1
	note C_, 1
	octave 2
	note B_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note E_, 1
	note D_, 1
	jumpchannel .loop

.sub1
	octave 2
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note G_, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note G_, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note G_, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note A_, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note A_, 2
	endchannel

.sub2
	octave 2
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note G_, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note G_, 1
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note A#, 1
	note __, 1
	note A_, 1
	note __, 1
	endchannel

.sub3
	octave 2
	note F_, 1
	octave 3
	note F_, 1
	octave 5
	note C_, 1
	octave 4
	note F_, 1
	octave 3
	note F_, 1
	octave 5
	note C_, 1
	octave 4
	note F_, 1
	octave 3
	note F_, 1
	octave 5
	note D#, 1
	note __, 1
	note D_, 1
	note __, 1
	note C_, 1
	endchannel

.sub4
	octave 2
	note F_, 2
	note __, 1
	note F_, 1
	octave 3
	note F_, 1
	octave 2
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	octave 3
	note F_, 1
	octave 2
	note F_, 2
	octave 3
	note F_, 1
	octave 2
	note F_, 1
	note __, 1
	octave 3
	note F_, 1
	octave 2
	note G_, 2
	note __, 1
	note G_, 1
	octave 3
	note G_, 1
	octave 2
	note G_, 1
	note __, 1
	note G_, 1
	note G_, 1
	octave 3
	note G_, 1
	octave 2
	note F_, 1
	octave 3
	note F_, 1
	octave 2
	note D#, 1
	octave 3
	note D#, 1
	octave 2
	note D_, 1
	octave 3
	note D_, 1
	endchannel

Music_GameCorner_Ch4:
	togglenoise $3
	notetype $8
	note D_, 1
	note D_, 1
	note D_, 1
	notetype $c
	note D_, 1
	note D_, 1
	note D_, 2
	note D_, 1
	note D_, 1
.loop
	callchannel .sub1
	callchannel .sub2
	callchannel .sub2
	callchannel .sub3
	callchannel .sub2
	note __, 12
	note D_, 1
	note D_, 1
	note F#, 2
	callchannel .sub1
	callchannel .sub2
	callchannel .sub2
	callchannel .sub3
	callchannel .sub2
	note A#, 2
	note F#, 2
	note D_, 2
	note F#, 2
	note D#, 2
	note F#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
.repeat5
	callchannel .sub4
	note F#, 2
	loopchannel 3, .repeat5
	callchannel .sub4
	note D_, 1
	note D_, 1
.repeat6
	callchannel .sub4
	note F#, 2
	loopchannel 3, .repeat6
	note D_, 1
	note D_, 1
	note D_, 2
	note A#, 1
	note F#, 2
	note F#, 5
	note D_, 1
	note D_, 1
	note D#, 2
	jumpchannel .loop

.sub1
	note C_, 2
	note F#, 2
	note D_, 2
	note F#, 2
	note A#, 2
	note F#, 2
	note D_, 2
	note F#, 2
	endchannel

.sub2
	note A#, 2
	note F#, 2
	note D_, 2
	note F#, 2
	note A#, 2
	note F#, 2
	note D_, 2
	note F#, 2
	loopchannel 3, .sub2
	endchannel

.sub3
	note A#, 2
	note F#, 2
	note D_, 2
	note F#, 2
	note A#, 2
	note F#, 2
	note D_, 1
	note D_, 1
	note F#, 2
	endchannel

.sub4
	note A#, 2
	note F#, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note F#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note F#, 1
	note D#, 1
	note D_, 2
	endchannel
