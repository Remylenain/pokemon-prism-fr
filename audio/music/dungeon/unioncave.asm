Music_UnionCave:
	channelcount 4
	channel 1, Music_UnionCave_Ch1
	channel 2, Music_UnionCave_Ch2
	channel 3, Music_UnionCave_Ch3
	channel 4, Music_UnionCave_Ch4

Music_UnionCave_Ch1:
	tempo 160
	volume $77
	dutycycle $1
	tone $0002
	vibrato $18, $34
	stereopanning $f
.loop
	notetype $c, $b3
.repeat1
	callchannel Music_UnionCave_Common
	loopchannel 4, .repeat1
.repeat2
	octave 2
	note G#, 2
	octave 3
	note C#, 2
	note E_, 4
	note C#, 2
	note E_, 2
	note F_, 4
	loopchannel 8, .repeat2
.repeat3
	octave 2
	note A_, 2
	octave 3
	note D_, 2
	note F_, 4
	note D_, 2
	note F_, 2
	note F#, 4
	loopchannel 4, .repeat3
	note __, 4
	intensity $80
	note F_, 16
	note F#, 16
	note G_, 16
	note F#, 16
	note G_, 8
	note F#, 8
	note F_, 8
	note E_, 8
	note G_, 8
	note F#, 8
	octave 4
	note C_, 8
	octave 3
	note A_, 8
	intensity $95
	tone $0004
	callchannel Music_UnionCave_Common
	tone $0008
	callchannel Music_UnionCave_Common
	tone $000c
	callchannel Music_UnionCave_Common
	tone $0010
	callchannel Music_UnionCave_Common
	tone $0002
	jumpchannel .loop

Music_UnionCave_Ch2:
	dutycycle $3
	vibrato $8, $24
.loop
	notetype $c, $c4
	callchannel .sub
	intensity $c5
	callchannel .sub
	intensity $c7
	callchannel .sub
	intensity $c4
	note C#, 4
	octave 3
	note B_, 4
	octave 4
	note D_, 2
	note E_, 2
	note C#, 2
	octave 3
	note B_, 2
	octave 4
	note C#, 4
	octave 3
	note B_, 4
	octave 4
	note D_, 8
	octave 3
	note B_, 4
	octave 4
	note D_, 4
	note F#, 2
	note F_, 2
	note C#, 2
	octave 3
	note B_, 2
	octave 4
	note C#, 8
	note D_, 4
	note C#, 4
	note __, 4
	intensity $a0
	note C_, 16
	note C#, 16
	note D_, 16
	note C#, 16
	note E_, 16
	note D#, 16
	note A#, 16
	note A_, 16
	intensity $a5
	vibrato $6, $44
	callchannel Music_UnionCave_Common
	vibrato $4, $33
	callchannel Music_UnionCave_Common
	vibrato $2, $22
	callchannel Music_UnionCave_Common
	vibrato $1, $41
	callchannel Music_UnionCave_Common
	vibrato $8, $24
	jumpchannel .loop

.sub
	octave 4
	note C_, 4
	octave 3
	note A#, 4
	octave 4
	note C#, 2
	note D#, 2
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 4
	octave 3
	note A#, 4
	octave 4
	note C#, 8
	octave 3
	note A#, 4
	octave 4
	note C#, 4
	note F_, 2
	note E_, 2
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 8
	note C#, 4
	note C_, 4
	endchannel

Music_UnionCave_Common:
	octave 2
	note G#, 2
	octave 3
	note C#, 2
	note E_, 12
	endchannel

Music_UnionCave_Ch3:
	notetype $c, $16
	stereopanning $f0
.loop
	note __, 16
	loopchannel 7, .loop
	note __, 14
	octave 4
	note C_, 2
.repeat1
	note __, 2
	octave 3
	note E_, 2
	note __, 2
	note E_, 2
	note G#, 2
	note E_, 2
	note __, 2
	octave 4
	note C_, 2
	loopchannel 4, .repeat1
.repeat2
	note __, 2
	octave 3
	note F_, 2
	note __, 2
	note F_, 2
	note A_, 2
	note F_, 2
	note __, 2
	octave 4
	note C#, 2
	loopchannel 4, .repeat2
	note __, 4
	note C_, 8
	octave 3
	note B_, 8
	note A#, 8
	note A_, 8
	octave 4
	note C#, 8
	note C_, 8
	octave 3
	note B_, 8
	note A#, 8
.repeat3
	note A_, 4
	note G_, 4
	note A#, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note G_, 2
	loopchannel 3, .repeat3
	note A_, 4
	note G_, 4
	note A#, 8
	loopchannel 12, .loop ; will loop forever (starting from 11) because of the top loop

Music_UnionCave_Ch4:
	togglenoise $1
	notetype $c
.loop
	stereopanning $f0
	note E_, 4
	stereopanning $ff
	note F_, 4
	stereopanning $f
	note G#, 4
	note __, 8
	stereopanning $f
	note E_, 4
	stereopanning $ff
	note F_, 4
	stereopanning $f0
	note G#, 4
	note __, 8
	jumpchannel .loop
