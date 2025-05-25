Music_JohtoPokemonCenter:
	channelcount 4
	channel 1, Music_JohtoPokemonCenter_Ch1
	channel 2, Music_JohtoPokemonCenter_Ch2
	channel 3, Music_JohtoPokemonCenter_Ch3
	channel 4, Music_JohtoPokemonCenter_Ch4

Music_JohtoPokemonCenter_Ch1:
	tempo 152
	volume $77
	dutycycle $2
	vibrato $a, $14
	tone $0001
.loop
	stereopanning $f
	notetype $c, $83
	octave 3
	callchannel .sub
	note F#, 2
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
	intensity $b4
	note F#, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note B_, 2
	stereopanning $f0
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
	note F#, 2
	note F_, 2
	note F#, 2
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
	note A_, 2
	note E_, 2
	note A_, 2
	octave 4
	note C#, 4
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	endchannel

Music_JohtoPokemonCenter_Ch2:
	vibrato $10, $25
.loop
	callchannel .sub
	note D_, 2
	note F#, 6
	stereopanning $f
	intensity $a5
	octave 3
	note A_, 4
	note E_, 4
	callchannel .sub
	note D_, 8
	stereopanning $f
	intensity $a5
	octave 3
	note D_, 4
	note E_, 4
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
	stereopanning $ff
	dutycycle $2
	notetype $c, $c2
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
	stereopanning $f
	intensity $a5
	octave 3
	note A_, 4
	note E_, 4
	stereopanning $ff
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

Music_JohtoPokemonCenter_Ch3:
	notetype $c, $28
.loop
	stereopanning $f0
	octave 3
	callchannel .sub1
	note F#, 1
	note __, 5
	note A_, 1
	note __, 3
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	callchannel .sub1
	note D_, 1
	note __, 5
	note F#, 1
	note __, 3
	note F#, 1
	note __, 1
	note D_, 1
	note __, 1
	note G_, 1
	stereopanning $ff
	callchannel .sub2
	note __, 1
	note G_, 1
	note __, 1
	callchannel .sub3
	note G#, 1
	note __, 1
	note A_, 1
	callchannel .sub2
	note __, 3
	callchannel .sub3
	note G_, 1
	note __, 1
	note E_, 1
	note __, 1
	jumpchannel .loop

.sub1
	note D_, 1
	note __, 5
	note F#, 1
	note __, 3
	note F#, 1
	note __, 1
	note G_, 1
	note __, 1
	note F#, 1
	note __, 1
	note E_, 1
	note __, 5
	note A_, 1
	note __, 3
	note A_, 1
	note __, 3
	note A_, 1
	note __, 1
	note E_, 1
	note __, 5
	note A_, 1
	note __, 3
	note A_, 1
	note __, 1
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	endchannel

.sub2
	note __, 1
	note F#, 1
	note __, 5
	note A_, 1
	note __, 3
	note A_, 1
	note __, 3
	note A_, 1
	note __, 1
	note G_, 1
	note __, 5
	note B_, 1
	note __, 3
	note B_, 1
	endchannel

.sub3
	note B_, 1
	note __, 1
	note E_, 1
	note __, 5
	note G_, 1
	note __, 3
	note G_, 1
	note __, 3
	note G_, 1
	note __, 1
	note F#, 1
	note __, 5
	note A_, 1
	note __, 3
	note A_, 1
	note __, 1
	endchannel

Music_JohtoPokemonCenter_Ch4:
	togglenoise $3
	notetype $c
	stereopanning $ff
.loop
	note G_, 6
	note G_, 4
	note G_, 2
	note G_, 2
	note G_, 2
	jumpchannel .loop
