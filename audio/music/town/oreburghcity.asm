Music_OreburghCity:
	channelcount 4
	channel 1, Music_OreburghCity_Ch1
	channel 2, Music_OreburghCity_Ch2
	channel 3, Music_OreburghCity_Ch3
	channel 4, Music_OreburghCity_Ch4

Music_OreburghCity_Ch1:
	tempo 208
	volume $77
	dutycycle 0
	stereopanning $f0
	tone $0001
.loop
	notetype $c, $b2
	octave 3
	note A#, 3
	note A#, 1
	note A_, 1
	note A#, 2
	note A#, 2
	octave 4
	note D_, 2
	note D_, 1
	note C#, 1
	note D_, 2
	note D_, 1
	note C_, 3
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 2
	octave 3
	note E_, 1
	note D_, 2
	note D_, 1
	note D_, 2
	note D_, 2
	note D#, 3
	note E_, 2
	note C_, 4
	note E_, 1
	note E_, 2
	note D_, 3
	note C_, 2
	note F_, 1
	note F_, 2
	octave 4
	note C_, 2
	note C_, 3
	octave 3
	note A#, 1
	note A#, 2
	note G#, 2
	note G#, 3
	intensity $b3
	octave 4
	note D_, 3
	note D_, 3
	note C_, 4
	intensity $b1
	octave 3
	note B_, 2
	note B_, 4
	intensity $b3
	octave 4
	note C_, 3
	note C_, 3
	octave 3
	note A#, 4
	intensity $b1
	note G#, 2
	note G#, 6
	intensity $b3
	octave 2
	note A_, 2
	octave 3
	note C_, 6
	note D#, 2
	note G_, 6
	octave 2
	note G_, 2
	note A#, 2
	octave 3
	note E_, 2
	octave 4
	note C_, 1
	note C_, 1
	octave 3
	note B_, 1
	note B_, 1
	note A#, 1
	note A#, 1
	note A_, 1
	note A_, 1
.repeat
	note C_, 1
	note C_, 2
	note C_, 2
	note D_, 1
	note C_, 2
	loopchannel 2, .repeat
	note C_, 1
	note C_, 2
	note C_, 2
	note D_, 1
	note C_, 1
	note G_, 1
	note E_, 1
	note E_, 2
	note A#, 2
	note A#, 3
	note A_, 1
	note A_, 2
	note A_, 2
	note A_, 3
	note A_, 1
	note A_, 2
	note A_, 2
	note A_, 2
	note A_, 1
	note G_, 2
	note G_, 3
	note G_, 3
	note E_, 3
	note G_, 5
	intensity $b1
	note G_, 2
	note G_, 3
	note G_, 3
	note E_, 3
	note G_, 2
	note E_, 1
	intensity $b3
	note C_, 4
	intensity $b1
	note F_, 1
	note F_, 2
	note D#, 3
	note D#, 1
	note D#, 2
	intensity $b3
	note C_, 7
	intensity $b1
	octave 2
	note G_, 2
	note G_, 1
	note G_, 3
	octave 3
	note G_, 2
	note G_, 1
	note G_, 3
	note G_, 2
	jumpchannel .loop

Music_OreburghCity_Ch2:
	tone $0001
	dutycycle 1
.loop
	notetype $c, $c5
	octave 4
	note C_, 3
	note G_, 3
	note D_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	octave 5
	callchannel .sub
	note D_, 3
	note C_, 3
	note G_, 3
	note D_, 2
	note E_, 2
	note G_, 2
	octave 5
	note D_, 2
	callchannel .sub
	note G#, 3
	intensity $c3
	note G_, 3
	note G_, 3
	note F#, 4
	intensity $c1
	note F_, 2
	note F_, 4
	intensity $c3
	note E_, 3
	note E_, 3
	note E_, 4
	intensity $c1
	note F_, 2
	note F_, 4
	intensity $c3
	note G_, 3
	note G_, 3
	octave 5
	note C_, 4
	note D_, 3
	note C_, 3
	octave 4
	note A#, 2
	note A_, 2
	note G_, 1
	note C_, 2
	note D_, 1
	note E_, 1
	note E_, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note C#, 1
	note C#, 1
	intensity $c5
	note C_, 3
	octave 3
	note A_, 3
	octave 4
	note C_, 2
	note D_, 1
	note D_, 1
	note C_, 2
	note D#, 1
	note C_, 3
	note E_, 3
	note D#, 3
	note E_, 2
	note A#, 1
	note A#, 1
	note A_, 2
	note G#, 1
	note A_, 3
	note E_, 3
	octave 3
	note A_, 3
	octave 4
	note C_, 2
	note D#, 2
	note C_, 2
	note D_, 1
	note C_, 3
	intensity $c2
	note C_, 2
	note C_, 2
	note D_, 1
	note C_, 3
	octave 3
	note G_, 1
	octave 4
	note C_, 1
	note D_, 1
	intensity $c3
	note C_, 5
	intensity $c2
	note E_, 2
	note E_, 2
	note D#, 1
	note E_, 3
	octave 3
	note G_, 1
	octave 4
	note E_, 1
	note F_, 1
	note E_, 2
	note C_, 1
	octave 3
	note G_, 2
	note A_, 2
	note A_, 1
	octave 4
	note C_, 1
	note D_, 1
	note C_, 3
	note D#, 1
	note C_, 1
	note D_, 1
	note C_, 2
	note C_, 1
	note E_, 1
	note F_, 1
	note G_, 2
	note G_, 2
	octave 3
	note G_, 4
	octave 4
	note G_, 1
	note G_, 2
	octave 3
	note G_, 2
	note G_, 1
	note G_, 2
	jumpchannel .loop

