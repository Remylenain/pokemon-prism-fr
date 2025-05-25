Music_LavenderTown:
	channelcount 3
	channel 1, Music_LavenderTown_Ch1
	channel 2, Music_LavenderTown_Ch2
	channel 3, Music_LavenderTown_Ch3

Music_LavenderTown_Ch1:
	tempo 160
	volume $77
	stereopanning $f
	vibrato $6, $24
	dutycycle $0
	notetype $c, $83
	note __, 16
	note __, 16
	note __, 16
	note __, 16
.loop
	callchannel .sub1
	note F#, 2
	intensity $43
	note F#, 2
	intensity $93
	note B_, 2
	intensity $43
	note B_, 2
	intensity $93
	note A_, 2
	intensity $43
	note A_, 2
	callchannel .sub2
	note F_, 2
	intensity $83
	note F_, 2
	intensity $93
	note D_, 2
	intensity $43
	note D_, 2
	octave 4
	callchannel .sub3
	callchannel .sub1
	note G_, 2
	intensity $43
	note G_, 2
	callchannel .sub3
	callchannel .sub2
	octave 6
	note C_, 2
	intensity $43
	note C_, 2
	intensity $93
	octave 5
	note G_, 2
	intensity $43
	note G_, 2
	intensity $93
	note E_, 2
	intensity $43
	note E_, 2
	intensity $93
	note C_, 2
	intensity $43
	note C_, 2
	octave 3
	callchannel .sub4
.repeat
	octave 3
	note C_, 2
	note E_, 2
	note G_, 2
	note B_, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	note E_, 2
	note C_, 2
	callchannel .sub4
	loopchannel 2, .repeat
	note F#, 2
	note A_, 2
	octave 4
	note C_, 2
	note F#, 2
	note A_, 2
	note C_, 2
	octave 3
	note A_, 2
	note F#, 2
	note G_, 2
	octave 4
	note C_, 2
	note D_, 2
	note F_, 2
	note G_, 2
	note F_, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 8
	note B_, 8
	jumpchannel .loop

.sub1
	intensity $83
	octave 5
	note C_, 2
	intensity $43
	note C_, 2
	intensity $83
	note G_, 2
	intensity $43
	note G_, 2
	intensity $83
	octave 6
	note C_, 2
	intensity $43
	note C_, 2
	intensity $83
	octave 5
	note G_, 2
	intensity $43
	note G_, 2
	intensity $83
	note D_, 2
	intensity $43
	note D_, 2
	intensity $83
	note A_, 2
	intensity $43
	note A_, 2
	intensity $83
	octave 6
	note D_, 2
	intensity $43
	note D_, 2
	intensity $83
	octave 5
	note A_, 2
	intensity $43
	note A_, 2
	intensity $83
	note E_, 2
	intensity $43
	note E_, 2
	intensity $83
	note B_, 2
	intensity $43
	note B_, 2
	intensity $83
	octave 6
	note E_, 2
	intensity $43
	note E_, 2
	intensity $83
	octave 5
	note B_, 2
	intensity $43
	note B_, 2
	intensity $83
	note C#, 2
	intensity $43
	note C#, 2
	intensity $83
	note G_, 2
	intensity $43
	note G_, 2
	intensity $83
	note A#, 2
	intensity $43
	note A#, 2
	intensity $83
	note G_, 2
	intensity $43
	note G_, 2
	intensity $83
	note C_, 2
	intensity $43
	note C_, 2
	intensity $83
	note F_, 2
	intensity $43
	note F_, 2
	intensity $83
	octave 6
	note C_, 2
	intensity $43
	note C_, 2
	intensity $83
	octave 5
	note F_, 2
	intensity $43
	note F_, 2
	intensity $93
	octave 5
	note D_, 2
	intensity $43
	note D_, 2
	intensity $93
	endchannel

.sub2
	intensity $93
	octave 5
	note G_, 2
	intensity $83
	note G_, 2
	intensity $83
	note F_, 2
	intensity $43
	note F_, 2
	intensity $83
	note D_, 2
	intensity $43
	note D_, 2
	intensity $83
	note G_, 2
	intensity $43
	note G_, 2
	intensity $93
	endchannel

.sub3
	intensity $93
	note B_, 2
	intensity $43
	note B_, 2
	intensity $93
	note G_, 2
	intensity $43
	note G_, 2
	endchannel

.sub4
	note F_, 2
	note A_, 2
	octave 4
	note C_, 2
	note E_, 2
	note F_, 2
	note C_, 2
	octave 3
	note A_, 2
	note F_, 2
	endchannel

