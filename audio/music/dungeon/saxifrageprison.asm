Music_SaxifragePrison:
	channelcount 4
	channel 1, Music_SaxifragePrison_Ch1
	channel 2, Music_SaxifragePrison_Ch2
	channel 3, Music_SaxifragePrison_Ch3
	channel 4, Music_SaxifragePrison_Ch4

Music_SaxifragePrison_Ch1:
	tempo $62
	dutycycle $3
	notetype $c, $c2
	vibrato $1, $14
	stereopanning $f
	note __, 1
.loop
	tone $0002
	setcondition 0
	callchannel Music_SaxifragePrison_Common_1
	callchannel Music_SaxifragePrison_Common_1
	callchannel Music_SaxifragePrison_Common_1
	setcondition 1
	callchannel Music_SaxifragePrison_Common_1
	tone $0000
	setcondition 0
	callchannel .sub1
	callchannel .sub1
	callchannel .sub2
	setcondition 1
	callchannel .sub2
	jumpchannel .loop

.sub1
	note C#, 2
	note F_, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note F_, 2
	loopchannel 4, .sub1
	jumpchannel .sub3

.sub2
	note C#, 2
	note F#, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note F#, 2
	loopchannel 2, .sub2
.repeat
	note C_, 2
	note D#, 2
	note G#, 2
	octave 4
	note C_, 2
	octave 3
	note G#, 2
	note D#, 2
	loopchannel 2, .repeat
.sub3
	note C#, 2
	note G_, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note G_, 2
	jumpif 1, .last
	loopchannel 4, .sub3
	endchannel
.last
	loopchannel 3, .sub3
	note C#, 2
	note G_, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note G_, 3
	endchannel

Music_SaxifragePrison_Ch2:
	dutycycle $1
	notetype $c, $c2
	stereopanning $f0
	setcondition 0
.loop
	rept 6
		callchannel Music_SaxifragePrison_Common_1
	endr
	callchannel .sub
	callchannel .sub
	jumpchannel .loop

.sub
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note F#, 2
	note A#, 2
	note F#, 2
	note C#, 2
	loopchannel 2, .sub
.repeat
	octave 2
	note A#, 2
	octave 3
	note C_, 2
	note D#, 2
	note A#, 2
	note D#, 2
	note C_, 2
	loopchannel 2, .repeat
	jumpchannel Music_SaxifragePrison_Common_2

Music_SaxifragePrison_Common_1:
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note F_, 2
	note A#, 2
	note F_, 2
	note C#, 2
	loopchannel 4, Music_SaxifragePrison_Common_1
Music_SaxifragePrison_Common_2:
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note G_, 2
	note G#, 2
	note G_, 2
	note C#, 2
	jumpif 1, .last
	loopchannel 4, Music_SaxifragePrison_Common_2
	endchannel
.last
	loopchannel 3, Music_SaxifragePrison_Common_2
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note G_, 2
	note G#, 2
	note G_, 2
	note C#, 1
	endchannel

Music_SaxifragePrison_Ch3:
	notetype $c, $11
	octave 1
	note A#, 4
	note __, 2
	octave 2
	note A#, 4
	note __, 6
	octave 1
	note A#, 2
	octave 2
	note A#, 2
	note __, 2
	note A#, 2
	octave 1
	note A#, 4
	note __, 2
	octave 2
	note A#, 4
	note __, 6
	octave 1
	note A#, 2
	octave 2
	note A#, 2
	octave 1
	note A#, 2
	octave 2
	note A#, 2
	octave 1
	note G_, 4
	note __, 2
	octave 2
	note G_, 4
	note __, 6
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	note __, 2
	note G_, 2
	octave 1
	note G_, 4
	note __, 2
	octave 2
	note G_, 4
	note __, 6
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	loopchannel 2, Music_SaxifragePrison_Ch3
	notetype $6, $11
	rept 4
		callchannel .sub1
	endr
	callchannel .sub2
	callchannel .sub2
	jumpchannel Music_SaxifragePrison_Ch3

.sub1
	octave 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	octave 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	loopchannel 4, .sub1
	jumpchannel .sub3

.sub2
	octave 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	octave 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	loopchannel 2, .sub2
.repeat
	octave 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	octave 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	loopchannel 2, .repeat
.sub3
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note G_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note G_, 3
	note __, 1
	loopchannel 4, .sub3
	endchannel

Music_SaxifragePrison_Ch4:
	notetype $c
	togglenoise $3
	note __, 16
.loop
	note __, 16
	loopchannel 10, .loop
	note __, 10
	note D#, 2
	note D_, 2
	note D_, 2
.repeat
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 2
	note D#, 2
	note D_, 4
	note D_, 1
	note D_, 1
	loopchannel 12, .repeat
	note D_, 16
	jumpchannel .loop
