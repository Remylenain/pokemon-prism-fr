Music_KalosPowerPlant:
	channelcount 4
	channel 1, Music_KalosPowerPlant_Ch1
	channel 2, Music_KalosPowerPlant_Ch2
	channel 3, Music_KalosPowerPlant_Ch3
	channel 4, Music_KalosPowerPlant_Ch4

Music_KalosPowerPlant_Ch1:
	tempo 175
	volume $77
	stereopanning $f
	notetype $c, $51
.loop
	vibrato $12, $35
	dutycycle $2
	note __, 3
	callchannel Music_KalosPowerPlant_Common
	note F#, 2
	note D#, 2
	note __, 2
	callchannel Music_KalosPowerPlant_Common
	note D#, 2
	note __, 1
	callchannel .sub
	callchannel .sub
	octave 3
	note C#, 1
	note __, 2
	note D_, 1
	note __, 2
	intensity $b9
	note C#, 6
	note __, 4
	octave 2
	note A#, 1
	note __, 2
	note D#, 1
	note __, 2
	note D_, 10
	intensity $aa
	note F#, 2
	note F#, 2
	note F#, 2
	octave 3
	note C_, 2
	note C#, 2
	note C_, 2
	note C#, 2
	note D#, 2
	intensity $6e
	note C_, 8
	note __, 2
	octave 2
	intensity $d3
	note G#, 1
	note __, 2
	intensity $c8
	note F#, 3
	callchannel .sub
	callchannel .sub
	intensity $6a
	octave 4
	note E_, 16
	note C_, 8
	note E_, 8
	octave 3
	note B_, 16
	note G#, 6
	note G#, 6
	note G#, 4
	note B_, 16
	note B_, 8
	octave 4
	note D#, 8
	octave 3
	note B_, 16
	note B_, 8
	octave 4
	note D#, 8
	intensity $51
	jumpchannel .loop

.sub
	vibrato $12, $23
	octave 2
.repeat1
	intensity $c3
	note G#, 3
	intensity $c2
	note G#, 1
	note __, 6
	note G#, 2
	note __, 1
	note G#, 2
	note __, 1
	loopchannel 2, .repeat1
.repeat2
	intensity $c3
	note G_, 3
	intensity $c2
	note G_, 1
	note __, 6
	note G_, 2
	note __, 1
	note G_, 2
	note __, 1
	loopchannel 2, .repeat2
	endchannel

Music_KalosPowerPlant_Ch2:
	stereopanning $ff
	notetype $c, $c2
.loop
	vibrato $12, $35
	dutycycle $2
	octave 3
	note C#, 1
	note G#, 1
	callchannel Music_KalosPowerPlant_Common
	note F#, 2
	note D#, 2
	octave 3
	note C#, 1
	note G#, 1
	callchannel Music_KalosPowerPlant_Common
	note D#, 2
	note __, 2
	callchannel .sub
	vibrato $12, $23
	octave 4
	note C#, 1
	note __, 2
	octave 3
	note G#, 1
	note __, 2
	intensity $b9
	note A_, 6
	octave 4
	note C#, 1
	note D#, 1
	note E_, 1
	note F_, 1
	intensity $d2
	note F#, 1
	note __, 2
	octave 3
	note F#, 1
	note __, 2
	intensity $b9
	note B_, 10
	intensity $aa
	note A_, 2
	note B_, 2
	note A_, 2
	octave 4
	note D#, 2
	note E_, 2
	note D#, 2
	note E_, 2
	note F#, 2
	intensity $4f
	note D#, 8
	note __, 2
	intensity $d3
	note E_, 1
	note __, 2
	intensity $c8
	note D#, 3
	callchannel .sub
	intensity $6a
	octave 4
	note G#, 16
	note F#, 8
	note B_, 8
	note E_, 16
	note D_, 6
	note E_, 6
	note F#, 4
	note G#, 16
	note F#, 8
	note B_, 8
	note G#, 16
	note F#, 8
	note B_, 8
	intensity $c2
	jumpchannel .loop

.sub
	intensity $c2
	dutycycle $1
