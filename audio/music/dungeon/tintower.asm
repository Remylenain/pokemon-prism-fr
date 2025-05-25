Music_TinTower:
	channelcount 4
	channel 1, Music_TinTower_Ch1
	channel 2, Music_TinTower_Ch2
	channel 3, Music_TinTower_Ch3
	channel 4, Music_TinTower_Ch4

Music_TinTower_Ch1:
	tempo 208
	volume $77
	dutycycle $3
	tone $0004
	vibrato $8, $45
.loop
	stereopanning $f0
	notetype $c, $a5
	octave 3
	note G_, 4
	note C_, 4
	note G#, 8
	note G_, 4
	note C_, 4
	octave 2
	note A#, 2
	octave 3
	note C_, 2
	note C#, 2
	octave 2
	note A#, 2
	octave 3
	note G_, 4
	note C_, 4
	note G#, 4
	note F_, 4
	note G_, 4
	octave 2
	note G_, 4
	octave 3
	note G_, 6
	note A#, 2
	note G_, 2
	note F_, 2
	note C#, 2
	note G_, 2
	note G#, 8
	note G_, 4
	octave 4
	note C_, 4
	octave 3
	note G#, 2
	note G_, 2
	note F_, 2
	note G#, 2
	note G_, 2
	note C#, 2
	octave 2
	note A#, 2
	octave 3
	note G_, 2
	note G#, 4
	note F_, 4
	note G_, 4
	octave 2
	note G_, 4
	octave 3
	note G_, 8
	intensity $a2
	octave 2
	note G_, 4
	note G_, 12
	note G_, 4
	note G_, 8
	intensity $a7
	note G_, 4
	intensity $a2
	note G#, 4
	note G#, 8
	intensity $a7
	note G_, 4
	intensity $a2
	note G#, 4
	note G#, 8
	intensity $a7
	note A#, 4
	intensity $a2
	note G_, 4
	note G_, 12
	note G_, 4
	note G_, 12
	note G_, 4
	note G_, 12
	note G_, 4
	note G_, 8
	intensity $a5
	octave 3
	note A#, 4
	jumpchannel .loop

Music_TinTower_Ch2:
	dutycycle $3
	tone $0002
	vibrato $18, $44
.loop
	notetype $c, $b5
	stereopanning $ff
.repeat
	callchannel .sub
	note F_, 4
	note C#, 4
	octave 3
	note A#, 4
	callchannel .sub
	octave 3
	note C_, 4
	octave 4
	note C_, 8
	stereopanning $f
	loopchannel 2, .repeat
	intensity $b2
	octave 3
	note C_, 4
	note C_, 12
	note C_, 4
	note C_, 8
	intensity $b7
	note C_, 4
	intensity $b2
	note C#, 4
	note C#, 8
	intensity $b7
	note C_, 4
	intensity $b2
	note C#, 4
	note C#, 8
	intensity $b7
	note D#, 4
	intensity $90
	stereopanning $ff
	note G_, 4
	octave 4
	note C_, 4
	octave 3
	note A#, 2
	note G#, 2
	note G_, 2
	note G#, 2
	note G_, 4
	note C_, 4
	note G_, 8
	note G_, 4
	octave 4
	note C_, 4
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	note C#, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 4
	octave 3
	note C_, 4
	octave 4
	note C_, 6
	intensity $95
	note C#, 2
	jumpchannel .loop

.sub
	octave 4
	note C_, 4
	note C_, 4
	note C#, 2
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C#, 2
	note C_, 4
	endchannel

Music_TinTower_Ch3:
	notetype $c, $14
.loop
	note __, 16
	note __, 16
	note __, 16
	note __, 10
	octave 2
	note G_, 2
	note G#, 2
	note A#, 2
	octave 3
	note C_, 8
	note C#, 8
	note E_, 8
	octave 2
	note A#, 2
	octave 3
	note C_, 2
	note C#, 2
	note D#, 2
	note C_, 8
	note C#, 8
	note E_, 8
	octave 4
	note C_, 8
	octave 3
	callchannel .sub1
	note __, 4
.repeat
	note C_, 4
	note C#, 1
	note __, 3
	note C#, 1
	note __, 7
	loopchannel 2, .repeat
	note D#, 4
	callchannel .sub2
	octave 2
	note A#, 2
	octave 3
	note C_, 2
	note C#, 2
	note D#, 2
	callchannel .sub2
	note __, 8
	jumpchannel .loop

.sub2
	stereopanning $f
.sub1
	note C_, 1
	note __, 3
	note C_, 1
	note __, 11
	note C_, 1
	note __, 3
	note C_, 1
	note __, 3
	stereopanning $ff
	endchannel

Music_TinTower_Ch4:
	togglenoise $0
	notetype $c
.loop
	stereopanning $f
	note G_, 2
	stereopanning $f0
	note G_, 1
	note G_, 1
	stereopanning $f
	note G_, 2
	stereopanning $f0
	note F_, 4
	stereopanning $f
	note G_, 2
	note G_, 2
	note F_, 2
	stereopanning $f0
	note G_, 2
	stereopanning $f
	note G_, 1
	note G_, 1
	stereopanning $f0
	note G_, 2
	stereopanning $f
	note F_, 4
	stereopanning $f0
	note G_, 2
	note G_, 2
	note F_, 2
	jumpchannel .loop
