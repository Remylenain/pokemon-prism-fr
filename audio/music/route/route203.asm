Music_Route203Day:
	channelcount 4
	channel 1, Music_Route203_Ch1
	channel 2, Music_Route203_Ch2
	channel 3, Music_Route203_Ch3
	channel 4, Music_Route203_Ch4

Music_Route203_Ch1:
	tempo 149
	volume $77
	dutycycle $2
	notetype 16, $48
	octave 4
	note __, 6
	note D#, 9
	note D#, 9
	notetype 8, $28
	note D#, 3
	note __, 1
	intensity $48
	note D#, 1
	intensity $28
	note D#, 5
	notetype 16, $48
	note D_, 10
	note D_, 9
	notetype 8, $28
	dutycycle $0
	notetype 4, $74
	callchannel Music_Route203_Shared_Riff
	intensity $78
	note D#, 1
	note F_, 1
	stereopanning $f
	octave 3
	callchannel .sub1
	intensity $b7
	note A#, 4
	intensity $87
	note A#, 1
	intensity $37
	note A#, 2
	note __, 1
	intensity $87
	note A#, 1
	intensity $37
	note A#, 2
	note __, 1
	intensity $87
	note A#, 1
	intensity $37
	note A#, 3
	intensity $87
	note A#, 1
	intensity $37
	note A#, 2
	note __, 1
	intensity $b7
	note A#, 4
	intensity $87
	note A#, 1
	note __, 3
	callchannel .sub2
	callchannel .sub3
	callchannel .sub4
	note __, 1