Music_LavenderTown_Ch2:
	dutycycle $1
	vibrato $8, $24
	stereopanning $ff
	notetype $c, $a3
	octave 5
	jumpchannel .skip
.repeat
	note F#, 2
	intensity $63
	note F#, 2
	intensity $a3
.skip
	note C_, 2
	intensity $63
	note C_, 2
	intensity $a3
	note G_, 2
	intensity $63
	note G_, 2
	intensity $a3
	note B_, 2
	intensity $63
	note B_, 2
	intensity $a3
	loopchannel 4, .repeat
	octave 6
	note D_, 2
	intensity $63
	note D_, 2
.loop
	intensity $b5
	callchannel .sub
	note F#, 4
	octave 3
	note C_, 4
	note F#, 4
	note A_, 4
	octave 2
	note G_, 4
	octave 3
	note C_, 4
	note D_, 4
	note G_, 4
	note F_, 4
	note D_, 4
	octave 2
	note B_, 4
	note G_, 4
	callchannel .sub
	note G_, 4
	octave 3
	note C_, 4
	note F_, 4
	note G_, 4
	note C_, 4
	note F_, 4
	note G_, 4
	note F_, 4
	note C_, 4
	note E_, 4
	note G_, 4
	octave 4
	note C_, 4
	intensity $b7
	octave 2
	note F_, 16
	note C_, 16
	note F_, 16
	note C_, 16
	note F_, 16
	note F#, 16
	note G_, 16
	octave 1
	note G_, 8
	intensity $57
	octave 5
	note D_, 1
	note F_, 1
	note G_, 6
	jumpchannel .loop

.sub
	octave 2
	note C_, 4
	note G_, 4
	octave 3
	note E_, 4
	octave 2
	note G_, 4
	note D_, 4
	note A_, 4
	octave 3
	note F_, 4
	octave 2
	note A_, 4
	note E_, 4
	note B_, 4
	octave 3
	note G_, 4
	note F_, 4
	note E_, 4
	note C#, 4
	octave 2
	note A#, 4
	note G_, 4
	note F_, 4
	octave 3
	note C_, 4
	note A_, 4
	note C_, 4
	octave 2
	endchannel

Music_LavenderTown_Ch3:
	vibrato $12, $24
	notetype $c, $13
	stereopanning $f0
	note __, 16
	note __, 16
	note __, 16
	note __, 8
	octave 5
	note E_, 4
	note F_, 4
.loop
	intensity $12
	octave 5
	note G_, 4
	note __, 4
	note G_, 4
	note __, 4
	note E_, 4
	note __, 4
	note E_, 4
	note F_, 4
	note G_, 4
	note F_, 4
	note E_, 4
	note B_, 4
	note C#, 8
	note __, 2
	note C#, 2
	note D_, 2
	note E_, 2
	note F_, 10
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 8
	octave 4
	note A_, 4
	octave 5
	note D_, 4
	note E_, 12
	note F_, 2
	note E_, 2
	note D_, 12
	note E_, 2
	note F_, 2
	note G_, 4
	note __, 4
	note G_, 4
	note __, 4
	note E_, 4
	note __, 4
	note E_, 4
	note F_, 4
	note G_, 4
	note F_, 4
	note E_, 4
	note B_, 4
	note C#, 8
	note __, 2
	note C#, 2
	note D_, 2
	note E_, 2
	note F_, 10
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 12
	note C_, 2
	note D_, 2
	note C_, 16
	note C_, 12
	note __, 4
	notetype $8, $24
	note A_, 3
	note G_, 3
	note A_, 3
	note B_, 3
	octave 6
	note C_, 6
	octave 5
	note G_, 6
	note F_, 6
	note E_, 6
	note D_, 6
	note C_, 6
	note A_, 3
	note G_, 3
	note A_, 3
	note B_, 3
	octave 6
	note C_, 6
	octave 5
	note G_, 6
	octave 6
	note F_, 6
	note E_, 2
	note F_, 2
	note E_, 2
	notetype $c, $24
	note D_, 4
	note C_, 4
	octave 5
	note A_, 2
	note G_, 2
	note A_, 2
	note B_, 2
	octave 6
	note C_, 4
	octave 5
	note G_, 4
	note A_, 2
	note G_, 2
	note A_, 2
	note B_, 2
	octave 6
	note C_, 4
	note C#, 4
	note D_, 12
	note C_, 4
	octave 5
	note B_, 12
	note E_, 2
	note F_, 2
	jumpchannel .loop
