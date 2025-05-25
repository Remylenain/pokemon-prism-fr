Music_HoOhBattle:
	channelcount 3
	channel 1, Music_HoOhBattle_Ch1
	channel 2, Music_HoOhBattle_Ch2
	channel 3, Music_HoOhBattle_Ch3

Music_HoOhBattle_Ch1:
	tempo 106
	dutycycle $3
	notetype $c, $c2
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note C_, 1
	octave 2
	note B_, 1
	note A#, 1
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 3
	note C_, 1
	jumpchannel .loop

.repeat
	note A_, 6
	octave 3
	note C_, 6
.loop
	intensity $c2
	octave 2
	note B_, 2
	note B_, 4
	note B_, 4
	note B_, 4
	intensity $c7
	note B_, 6
	loopchannel 4, .repeat
	note A_, 4
	intensity $c2
	octave 3
	note E_, 1
	note D_, 1
	octave 2
	note B_, 1
	note E_, 1
	octave 3
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note D#, 1
	octave 2
	note B_, 1
	octave 3
	intensity $c7
	callchannel .sub1
	note E_, 12
	note D_, 2
	note F_, 2
	note D_, 1
	toneporta $08
	note E_, 11
	toneporta $00
	note F_, 2
	note D_, 2
	note D_, 1
	toneporta $08
	note E_, 11
	toneporta $00
	note D_, 2
	note E_, 2
	note D_, 1
	toneporta $08
	note E_, 15
	toneporta $00
	intensity $c2
	octave 2
	note B_, 1
	note E_, 1
	note A_, 1
	note E_, 1
	note B_, 1
	note E_, 1
	octave 3
	note F_, 1
	octave 2
	note E_, 1
	octave 3
	note E_, 1
	octave 2
	note E_, 1
	octave 3
	note A#, 1
	octave 4
	note C#, 1
	octave 3
	note A_, 1
	note A#, 1
	note E_, 1
	octave 2
	note B_, 1
	intensity $c7
	octave 3
	callchannel .sub1
	octave 4
	note D_, 10
	octave 3
	note B_, 2
	note F_, 2
	note A_, 2
	note F#, 1
	toneporta $08
	note G#, 9
	toneporta $00
	note B_, 2
	note E_, 2
	note A_, 2
	note D#, 1
	toneporta $08
	note F_, 9
	toneporta $00
	note A_, 2
	note D_, 2
	note F_, 2
	note D_, 1
	toneporta $08
	note E_, 9
	toneporta $00
	note E_, 2
	note F_, 2
	note D_, 2
	note D_, 1
	toneporta $08
	note E_, 7
	toneporta $00
	notetype $8, $b7
	vibrato $7, $26
	octave 4
	note D_, 2
	note F_, 2
	note A_, 2
	note B_, 2
	forceoctave $f0
	note D_, 2
	note D#, 2
	callchannel .sub2
	intensity $b7
	vibrato $7, $26
	callchannel .sub3
	forceoctave 0
	note B_, 8
	octave 5
	note D_, 2
	note E_, 2
	octave 4
	note B_, 2
	octave 5
	note D_, 2
	octave 4
	note A_, 2
	note B_, 2
	octave 5
	note D_, 4
	intensity $c8
	vibrato $0, $0
	note E_, 8
	intensity $b7
	vibrato $7, $26
	note E_, 16
	vibrato $0, $0
	octave 4
	callchannel .sub2
	intensity $c7
	callchannel .sub3
	octave 3
	note B_, 12
	note A_, 2
	note B_, 2
	note A_, 2
	note B_, 2
	octave 4
	note D_, 4
	intensity $c8
	note E_, 8
	intensity $c7
	note E_, 16
	callchannel .sub4
	intensity $c8
	note D_, 2
	intensity $c7
	portadown $08
	note D_, 2
	portadown $00
	callchannel .sub5
	callchannel .sub4
	note D_, 1
	note C_, 1
	octave 2
	note A_, 2
	octave 3
	callchannel .sub5
	dutycycle $0
	intensity $c4
	vibrato $1, $25
	octave 2
	note E_, 2
	note E_, 6
	intensity $93
	note E_, 1
	note E_, 1
	note E_, 2
	note E_, 1
	note E_, 1
	note E_, 2
	intensity $c4
	note E_, 1
	intensity $93
	note E_, 1
	intensity $c4
	note E_, 2
	note E_, 1
	intensity $93
	note E_, 1
	intensity $c4
	note E_, 2
	note E_, 1
	note E_, 1
	note E_, 2
	note E_, 1
	note E_, 1
	note E_, 2
	dutycycle $3
	intensity $c7
	vibrato $0, $0
	octave 3
	note D_, 1
	toneporta $08
	note E_, 3
	toneporta $00
	note D_, 2
	note E_, 2
	note __, 2
	note G_, 2
	note A_, 2
	octave 2
	note B_, 2
	octave 3
	note D_, 1
	toneporta $08
	note E_, 3
	toneporta $00
	note D_, 2
	note E_, 2
	note __, 2
	note G_, 2
	note A_, 4
	intensity $c8
	note A#, 16
	intensity $c7
	note A#, 16
	jumpchannel .loop

