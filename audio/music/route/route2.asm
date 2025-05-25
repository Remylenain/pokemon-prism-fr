Music_Route2:
	channelcount 4
	channel 1, Music_Route2_Ch1
	channel 2, Music_Route2_Ch2
	channel 3, Music_Route2_Ch3
	channel 4, Music_Route2_Ch4

Music_Route2_Ch1:
	tempo 151
	volume $77
	stereopanning $f
	vibrato $6, $23
	notetype $c, $b1
	note __, 16
	note __, 16
	callchannel .sub1
.loop
	octave 3
	note B_, 4
	note B_, 4
	note B_, 4
	note B_, 4
	octave 4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	callchannel .sub1
	callchannel .sub2
	callchannel .sub2
	callchannel .sub3
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	note F_, 2
	note D_, 2
	octave 3
	note B_, 2
	note G_, 2
	callchannel .sub3
	note D_, 2
	note G_, 2
	note F_, 2
	note D_, 2
	octave 3
	note B_, 2
	note G_, 2
	jumpchannel .loop

.sub1
	octave 4
	note C_, 4
	note C_, 4
	note C_, 4
	note C_, 4
	note C_, 4
	note C_, 4
	intensity $b7
	note C_, 4
	octave 3
	note B_, 4
	intensity $b1
	endchannel

.sub2
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	loopchannel 4, .sub2
.repeat1
	note E_, 2
	note A#, 2
	loopchannel 4, .repeat1
.repeat2
	note C_, 2
	note A_, 2
	loopchannel 4, .repeat2
	note C_, 2
	note G#, 2
	note C_, 2
	note G#, 2
	intensity $b7
	octave 2
	note B_, 2
	octave 3
	note G#, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	intensity $b1
	endchannel

.sub3
	note B_, 2
	note G_, 2
	note B_, 2
	note G_, 2
	note B_, 2
	note G#, 2
	note B_, 2
	note G#, 2
	octave 4
	note E_, 2
	note C_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
.repeat3
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	loopchannel 4, .repeat3
	note G_, 2
	octave 4
	note C_, 2
	endchannel

Music_Route2_Ch2:
	stereopanning $ff
	vibrato $8, $24
	callchannel .sub
.loop
	callchannel .sub
	dutycycle $2
	intensity $b5
	octave 2
.repeat1
	callchannel Music_Route2_Common_1
	callchannel Music_Route2_Common_2
	note D_, 4
	loopchannel 2, .repeat1
.repeat2
	note E_, 4
	note __, 2
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 2
	note __, 2
	note E_, 1
	note __, 1
	note A_, 4
	note __, 2
	note A_, 1
	note __, 1
	note G#, 1
	note __, 1
	note G#, 2
	note __, 2
	note G#, 1
	note __, 1
	note F_, 4
	note __, 2
	note F_, 1
	note __, 1
	note F#, 1
	note __, 1
	note F#, 2
	note __, 2
	note F#, 1
	callchannel Music_Route2_Common_3
	loopchannel 2, .repeat2
	jumpchannel .loop

.sub
	notetype $c, $b2
	octave 4
	note E_, 4
	note E_, 4
	note E_, 2
	octave 2
	note C_, 2
	octave 4
	note E_, 2
	octave 2
	note C_, 2
	octave 4
	note A#, 4
	note A#, 4
	note A#, 2
	octave 2
	note G_, 2
	octave 4
	note A#, 2
	octave 2
	note G_, 2
	octave 4
	note A_, 4
	note A_, 4
	note A_, 4
	note A_, 4
	note G#, 4
	note G#, 4
	intensity $b7
	note G#, 4
	note G_, 4
	endchannel

Music_Route2_Ch3:
	stereopanning $f0
	vibrato $16, $15
	notetype $c, $14
	octave 4
.repeat1
	note B_, 1
	note __, 3
	loopchannel 4, .repeat1
	octave 5
.repeat2
	note E_, 1
	note __, 3
	loopchannel 4, .repeat2
	octave 3
	callchannel Music_Route2_Common_2
	note D_, 4
.loop
	notetype $c, $15
	octave 3
	callchannel Music_Route2_Common_1
	callchannel Music_Route2_Common_2
	note D_, 2
	intensity $10
	octave 6
	note C_, 1
	note D_, 1
	callchannel .sub1
	note __, 4
	note G_, 8
	note F_, 2
	note G_, 2
	notetype $c, $10
	callchannel .sub1
	note __, 16
	intensity $25
	callchannel .sub2
	note D#, 1
	note E_, 7
	note D_, 4
	octave 5
	note B_, 1
	octave 6
	note C_, 3
	octave 5
	note B_, 4
	note A_, 4
	note B_, 8
	note G_, 4
	octave 6
	note A_, 4
	note G_, 4
	callchannel .sub2
	note G#, 1
	note A_, 7
	note B_, 4
	note F#, 1
	note G_, 16
	note G_, 15
	jumpchannel .loop

.sub1
	octave 6
	note E_, 10
	note D_, 2
	note __, 2
	note C_, 2
	notetype $6, $10
	octave 5
	note F#, 1
	note G_, 15
	note A_, 4
	note A#, 4
	note __, 4
	octave 6
	note C_, 2
	note D_, 2
	note D#, 1
	note E_, 16
	note E_, 7
	note F_, 4
	note E_, 4
	note D#, 1
	note E_, 3
	note D_, 4
	note C_, 4
	note D_, 4
	endchannel

.sub2
	octave 5
	note B_, 16
	note __, 4
	octave 6
	note C#, 1
	note D_, 7
	note E_, 4
	octave 5
	note B_, 1
	octave 6
	note C_, 16
	note C_, 3
	note D_, 4
	note __, 4
	note E_, 4
	note F_, 16
	note __, 4
	endchannel

Music_Route2_Common_1:
	note C_, 4
	note __, 2
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note C_, 2
	note __, 2
	note C_, 1
Music_Route2_Common_3:
	note __, 1
	note G_, 4
	note __, 2
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 2
	note __, 2
	note G_, 1
	note __, 1
	endchannel

Music_Route2_Common_2:
	note F_, 4
	note __, 2
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 2
	note __, 2
	note F_, 1
	note __, 1
	note F_, 4
	note __, 2
	note F_, 1
	note __, 1
	note F_, 4
	endchannel

Music_Route2_Ch4:
	togglenoise $5
	notetype $c
.repeat1
	note A_, 4
	note A_, 4
	note A_, 2
	note B_, 2
	note A_, 2
	note B_, 2
	loopchannel 3, .repeat1
	note A_, 4
	note A_, 4
	note A_, 2
	note A_, 2
	note D#, 4
.loop
	note A_, 4
	note A_, 4
	note A_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	loopchannel 4, .loop
.repeat2
	note B_, 4
	note A_, 2
	note B_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note B_, 2
	loopchannel 7, .repeat2
	note B_, 4
	note A_, 4
	note A_, 2
	note A_, 2
	note D#, 4
.repeat3
	note B_, 4
	note C_, 4
	note B_, 2
	note B_, 2
	note C_, 4
	loopchannel 3, .repeat3
	note B_, 4
	note C_, 4
	note C#, 2
	note C_, 2
	note C#, 4
.repeat4
	note B_, 4
	note C_, 4
	note B_, 2
	note B_, 2
	note C_, 4
	loopchannel 3, .repeat4
	note B_, 4
	note C_, 4
	note D_, 2
	note D_, 2
	note D#, 4
	jumpchannel .loop
