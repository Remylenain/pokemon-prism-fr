Music_RijonLeague:
	channelcount 4
	channel 1, Music_RijonLeague_Ch1
	channel 2, Music_RijonLeague_Ch2
	channel 3, Music_RijonLeague_Ch3
	channel 4, Music_RijonLeague_Ch4

Music_RijonLeague_Ch1:
	tempo 103
.loop
	sound_duty 1, 1, 1, 1
	notetype $c, $b4
	vibrato $9, $11
	octave 4
	note F_, 16
	note __, 8
	note F_, 16
	note __, 8
	note F_, 12
	note F_, 12
	note F_, 12
	note F#, 6
	octave 2
	note F#, 2
	note G#, 2
	note A_, 2
	callchannel .sub1
	octave 3
	callchannel .sub1
	sound_duty 0, 1, 1, 0
	intensity $c7
	vibrato $0, $0
	note A_, 16
	note __, 8
	note B_, 16
	note __, 8
	octave 4
	note C_, 16
	note __, 8
	octave 3
	note B_, 16
	note __, 8
.repeat1
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note F_, 2
	loopchannel 3, .repeat1
	note A_, 2
	note B_, 2
	octave 4
	note D_, 2
	octave 3
.repeat2
	note B_, 2
	note G#, 2
	note E_, 2
	loopchannel 3, .repeat2
	note G#, 2
	note B_, 2
	octave 4
	note E_, 2
.repeat3
	note F_, 2
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	loopchannel 3, .repeat3
	note C_, 2
	note E_, 2
	note G_, 2
.repeat4
	octave 4
	note E_, 2
	octave 3
	note B_, 2
	note G#, 2
	loopchannel 3, .repeat4
	note B_, 2
	octave 4
	note E_, 2
	note G#, 2
	sound_duty 0, 1, 2, 3
	intensity $d1
	callchannel .sub2
	forceoctave $2
	callchannel .sub2
	forceoctave $5
	callchannel .sub2
	forceoctave $0
.repeat5
	octave 3
	note F_, 2
	note A#, 2
	octave 4
	note F_, 2
	note A#, 6
	loopchannel 3, .repeat5
	note G#, 2
	note D#, 2
	octave 3
	note G#, 2
	note D#, 2
	sound_duty 1, 1, 1, 1
	octave 4
	callchannel .sub3
	forceoctave $2
	callchannel .sub3
	forceoctave $5
	callchannel .sub3
	forceoctave $0
	intensity $f
	vibrato $10, $23
	note A#, 16
	intensity $c8
	vibrato $1, $23
	note A#, 12
	intensity $c7
	note A#, 16
	intensity $b4
	vibrato $9, $11
	note F_, 16
	note __, 8
	note F_, 12
	note F#, 4
	note C#, 4
	note F#, 4
	note F_, 16
	note __, 8
	note F_, 12
	note F#, 6
	intensity $a7
	vibrato $0, $0
	octave 3
	note C_, 2
	note D_, 2
	note D#, 2
	forceoctave $17
	callchannel .sub1
	octave 4
	callchannel .sub1
	forceoctave $0
	sound_duty 0, 1, 1, 0
	intensity $c7
	callchannel .sub4
	note C_, 6
	octave 3
	note F_, 6
	octave 4
	note C_, 4
	note C#, 3
	note __, 1
	note C#, 3
	note __, 1
	note C#, 3
	note __, 1
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	note C_, 6
	octave 3
	note F_, 6
	octave 4
	note F_, 4
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
.repeat6
	octave 3
	note G#, 6
	octave 4
	note D#, 6
	note G#, 4
	loopchannel 2, .repeat6
	note D#, 6
	octave 3
	note G#, 6
	octave 4
	note D#, 4
	note D_, 3
	note __, 1
	note D_, 3
	note __, 1
	note D_, 3
	note __, 1
	callchannel .sub5
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note G#, 12
	note F#, 16
	jumpchannel .loop

.sub1
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note A#, 2
	note __, 4
	loopchannel 3, .sub1
	note B_, 3
	note __, 1
	note B_, 3
	note __, 1
	note B_, 3
	note __, 1
	endchannel

.sub2
	octave 3
	note C_, 2
	note F_, 2
	octave 4
	note C_, 2
	note F_, 6
	loopchannel 3, .sub2
	note F#, 2
	note C#, 2
	octave 3
	note F#, 2
	note C#, 2
	endchannel

.sub3
	intensity $f
	vibrato $10, $23
	note F_, 16
	intensity $c8
	vibrato $1, $23
	note F_, 8
	note F_, 12
	note F#, 8
	endchannel

.sub5
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
.sub4
	loopchannel 3, .sub5
	endchannel

Music_RijonLeague_Ch2:
	dutycycle $2
	stereopanning $f0
	notetype $c, $b6
.loop
	callchannel .sub1
	octave 1
	note F#, 2
	note __, 2
	loopchannel 8, .loop
.repeat1
	callchannel .sub1
	forceoctave $2
	callchannel .sub1
	forceoctave $5
	callchannel .sub1
	forceoctave $0
	rept 3
		octave 1
		note A#, 2
		note __, 4
		octave 2
		note A#, 2
		note __, 4
	endr
	octave 1
	note G#, 2
	note __, 2
	octave 2
	note G#, 2
	note __, 2
	loopchannel 2, .repeat1
.repeat2
	callchannel .sub1
	octave 1
	note F#, 2
	note __, 2
	loopchannel 4, .repeat2
	callchannel .sub2
	callchannel .sub2
