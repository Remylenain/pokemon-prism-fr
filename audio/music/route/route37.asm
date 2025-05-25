Music_Route37:
	channelcount 4
	channel 1, Music_Route37_Ch1
	channel 2, Music_Route37_Ch2
	channel 3, Music_Route37_Ch3
	channel 4, Music_Route37_Ch4

Music_Route37_Ch1:
	tempo 144
	volume $77
	dutycycle $3
	tone $0002
	vibrato $10, $22
	notetype $c, $b3
	note __, 16
	note __, 12
.loop
	note __, 6
	octave 2
	note F#, 2
	note B_, 2
	octave 3
	note E_, 2
	intensity $b7
	note D#, 10
	intensity $b3
	note E_, 4
	note D#, 4
	note C#, 4
	octave 2
	note B_, 2
	octave 3
	note D#, 3
	octave 2
	note B_, 1
	intensity $b7
	note F#, 8
	note B_, 8
	octave 3
	note B_, 12
	intensity $b3
	note __, 2
	octave 2
	note F#, 2
	note B_, 2
	octave 3
	note E_, 2
	intensity $b7
	note D#, 10
	octave 2
	note A_, 4
	octave 3
	note C#, 4
	note E_, 4
	note A_, 2
	note F#, 3
	note A_, 1
	note B_, 6
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	note F#, 2
	note B_, 2
	note A_, 4
	note F#, 4
	note E_, 2
	note D#, 4
	stereopanning $f
.repeat1
	callchannel .sub1
	octave 3
	note C#, 4
	loopchannel 2, .repeat1
.repeat2
	callchannel .sub2
	octave 3
	note F#, 4
	loopchannel 2, .repeat2
	callchannel .sub1
	octave 3
	note E_, 4
	callchannel .sub1
	octave 3
	note G#, 4
	callchannel .sub2
	octave 4
	note D#, 4
	callchannel .sub2
	octave 3
	note F_, 4
	stereopanning $ff
	callchannel .sub2
	note __, 4
	callchannel .sub2
	intensity $b3
	jumpchannel .loop

.sub1
	intensity $c2
	octave 2
	note A_, 2
	note A_, 1
	note A_, 1
	note A_, 2
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 1
	note A_, 2
	intensity $b7
	endchannel

.sub2
	intensity $c2
	octave 2
	note B_, 2
	note B_, 1
	note B_, 1
	note B_, 2
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 2
	intensity $b7
	endchannel

Music_Route37_Ch2:
	dutycycle $3
	vibrato $1c, $12
	octave 2
	callchannel .sub1
	callchannel .sub1
	note B_, 1
	note B_, 1
	intensity $c2
	note B_, 6
	note B_, 2
	intensity $c1
	note B_, 1
	note B_, 1
	callchannel .sub1
	note B_, 1
	note B_, 1
	intensity $c2
	note B_, 2
.loop
	callchannel .sub2
	intensity $c6
	octave 4
	note C#, 4
	octave 3
	note B_, 4
	note A_, 4
	note E_, 4
	intensity $b0
	note F#, 8
	intensity $b7
	note F#, 8
	intensity $c7
	note D#, 12
	callchannel .sub2
	intensity $c7
	octave 4
	note C#, 4
	octave 3
	note B_, 4
	octave 4
	note C#, 4
	note E_, 4
	intensity $b0
	note D#, 16
	intensity $b0
	note D#, 8
	intensity $b7
	note D#, 8
	callchannel .sub3
	note E_, 1
	intensity $b0
	note D#, 6
	intensity $b7
	note D#, 6
	intensity $c3
	octave 3
	note B_, 3
	note F#, 1
	intensity $b0
	octave 4
	note D#, 6
	intensity $b7
	octave 4
	note D#, 6
	callchannel .sub3
	note D#, 1
	intensity $b0
	note B_, 6
	intensity $b7
	note B_, 6
	intensity $c3
	note B_, 3
	note F#, 1
	intensity $b0
	octave 5
	note D#, 6
	intensity $b7
	octave 5
	note D#, 6
	intensity $c2
	octave 3
	callchannel .sub4
	note F#, 6
	callchannel .sub4
	note F#, 2
	jumpchannel .loop

.sub1
	notetype $c, $c2
	note B_, 2
	intensity $c1
	note B_, 1
	note B_, 1
	endchannel

.sub2
	intensity $c7
	octave 3
	note F#, 4
	intensity $b0
	note B_, 5
	intensity $b7
	note B_, 5
	intensity $c3
	note F#, 2
	note F#, 2
	note B_, 2
	endchannel

.sub3
	intensity $c4
	note __, 4
	octave 3
	note A_, 3
	octave 4
	note E_, 1
	note A_, 4
	note G#, 4
	intensity $b0
	note C#, 6
	note D#, 6
	note E_, 4
	intensity $c3
	note F#, 3
	endchannel

.sub4
	note F#, 2
	note F#, 1
	note F#, 1
	note F#, 2
	intensity $c1
	note F#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	intensity $c2
	endchannel

Music_Route37_Ch3:
	stereopanning $f0
	notetype $c, $14
	octave 2
.loop
	note F#, 2
	note __, 6
	loopchannel 4, .loop
	callchannel .sub1
	callchannel .sub2
	note F#, 2
	note E_, 2
.repeat1
	note D#, 2
	note F#, 2
	loopchannel 4, .repeat1
	callchannel .sub1
	callchannel .sub1
	callchannel .sub2
	octave 3
	note C#, 2
	octave 2
	note A_, 2
	callchannel .sub1
.repeat2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	loopchannel 4, .repeat2
	callchannel .sub3
.repeat3
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	loopchannel 4, .repeat3
	callchannel .sub3
	callchannel .sub1
	jumpchannel .loop

.sub1
	octave 2
.repeat4
	note F#, 2
	note B_, 2
	loopchannel 4, .repeat4
	endchannel

.sub2
	note A_, 2
	octave 3
	note C#, 2
	octave 2
	note G#, 2
	note B_, 2
	note F#, 2
	note A_, 2
	endchannel

.sub3
	octave 2
	note A_, 2
	octave 3
	note C#, 2
	loopchannel 7, .sub3
	note E_, 2
	note C#, 2
.repeat5
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	loopchannel 4, .repeat5
	endchannel

Music_Route37_Ch4:
	stereopanning $f
	togglenoise $0
	notetype $6
.loop
	callchannel .sub
	note D_, 2
	note D#, 2
	note D#, 2
	note D_, 2
	callchannel .sub
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	jumpchannel .loop

.sub
	note D_, 4
	note D#, 2
	note D#, 2
	loopchannel 3, .sub
	endchannel
