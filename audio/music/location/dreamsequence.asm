Music_DreamSequence:
	channelcount 2
	channel 1, Music_DreamSequence_Ch1
	channel 2, Music_DreamSequence_Ch2

Music_DreamSequence_Ch1:
	tempo $72
	dutycycle $0
	notetype $c, $38
	tone $0003
	note __, 6
	octave 4
	note F_, 1
	note __, 1
.loop
	jumpchannel .skip1
.repeat1
	note F_, 1
	intensity $18
	note A#, 1
.skip1
	intensity $38
	note A#, 1
	intensity $18
	note F_, 1
	intensity $38
	octave 5
	note C_, 1
	intensity $18
	octave 4
	note A#, 1
	intensity $38
	octave 5
	note F_, 1
	intensity $18
	note C_, 1
	intensity $38
	note A#, 1
	intensity $18
	note F_, 1
	intensity $38
	note F_, 1
	intensity $18
	note A#, 1
	intensity $38
	note D_, 1
	intensity $18
	note F_, 1
	intensity $38
	octave 4
	note A#, 1
	intensity $18
	octave 5
	note D_, 1
	intensity $38
	octave 4
	loopchannel 4, .repeat1
	note D_, 1
	intensity $18
	note A#, 1
	jumpchannel .skip2
.repeat2
	note D_, 1
	intensity $18
	note G_, 1
.skip2
	intensity $38
	note G_, 1
	intensity $18
	note D_, 1
	intensity $38
	note A_, 1
	intensity $18
	note G_, 1
	intensity $38
	octave 5
	note D_, 1
	intensity $18
	octave 4
	note A_, 1
	intensity $38
	octave 5
	note G_, 1
	intensity $18
	note D_, 1
	intensity $38
	note D_, 1
	intensity $18
	note G_, 1
	intensity $38
	octave 4
	note A#, 1
	intensity $18
	octave 5
	note D_, 1
	intensity $38
	octave 4
	note G_, 1
	intensity $18
	note A#, 1
	intensity $38
	loopchannel 4, .repeat2
	note F_, 1
	intensity $18
	note G_, 1
	jumpchannel .loop

Music_DreamSequence_Ch2:
	dutycycle $0
	notetype $c, $c6
	tone $0003
	octave 4
	note F_, 1
	note __, 1
.loop
	jumpchannel .skip1
.repeat1
	note F_, 1
	intensity $67
	note A#, 1
.skip1
	intensity $c6
	note A#, 1
	intensity $67
	note F_, 1
	intensity $c6
	octave 5
	note C_, 1
	intensity $67
	octave 4
	note A#, 1
	intensity $c6
	octave 5
	note F_, 1
	intensity $67
	note C_, 1
	intensity $c6
	note A#, 1
	intensity $67
	note F_, 1
	intensity $c6
	note F_, 1
	intensity $67
	note A#, 1
	intensity $c6
	note D_, 1
	intensity $67
	note F_, 1
	intensity $c6
	octave 4
	note A#, 1
	intensity $67
	octave 5
	note D_, 1
	intensity $c6
	octave 4
	loopchannel 4, .repeat1
	note D_, 1
	intensity $67
	note A#, 1
	jumpchannel .skip2
.repeat2
	note D_, 1
	intensity $67
	note G_, 1
.skip2
	intensity $c6
	note G_, 1
	intensity $67
	note D_, 1
	intensity $c6
	note A_, 1
	intensity $67
	note G_, 1
	intensity $c6
	octave 5
	note D_, 1
	intensity $67
	octave 4
	note A_, 1
	intensity $c6
	octave 5
	note G_, 1
	intensity $67
	note D_, 1
	intensity $c6
	note D_, 1
	intensity $67
	note G_, 1
	intensity $c6
	octave 4
	note A#, 1
	intensity $67
	octave 5
	note D_, 1
	intensity $c6
	octave 4
	note G_, 1
	intensity $67
	note A#, 1
	intensity $c6
	loopchannel 4, .repeat2
	note F_, 1
	intensity $67
	note G_, 1
	jumpchannel .loop
