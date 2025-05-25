Music_KantoPokemonCenter:
	channelcount 3
	channel 1, Music_KantoPokemonCenter_Ch1
	channel 2, Music_KantoPokemonCenter_Ch2
	channel 3, Music_KantoPokemonCenter_Ch3

Music_KantoPokemonCenter_Ch1:
	tempo 144
	volume $77
	dutycycle 3
	stereopanning $f
	vibrato 10, $22
	octave 3
.loop
	callchannel .sub
	note A_, 2
	note B_, 2
	octave 4
	note C#, 2
	note D_, 2
	note C#, 2
	octave 3
	note B_, 2
	note A_, 2
	callchannel .sub
	note E_, 2
	note D_, 2
	note E_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note B_, 2
	note F#, 2
	note E_, 2
	note D_, 4
	note E_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note G_, 4
	note E_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note E_, 4
	note C#, 2
	note D_, 2
	note E_, 2
	note G_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note B_, 2
	note A_, 8
	octave 4
	note D_, 2
	note C#, 2
	octave 3
	note B_, 4
	note A_, 2
	note B_, 2
	octave 4
	note C#, 2
	note D_, 2
	note E_, 2
	note D_, 2
	note C#, 4
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	note D_, 2
	note E_, 2
	note C#, 2
	octave 3
	note B_, 2
	note A_, 4
	note G_, 2
	note A_, 2
	note B_, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note F#, 2
	note G_, 2
	jumpchannel .loop

.sub
	notetype 12, $a3
	note F#, 2
	note F_, 2
	note F#, 2
	intensity $b5
	octave 4
	note D_, 4
	note C#, 2
	octave 3
	note B_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note E_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	intensity $a3
	note A_, 2
	note E_, 2
	note A_, 2
	intensity $b5
	octave 4
	note C#, 4
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	endchannel

Music_KantoPokemonCenter_Ch2:
	vibrato 8, $25
.loop
	callchannel .sub
	note D_, 2
	note F#, 6
	dutycycle 3
	intensity $a5
	octave 3
	note A_, 4
	note E_, 4
	callchannel .sub
	note D_, 8
	dutycycle 3
	intensity $a5
	octave 3
	note D_, 4
	note E_, 4
	dutycycle 2
	intensity $c6
	octave 4
	note F#, 8
	note A_, 8
	note G_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note E_, 8
	note C#, 8
	note E_, 8
	note F#, 2
	note G_, 2
	note F#, 2
	note E_, 2
	note D_, 8
	note F#, 8
	note A_, 8
	note G_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note B_, 8
	note A_, 4
	note G_, 2
	note F#, 2
	note G_, 8
	note F#, 2
	note G_, 2
	note F#, 2
	note E_, 2
	note D_, 8
	jumpchannel .loop

.sub
	dutycycle 2
	notetype 12, $c2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	intensity $c3
	note A_, 4
	note G_, 4
	note F#, 2
	note E_, 2
	note C#, 6
	dutycycle 3
	intensity $a5
	octave 3
	note A_, 4
	note E_, 4
	dutycycle 2
	intensity $c2
	octave 4
	note C#, 2
	octave 3
	note A_, 2
	octave 4
	note C#, 2
	intensity $c3
	note F#, 4
	note E_, 4
	note C#, 2
	endchannel

Music_KantoPokemonCenter_Ch3:
	stereopanning $f0
	notetype 12, $10
.loop
	octave 4
	callchannel .sub1
	note F#, 2
	note A_, 2
	note F#, 2
	note A_, 2
	note F#, 2
	note A_, 2
	note G_, 2
	note A_, 2
	callchannel .sub1
	note D_, 2
	note F#, 2
	note D_, 2
	note F#, 2
	note D_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	callchannel .sub2
	note A_, 2
	note G#, 2
	note A_, 2
	callchannel .sub2
	note G_, 2
	note F#, 2
	note E_, 2
	jumpchannel .loop

.sub1
	note D_, 2
	note F#, 2
	note D_, 2
	note F#, 2
	note D_, 2
	note F#, 2
	note G_, 2
	note F#, 2
.repeat1
	note E_, 2
	note A_, 2
	loopchannel 7, .repeat1
	note G_, 2
	note A_, 2
	endchannel

.sub2
	note F#, 2
	note A_, 2
	loopchannel 4, .sub2
.repeat2
	note G_, 2
	note B_, 2
	loopchannel 4, .repeat2
.repeat3
	note E_, 2
	note G_, 2
	loopchannel 4, .repeat3
	note F#, 2
	note A_, 2
	note F#, 2
	note A_, 2
	note F#, 2
	endchannel
