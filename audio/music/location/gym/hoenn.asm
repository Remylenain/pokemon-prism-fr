Music_HoennGym:
	channelcount 4
	channel 1, Music_HoennGym_Ch1
	channel 2, Music_HoennGym_Ch2
	channel 3, Music_HoennGym_Ch3
	channel 4, Music_HoennGym_Ch4

Music_HoennGym_Ch1:
	tempo 72
	dutycycle $0
	stereopanning $f
	vibrato $08, $24
	tone $0001
	notetype $c, $70
	octave 3
	note B_, 4
	octave 2
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note B_, 4
	note __, 4
.repeat
	octave 3
	note A_, 4
	octave 2
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 4
	note __, 4
	loopchannel 2, .repeat
	octave 3
	note A_, 16
	callchannel .sub
	note F#, 16
	note A_, 2
	note __, 2
	note D_, 4
	note F#, 2
	note A_, 6
	callchannel .sub
	note F#, 14
	intensity $94
	dutycycle $1
	note B_, 1
	octave 4
	note C#, 1
	note D_, 4
	octave 3
	intensity $92
	note A_, 4
	octave 4
	note D_, 2
	intensity $97
	note C#, 6
	octave 3
	note B_, 16
	intensity $92
	octave 4
	note E_, 4
	note C#, 4
	note D#, 2
	intensity $96
	note E_, 6
	intensity $94
	note D_, 6
	octave 3
	note A_, 2
	intensity $97
	note A_, 8
	intensity $94
	octave 4
	note A_, 6
	note D_, 2
	intensity $97
	note D_, 8
	intensity $92
	octave 3
	note B_, 4
	note G#, 4
	note A#, 2
	intensity $97
	note B_, 6
	intensity $92
	octave 4
	note E_, 4
	note C#, 4
	note D#, 2
	intensity $97
	note E_, 6
	note F#, 4
	note D_, 2
	note F#, 2
	intensity $90
	note A_, 8
	intensity $97
	note A_, 8
	note A_, 8
	intensity $72
	octave 3
	note B_, 4
	octave 4
	note G#, 2
	note F#, 2
	note G#, 4
	note E_, 2
	note F#, 2
	note G#, 2
	note F#, 2
	note G#, 4
	octave 3
	note B_, 2
	intensity $75
	octave 4
	note E_, 4
	intensity $72
	octave 3
	note B_, 2
	note A_, 4
	octave 4
	note F#, 2
	note E_, 2
	note F#, 4
	note D_, 2
	note E_, 2
	note F#, 2
	note E_, 2
	note F#, 4
	octave 3
	note A_, 2
	intensity $75
	octave 4
	note D_, 4
	intensity $72
	octave 3
	note A_, 2
	note G#, 4
	octave 4
	note E_, 2
	note D#, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note B_, 4
	intensity $87
	note E_, 4
	note G#, 2
	note B_, 6
	intensity $97
	octave 5
	note C_, 16
	intensity $a7
	note D_, 16
	dutycycle $0
	intensity $70
	octave 4
	note E_, 4
	octave 3
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 4
	note B_, 2
	octave 4
	note D#, 2
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
	octave 3
	note B_, 2
	octave 4
	note E_, 6
	note D_, 4
	octave 3
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 4
	note A_, 2
	octave 4
	note C#, 2
	note D_, 2
	note __, 2
	note D_, 2
	note __, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 6
	octave 3
	note E_, 2
	note G#, 2
	note B_, 2
	octave 4
	note E_, 2
	octave 5
	note E_, 2
	octave 4
	note B_, 2
	note G#, 2
	note E_, 2
	octave 3
	note D_, 2
	note F#, 2
	note B_, 2
	octave 4
	note D_, 2
	octave 5
	note D_, 2
	octave 4
	note B_, 2
	note F#, 2
	note D_, 2
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	note G#, 2
	note B_, 2
	octave 4
	note B_, 2
	note G#, 2
	note E_, 2
	octave 3
	note B_, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	note F#, 2
	note G#, 2
	note B_, 2
	octave 4
	note F#, 2
	note B_, 2
	octave 5
	note D#, 2
	jumpchannel Music_HoennGym_Ch1

