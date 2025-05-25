Music_PaletteBattle:
	channelcount 3
	channel 1, Music_PaletteBattle_Ch1
	channel 2, Music_PaletteBattle_Ch2
	channel 3, Music_PaletteBattle_Ch3

Music_PaletteBattle_Ch1:
	tempo 96
	volume $77
	dutycycle $3
	tone $0002
	vibrato $10, $12
	notetype $c, $b2
	octave 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 2
	note C_, 1
	octave 1
	note B_, 1
	octave 2
	note C_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note F_, 1
	note F#, 1
	note G_, 1
	note G#, 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 3
	note C_, 1

.loop
	stereopanning $f0
	note E_, 4
	octave 2
	note G_, 2
	note B_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	note E_, 2
	note B_, 2
	note G_, 4
	octave 3
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note F_, 2
	note G_, 2
	note D_, 4
	octave 1
	note B_, 4
	octave 2
	note G_, 4
	note D_, 4
	octave 1
	note G_, 4
	note D_, 4
	note B_, 4
	note G_, 4
	octave 2
	note G_, 4
	octave 3
	note E_, 2
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	note B_, 4
	octave 3
	note C_, 2
	note D_, 2
	note E_, 2
	note G_, 2
	note G_, 2
	note F_, 2
	note D_, 4
	octave 2
	note B_, 4
	octave 3
	note G_, 4
	note D_, 4
	octave 2
	note B_, 4
	note G_, 4
	octave 3
	note D_, 4
	octave 2
	note G_, 2
	note G_, 2
	octave 3
	note C_, 4
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	note G_, 2
	octave 3
	note D_, 2
	note C_, 2
	octave 2
	note B_, 4
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	note G_, 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note D_, 4
	octave 2
	note B_, 4
	octave 3
	note G_, 4
	note D_, 4
	octave 2
	note B_, 4
	note G_, 4
	octave 3
	note D_, 4
	octave 2
	note B_, 4
	octave 3
	note G_, 4
	note G_, 2
	note F_, 2
	note E_, 2
	octave 2
	note G_, 2
	note G_, 2
	note B_, 2
	octave 3
	note C_, 4
	note D_, 2
	note C_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	octave 2
	note B_, 2
	note G_, 2
	note G_, 4
	note E_, 4
	note C_, 4
	octave 1
	note G_, 4
	octave 2
	note C_, 4
	octave 1
	note G_, 4
	note E_, 4
	note C_, 4
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	octave 3
.repeat1
	note G#, 2
	note G#, 2
	note C#, 2
	note G#, 2
	note G#, 2
	note C#, 2
	note G#, 2
	note C#, 2
	loopchannel 2, .repeat1
.repeat2
	note D#, 2
	note D#, 2
	octave 2
	note G#, 2
	octave 3
	note D#, 2
	note D#, 2
	octave 2
	note G#, 2
	octave 3
	note D#, 2
	octave 2
	note G#, 2
	octave 3
	loopchannel 2, .repeat2
.repeat3
	note F_, 2
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	loopchannel 2, .repeat3
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F#, 2
	note F#, 2
	note C_, 2
	note F#, 2
	note F#, 2
	note C_, 2
	note F#, 2
	note C_, 2
	note G#, 2
	note G#, 2
	note C#, 2
	note G#, 2
	note G#, 2
	note C#, 2
	note G#, 2
	note C#, 2
.repeat4
	note D#, 2
	note D#, 2
	octave 2
	note A#, 2
	octave 3
	loopchannel 2, .repeat4
	note D#, 2
	octave 2
	note A#, 2
	intensity $b8
	note G_, 16
	note G_, 16
	note D_, 16
	note D_, 16
	note G_, 16
	note G_, 16
	note D_, 16
	note D_, 16
	intensity $b2
	octave 3
	jumpchannel .loop

Music_PaletteBattle_Ch2:
	dutycycle $3
	tone $0001
	vibrato $8, $36
	notetype $c, $c2
	octave 5
	note C#, 1
	note C_, 1
	octave 4
	note A#, 1
	note A_, 1
	note A#, 1
	note A#, 1
	note G#, 1
	note G_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1