.mainloop
	vibrato 0, 0
	dutycycle $0
	note E_, 4
	note D_, 4
	note __, 4
	note E_, 12
	;transplant (melody)
	dutycycle $1
	octave 3
	notetype 8, $c8
	octave 3
	note F#, 2
	note G_, 2
	note A_, 2
	note A_, 2
	note G_, 2
	note F#, 2
	note A_, 4
	note G_, 4
	note F#, 4
	note E_, 2
	note D_, 5
	slidepitchto 2, 5, C_
	intensity $c7
	note D_, 5
	intensity $c8
	note A_, 8
	note G_, 2
	note F#, 2
	note E_, 6
	note C#, 2
	note D_, 2
	note E_, 2
	note F#, 3
	slidepitchto 1, 5, E_
	intensity $c3
	note F#, 2
	intensity $68
	note E_, 3
	note __, 4
	intensity $c8
	note E_, 4
	note F#, 4
	note E_, 4
	note E_, 2
	intensity $d8
	note D_, 2
	intensity $68
	note D_, 2
	intensity $d8
	note D_, 2
	intensity $68
	note D_, 2
	note __, 4
	;end transplant (melody)
	dutycycle $2
	notetype 4, $57
	octave 2
	note A_, 4
	intensity $37
	note A_, 4
	intensity $57
	note B_, 7
	octave 3
	intensity $57
	note D_, 1
	note E_, 1
	note F#, 1
	note G_, 1
	note A_, 1
	note B_, 7
	note __, 1
	octave 3
	intensity $77
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	note B_, 4
	note A_, 2
	intensity $37
	note A_, 2
	intensity $77
	note B_, 4
	octave 4
	note D_, 4
	octave 3
	note B_, 4
	intensity $37
	note B_, 4
	intensity $77
	note A#, 1
	note B_, 7
	octave 4
	note C_, 4
	note C#, 4
	intensity $37
	note C#, 4
	octave 4
	intensity $77
	note C#, 1
	note __, 1
	note C#, 1
	note __, 1
	note C#, 4
	octave 3
	note B_, 2
	intensity $37
	note B_, 2
	octave 4
	intensity $77
	note C#, 4
	note E_, 4
	note C#, 4
	intensity $37
	note C#, 4
	intensity $77
	note C_, 1
	note C#, 7
	note D_, 4
	note D#, 4
	intensity $37
	note D#, 4
	callchannel .sub5
	note F#, 4
	note D#, 4
	intensity $37
	note D#, 4
	intensity $77
	note D_, 1
	note D#, 5
	intensity $37
	note D#, 6
	intensity $77
	note D#, 4
	intensity $37
	note D#, 4
	callchannel .sub5
	note F#, 4
	note D#, 4
	octave 3
	note B_, 4
	octave 4
	note D#, 4
	note F#, 4
	note B_, 4
	octave 3
	note F#, 4
	octave 2
	dutycycle $0
	note B_, 4
	intensity $27
	note B_, 4
	octave 3
	intensity $97
	note E_, 4
	intensity $27
	note E_, 4
	intensity $97
	note D_, 4
	note C#, 4
	intensity $27
	note C#, 8
	note __, 8
	intensity $97
	note D_, 4
	note E_, 4
	octave 2
	note A_, 4
	intensity $27
	note A_, 4
	octave 3
	intensity $97
	note C#, 4
	intensity $27
	note C#, 1
	note __, 3
	intensity $97
	note E_, 4
	note D#, 4
	intensity $27
	note D#, 16
	intensity $97
	note C_, 4
	note D_, 4
	octave 2
	note G_, 4
	intensity $27
	note G_, 4
	octave 3
	intensity $97
	note C#, 4
	intensity $27
	note C#, 4
	intensity $97
	note D_, 4
	note C#, 4
	note G_, 4
	intensity $27
	note G_, 4
	intensity $97
	note A_, 4
	intensity $27
	note A_, 4
	intensity $97
	note E_, 4
	note C#, 4
	intensity $27
	note C#, 16
	intensity $97
	note C#, 4
	intensity $27
	note C#, 8
	intensity $97
	note D#, 4
	intensity $27
	note D#, 4
	intensity $97
	note A_, 4
	note D#, 4
	note D_, 4
	intensity $27
	note D_, 8
	intensity $97
	note D_, 4
	intensity $27
	note D_, 8
	intensity $97
	note E_, 4
	intensity $27
	note E_, 8
	intensity $97
	note E_, 4
	intensity $27
	note E_, 8
	intensity $97
	note F_, 4
	intensity $27
	note F_, 8
	intensity $97
	note A#, 4
	intensity $27
	note A#, 8
	intensity $97
	note F_, 4
	note D_, 4
	octave 2
	note A#, 4
	octave 3
	note A#, 4
	intensity $27
	note A#, 8
	intensity $97
	note E_, 4
	intensity $27
	note E_, 8
	intensity $97
	note G_, 4
	intensity $27
	note G_, 8
	intensity $97
	note E_, 4
	note D_, 4
	octave 2
	note A_, 4
	octave 3
	note G_, 4
	intensity $27
	note G_, 4
	intensity $97
	note D_, 4
	note __, 16
	note __, 16
	note __, 16
	dutycycle $3
	intensity $96
	octave 3
	note F_, 4
	note __, 4
	octave 2
	note F_, 4
	octave 3
	note F_, 8
	octave 2
	note F_, 4
	note E_, 4
	note __, 4
	note E_, 4
	octave 3
	note E_, 8
	octave 2
	note E_, 4
	note D#, 4
	note __, 4
	note D#, 4
	octave 3
	note C_, 8
	octave 2
	note D#, 4
	note D_, 4
	octave 3
	note D_, 8
	note C_, 4
	note __, 4
	octave 2
	note A_, 4
	octave 1
	note A#, 4
	octave 3
	note D_, 4
	octave 1
	note A#, 4
	octave 3
	note D_, 8
	octave 1
	note A#, 4
	octave 3
	note C_, 4
	note __, 4
	octave 2
	note C_, 4
	note G_, 8
	note C_, 4
	octave 2
	note C#, 4
	octave 3
	note F_, 4
	octave 2
	note C#, 4
	octave 3
	note F_, 8
	octave 2
	note C#, 4
	octave 2
	note D#, 4
	octave 3
	note G_, 4
	octave 2
	note D#, 4
	octave 3
	note G_, 8
	octave 2
	note D#, 4
	octave 3
	note G#, 4
	note __, 4
	octave 2
	note G#, 4
	octave 3
	note G#, 8
	octave 2
	note G#, 4
	note G_, 4
	note __, 4
	note G_, 4
	octave 3
	note G_, 8
	octave 2
	note G_, 4
	note F#, 4
	note __, 4
	note F#, 4
	octave 3
	note D#, 8
	octave 2
	note F#, 4
	note F_, 4
	octave 3
	note F_, 8
	note D#, 4
	note __, 4
	note C_, 4
	octave 2
	callchannel .sub6
	callchannel .sub7
	callchannel .sub6
	callchannel .sub7
	note E_, 4
	octave 3
	note E_, 4
	octave 2
	note E_, 4
	octave 3
	note E_, 8
	octave 2
	note E_, 4
	note F#, 4
	octave 3
	note F#, 4
	octave 2
	note F#, 4
	dutycycle $2
	vibrato 0, $42
	intensity $47
	note A#, 1
	octave 3
	note C_, 1
	note D_, 1
	intensity $57
	note D#, 1
	note F_, 1
	note G_, 1
	intensity $67
	note A_, 1
	note A#, 1
	octave 4
	intensity $77
	note C_, 1
	note D_, 1
	intensity $87
	note D#, 1
	note F_, 1
	notetype 16, $78
	note D#, 9
	note D#, 9
	notetype 4, $27
	note D#, 6
	note __, 2
	intensity $77
	note D#, 2
	intensity $27
	note D#, 6
	note __, 4
	notetype 16, $78
	note D_, 10
	note D_, 9
	notetype 4, $27
	dutycycle $0
	vibrato 0, 0
	callchannel Music_Route203_Shared_Riff
	stereopanning $f0
	intensity $a7
	note D#, 1
	note F_, 1
	stereopanning $f
	intensity $b7
	note F_, 12
	note D#, 12
	octave 3
	note A#, 8
	octave 4
	note C_, 4
	octave 3
	callchannel .sub8
	octave 4
	intensity $b7
	note C_, 4
	intensity $37
	note C_, 12
	notetype 16, $b7
	note __, 12
	notetype 4, $b7
	octave 3
	note D_, 4
	note D#, 4
	note F_, 4
	note A#, 8
	note G#, 4
	note F_, 8
	note D#, 4
	note D_, 4
	octave 2
	note A#, 8
	octave 3
	note C_, 4
	intensity $57
	note C_, 4
	intensity $b7
	note D_, 4
	octave 4
	callchannel Music_Route203_Shared_Riff
	stereopanning $f0
	intensity $a7
	note F#, 1
	note G#, 1
	stereopanning $f
	note __, 12
	octave 2
	callchannel .sub8
	intensity $b7
	note F_, 4
	note A#, 4
	note G#, 4
	note F_, 4
	note A#, 4
	note G#, 4
	note F_, 4
	callchannel .sub8
	intensity $b7
	note F_, 4
	callchannel .sub8
	octave 3
	intensity $b7
	note C_, 4
	intensity $57
	note C_, 12
	octave 2
	callchannel .sub8
	octave 3
	intensity $b7
	note D_, 4
	intensity $57
	note D_, 4
	callchannel .sub8
	intensity $b7
	note G#, 4
	intensity $57
	note G#, 4
	intensity $b7
	note F_, 4
	intensity $57
	note F_, 4
	intensity $b7
	note G#, 4
	intensity $57
	note G#, 4
	intensity $b7
	note F_, 4
	intensity $57
	note F_, 4
	intensity $b7
	note D#, 4
	note D_, 4
	octave 2
	note A#, 7
	note __, 1
	octave 3
	note C_, 4
	intensity $57
	note C_, 4
	intensity $b7
	note D_, 4
	callchannel Music_Route203_Shared_Riff
	stereopanning $f0
	intensity $a7
	note F#, 1
	note G#, 1
	stereopanning $f
	octave 3
	intensity $77
	note G#, 1
	callchannel .sub1
	callchannel .sub3
	callchannel .sub2
	callchannel .sub3
	callchannel .sub4
	stereopanning $f
	jumpchannel .mainloop

