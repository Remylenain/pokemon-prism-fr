Music_ViridianCityRBY:
	channelcount 4
	channel 1, Music_ViridianCityRBY_Ch1
	channel 2, Music_ViridianCityRBY_Ch2
	channel 3, Music_ViridianCityRBY_Ch3
	channel 4, Music_ViridianCityRBY_Ch4

Music_ViridianCityRBY_Ch1:
	tempo 144
	volume $77
	vibrato 8, $24
	dutycycle 3
	stereopanning $f0
.loop
	notetype 12, $c5
	octave 3
	note G#, 4
	note F#, 4
	note E_, 2
	note E_, 2
	note F#, 2
	note D#, 2
	note E_, 2
	note E_, 2
	note D#, 2
	note C#, 4
	note D#, 4
	note E_, 2
	note D#, 4
	note C#, 2
	note E_, 2
	note E_, 4
	intensity $a5
	note C#, 4
	octave 2
	note B_, 6
	octave 3
	note C#, 2
	note C#, 4
	octave 2
	callchannel .sub1
	note D#, 6
	note E_, 2
	octave 2
	note B_, 4
	intensity $a5
	octave 3
	note C#, 2
	octave 2
	note B_, 2
	note A_, 4
	note B_, 4
	note B_, 2
	octave 3
	note C#, 2
	note D#, 2
	note E_, 2
	note D#, 2
	note C#, 2
	note D#, 2
	intensity $c5
	note G#, 2
	note E_, 2
	note F#, 2
	note E_, 2
	note E_, 4
	note F#, 2
	note D#, 2
	note E_, 4
	note D#, 2
	note C#, 4
	note D#, 4
	note E_, 2
	note D#, 2
	note C#, 2
	note C#, 2
	note E_, 2
	note E_, 4
	intensity $a5
	note C#, 2
	octave 2
	note A_, 2
	note B_, 6
	octave 3
	note C#, 2
	note C#, 2
	octave 2
	note B_, 2
	callchannel .sub1
	note D#, 4
	note D#, 2
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note C#, 2
	note G#, 2
	note E_, 4
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	intensity $a5
	note C#, 4
	octave 2
	note B_, 2
	octave 3
	note D#, 4
	note C#, 2
	note E_, 4
	intensity $b3
	callchannel .sub2
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 4
	note F#, 4
	note G#, 2
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note E_, 4
	note G#, 2
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	note E_, 2
	note F#, 2
	note E_, 2
	note D#, 2
	note E_, 2
	note D#, 2
	note C#, 2
	octave 2
	note B_, 2
	octave 3
.repeat
	note C#, 2
	note D#, 2
	note C#, 2
	octave 2
	note B_, 4
	note B_, 2
	octave 3
	note C#, 2
	note D#, 2
	loopchannel 2, .repeat
	note E_, 2
	octave 2
	note B_, 4
	octave 3
	note E_, 4
	octave 2
	note B_, 2
	octave 3
	note C#, 2
	note G#, 2
	note G#, 2
	octave 2
	note B_, 2
	octave 3
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	callchannel .sub2
	note E_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 2
	note F#, 2
	note G#, 2
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	note C#, 2
	note G#, 2
	note C#, 2
	note D#, 2
	note B_, 2
	note E_, 2
	note G#, 2
	note E_, 2
	note F#, 2
	note E_, 4
	note G#, 2
	note F#, 2
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 4
	note F#, 2
	note D#, 2
	note D#, 2
	note F#, 2
	octave 2
	note B_, 2
	octave 3
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	octave 2
	note B_, 2
	note B_, 2
	octave 3
	note D#, 2
	intensity $b6
	note F#, 8
	note F#, 4
	note D#, 4
	note E_, 8
	intensity $84
	octave 2
	note B_, 4
	octave 3
	note E_, 2
	note F#, 2
	jumpchannel .loop

.sub1
	note B_, 4
	intensity $c5
	octave 3
	note F#, 2
	note D#, 4
	note E_, 2
	note D#, 4
	note C#, 4
	octave 2
	note B_, 4
	octave 3
	note C#, 2
	note D#, 2
	note C#, 2
	octave 3
	endchannel

.sub2
	note A_, 2
	note E_, 2
	note C#, 2
	note E_, 4
	note A_, 2
	note C#, 2
	note E_, 2
	note A_, 2
	endchannel

Music_ViridianCityRBY_Ch2:
	stereopanning $f
	vibrato 5, $15
	callchannel .sub
	note E_, 6
	intensity $c5
	dutycycle 3
	octave 3
	note C#, 4
	note D#, 4
	note E_, 6
	note F#, 6
	note G#, 4
	callchannel .sub
	note E_, 14
	dutycycle 3
	octave 3
	note E_, 6
	note F#, 6
	note G#, 4
	intensity $b7
	dutycycle 2
	vibrato 8, $17
	octave 5
	note C#, 12
	octave 4
	note A_, 4
	octave 5
	note E_, 8
	note F#, 2
	note E_, 2
	note D#, 2
	note C#, 2
	octave 4
	note B_, 12
	note G#, 4
	note B_, 16
	note F#, 12
	note G#, 2
	note A_, 2
	note B_, 4
	note A_, 4
	note G#, 4
	note F#, 4
	note G#, 12
	note E_, 4
	note B_, 16
	octave 5
	note C#, 12
	note D#, 2
	note E_, 2
	note F#, 4
	note E_, 4
	note D#, 4
	note C#, 4
	octave 4
	note B_, 12
	octave 5
	note C#, 2
	note D#, 2
	note C#, 4
	octave 4
	note B_, 4
	note A_, 4
	note G#, 4
	note A_, 12
	note B_, 2
	octave 5
	note C_, 2
	note C_, 4
	octave 4
	note B_, 4
	note A_, 4
	note F#, 4
	intensity $b7
	note A_, 8
	octave 5
	note C_, 8
	octave 4
	note B_, 14
	intensity $84
	note G#, 1
	intensity $a4
	note A_, 1
	jumpchannel Music_ViridianCityRBY_Ch2