.sub1
	note D_, 1
	toneporta $08
	note E_, 11
	toneporta $00
	note D_, 2
	note E_, 2
	loopchannel 2, .sub1
	note G_, 1
	toneporta $08
	note A_, 11
	toneporta $00
	note A_, 1
	toneporta $08
	note B_, 3
	toneporta $00
	endchannel

.sub2
	notetype $c, $b7
	note E_, 1
	note F_, 1
	note E_, 12
	note F_, 2
	note D_, 2
	note E_, 2
	octave 3
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note B_, 2
	note D_, 2
	note E_, 2
	note F#, 2
	note A_, 2
	intensity $c8
	vibrato $0, $0
	octave 4
	note D_, 8
	endchannel

.sub3
	note D_, 12
	octave 3
	note B_, 1
	note A_, 1
	note F_, 1
	note D_, 1
	octave 2
	note B_, 1
	note A_, 1
	note F_, 1
	note D_, 1
	octave 4
	note E_, 1
	note F_, 1
	note E_, 8
	note F_, 2
	note D_, 2
	note E_, 2
	endchannel

.sub4
	octave 2
	note E_, 4
	intensity $c8
	note A_, 2
	intensity $c7
	portadown $08
	note A_, 2
	portadown $00
	note G_, 2
	note A_, 2
	intensity $c8
	octave 3
	note C_, 2
	intensity $c7
	portadown $08
	note C_, 2
	portadown $00
	octave 2
	note A_, 2
	octave 3
	note C_, 2
	endchannel

.sub5
	note C_, 2
	note D_, 2
	intensity $c8
	note G_, 2
	intensity $c7
	portadown $08
	note G_, 2
	portadown $00
	note E_, 2
	note __, 14
	note __, 16
	endchannel

Music_HoOhBattle_Ch2:
	dutycycle $3
	notetype $c, $c2
.repeat1
	octave 4
	note E_, 1
	note D#, 1
	note D_, 1
	octave 5
	note E_, 1
	loopchannel 8, .repeat1
	jumpchannel .loop

.repeat2
	note F_, 6
.loop
	intensity $c2
	octave 3
	note E_, 2
	note E_, 4
	note E_, 4
	note E_, 4
	intensity $c7
	note E_, 6
	note D_, 6
	loopchannel 4, .repeat2
	note F_, 4
	dutycycle $0
	intensity $c4
	vibrato $1, $25
	octave 2
	callchannel .sub1
	callchannel .sub2
	note E_, 2
	note E_, 2
.repeat3
	note D_, 2
	note E_, 4
	loopchannel 4, .repeat3
	note E_, 2
	octave 1
	note B_, 2
	octave 2
	callchannel .sub3
	callchannel .sub2
	note E_, 4
	note D_, 2
	note E_, 12
	note E_, 8
	note E_, 2
	note E_, 2
	note E_, 2
	forceoctave $f0
	dutycycle $2
	vibrato $0, $0
	callchannel .sub4
	note D_, 6
	forceoctave 0
	dutycycle $3
	intensity $b7
	vibrato $7, $26
	octave 5
	note F_, 2
	note D_, 2
	note E_, 8
	dutycycle $0
	vibrato $1, $25
	callchannel .sub4
	note D_, 2
	octave 3
	note E_, 2
	octave 4
	note E_, 2
	note D_, 2
	octave 3
	note B_, 2
	note A_, 2
	note B_, 2
	note A_, 2
	note G_, 2
	note __, 16
	note __, 16
	note __, 1
	intensity $c4
	note D_, 1
	note E_, 4
	octave 2
	note A_, 2
	octave 3
	note D_, 2
	note E_, 2
	note C_, 2
	octave 2
	note A_, 2
	note E_, 2
	octave 3
	note D_, 2
	note E_, 1
	note D_, 1
	octave 2
	note A_, 2
	note G_, 2
	note A_, 2
	note D_, 1
	note E_, 1
	note G_, 2
	note __, 16
	note __, 16
	octave 3
	note A_, 1
	note G_, 1
	note A_, 2
	note A_, 2
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	note G_, 2
	note C_, 2
	octave 2
	note A_, 2
	octave 3
	note C_, 2
	note G_, 2
	note E_, 1
	note D_, 1
	octave 2
	note A_, 2
	note G_, 2
	note A_, 2
	note D_, 1
	note E_, 1
	note G_, 2
	note B_, 2
	note B_, 6
	intensity $93
	note B_, 1
	note B_, 1
	note B_, 2
	note B_, 1
	note B_, 1
	note B_, 2
	intensity $c4
	note B_, 1
	intensity $93
	note B_, 1
	intensity $c4
	note B_, 2
	note B_, 1
	intensity $93
	note B_, 1
	intensity $c4
	note B_, 2
	note B_, 1
	note B_, 1
	note B_, 2
	note B_, 1
	note B_, 1
	note B_, 2
	note __, 16
	note __, 16
	dutycycle $3
	intensity $c8
	vibrato $0, $0
	octave 3
	note F_, 16
	intensity $c7
	note F_, 16
	jumpchannel .loop

