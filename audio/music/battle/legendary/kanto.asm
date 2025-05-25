Music_KantoLegend:
	channelcount 3
	channel 1, Music_KantoLegend_Ch1
	channel 2, Music_KantoLegend_Ch2
	channel 3, Music_KantoLegend_Ch3

Music_KantoLegend_Ch1:
	tempo 106
	dutycycle $2
	notetype $c, $c7
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
	octave 2
	note B_, 1
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 3
	note C_, 1
	note C#, 1
.repeat1
	note C_, 1
	note __, 1
	note C_, 1
	note __, 5
	loopchannel 4, .repeat1
.repeat2
	note D_, 1
	note __, 1
	note D_, 1
	note __, 5
	loopchannel 4, .repeat2
.repeat3
	note E_, 1
	note __, 1
	note E_, 1
	note __, 5
	loopchannel 7, .repeat3
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	intensity $74
	octave 4
	note G_, 1
	note A_, 1
	note B_, 1
	octave 5
	note D_, 1
	note E_, 1
.loop
	intensity $53
	octave 2
	note C_, 2
	note F_, 2
	note G_, 2
	octave 3
	note C_, 2
	loopchannel 4, .loop
.repeat4
	octave 2
	note D_, 2
	note G_, 2
	note A_, 2
	octave 3
	note D_, 2
	loopchannel 4, .repeat4
	jumpchannel .skip1
.repeat5
	note E_, 2
.skip1
	octave 2
	note E_, 2
	note A_, 2
	note B_, 2
	octave 3
	loopchannel 8, .repeat5
	note E_, 1
	setcondition 0
	callchannel .sub1
	callchannel .sub1
	forceoctave 2
	callchannel .sub1
	callchannel .sub1
	forceoctave 4
	callchannel .sub1
	callchannel .sub1
	callchannel .sub1
	setcondition 1
	callchannel .sub1
	forceoctave 0
	intensity $74
	note A_, 1
	note B_, 1
	octave 4
	note D_, 1
	note E_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 5
	note D_, 1
	dutycycle $1
	intensity $c5
	octave 3
	note G_, 6
	note F#, 6
	note E_, 4
	note G_, 6
	note A_, 6
	note G_, 4
	octave 4
	note G#, 12
	note G_, 2
	note __, 2
	note G#, 2
	note G_, 2
	note __, 4
	intensity $b7
	octave 5
	note C#, 8
	intensity $c5
	octave 4
	note C_, 6
	octave 3
	note A#, 6
	note G#, 4
	octave 4
	note C#, 6
	note C_, 6
	octave 3
	note A#, 4
	octave 4
	note F_, 6
	note E_, 6
	note D_, 4
	intensity $c7
	octave 3
	note A#, 4
	octave 4
	note C_, 4
	note D_, 4
	note F_, 4
	intensity $c0
	note G#, 16
	intensity $b0
	note G#, 16
	intensity $4e
	note G_, 16
	intensity $c7
	note G_, 16
	callchannel .sub2
	note E_, 16
	intensity $c7
	note E_, 16
	callchannel .sub2
	note G_, 16
	intensity $3f
	octave 5
	note C_, 16
	dutycycle $2
	intensity $43
	note C_, 1
	note E_, 1
	note G_, 1
	octave 6
	note C_, 1
	octave 5
	note C_, 1
	octave 6
	note C_, 1
	octave 5
	note G_, 1
	note C_, 1
	note E_, 1
	note G_, 1
	jumpchannel .skip2
.repeat6
	note E_, 1
	note C_, 1
	note E_, 1
.skip2
	octave 6
	note C_, 1
	octave 5
	note G_, 1
	loopchannel 3, .repeat6
	note F_, 1
	note E_, 1
	note F_, 1
	note G_, 1
	octave 6
	note C_, 1
	octave 5
	note F_, 1
	note G_, 1
	note F_, 1
	note C_, 1
	note F_, 1
	note D_, 1
	note F_, 1
	note A_, 1
	octave 6
	note D_, 1
	octave 5
	note D_, 1
	octave 6
	note D_, 1
	octave 5
	note A_, 1
	note D_, 1
	note F_, 1
	note A_, 1
	jumpchannel .skip3