.sub
	dutycycle 2
	notetype 12, $c3
	octave 4
	note B_, 4
	note A_, 4
	intensity $c4
	note G#, 10
	intensity $c3
	note G#, 2
	note A_, 2
	note B_, 4
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 2
	intensity $c4
	note F#, 10
	intensity $c5
	dutycycle 3
	octave 3
	note E_, 4
	note D#, 8
	note E_, 4
	note F#, 4
	intensity $c3
	dutycycle 2
	octave 4
	note A_, 4
	note G#, 4
	intensity $c4
	note F#, 10
	intensity $c3
	note F#, 2
	note G#, 2
	note A_, 4
	note A_, 2
	note G#, 2
	note F#, 2
	octave 4
	note G#, 2
	intensity $c4
	endchannel

Music_ViridianCityRBY_Ch3:
	notetype 12, $11
.loop
	vibrato 0, $00
	octave 4
	callchannel .sub1
	callchannel .sub2
	callchannel .sub3
	note B_, 2
	callchannel .sub3
	callchannel .sub2
	note E_, 2
	note F#, 2
	note G#, 2
	note __, 2
	note G#, 2
	note E_, 2
	note B_, 2
	note __, 2
	note E_, 2
	note F#, 2
	note E_, 2
	note G#, 2
	note E_, 2
	note B_, 2
	note E_, 2
	vibrato 8, $25
	note A_, 8
	note E_, 8
	note A_, 8
	note F#, 8
	note G#, 8
	note E_, 8
	note G#, 12
	note E_, 4
	note F#, 2
	note F#, 2
	note D#, 2
	note E_, 4
	note F#, 2
	note D#, 2
	note E_, 2
	note F#, 2
	note F#, 2
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note G#, 2
	note G#, 2
	note E_, 2
	note G#, 2
	note __, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note __, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note B_, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note A_, 8
	note E_, 8
	note A_, 8
	note B_, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note G#, 8
	note E_, 8
	note B_, 4
	note E_, 4
	note F#, 4
	note G#, 4
	note __, 2
	note D#, 2
	note E_, 2
	note F#, 2
	note __, 2
	note F#, 2
	note B_, 2
	note A_, 2
	note A_, 4
	note G#, 4
	note F#, 2
	note D#, 2
	note A_, 2
	note F#, 2
	note __, 2
	note E_, 2
	note F#, 2
	note G#, 2
	note __, 2
	note E_, 2
	note F#, 1
	note G#, 1
	note E_, 1
	note F#, 1
	note G#, 4
	note B_, 2
	note A_, 2
	note G#, 2
	note A_, 2
	note G#, 2
	note F#, 2
	jumpchannel .loop

.sub1
	note __, 2
.sub3
	note E_, 2
	note F#, 2
	note G#, 2
	loopchannel 4, .sub1
	endchannel

.sub2
	note A_, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note __, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note __, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note __, 2
	note A_, 2
	note G#, 2
	note F#, 2
	note D#, 2
.subrepeat
	note D#, 2
	note E_, 2
	note F#, 2
	note __, 2
	loopchannel 3, .subrepeat
	note D#, 2
	note E_, 2
	note F#, 2
	note G#, 2
	endchannel

Music_ViridianCityRBY_Ch4:
	togglenoise 0
	notetype 12
.loop
	callchannel .sub1
	callchannel .sub1
	callchannel .sub2
	callchannel .sub2
	callchannel .sub3
	note F_, 6
	note F_, 6
	note F#, 4
	note F_, 6
	note F_, 6
	note F#, 2
	note F#, 2
	callchannel .sub3
	note F_, 6
	note F_, 6
	note F#, 2
	note F#, 2
	callchannel .sub4
	note F_, 6
	note F_, 6
	note F#, 2
	note F_, 2
	note F_, 6
	note F_, 6
	note F_, 4
	note F_, 6
	note G_, 6
	note G_, 4
	jumpchannel .loop

.sub2
	note G_, 6
	note G_, 6
	note G_, 4
	loopchannel 4, .sub2
.sub1
	note G_, 6
	note G_, 6
	note G_, 4
	note G_, 6
	note G_, 6
	note G_, 2
	note G_, 2
	endchannel

.sub3
	note F_, 6
	note F_, 6
	note F#, 4
	note F_, 6
	note F_, 6
	note F#, 2
	note F_, 2
.sub4
	note F_, 6
	note F_, 6
	note F#, 4
	note F_, 6
	note F_, 6
	note F#, 4
	endchannel
