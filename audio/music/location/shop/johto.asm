Music_JohtoShop:
	channelcount 4
	channel 1, Music_JohtoShop_Ch1
	channel 2, Music_JohtoShop_Ch2
	channel 3, Music_JohtoShop_Ch3
	channel 4, Music_JohtoShop_Ch4

Music_JohtoShop_Ch1:
	tempo $90
	volume $77
	dutycycle 1
	notetype $c, $b2
	octave 4
	note C#, 4
	note C#, 4
	note C_, 2
	note C_, 4
	octave 3
	note B_, 6
	note A#, 12
.loop
	stereopanning $f
	note D#, 4
	octave 2
	note A#, 2
	octave 3
	note D#, 4
	octave 2
	note F#, 4
	octave 3
	note D#, 4
	octave 2
	note F#, 2
	note B_, 2
	note F#, 4
	octave 3
	note D#, 4
	octave 2
	note B_, 2
	note A_, 4
	note F#, 2
	octave 3
	note D#, 4
	octave 2
	note A_, 4
	octave 3
	note D#, 4
	octave 2
	note F#, 2
	note A_, 2
	note F#, 4
	octave 3
	note D#, 4
	octave 2
	note A_, 2
	note G#, 4
	note B_, 2
	note E_, 4
	note B_, 4
	note G#, 4
	note F_, 2
	octave 3
	note D_, 2
	octave 2
	note G#, 4
	octave 3
	note D_, 4
	note F_, 2
	note B_, 4
	note F#, 2
	note B_, 2
	note F#, 2
	intensity $b4
	note F_, 2
	note F#, 2
	note G#, 2
	note A#, 16
	dutycycle 2
	note A#, 4
	note B_, 2
	note D#, 4
	note F#, 4
	note D#, 1
	note F#, 1
	note B_, 2
	note F#, 2
	note B_, 2
	octave 4
	note C#, 4
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	note D#, 2
	octave 3
	note A_, 4
	note B_, 2
	note D#, 4
	note F#, 4
	note D#, 1
	note F#, 1
	note A_, 2
	note D#, 2
	note F#, 2
	note B_, 4
	note A_, 4
	note F#, 1
	note A_, 1
	note B_, 4
	note B_, 2
	note E_, 4
	note B_, 4
	note E_, 4
	octave 2
	note F_, 2
	octave 3
	note D_, 2
	note F_, 4
	note D_, 4
	note G#, 2
	note B_, 4
	note F#, 2
	octave 4
	note C#, 1
	octave 3
	note B_, 1
	note F#, 2
	note F_, 2
	note F#, 2
	note G#, 2
	note A#, 8
	note E_, 2
	note C#, 2
	note F#, 2
	note E_, 2
	intensity $b1
	dutycycle 0
	note D#, 2
	octave 2
	note G_, 2
	note A#, 2
	note G_, 4
	note A#, 4
	octave 3
	note D#, 4
	octave 2
	note G_, 2
	note A#, 2
	note G_, 4
	octave 3
	note D#, 4
	octave 2
	note A#, 2
	octave 3
	note D#, 2
	octave 2
	note G#, 2
	note B_, 2
	note G#, 4
	octave 3
	note D#, 4
	octave 2
	note B_, 4
	note G#, 2
	note B_, 2
	note G#, 4
	octave 3
	note D#, 4
	octave 2
	note G#, 2
	intensity $b4
	dutycycle 1
	octave 3
	note G_, 2
	note D#, 2
	note G_, 2
	note D#, 2
	note A#, 2
	note A_, 2
	note A#, 2
	octave 4
	note D#, 2
	octave 3
	note D#, 2
	octave 2
	note A#, 2
	octave 4
	note D#, 1
	note D_, 1
	note D#, 2
	note F_, 1
	note E_, 1
	note F_, 2
	note G_, 1
	note F#, 1
	note G_, 2
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note D#, 2
	octave 3
	note B_, 4
	note D#, 4
	note C#, 4
	octave 4
	note C#, 2
	note D#, 2
	octave 3
	note B_, 4
	note D#, 4
	octave 2
	note G#, 2
	intensity $b2
	octave 3
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	note G#, 4
	note B_, 4
	note D#, 2
	note D_, 2
	octave 2
	note B_, 2
	octave 3
	note D_, 2
	note G#, 4
	note F_, 4
	note D_, 2
	note C#, 2
	octave 2
	note F#, 2
	note A#, 2
	octave 3
	note C#, 2
	note F#, 2
	note B_, 2
	octave 4
	note C#, 2
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	octave 3
	note B_, 4
	note A#, 10
	jumpchannel .loop