.sub2
	intensity $87
	note A_, 4
	intensity $b7
	note A#, 3
	intensity $57
	note F#, 1
	intensity $67
	note G#, 1
.sub1
	intensity $a7
	note A#, 4
	note __, 1
	intensity $97
	note A#, 1
	note __, 1
	intensity $87
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	endchannel

.sub3
	intensity $b7
	note A#, 2
	note __, 2
	intensity $87
	note A#, 1
	note __, 3
	note A#, 1
	note __, 3
	note A#, 1
	note __, 3
	note A#, 1
	note __, 3
	intensity $b7
	note A#, 2
	note __, 2
	intensity $87
	note A#, 1
	note __, 3
	endchannel

.sub4
	octave 4
	intensity $b7
	note C_, 1
	note __, 3
	octave 3
	intensity $87
	note A#, 3
	intensity $57
	note C#, 1
	intensity $67
	note D#, 1
	intensity $a7
	note F_, 4
	note __, 1
	intensity $97
	note F_, 1
	note __, 1
	intensity $87
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	intensity $b7
	note F_, 2
	note __, 2
	intensity $87
	note F_, 1
	note __, 3
	note F_, 1
	note __, 3
	note F_, 1
	note __, 3
	note F_, 1
	note __, 3
	intensity $b7
	note F_, 2
	note __, 2
	intensity $87
	note F_, 2
	note __, 2
	intensity $b7
	note G_, 4
	intensity $a7
	note F_, 1
	note __, 3
	endchannel

.sub5
	octave 4
	intensity $77
	note D#, 1
	note __, 1
	note D#, 1
	note __, 1
	note D#, 4
	note C#, 2
	intensity $37
	note C#, 2
	intensity $77
	note D#, 4
	endchannel