.main_loop
	stereopanning $f
	note G_, 4
	note C_, 2
	note D_, 2
	note E_, 2
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note D_, 2
	note C_, 4
	note F_, 2
	note E_, 2
	note D_, 2
	note G_, 2
	octave 2
	note A_, 2
	note B_, 2
	intensity $c7
	note G_, 16
	note __, 16
	octave 3
	intensity $c2
	note C_, 4
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	note D_, 4
	note E_, 2
	note F_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	intensity $c7
	note G_, 16
	note __, 12
	intensity $c2
	note D_, 2
	note D_, 2
	note E_, 4
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note F_, 2
	note E_, 2
	note D_, 4
	note E_, 2
	note C_, 2
	octave 2
	note B_, 2
	octave 3
	note D_, 2
	note E_, 2
	note F_, 2
	intensity $c7
	note G_, 16
	note __, 16
	octave 4
	intensity $c2
	note C_, 4
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note D_, 2
	note E_, 4
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 2
	note D_, 2
	octave 2
	note B_, 2
	octave 3
	intensity $c7
	note C_, 16
	note __, 16
.repeat1
	octave 4
	intensity $c2
	note C#, 2
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note C#, 2
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	loopchannel 2, .repeat1
.repeat2
	note G#, 2
	note G#, 2
	note D#, 2
	note G#, 2
	note G#, 2
	note D#, 2
	note G#, 2
	note D#, 2
	loopchannel 2, .repeat2
.repeat3
	octave 4
	note C#, 2
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note C#, 2
	note C#, 2
	octave 3
	note G#, 2
	octave 4
	note C#, 2
	octave 3
	note G#, 2
	loopchannel 2, .repeat3
.repeat4
	note G#, 2
	note G#, 2
	note D#, 2
	note G#, 2
	note G#, 2
	note D#, 2
	note G#, 2
	note D#, 2
	loopchannel 2, .repeat4
	note A#, 2
	note A#, 2
	note F_, 2
	note A#, 2
	note A#, 2
	note F_, 2
	note A#, 2
	note F_, 2
	note B_, 2
	note B_, 2
	note F#, 2
	note B_, 2
	note B_, 2
	note F#, 2
	note B_, 2
	note F#, 2
.repeat5
	octave 4
	note C#, 2
	note C#, 2
	octave 3
	note G#, 2
	loopchannel 2, .repeat5
	octave 4
	note C#, 2
	octave 3
	note G#, 2
.repeat6
	octave 4
	note D#, 2
	note D#, 2
	octave 3
	note A#, 2
	loopchannel 2, .repeat6
	octave 4
	note D#, 2
	octave 3
	note A#, 2
.repeat7
	intensity $c8
	note C_, 16
	note C_, 16
	octave 2
	note G_, 16
	note G_, 16
	octave 3
	loopchannel 2, .repeat7
	intensity $c2
	jumpchannel .main_loop

Music_PaletteBattle_Ch3:
	notetype $c, $19
	note __, 16
	note __, 16
	octave 3

.main_loop
	rept 3
.first\@
		note C_, 2
		note G_, 2
		loopchannel 8, .first\@
.second\@
		octave 2
		note G_, 2
		octave 3
		note D_, 2
		loopchannel 8, .second\@
	endr

.repeat1
	note C_, 2
	note G_, 2
	loopchannel 16, .repeat1

	rept 2
.first\@
		note C#, 2
		note G#, 2
		loopchannel 8, .first\@
.second\@
		octave 2
		note G#, 2
		octave 3
		note D#, 2
		loopchannel 8, .second\@
	endr

.repeat2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	loopchannel 4, .repeat2
.repeat3
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	loopchannel 4, .repeat3
.repeat4
	note C#, 2
	note G#, 2
	loopchannel 4, .repeat4
.repeat5
	note D#, 2
	note A#, 2
	loopchannel 4, .repeat5

	rept 2
.first\@
		note C_, 2
		note G_, 2
		loopchannel 8, .first\@
.second\@
		octave 2
		note G_, 2
		octave 3
		note D_, 2
		loopchannel 8, .second\@
	endr

	jumpchannel .main_loop
