Music_CeruleanGSC:
	channelcount 4
	channel 1, Music_CeruleanGSC_Ch1
	channel 2, Music_CeruleanGSC_Ch2
	channel 3, Music_CeruleanGSC_Ch3
	channel 4, Music_CeruleanGSC_Ch4

Music_CeruleanGSC_Ch1:
	tempo 148
	volume $77
	notetype $c, $b2
	tone $0001
	dutycycle 2
	stereopanning $f0
	octave 4
	note E_, 2
	note D#, 2
	note C#, 2
	octave 3
	note B_, 2
	note A_, 2
	note B_, 2
	octave 4
	note C#, 2
	note D#, 2
.loop
	intensity $b1
	octave 3
	note G#, 2
	octave 4
	note G#, 2
	callchannel .sub1
	octave 3
	note B_, 2
	octave 4
	note D#, 2
	octave 3
	note B_, 2
	octave 4
	note D#, 2
	callchannel .sub2
	note D#, 2
	note B_, 2
	note D#, 2
	note B_, 2
	octave 3
	note B_, 4
	note B_, 2
	callchannel .sub3
	octave 4
	note C#, 1
	octave 3
	note B_, 1
	note A_, 8
	intensity $b2
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 2
	callchannel .sub3
	note G#, 1
	note B_, 1
	octave 4
	note D#, 8
	octave 3
	note E_, 2
	note E_, 1
	note F#, 1
	note G#, 1
	note __, 3
	note B_, 4
	note G#, 4
	note B_, 2
	note B_, 1
	octave 4
	note C#, 1
	note D#, 1
	note __, 3
	note D#, 4
	octave 3
	note B_, 4
	note A_, 1
	note G#, 1
	note A_, 1
	note B_, 1
	octave 4
	note C#, 1
	note __, 1
	note C#, 1
	octave 3
	note B_, 1
	octave 4
	note C#, 1
	note D#, 1
	note E_, 1
	note __, 1
	note E_, 1
	note F#, 1
	note E_, 1
	note F#, 1
	octave 5
	note B_, 1
	note F#, 1
	note D#, 1
	note C#, 1
	octave 4
	note B_, 1
	octave 5
	note C#, 1
	note D#, 1
	note F#, 1
	note B_, 8
	intensity $b6
	octave 3
	note G#, 8
	note G#, 4
	note B_, 4
	octave 4
	note E_, 4
	note F#, 4
	note G#, 8
	note D#, 8
	octave 3
	note B_, 4
	octave 4
	note B_, 4
	note A_, 4
	note B_, 4
	intensity $b2
	note E_, 2
	note D#, 2
	note C#, 2
	note C_, 2
	jumpchannel .loop

.sub2
	octave 3
	note B_, 2
	octave 4
	note G#, 2
.sub1
	loopchannel 4, .sub2
	octave 3
	note A_, 2
	octave 4
	note E_, 2
	octave 3
	note A_, 2
	octave 4
	note E_, 2
	endchannel

.sub3
	note G#, 1
	note G#, 1
	note E_, 2
	note F#, 2
	intensity $b4
	note G#, 1
	note A_, 1
	note B_, 1
	octave 4
	note C#, 1
	octave 3
	note B_, 6
	endchannel

Music_CeruleanGSC_Ch2:
	vibrato $c, $34
	dutycycle 2
	notetype 2, $c2
	tone $0002
	note __, 2
	octave 5
	note E_, 12
	note D#, 12
	note C#, 12
	octave 4
	note B_, 12
	note A_, 12
	note B_, 12
	octave 5