.repeat7
	note F_, 1
	note D_, 1
	note F_, 1
.skip3
	octave 6
	note D_, 1
	octave 5
	note A_, 1
	loopchannel 3, .repeat7
	note G_, 1
	note F_, 1
	note G_, 1
	note A_, 1
	octave 6
	note D_, 1
	octave 5
	note G_, 1
	note A_, 1
	note G_, 1
	note D_, 1
	note G_, 1
	callchannel .sub3
	callchannel .sub3
	dutycycle $1
	intensity $c5
	octave 4
	note E_, 12
	note E_, 2
	note __, 2
	note F_, 2
	intensity $c2
	note E_, 4
	note __, 10
	intensity $c5
	note F_, 12
	note F_, 2
	note __, 2
	note G#, 2
	intensity $c2
	note G_, 6
	intensity $c5
	note F_, 8
	note G_, 12
	note G_, 2
	note __, 2
	note A_, 2
	intensity $c2
	note G_, 4
	note __, 10
	intensity $c5
	note G_, 12
	note G_, 2
	note __, 2
	note A_, 2
	intensity $c2
	note G_, 6
	intensity $c5
	note G_, 9
	dutycycle $2
	jumpchannel .loop

.sub1
	octave 4
	note C_, 1
	octave 3
	note C_, 1
	octave 5
	note C_, 1
	octave 3
	note C_, 1
	loopchannel 2, .sub1
	jumpif 1, .end
	octave 2
	note C_, 1
	octave 3
	note C_, 1
	octave 4
	note C_, 1
	octave 3
	note C_, 1
	octave 5
	note C_, 1
	octave 3
	note C_, 1
	octave 5
	note C_, 1
	octave 3
	note C_, 1
.end
	endchannel

.sub2
	octave 3
	note F_, 8
	note A#, 8
	octave 4
	note D_, 8
	note F_, 8
	intensity $c0
	endchannel

.sub3
	note E_, 1
	note G_, 1
	note B_, 1
	octave 6
	note E_, 1
	octave 5
	note E_, 1
	octave 6
	note E_, 1
	octave 5
	note B_, 1
	note E_, 1
	note G_, 1
	note B_, 1
	jumpchannel .skip4
.repeat8
	note G_, 1
	note E_, 1
	note G_, 1
.skip4
	octave 6
	note E_, 1
	octave 5
	note B_, 1
	loopchannel 3, .repeat8
	note A_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 6
	note E_, 1
	octave 5
	note A_, 1
	note B_, 1
	note A_, 1
	note E_, 1
	note A_, 1
	endchannel

Music_KantoLegend_Ch2:
	dutycycle $1
	notetype $c, $c2
.repeat1
	octave 3
	note G_, 1
	note F#, 1
	note F_, 1
	octave 4
	note G_, 1
	loopchannel 8, .repeat1
	octave 2
.repeat2
	note C_, 2
	note C_, 6
	loopchannel 4, .repeat2
.repeat3
	note D_, 2
	note D_, 6
	loopchannel 4, .repeat3
.repeat4
	note E_, 2
	note E_, 6
	loopchannel 6, .repeat4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	intensity $b7
.loop
	callchannel .sub1
	forceoctave 2
	callchannel .sub1
	forceoctave 4
	callchannel .sub1
	callchannel .sub1
	forceoctave 0
	loopchannel 2, .loop
	setcondition 1
	jumpchannel .skip
.repeat5
	setcondition 1
	callchannel .sub1