.sub6
	octave 2
	note C#, 4
	octave 3
	note F_, 4
	octave 2
	note C#, 4
	octave 3
	note F_, 8
	octave 2
	note C#, 4
	endchannel

.sub7
	octave 3
	note D#, 4
	note __, 4
	octave 2
	note D#, 4
	note A#, 8
	note D#, 4
	endchannel

.sub8
	intensity $b7
	note A#, 4
	intensity $57
	note A#, 4
	endchannel

Music_Route203_Ch2:
	dutycycle $0
	notetype 4, $b8
	callchannel Music_Route203_Shared_Riff
	vibrato 0, $18
	intensity $c8
	note D#, 1
	note F_, 1
	stereopanning $f0
	dutycycle $1
	notetype 16, $98
	note G_, 9
	note G_, 9
	notetype 8, $58
	note G_, 3
	note __, 1
	intensity $98
	note G_, 1
	intensity $58
	note G_, 5
	notetype 16, $98
	note F_, 11
	note F_, 11
	notetype 8, $58
	note F_, 4
	note __, 1
	octave 3
	notetype 4, $78
	note F#, 1
	note G#, 1
.mainloop
	octave 4
	notetype 16, $98
	note G_, 9
	note G_, 9
	notetype 8, $58
	note G_, 3
	note __, 1
	intensity $98
	note G_, 1
	intensity $58
	note G_, 3
	note __, 2
	intensity $98
	note F_, 14
	note D_, 12
	vibrato 0, 0
	dutycycle $1
	notetype 8, $d8
	note E_, 2
	note D_, 2
	intensity $88
	note D_, 2
	intensity $d8
	note E_, 6
	notetype 4, $94
	dutycycle $0
	octave 5
	note E_, 2
	note C#, 2
	octave 4
	note B_, 2
	note A_, 2
	note E_, 2
	note C#, 2
	note A_, 2
	note G_, 2
	note E_, 2
	note C#, 2
	octave 3
	note A_, 2
	note E_, 2
	octave 2
	notetype 12, $77
	dutycycle $3
	note B_, 12
	note __, 4
	octave 3
	note C#, 8
	note C#, 4
	octave 2
	note A#, 4
	octave 3
	note C#, 8
	octave 2
	note A#, 8
	notetype 4, $77
	note __, 4
	note B_, 4
	note __, 4
	note B_, 4
	note __, 12
	;instrument change - vibrato?
	dutycycle $3
	octave 3
	vibrato 0, $81
	notetype 8, $c8
	note D_, 2
	intensity $77
	note D_, 2
	intensity $c8
	note E_, 6
	note A_, 4
	note G_, 4
	note F#, 2
	note E_, 2
	note D_, 2
	note C#, 4
	octave 2
	note B_, 2
	intensity $77
	note B_, 2
	octave 3
	intensity $c8
	note C_, 2
	note A_, 4
	note G_, 2
	note F#, 2
	note G_, 2
	note E_, 4
	intensity $77
	note E_, 4
	note __, 2
	intensity $c8
	note D#, 2
	note E_, 2
	note F#, 2
	note E_, 2
	notetype 16, $c8
	note D#, 6
	intensity $c7
	note D#, 6
	note __, 13
	dutycycle $1
	vibrato 0, 0
	notetype 8, $c8
	note D_, 2
	note G_, 2
	note B_, 2
	note A_, 4
	note B_, 1
	note A_, 1
	note G_, 4
	note G#, 2
	note A_, 2
	note E_, 2
	intensity $78
	note E_, 2
	intensity $c8
	note E_, 2
	intensity $78
	note E_, 2
	intensity $c8
	note G_, 2
	note F#, 1
	note G_, 1
	note F#, 10
	intensity $77
	note F#, 6
	intensity $c8
	note D_, 2
	note G_, 2
	note B_, 2
	octave 4
	note C#, 4
	note D_, 1
	note C#, 1
	octave 3
	note B_, 6
	note A_, 8
	note G#, 2
	note A_, 2
	note B_, 4
	note F#, 2
	note A_, 2
	intensity $78
	note A_, 4
	intensity $c8
	note G_, 2
	octave 2
	note B_, 2
	intensity $78
	note B_, 2
	intensity $c8
	note B_, 2
	intensity $78
	note B_, 2
	octave 3
	notetype 4, $c8
	note F#, 1
	note G_, 3
	notetype 8, $a8
	note C#, 8
	octave 2
	intensity $c8
	note B_, 2
	octave 3
	note C#, 2
	note D_, 12
	note F_, 10
	note G_, 1
	note F_, 1
	note E_, 2
	note G_, 2
	notetype 16, $c8
	note A_, 10
	notetype 8, $c8
	dutycycle $2
	octave 2
	note C_, 2
	note G_, 2
	note E_, 2
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 6
	octave 3
	intensity $d8
	note A#, 6
	dutycycle $1
	note A_, 2
	note A#, 2
	octave 4
	note C_, 1
	intensity $68
	note C_, 1
	octave 3
	intensity $d8
	note B_, 1
	octave 4
	note C_, 16
	note C_, 7
	octave 3
	note A_, 2
	octave 4
	note C_, 2
	note C#, 2
	notetype 4, $d8
	note C#, 1
	note D_, 7
	notetype 8, $d8
	note C_, 2
	intensity $78
	note C_, 2
	octave 3
	intensity $d8
	note A_, 2
	note G_, 2
	note F_, 8
	note G_, 2
	note A_, 2
	note A#, 4
	note G_, 2
	note E_, 4
	note G_, 2
	intensity $78
	note G_, 2
	intensity $d8
	note G#, 2
	intensity $78
	note G#, 2
	intensity $d8
	note F_, 4
	note G#, 2
	note G_, 2
	note G#, 2
	note A#, 2
	octave 4
	notetype 4, $d8
	note D_, 1
	note D#, 7
	notetype 8, $c8
	note C#, 2
	dutycycle $0
	vibrato 0, $42
	note C_, 2
	note C#, 2
	note D#, 1
	intensity $78
	note D#, 1
	notetype 16, $c8
	note D#, 9
	notetype 8, $68
	note D#, 4
	intensity $c8
	note D#, 2
	note C_, 2
	notetype 4, $c8
	note D_, 1
	note D#, 7
	notetype 8, $c8
	note F_, 2
	intensity $68
	note F_, 2
	intensity $c8
	note D#, 2
	intensity $68
	note D#, 2
	intensity $c8
	dutycycle $1
	note C_, 2
	octave 3
	note A#, 2
	note G#, 8
	note A#, 2
	octave 4
	note C_, 2
	octave 3
	note A#, 4
	note G#, 2
	note G_, 4
	note A#, 2
	note G#, 8
	note A#, 2
	note B_, 2
	octave 4
	note C_, 2
	intensity $68
	note C_, 2
	intensity $c8
	note C#, 2
	note D#, 2
	note F_, 2
	note G_, 2
	dutycycle $2
	vibrato 0, $32
	note G#, 12
	intensity $a8
	note A#, 12
	vibrato 0, $18
	dutycycle $3
	octave 5
	notetype 16, $88
	note C_, 9
	note C_, 9
	notetype 8, $48
	note C_, 3
	note __, 1
	intensity $88
	note C_, 1
	intensity $58
	note C_, 3
	note __, 2
	notetype 16, $88
	note D_, 11
	note D_, 11
	notetype 8, $58
	note D_, 4
	note __, 2
	;drop
	octave 4
	stereopanning $f
	notetype 16, $98
	note G_, 9
	note G_, 9
	notetype 8, $58
	note G_, 4
	intensity $98
	note G_, 1
	intensity $58
	note G_, 3
	note __, 2
	notetype 16, $98
	note F_, 11
	note F_, 11
	notetype 8, $58
	note F_, 4
	note __, 2
	notetype 16, $98
	note G_, 9
	note G_, 9
	notetype 8, $58
	note G_, 3
	note __, 1
	intensity $98
	note G_, 1
	intensity $58
	note G_, 4
	note __, 1
	notetype 16, $98
	note F_, 11
	note F_, 11
	notetype 8, $58
	note F_, 3
	note __, 3
	stereopanning $f0
	jumpchannel .mainloop