.sub2
	note E_, 4
	note D_, 2
	note E_, 12
	note E_, 8
	note E_, 2
	note E_, 2
.sub1
	note E_, 2
.sub3
	note E_, 14
	note E_, 2
	note E_, 4
	note D_, 2
	note E_, 6
	note E_, 2
	note E_, 2
	endchannel

.sub4
	intensity $93
	octave 3
	note E_, 2
	octave 4
	note E_, 2
	note D_, 2
	octave 3
	note A_, 2
	note B_, 2
	note A_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note F_, 2
	note D_, 2
	octave 2
	note A_, 2
	note F#, 2
	octave 3
	note D_, 2
	octave 2
	note D_, 2
	note A_, 2
	note F#, 2
	octave 3
	note E_, 2
	note D_, 2
	octave 2
	note A_, 2
	note B_, 2
	note A_, 2
	note F#, 2
	note D_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note B_, 2
	note F#, 2
	note F#, 1
	note E_, 1
	note C_, 1
	octave 2
	note A_, 1
	note F#, 1
	note E_, 1
	octave 3
	note B_, 2
	note E_, 2
	octave 4
	note E_, 2
	note D_, 2
	octave 3
	note A_, 2
	note B_, 2
	note A_, 2
	note F_, 2
	note D_, 2
	octave 2
	note B_, 2
	octave 3
	note F_, 2
	note E_, 2
	note D_, 2
	octave 2
	note B_, 2
	octave 4
	note E_, 2
	note D_, 2
	octave 3
	note B_, 2
	octave 2
	note D_, 2
	octave 3
	note E_, 2
	note D_, 2
	octave 2
	note A_, 2
	note B_, 2
	note A_, 2
	note F#, 2
	endchannel

Music_HoOhBattle_Ch3:
	notetype $c, $16
	octave 2
	note E_, 16
	note D_, 8
	note F_, 8
.loop
	octave 1
	note B_, 2
	octave 2
	note E_, 2
	loopchannel 93, .loop
	note F_, 2
	note D_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note F_, 14
	octave 3
	note E_, 2
	octave 2
	note F_, 2
	note __, 2
	note E_, 2
	note __, 2
	note B_, 6
	note A_, 2
	note F#, 2
	note D_, 12
	note F#, 1
	note __, 1
	note F#, 2
	note __, 2
	note D_, 8
	note __, 4
	note D_, 1
	note __, 1
	note D_, 6
	note __, 4
	note D_, 2
	note __, 2
	note D_, 2
	note __, 2
	octave 3
	note D_, 4
	octave 2
	note B_, 4
	note A_, 4
	note __, 2
	note E_, 6
	note __, 4
	note E_, 1
	note __, 1
	note E_, 2
	octave 3
	note D_, 2
	octave 2
	note E_, 1
	note __, 1
	note E_, 2
	note B_, 2
	note E_, 2
	note B_, 2
	note G_, 2
	callchannel .sub1
.repeat1
	note D_, 2
	note A_, 2
	loopchannel 7, .repeat1
	note F#, 2
	callchannel .sub1
.repeat2
	note E_, 2
	note B_, 2
	loopchannel 7, .repeat2
	note F#, 2
	note D_, 2
	callchannel .sub2
	callchannel .sub2
	note F_, 4
	note B_, 4
	note F_, 4
	note B_, 4
	note F_, 4
	note B_, 4
	octave 3
	note E_, 4
	octave 2
	note B_, 4
	note E_, 4
	note D_, 2
	note E_, 2
	note __, 2
	note G_, 2
	note A_, 2
	octave 1
	note B_, 2
	octave 2
	note E_, 4
	note D_, 2
	note E_, 2
	note __, 2
	note G_, 2
	note A_, 4
	note A#, 16
	note A#, 10
	note G_, 2
	note A_, 2
	note E_, 2
	jumpchannel .loop

.sub1
	note E_, 2
.repeat3
	note F_, 2
	note B_, 2
	loopchannel 7, .repeat3
	note A_, 2
	note F#, 2
	endchannel

.sub2
	octave 1
	note A_, 2
	octave 2
	note E_, 2
	loopchannel 14, .sub2
	octave 1
	note G_, 2
	octave 2
	note D_, 2
	octave 1
	note G_, 2
	octave 2
	note D_, 2
	endchannel
