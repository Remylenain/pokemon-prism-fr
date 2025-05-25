Music_ViridianCity:
	channelcount 4
	channel 1, Music_ViridianCity_Ch1
	channel 2, Music_ViridianCity_Ch2
	channel 3, Music_ViridianCity_Ch3
	channel 4, Music_ViridianCity_Ch4

Music_ViridianCity_Ch1:
	tempo 157
	volume $77
	stereopanning $f
	dutycycle $2
	vibrato $12, $34
	notetype $c, $a7
	octave 3
	note F#, 1
	note __, 3
	note F#, 2
	note __, 4
	note F#, 2
	note __, 2
	note F#, 1
	note __, 1
	note F#, 4
	note __, 2
	octave 4
	note D_, 2
	note __, 2
	octave 3
	note A_, 2
	note __, 2
	note F#, 1
	note __, 1
	note F#, 1
	callchannel .sub1
	note __, 4
.loop
	callchannel .sub2
	note __, 4
	callchannel .sub2
	octave 4
	note C_, 4
	callchannel .sub3
	octave 4
	note B_, 2
	note G_, 2
	note D_, 2
	octave 3
	note B_, 2
	note F#, 2
	note E_, 2
	callchannel .sub4
	note C#, 1
	note __, 3
	octave 3
	note A_, 1
	note __, 1
	octave 4
	note C#, 1
	note __, 1
	note F#, 1
	note __, 1
	intensity $87
	octave 5
	note F#, 4
	note F_, 4
	intensity $a7
	octave 3
	note G_, 6
	note B_, 8
	octave 4
	note E_, 2
	note __, 2
	note E_, 2
	octave 3
	note B_, 4
	note G_, 2
	note F#, 2
	note E_, 4
	note D_, 2
	octave 2
	note A_, 2
	octave 3
	note D_, 1
	note __, 1
	note F#, 1
	note __, 3
	note D_, 2
	callchannel .sub4
	note C_, 1
	note __, 1
	note D#, 2
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	callchannel .sub3
	octave 4
	note A_, 2
	note G_, 2
	note D_, 2
	note G_, 2
	octave 3
	note F#, 2
	note E_, 2
	callchannel .sub4
	note C_, 1
	note __, 3
	note E_, 2
	note __, 2
	note C_, 2
	note __, 2
	octave 3
	note A_, 2
	note __, 2
	note F#, 2
	note G_, 6
	note B_, 1
	note __, 1
	octave 4
	note E_, 4
	note F#, 2
	note G_, 6
	note E_, 2
	note __, 2
	octave 3
	note G_, 2
	octave 4
	note E_, 2
	note __, 2
	note F#, 6
	note D_, 4
	octave 3
	note A_, 4
	note F#, 4
	note G_, 1
	note __, 3
	note G_, 8
	note A#, 4
	jumpchannel .loop

.sub2
	note A_, 1
	note __, 3
	note A_, 2
	note __, 4
	note A_, 2
	note __, 2
	note A_, 1
	note __, 1
	octave 4
	note C_, 4
	note __, 2
	octave 3
	note A_, 2
	note __, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 1
	note __, 1
	octave 4
	note C_, 1
	note __, 1
	octave 3
	note B_, 1
	note __, 3
	note G_, 2
	note __, 4
	note G_, 2
	note __, 2
	octave 4
	note D_, 2
	note __, 2
	octave 3
	note B_, 2
	note __, 2
	note G_, 1
	note __, 1
	note G_, 4
	note __, 2
	note B_, 1
	note __, 1
	octave 4
	note D_, 1
	note __, 3
	note D_, 2
	note __, 4
	note D_, 2
	note __, 2
	note D_, 1
	note __, 1
	octave 3
	note G_, 4
	note __, 2
	octave 4
	note C#, 1
	note __, 1
	note E_, 1
	note __, 1
	note D_, 4
	note C#, 1
	note __, 1
	octave 3
	note A_, 1
.sub1
	note __, 3
	note F#, 2
	note __, 4
	note F#, 2
	note __, 2
	note G_, 1
	note __, 5
	note G_, 8
	endchannel

