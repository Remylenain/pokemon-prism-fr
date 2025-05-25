Music_LookTwins:
	channelcount 4
	channel 1, Music_LookTwins_Ch1
	channel 2, Music_LookTwins_Ch2
	channel 3, Music_LookTwins_Ch3
	channel 4, Music_LookTwins_Ch4

Music_LookTwins_Ch1:
	tempo 132
	volume $77
	tone $0001
	dutycycle $2
	notetype $c, $c7
	octave 3
	note B_, 1
	note __, 1
	octave 4
	note B_, 14
	stereopanning $f
	dutycycle $0
.loop
	intensity $a2
	octave 3
	note E_, 4
	intensity $a1
	note E_, 4
	note E_, 4
	note E_, 2
	intensity $a3
	note B_, 2
	jumpchannel .loop

Music_LookTwins_Ch2:
	stereopanning $f0
	dutycycle $0
	notetype $c, $83
	note __, 16
.loop
	intensity $92
	octave 2
	note B_, 4
	intensity $91
	note B_, 4
	note B_, 4
	note B_, 2
	intensity $93
	octave 3
	note G#, 2
	jumpchannel .loop

Music_LookTwins_Ch3:
	notetype $c, $10
	note __, 8
	octave 6
	note E_, 2
	note D#, 2
	note C#, 2
	note C_, 2
.loop
	octave 5
	note B_, 2
	note __, 2
	octave 6
	note D#, 2
	note __, 2
	note E_, 2
	note __, 2
	note D#, 2
	note __, 2
	note C#, 2
	note C_, 2
	octave 5
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 2
	note A#, 2
	octave 6
	note C#, 2
	octave 5
	note B_, 2
	note __, 2
	octave 6
	note C#, 2
	note __, 2
	octave 5
	note B_, 2
	note __, 2
	note A_, 2
	note __, 2
	note G#, 2
	note F#, 2
	note E_, 2
	note D#, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	jumpchannel .loop

Music_LookTwins_Ch4:
	togglenoise $4
	notetype $c
	note C_, 16
.loop
	notetype $6
	note D_, 8
	note C#, 8
	note C#, 8
	note C#, 4
	note D_, 1
	note C#, 1
	note C#, 1
	note C#, 1
	jumpchannel .loop