.sub
	note G#, 16
	octave 2
	note B_, 2
	note __, 2
	note G#, 2
	note __, 2
	note B_, 2
	octave 3
	note E_, 6
	endchannel

Music_HoennGym_Ch2:
	vibrato $08, $24
	dutycycle $3
	tone $0001
	notetype $c, $b0
	octave 4
	note E_, 4
	intensity $b7
	note E_, 8
	octave 3
	note B_, 2
	octave 4
	note E_, 2
	intensity $b0
	note D_, 4
	intensity $b7
	note D_, 8
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	intensity $b0
	note C#, 16
	intensity $b4
	note C#, 8
	note D#, 8
	intensity $b0
	note E_, 12
	intensity $b7
	note E_, 12
	octave 3
	note B_, 2
	octave 4
	note E_, 6
	intensity $b2
	note F#, 6
	note D_, 2
	intensity $b0
	note D_, 12
	intensity $b7
	note D_, 12
	intensity $b0
	note E_, 12
	intensity $b7
	note E_, 12
	octave 3
	note B_, 2
	octave 4
	note E_, 6
	intensity $b2
	note D_, 4
	intensity $b0
	note D_, 2
	note E_, 2
	note F#, 12
	intensity $b7
	note F#, 12
	callchannel .sub
	intensity $b2
	note A_, 6
	note F#, 2
	intensity $b7
	note F#, 8
	intensity $b5
	octave 5
	note D_, 6
	octave 4
	intensity $b2
	note A_, 2
	intensity $b7
	note A_, 8
	callchannel .sub
	note A_, 4
	note F#, 2
	note A_, 2
	octave 5
	intensity $b0
	note D_, 8
	intensity $b7
	note D_, 8
	note C#, 8
	intensity $b0
	octave 2
	note B_, 12
	octave 3
	note E_, 12
	octave 2
	note B_, 8
	octave 3
	note D_, 8
	note C#, 8
	octave 2
	note B_, 8
	note A_, 8
	note G#, 2
	note __, 2
	note G#, 2
	note A_, 2
	note B_, 10
	note __, 2
	note B_, 4
	octave 3
	note E_, 2
	octave 2
	note B_, 6
	octave 3
	note D_, 8
	note C_, 8
	octave 2
	note B_, 8
	note A_, 8
	intensity $b7
	octave 4
	note B_, 12
	intensity $b0
	octave 5
	note E_, 4
	intensity $b7
	note E_, 8
	octave 4
	note B_, 8
	octave 5
	note D_, 8
	note C#, 8
	octave 4
	note B_, 8
	note A_, 8
	intensity $b2
	note G#, 4
	note G#, 2
	note A_, 2
	intensity $b7
	note B_, 8
	intensity $b2
	note B_, 4
	note B_, 2
	octave 5
	note C#, 2
	intensity $b7
	note D_, 8
	intensity $b2
	note E_, 4
	note E_, 2
	note F#, 2
	intensity $b0
	note G#, 8
	intensity $b7
	note G#, 8
	note F#, 8
	jumpchannel Music_HoennGym_Ch2

.sub
	intensity $b0
	note G#, 12
	intensity $b7
	note G#, 12
	note F#, 2
	note G#, 6
	endchannel

