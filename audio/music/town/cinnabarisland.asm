Music_CinnabarIsland:
	channelcount 4
	channel 1, Music_CinnabarIsland_Ch1
	channel 2, Music_CinnabarIsland_Ch2
	channel 3, Music_CinnabarIsland_Ch3
	channel 4, Music_CinnabarIsland_Ch4

Music_CinnabarIsland_Ch1:
	tempo 144
	volume 119
	dutycycle 2
	stereopanning $f0
.loop
	notetype 12, $b5
	note __, 4
	octave 3
	note D_, 4
	note E_, 6
	note C#, 2
	intensity $b1
	note D_, 4
	intensity $b5
	note B_, 4
	octave 4
	note C_, 6
	octave 3
	note A_, 2
	intensity $b1
	note B_, 4
	intensity $b5
	note G_, 4
	note F#, 4
	note E_, 2
	note F#, 2
	intensity $b1
	note G_, 4
	intensity $b5
	note G_, 4
	note F#, 4
	note E_, 4
	note D_, 4
	note E_, 4
	note F#, 6
	note A_, 2
	intensity $b1
	note G_, 4
	intensity $b5
	note B_, 4
	octave 4
	note C_, 6
	octave 3
	note A_, 2
	note B_, 4
	note G_, 4
	note F#, 3
	note E_, 1
	note F#, 2
	note A_, 2
	intensity $a2
	note G_, 4
	octave 4
	note D_, 1
	note E_, 1
	note D_, 4
	intensity $72
	note D_, 1
	note E_, 1
	note D_, 4
	intensity $a7
	octave 3
	note B_, 6
	note G_, 2
	note E_, 8
	octave 4
	note C_, 6
	octave 3
	note A_, 2
	note F#, 8
	octave 4
	note F#, 6
	note D_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note G_, 8
	note F#, 4
	note E_, 4
	jumpchannel .loop

Music_CinnabarIsland_Ch2:
	stereopanning $f
	vibrato 12, $34
.loop
	sound_duty 2, 2, 2, 2
	notetype 12, $c2
	octave 3
	callchannel .sub
	note B_, 8
	note A_, 4
	callchannel .sub
	note A_, 4
	note G_, 4
	note F#, 4
	intensity $b0
	sound_duty 2, 2, 0, 0
	octave 4
	note D_, 6
	octave 3
	note B_, 2
	note G_, 8
	octave 4
	note E_, 6
	note C_, 2
	octave 3
	note A_, 8
	octave 4
	note A_, 6
	note F#, 2
	note D_, 2
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note B_, 4
	octave 4
	note D_, 4
	octave 3
	note B_, 2
	note A_, 6
	jumpchannel .loop

.sub
	note G_, 6
	note A_, 1
	note B_, 1
	octave 4
	note C_, 6
	note D_, 1
	note E_, 1
	intensity $c1
	note D_, 4
	intensity $c7
	note G_, 4
	note A_, 6
	note G_, 1
	note F#, 1
	note E_, 4
	note D_, 4
	note C_, 3
	octave 3
	note B_, 1
	octave 4
	note C_, 2
	note D_, 1
	note E_, 1
	intensity $c1
	note D_, 4
	intensity $c7
	octave 3
	endchannel

Music_CinnabarIsland_Ch3:
	notetype 6, $25
	vibrato 12, $24
.loop
	octave 2
.repeat1
	callchannel .sub
	note F#, 1
	note __, 1
	loopchannel 3, .repeat1
	callchannel .sub
	note A_, 1
	note __, 1
.repeat2
	callchannel .sub
	note F#, 1
	note __, 1
	loopchannel 3, .repeat2
	note G_, 1
	note __, 3
	note B_, 4
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 3
	note C_, 4
	octave 2
	note B_, 1
	note __, 3
	octave 3
	note D_, 2
	octave 2
	note B_, 1
	note B_, 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	octave 3
	note C_, 2
	octave 2
	note B_, 1
	note __, 1
	note G_, 1
	note __, 3
	octave 3
	note E_, 2
	note C_, 1
	note C_, 1
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note E_, 2
	note C_, 1
	note __, 1
	octave 2
	note A_, 1
	note __, 3
	octave 3
	note A_, 2
	note F#, 1
	note F#, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 2
	note C_, 1
	note __, 1
	octave 2
	note B_, 1
	note __, 3
	octave 3
	note D_, 2
	note C_, 1
	note C_, 1
	octave 2
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note A_, 2
	octave 3
	note C_, 1
	note __, 1
	jumpchannel .loop

.sub
	note G_, 1
	note __, 3
	note B_, 2
	note G_, 1
	note G_, 1
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 3
	note C_, 2
	octave 2
	endchannel

Music_CinnabarIsland_Ch4:
	notetype $c
	togglenoise 0
.loop
	callchannel .sub1
	note A#, 4
	note A_, 4
	callchannel .sub2
	note A_, 4
	note A#, 4
	callchannel .sub2
	note A#, 4
	note A_, 4
	callchannel .sub2
	note A_, 4
	note A#, 4
	note A_, 4
	note A#, 4
.repeat1
	note F_, 2
	note G_, 2
	loopchannel 12, .repeat1
.repeat2
	note F_, 2
	note G_, 1
	note G_, 1
	loopchannel 4, .repeat2
	jumpchannel .loop

.subrepeat
	note A#, 2
	note G_, 1
	note G_, 1
	note D_, 2
	note G_, 1
	note G_, 1
.sub2
	note A_, 2
	note G_, 1
	note G_, 1
	note D_, 2
	note G_, 1
	note G_, 1
.sub1
	loopchannel 2, .subrepeat
	endchannel