Music_Route203_Shared_Riff:
	octave 4
	stereopanning $ff
	intensity $98
	note D#, 1
	note D_, 1
	intensity $88
	note C_, 1
	octave 3
	note A#, 1
	intensity $78
	note A_, 1
	note G_, 1
	note F_, 1
	note D#, 1
	note D_, 1
	note C_, 1
	octave 2
	note A#, 1
	note A_, 1
	note A#, 1
	octave 3
	note C_, 1
	note D_, 1
	note D#, 1
	note F_, 1
	intensity $88
	note G_, 1
	note A_, 1
	intensity $98
	note A#, 1
	octave 4
	note C_, 1
	note D_, 1
	endchannel

Music_Route203_Ch3:
	notetype 8, $14
	intensity $1f
	note __, 12
	octave 1
	note A#, 2
	intensity $2f
	note A#, 2
	intensity $2f
	note A#, 1
	note __, 1
	octave 2
	intensity $1f
	note A#, 4
	octave 1
	intensity $2f
	note A#, 1
	note __, 1
	callchannel .sub1
.loop1
	callchannel .sub2
	loopchannel 3, .loop1
	callchannel .sub1
.loop2
	callchannel .sub2
	loopchannel 8, .loop2
.mainloop
	intensity $1f
	note A_, 2
	octave 2
	note D_, 2
	note __, 2
	intensity $2f
	note E_, 6
	octave 1
	intensity $1f
	note A_, 9
	intensity $2f
	note A_, 3
	octave 2
	intensity $14
	note G_, 16
	note G_, 2
	note __, 6
	note G_, 12
	note A#, 6
	octave 3
	note C#, 5
	note __, 1
	octave 2
	note F#, 12
	octave 3
	note C#, 12
	octave 2
	note B_, 2
	note F#, 2
	note __, 2
	note B_, 2
	note __, 2
	octave 1
	note B_, 2
	octave 2
	note B_, 6
	note A_, 6
	octave 1
	note G_, 2
	intensity $24
	note G_, 6
	octave 2
	intensity $14
	note D_, 2
	intensity $24
	note D_, 2
	intensity $14
	note D_, 2
	note G_, 2
	intensity $24
	note G_, 2
	intensity $14
	note G_, 4
	note G#, 2
	note A_, 2
	note G#, 2
	note A_, 2
	intensity $24
	note A_, 2
	intensity $14
	note E_, 2
	intensity $24
	note E_, 2
	intensity $14
	note C#, 4
	intensity $24
	note C#, 2
	intensity $14
	note A_, 4
	note A#, 2
	note B_, 2
	octave 1
	note B_, 4
	intensity $24
	note B_, 12
	note __, 6
	octave 2
	intensity $14
	note B_, 2
	intensity $24
	note B_, 2
	intensity $14
	note B_, 2
	note __, 2
	octave 1
	note B_, 2
	intensity $24
	note B_, 2
	octave 2
	intensity $14
	note A_, 2
	intensity $24
	note A_, 2
	intensity $14
	note A_, 2
	note D#, 2
	note F#, 2
	note B_, 2
	octave 3
	note D_, 2
	note __, 2
	octave 2
	note D_, 2
	note G_, 2
	intensity $24
	note G_, 2
	intensity $14
	note D_, 2
	note G_, 2
	note __, 2
	octave 3
	note C#, 2
	intensity $24
	note C#, 4
	octave 2
	intensity $14
	note E_, 2
	note A_, 2
	intensity $24
	note A_, 8
	intensity $14
	note E_, 2
	note F#, 2
	intensity $24
	note F#, 2
	intensity $14
	note B_, 2
	intensity $24
	note B_, 4
	intensity $14
	note F#, 2
	note E_, 2
	intensity $24
	note E_, 2
	intensity $14
	note E_, 2
	intensity $24
	note E_, 6
	intensity $14
	note E_, 2
	note G_, 2
	note B_, 2
	intensity $24
	note B_, 2
	intensity $14
	note A_, 2
	note E_, 2
	note D_, 2
	intensity $24
	note D_, 2
	intensity $14
	note D_, 2
	intensity $24
	note D_, 6
	intensity $14
	note D#, 2
	intensity $24
	note D#, 2
	intensity $14
	note B_, 2
	intensity $24
	note B_, 6
	intensity $14
	note E_, 2
	intensity $24
	note E_, 4
	intensity $14
	note E_, 2
	intensity $24
	note E_, 4
	intensity $14
	note F#, 2
	intensity $24
	note F#, 4
	intensity $14
	note F#, 2
	intensity $24
	note F#, 4
	intensity $14
	note G_, 2
	intensity $24
	note G_, 4
	intensity $14
	note G_, 2
	intensity $24
	note G_, 4
	intensity $14
	note G_, 2
	intensity $24
	note G_, 4
	intensity $14
	note G_, 2
	intensity $24
	note G_, 4
