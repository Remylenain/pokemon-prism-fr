Music_LookDubious:
	channelcount 4
	channel 1, Music_LookDubious_Ch1
	channel 2, Music_LookDubious_Ch2
	channel 3, Music_LookDubious_Ch3
	channel 4, Music_LookDubious_Ch4

Music_LookDubious_Ch1::
	tempo 134
	volume $77
	vibrato $12, $25
	dutycycle $1
	tone $0002
	octave 5
	notetype $6, $c3
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 4
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	notetype $c, $c1
.loop
	stereopanning $f
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
.repeat
	note C_, 1
	note C_, 1
	note __, 1
	loopchannel 4, .repeat
	jumpchannel .loop

Music_LookDubious_Ch2::
	vibrato $10, $23
	dutycycle $1
	notetype $c, $c7
	tone $0003
	octave 5
	notetype $6, $c3
	note C_, 1
	octave 4
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	octave 4
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
	notetype $c, $c1
.loop
	stereopanning $f0
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
.repeat
	note F_, 1
	note F_, 1
	note __, 1
	loopchannel 4, .repeat
	jumpchannel .loop

Music_LookDubious_Ch3::
	stereopanning $ff
	vibrato $8, $23
	notetype $c, $12
	intensity $10
	note __, 8
.loop
	octave 5
	note F_, 12
	note G#, 4
	note G_, 4
	note E_, 12
	note F_, 12
	note G#, 4
	note G_, 4
	note A#, 12
	jumpchannel .loop

Music_LookDubious_Ch4:
	togglenoise $3
	notetype $c
	note __, 8
.loop
	note E_, 1
	note E_, 1
	note E_, 2
	note B_, 4
	jumpchannel .loop
