Music_EternaForest:
	channelcount 4
	channel 1, Music_EternaForest_Ch1
	channel 2, Music_EternaForest_Ch2
	channel 3, Music_EternaForest_Ch3
	channel 4, Music_EternaForest_Ch4

Music_EternaForest_Ch1:
	tempo $88
	volume $77
	notetype $c, $82
	dutycycle 0
	stereopanning $f0
	octave 5
	note __, 1
.loop
	callchannel .sub
	note B_, 8
	note __, 1
	intensity $82
	callchannel .sub
	note B_, 7
	intensity $82
	octave 4
	callchannel .sub
	note B_, 9
	intensity $82
	octave 5
	note F#, 5
	intensity $72
	note F#, 6
	intensity $62
	note F#, 6
	intensity $52
	note F#, 6
	intensity $42
	note F#, 9
	intensity $82
	octave 4
	note F#, 5
	intensity $72
	note F#, 6
	intensity $62
	note F#, 6
	intensity $82
	note D_, 6
	intensity $72
	note D_, 4
	intensity $82
	note C_, 16
	dutycycle 1
	note __, 16
	note __, 12
	octave 6
	note C_, 2
	octave 5
	note F#, 2
	octave 6
	note C_, 12
	octave 5
	note F#, 2
	note C_, 2
	note F#, 14
	octave 4
	note B_, 2
	octave 5
	note D_, 10
	octave 3
	note B_, 4
	note A_, 2
	note B_, 2
	octave 4
	note F#, 8
	octave 3
	note B_, 4
	note F#, 2
	octave 4
	note D_, 6
	octave 3
	note G_, 2
	octave 4
	note D_, 6
	octave 3
	note A_, 2
	octave 4
	note D_, 16
	note __, 16
	note __, 2
	octave 6
	note D_, 2
	octave 5
	note G_, 2
	notetype $f, $82
	note B_, 16
	notetype $c, $82
	octave 6
	note D_, 2
	octave 5
	note F#, 2
	notetype $f, $82
	note A_, 16
	notetype $c, $82
	octave 6
	note D_, 2
	octave 5
	note G_, 2
	note D_, 4
	octave 3
	note B_, 2
	octave 4
	note B_, 2
	octave 3
	note A_, 2
	note B_, 2
	octave 4
	note F#, 8
	octave 3
	note B_, 2
	octave 4
	note B_, 2
	octave 3
	note F#, 2
	octave 4
	note F#, 2
	octave 5
	note F#, 4
	octave 3
	note G_, 2
	octave 4
	note G_, 2
	octave 5
	note G_, 4
	octave 4
	note D_, 2
	octave 5
	note D_, 2
	octave 6
	note D_, 8
	octave 4
	note G_, 2
	octave 5
	note C_, 2
	note G_, 2
	octave 4
	note G_, 2
	octave 6
	note C_, 2
	note G_, 2
	note F#, 2
	note G_, 2
	note D_, 2
	octave 4
	note G_, 4
	octave 5
	note D_, 2
	note G_, 8
	octave 4
	note G_, 2
	note B_, 2
	octave 5
	note G_, 2
	octave 4
	note G_, 2
	octave 5
	note B_, 2
	octave 6
	note G_, 2
	note F#, 2
	note G_, 2
	note D_, 2
	octave 4
	note G_, 4
	octave 5
	note D_, 2
	note G_, 6
	note B_, 4
	note G_, 4
	note A_, 2
	note D_, 6
	octave 4
	note B_, 4
	note G_, 4
	note A_, 2
	octave 5
	note D_, 2
	note E_, 16
	note __, 6
	note F#, 4
	note G_, 2
	note F#, 4
	note D_, 16
	note __, 6
	note A_, 4
	note B_, 2
	note A_, 4
	note E_, 16
	note __, 16
	note __, 2
	octave 6
	note D_, 2
	note C_, 2
	octave 5
	note G_, 2
	note E_, 2
	note C_, 2
	octave 4
	note B_, 2
	note G_, 2
	note C_, 2
	octave 6
	note D#, 2
	note C_, 2
	octave 5
	note A_, 2
	note F#, 2
	note D#, 2
	note C_, 2
	octave 4
	note A_, 2
	note D#, 3
	dutycycle 0
	octave 5
.repeat
	callchannel .sub
	note B_, 9
	intensity $82
	loopchannel 3, .repeat
	jumpchannel .loop

.sub
	note B_, 5
	intensity $72
	note B_, 6
	intensity $62
	note B_, 6
	intensity $52
	note B_, 6
	intensity $42
	endchannel

