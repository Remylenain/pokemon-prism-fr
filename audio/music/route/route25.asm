Music_Route25:
	channelcount 4
	channel 1, Music_Route25_Ch1
	channel 2, Music_Route25_Ch2
	channel 3, Music_Route25_Ch3
	channel 4, Music_Route25_Ch4

Music_Route25_Ch1:
	tempo 168
	stereopanning $f
	volume $77
	tone $0001
	notetype $c, $b5
	octave 2
.loop
	callchannel .sub1
	note A_, 6
	dutycycle 2
	note A_, 1
	note G#, 1
	note F#, 4
	callchannel .sub1
	octave 3
	note E_, 6
	dutycycle 2
	octave 2
	note B_, 1
	octave 3
	note C#, 1
	note D_, 4
	note A_, 2
	note E_, 2
	octave 2
	note A_, 4
	octave 3
	note G#, 2
	note E_, 2
	octave 2
	note G#, 4
	octave 3
	note F#, 2
	note C#, 2
	octave 2
	note F#, 4
	octave 3
	note E_, 2
	note C#, 2
	note D#, 2
	note C#, 2
	octave 2
	note F#, 2
	note F#, 1
	note G#, 1
	note A_, 6
	note F#, 2
	octave 3
	note D_, 4
	note E_, 3
	octave 2
	note A_, 1
	note G#, 6
	note E_, 2
	note A_, 2
	note G#, 2
	callchannel .sub2
	note E_, 1
	note F#, 1
	note G#, 2
	note F#, 1
	note E_, 1
	callchannel .sub2
	note G#, 1
	note A_, 1
	note B_, 2
	note A_, 1
	note G#, 1
	intensity $b2
	note B_, 2
	note B_, 1
	octave 3
	note C#, 1
	note D_, 2
	note D_, 1
	note E_, 1
	note F#, 2
	note F#, 1
	note G#, 1
	note A_, 4
	octave 2
	note B_, 2
	note B_, 1
	octave 3
	note C#, 1
	note D#, 2
	note D#, 1
	note E_, 1
	note F#, 2
	note F#, 1
	note G#, 1
	intensity $b5
	note A_, 4
	jumpchannel .loop

.sub1
	dutycycle 1
	note G#, 6
	octave 2
	note G#, 1
	note B_, 1
	note A_, 4
	note F#, 2
	octave 3
	note C#, 2
	octave 2
	note B_, 3
	note G#, 1
	endchannel

.sub2
	intensity $b2
	note B_, 2
	note B_, 1
	octave 3
	note C#, 1
	note D_, 2
	note D_, 1
	note E_, 1
	note F#, 2
	note D_, 2
	note A_, 4
	note G#, 3
	note F#, 1
	note E_, 6
	intensity $b1
	octave 2
	endchannel

Music_Route25_Ch2:
	stereopanning $f0
	tone $0002
	octave 3
.loop
	notetype $c, $c5
	dutycycle 1
	callchannel .sub1
	note F#, 12
	callchannel .sub1
	note B_, 12
	dutycycle 0
	octave 4
	note C#, 6
	octave 3
	note B_, 1
	note A_, 1
	note B_, 6
	note A_, 1
	note G#, 1
	note A_, 6
	note G#, 1
	note F#, 1
	note G#, 4
	dutycycle 2
	note F#, 2
	note E_, 2
	note D_, 2
	note D_, 1
	note E_, 1
	note F#, 8
	note A_, 4
	note G#, 3
	note F#, 1
	note E_, 8
	dutycycle 1
	note F#, 2
	note E_, 2
	callchannel .sub2
	dutycycle 0
	callchannel .sub2
	dutycycle 2
	note D_, 2
	note D_, 1
	note E_, 1
	note F#, 2
	note F#, 1
	note G#, 1
	note A_, 2
	note A_, 1
	note B_, 1
	octave 4
	note C#, 4
	octave 3
	note D#, 2
	note D#, 1
	note E_, 1
	note F#, 2
	note F#, 1
	note G#, 1
	note A_, 2
	note B_, 1
	octave 4
	note C#, 1
	notetype 6, $c5
	note D#, 4
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note C#, 1
	note D#, 1
	jumpchannel .loop

.sub1
	note E_, 6
	octave 2
	note B_, 1
	octave 3
	note E_, 1
	note F#, 6
	note A_, 2
	note G#, 3
	note E_, 1
	endchannel