.loop3
	intensity $14
	note A_, 2
	intensity $24
	note A_, 4
	loopchannel 4, .loop3
	octave 3
	intensity $14
	note E_, 8
	note D#, 2
	note E_, 2
	note G_, 6
	note C_, 6
	octave 2
	intensity $1f
	note F_, 6
	note __, 2
	note A_, 2
	note F_, 2
	note E_, 2
	note __, 8
	note E_, 2
	note D#, 2
	note __, 8
	note D#, 2
	note D_, 2
	note __, 2
	note C_, 2
	note D_, 2
	note __, 2
	note A#, 2
	note F_, 4
	note A#, 2
	note __, 4
	note D_, 2
	note C_, 4
	note G_, 2
	note __, 4
	octave 3
	note C_, 2
	note __, 4
	octave 2
	note G#, 2
	note __, 2
	note F_, 2
	note G#, 2
	note D#, 4
	note A#, 2
	note __, 4
	note G_, 2
	note D#, 6
	note __, 2
	octave 3
	note C_, 2
	octave 2
	note G#, 2
	note G_, 2
	note D#, 2
	note __, 4
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	note F#, 2
	note __, 2
	note F#, 2
	note __, 4
	note C_, 2
	note F_, 2
	note __, 2
	note F_, 2
	note F_, 2
	note __, 2
	note G#, 2
	note G#, 2
	note C#, 4
	note __, 4
	note C#, 2
	note D#, 2
	note __, 4
	note G_, 4
	note D#, 2
	note G#, 2
	note __, 2
	note F_, 2
	note C#, 4
	note __, 2
	note D#, 2
	note A#, 2
	note G_, 2
	intensity $2f
	note G_, 4
	intensity $1f
	note D#, 2
	note E_, 2
	intensity $2f
	note E_, 4
	intensity $1f
	note E_, 2
	intensity $2f
	note E_, 4
	intensity $1f
	note F#, 2
	intensity $2f
	note F#, 4
	intensity $1f
	note D#, 4
	note G_, 2
	callchannel .sub3
	intensity $1f
	note G#, 1
	note __, 1
	octave 3
	note G#, 1
	note __, 1
	octave 2
	intensity $2f
	note G#, 1
	note __, 1
	octave 3
	intensity $1f
	note G#, 4
	octave 2
	intensity $2f
	note G#, 1
	note __, 1
	intensity $1f
	callchannel .sub3
	intensity $1f
	callchannel .sub3
	octave 1
