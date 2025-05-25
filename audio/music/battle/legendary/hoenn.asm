Music_HoennLegend:
	channelcount 3
	channel 1, Music_HoennLegend_Ch1
	channel 2, Music_HoennLegend_Ch2
	channel 3, Music_HoennLegend_Ch3

Music_HoennLegend_Ch1:
	tempo 97
	octave 3
.loop
	callchannel Music_HoennLegend_Common
	intensity $a8
	stereopanning $f
	vibrato $10, $14
	callchannel .sub
	note D#, 12
	callchannel .sub
	note E_, 12
	dutycycle $1
	note F_, 2
	note __, 6
	note F_, 4
	note F#, 2
	note __, 6
	note C_, 12
	note F_, 2
	note __, 6
	note F_, 4
	note F#, 2
	note __, 6
	note G#, 12
.repeat
	octave 3
	note G_, 8
	octave 4
	note C_, 8
	octave 3
	note G#, 16
	note G_, 8
	octave 4
	note C_, 8
	note G#, 16
	loopchannel 2, .repeat
	dutycycle $2
	intensity $98
	note D#, 8
	octave 3
	note A#, 8
	note B_, 16
	note A#, 8
	octave 4
	note D#, 8
	note B_, 16
	vibrato $0, $0
	jumpchannel .loop

.subrepeat
	octave 3
	note G_, 12
.sub
	octave 4
	note C_, 2
	note __, 6
	note C_, 4
	note C#, 2
	note __, 6
	loopchannel 2, .subrepeat
	endchannel

Music_HoennLegend_Ch2:
	octave 3
	tone $0002
	callchannel Music_HoennLegend_Common
.loop
	stereopanning $f0
	intensity $a8
	vibrato $10, $14
	tone $0000
	octave 4
	callchannel .sub1
	note A#, 12
	callchannel .sub1
	note B_, 12
	dutycycle $1
	octave 5
	note C_, 2
	note __, 6
	note C_, 4
	note C#, 2
	note __, 6
	octave 4
	note G_, 12
	octave 5
	note C_, 2
	note __, 6
	note C_, 4
	note C#, 2
	note __, 6
	note D#, 12
	dutycycle $2
	intensity $98
	callchannel .sub2
	dutycycle $0
	intensity $a8
	callchannel .sub2
	dutycycle $1
	octave 4
	note G_, 6
	note A#, 6
	octave 5
	note D#, 4
	note E_, 16
	note D#, 6
	octave 4
	note A#, 6
	note G#, 4
	octave 5
	note E_, 16
	dutycycle $3
	intensity $a7
	vibrato $0, $0
	callchannel .sub3
	note G#, 6
	note G_, 1
	note F_, 1
	callchannel .sub3
	octave 1
	note G_, 2
	note G#, 2
	note G_, 2
	note F_, 2
	jumpchannel .loop

.repeat1
	note D_, 12
.sub1
	note G_, 2
	note __, 6
	note G_, 4
	note G#, 2
	note __, 6
	loopchannel 2, .repeat1
	endchannel

.sub2
	note C_, 6
	octave 4
	note G_, 6
	note F#, 4
	note C#, 16
	octave 5
	note C_, 6
	octave 4
	note G_, 6
	note F_, 4
	octave 5
	note C#, 16
	endchannel

.repeat2
	octave 1
	note B_, 8
.sub3
	stereopanning $ff
	octave 2
	rept 3
		note C_, 2
		note __, 6
	endr
	loopchannel 2, .repeat2
	endchannel

Music_HoennLegend_Ch3:
	notetype $6, $1f
	customwave .wave
	octave 1
.repeat1
	note G_, 8
	note __, 8
	note __, 16
	loopchannel 3, .repeat1
	note C_, 8
	note __, 8
	note __, 16
.loop
	callchannel .sub1
	callchannel .sub1
	callchannel .sub1
	octave 2
	note C_, 3
	callchannel .sub2
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	callchannel .sub3
	callchannel .sub3
	callchannel .sub1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	loopchannel 5, .loop
	intensity $19
	octave 3
	callchannel .sub4
	callchannel .sub4
	callchannel .sub5
	callchannel .sub5
	customwave .wave
	loopchannel 7, .loop

.sub3
	note G_, 3
.sub2
	note __, 1
	octave 2
	note C_, 3
	note __, 1
.sub1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	endchannel

.sub4
	note C_, 4
	note G_, 4
	loopchannel 4, .sub4
.repeat2
	note C#, 4
	note G#, 4
	loopchannel 4, .repeat2
	endchannel

.sub5
	note D#, 4
	note A#, 4
	loopchannel 4, .sub5
.repeat3
	note E_, 4
	note B_, 4
	loopchannel 4, .repeat3
	endchannel

.wave
	dn $0, $0, $4, $5, $a, $d, $d, $8, $a, $9, $b, $a, $7, $7, $6, $6
	dn $5, $2, $0, $4, $9, $9, $a, $b, $f, $d, $f, $9, $6, $4, $3, $1

Music_HoennLegend_Common:
	dutycycle $0
	notetype $c, $a6
	stereopanning $f
	note C_, 16
	stereopanning $f0
	note C_, 16
	stereopanning $f
	note C_, 16
	stereopanning $f0
	note C_, 16
	stereopanning $ff
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	endchannel
