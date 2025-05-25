Music_BugCatchingContest:
	channelcount 4
	channel 1, Music_BugCatchingContest_Ch1
	channel 2, Music_BugCatchingContest_Ch2
	channel 3, Music_BugCatchingContest_Ch3
	channel 4, Music_BugCatchingContest_Ch4

Music_BugCatchingContest_Ch1:
	tempo 144
	volume $77
	stereopanning $f
	vibrato $8, $24
	dutycycle $2
	notetype $6, $b7
	note __, 16
	octave 4
.loop
	note C#, 2
	note __, 2
	note C#, 6
	note __, 2
	note C#, 2
	note C#, 2
	note D_, 2
	note __, 2
	note D_, 6
	note __, 2
	note D_, 2
	note D_, 2
	note D#, 2
	note __, 2
	note D#, 6
	note __, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note __, 2
	note E_, 6
	note __, 2
	note E_, 2
	note E_, 2
	callchannel .sub1
.repeat1
	note __, 4
	note B_, 4
	loopchannel 8, .repeat1
	intensity $b4
	dutycycle $1
	octave 3
	note B_, 12
	note A_, 2
	note B_, 2
	note A_, 12
	octave 4
	note D_, 2
	note E_, 2
	dutycycle $2
	callchannel .sub1
	note __, 4
	note B_, 4
	note __, 4
	note B_, 4
	intensity $b7
	octave 4
	note E_, 4
	note __, 1
	octave 3
	note B_, 1
	octave 4
	note E_, 1
	note G_, 1
	note B_, 8
	octave 5
	note E_, 8
	intensity $b1
	note __, 4
	octave 2
	note B_, 4
	note __, 4
	octave 3
	note E_, 4
	note __, 4
	note E_, 4
	callchannel .sub2
	intensity $a7
	octave 4
	note F#, 4
	note A_, 4
	note __, 4
	octave 3
	note G_, 2
	note B_, 2
	octave 4
	note D_, 2
	note __, 2
	octave 3
	note B_, 2
	note G_, 2
	octave 4
.repeat2
	note G_, 1
	note A_, 1
	loopchannel 4, .repeat2
	note G_, 8
	note __, 4
	octave 3
	note F#, 2
	note A_, 2
	octave 4
	note D_, 2
	note __, 2
	octave 3
	note A_, 2
	note F#, 2
	octave 4
.repeat3
	note F#, 1
	note G_, 1
	loopchannel 4, .repeat3
	note F#, 8
	note D_, 2
	note __, 2
	octave 3
	note B_, 2
	note G_, 2
	octave 4
	note G_, 2
	note __, 2
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note B_, 2
	note __, 2
	note G#, 2
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	note G#, 2
	note B_, 2
	jumpchannel .loop

.sub1
	intensity $b1
	octave 2
	note __, 4
	note A_, 4
.sub2
	loopchannel 4, .sub1
	endchannel

Music_BugCatchingContest_Ch2:
	stereopanning $f0
	vibrato $8, $23
	dutycycle $1
	notetype $c, $c7
	note __, 8
.repeat
	octave 4
	note A_, 1
	note __, 1
	note A_, 3
	note __, 1
	note A_, 1
	note A_, 1
	loopchannel 4, .repeat
	dutycycle $0
.loop
	callchannel .sub
	note E_, 2
	octave 3
	note G_, 1
	note __, 1
	octave 2
	note G_, 2
	octave 3
	note G_, 1
	note __, 1
	octave 2
	note A_, 2
	octave 3
	note A_, 1
	note __, 1
	octave 2
	note G#, 2
	octave 3
	note G#, 1
	note __, 1
	octave 2
	note G_, 2
	octave 3
	note G_, 1
	note __, 1
	octave 2
	note E_, 2
	octave 3
	note E_, 1
	note __, 1
	callchannel .sub
	note A_, 2
	octave 4
	note C#, 1
	note __, 1
	octave 2
	note E_, 2
	octave 4
	note C#, 1
	note __, 1
	octave 2
	note D_, 2
	octave 3
	note F#, 1
	note __, 1
	octave 1
	note A_, 2
	octave 3
	note F#, 1
	note __, 1
	octave 1
	note B_, 2
	octave 3
	note F#, 1
	note __, 1
	octave 2
	note D#, 2
	octave 3
	note A_, 1
	note __, 3
	octave 5
	note D_, 1
	note __, 1
	note C#, 2
	note D_, 1
	note __, 1
	octave 4
	note B_, 8
	note __, 2
	octave 5
	note D_, 1
	note __, 1
	note C#, 2
	note D_, 1
	note __, 1
	octave 4
	note A_, 8
	note __, 2
	octave 5
	note D_, 4
	note F#, 2
	note E_, 2
	note D_, 1
	note __, 1
	note C#, 2
	note D_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 1
	note __, 3
	note E_, 10
	note A_, 1
	note __, 1
	note A_, 1
	note __, 3
	note A_, 10
	jumpchannel .loop

