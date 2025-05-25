Music_LentimasTown:
	channelcount 4
	channel 1, Music_LentimasTown_Ch1
	channel 2, Music_LentimasTown_Ch2
	channel 3, Music_LentimasTown_Ch3
	channel 4, Music_LentimasTown_Ch4

Music_LentimasTown_Ch1:
	tempo 152
	dutycycle 0
	stereopanning $f0
	tone $0002
.loop
	notetype $6, $84
	octave 3
	note C#, 12
	note B_, 12
	note A_, 8
	octave 2
	note F#, 12
	note F#, 8
	callchannel .sub
	note F#, 4
	note F_, 4
	note __, 4
	note C#, 4
	note F_, 4
	octave 2
	note G#, 4
	note B_, 8
	octave 3
	note D#, 4
	note C#, 8
	note C#, 8
	callchannel .sub
	note G_, 4
	note F#, 8
	octave 2
	note A#, 4
	note __, 8
	note A#, 4
	octave 3
	note C#, 8
	octave 2
	note A#, 8
	note B_, 8
	note B_, 8
	octave 3
	note D_, 4
	note C#, 4
	note C_, 8
	note F#, 4
	note F_, 4
	note D#, 8
	note B_, 4
	intensity $86
	note F#, 12
	notetype $c, $84
	note F_, 2
	note __, 12
	notetype $8, $b5
	note F#, 3
	note G#, 9
	note A_, 3
	octave 2
	note A_, 3
	note __, 3
	note G#, 3
	note __, 6
	intensity $b4
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	octave 3
	note B_, 2
	note A_, 2
	note G#, 2
	note F#, 2
	intensity $b5
	note F_, 3
	note __, 3
	note A_, 3
	note B_, 3
	note __, 3
	octave 4
	note D_, 3
	notetype $c, $b7
	note C#, 16
	note __, 6
	notetype $6, $b4
	octave 3
	note F#, 4
	note G#, 1
	note A_, 1
	note G#, 2
	note F#, 4
	notetype $8, $b5
	note A#, 4
	note B_, 4
	octave 4
	note C#, 4
	note D_, 2
	note C#, 2
	octave 3
	note B_, 5
	note F#, 6
	note F#, 3
	note G#, 3
	note A_, 3
	note D_, 3
	note __, 16
	note __, 5
	note C#, 3
	note __, 16
	note __, 5
	note F#, 12
	note __, 2
	note A_, 2
	note B_, 2
	octave 4
	notetype $c, $b5
	note C#, 3
	note F#, 2
	intensity $b0
	note C#, 1
	notetype $2, $b5
	note C#, 8
	note F#, 8
	note C#, 8
	note D_, 16
	octave 3
	note G#, 4
	note A_, 12
	note B_, 16
	note __, 6
	note F#, 12
	note F#, 12
	note F_, 3
	note F#, 3
	note F_, 12
	notetype $4, $b5
	note C#, 12
	note __, 4
	note C#, 8
	note D_, 6
	note C#, 4
	note E_, 8
	note __, 3
	note D_, 9
	note C#, 6
	octave 2
	note B_, 12
	notetype $6, $b5
	note A_, 5
	note B_, 6
	octave 3
	note C#, 1
	note D#, 1
	note D_, 1
	note C#, 8
	notetype $2, $b5
	note A_, 9
	note G#, 9
	note F#, 9
	note A_, 15
	note G#, 12
	note C#, 8
	note C#, 16
	note A_, 8
	note G#, 16
	note B_, 12
	note A_, 8
	note C#, 16
	note __, 9
	note C_, 3
	note C#, 15
	note D_, 15
	notetype $6, $b5
	octave 2
	note G#, 6
	notetype $8, $b5
	octave 3
	note C#, 3
	note D#, 2
	note E_, 2
	note F_, 2
	note F#, 2
	note G_, 2
	note G#, 14
	note __, 6
	jumpchannel .loop

.sub
	octave 3
	note B_, 4
	octave 4
	intensity $94
	note C#, 1
	note D_, 1
	note C#, 2
	octave 3
	note A_, 4
	endchannel

