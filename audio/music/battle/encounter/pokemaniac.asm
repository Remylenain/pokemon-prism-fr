Music_LookPokemaniac:
	channelcount 3
	channel 1, Music_LookPokemaniac_Ch1
	channel 2, Music_LookPokemaniac_Ch2
	channel 3, Music_LookPokemaniac_Ch3

Music_LookPokemaniac_Ch1:
	stereopanning $f
	tempo 144
	volume $77
	vibrato $2, $33
	tone $0002
	notetype $c, $b3
	note __, 8
.loop
	note __, 4
	octave 3
	note A#, 1
	note __, 3
	note A#, 1
	note __, 3
	loopchannel 4, .loop
	note __, 4
	note G_, 1
	note __, 3
	note G_, 1
	note __, 3
	; never terminates (only reachable with a loop counter of 0 due to the previous loop)
	loopchannel 4, .loop

Music_LookPokemaniac_Ch2:
	stereopanning $ff
	vibrato $2, $33
	tone $0001
	notetype $c, $b3
	octave 2
	note A_, 1
	note F#, 1
	note D#, 1
	note C_, 1
	octave 1
	note A_, 4
.loop
	octave 2
	note C_, 2
	note __, 2
	octave 3
	note F#, 1
	note __, 3
	note A_, 1
	note __, 3
	octave 1
	note G_, 2
	note __, 2
	octave 3
	note C_, 1
	note __, 3
	note D#, 1
	note __, 3
	loopchannel 2, .loop
.repeat
	octave 1
	note A_, 2
	note __, 2
	octave 3
	note D#, 1
	note __, 3
	note F#, 1
	note __, 3
	octave 1
	note E_, 2
	note __, 2
	octave 2
	note A_, 1
	note __, 3
	octave 3
	note C_, 1
	note __, 3
	loopchannel 2, .repeat
	jumpchannel .loop

Music_LookPokemaniac_Ch3:
	stereopanning $f0
	vibrato $6, $33
	notetype $c, $15
	octave 4
	note C_, 1
	note D#, 1
	note F#, 1
	note A_, 1
	octave 5
	note C_, 4
	intensity $10
.loop
	callchannel .sub
	intensity $14
	callchannel .sub
	intensity $10
	jumpchannel .loop

.sub
	note A#, 6
	note A_, 2
	note G#, 2
	note G_, 2
	note F#, 6
	note F_, 2
	note F#, 2
	note A_, 2
	octave 4
	note D#, 4
	note C_, 1
	note __, 1
	note D#, 1
	note __, 1
	note C_, 1
	note __, 1
	note D#, 1
	note __, 1
	octave 5
	note F#, 4
	note C_, 1
	note __, 1
	note F#, 1
	note __, 1
	note C_, 1
	note __, 1
	note F#, 1
	note __, 1
	note G_, 6
	note F#, 2
	note F_, 2
	note E_, 2
	note D#, 6
	note D_, 2
	note D#, 2
	note F#, 2
	note C_, 4
	octave 4
	note A_, 1
	note __, 1
	octave 5
	note C_, 1
	note __, 1
	note D#, 1
	note __, 1
	note C_, 1
	note __, 1
	note D#, 4
	octave 4
	note A_, 1
	note __, 1
	octave 5
	note D#, 1
	note __, 1
	note F#, 1
	note __, 1
	note C_, 1
	note __, 1
	endchannel