Music_HoennGym_Ch3:
	stereopanning $f0
	vibrato $08, $24
	tone $0001
	notetype $c, $14
	octave 3
	note E_, 4
	octave 2
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 4
	note B_, 2
	octave 3
	note E_, 2
	note D_, 4
	octave 2
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 4
	note B_, 2
	octave 3
	note D_, 2
	note C#, 4
	octave 2
	note C#, 1
	note __, 1
	note C#, 1
	note __, 1
	note C#, 4
	note A_, 2
	octave 3
	note C#, 2
	octave 2
	note B_, 3
	note __, 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note B_, 8
	callchannel .sub1
	callchannel .sub2
	callchannel .sub1
	note D_, 2
	note __, 4
	note D_, 2
	note __, 4
	note D_, 2
	note __, 6
	note A_, 2
	note __, 2
	note D_, 2
	note F#, 6
	callchannel .sub1
	callchannel .sub2
	note E_, 2
	note __, 4
	note E_, 2
	note __, 4
	note E_, 2
	note __, 6
	note E_, 2
	note __, 2
	note E_, 2
	note E_, 6
	note D_, 2
	note __, 4
	note D_, 2
	note __, 4
	note D_, 2
	note __, 6
	note F#, 2
	note __, 2
	note E_, 2
	note A_, 6
	callchannel .sub1
	callchannel .sub2
	note C#, 2
	note __, 4
	note C#, 2
	note __, 4
	note C#, 2
	note __, 6
	note C#, 2
	note __, 2
	note E_, 2
	note C#, 6
	note C_, 16
	note D_, 16
	note E_, 2
	note __, 2
	note E_, 2
	note __, 6
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 4
	note __, 4
	note E_, 8
	note D_, 2
	note __, 2
	note D_, 2
	note __, 6
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 4
	note __, 4
	note F#, 2
	note A_, 6
	note G#, 2
	note __, 2
	note G#, 1
	note __, 1
	note G#, 1
	note __, 1
	note G#, 8
	note F#, 2
	note __, 2
	note F#, 1
	note __, 1
	note F#, 1
	note __, 1
	note F#, 8
	note E_, 2
	note __, 2
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 8
	note D#, 8
	note F#, 2
	note G#, 2
	note B_, 2
	octave 3
	note D#, 2
	jumpchannel Music_HoennGym_Ch3

.sub1
	note E_, 2
	note __, 4
	note E_, 2
	note __, 4
	note E_, 2
	note __, 6
	note E_, 2
	note __, 2
	note E_, 1
	note __, 1
	note E_, 6
	endchannel

.sub2
	note D_, 2
	note __, 4
	note D_, 2
	note __, 4
	note D_, 2
	note __, 6
	note D_, 2
	note __, 2
	note D_, 1
	note __, 1
	note D_, 6
	endchannel

Music_HoennGym_Ch4:
	togglenoise $3
	notetype $c
.loop
	note B_, 4
	note C_, 2
	note A#, 2
	note A#, 4
	note C_, 2
	note C_, 2
	note B_, 4
	note C_, 2
	note A#, 2
	note A#, 4
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note B_, 2
	note C_, 2
	note C_, 2
	note A#, 2
	note A#, 4
	note C_, 2
	note C_, 2
	note A#, 2
	note C_, 2
	note C_, 2
	note C_, 2
	callchannel .sub1
	note B_, 6
	note C_, 2
	note C_, 4
	note C_, 2
	note C_, 2
	note C_, 4
	note C_, 4
	note A#, 2
	note A#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	callchannel .sub2
	callchannel .sub3
	callchannel .sub3
	callchannel .sub3
	note B_, 16
	note __, 8
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	note A#, 2
	note A#, 6
	note A#, 12
	note A#, 2
	note A#, 2
.repeat1
	note F#, 1
	loopchannel 8, .repeat1
	callchannel .sub1
	note B_, 4
	note C_, 8
	note C_, 2
	note C_, 2
	note C_, 8
	callchannel .sub1
	note A#, 4
	note C_, 8
	callchannel .sub4
	note A#, 4
	note C_, 2
	note A#, 2
	note B_, 4
	callchannel .sub4
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 4
	note C_, 2
	note C_, 2
.repeat2
	note F#, 1
	loopchannel 8, .repeat2
	callchannel .sub1
	jumpchannel .loop

.sub4
	note C_, 2
	note C_, 2
	note C_, 4
	note C_, 4
.sub1
	note D_, 1
	loopchannel 8, .sub1
	endchannel

.sub3
	note A#, 6
	note C_, 2
	note C_, 4
	note C_, 2
	note C_, 2
	note C_, 4
	note C_, 4
	note A#, 2
	note A#, 2
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
.sub2
	note A#, 6
	note C_, 2
	note C_, 4
	note C_, 2
	note C_, 2
	note A#, 4
	note C_, 4
	jumpchannel .sub1
