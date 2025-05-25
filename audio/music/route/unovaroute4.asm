Music_UnovaRoute4:
	channelcount 4
	channel 1, Music_UnovaRoute4_Ch1
	channel 2, Music_UnovaRoute4_Ch2
	channel 3, Music_UnovaRoute4_Ch3
	channel 4, Music_UnovaRoute4_Ch4

Music_UnovaRoute4_Ch1:
	tempo 144
	volume $77
	tone $0002
	vibrato $10, $22
.loop
	dutycycle $3
	notetype $c, $b2
	octave 2
	note B_, 2
	note B_, 4
	intensity $b1
	note B_, 1
	note B_, 1
	intensity $b2
	note B_, 2
	note B_, 4
	note B_, 2
	octave 3
	callchannel .sub1
	note D#, 2
	note D#, 4
	intensity $b1
	note D#, 1
	note D#, 1
	intensity $b2
	note D#, 2
	note D#, 4
	note D#, 2
	callchannel .sub1
	loopchannel 3, .loop
	dutycycle $0
	intensity $80
	callchannel .sub2
	note E_, 2
	note C#, 2
	note E_, 2
	note C#, 4
	note E_, 2
	note C#, 2
	note E_, 2
	callchannel .sub2
	octave 3
	note C#, 2
	octave 2
	note A_, 2
	octave 3
	note C#, 2
	octave 2
	note A_, 4
	octave 3
	note C#, 2
	octave 2
	note A_, 2
	octave 3
	note C#, 2
	callchannel .sub2
	notetype $8, $b0
	octave 2
	note A_, 4
	note B_, 4
	octave 3
	note E_, 4
	note D#, 6
	note C#, 6
	notetype $c, $c7
	note __, 4
	note F#, 6
	note B_, 6
	octave 4
	note G#, 6
	note F#, 6
	note E_, 4
	intensity $c0
	note D#, 8
	intensity $c7
	note D#, 8
	note C#, 1
	note __, 2
	note D#, 1
	intensity $c0
	note E_, 4
	intensity $c7
	note E_, 8
	loopchannel 3, .loop

.sub1
	note C#, 2
	note C#, 4
	intensity $b1
	note C#, 1
	note C#, 1
	intensity $b2
	note C#, 2
	note C#, 4
	note C#, 2
	endchannel

.repeat
	octave 2
	note B_, 4
.sub2
	octave 3
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	loopchannel 2, .repeat
	endchannel

Music_UnovaRoute4_Ch2:
	dutycycle $3
	vibrato $1c, $12
	notetype $6, $c2
	octave 3
	note D#, 4
	note D#, 8
	intensity $c1
	note D#, 2
	note D#, 2
	intensity $c2
	note D#, 4
	note D#, 8
	intensity $c1
	note C#, 2
	note D#, 2
	intensity $c2
	note E_, 4
	note E_, 8
	intensity $c1
	note E_, 2
	note E_, 2
	intensity $c2
	note E_, 4
	note E_, 8
	intensity $c1
	note D#, 2
	note E_, 2
	intensity $c2
	note F#, 4
	note F#, 8
	intensity $c1
	note F#, 2
	note F#, 2
	intensity $c2
	note F#, 4
	note D#, 4
	note F#, 4
	note B_, 4
	intensity $c7
	note A_, 8
	note G#, 8
	note A_, 8
	octave 4
	note C#, 8
	intensity $c0
	octave 3
	note B_, 16
	intensity $c7
	note B_, 16
	note __, 4
	note F#, 4
	octave 4
	note F#, 4
	note E_, 4
	note D#, 4
	note C#, 4
	octave 3
	note B_, 4
	note F#, 4
	intensity $c0
	note A_, 16
	intensity $c7
	note A_, 16
	note __, 4
	note F#, 4
	note A_, 4
	note B_, 4
	octave 4
	note C#, 4
	note D#, 4
	note E_, 4
	note C#, 4
	intensity $c0
	note D#, 16
	intensity $c7
	note D#, 16
	note __, 4
	octave 3
	note F#, 4
	octave 4
	note F#, 4
	note E_, 4
	note D#, 4
	note C#, 4
	octave 3
	note B_, 4
	note F#, 4
	intensity $c0
	note A_, 16
	intensity $c7
	note A_, 16
	note __, 8
	note A_, 4
	note B_, 4
	octave 4
	note C#, 4
	note D#, 4
	note E_, 4
	note C#, 4
	note __, 8
	octave 2
	intensity $b7
	note F#, 8
	note B_, 8
	octave 3
	note F#, 8
	note E_, 8
	note D#, 8
	note C#, 8
	note E_, 8
	note D#, 4
	note __, 2
	note E_, 2
	note F#, 12
	note D#, 12
	note E_, 8
	note C#, 4
	note E_, 4
	octave 4
	note C#, 4
	octave 3
	note A_, 12
	note D#, 4
	note __, 2
	note E_, 2
	note F#, 8
	note B_, 4
	note __, 2
	octave 4
	note C#, 2
	note D#, 6
	octave 3
	note A_, 1
	note B_, 1
	notetype $8, $c7
	octave 4
	note C#, 4
	octave 3
	note B_, 4
	note A_, 4
	note F#, 6
	note E_, 6
	jumpchannel Music_UnovaRoute4_Ch2

