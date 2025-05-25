Music_HoennPokemonCenter:
	channelcount 4
	channel 1, Music_HoennPokemonCenter_Ch1
	channel 2, Music_HoennPokemonCenter_Ch2
	channel 3, Music_HoennPokemonCenter_Ch3
	channel 4, Music_HoennPokemonCenter_Ch4

Music_HoennPokemonCenter_Ch1:
	tempo 184
	dutycycle $0
	vibrato $12, $15
	tone $0001
	notetype $6, $72
	octave 4
	note E_, 4
	note A_, 4
	note C#, 4
	octave 3
	note B_, 4
	note A_, 4
	note B_, 4
	octave 4
	note C#, 4
	note E_, 4
.loop
	dutycycle $2
	intensity $83
	octave 4
	note A_, 2
	note E_, 2
	note G#, 2
	note A_, 2
	octave 5
	note C#, 3
	note D#, 1
	note E_, 8
	note E_, 4
	note D_, 1
	note E_, 1
	note D_, 2
	note C#, 4
	octave 4
	note B_, 4
	intensity $84
	octave 5
	note D_, 8
	octave 4
	note B_, 4
	note G#, 4
	note E_, 2
	octave 3
	note B_, 2
	octave 4
	note F#, 4
	note G_, 4
	intensity $83
	note G#, 2
	octave 3
	note B_, 2
	octave 4
	note E_, 2
	note F#, 2
	note G#, 3
	octave 5
	note C_, 1
	note C#, 8
	octave 4
	note B_, 8
	note G#, 4
	note A_, 4
	intensity $80
	octave 5
	note C#, 4
	intensity $87
	note C#, 16
	dutycycle $1
	intensity $77
	octave 3
	note C#, 2
	octave 2
	note B_, 2
	note A_, 2
	octave 3
	note C_, 2
	note D_, 1
	note C#, 11
	octave 2
	note E_, 4
	note A_, 4
	octave 3
	note E_, 4
	note D_, 4
	note C#, 4
	note D_, 12
	octave 2
	note B_, 4
	note G#, 1
	note A_, 1
	note G#, 2
	note G_, 4
	note D#, 4
	note E_, 4
	octave 3
	note C_, 1
	octave 2
	note B_, 11
	note G#, 4
	octave 3
	note D_, 4
	note E_, 4
	note F#, 4
	note G#, 4
	intensity $57
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	note E_, 2
	note D_, 2
	note B_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	octave 4
	note C#, 2
	octave 3
	note E_, 2
	note F#, 2
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note B_, 2
	callchannel .sub
	note E_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note F#, 2
	octave 4
	note C#, 2
	octave 3
	note F#, 2
	note B_, 2
	note E_, 2
	note F#, 2
	note E_, 2
	note G#, 2
	note E_, 2
	note F#, 2
	note E_, 2
	note B_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	note B_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note F_, 2
	note A_, 2
	note F_, 2
	octave 4
	note D_, 2
	octave 3
	note F_, 2
	note G#, 2
	note F_, 2
	octave 4
	note C#, 2
	octave 3
	note E_, 2
	octave 4
	note D_, 2
	octave 3
	note E_, 2
	octave 4
	note C#, 2
	octave 3
	note E_, 2
	note B_, 2
	note E_, 2
	note A_, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note G#, 2
	callchannel .sub
	note C#, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note F#, 2
	octave 4
	note E_, 2
	octave 3
	note F#, 2
	octave 4
	note F#, 2
	octave 3
	note A_, 2
	note B_, 2
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note F#, 2
	octave 3
	note A_, 2
	intensity $87
	octave 4
	note G_, 1
	note G#, 7
	note F#, 4
	note E_, 4
	note A_, 8
	note G#, 8
	note E_, 4
	note F#, 4
	note E_, 4
	note D_, 4
	note C#, 16
	jumpchannel .loop

.sub
	note A_, 2
	note B_, 2
.repeat1
	octave 4
	note C#, 2
	octave 3
	note E_, 2
	note F#, 2
	note E_, 2
	loopchannel 2, .repeat1
.repeat2
	octave 4
	note E_, 2
	octave 3
	note G#, 2
	note A_, 2
	note G#, 2
	loopchannel 2, .repeat2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	endchannel

