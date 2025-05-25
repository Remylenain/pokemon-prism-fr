Music_JohtoGym:
	channelcount 4
	channel 1, Music_JohtoGym_Ch1
	channel 2, Music_JohtoGym_Ch2
	channel 3, Music_JohtoGym_Ch3
	channel 4, Music_JohtoGym_Ch4

Music_JohtoGym_Ch1:
	tempo 156
	volume $77
	stereopanning $f
	vibrato $12, $24
	dutycycle $1
	notetype $c, $b7
.loop
	octave 4
	note F#, 2
	octave 2
	note A_, 1
	note A_, 1
	note A_, 1
	note __, 3
	octave 4
	note E_, 2
	octave 2
	note G_, 1
	note G_, 1
	note G_, 1
	note __, 3
	octave 4
	note D_, 2
	octave 2
	note D_, 1
	note D_, 1
	note D_, 1
	note __, 1
	octave 3
	note D_, 1
	note D_, 1
	note B_, 1
	note G_, 1
	note D_, 1
	note B_, 1
	octave 4
	note C#, 1
	octave 3
	note A_, 1
	note E_, 1
	octave 4
	note E_, 1
	octave 3
	note A_, 12
	note F#, 2
	note A_, 2
	note G_, 1
	note __, 2
	note E_, 1
	note E_, 2
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	note F#, 8
	note A_, 4
	note F#, 2
	note A_, 2
	note E_, 1
	note __, 1
	note E_, 1
	note F#, 1
	note G_, 4
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	octave 4
	note C_, 2
	note D_, 6
	octave 3
	note A_, 2
	note F#, 2
	note E_, 2
	note G_, 2
	note A_, 2
	note B_, 1
	note __, 2
	note G_, 1
	note G_, 4
	octave 4
	note E_, 1
	note __, 2
	note C_, 1
	note C_, 2
	octave 3
	note B_, 1
	note A#, 1
	note A_, 12
	note F#, 2
	note A_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 1
	octave 4
	note C_, 1
	note E_, 2
	note C_, 2
	note E_, 2
	note C_, 1
	note E_, 1
	note G_, 4
	note D_, 6
	callchannel .sub
	note G_, 4
	note F#, 4
	note E_, 4
	note C_, 4
	note D_, 1
	note __, 1
	note D_, 1
	note E_, 1
	note __, 2
	octave 3
	note B_, 4
	note F#, 2
	note D_, 2
	note F#, 2
	note A#, 1
	note A_, 1
	note G_, 1
	note F_, 1
	octave 4
	note D_, 4
	note C_, 1
	octave 3
	note A#, 1
	note A_, 1
	note G_, 1
	octave 4
	note E_, 4
	note F#, 6
	callchannel .sub
	note A_, 4
	note G_, 4
	note F#, 4
	note E_, 4
	note D_, 1
	octave 3
	note B_, 1
	note F#, 1
	octave 4
	note E_, 1
	note F#, 4
	note E_, 1
	note C_, 1
	octave 3
	note G_, 1
	octave 4
	note F#, 1
	note G_, 4
	note A_, 1
	note G_, 1
	note F#, 1
	note E_, 1
	note A_, 4
	octave 5
	note D_, 4
	octave 4
	note A_, 1
	note G_, 1
	note F#, 1
	note E_, 1
	jumpchannel .loop

.sub
	octave 3
	note A_, 1
	note __, 3
	note A_, 1
	note __, 1
	note A_, 1
	octave 4
	note F#, 3
	endchannel

Music_JohtoGym_Ch2:
	dutycycle $1
	stereopanning $f0
.loop
	notetype $c, $c3
	octave 2
	note D_, 2
	octave 1
	note D_, 1
	note D_, 1
	note D_, 2
	note A_, 1
	octave 2
	note F#, 1
	note C_, 2
	octave 1
	note C_, 1
	note C_, 1
	note C_, 2
	octave 2
	note G_, 1
	note E_, 1
	octave 1
	note G_, 2
	octave 1
	note G_, 1
	note G_, 1
	note G_, 2
	octave 1
	note G_, 1
	note G_, 1
	note A_, 4
	octave 2
	note A_, 2
	octave 3
	note C_, 1
	note C#, 1
	callchannel .sub1
	note E_, 2
	note C_, 1
	note C#, 1
	callchannel .sub1
	note C_, 1
	note E_, 1
	note G_, 1
	octave 4
	note C_, 1
	intensity $d2
	callchannel .sub2
	note F#, 1
	note B_, 1
	note F#, 2
	octave 2
	note F#, 2
	octave 1
	note B_, 2
	note A#, 4
	note A#, 2
	note F_, 1
	note F_, 1
	note G_, 1
	octave 2
	note C_, 1
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	note E_, 2
	callchannel .sub2
	note G_, 1
	octave 2
	note C_, 1
	octave 1
	note G_, 2
	octave 2
	note E_, 2
	note C_, 2
	note D_, 4
	note D_, 2
	octave 1
	note A_, 1
	note A_, 1
	note A_, 1
	octave 2
	note D_, 1
	octave 1
	note A_, 2
	octave 2
	note F#, 2
	note D_, 2
	jumpchannel .loop