Music_JohtoShop_Ch2:
	dutycycle 2
	notetype $c, $b1
	octave 4
	note F#, 4
	note F#, 4
	note F#, 2
	note F#, 4
	note F#, 6
	intensity $c5
	note F#, 6
	dutycycle 1
	octave 3
	note F#, 2
	note G#, 2
	note A#, 2
	octave 4
.loop
	stereopanning $f0
	callchannel .sub1
	note D#, 2
	note D_, 2
	note D#, 2
	note E_, 6
	note D#, 1
	note E_, 1
	note F#, 2
	callchannel .sub1
	note D#, 2
	note D_, 2
	note D#, 2
	note G#, 6
	note E_, 1
	note D#, 1
	note C#, 2
	note D#, 3
	octave 3
	note G#, 1
	octave 4
	note E_, 2
	note C#, 12
	octave 3
	note G#, 6
	note A#, 4
	note B_, 4
	octave 4
	callchannel .sub2
	intensity $c2
	note C#, 8
	note B_, 2
	note F#, 2
	note E_, 2
	note D#, 2
	intensity $c5
	callchannel .sub1
	note D#, 6
	note E_, 4
	note D#, 2
	note E_, 2
	note F#, 2
	callchannel .sub1
	notetype 6, $c5
	note D#, 11
	note G_, 1
	note G#, 8
	note F#, 8
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	note D#, 6
	octave 3
	note G#, 2
	octave 4
	note E_, 4
	note C#, 16
	note __, 8
	octave 3
	note G#, 4
	note G_, 4
	note G#, 4
	note A#, 4
	note G#, 4
	note A#, 4
	note B_, 3
	octave 4
	note D_, 1
	notetype $c, $c5
	callchannel .sub2
	note C#, 12
	notetype 6, $c5
	dutycycle 2
	callchannel .sub3
	note G_, 8
	note D#, 8
	note C#, 8
	note C#, 6
	note C#, 1
	note D_, 1
	note D#, 4
	octave 3
	note B_, 8
	note A#, 4
	note B_, 4
	octave 4
	note C#, 12
	note D#, 4
	note G#, 12
	callchannel .sub3
	note G_, 2
	note F#, 2
	note G_, 4
	note G#, 2
	note G_, 2
	note G#, 4
	note A#, 2
	note A_, 2
	note A#, 4
	note A#, 8
	note B_, 4
	note G#, 8
	note G_, 4
	note G#, 4
	note A#, 12
	note B_, 4
	note G#, 7
	dutycycle 0
	octave 5
	note C_, 1
	note C#, 4
	octave 4
	note B_, 4
	note A#, 4
	notetype $c, $c5
	note B_, 15
	notetype 6, $c5
	note G#, 1
	note A#, 1
	notetype $c, $c5
	note B_, 10
	note G#, 2
	note A#, 2
	note B_, 2
	note A#, 10
	note G#, 2
	note A#, 2
	note G#, 2
	note A#, 2
	note G#, 4
	note F#, 10
	dutycycle 1
	jumpchannel .loop

.sub1
	note C#, 3
	octave 3
	note F#, 1
	octave 4
	note D#, 2
	octave 3
	note B_, 8
	note B_, 1
	octave 4
	note C#, 1
	endchannel

.sub2
	note D#, 6
	note E_, 1
	note D#, 1
	note C#, 2
	octave 3
	note B_, 2
	note A#, 2
	note B_, 2
	octave 4
	endchannel

.sub3
	octave 3
	note B_, 4
	octave 4
	note C#, 4
	note D#, 8
	note D#, 8
	note D#, 4
	note D_, 4
	note D#, 3
	note G#, 1
	note A#, 12
	endchannel

Music_JohtoShop_Ch3:
	notetype $c, $14
	octave 4
	note D#, 1
	note __, 3
	note D#, 1
	note __, 3
	note D_, 1
	note __, 1
	note D_, 1
	note __, 3
	note C#, 1
	note __, 5
	octave 3
	note F#, 5
	note __, 7
.loop
	octave 2
.repeat1
	callchannel .sub1
	loopchannel 4, .repeat1
	note E_, 4
	note __, 2
	note E_, 1
	note __, 1
	note B_, 4
	note __, 2
	note B_, 1
	note __, 1
	note F_, 4
	note __, 2
	note F_, 1
	note __, 1
	callchannel .sub1
	octave 3
	callchannel .sub2
	octave 2
	note F#, 2
	note __, 14