Music_HoennPokemonCenter_Ch2:
	dutycycle $2
	stereopanning $f0
	vibrato $12, $15
	tone $0001
	notetype $6, $92
	octave 5
	note C#, 4
	note E_, 4
	octave 4
	note A_, 4
	note G#, 4
	note F#, 4
	note G#, 4
	note A_, 4
	note B_, 4
.loop
	dutycycle $3
	intensity $77
	callchannel .sub
	octave 1
	note G#, 4
	note A_, 4
	note __, 8
	note A_, 2
	note E_, 2
	note A_, 2
	note E_, 2
	octave 2
	note C#, 4
	note __, 4
	note C#, 4
	callchannel .sub
	note D_, 4
	octave 1
	note A_, 2
	note A_, 2
	note __, 8
	note A_, 2
	note A_, 2
	note A_, 2
	note E_, 2
	octave 2
	note E_, 4
	note __, 4
	note E_, 2
	octave 1
	note G#, 2
	note A_, 10
	note __, 2
	note E_, 2
	note E_, 2
	octave 2
	note C#, 8
	note C#, 2
	note __, 2
	octave 1
	note A_, 2
	note __, 2
	octave 2
	note D_, 10
	note __, 2
	octave 1
	note A_, 2
	octave 2
	note D_, 2
	octave 1
	note E_, 2
	octave 2
	note E_, 1
	note __, 3
	octave 1
	note E_, 2
	note F#, 4
	note G_, 4
	note G#, 10
	note __, 2
	note E_, 2
	note E_, 2
	note B_, 8
	note G#, 8
	note A_, 10
	note __, 2
	note A_, 2
	note A_, 2
	octave 2
	note C#, 2
	note E_, 1
	note __, 3
	octave 1
	note E_, 2
	note F#, 4
	note G#, 4
	note A_, 10
	note __, 2
	note E_, 2
	note E_, 2
	octave 2
	note C#, 10
	note __, 2
	octave 1
	note A_, 2
	note A_, 2
	note B_, 10
	note __, 2
	note E_, 2
	note __, 2
	note D_, 2
	octave 2
	note D_, 1
	note __, 3
	octave 1
	note D_, 2
	note F#, 2
	note __, 2
	note A_, 2
	note __, 2
	note G#, 10
	note __, 2
	note E_, 2
	note __, 2
	note B_, 8
	note G#, 8
	note A_, 6
	note __, 6
	note A_, 2
	note E_, 2
	octave 2
	note C#, 2
	note E_, 1
	note __, 3
	octave 1
	note E_, 2
	note F#, 4
	note G#, 4
	jumpchannel .loop

.sub
	octave 1
	note A_, 4
	note __, 8
	note A_, 2
	note E_, 1
	note __, 5
	octave 2
	note E_, 4
	note __, 4
	octave 1
	note A_, 4
	note B_, 4
	note __, 8
	note B_, 2
	note E_, 1
	note __, 5
	octave 2
	note D_, 4
	note __, 4
	octave 1
	note E_, 2
	note F#, 2
	note B_, 4
	note __, 8
	note B_, 2
	note G#, 1
	note __, 5
	octave 2
	note D_, 4
	note __, 4
	endchannel

Music_HoennPokemonCenter_Ch3:
	notetype $6, $10
	octave 4
	note __, 16
	note __, 8
	note G#, 1
	note A_, 1
	note G#, 2
	note F#, 2
	note G#, 2