.repeat
	note E_, 2
	note C_, 1
	note C#, 1
.sub1
	note D_, 3
	octave 2
	note D_, 3
	note D_, 2
	note D_, 1
	note D_, 1
	note D_, 2
	octave 3
	note D_, 2
	octave 2
	note A_, 2
	octave 3
	note C_, 3
	octave 2
	note C_, 3
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 2
	octave 3
	loopchannel 2, .repeat
	endchannel

.sub2
	octave 2
	note D_, 4
	note D_, 2
	octave 1
	note A_, 1
	note A_, 1
	note A_, 1
	octave 2
	note D_, 1
	octave 1
	note A_, 2
	octave 2
	note A_, 2
	note D_, 2
	note C_, 4
	note C_, 2
	octave 1
	note G_, 1
	note G_, 1
	note G_, 1
	octave 2
	note C_, 1
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	note C_, 2
	octave 1
	note B_, 2
	note __, 2
	note B_, 2
	note F#, 1
	note F#, 1
	endchannel

Music_JohtoGym_Ch3:
	vibrato $14, $23
	stereopanning $ff
.loop
	notetype $c, $14
	octave 6
	note D_, 2
	octave 4
	note D_, 1
	note D_, 1
	note D_, 1
	note __, 1
	octave 5
	note A_, 1
	octave 6
	note D_, 1
	note C_, 2
	octave 4
	note C_, 1
	note C_, 1
	note C_, 1
	note __, 1
	octave 5
	note A_, 1
	octave 6
	note C_, 1
	octave 5
	note B_, 2
	octave 3
	note G_, 1
	note G_, 1
	note G_, 1
	note __, 1
	octave 5
	note B_, 1
	note B_, 1
	note B_, 4
	octave 6
	note C#, 4
	octave 5
	note D_, 12
	octave 4
	note A_, 2
	octave 5
	note D_, 2
	note E_, 1
	note __, 2
	note C_, 1
	note C_, 4
	note G_, 4
	note E_, 4
	note D_, 12
	octave 4
	note A_, 2
	octave 5
	note D_, 2
	note C_, 1
	note __, 1
	note C_, 1
	note D_, 1
	note E_, 8
	note __, 4
	note F#, 12
	note E_, 2
	note F#, 2
	note G_, 1
	note __, 2
	note E_, 1
	note E_, 4
	octave 6
	note C_, 1
	note __, 2
	octave 5
	note G_, 1
	note G_, 4
	note F#, 12
	note E_, 2
	note F#, 2
	note G_, 2
	note E_, 1
	note G_, 1
	octave 6
	note C_, 8
	octave 5
	note B_, 4
	intensity $13
	callchannel .sub
	note __, 2
	note A_, 2
	octave 6
	note D_, 2
	octave 5
	note A_, 2
	octave 6
	note C_, 4
	octave 5
	note A#, 4
	note A_, 4
	note G_, 4
	callchannel .sub
	note A_, 1
	note __, 1
	note A_, 1
	note B_, 1
	octave 6
	note C_, 4
	note D_, 1
	note __, 1
	note D_, 1
	note E_, 1
	note F#, 8
	note E_, 4
	jumpchannel .loop

.sub
	octave 5
	note A_, 6
	octave 6
	note D_, 6
	octave 5
	note A_, 4
	octave 6
	note C_, 4
	octave 5
	note B_, 4
	note A_, 4
	note G_, 4
	note F#, 1
	note __, 1
	note F#, 1
	note G_, 1
	note A_, 4
	endchannel

Music_JohtoGym_Ch4:
	togglenoise $4
	notetype $6
.loop
	note D_, 4
	note C#, 2
	note C#, 2
	note B_, 8
	note D_, 4
	note C#, 2
	note C#, 2
	note B_, 8
	note D_, 4
	note C#, 2
	note C#, 2
	note D_, 4
	note C#, 2
	note C#, 2
	note A#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note C#, 2
	note C#, 2
	note D_, 2
	note D_, 2
.repeat1
	note D_, 6
	note D_, 6
	note D_, 4
	note D_, 2
	note D_, 2
	note D_, 4
	rept 8
		note C#, 1
	endr
	note D_, 6
	note D_, 6
	note D_, 4
	note D_, 2
	note D_, 2
	note D_, 4
	note B_, 8
	loopchannel 4, .repeat1
.repeat2
	note D#, 4
	note F#, 4
	note D_, 4
	note D#, 2
	note D_, 2
	note D#, 2
	note D_, 2
	note D#, 4
	note D_, 4
	note F#, 4
	loopchannel 8, .repeat2
	jumpchannel .loop