.loop
	note C#, 12
	note D#, 10
	notetype 12, $c2
	note E_, 6
	octave 3
	callchannel .sub1
	intensity $c4
	note G#, 6
	note A_, 1
	note G#, 1
	note F#, 14
	intensity $c2
	callchannel .sub1
	intensity $c4
	note G#, 6
	note E_, 1
	note G#, 1
	note B_, 14
	intensity $c2
	dutycycle 1
	octave 4
	callchannel .sub2
	intensity $c4
	note G#, 6
	note A_, 1
	note G#, 1
	note F#, 8
	intensity $c2
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 1
	note B_, 2
	callchannel .sub2
	intensity $c4
	note G#, 6
	note E_, 1
	note G#, 1
	note B_, 8
	octave 3
	note C#, 1
	octave 2
	note B_, 1
	octave 3
	note C#, 1
	note D#, 1
	note E_, 1
	note __, 3
	sound_duty 2, 2, 0, 0
	dutycycle 0
	octave 4
	note G#, 4
	note E_, 4
	sound_duty 1, 1, 1, 1
	dutycycle 1
	octave 3
	note D#, 1
	note C#, 1
	note D#, 1
	note E_, 1
	note F#, 1
	note __, 3
	sound_duty 2, 2, 0, 0
	dutycycle 0
	octave 4
	note B_, 4
	note F#, 4
	sound_duty 1, 1, 1, 1
	dutycycle 1
	octave 3
	note C#, 1
	octave 2
	note B_, 1
	octave 3
	note C#, 1
	note D#, 1
	note E_, 1
	note __, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note F#, 1
	note G#, 1
	note __, 1
	note G#, 1
	note A_, 1
	note G#, 1
	note A_, 1
	note B_, 1
	note F#, 1
	note D#, 1
	note C#, 1
	octave 2
	note B_, 1
	octave 3
	note C#, 1
	note D#, 1
	note F#, 1
	note B_, 8
	sound_duty 2, 2, 0, 0
	intensity $c6
	dutycycle 2
	octave 4
	note E_, 8
	octave 3
	note B_, 4
	octave 4
	note F#, 4
	note G#, 4
	note A_, 4
	note B_, 8
	note B_, 8
	note G#, 4
	octave 5
	note D#, 4
	note C#, 4
	note D#, 4
	sound_duty 2, 2, 2, 2
	notetype 2, $c2
	note __, 2
	note E_, 12
	note D#, 12
	jumpchannel .loop

.sub1
	note E_, 1
	octave 2
	note B_, 1
	octave 3
.sub3
	note C#, 2
	note D#, 2
	note E_, 1
	note F#, 1
	note G#, 1
	note A_, 1
	endchannel

.sub2
	note E_, 1
	octave 3
	note B_, 1
	octave 4
	jumpchannel .sub3

Music_CeruleanGSC_Ch3:
	stereopanning $f
	notetype 6, $15
	vibrato $c, $24
	note __, 16
	octave 4
	note E_, 3
	note __, 1
	note D#, 3
	note __, 1
	note C#, 3
	note __, 1
	note C_, 3
	note __, 1
.loop
	callchannel .sub1
	note __, 2
	octave 2
	note B_, 2
	note __, 2
	callchannel .sub1
	octave 2
	note B_, 2
	octave 4
	note B_, 2
	octave 3
	note B_, 2
	octave 1
	note E_, 2
	note __, 2
	octave 5
	note G#, 1
	note __, 3
	callchannel .sub2
	octave 6
	note C#, 1
	note __, 3
	octave 1
	note F#, 2
	note __, 2
	octave 6
	note C#, 1
	note __, 1
	octave 2
	note C#, 2
	octave 1
	note B_, 2
	note __, 2
	octave 6
	note D#, 1
	note __, 1
	octave 2
	note B_, 2
	octave 1
	note B_, 2
	octave 2
	note B_, 2
	octave 6
	note D#, 1
	note __, 1
	octave 1
	note B_, 2
	octave 2
	note E_, 2
	octave 3
	note E_, 2
	octave 4
	note E_, 2
	octave 5
	note E_, 2
	callchannel .sub2
	octave 5
	note E_, 1
	note __, 3
	octave 1
	note F#, 2
	note __, 2
	octave 5
	note E_, 1
	note __, 1
	octave 2
	note C#, 2
	octave 1
	note B_, 2
	note __, 2
	octave 5
	note F#, 1
	note __, 1
	octave 1
	note B_, 2
	note G#, 2
	octave 4
	note D#, 2
	octave 5
	note G#, 1
	note __, 1
	octave 3
	note G#, 2
	octave 2
	note C#, 2
	note __, 6
	note C#, 2
	note __, 4
	note C#, 1
	note __, 1
.repeat1
	octave 2
	note C#, 2
	note __, 2
	octave 3
	note C#, 2
	note __, 2
	loopchannel 2, .repeat1
	octave 1
	note G#, 2
	note __, 6
	note G#, 2
	note __, 4
	note G#, 1
	note __, 1