.skip
	callchannel .sub1
	setcondition 0
	forceoctave 1
	callchannel .sub1
	forceoctave 0
	loopchannel 2, .repeat5
	callchannel .sub1
	note C_, 2
	note C_, 2
	note A#, 4
	note C_, 2
	note C_, 2
	note A#, 4
	note C_, 2
	note F_, 2
	note C_, 2
	note C_, 4
	note C_, 2
	note A#, 4
	callchannel .sub1
	note C_, 2
	note C_, 2
	note G_, 2
	note F_, 2
	note C_, 2
	note C_, 2
	callchannel .sub2
	callchannel .sub1
	loopchannel 5, .loop

.sub1
	octave 1
	note C_, 2
	octave 2
	note C_, 2
	octave 1
	note G_, 2
	note F_, 2
	note C_, 2
	octave 2
	note C_, 2
	octave 1
.sub2
	note G_, 2
	note F_, 2
	note C_, 2
	note G_, 2
	note F_, 2
	octave 2
	note C_, 2
	octave 1
	note C_, 2
	octave 2
	note C_, 2
	octave 1
	note G_, 2
	jumpif 1, .sharp
	note F_, 2
	endchannel

.sharp
	note F#, 2
	endchannel

Music_KantoLegend_Ch3:
	notetype $c, $14
	octave 3
	note C_, 1
	note __, 1
	note C_, 1
	octave 4
	note C_, 1
	octave 3
	note C#, 1
	note __, 1
	note C#, 1
	octave 4
	note C#, 1
	octave 3
	note D_, 1
	note __, 1
	note D_, 1
	octave 4
	note D_, 1
	octave 3
	note D#, 1
	note __, 1
	note D#, 1
	octave 4
	note D#, 1
	octave 3
	note E_, 1
	note __, 1
	note E_, 1
	octave 4
	note E_, 1
	octave 3
	note F_, 1
	note __, 1
	note F_, 1
	octave 4
	note F_, 1
	octave 3
	note F#, 1
	note __, 1
	note F#, 1
	octave 4
	note F#, 1
	octave 3
	note G_, 1
	note __, 1
	note G_, 1
	octave 4
	note G_, 1
.loop
	callchannel .sub1
	forceoctave 0
	intensity $14
	callchannel .sub1
	callchannel .sub1
	intensity $26
	note C#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	callchannel .sub2
	note A_, 1
	callchannel .sub3
	note D#, 1
	callchannel .sub3
	callchannel .sub4
	intensity $16
	note D_, 4
	note C_, 4
	note D_, 4
	note F_, 4
	note E_, 6
	note D_, 6
	note F_, 4
	note A_, 16
	note G_, 16
	note D_, 4
	note C_, 4
	note D_, 4
	note F_, 4
	note G_, 6
	note A_, 6
	note B_, 4
	octave 5
	note C_, 16
	octave 4
	note G_, 8
	intensity $20
	note A_, 1
	note B_, 1
	octave 5
	note D_, 1
	note E_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 6
	note D_, 1
	note E_, 4
.repeat1
	note __, 4
	loopchannel 31, .repeat1
	intensity $10
	forceoctave $f0
	jumpchannel .loop

.sub1
	octave 3
	note C_, 1
	note __, 1
	note F_, 1
	note __, 1
	note G_, 1
	note __, 1
	octave 4
	note C_, 1
	note __, 1
	loopchannel 4, .sub1
.repeat2
	octave 3
	note D_, 1
	note __, 1
	note G_, 1
	note __, 1
	note A_, 1
	note __, 1
	octave 4
	note D_, 1
	note __, 1
	loopchannel 4, .repeat2
.repeat3
	octave 3
	note E_, 1
	note __, 1
	note A_, 1
	note __, 1
	note B_, 1
	note __, 1
	octave 4
	note E_, 1
	note __, 1
	loopchannel 8, .repeat3
	endchannel

.repeat4
	note G#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
.sub2
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 1
	loopchannel 2, .repeat4
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 1
	note G#, 1
	endchannel

.repeat5
	note D#, 1
	note D_, 1
	note C#, 1
.sub3
	note D_, 1
	note D#, 1
	note E_, 1
	loopchannel 5, .repeat5
	note F_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	endchannel

.sub4
	loopchannel 5, .sub2