Music_EternaForest_Ch2:
	notetype $c, $92
	dutycycle 0
	stereopanning $f
	octave 5
	note D_, 6
	intensity $82
	note D_, 6
	intensity $72
	note D_, 6
	intensity $62
	note D_, 6
	intensity $52
	note D_, 8
.loop
	callchannel .sub1
	note E_, 6
	octave 4
	callchannel .sub1
	note E_, 8
	intensity $92
	note B_, 6
	intensity $82
	note B_, 6
	intensity $72
	note B_, 6
	intensity $62
	note B_, 6
	intensity $52
	note B_, 8
	intensity $92
	octave 3
	note B_, 6
	intensity $82
	note B_, 6
	intensity $72
	note B_, 6
	intensity $62
	note G_, 6
	intensity $52
	note G_, 4
	intensity $92
	note F#, 6
	intensity $B6
	dutycycle 2
	octave 2
	note C_, 2
	note __, 4
	octave 1
	note C_, 2
	note __, 16
	note __, 8
	octave 2
	note C_, 2
	note __, 4
	octave 1
	note C_, 2
	note __, 16
	note __, 8
	note G_, 2
	note __, 4
	octave 1
	note G_, 2
	note __, 16
	note __, 16
	note __, 8
	octave 1
	note E_, 2
	note __, 6
	note D_, 2
	note __, 6
	octave 2
	note C_, 2
	note __, 4
	octave 1
	note C_, 2
	note __, 16
	note __, 8
	octave 2
	note C_, 2
	note __, 4
	octave 1
	note C_, 2
	note __, 16
	note __, 8
	note G_, 2
	note __, 4
	octave 1
	note G_, 2
	note __, 16
	note __, 16
	note __, 8
	octave 1
	note E_, 2
	note __, 6
	note D_, 2
	note __, 6
	octave 1
	note A_, 2
	note __, 4
	note A_, 2
	note __, 2
	note A_, 2
	note __, 1
	note A_, 2
	note __, 1
	note B_, 2
	note __, 4
	note B_, 2
	note __, 2
	note B_, 2
	note __, 1
	note B_, 2
	note __, 1
	octave 1
	note E_, 2
	note __, 4
	note E_, 2
	note __, 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note D_, 2
	note __, 4
	note D_, 2
	note __, 2
	note D_, 2
	note __, 1
	note D_, 2
	note __, 1
	octave 1
	note A_, 2
	note __, 6
	note B_, 2
	note __, 6
	note A_, 2
	note __, 2
	note B_, 2
	note __, 2
	octave 1
	note C_, 2
	note D_, 2
	note __, 2
	note C_, 16
	note __, 16
	note __, 2
	octave 1
	note B_, 16
	note __, 16
	note __, 4
	octave 1
	note A_, 4
	octave 2
	note C_, 4
	octave 1
	note A_, 4
	note B_, 4
	octave 2
	note D_, 4
	note F#, 4
	note A_, 4
	octave 3
	note C_, 6
	octave 2
	note C_, 6
	octave 3
	note C_, 4
	octave 4
	note C_, 6
	octave 3
	note C_, 10
	intensity $92
	dutycycle 0
	octave 5
	callchannel .sub2
	octave 4
	callchannel .sub2
	octave 5
	callchannel .sub2
	octave 4
	note G_, 6
	intensity $82
	note G_, 6
	intensity $72
	note G_, 6
	intensity $62
	note G_, 6
	intensity $52
	note G_, 8
	jumpchannel .loop

.sub1
	intensity $92
	note E_, 6
	intensity $82
	note E_, 6
	intensity $72
	note E_, 6
	intensity $62
	note E_, 6
	intensity $52
	endchannel

.sub2
	note C_, 6
	intensity $82
	note C_, 6
	intensity $72
	note C_, 6
	intensity $62
	note C_, 6
	intensity $52
	note C_, 8
	intensity $92
	endchannel

Music_EternaForest_Ch3:
	notetype $c, $12
	vibrato $10, $14
	note __, 16
	note __, 16