.repeat2
	note G#, 2
	note __, 2
	octave 2
	note G#, 2
	note __, 2
	octave 1
	loopchannel 2, .repeat2
	note A_, 4
	octave 2
	note A_, 2
	note __, 2
	octave 1
	note A_, 2
	note __, 2
	note G#, 4
	octave 2
	note G#, 2
	note __, 2
	octave 1
	note G#, 2
	note __, 2
	note F#, 4
	octave 2
	note F#, 2
	note __, 2
	octave 1
	note F#, 2
	note __, 2
	note B_, 2
	note __, 2
	note B_, 8
	note __, 16
	note __, 4
	octave 2
	note E_, 2
	note __, 2
	octave 1
	note E_, 2
	note __, 2
	octave 2
	note E_, 2
	note __, 6
	note E_, 2
	note __, 2
	octave 1
	note E_, 2
	note __, 2
	octave 2
	note E_, 2
	note __, 6
	note F#, 2
	note __, 2
	octave 1
	note F#, 2
	note __, 2
	octave 2
	note F#, 2
	note __, 6
	note F#, 2
	note __, 2
	octave 1
	note F#, 2
	note __, 2
	octave 2
	note F#, 2
	note __, 6
	note G#, 2
	note __, 2
	octave 1
	note G#, 2
	note __, 2
	octave 2
	note G#, 2
	note __, 6
	note G#, 2
	note __, 2
	octave 1
	note G#, 2
	note __, 2
	octave 2
	note G#, 2
	note __, 6
	note A_, 2
	note __, 2
	octave 1
	note A_, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 6
	note A_, 2
	note __, 2
	octave 1
	note A_, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 2
	jumpchannel .loop

.sub1
	octave 1
	note E_, 2
	note __, 6
	note E_, 2
	note __, 4
	note E_, 1
	note __, 1
.subrepeat
	note E_, 2
	note __, 2
	octave 2
	note E_, 2
	note __, 2
	octave 1
	loopchannel 2, .subrepeat
	note F#, 2
	note __, 6
	note F#, 2
	note __, 4
	octave 2
	note C#, 2
	octave 1
	note B_, 2
	note __, 2
	octave 2
	note B_, 2
	note __, 2
	octave 1
	note B_, 2
	endchannel

.sub2
	octave 1
	note E_, 2
	note __, 2
	octave 5
	note G#, 1
	note __, 1
	octave 1
	note E_, 1
	note __, 1
	note E_, 2
	note __, 2
	octave 5
	note G#, 1
	note __, 1
	octave 2
	note E_, 2
	octave 1
	note E_, 2
	octave 2
	note E_, 2
	octave 5
	note G#, 1
	note __, 1
	octave 1
	note E_, 2
	note F#, 2
	note __, 2
	endchannel

Music_CeruleanGSC_Ch4:
	notetype $c
	togglenoise 0
	note __, 16
.loop
	note A#, 2
.repeat1
	callchannel .sub
	loopchannel 7, .repeat1
	note G_, 1
	note G_, 1
	note D_, 2
	note G_, 1
	note F_, 1
	note A_, 2
.repeat2
	callchannel .sub
	loopchannel 3, .repeat2
	note G_, 1
	note G_, 1
	note D_, 2
	note A#, 2
	note F_, 1
	note F_, 1
	note G_, 1
	note F_, 1
	note D_, 2
	note G_, 1
	note G_, 1
	note A_, 2
	callchannel .sub
	callchannel .sub
	note A#, 2
	note D_, 2
	note D_, 1
	note F_, 1
	note A#, 2
.repeat3
	callchannel .sub
	loopchannel 3, .repeat3
	note G_, 1
	note G_, 1
	note D_, 2
	note A#, 2
	note A#, 2
	note G_, 1
	note G_, 1
	note D_, 2
	note A_, 2
	note G_, 1
	note G_, 1
	note D_, 2
	note A_, 2
	note G_, 1
	note G_, 1
	note D_, 2
	note D_, 2
	note D_, 12
.repeat4
	note G_, 1
	note G_, 1
	note D_, 2
	loopchannel 14, .repeat4
	note G_, 1
	note G_, 1
	note A#, 2
	note D_, 2
	note F_, 1
	note F_, 1
	jumpchannel .loop

.sub
	note G_, 1
	note G_, 1
	note D_, 2
	note G_, 1
	note G_, 1
	note A_, 2
	endchannel
