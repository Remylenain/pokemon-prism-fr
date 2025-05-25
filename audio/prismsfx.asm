SFX_TCG2Diddly5:
	channelcount 2
	channel 5, .channel_5
	channel 6, .channel_6

.channel_5
	togglesfx
	sfxpriorityon
	notetype1 10
	notetype0 1
	octave 2
	note B_, 2
	inc_octave
	note D_, 3
	note G_, 3
	dec_octave
	note B_, 3
	inc_octave
	note D_, 2
	note G_, 3
	note B_, 3
	note D_, 3
	note G_, 2
	note B_, 3
	inc_octave
	note D_, 3
	dec_octave
	note G_, 3
	note B_, 2
	inc_octave
	note D_, 3
	note G_, 3
	note B_, 3
	note B_, 3
	sfxpriorityoff
	endchannel

.channel_6
	togglesfx
	notetype1 10
	notetype0 1
	octave 3
	note G_, 2
	note B_, 3
	inc_octave
	note D_, 3
	note G_, 3
	dec_octave
	note B_, 2
	inc_octave
	note D_, 3
	note G_, 3
	note B_, 3
	note D_, 2
	note G_, 3
	note B_, 3
	inc_octave
	note D_, 3
	dec_octave
	note G_, 2
	note B_, 3
	inc_octave
	note D_, 3
	note G_, 3
	note G_, 3
	endchannel

SFX_PinballEvolutionFanfareHeader:
	channelcount 3
	channel 5, .channel_5
	channel 6, .channel_6
	channel 7, .channel_7

.channel_5
	togglesfx
	sfxpriorityon
	tempo 112
	volume $77
	dutycycle $03
	vibrato $09, $34
	forceoctave 7
	notetype $08, $a3
	octave 3
	note C_, 4
	intensity $78
	octave 2
	note C_, 2
	intensity $a3
	note A#, 4
	intensity $78
	note C_, 2
	intensity $a3
	note A_, 4
	intensity $78
	note C_, 2
	intensity $38
	octave 3
	note C_, 1
	intensity $48
	note D_, 1
	intensity $58
	note E_, 1
	intensity $68
	note F_, 1
	intensity $78
	note G_, 1
	intensity $88
	note A_, 1
	intensity $91
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note C#, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	intensity $85
	octave 3
	note C_, 12
	note __, 1
	sfxpriorityoff
	endchannel

.channel_6
	togglesfx
	dutycycle $03
	vibrato $09, $34
	forceoctave 7
	notetype $08, $b8
	octave 3
	note A_, 4
	intensity $28
	note A_, 2
	intensity $b8
	note F_, 4
	intensity $28
	note F_, 2
	intensity $b8
	note C_, 4
	intensity $28
	note C_, 2
	note __, 6
	intensity $98
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b8
	note G_, 1
	intensity $28
	note G_, 1
	intensity $b8
	note G_, 1
	intensity $28
	note G_, 1
	intensity $b8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $b5
	note A_, 12
	note __, 1
	endchannel

.channel_7
	togglesfx
	forceoctave 7
	notetype $08, $22
	octave 1
	note F_, 2
	note __, 2
	note A_, 2
	note F_, 2
	note __, 2
	note A#, 2
	note F_, 2
	note __, 2
	note A_, 2
	note F_, 2
	note __, 2
	note A_, 2
	note A#, 2
	note __, 2
	octave 2
	note D_, 1
	note __, 1
	note C#, 2
	note __, 2
	note F_, 1
	note __, 1
	note F_, 12
	note __, 1
	endchannel

SFX_nSomniartLogo:
	channelcount 4
	channel 5, .channel_5
	channel 6, .channel_6
	channel 7, .channel_7
	channel 8, .channel_8

.channel_5
	togglesfx
	tempo 133
	volume $77
	notetype $c, $c8
	portadown $f
	octave 3
	note D_, 16
	toneporta $f
	octave 2
	note A_, 16
	toneporta 0
	intensity $c7
	note A_, 16
	endchannel

.channel_6
	togglesfx
	notetype $c, $c8
	portadown $f
	octave 2
	note A_, 16
	toneporta $f
	note D_, 16
	toneporta 0
	intensity $c7
	note D_, 16
	endchannel

.channel_7
	togglesfx
	notetype $c, $13
	portadown $f
	octave 3
	note D_, 16
	toneporta $f
	octave 2
	note D_, 16
	toneporta 0
	note D_, 16
	endchannel

.channel_8
	noise __,  9, $c8, $00
	noise __,  9, $c8, $10
	noise __,  9, $c8, $20
	noise __,  9, $c8, $30
	noise __,  9, $c8, $40
	noise __,  9, $c8, $50
	noise __,  9, $c8, $70
	noise __,  9, $c8, $80
	noise __,  9, $c8, $90
	noise __,  9, $c8, $a0
	noise __,  9, $c8, $b0
	noise __,  9, $c8, $c0
	noise __,  9, $c8, $d0
	noise __,  9, $c8, $e0
	noise __,  9, $c8, $f0
	endchannel