.sub3
	octave 3
	note B_, 2
	note D_, 2
	note G_, 1
	note __, 1
	note B_, 1
	note __, 3
	note G_, 2
	note B_, 1
	note __, 1
	octave 4
	note D_, 1
	note __, 3
	octave 3
	note B_, 2
	octave 4
	note D_, 1
	note __, 1
	note G_, 1
	note __, 1
	endchannel

.sub4
	note F#, 1
	note __, 1
	note A_, 1
	note __, 3
	note F#, 2
	note A_, 1
	note __, 1
	octave 4
	endchannel

Music_ViridianCity_Ch2:
	vibrato $10, $46
	dutycycle $1
	notetype $c, $b7
	stereopanning $f0
	callchannel .sub1
	note __, 2
	note D_, 4
	note __, 2
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 3
	note C#, 4
	octave 2
	note A_, 1
	callchannel .sub2
	note E_, 1
	note __, 5
	note E_, 8
	note __, 4
.loop
	callchannel .sub3
	note E_, 1
	note __, 5
	note E_, 8
	note __, 4
	callchannel .sub3
	note E_, 1
	note __, 5
	note E_, 8
	octave 2
	note F#, 4
	callchannel .sub4
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note G_, 1
	note __, 1
	octave 3
	note D_, 4
	octave 2
	note B_, 2
	callchannel .sub5
	octave 3
	note C#, 1
	note __, 1
	note C#, 4
	note C_, 4
	octave 2
	callchannel .sub6
	note B_, 1
	note __, 1
	note E_, 2
	note B_, 2
	note G_, 4
	note D_, 4
	note __, 2
	note A_, 1
	note __, 1
	note A_, 4
	note C_, 2
	note C#, 2
	note __, 2
	note D#, 2
	note A_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	note D#, 2
	note C_, 2
	octave 2
	note A_, 2
	note F#, 2
	callchannel .sub4
	note B_, 1
	note __, 1
	note G_, 1
	note __, 1
	note B_, 4
	note G_, 2
	callchannel .sub5
	note A_, 2
	note __, 2
	octave 3
	note C_, 2
	note __, 2
	octave 2
	note D#, 2
	callchannel .sub6
	note A#, 1
	note __, 1
	note A#, 4
	note __, 2
	note G_, 1
	callchannel .sub2
	note D_, 1
	note __, 1
	note E_, 1
	note __, 3
	note E_, 8
	octave 1
	note A_, 4
	jumpchannel .loop

.sub3
	octave 2
	note D_, 4
	note __, 2
	note A_, 1
	note __, 1
	note A_, 4
	note __, 4
	note D#, 4
	note __, 2
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 3
	note C_, 4
	octave 2
	note A_, 1
	note __, 1
	note E_, 4
	note __, 2
	note B_, 1
	note __, 1
	note B_, 4
	note __, 4
	note E_, 4
	note __, 2
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	octave 3
	note D_, 4
	octave 2
	note B_, 1
	note __, 1
	note G_, 4
	note __, 2
	octave 3
	note D_, 1
	note __, 1
	note D_, 4
	note __, 4
	octave 2
	note A_, 4
	note __, 2
	octave 3
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note G_, 4
	note E_, 1
.sub2
	note __, 1
.sub1
	octave 2
	note D_, 4
	note __, 2
	note A_, 1
	note __, 1
	note A_, 4
	note __, 2
	endchannel

.sub4
	note G_, 4
	note __, 2
	octave 3
	note D_, 1
	note __, 1
	note D_, 4
	octave 2
	note F_, 2
	note F#, 2
	note G_, 4
	note __, 2
	endchannel

.sub5
	note F#, 4
	note __, 2
	octave 3
	note C#, 1
	note __, 1
	note C#, 4
	octave 2
	note E_, 2
	note F_, 2
	note __, 2
	note F#, 2
	note __, 2
	endchannel

.sub6
	note E_, 4
	note __, 2
	note B_, 1
	note __, 1
	note B_, 4
	note D_, 2
	note D#, 2
	note E_, 4
	note __, 2
	endchannel