.repeat
	octave 3
	note G#, 2
	octave 4
	note E_, 2
	note D#, 2
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	note __, 2
	octave 3
	note G#, 2
	note B_, 2
	note __, 2
	note A_, 2
	note __, 2
	note G#, 2
	note __, 2
	note F#, 2
	note G#, 2
	note __, 3
	octave 4
	note E_, 1
	dutycycle $2
	octave 5
	note E_, 1
	dutycycle $1
	octave 4
	note E_, 1
	dutycycle $2
	octave 5
	note E_, 2
	dutycycle $1
	octave 4
	note E_, 1
	dutycycle $2
	octave 5
	note E_, 2
	dutycycle $1
	octave 4
	note E_, 1
	octave 5
	note D_, 2
	octave 4
	note B_, 2
	note A_, 2
	note B_, 2
	note A_, 1
	note E_, 2
	note E_, 1
	note A_, 1
	note B_, 3
	note A_, 2
	note E_, 2
	note A_, 2
	loopchannel 2, .repeat
	endchannel

Music_KalosPowerPlant_Common:
	octave 4
	note E_, 2
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 2
	endchannel

Music_KalosPowerPlant_Ch3:
	stereopanning $ff
.loop
	notetype $c, $11
	octave 3
	note C#, 16
	note C#, 13
	note __, 3
	callchannel .sub
	intensity $14
	octave 2
	note A_, 1
	note __, 2
	note G#, 1
	note __, 2
	note A_, 7
	note G#, 1
	note A_, 1
	note G#, 1
	note F#, 1
	note __, 2
	note D#, 1
	note __, 2
	note G_, 8
	note A_, 1
	note G_, 1
	note F#, 8
	note D#, 8
	note G#, 8
	note __, 2
	note G#, 1
	note __, 2
	note G#, 3
	callchannel .sub
	octave 2
	note B_, 2
	note __, 1
	note B_, 1
	note __, 6
	octave 3
	note E_, 3
	octave 2
	note A_, 3
	note G#, 2
	note __, 1
	note G#, 1
	note __, 1
	note G#, 1
	note __, 4
	note G#, 2
	note __, 1
	note G#, 3
	octave 3
	note C#, 2
	note __, 1
	note C#, 1
	note __, 2
	note C#, 1
	note __, 3
	note C#, 1
	note __, 2
	note C#, 3
	octave 2
	note E_, 2
	note __, 1
	note E_, 1
	note __, 2
	note E_, 1
	note __, 3
	note E_, 1
	note __, 2
	note E_, 3
	note F#, 4
	note B_, 1
	octave 3
	note C_, 1
	note C#, 6
	octave 2
	note F#, 4
	note G#, 4
	octave 3
	note C#, 1
	note D_, 1
	note D#, 6
	octave 2
	note B_, 4
	note G#, 4
	octave 3
	note C#, 1
	note D#, 1
	note E_, 6
	octave 2
	note B_, 2
	octave 3
	note C#, 2
	octave 2
	note B_, 4
	octave 3
	note D#, 1
	note F_, 1
	note F#, 4
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	jumpchannel .loop

.sub
	vibrato $0, $66
	intensity $14
	octave 3
.repeat
	note C#, 3
	note C#, 1
	note __, 2
	octave 2
	intensity $12
	note C#, 4
	intensity $14
	octave 3
	note C#, 2
	note __, 1
	note C#, 2
	note __, 1
	note C#, 3
	note C#, 1
	note __, 2
	intensity $12
	octave 2
	note C#, 4
	intensity $14
	octave 3
	note C#, 2
	note __, 1
	note C#, 2
	note __, 1
	note E_, 3
	note E_, 1
	note __, 2
	intensity $12
	octave 2
	note E_, 4
	intensity $14
	octave 3
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	note E_, 3
	note E_, 1
	note __, 2
	intensity $12
	octave 2
	note E_, 4
	intensity $14
	octave 3
	note E_, 2
	note __, 1
	note E_, 2
	note __, 1
	loopchannel 2, .repeat
	endchannel

Music_KalosPowerPlant_Ch4:
	notetype $c
	togglenoise $3
.loop
	note A#, 3
	note C#, 1
	note D_, 2
	note A#, 4
	note A#, 2
	note D_, 4
	note A#, 3
	note C#, 1
	note D_, 2
	note A#, 4
	note A#, 2
	note C_, 4
.repeat1
	note D_, 4
	callchannel .sub1
	callchannel .sub2
	loopchannel 5, .repeat1
	note D_, 4
	callchannel .sub1
	note D_, 2
	note D_, 1
	note G#, 1
	note D_, 2
	note D_, 2
	note D_, 2
	note B_, 2
	note __, 1
	note B_, 2
	note __, 1
.repeat2
	note D_, 4
	callchannel .sub1
	callchannel .sub2
	loopchannel 8, .repeat2
	jumpchannel .loop

.sub2
	note D_, 2
	note D_, 1
	note G#, 1
.sub1
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 1
	note G#, 1
	note B_, 2
	endchannel
