Music_KantoGym::
	channelcount 3
	channel 1, Music_KantoGym_Ch1
	channel 2, Music_KantoGym_Ch2
	channel 3, Music_KantoGym_Ch3

Music_KantoGym_Ch1:
	tempo 138
	volume $77
	dutycycle 3
	stereopanning $f
	vibrato 8, $22
	notetype 12, $b5
	octave 3
	note G_, 6
	note C_, 1
	note G_, 1
	note F_, 6
	octave 2
	note A#, 1
	octave 3
	note F_, 1
	note E_, 6
	octave 2
	note A_, 1
	octave 3
	note E_, 1
	note F_, 4
	note G_, 4
.loop
	note E_, 4
	note F_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	intensity $b1
	note D_, 3
	intensity $b5
	callchannel .sub1
	note E_, 4
	note F_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note D_, 1
	callchannel .sub1
	callchannel .sub2
	intensity $b1
	note A#, 3
	intensity $b5
	note F_, 1
	callchannel .sub3
	callchannel .sub2
	note D_, 2
	note D_, 1
	note E_, 1
	note F_, 4
	note A#, 2
	note F_, 1
	note A#, 1
	octave 4
	note D_, 4
	octave 3
	callchannel .sub4
	note F_, 2
	note D_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	note C_, 2
	note C_, 1
	note D_, 1
	note E_, 4
	note C_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note E_, 2
	note C_, 1
	callchannel .sub1
	callchannel .sub4
	note D_, 2
	note F_, 2
	note D_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note C_, 2
	note C_, 1
	note D_, 1
	note E_, 4
	note D_, 2
	note E_, 2
	note F_, 2
	note F_, 2
	note G_, 2
	note E_, 1
	note G_, 1
	note A#, 2
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	note A_, 2
	note G_, 2
	note A_, 2
	jumpchannel .loop

.sub1
	note E_, 1
.sub3
	note F_, 4
	note E_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	endchannel

.sub2
	octave 4
	note C_, 4
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	note A_, 2
	note G_, 2
	note F_, 2
	endchannel

.sub4
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	endchannel

Music_KantoGym_Ch2:
	dutycycle 3
	vibrato 10, $25
	notetype 12, $c7
	octave 4
	note C_, 6
	octave 3
	note G_, 1
	octave 4
	note C_, 1
	octave 3
	note A#, 6
	note F_, 1
	note A#, 1
	intensity $a0
	note A_, 12
	intensity $c7
	note B_, 4
.loop
	octave 4
	note C_, 12
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	intensity $c2
	note D_, 3
	octave 3
	note A#, 1
	intensity $c7
	note A#, 12
	octave 4
	note C_, 12
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	intensity $c4
	octave 3
	note A#, 2
	intensity $c7
	note A#, 1
	octave 4
	note C_, 1
	note D_, 12
	note E_, 12
	note D_, 2
	note E_, 2
	intensity $c2
	note F_, 3
	note D_, 1
	intensity $c7
	note D_, 4
	intensity $c2
	note A#, 3
	note F_, 1
	intensity $c7
	note F_, 4
	note E_, 12
	note D_, 2
	note E_, 2
	note F_, 2
	note D_, 1
	note F_, 1
	note A#, 12
	octave 3
	callchannel .sub
	note G_, 6
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note A#, 4
	note A_, 4
	note G_, 4
	note C_, 2
	note D_, 2
	callchannel .sub
	note G_, 4
	intensity $c3
	note G_, 2
	intensity $c7
	note G_, 1
	note A_, 1
	note A#, 4
	intensity $c4
	octave 4
	note C_, 2
	intensity $c7
	note C_, 1
	note D_, 1
	note E_, 12
	jumpchannel .loop

.sub
	note G_, 6
	octave 4
	note C_, 6
	octave 3
	note G_, 4
	note A#, 4
	note A_, 4
	note G_, 4
	note F_, 4
	intensity $c3
	note E_, 2
	intensity $c7
	note E_, 1
	note F_, 1
	endchannel

Music_KantoGym_Ch3:
	stereopanning $f0
	notetype 12, $11
	note __, 16
	note __, 10
	octave 4
	note G_, 2
	note F_, 2
	note D_, 2
.loop
	callchannel .sub
	note D_, 2
	note F_, 2
	note D_, 2
	note F_, 2
	note D_, 2
	note F_, 2
	note D_, 2
	note F_, 2
	loopchannel 4, .loop
	jumpchannel .skip
.repeat
	note F_, 2
	note A#, 2
.skip
	callchannel .sub
	note F_, 2
	note A#, 2
	note F_, 2
	note A#, 2
	note F_, 2
	note A#, 2
	loopchannel 4, .repeat
	note A_, 2
	note F_, 2
	jumpchannel .loop

.sub
	note E_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	endchannel