.sub2
	note D_, 2
	note D_, 1
	note E_, 1
	note F#, 2
	note F#, 1
	note G#, 1
	note A_, 4
	octave 4
	note C#, 4
	octave 3
	note B_, 3
	note A_, 1
	note G#, 12
	endchannel

Music_Route25_Ch3:
	notetype $c, $15
	octave 2
	note E_, 4
	note __, 8
	note D_, 4
	note E_, 1
	note __, 11
	octave 1
	note B_, 4
	octave 2
	note E_, 4
	note __, 8
	note D_, 4
	note E_, 1
	note __, 11
	note G#, 4
	notetype 4, $24
	octave 3
	note A_, 2
	octave 5
	note C#, 2
	note E_, 2
	note A_, 2
	octave 6
	note C#, 2
	note E_, 2
	note A_, 2
	note E_, 2
	note C#, 2
	octave 5
	note A_, 2
	note E_, 2
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note B_, 2
	octave 5
	note E_, 2
	note G#, 2
	note B_, 2
	octave 6
	note E_, 2
	note G#, 2
	note E_, 2
	octave 5
	note B_, 2
	note G#, 2
	note E_, 2
	octave 4
	note B_, 2
	octave 3
	note F#, 2
	octave 4
	note A_, 2
	octave 5
	note C#, 2
	note F#, 2
	note A_, 2
	octave 6
	note C#, 2
	note F#, 2
	note C#, 2
	octave 5
	note A_, 2
	note F#, 2
	note C#, 2
	octave 4
	note A_, 2
	octave 3
	note C#, 2
	octave 4
	note E_, 2
	note G#, 2
	octave 5
	note C#, 2
	note E_, 2
	note G#, 2
	octave 6
	note C#, 3
	note __, 9
.repeat1
	intensity $15
	octave 2
	note D_, 3
	note __, 3
	intensity $24
	octave 5
	note A_, 3
	octave 4
	note D_, 3
	loopchannel 4, .repeat1
.repeat2
	intensity $15
	octave 2
	note E_, 3
	note __, 3
	intensity $24
	octave 5
	note B_, 3
	octave 4
	note E_, 3
	loopchannel 4, .repeat2
.repeat3
	intensity $15
	octave 1
	note B_, 3
	note __, 3
	intensity $24
	octave 6
	note D_, 3
	octave 4
	note F#, 3
	loopchannel 4, .repeat3
.repeat4
	intensity $15
	octave 2
	note E_, 3
	note __, 3
	intensity $24
	octave 6
	note E_, 3
	octave 4
	note B_, 3
	loopchannel 4, .repeat4
.repeat5
	intensity $15
	octave 1
	note B_, 3
	intensity $24
	octave 4
	note A_, 3
	octave 6
	note F#, 3
	octave 5
	note D_, 3
	loopchannel 4, .repeat5
.repeat6
	intensity $15
	octave 2
	note E_, 3
	intensity $24
	octave 4
	note B_, 3
	octave 6
	note G#, 3
	octave 5
	note E_, 3
	loopchannel 4, .repeat6
	notetype 6, $15
	octave 1
.repeat7
	note B_, 2
	note __, 16
	note __, 2
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note B_, 6
	note __, 2
	loopchannel 2, .repeat7
	jumpchannel Music_Route25_Ch3

Music_Route25_Ch4:
	notetype 4
	togglenoise 0
.loop
	note A_, 16
	note __, 2
	note D_, 3
	note D_, 3
	note D_, 12
	rept 6
		note D_, 2
	endr
	note D_, 16
	note __, 2
	note D_, 3
	note D_, 3
	note D_, 12
	note D_, 3
	note D_, 3
	note D_, 3
	note D_, 3
	loopchannel 2, .loop
	note A_, 16
	rept 5
		note __, 16
	endr
	jumpchannel .skip
.repeat
	note D_, 12
	note D_, 6
	note D_, 2
	note D_, 2
	note D_, 2
.skip
	note D_, 12
	note D_, 12
	note D_, 12
	note D_, 6
	note D_, 3
	note D_, 3
	note D_, 12
	note D_, 12
	loopchannel 3, .repeat
	note D_, 6
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 3
	note D_, 3
	note D_, 3
	note D_, 3
	note D_, 16
	note __, 14
	note D_, 3
	note D_, 3
	note A_, 6
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 16
	note __, 14
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 3
	note D_, 3
	note D_, 3
	note D_, 3
	jumpchannel .loop
