Music_NaljoPokemonCenter:
	channelcount 4
	channel 1, Music_NaljoPokemonCenter_Ch1
	channel 2, Music_NaljoPokemonCenter_Ch2
	channel 3, Music_NaljoPokemonCenter_Ch3
	channel 4, Music_NaljoPokemonCenter_Ch4

Music_NaljoPokemonCenter_Ch1:
	tempo 160
	volume $77
	dutycycle $1
	tone $0002
	vibrato $8, $22
	stereopanning $f0
	notetype $c, $a2
	octave 3
	note E_, 2
	note F_, 2
	note G_, 4
	note G_, 2
	note A_, 2
	note B_, 4
.loop
	octave 3
	callchannel .sub
	note B_, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note G_, 2
	note A_, 2
	note B_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	callchannel .sub
	note B_, 4
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note A_, 2
	note E_, 2
	note D_, 2
	note C_, 4
	note D_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 4
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note F_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note A_, 2
	note G_, 8
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 4
	note G_, 2
	note A_, 2
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 4
	note A_, 2
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_, 4
	note F_, 2
	note G_, 2
	note A_, 2
	note F_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	jumpchannel .loop

.sub
	note E_, 2
	note C_, 2
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note G_, 2
	note D_, 2
	note G_, 2
	endchannel

Music_NaljoPokemonCenter_Ch2:
	notetype $c, $c2
	dutycycle $3
	note __, 10
	octave 1
	note G_, 2
	note A_, 2
	note B_, 2
.loop
	octave 2
	callchannel .sub1
	note E_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	callchannel .sub1
	note C_, 2
	note E_, 2
	octave 1
	note G_, 2
	octave 2
	note E_, 2
	note C_, 2
	note A_, 2
	note G_, 2
	callchannel .sub2
	callchannel .sub3
	callchannel .sub2
	callchannel .sub4
	callchannel .sub3
	note F_, 2
	note E_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	jumpchannel .loop

.sub1
	note C_, 2
	note E_, 2
	octave 1
	note G_, 2
	octave 2
	note E_, 2
	note C_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note G_, 2
.repeat
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	note D_, 2
	note G_, 2
	loopchannel 3, .repeat
	note F_, 2
	note G_, 2
	endchannel

.sub2
	note F_, 2
.sub4
	note E_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	endchannel

.sub3
	note F_, 2
	note A_, 2
	note C_, 2
	note A_, 2
	note F_, 2
	note A_, 2
	note C_, 2
	note A_, 2
	note D_, 2
	note F_, 2
	octave 1
	note B_, 2
	octave 2
	note F_, 2
	note D_, 2
	note F_, 2
	octave 1
	note B_, 2
	octave 2
	endchannel

Music_NaljoPokemonCenter_Ch3:
	notetype $c, $24
	vibrato $10, $34
	octave 4
	note G_, 2
	note A_, 2
	note B_, 4
	note B_, 2
	octave 5
	note C_, 2
	note D_, 4
	intensity $25
.loop
	callchannel .sub
	note C_, 2
	note E_, 6
	octave 4
	note E_, 2
	note F_, 2
	note D_, 2
	note E_, 2
	octave 5
	callchannel .sub
	note C_, 8
	octave 4
	note G_, 2
	note A_, 2
	note B_, 2
	octave 5
	note D_, 2
	vibrato $18, $44
	note E_, 8
	note G_, 8
	note F_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 8
	octave 4
	note B_, 8
	octave 5
	note D_, 8
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 8
	note E_, 8
	note G_, 8
	note F_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note A_, 8
	note G_, 4
	note F_, 2
	note E_, 2
	note F_, 8
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 8
	vibrato $10, $34
	jumpchannel .loop

.sub
	note C_, 2
	octave 4
	note G_, 2
	octave 5
	note C_, 2
	note G_, 4
	note F_, 4
	note E_, 2
	note D_, 2
	octave 4
	note B_, 6
	intensity $10
	octave 6
	note G_, 1
	note __, 1
	note D_, 1
	note __, 1
	octave 7
	note D_, 1
	note __, 3
	intensity $25
	octave 4
	note B_, 2
	note G_, 2
	note B_, 2
	octave 5
	note E_, 4
	note D_, 4
	octave 4
	note B_, 2
	octave 5
	endchannel

Music_NaljoPokemonCenter_Ch4:
	togglenoise $3
	stereopanning $f
	notetype $c
	note A_, 8
	note A_, 4
.loop
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	jumpchannel .skip
.repeat
	note C#, 2
	note D_, 2
	note C#, 2
.skip
	note A_, 2
	note C#, 2
	note C#, 2
	note C#, 2
	note A_, 2
	loopchannel 4, .repeat
	note D_, 2
	jumpchannel .loop