.loop
	note __, 11
	octave 5
	note D#, 1
	note E_, 2
	note __, 6
	note E_, 2
	note __, 2
	note D_, 1
	note E_, 1
	note D_, 3
	note C#, 1
	octave 4
	note A_, 2
	note B_, 2
	note __, 2
	note G#, 8
	note __, 12
	note F#, 2
	note __, 2
	note G_, 2
	note __, 13
	octave 5
	note C_, 1
	note C#, 2
	note __, 6
	octave 4
	note B_, 2
	note __, 6
	note G#, 2
	note __, 2
	note A_, 2
	note __, 2
	octave 5
	note C#, 8
	octave 4
	note E_, 2
	note __, 2
	note F#, 2
	note __, 2
	note G#, 3
	note A#, 1
	note A_, 2
	note G#, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note E_, 2
	note G#, 2
	note A_, 2
	octave 5
	note C#, 3
	octave 6
	note D#, 1
	note E_, 2
	note __, 6
	note D_, 2
	note __, 6
	note C#, 2
	note __, 2
	octave 5
	note B_, 2
	note __, 2
	note G#, 8
	octave 4
	note B_, 2
	note __, 2
	note G#, 2
	note __, 2
	note E_, 4
	octave 5
	note B_, 1
	octave 6
	note C#, 1
	octave 5
	note B_, 3
	note A#, 1
	note B_, 2
	note G#, 2
	note __, 6
	note G#, 3
	octave 6
	note C_, 1
	note C#, 2
	note __, 6
	octave 5
	note B_, 2
	note __, 6
	note G#, 2
	note __, 2
	octave 4
	note A_, 8
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 5
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 8
	note F_, 1
	note F#, 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 6
	note C_, 1
	note C#, 16
	note E_, 12
	note C_, 2
	note C#, 2
	note D_, 4
	note E_, 4
	note D_, 4
	note C#, 4
	octave 5
	note B_, 4
	note __, 2
	note G#, 2
	octave 6
	note C#, 1
	note D_, 1
	note C#, 3
	octave 5
	note B_, 1
	note A_, 2
	note B_, 2
	note E_, 2
	note __, 2
	note E_, 2
	note B_, 2
	note E_, 2
	note __, 2
	note E_, 2
	octave 6
	note D_, 2
	octave 5
	note A_, 2
	note __, 2
	note A_, 2
	octave 6
	note D_, 4
	octave 5
	note G#, 3
	octave 6
	note C_, 1
	note C#, 4
	note D_, 4
	note C#, 4
	octave 5
	note B_, 4
	note A_, 2
	note G#, 2
	note F#, 2
	note G#, 2
	octave 6
	note E_, 1
	note F#, 1
	note E_, 3
	note C#, 1
	octave 5
	note B_, 2
	note __, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note B_, 2
	octave 6
	note C#, 2
	note D_, 2
	note E_, 2
	octave 5
	note A_, 2
	note B_, 2
	octave 6
	note C#, 2
	note D_, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note E_, 2
	note D_, 2
	note C#, 2
	octave 5
	note B_, 2
	note A_, 2
	octave 6
	note F#, 2
	note E_, 2
	note D_, 2
	note C#, 2
	octave 5
	note B_, 2
	octave 6
	note C#, 2
	note D_, 2
	note F#, 2
	note D#, 1
	note E_, 7
	note D_, 4
	note C#, 4
	note D_, 16
	note C#, 4
	note D_, 4
	note C#, 4
	octave 5
	note B_, 4
	note A_, 8
	note G#, 1
	note A_, 1
	note G#, 3
	note F#, 1
	note G#, 2
	jumpchannel .loop

Music_HoennPokemonCenter_Ch4:
	stereopanning $f
	togglenoise $3
	notetype $6
	note G#, 4
	note G_, 2
	note G_, 2
	note G#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 1
	note G_, 1
	note G#, 4
	note G_, 2
	note G_, 1
	note G_, 1
	octave 3
	note F_, 2
	octave 4
	note G#, 2
.loop
	callchannel .sub1
	callchannel .sub2
	callchannel .sub2
	note G_, 4
	note G#, 4
	note G_, 4
	note G_, 4
	callchannel .sub1
	note G_, 2
	note G_, 1
	note G_, 1
	note G#, 4
	note G_, 2
	note G_, 2
	note G#, 4
	callchannel .sub1
	callchannel .sub2
	note G_, 2
	note G_, 1
	note G_, 1
	note G#, 4
	note G#, 4
	note G_, 2
	note G_, 2
	callchannel .sub1
	callchannel .sub2
	note G_, 4
	note G#, 4
	note G_, 2
	note G_, 1
	note G_, 1
	note G#, 2
	note G#, 2
.repeat1
	callchannel .sub1
	note G_, 2
	note G_, 2
	note G#, 4
	note G_, 2
	note G_, 2
	note G#, 4
	loopchannel 6, .repeat1
	note G#, 12
.repeat2
	note G_, 2
	loopchannel 6, .repeat2
	note G#, 4
	note G#, 4
	note G#, 16
	note G#, 4
	note G_, 2
	note G_, 2
	note G#, 4
	note G_, 2
	note G_, 2
	jumpchannel .loop

.sub2
	note G_, 4
	note G#, 4
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
.sub1
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 2
	note G#, 4
	note G_, 2
	note G_, 2
	endchannel