.repeat2
	note B_, 4
	intensity $24
	octave 6
	note F#, 1
	intensity $14
	octave 2
	note __, 1
	note B_, 1
	note __, 1
	note F#, 4
	intensity $24
	octave 5
	note F#, 1
	intensity $14
	octave 2
	note __, 1
	note F#, 1
	note __, 1
	loopchannel 4, .repeat2
	note E_, 4
	intensity $24
	octave 6
	note G#, 1
	intensity $14
	octave 2
	note __, 1
	note E_, 1
	callchannel .sub3
	note F_, 4
	intensity $24
	octave 6
	note G#, 1
	intensity $14
	octave 2
	note __, 1
	note F_, 1
	callchannel .sub3
	note F#, 4
	intensity $24
	octave 6
	note F#, 1
	intensity $14
	octave 2
	note __, 1
	note F#, 1
	note __, 1
	octave 3
	note F#, 4
	intensity $24
	octave 5
	note F#, 1
	intensity $14
	octave 2
	note __, 1
	octave 3
	note F#, 1
	octave 2
	note __, 1
	note F#, 2
	note __, 6
	octave 3
	note C#, 4
	octave 2
	note F#, 4
	note D#, 4
	note __, 2
	note D#, 1
	note __, 1
	note G_, 4
	note __, 2
	note G_, 1
	note __, 1
	note A#, 4
	note __, 2
	note A#, 1
	note __, 1
	note D#, 4
	note G_, 4
	note G#, 4
	note __, 2
	note G#, 1
	note __, 1
	note G_, 4
	note __, 2
	note G_, 1
	note __, 1
	callchannel .sub2
	note F_, 4
	note E_, 4
	note D#, 4
	octave 4
	note A#, 1
	octave 2
	note __, 1
	note D#, 1
	note __, 1
	note G_, 4
	octave 4
	note G_, 1
	octave 2
	note __, 1
	note G_, 1
	note __, 1
	note A#, 4
	octave 4
	note A#, 1
	octave 2
	note __, 1
	note A#, 1
	note __, 1
	note D#, 4
	note G_, 4
	note G#, 4
	callchannel .sub4
	note G#, 1
	note __, 1
	note G_, 4
	callchannel .sub4
	note G_, 1
	note __, 1
	note F#, 4
	callchannel .sub4
	note F#, 1
	note __, 1
	note F_, 4
	callchannel .sub4
	note F_, 1
	note __, 1
	note E_, 4
	intensity $24
	octave 6
	note G#, 1
	intensity $14
	octave 2
	note __, 1
	note E_, 1
	note __, 1
	octave 1
	note B_, 4
	intensity $24
	octave 5
	note G#, 1
	intensity $14
	octave 1
	note __, 1
	note B_, 1
	note __, 1
	octave 2
	note F_, 4
	intensity $24
	octave 6
	note G#, 1
	intensity $14
	octave 2
	note __, 1
	note F_, 1
	note __, 1
	octave 1
	note B_, 4
	intensity $24
	octave 6
	note D_, 1
	intensity $14
	octave 1
	note __, 1
	note B_, 1
	note __, 1
	octave 2
	note F#, 4
	intensity $24
	octave 6
	note F#, 1
	intensity $14
	octave 2
	note __, 1
	note F#, 1
	note __, 1
	octave 3
	note C#, 4
	intensity $24
	octave 5
	note F#, 1
	intensity $14
	octave 3
	note __, 1
	note C#, 1
	note __, 1
	octave 2
	note F#, 1
	note __, 1
	note F#, 1
	note __, 3
	note F#, 3
	note __, 1
	note F#, 1
	note __, 1
	note G#, 1
	note __, 1
	note A#, 1
	note __, 1
	jumpchannel .loop

.sub1
	note B_, 4
	note __, 2
	note B_, 1
	note __, 1
.sub2
	note F#, 4
	note __, 2
	note F#, 1
	note __, 1
	endchannel

.sub3
	note __, 1
	note B_, 4
	intensity $24
	octave 5
	note G#, 1
	intensity $14
	octave 2
	note __, 1
	note B_, 1
	note __, 1
	endchannel

.sub4
	intensity $24
	octave 6
	note D#, 1
	intensity $14
	octave 2
	note __, 1
	endchannel

Music_JohtoShop_Ch4:
	notetype $c
	togglenoise 0
	note G_, 4
	note G_, 4
	note G_, 2
	note G_, 4
	note G_, 6
	note A#, 12
.loop
	note A#, 4
	callchannel .sub
	note G_, 16
	note G_, 2
	note D_, 2
	callchannel .sub
	note G_, 16
.repeat
	note A#, 4
	note G_, 2
	note D_, 2
	loopchannel 22, .repeat
	note G_, 2
	note A#, 4
	note A#, 4
	note D_, 2
	note G_, 2
	note G_, 2
	jumpchannel .loop

.subrepeat
	note G_, 2
	note D_, 2
	note D_, 2
	note G_, 2
	note D_, 2
	note D_, 2
	note G_, 2
	note D_, 2
	note G_, 2
	note D_, 2
.sub
	note G_, 2
	note D_, 2
	note D_, 2
	note G_, 2
	note D_, 2
	note D_, 2
	loopchannel 4, .subrepeat
	endchannel
