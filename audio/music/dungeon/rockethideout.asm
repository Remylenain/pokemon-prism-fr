Music_RocketHideout:
	channelcount 4
	channel 1, Music_RocketHideout_Ch1
	channel 2, Music_RocketHideout_Ch2
	channel 3, Music_RocketHideout_Ch3
	channel 4, Music_RocketHideout_Ch4

Music_RocketHideout_Ch1:
	tempo 144
	volume $77
	dutycycle $3
	tone $0004
	vibrato $10, $44
	notetype $c, $b3
	stereopanning $f0
.loop
	note __, 16
	note __, 16
	note __, 16
	note __, 16
.repeat
	octave 2
	note D#, 2
	note __, 2
	note A#, 4
	note A_, 2
	note __, 6
	note D#, 2
	note A#, 4
	note A_, 2
	note __, 8
	loopchannel 2, .repeat
	callchannel .sub
	note C#, 2
	note C_, 2
	callchannel .sub
	octave 3
	note A#, 2
	note A_, 2
	note F#, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note F#, 2
	note A#, 2
	note F#, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note F#, 2
	note A_, 2
	octave 2
	note A#, 2
	note B_, 2
	octave 3
	note D#, 2
	note F_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note G_, 2
	note G#, 2
	octave 4
	note D#, 2
	note D_, 2
	note D#, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	note G_, 2
	note G#, 2
	octave 4
	note D#, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	note G#, 2
	note G_, 2
	note F_, 2
	note G_, 2
	note G#, 2
	octave 4
	note C_, 2
	octave 3
	note G#, 2
	note G_, 2
	note F_, 2
	note G_, 2
	note G#, 2
	note B_, 2
	note C_, 2
	note C#, 2
	note F_, 2
	note G_, 2
	note __, 16
	intensity $b7
	octave 2
	note G#, 16
	note __, 16
	note A_, 16
	intensity $b3
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	jumpchannel .loop

.sub
	octave 3
	note A#, 2
	note A_, 2
	note F_, 2
	note F#, 2
	octave 4
	note C#, 2
	note C_, 2
	endchannel

Music_RocketHideout_Ch2:
	dutycycle $3
	tone $0002
	vibrato $0, $f0
	notetype $c, $c4
	stereopanning $f
.loop
	callchannel Music_RocketHideout_Common_1
	loopchannel 2, .loop
	octave 3
	note D#, 12
	note A#, 2
	note A_, 2
	octave 4
	note C#, 8
	note C_, 8
	octave 3
	note A#, 12
	note A_, 4
	note F#, 8
	note F_, 8
	octave 4
	note D#, 12
	note A#, 2
	note A_, 2
	note F#, 8
	note F_, 8
	note D#, 12
	note D_, 4
	octave 3
	note B_, 8
	note A#, 8
	octave 4
	note F_, 12
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note G#, 8
	note G_, 8
	note F_, 12
	note E_, 4
	note C#, 8
	note C_, 8
.repeat
	octave 2
	note C#, 2
	note __, 2
	note G#, 4
	note G_, 2
	note __, 6
	intensity $c7
	octave 3
	note C#, 16
	intensity $c4
	loopchannel 2, .repeat
	callchannel Music_RocketHideout_Common_2
	jumpchannel .loop

Music_RocketHideout_Ch3:
	notetype $c, $19
.loop
	callchannel Music_RocketHideout_Common_1
	loopchannel 6, .loop
.repeat1
	note F_, 2
	note __, 2
	octave 3
	note C_, 4
	octave 2
	note B_, 2
	note __, 6
	note F_, 2
	octave 3
	note C_, 4
	octave 2
	note B_, 2
	note __, 8
	loopchannel 2, .repeat1
.repeat2
	note C#, 2
	note __, 2
	note G#, 4
	note G_, 2
	note __, 6
	octave 3
	note C#, 16
	loopchannel 2, .repeat2
	callchannel Music_RocketHideout_Common_2
	jumpchannel .loop

Music_RocketHideout_Common_1:
	octave 2
	note D#, 2
	note __, 2
	note A#, 4
	note A_, 2
	note __, 6
	note D#, 2
	note A#, 4
	note A_, 2
	note __, 8
	endchannel

Music_RocketHideout_Common_2:
	octave 2
	note C#, 2
	note __, 2
	note G#, 4
	note G_, 2
	note __, 6
	note C#, 2
	note G#, 4
	note G_, 2
	note __, 8
	loopchannel 2, Music_RocketHideout_Common_2
	endchannel

Music_RocketHideout_Ch4:
	togglenoise $0
	notetype $c
	stereopanning $f
	note __, 16
	note __, 16
	note D_, 1
	note D_, 1
	note D#, 1
	note D#, 1
	callchannel .sub
.loop
	callchannel .sub
	note E_, 4
	callchannel .sub
	note F_, 4
	callchannel .sub
	note A#, 4
	callchannel .sub
	note F#, 4
	jumpchannel .loop

.sub
	stereopanning $f0
	note D#, 1
	note D#, 1
	stereopanning $f
	note A_, 4
	note D#, 1
	note D#, 1
	stereopanning $f0
	note A_, 4
	endchannel