.loop
	octave 5
	note __, 16
	note B_, 2
	octave 6
	note C_, 2
	note __, 2
	callchannel .sub
	note __, 4
	octave 5
	note B_, 2
	octave 6
	note C_, 2
	note __, 2
	callchannel .sub
	octave 5
	note E_, 2
	note F#, 2
	note G_, 2
	note B_, 2
	note __, 2
	note A_, 2
	octave 6
	note D_, 2
	note C_, 2
	note __, 2
	octave 5
	note B_, 2
	note F#, 2
	note __, 2
	note G_, 2
	note A_, 2
	note __, 2
	note B_, 2
	note __, 2
	octave 6
	note C_, 2
	octave 5
	note B_, 2
	octave 6
	note C_, 2
	note __, 2
	note D_, 2
	note __, 2
	note A_, 2
	note F#, 2
	note G_, 2
	note A_, 2
	note G_, 2
	note __, 2
	note D_, 2
	note __, 2
	octave 5
	note B_, 2
	note __, 16
	note __, 16
	note __, 16
	note __, 4
	octave 4
	note G_, 8
	octave 5
	note C_, 4
	octave 4
	note B_, 8
	octave 5
	note D_, 4
	note A_, 4
	note G_, 12
	octave 4
	note B_, 4
	octave 5
	note D_, 8
	note G_, 4
	note A_, 4
	note G_, 8
	note E_, 4
	note F#, 4
	note G_, 4
	note A_, 4
	note B_, 4
	octave 6
	note C_, 2
	note D_, 4
	note E_, 2
	notetype $8, $12
	note F#, 4
	note G_, 4
	note F#, 4
	note D_, 4
	octave 5
	note B_, 4
	octave 6
	note E_, 4
	notetype $c, $12
	octave 5
	note G_, 16
	notetype $8, $12
	note A_, 4
	note B_, 4
	note A_, 4
	note G_, 4
	note E_, 4
	note A_, 4
	notetype $c, $12
	note D_, 12
	note A_, 4
	note G_, 8
	note E_, 4
	note A_, 8
	note G_, 4
	note B_, 4
	note A_, 4
	octave 6
	note D_, 16
	note C_, 16
	note C_, 8
	octave 5
	note C_, 2
	octave 6
	note F#, 2
	note F#, 2
	octave 5
	note C_, 2
	octave 6
	note A_, 2
	note B_, 4
	note __, 16
	note __, 2
	octave 4
	note G_, 2
	octave 6
	note D_, 2
	note D_, 2
	octave 4
	note G_, 2
	octave 6
	note A_, 2
	note B_, 4
	note __, 16
	note __, 2
	octave 5
	note C_, 2
	octave 6
	note F#, 2
	note F#, 2
	octave 5
	note C_, 2
	octave 6
	note A_, 2
	note B_, 2
	octave 7
	note D_, 2
	note __, 16
	note __, 2
	octave 4
	note G_, 2
	octave 6
	note D_, 2
	note D_, 2
	octave 4
	note G_, 2
	octave 6
	note A_, 2
	note B_, 2
	octave 7
	note D_, 2
	note __, 10
	jumpchannel .loop

.sub
	octave 5
	note B_, 2
	note A_, 2
	note B_, 2
	note __, 2
	octave 6
	note C_, 2
	octave 5
	note B_, 2
	note __, 2
	note F#, 2
	note G_, 2
	note __, 2
	note A_, 2
	note __, 2
	note G_, 2
	note F#, 2
	note G_, 2
	note __, 2
	note A_, 2
	note G_, 2
	note __, 2
	note E_, 2
	note G_, 2
	note F#, 2
	note G_, 2
	note __, 2
	note F#, 2
	note D_, 2
	note __, 2
	octave 4
	note B_, 2
	note __, 16
	note __, 16
	note __, 16
	note __, 14
	endchannel

Music_EternaForest_Ch4:
	togglenoise 4
	notetype $c
.loop
	note __, 16
	loopchannel 10, .loop
.repeat1
	note F#, 2
	note G#, 2
	note G#, 2
	note G#, 2
	loopchannel 32, .repeat1
.repeat2
	note D#, 2
	note F#, 1
	note D#, 1
	note C_, 2
	note D#, 2
	note F#, 2
	note D#, 2
	note C_, 1
	note D#, 1
	note F#, 2
	loopchannel 4, .repeat2
	note D#, 2
	note D#, 2
	note C_, 1
	note D#, 2
	note C_, 1
	note D#, 2
	note D#, 2
	note C_, 1
	note D#, 2
	note C_, 1
	note D#, 2
	note D#, 2
	note C_, 1
	note C_, 2
	note C_, 1
	note C_, 2
	note C_, 2
	note C_, 1
	note D#, 2
	note C_, 1
	note F#, 16
.repeat3
	note __, 16
	loopchannel 13, .repeat3
	jumpchannel .loop