Music_ViridianCity_Ch3:
	vibrato $12, $24
	notetype $c, $13
	stereopanning $ff
	octave 4
	note A_, 1
	note __, 3
	note A_, 2
	note __, 4
	note A_, 2
	note __, 2
	note A_, 1
	note __, 1
	note A_, 4
	note __, 2
	octave 5
	note F#, 2
	note __, 2
	note C#, 2
	note __, 2
	octave 4
	note A_, 1
	note __, 1
	note A_, 1
	note __, 3
	callchannel .sub1
	note F#, 2
	note G_, 2
.loop
	callchannel .sub2
	octave 5
	note F#, 2
	note G_, 2
	callchannel .sub2
	note E_, 4
	vibrato $18, $25
	intensity $25
	note B_, 12
	note G_, 4
	octave 6
	note D_, 8
	note E_, 2
	note D_, 2
	note C#, 2
	octave 5
	note B_, 2
	note A_, 12
	note F#, 4
	note A_, 8
	note A_, 4
	note G#, 4
	note E_, 10
	note E_, 2
	note F#, 2
	note G_, 2
	note __, 2
	note G_, 2
	note F#, 4
	note E_, 4
	note G_, 4
	note F#, 12
	note D_, 4
	note A_, 4
	note __, 4
	octave 6
	note C_, 8
	octave 5
	note B_, 12
	octave 6
	note C#, 2
	note D_, 2
	note E_, 2
	note __, 2
	note D_, 2
	note __, 2
	note C#, 2
	note __, 2
	octave 5
	note B_, 2
	note __, 2
	note A_, 10
	note A_, 2
	note B_, 2
	octave 6
	note C_, 2
	note __, 2
	octave 5
	note B_, 2
	note __, 2
	note A_, 2
	note __, 2
	note F#, 2
	note __, 2
	note G_, 12
	note G_, 2
	note A_, 2
	note A#, 6
	note A_, 2
	note __, 2
	note G_, 2
	note A#, 2
	note __, 2
	note A_, 14
	note __, 4
	note D_, 1
	note __, 3
	note D_, 8
	note E_, 4
	intensity $13
	jumpchannel .loop

.sub2
	octave 5
	note A_, 2
	note __, 2
	note G_, 2
	note __, 2
	note F#, 2
	note __, 8
	note F#, 2
	note G_, 2
	note A_, 2
	note __, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note G_, 2
	note E_, 2
	octave 4
	note B_, 2
	note __, 4
	note B_, 2
	note __, 2
	octave 5
	note G_, 2
	note __, 2
	note D_, 2
	note __, 2
	octave 4
	note B_, 1
	note __, 1
	note B_, 4
	octave 5
	note E_, 2
	note F#, 2
	note G_, 2
	note __, 2
	note F#, 2
	note __, 2
	note E_, 2
	note __, 8
	note E_, 2
	note F#, 2
	note G_, 2
	note __, 2
	note G_, 2
	note F#, 2
	note E_, 2
	note F#, 2
	note D_, 2
	octave 4
.sub1
	note A_, 2
	note __, 4
	note A_, 2
	note __, 2
	octave 5
	note D_, 1
	note __, 5
	note D_, 8
	endchannel

Music_ViridianCity_Ch4:
	togglenoise $3
	notetype $c
	callchannel .sub1
.loop
	callchannel .sub2
	callchannel .sub2
.repeat
	callchannel .sub3
	callchannel .sub4
	note D_, 2
	note D_, 2
	note F#, 2
	callchannel .sub3
	callchannel .sub4
	note F#, 2
	note D_, 2
	note D#, 2
	loopchannel 2, .repeat
	jumpchannel .loop

.sub1
	loopchannel 3, .sub2

.subrepeat
	note D_, 4
	note E_, 2
	note D_, 2
	note E_, 2
	note F#, 2
.sub2
	note E_, 2
	note E_, 2
	note D_, 2
	note E_, 4
	note D_, 2
	note E_, 2
	note F#, 2
	note E_, 2
	note E_, 2
	loopchannel 4, .subrepeat
	note F#, 4
	note D_, 2
	note D_, 2
	note A#, 2
	note A#, 2
	endchannel

.sub4
	note F#, 2
	note D_, 2
	note D#, 2
.sub3
	note D#, 2
	note F#, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note F#, 2
	note D_, 4
	note D#, 2
	note F#, 2
	note D_, 2
	note D#, 2
	note D#, 2
	endchannel