.sub
	octave 2
	note D_, 2
	octave 3
	note F#, 1
	note __, 1
	octave 1
	note A_, 2
	octave 3
	note F#, 1
	note __, 1
	octave 1
	note B_, 2
	octave 3
	note F#, 1
	note __, 1
	octave 2
	note C#, 2
	octave 3
	note F#, 1
	note __, 1
	octave 2
	note E_, 2
	octave 3
	note G_, 1
	note __, 1
	octave 1
	note B_, 2
	octave 3
	note G_, 1
	note __, 1
	octave 2
	note C#, 2
	octave 3
	note G_, 1
	note __, 1
	octave 2
	note D#, 2
	octave 3
	note G_, 1
	note __, 1
	octave 2
	note E_, 2
	octave 3
	note G_, 1
	note __, 1
	octave 1
	note B_, 2
	octave 3
	note G_, 1
	note __, 1
	octave 2
	endchannel

Music_BugCatchingContest_Ch3:
	stereopanning $ff
	vibrato $10, $23
	notetype $6, $14
	note __, 16
	octave 3
.loop
	note A_, 2
	note __, 2
	note A_, 6
	note __, 2
	note A_, 2
	note A_, 2
	note B_, 2
	note __, 2
	note B_, 6
	note __, 2
	note B_, 2
	note B_, 2
	octave 4
	note C_, 2
	note __, 2
	note C_, 6
	note __, 2
	note C_, 2
	note C_, 2
	note C#, 2
	note __, 2
	note C#, 6
	note __, 2
	note C#, 2
	note C#, 2
	intensity $14
	note F#, 10
	note __, 2
	note F#, 2
	note G_, 2
	note A_, 8
	octave 5
	note D_, 8
	note C#, 4
	intensity $10
	note E_, 2
	note G_, 2
	note B_, 2
	note __, 2
	note G_, 2
	note E_, 2
	intensity $20
	octave 6
.repeat1
	note E_, 1
	note F#, 1
	loopchannel 4, .repeat1
	note E_, 8
	intensity $14
	octave 4
	note E_, 10
	note __, 2
	note E_, 2
	note F#, 2
	note G_, 8
	octave 5
	note C#, 8
	note __, 4
	intensity $10
	note E_, 2
	note G_, 2
	note A_, 2
	note __, 2
	note E_, 2
	note C_, 2
	octave 6
.repeat2
	note C#, 1
	note D_, 1
	loopchannel 4, .repeat2
	note C#, 8
	intensity $15
	octave 5
	note F#, 4
	note __, 4
	note G_, 4
	note __, 4
	note A_, 4
	note __, 4
	octave 6
	note D_, 4
	note __, 4
	note C#, 12
	octave 5
	note B_, 2
	octave 6
	note C#, 2
	octave 5
	note B_, 4
	note __, 4
	octave 6
	note G_, 4
	note F#, 4
	note __, 4
	octave 5
	note G_, 4
	note A_, 4
	note B_, 4
	octave 6
	note E_, 4
	note D_, 4
	note C#, 4
	octave 5
	note B_, 2
	octave 6
	note C#, 2
	note D_, 4
	note __, 8
	octave 5
	note B_, 4
	note A_, 4
	note __, 1
	note D#, 1
	note F#, 1
	note A_, 1
	octave 6
	note C_, 8
	octave 3
	note G_, 2
	note __, 2
	note B_, 2
	note __, 2
	note D_, 2
	note __, 2
	note B_, 2
	note __, 2
	note E_, 2
	note __, 2
	note B_, 2
	note __, 2
	note G_, 2
	note __, 2
	note B_, 2
	note __, 2
	note D_, 2
	note __, 2
	note F#, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note F#, 2
	note __, 2
	note D#, 2
	note __, 2
	octave 4
	note C_, 2
	note __, 2
	octave 3
	note A_, 2
	note __, 2
	octave 4
	note C_, 2
	note __, 2
	octave 3
	note G_, 2
	note __, 2
	note B_, 2
	note __, 2
	note D_, 2
	note __, 2
	note B_, 2
	note __, 2
	note G#, 2
	note __, 2
	note B_, 2
	note __, 2
	note E_, 2
	note __, 2
	note B_, 2
	note __, 2
	jumpchannel .loop

Music_BugCatchingContest_Ch4:
	togglenoise $4
	notetype $6
.repeat1
	note C#, 1
	loopchannel 12, .repeat1
	note E_, 2
	note E_, 2
.loop
	note D_, 4
	note B_, 8
	note D_, 2
	note D_, 2
	loopchannel 4, .loop
.repeat2
	callchannel .sub
	callchannel .sub
	callchannel .sub
	note D_, 4
	note D_, 4
	rept 8
		note C#, 1
	endr
	loopchannel 5, .repeat2
.repeat3
	note D_, 4
	note D_, 4
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 2
	loopchannel 2, .repeat3
	jumpchannel .loop

.sub
	note D_, 4
	note D_, 4
	note D_, 2
	note C#, 2
	note D_, 2
	note C#, 2
	endchannel