Music_UnovaRoute4_Ch3:
	stereopanning $f0
	notetype $6, $14
	octave 2
	note B_, 3
	note __, 1
	note B_, 4
	note __, 4
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note B_, 3
	note __, 1
	note B_, 4
	note __, 4
	note B_, 4
	octave 3
	note C#, 3
	note __, 1
	note C#, 4
	note __, 4
	note C#, 1
	note __, 1
	note C#, 1
	note __, 1
	note C#, 3
	note __, 1
	note C#, 4
	note __, 4
	note C#, 4
	note D#, 3
	note __, 1
	note D#, 4
	note __, 4
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note D#, 3
	note __, 1
	octave 2
	note B_, 3
	note __, 1
	octave 3
	note D#, 3
	note __, 1
	note F#, 3
	note __, 1
	note E_, 8
	note C#, 8
	note E_, 8
	octave 2
	note A_, 8
	note B_, 8
	note F#, 2
	note __, 2
	note B_, 8
	note F#, 2
	note __, 2
	note B_, 4
	note F#, 4
	octave 3
	note C#, 8
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note C#, 8
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note C#, 4
	note D_, 4
	note D#, 4
	callchannel .sub1
	intensity $14
	octave 3
	note C#, 4
	octave 2
	note A_, 4
	note A#, 4
	note B_, 4
	intensity $10
	octave 5
	note F#, 4
	note A_, 4
	note B_, 4
	octave 6
	note C#, 4
	note D#, 4
	note E_, 4
	note C#, 4
.repeat1
	note D#, 1
	note E_, 1
	loopchannel 4, .repeat1
	intensity $20
.repeat2
	note D#, 1
	note E_, 1
	loopchannel 4, .repeat2
	note D#, 2
	note E_, 2
	intensity $14
	octave 2
	note E_, 4
	note A_, 4
	note A#, 4
	note B_, 4
	callchannel .sub1
	octave 6
	note C#, 2
	note D#, 2
	intensity $10
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	intensity $14
	octave 5
	callchannel .sub2
	intensity $14
	note A_, 16
	octave 4
	note B_, 2
	octave 5
	note C#, 2
	callchannel .sub2
	notetype $c, $14
	note A_, 10
	note F#, 5
	notetype $6, $14
	note G#, 1
	note A#, 1
	note B_, 16
	note F#, 2
	note G#, 2
	notetype $8, $14
	note A_, 4
	note G#, 4
	note E_, 4
	note D#, 6
	note C#, 6
	jumpchannel Music_UnovaRoute4_Ch3

.sub1
	intensity $10
	octave 5
	note F#, 4
	octave 6
	note F#, 4
	note E_, 4
	note D#, 4
	note C#, 4
	octave 5
	note B_, 4
	note F#, 4
.repeat3
	note A_, 1
	note B_, 1
	loopchannel 4, .repeat3
	intensity $20
.repeat4
	note A_, 1
	note B_, 1
	loopchannel 4, .repeat4
	note A_, 2
	note B_, 2
	endchannel

.sub2
	note D#, 10
	intensity $24
	note C#, 1
	note D#, 1
	intensity $14
	note F#, 16
	note E_, 2
	note D#, 2
	note E_, 4
	note D#, 4
	note E_, 2
	intensity $24
	note F#, 1
	note G#, 1
	endchannel

Music_UnovaRoute4_Ch4:
	stereopanning $f
	togglenoise $0
	notetype $6
.loop
	callchannel .sub1
	note D_, 2
	note D#, 2
	note D#, 2
	note D_, 2
	callchannel .sub1
	callchannel .sub2
	loopchannel 6, .loop
.repeat
	notetype $c
	note D_, 16
	note __, 12
	notetype $6
	callchannel .sub2
	loopchannel 2, .repeat
	notetype $c
	note D_, 10
	note D#, 1
	note D_, 3
	note D#, 1
	note D#, 1
	notetype $8
	note D_, 4
	note D_, 4
	note D_, 4
	notetype $6
	note B_, 12
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	jumpchannel .loop

.sub1
	note D_, 4
	note D#, 2
	note D#, 2
	note D_, 4
	note D#, 2
	note D#, 2
	note D_, 4
	note D#, 2
	note D#, 2
	endchannel

.sub2
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	endchannel