.loop4
	callchannel .sub4
	callchannel .sub1
	callchannel .sub4
	callchannel .sub4
	loopchannel 5, .loop4
.loop5
	callchannel .sub4
	loopchannel 6, .loop5
	jumpchannel .mainloop

.sub1
	intensity $1f
	note A#, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	octave 1
	intensity $2f
	note A#, 1
	note __, 1
	octave 2
	intensity $1f
	note A#, 4
	octave 1
	intensity $2f
	note A#, 1
	note __, 1
	endchannel

.sub2
	intensity $1f
	note A#, 2
	intensity $2f
	note A#, 2
	intensity $2f
	note A#, 1
	note __, 1
	octave 2
	intensity $1f
	note A#, 4
	octave 1
	intensity $2f
	note A#, 1
	note __, 1
	endchannel

.sub3
	note G#, 2
	note __, 2
	intensity $2f
	note G#, 1
	note __, 1
	octave 3
	intensity $1f
	note G#, 4
	octave 2
	intensity $2f
	note G#, 1
	note __, 1
	endchannel

.sub4
	intensity $1f
	note A#, 2
	note __, 2
	intensity $2f
	note A#, 1
	note __, 1
	octave 2
	intensity $1f
	note A#, 4
	octave 1
	intensity $2f
	note A#, 1
	note __, 1
	endchannel

Music_Route203_Ch4:
	togglenoise $5
	notetype 4
	note __, 16
	note __, 8
	callchannel .sub1
	callchannel .sub2
	callchannel .sub1
	callchannel .sub3
	callchannel .sub4
	callchannel .sub4