Music_LentimasTown_Ch2:
	dutycycle 1
	stereopanning $f
	vibrato $16, $25
	notetype $6, $a0
	octave 4
	note __, 8
	note C#, 8
	note F#, 4
	note F_, 8
	note C#, 4
	note __, 4
	note D_, 1
	note E_, 1
	note D#, 1
	note D_, 5
	note C#, 4
	note __, 16
	note __, 12
	note C#, 4
	note D_, 4
	note C#, 4
	note __, 4
	octave 3
	note G#, 4
	note __, 4
	note B_, 1
	octave 4
	note C#, 1
	note C_, 1
	octave 3
	note B_, 5
	note A_, 4
	note __, 16
	note __, 12
	octave 4
	note C#, 4
	note D_, 4
	note C#, 8
	octave 3
	note F#, 8
	note G_, 8
	note F#, 4
	note __, 4
	note B_, 4
	octave 4
	note C#, 4
	octave 3
	note B_, 4
	note A_, 4
	note G#, 8
	octave 4
	note D#, 4
	note C#, 4
	note C_, 8
	note G#, 4
	note F#, 12
	note F_, 4
	note __, 4
	dutycycle 2
	octave 4
	intensity $64
	note C#, 4
	note F#, 4
	note A_, 4
	intensity $74
	octave 5
	note C#, 4
	callchannel .sub1
	intensity $74
	octave 5
	note D_, 4
	callchannel .sub1
	callchannel .sub2
	note C#, 4
	callchannel .sub2
	intensity $74
	octave 5
	note D#, 4
	dutycycle 1
	intensity $90
	octave 3
	note F#, 2
	note __, 2
	note F#, 4
	note __, 4
	note C#, 4
	note __, 4
	note A_, 12
	intensity $77
	note __, 4
	note A#, 8
	note A#, 8
	intensity $70
	note F#, 8
	intensity $77
	note F#, 8
	note B_, 8
	note B_, 8
	intensity $70
	note A_, 8
	intensity $77
	note A_, 4
	octave 4
	notetype $8, $a0
	note __, 4
	note D_, 4
	note C#, 4
	notetype $6, $b0
	octave 3
	note B_, 4
	octave 4
	note F#, 4
	note A_, 1
	note G#, 3
	note F#, 4
	note __, 4
	octave 3
	note B_, 4
	note A_, 4
	note G#, 4
	note F_, 4
	octave 4
	note C#, 4
	note E_, 1
	note D_, 3
	note C#, 4
	octave 3
	note G#, 16
	notetype $c, $b5
	note G#, 8
	note __, 2
	dutycycle 2
	octave 4
	intensity $64
	note D_, 4
	note D_, 4
	note A_, 4
	note F#, 4
	note D_, 4
	note D_, 4
	note G#, 4
	note F_, 4
	note D#, 4
	note D#, 4
	intensity $a4
	dutycycle 1
	note E_, 4
	note F_, 2
	note F#, 2
	note F#, 2
	dutycycle 2
	intensity $64
	note __, 2
	note F#, 4
	note A_, 4
	note C#, 4
	note D_, 4
	note D_, 4
	note A_, 4
	note F#, 4
	note C#, 4
	note C#, 4
	note D_, 4
	note F_, 4
	note E_, 4
	note E_, 4
	note F_, 4
	note F#, 2
	jumpchannel Music_LentimasTown_Ch2

.sub1
	octave 4
	intensity $64
	note C#, 4
	intensity $54
	note F#, 4
	intensity $44
	note A_, 4
	endchannel

.sub2
	intensity $74
	octave 5
	note C#, 4
	octave 4
	intensity $64
	note C#, 4
	intensity $54
	note F_, 4
	intensity $74
	octave 5
	note D_, 4
	intensity $54
	octave 4
	note C#, 4
	note F_, 4
	intensity $44
	note G#, 4
	endchannel

Music_LentimasTown_Ch3:
	notetype $c, $14
	vibrato $16, $25
	octave 2
	note F_, 2
	note __, 4
	note G#, 6
	octave 3
	note C#, 2
	callchannel .sub1
	note C#, 2
	note __, 4
	note G#, 6
	note B_, 2
	callchannel .sub1
	note F#, 2
	note __, 4
	note A#, 6
	octave 3
	note C#, 2
	note __, 2
	octave 2
	note B_, 2
	note __, 4
	note D_, 6
	note F#, 2
	note __, 2
	octave 3
	note C_, 2
	note __, 4
	octave 2
	note D#, 6
	note G#, 2
	note __, 2
	note C#, 1
	note __, 1
	note C#, 2
	note __, 2
	note G#, 4
	note __, 2
	note C#, 2
	note __, 2
	callchannel .sub2
	note F_, 2
	note __, 4
	callchannel .sub3
	note G#, 2
	note __, 4
	callchannel .sub3
	callchannel .sub2
	callchannel .sub2
	note D_, 2
	note __, 4
	octave 3
	note C_, 2
	note __, 2
	note C_, 2
	octave 2
	note C_, 2
	note __, 2
	octave 1
	note B_, 2
	note __, 14
	octave 2
	note C#, 2
	note __, 14
	note F#, 6
	note A_, 6
	octave 3
	note C#, 2
	note __, 2
	callchannel .sub4
	note F#, 6
	note A_, 6
	note C#, 2
	note __, 2
	octave 1
	note A_, 6
	octave 2
	note C#, 6
	note F#, 2
	note __, 2
	callchannel .sub4
	note F#, 6
	octave 1
	note A_, 6
	octave 2
	note C#, 2
	note __, 2
	jumpchannel Music_LentimasTown_Ch3

.sub1
	note __, 2
	octave 2
	note F#, 2
	note __, 4
	note A_, 6
	octave 3
	note C#, 2
	note __, 2
	octave 2
	endchannel

.sub2
	note F#, 2
	note __, 4
.sub3
	octave 3
	note C#, 2
	note __, 2
	note C#, 2
	octave 2
	note C#, 2
	note __, 2
	endchannel

.sub4
	octave 1
	note B_, 6
	octave 2
	note D_, 6
	note F#, 2
	note __, 2
	note C#, 6
	note F_, 6
	note G#, 2
	note __, 2
	endchannel

Music_LentimasTown_Ch4:
	togglenoise $3
	notetype $c
.loop
	note F#, 2
	note F#, 2
	note D_, 2
	note F#, 2
	jumpchannel .loop
