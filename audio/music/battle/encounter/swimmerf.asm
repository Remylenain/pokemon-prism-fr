Music_LookSwimmerF:
	channelcount 4
	channel 1, Music_LookSwimmerF_Ch1
	channel 2, Music_LookSwimmerF_Ch2
	channel 3, Music_LookSwimmerF_Ch3
	channel 4, Music_LookSwimmerF_Ch4

Music_LookSwimmerF_Ch1::
	tempo 115
	volume $77
	stereopanning $0f
.loop
	dutycycle $2
	octave 3
	notetype $c, $a2
	vibrato $12, $23
	note E_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	dutycycle $1
	note C_, 1
	note __, 3
	octave 3
	note G_, 2
	dutycycle $2
	note A_, 2
	octave 4
	note C_, 1
	note __, 3
	octave 3
	note C_, 2
	note D_, 2
	dutycycle $1
	note E_, 1
	note __, 3
	vibrato $00, $33
	notetype $c, $a7
	note G_, 4
	octave 4
	vibrato $12, $23
	notetype $c, $a2
	dutycycle $2
	note C_, 2
	note __, 2
	octave 3
	note F_, 1
	note __, 3
	note D_, 1
	note __, 3
	note D_, 2
	note E_, 2
	note D_, 2
	note __, 2
	note D_, 2
	note __, 2
	dutycycle $1
	note E_, 2
	note __, 2
	note E_, 2
	note G_, 2
	jumpchannel .loop

Music_LookSwimmerF_Ch2::
	dutycycle $2
	stereopanning $f0
.loop
	notetype $c, $c2
	vibrato $12, $23
	octave 4
	note G_, 2
	note G#, 2
	note A_, 2
	note B_, 2
	octave 5
	dutycycle $1
	note C_, 1
	note __, 3
	octave 4
	note A#, 1
	note __, 3
	dutycycle $2
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note A_, 2
	note B_, 2
	dutycycle $1
	note G_, 1
	note __, 3
	notetype $c, $c7
	vibrato $0, $33
	note G_, 4
	notetype $c, $c2
	vibrato $12, $23
	dutycycle $2
	note E_, 2
	note F_, 2
	note F#, 2
	note G_, 2
	dutycycle $1
	note D_, 1
	note __, 3
	note D_, 1
	note __, 3
	dutycycle $2
	note F_, 2
	note G_, 2
	note G#, 2
	note A_, 2
	dutycycle $1
	note E_, 2
	note D#, 2
	vibrato $0, $33
	notetype $c, $c7
	note E_, 4
	jumpchannel .loop

Music_LookSwimmerF_Ch3::
	stereopanning $ff
	vibrato $6, $26
	notetype $c, $16
.loop
	octave 3
	note C_, 1
	note __, 1
	note E_, 1
	note __, 1
	note C_, 1
	note __, 3
	note C_, 1
	note __, 3
	note C_, 1
	note __, 1
	note E_, 1
	note __, 1
	note C_, 1
	note __, 3
	note C_, 1
	note __, 1
	note E_, 1
	note __, 1
	note G_, 1
	note __, 1
	note F#, 1
	note __, 1
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
.repeat
	note B_, 1
	note __, 1
	note D_, 1
	note __, 1
	note B_, 1
	note __, 3
	note B_, 1
	note __, 3
	loopchannel 2, .repeat
	octave 4
	note C_, 1
	octave 3
	note __, 1
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
	note E_, 1
	note __, 1
	jumpchannel .loop

Music_LookSwimmerF_Ch4::
	togglenoise $3
	notetype $c
.loop
	note D#, 4
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note D#, 4
	note D_, 4
	note D#, 4
	note D_, 4
	note D#, 4
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	jumpchannel .loop