.mainloop
	callchannel .sub1
	callchannel .sub2
	loopchannel 2, .mainloop
	callchannel .sub4
	noisesampleset 5
	note B_, 4
	note B_, 8
	note G#, 12
	note B_, 4
	note B_, 4
	note B_, 4
	noisesampleset 1
	note F_, 12
	noisesampleset 5
	note B_, 8
	note E_, 4
	noisesampleset 1
	note F_, 12
	noisesampleset 5
	note E_, 4
	note E_, 4
	note E_, 4
	noisesampleset 1
	note F_, 8
	noisesampleset 5
	note B_, 4
	note B_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note B_, 4
	note E_, 4
	note E_, 4
	noisesampleset 1
	note F_, 8
	noisesampleset 5
	note B_, 4
	note B_, 12
	note B_, 8
	note B_, 4
	note B_, 8
	note __, 16
	note B_, 4
	noisesampleset 0
	note A_, 8
	note A_, 8
	noisesampleset 5
	note B_, 4
	note C_, 4
	note C_, 4
	note B_, 4
	noisesampleset 0
	note A_, 4
	note A_, 4
	note A_, 4
	noisesampleset 5
	callchannel .sub5
	callchannel .sub6
	note E_, 4
	note E_, 8
	note E_, 4
	note E_, 4
	note C_, 4
	note E_, 4
	callchannel .sub6
	note E_, 4
	note B_, 4
	note B_, 4
	note E_, 4
	note E_, 4
	note C_, 8
	note B_, 4
	note B_, 4
	note E_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note E_, 4
	note E_, 4
	callchannel .sub5
	note B_, 4
	note B_, 4
	note E_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note E_, 4
	note C_, 2
	note C_, 2
	callchannel .sub7
	callchannel .sub8
	note C_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note C_, 4
	noisesampleset 0
	note A_, 4
	note A_, 4
	noisesampleset 5
	note B_, 4
	callchannel .sub7
	callchannel .sub8
	note C_, 8
	note C_, 4
	callchannel .sub9
	note C_, 8
	note C_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note C_, 4
	note C_, 4
	note C_, 8
	note B_, 4
	callchannel .sub9
	note C_, 4
	note C_, 4
	note C_, 4
	noisesampleset 0
	note A_, 8
	note A_, 4
	noisesampleset 5
	note C_, 8
	note C_, 4
	callchannel .sub9
	note C_, 8
	note C_, 4
	noisesampleset 0
	note A_, 8
	noisesampleset 5
	note C_, 4
	note C_, 8
	note C_, 4
	noisesampleset 0
	note A_, 8
	noisesampleset 5
	note B_, 4
	noisesampleset 0
	note A_, 4
	note A_, 4
	noisesampleset 5
	note C_, 4
	noisesampleset 0
	note A_, 8
	noisesampleset 5
	note C_, 4
	note C_, 8
	note C_, 4
	callchannel .sub9
.loop2
	callchannel .sub10
	callchannel .sub11
	loopchannel 2, .loop2
	note B_, 4
	noisesampleset 0
	note G#, 4
	noisesampleset 5
	note C_, 4
	noisesampleset 1
	note F_, 8
	noisesampleset 5
	note F_, 4
	callchannel .sub12
	noisesampleset 5
	note B_, 4
	noisesampleset 0
	note G#, 4
	noisesampleset 5
	note C_, 4
	noisesampleset 1
	note F_, 8
	noisesampleset 5
	note F_, 4
	callchannel .sub13
	callchannel .sub10
	callchannel .sub11
	note B_, 2
	note B_, 2
	note B_, 4
	note B_, 4
	note G#, 8
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note B_, 2
	note B_, 2
	note B_, 4
	note B_, 4
	note G#, 8
	note B_, 4
.loop3
	callchannel .sub1
	callchannel .sub2
	callchannel .sub1
	callchannel .sub3
	callchannel .sub4
	callchannel .sub4
	loopchannel 3, .loop3
	jumpchannel .mainloop

.sub1
	note B_, 4
	note E_, 4
	note A_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 5
	note C_, 4
	endchannel

.sub2
	note B_, 4
	note C_, 4
	note E_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 5
	note C_, 4
	endchannel

.sub3
	note B_, 4
	note C_, 4
	note E_, 4
	note C_, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	endchannel

.sub4
	note B_, 4
	note E_, 4
	note E_, 4
	note C_, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note B_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note E_, 4
	note C_, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	endchannel

.sub5
	note B_, 4
	note E_, 4
	note E_, 2
	note E_, 2
	note E_, 4
	note C_, 4
	note E_, 4
	endchannel

.sub6
	note B_, 4
	note B_, 4
	note E_, 4
	noisesampleset 0
	note A_, 8
	noisesampleset 5
	endchannel

.sub7
	note C_, 8
	note C_, 4
	note C_, 4
	noisesampleset 0
	note A_, 4
	noisesampleset 5
	note C_, 4
	note C_, 8
	note C_, 4
.sub9
	note C_, 2
	loopchannel 6, .sub9
	endchannel

.sub8
	note C_, 4
	note C_, 4
	note C_, 4
	noisesampleset 0
	note A_, 8
	noisesampleset 5
	note C_, 4
	endchannel

.sub10
	note B_, 4
	note F_, 4
	note C_, 4
	noisesampleset 1
	note F_, 8
	noisesampleset 5
	note F_, 4
.sub12
	note E_, 2
	note E_, 2
	note E_, 4
	note E_, 4
	noisesampleset 0
	note G#, 4
	noisesampleset 5
	note E_, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 5
	endchannel

.sub11
	noisesampleset 5
	note B_, 4
	note F_, 4
	note C_, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 0
	note G#, 4
	noisesampleset 5
	note F_, 4
.sub13
	note E_, 2
	note E_, 2
	note E_, 4
	note B_, 4
	noisesampleset 0
	note A_, 4
	note G#, 4
	noisesampleset 1
	note F_, 4
	noisesampleset 5
	endchannel