.repeat3
	octave 2
	note G#, 2
	note E_, 2
	note F#, 2
	note D#, 2
	note E_, 2
	note C#, 2
	note D#, 2
	octave 1
	note G#, 2
	loopchannel 3, .repeat3
	octave 2
	note G_, 2
	note __, 2
	octave 1
	note G_, 2
	note __, 2
	octave 2
	note G_, 2
	note __, 2
	callchannel .sub2
	note G#, 12
	note F#, 8
	octave 1
	note F#, 8
	jumpchannel .loop

.sub1
	rept 3
		octave 1
		note F_, 2
		note __, 4
		octave 2
		note F_, 2
		note __, 4
	endr
.sub3
	octave 1
	note F#, 2
	note __, 2
	octave 2
	note F#, 2
	note __, 2
	endchannel

.sub2
	octave 2
	note F_, 2
	note C#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	octave 1
	note A#, 2
	octave 2
	note C_, 2
	octave 1
	note F_, 2
	loopchannel 3, .sub2
	octave 2
	note F#, 2
	note __, 2
	jumpchannel .sub3

Music_RijonLeague_Ch3:
	stereopanning $f
	notetype $c, $1f
	customwave .wave1
	octave 2
.loop
	callchannel .sub1
	callchannel .sub1
	callchannel .sub1
	callchannel .sub2
	loopchannel 8, .loop
	rept 2
		callchannel .sub3
		note F#, 3
		note __, 1
		note F#, 3
		note __, 1
		forceoctave $2
		callchannel .sub3
		note F#, 3
		note __, 1
		note F#, 3
		note __, 1
		forceoctave $5
		callchannel .sub3
		note F#, 3
		note __, 1
		note F#, 3
		note __, 1
		callchannel .sub3
		note D#, 3
		note __, 1
		note D#, 3
		note __, 1
		forceoctave $0
	endr
.repeat
	callchannel .sub1
	callchannel .sub1
	callchannel .sub1
	callchannel .sub2
	loopchannel 4, .repeat
	rept 2
		callchannel .sub4
		note F#, 3
		note __, 1
		note F#, 3
		note __, 1
		note F#, 3
		note __, 1
	endr
	forceoctave $3
	callchannel .sub4
	forceoctave $0
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	callchannel .sub4
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note G#, 12
	note F#, 8
	customwave .wave2
	note F#, 8
	customwave .wave1
	jumpchannel .loop

.sub1
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	customwave .wave2
	note F_, 1
	note __, 1
	customwave .wave1
	note F_, 2
	note __, 4
	endchannel

.sub2
	note F#, 3
	note __, 1
	customwave .wave2
	note F#, 3
	note __, 1
	customwave .wave1
	note F#, 3
	note __, 1
	endchannel

.sub3
	note F_, 1
	note __, 1
	customwave .wave2
	intensity $2f
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	customwave .wave1
	intensity $1f
	loopchannel 6, .sub3
	endchannel

.sub4
	note F_, 2
	customwave .wave2
	note F_, 2
	customwave .wave1
	octave 1
	note F_, 2
	note __, 2
	octave 2
	loopchannel 6, .sub4
	endchannel

.wave1
	dn $f, $f, $f, $f, $f, $f, $b, $7, $8, $7, $8, $e, $f, $f, $b, $6
	dn $d, $f, $f, $9, $7, $a, $c, $6, $d, $f, $f, $f, $f, $e, $2, $0

.wave2
	dn $f, $f, $f, $f, $f, $f, $f, $f, $a, $7, $8, $f, $b, $6, $8, $6
	dn $d, $f, $f, $9, $7, $a, $f, $f, $f, $f, $f, $f, $b, $5, $0, $0

Music_RijonLeague_Ch4:
	notetype $c
	togglenoise $0
.loop
	note D_, 2
	note D#, 2
	note D#, 2
	note D#, 6
	note D_, 2
	note D#, 2
	note D#, 2
	note D#, 4
	note D#, 1
	note D#, 1
	note D_, 2
	note D#, 2
	note D#, 2
	note D#, 6
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	callchannel .sub1
	loopchannel 8, .loop
.repeat1
	rept 3
		note D#, 4
		note G_, 2
		note C#, 4
		note G_, 2
	endr
	note D#, 2
	note G_, 1
	note G_, 1
	note C#, 2
	note G_, 1
	note G_, 1
	loopchannel 8, .repeat1
	togglenoise $3
	note B_, 16
	note __, 16
	note __, 16
	note B_, 16
	note __, 8
	note B_, 12
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G_, 1
	note G_, 1
	note B_, 1
	note B_, 1
.repeat2
	note B_, 2
	note G_, 2
	note G_, 2
	note G#, 2
	note G_, 2
	note G_, 2
	loopchannel 3, .repeat2
	note B_, 2
	note G_, 2
	note D#, 2
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 1
	note C_, 1
.repeat3
	note D#, 2
	note G#, 2
	note C_, 2
	note G#, 2
	note C_, 2
	note G#, 1
	note G#, 1
	loopchannel 3, .repeat3
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
.repeat4
	callchannel .sub2
	callchannel .sub3
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 1
	note G#, 1
	callchannel .sub2
	note D#, 2
	note G_, 1
	note G#, 1
	note C_, 2
	note G_, 1
	note G#, 1
	note C_, 2
	note G_, 1
	note G#, 1
	loopchannel 4, .repeat4
	note B_, 12
	note D#, 8
	togglenoise $0
	callchannel .sub1
	jumpchannel .loop

.sub1
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	endchannel

.sub2
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 2
.sub3
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 2
	endchannel