.sub
	note C_, 2
	octave 4
	note A_, 3
	note G_, 3
	note C_, 2
	note D#, 2
	note D_, 2
	note C_, 1
	endchannel

Music_OreburghCity_Ch3:
	stereopanning $f
	notetype $c, $12
	octave 2
.loop
	note C_, 1
	note C_, 1
	note E_, 1
	note E_, 1
	note G_, 1
	note G_, 1
	note A#, 1
	note G_, 1
	note E_, 1
	note E_, 1
	note G_, 1
	note G_, 1
	note A#, 1
	note A#, 1
	octave 3
	note D_, 1
	octave 2
	note A#, 1
	note F_, 1
	note F_, 1
	note A_, 1
	note A_, 1
	octave 3
	note C_, 1
	note C_, 1
	note E_, 1
	note C_, 1
	octave 1
	note A#, 1
	note A#, 1
	octave 2
	note D_, 1
	note D_, 1
	note F_, 1
	note F_, 1
	note G#, 1
	note F_, 1
	loopchannel 2, .loop
	note D_, 1
	note __, 2
	note D_, 1
	note __, 2
	note D_, 1
	note __, 3
	note G_, 1
	note __, 1
	note G_, 1
	note __, 3
	note C_, 1
	note __, 2
	note C_, 1
	note __, 2
	note C_, 1
	note __, 3
	note C#, 1
	note __, 1
	note C#, 1
	note __, 4
	note D_, 1
	note __, 1
	note D_, 1
	note D_, 1
	note __, 3
	note G_, 1
	note __, 1
	note G_, 1
	note G_, 1
	note __, 5
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 4
	note G_, 1
	note __, 2
	note A#, 1
	note __, 3
	note F_, 1
	note F_, 1
	note A_, 1
	note A_, 1
	octave 3
	note C_, 1
	note C_, 1
	note D_, 1
	note C_, 1
	octave 2
	note F#, 1
	note F#, 1
	note A_, 1
	note A_, 1
	octave 3
	note C_, 1
	note C_, 1
	note D_, 1
	note C_, 1
	octave 2
	note G_, 1
	note G_, 1
	octave 3
	note C_, 1
	note C_, 1
	note E_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	octave 2
	note A_, 1
	note A_, 1
	octave 3
	note C#, 1
	note C#, 1
	note G_, 1
	note G_, 1
	note A#, 1
	note G_, 1
	octave 2
	note D_, 1
	note D_, 1
	note F_, 1
	note F_, 1
	note A_, 1
	note A_, 1
	octave 3
	note C_, 1
	octave 2
	note A_, 1
	note F_, 1
	note F_, 1
	note A_, 1
	note A_, 1
	octave 3
	note C_, 1
	note C_, 1
	note D#, 1
	note C_, 1
	note __, 1
	octave 2
	note C_, 1
	note __, 2
	note C_, 1
	note C_, 1
	note __, 2
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 5
	note C_, 1
	note __, 2
	note C_, 1
	note C_, 1
	note __, 2
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 5
	note F_, 1
	note __, 2
	note F_, 1
	note F_, 1
	note __, 2
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	note __, 5
	note C_, 1
	note __, 2
	note C_, 1
	note C_, 1
	note __, 2
	note G_, 1
	note __, 1
	note G_, 1
	note G_, 1
	note __, 4
	jumpchannel .loop

Music_OreburghCity_Ch4:
	togglenoise 3
	notetype $c
.loop
	note A#, 1
	note G#, 1
	note C_, 1
	note G#, 1
	loopchannel 16, .loop
.repeat1
	note C_, 2
	note E_, 1
	note C_, 2
	note E_, 1
	note C_, 2
	note E_, 2
	note C_, 2
	note C_, 2
	note E_, 2
	loopchannel 2, .repeat1
	note C_, 2
	note E_, 1
	note C_, 2
	note E_, 1
	note C_, 2
	note C_, 1
	note G#, 2
	note C_, 1
	note C_, 2
	note G#, 1
	note C_, 1
	note A#, 1
	note G#, 1
	note C_, 1
	note G#, 1
	note A#, 1
	note G#, 1
	note C_, 1
	note G#, 1
	note C_, 1
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 2
	note C_, 1
.repeat2
	note A#, 1
	note G#, 1
	note C_, 1
	note G#, 1
	loopchannel 11, .repeat2
	note C_, 1
	note G#, 2
	note A#, 1
.repeat3
	note A#, 2
	note C_, 2
	note A#, 1
	note C_, 3
	loopchannel 8, .repeat3
	jumpchannel .loop
