Music_BattleArcade:
	channelcount 4
	channel 1, Music_BattleArcade_Ch1
	channel 2, Music_BattleArcade_Ch2
	channel 3, Music_BattleArcade_Ch3
	channel 4, Music_BattleArcade_Ch4

Music_BattleArcade_Ch1:
	volume $77
	dutycycle $3
	stereopanning $f
	notetype 12, $a7
	tempo 126
	octave 3
	intensity $b7
	note C_, 1
	note C_, 1
	intensity $47
	note C_, 1
	note __, 1
	intensity $b7
	note C_, 1
	note C_, 1
	intensity $47
	note C_, 1
	intensity $b7
	note F_, 1
	note F_, 1
	note F_, 1
	intensity $47
	note F_, 1
	intensity $b7
	note C_, 1
	note F_, 1
	note G_, 1
	intensity $47
	note G_, 1
	octave 4
	intensity $b7
	note C_, 5
	octave 3
	note C_, 1
	intensity $47
	note C_, 1
	note __, 2
	intensity $b7
	note C_, 1
	note C_, 1
	intensity $47
	note C_, 1
	note __, 5
.mainloop
	stereopanning $f
	note __, 3
	dutycycle $0
	callchannel .sub1
	octave 2
	callchannel Music_BattleArcade_Shared_Asharp
	callchannel Music_BattleArcade_Shared_F
	note __, 2
	intensity $a7
	note D_, 1
	intensity $37
	note D_, 1
	callchannel Music_BattleArcade_Shared_Asharp
	octave 3
	callchannel Music_BattleArcade_Shared_F
	callchannel Music_BattleArcade_Shared_G
	intensity $a7
	note F_, 1
	callchannel .sub1
	callchannel Music_BattleArcade_Shared_Asharp
	octave 4
	intensity $a7
	note C#, 1
	intensity $37
	note C#, 1
	intensity $a7
	note D#, 1
	intensity $37
	note D#, 1
	octave 3
	callchannel Music_BattleArcade_Shared_Asharp
	octave 4
	intensity $a7
	note C#, 1
	intensity $37
	note C#, 1
	intensity $a7
	note C_, 8
	octave 3
	note F_, 1
	note G_, 1
	note A_, 1
	intensity $37
	note A_, 1
	callchannel Music_BattleArcade_Shared_G
	callchannel Music_BattleArcade_Shared_F
	intensity $a7
	note C_, 1
	intensity $37
	note C_, 1
	callchannel Music_BattleArcade_Shared_F
	intensity $a7
	note E_, 1
	intensity $37
	note E_, 1
	intensity $a7
	note D_, 1
	intensity $37
	note D_, 1
	dutycycle $3
	intensity $a7
	note D_, 4
	note D_, 2
	note F_, 2
	note A_, 2
	note A#, 2
	intensity $37
	note A#, 1
	callchannel Music_BattleArcade_Shared_Asharp
	note __, 3
	octave 4
	intensity $a7
	note C_, 2
	intensity $37
	note C_, 1
	intensity $a7
	note C_, 1
	intensity $37
	note C_, 1
	note __, 3
	octave 3
	intensity $a7
	note A_, 2
	intensity $37
	note A_, 1
	note __, 1
	intensity $a7
	note G_, 2
	intensity $37
	note G_, 1
	note __, 3
	intensity $a7
	note F_, 1
	note F_, 1
	note E_, 1
	note F_, 1
	intensity $37
	note F_, 1
	note __, 3
	dutycycle $0
	intensity $97
	note A#, 2
	octave 4
	note D_, 2
	note F_, 2
	note E_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 1
	octave 3
	note A#, 1
	note A_, 1
	note G_, 1
	note A_, 2
	note A#, 2
	note A_, 2
	note F_, 4
	note C_, 4
	note G_, 2
	note A_, 2
	dutycycle $3
	intensity $b7
	note F_, 1
	intensity $37
	note F_, 1
	intensity $b7
	note F_, 1
	note F_, 1
	intensity $37
	note F_, 1
	intensity $b7
	note F_, 2
	intensity $37
	note F_, 1
	intensity $b7
	note D#, 1
	intensity $37
	note D#, 1
	intensity $b7
	note D#, 1
	note D#, 1
	intensity $37
	note D#, 1
	intensity $a7
	note D#, 1
	note __, 2
	dutycycle $0
	notetype 6, $87
	note F_, 1
	note __, 3
	note F_, 8
	note F_, 1
	note __, 3
	notetype 12, $a7
	note G_, 4
	note A_, 1
	note A#, 1
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note G_, 1
	note F#, 1
	note F_, 1
	intensity $77
	note F_, 1
	note F_, 2
	intensity $a7
	note F_, 2
	intensity $77
	note F_, 1
	intensity $a7
	note F_, 3
	octave 4
	note C_, 2
	intensity $77
	note C_, 2
	octave 3
	intensity $a7
	note A_, 4
	intensity $77
	note A_, 2
	intensity $a7
	note G_, 4
	note A_, 1
	note A#, 1
	octave 4
	note C_, 2
	intensity $77
	note C_, 1
	intensity $a7
	note C_, 2
	intensity $77
	note C_, 3
	intensity $a7
	note E_, 2
	intensity $77
	note E_, 1
	intensity $a7
	note E_, 2
	note C_, 2
	octave 3
	note A#, 1
	note A_, 2
	note A#, 2
	note A_, 2
	note A#, 4
	note A_, 2
	note A#, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	octave 3
	note G_, 4
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	octave 3
	note C_, 1
	intensity $77
	note C_, 1
	intensity $a7
	note C_, 2
	note F_, 1
	intensity $77
	note F_, 1
	intensity $a7
	note F_, 2
	note C_, 1
	intensity $77
	note C_, 1
	intensity $a7
	note F_, 1
	note G_, 1
	intensity $77
	note G_, 1
	octave 4
	intensity $a7
	note C_, 9
	intensity $77
	note C_, 2
	intensity $a7
	note C_, 2
	notetype 6, $77
	note C_, 1
	note __, 1
	notetype 12, $a7
	note C_, 2
	notetype 6, $67
	note C_, 1
	note __, 1
	notetype 12, $88
	octave 3
	dutycycle $2
	note C_, 8
	note F_, 8
	note A#, 8
	octave 4
	note D_, 8
	octave 3
	note C_, 8
	note F_, 8
	note F_, 8
	note A_, 8
	note F#, 8
	note D_, 8
	note D_, 8
	note F_, 8
	note C#, 8
	note D#, 4
	note F_, 12
	octave 2
	note G_, 8
	note A_, 8
	octave 3
	note C_, 8
	note C#, 8
	note D_, 8
	note C_, 8
	octave 2
	note A_, 8
	octave 4
	note C_, 4
	octave 3
	note A_, 4
	note F_, 4
	note A_, 4
	note A_, 1
	intensity $38
	note A_, 1
	intensity $98
	note A_, 1
	intensity $38
	note A_, 1
	note __, 4
	intensity $98
	note E_, 1
	intensity $38
	note E_, 1
	intensity $98
	note E_, 1
	intensity $38
	note E_, 1
	note __, 4
	intensity $98
	note A_, 4
	note F_, 2
	note A_, 2
	intensity $38
	note A_, 1
	note __, 1
	intensity $98
	note G_, 6
	note E_, 16
	note F_, 16
	dutycycle $3
	note E_, 4
	callchannel .sub2
	jumpchannel .mainloop

.sub1
	octave 2
	notetype 6, $a7
	note __, 1
	note G#, 1
	notetype 12, $a7
	note A_, 2
	note F_, 1
	intensity $37
	note F_, 1
	note __, 2
	intensity $a7
	note C_, 1
	intensity $37
	note C_, 1
	intensity $a7
	note A_, 1
	intensity $37
	note A_, 1
	octave 3
	intensity $a7
	note F_, 1
	intensity $37
	note F_, 1
	intensity $a7
	note G_, 1
	intensity $37
	note G_, 1
	intensity $a7
	note F_, 1
	intensity $37
	note F_, 1
	endchannel

.sub2
	intensity $47
	note E_, 1
	note __, 1
	intensity $a7
	note E_, 2
	intensity $47
	note E_, 1
	note __, 1
	intensity $a7
	note E_, 1
	note E_, 1
	intensity $47
	note E_, 1
	note __, 3
	intensity $a7
	note F_, 4
	intensity $47
	note F_, 1
	note __, 1
	intensity $a7
	note F_, 2
	intensity $47
	note F_, 1
	note __, 1
	intensity $a7
	note F_, 1
	note F_, 1
	intensity $47
	note F_, 1
	note __, 3
	endchannel

Music_BattleArcade_Ch2:
	dutycycle $0
	vibrato $8, $22
	stereopanning $f0
	notetype 12, $a7
	intensity $47
	note __, 4
	octave 4
	intensity $d7
	note C_, 1
	intensity $47
	note C_, 1
	intensity $d7
	note F_, 1
	intensity $47
	note F_, 1
	note __, 2
	intensity $d7
	note C_, 1
	intensity $47
	note C_, 1
	octave 5
	intensity $d7
	note C_, 1
	note C_, 1
	octave 4
	dutycycle $1
	note C_, 1
	intensity $47
	note C_, 1
	dutycycle $0
	octave 5
	intensity $d7
	note C_, 4
	note C_, 1
	note C_, 1
	intensity $47
	note C_, 1
	note __, 1
	octave 3
	intensity $b7
	note E_, 1
	note E_, 1
	octave 4
	intensity $d7
	note C_, 1
	intensity $c7
	note C_, 1
	intensity $47
	note C_, 1
	note __, 1
.mainloop
	octave 3
	dutycycle $1
	intensity $c7
	note C_, 2
	note F_, 1
	intensity $47
	note F_, 1
	intensity $c7
	note C_, 1
	intensity $47
	note C_, 1
	callchannel Music_BattleArcade_Shared_G
	intensity $c7
	note A_, 1
	intensity $47
	note A_, 1
	note __, 2
	octave 4
	intensity $c7
	note C_, 5
	intensity $47
	note C_, 1
.loop1
	note __, 2
	octave 3
	callchannel Music_BattleArcade_Shared_Asharp
	octave 4
	intensity $c7
	note D_, 1
	intensity $47
	note D_, 1
	callchannel Music_BattleArcade_Shared_F
	callchannel Music_BattleArcade_Shared_G
	callchannel Music_BattleArcade_Shared_F
	callchannel Music_BattleArcade_Shared_Asharp
	intensity $b8
	note A_, 3
	intensity $b2
	note A_, 1
	intensity $88
	note A_, 2
	intensity $8a
	note A_, 2
	intensity $c7
	note A_, 1
	note A#, 1
	octave 5
	note C_, 4
	octave 4
	note C_, 4
	loopchannel 2, .loop1
	note D_, 1
	intensity $47
	note D_, 1
	octave 3
	intensity $c7
	note A_, 1
	intensity $47
	note A_, 1
	octave 4
	intensity $c7
	note E_, 1
	intensity $47
	note E_, 1
	intensity $c7
	note F_, 4
	note D_, 4
	note F_, 1
	intensity $97
	note A_, 1
	intensity $c7
	note F_, 8
	note E_, 6
	note F_, 1
	note G_, 1
	note A_, 2
	intensity $47
	note A_, 1
	note __, 1
	intensity $c7
	note G_, 2
	intensity $47
	note G_, 1
	note __, 1
	intensity $c7
	note F_, 2
	intensity $47
	note F_, 1
	note __, 1
	intensity $c7
	note C_, 2
	note D_, 1
	note E_, 1
	note F_, 8
	note G_, 6
	note D_, 1
	note E_, 1
	intensity $b8
	note F_, 1
	intensity $b2
	note F_, 1
	intensity $78
	note F_, 3
	intensity $7b
	note F_, 1
	intensity $b8
	note F_, 8
	intensity $b3
	note F_, 2
	intensity $47
	note F_, 1
	note __, 1
	callchannel Music_BattleArcade_Shared_F
	intensity $c7
	note F_, 1
	note F_, 1
	intensity $47
	note F_, 1
	callchannel Music_BattleArcade_Shared_F
	note __, 1
	dutycycle $0
	intensity $f7
	note C_, 2
	note D_, 1
	note C#, 1
	note C_, 2
	octave 5
	note C_, 2
	intensity $47
	note C_, 1
	note __, 1
	octave 4
	intensity $f7
	note F_, 2
	intensity $47
	note F_, 1
	note __, 1
	intensity $f7
	note C_, 2
	note G_, 4
	note F_, 1
	note G_, 1
	note E_, 2
	note C_, 2
	note D_, 2
	octave 3
	note A_, 2
	intensity $47
	note A_, 1
	note __, 1
	octave 4
	intensity $f7
	note C_, 2
	note D_, 1
	note C#, 1
	note C_, 2
	octave 5
	note C_, 2
	intensity $47
	note C_, 1
	note __, 1
	octave 4
	intensity $f7
	note F_, 2
	intensity $47
	note F_, 1
	note __, 1
	intensity $f7
	note E_, 2
	note F_, 4
	note G_, 1
	note F_, 1
	note A_, 2
	note A#, 2
	note A_, 2
	note G_, 2
	intensity $47
	note G_, 1
	note __, 1
	intensity $d7
	note F_, 4
	note E_, 1
	note F_, 1
	note C_, 4
	note F_, 2
	note E_, 4
	note F_, 2
	note G_, 2
	note A#, 2
	note A_, 2
	note G#, 2
	note G_, 2
	note F_, 4
	note E_, 1
	note F_, 1
	octave 5
	note D_, 2
	intensity $b8
	note C_, 5
	intensity $b6
	note C_, 5
	intensity $68
	note C_, 8
	intensity $6e
	note C_, 5
	intensity $b8
	note C_, 3
	intensity $c2
	note C_, 2
	intensity $c7
	note C_, 2
	note __, 1
	intensity $c7
	note C_, 2
	note __, 5
	dutycycle $3
	octave 3
	note C_, 4
	note F_, 4
	note A_, 4
	note A#, 4
	note A_, 4
	note F_, 4
	octave 4
	note D_, 4
	note C_, 4
	intensity $47
	note C_, 1
	note __, 1
	octave 3
	intensity $c7
	note F_, 2
	note F_, 4
	note C_, 2
	note G_, 2
	intensity $47
	note G_, 1
	note __, 1
	intensity $c7
	note G_, 2
	note F_, 4
	octave 4
	note C_, 4
	note D_, 4
	note D#, 4
	octave 3
	note A_, 4
	octave 4
	note C_, 4
	note D_, 2
	note C_, 2
	intensity $47
	note C_, 1
	note __, 1
	intensity $c7
	note C_, 2
	octave 3
	note A#, 4
	note A_, 4
	note A#, 4
	octave 4
	note F_, 4
	note C#, 4
	note C_, 4
	octave 3
	note A#, 4
	note A_, 4
	note G_, 4
	note F_, 4
	note G_, 2
	intensity $e7
	note F_, 6
	dutycycle $0
	note C_, 4
	note G_, 4
	note A_, 4
	note A#, 4
	note A_, 4
	note F_, 4
	octave 4
	note D_, 4
	note C_, 4
	intensity $47
	note C_, 1
	note __, 1
	intensity $e7
	note F_, 2
	note F_, 4
	note C_, 2
	note G_, 2
	intensity $47
	note G_, 1
	note __, 1
	intensity $e7
	note G_, 2
	note F_, 4
	note E_, 4
	note F_, 4
	octave 5
	note C_, 2
	intensity $47
	note C_, 1
	note __, 1
	octave 4
	intensity $e7
	note F_, 2
	intensity $47
	note F_, 1
	note __, 1
	intensity $e7
	note G_, 2
	intensity $47
	note G_, 1
	note __, 1
	intensity $e7
	note C_, 1
	intensity $47
	note C_, 1
	intensity $e7
	note F_, 4
	note G_, 2
	note A_, 2
	note A#, 2
	note A_, 2
	note C_, 2
	note F_, 2
	note G_, 1
	intensity $c8
	note F_, 4
	intensity $c7
	note F_, 7
	intensity $68
	note F_, 11
	intensity $6c
	note F_, 4
	intensity $c8
	note F_, 7
	intensity $c3
	note F_, 4
	intensity $f7
	note C_, 1
	intensity $47
	note C_, 1
	intensity $f7
	note F_, 1
	intensity $47
	note F_, 1
	note __, 2
	intensity $f7
	note C_, 1
	intensity $47
	note C_, 1
	octave 5
	intensity $f7
	note C_, 1
	note C_, 1
	octave 4
	note C_, 1
	intensity $47
	note C_, 1
	note __, 2
	intensity $f7
	note C_, 1
	intensity $47
	note C_, 1
	intensity $f7
	note F_, 1
	note F_, 1
	intensity $47
	note F_, 1
	note __, 7
	jumpchannel .mainloop

Music_BattleArcade_Shared_Asharp:
	intensity $a7
	note A#, 1
	intensity $37
	note A#, 1
	endchannel

Music_BattleArcade_Shared_F:
	intensity $a7
	note F_, 1
	intensity $37
	note F_, 1
	endchannel

Music_BattleArcade_Shared_G:
	intensity $a7
	note G_, 1
	intensity $37
	note G_, 1
	endchannel

Music_BattleArcade_Ch3:
	notetype 12, $16
	octave 2
	intensity $16
	callchannel .sub1
	callchannel .sub2
	callchannel .sub2
	intensity $16
	note C_, 2
	note G_, 2
	note G_, 2
	note C_, 2
	note C_, 2
	octave 3
	note C_, 1
	note C_, 1
	octave 2
	note C_, 2
	intensity $26
	note C_, 1
	note __, 1
	intensity $16
	note C_, 2
.mainloop
	callchannel .sub3
	note __, 11
	callchannel .sub3
	note __, 11
	callchannel .sub3
	note __, 11
	callchannel .sub3
	note __, 5
	callchannel .sub4
	callchannel .sub3
	note __, 5
	callchannel .sub4
	note D_, 2
	note D_, 2
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note D_, 2
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note D_, 2
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note D_, 2
	note G_, 2
	note G_, 2
	intensity $26
	note G_, 1
	note __, 1
	intensity $16
	note G_, 2
	callchannel .sub1
	intensity $16
	note C_, 2
	note D_, 2
	note D_, 2
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note D_, 2
	callchannel .sub1
	octave 1
	intensity $16
	note A_, 2
	note A#, 2
	note A#, 2
	intensity $26
	note A#, 1
	note __, 1
	intensity $16
	note A#, 2
	octave 2
	callchannel .sub1
	intensity $16
	note C_, 2
	callchannel .sub3
	note __, 1
	callchannel .sub2
	intensity $16
	note F_, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 2
	intensity $26
	note C_, 1
	note __, 1
.loop1
	intensity $16
	note F_, 1
	intensity $26
	note F_, 1
	loopchannel 3, .loop1
	intensity $16
	note F_, 2
	note F_, 2
	note G_, 1
	note F_, 1
	note C_, 1
	note F_, 1
	callchannel .sub5
	note F_, 4
	intensity $26
	note F_, 1
	intensity $16
	note F_, 2
	note C_, 1
	intensity $26
	note C_, 1
	note __, 1
	intensity $16
	note C_, 2
	note F_, 1
	note C_, 2
	note A_, 1
	callchannel .sub5
	note D_, 3
	note D_, 1
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note D_, 2
	intensity $26
	note D_, 1
	intensity $16
	note F_, 2
	note F_, 1
	note A_, 1
	note C_, 2
	note F_, 1
	octave 1
	note A#, 3
	note A#, 1
	intensity $26
	note A#, 1
	note __, 1
	intensity $16
	note A#, 2
	note A_, 2
	octave 2
	note C#, 1
	note E_, 2
	note A_, 2
	note G_, 1
	note D_, 4
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note D_, 2
	note G_, 2
	note G_, 2
	note B_, 1
	octave 3
	note D_, 2
	octave 2
	note G_, 1
	octave 3
	callchannel .sub1
	intensity $16
	callchannel .sub6
	note __, 1
	intensity $16
	note C_, 2
	callchannel .sub6
	intensity $16
	note C_, 1
	octave 2
	callchannel .sub6
	note __, 3
	intensity $16
	callchannel .sub6
	note __, 1
	intensity $16
	note C_, 2
	intensity $26
	note C_, 1
	intensity $16
	note C_, 2
	note C_, 1
.loop2
	callchannel .sub7
	intensity $16
	note F_, 2
	loopchannel 3, .loop2
	intensity $26
	note F_, 1
	note __, 1
	intensity $16
	note F_, 2
	note F_, 4
	intensity $26
	note F_, 1
	note __, 1
	callchannel .sub4
	note D_, 4
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note D_, 2
	intensity $26
	note D_, 1
	note __, 1
	intensity $16
	note F#, 2
	intensity $26
	note F#, 1
	note __, 1
	intensity $16
	note F#, 2
	note G_, 4
	intensity $26
	note G_, 1
	note __, 1
	intensity $16
	note G_, 2
	intensity $26
	note G_, 1
	note __, 1
	intensity $16
	note G_, 2
	intensity $26
	note G_, 1
	note __, 1
	intensity $16
	note D_, 2
	notetype 6, $16
	note D#, 4
	note D#, 4
	note G_, 4
	note G_, 4
	note A#, 4
	note A#, 4
	octave 3
	note C#, 4
	note C#, 4
	notetype 12, $16
	note C_, 6
	octave 2
	note C_, 4
	note C_, 4
	note G_, 2
	note F_, 6
	note C_, 2
	note F_, 4
	note F_, 2
	octave 3
	note C_, 2
	octave 2
	note F_, 6
	octave 1
	note A#, 4
	octave 2
	note F_, 4
	note A#, 2
	note A_, 2
	octave 3
	note C_, 2
	octave 2
	note F_, 2
	octave 3
	note C_, 4
	note C_, 2
	octave 2
	note F_, 2
	note A_, 2
	note A#, 4
	octave 3
	note D_, 2
	octave 2
	note F_, 4
	note F_, 2
	note C_, 2
	note F_, 2
	note A#, 2
	note A#, 2
	intensity $26
	note A#, 1
	note __, 3
	intensity $16
	note A_, 2
	note A_, 2
	intensity $26
	note A_, 1
	note __, 3
	intensity $16
	note G_, 4
	note A_, 2
	note A#, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 2
	note G_, 2
	note C_, 2
	callchannel .sub7
	intensity $16
	note C_, 2
	callchannel .sub7
	octave 1
	intensity $16
	note A#, 2
	octave 2
	callchannel .sub7
	intensity $16
	note F_, 2
	callchannel .sub7
	intensity $16
	note F_, 2
	jumpchannel .mainloop

.sub1
	note C_, 2
	note C_, 2
	intensity $26
	note C_, 1
	note __, 1
	endchannel

.sub2
	intensity $16
	note C_, 2
	intensity $26
	note C_, 1
	note __, 1
	endchannel

.sub3
	intensity $16
	note F_, 2
	note F_, 2
	intensity $26
	note F_, 1
	endchannel

.sub4
	intensity $16
	note F_, 2
	intensity $26
	note F_, 1
	note __, 1
	intensity $16
	note F_, 2
	endchannel

.sub5
	note A#, 2
	intensity $26
	note A#, 1
	note __, 1
	octave 1
	intensity $16
	note A#, 3
	note A#, 1
	octave 2
	note C_, 2
	note C_, 2
	note G_, 1
	note C_, 2
	note C_, 1
	endchannel

.sub6
	note C_, 1
	note C_, 1
	intensity $26
	note C_, 1
	endchannel

.sub7
	note F_, 4
	intensity $26
	note F_, 1
	note __, 1
	intensity $16
	note F_, 2
	intensity $26
	note F_, 1
	note __, 1
	intensity $16
	note F_, 2
	intensity $26
	note F_, 1
	note __, 1
	endchannel

Music_BattleArcade_Ch4:
	togglenoise 3
	notetype 12
	note B_, 2
	note D#, 2
	note D#, 2
	callchannel .sub1
	note D#, 2
	callchannel .sub1
	callchannel .sub1
	noisesampleset 3
	note C_, 2
	noisesampleset 1
	note C_, 2
	note C_, 2
	note C_, 2
	noisesampleset 3
	note B_, 2
	noisesampleset 1
	note C_, 2
.mainloop
	noisesampleset 3
	note D#, 2
	noisesampleset 1
	note C_, 4
	note C_, 4
	note C_, 2
	noisesampleset 3
	note F_, 2
	noisesampleset 1
	note C_, 2
	loopchannel 4, .mainloop
	callchannel .sub2
	noisesampleset 1
	note C_, 1
	note B_, 1
	noisesampleset 3
	note D#, 2
	noisesampleset 1
	note C_, 2
	note B_, 2
	note C_, 2
	note B_, 1
	note B_, 1
	note C_, 1
	noisesampleset 3
	note D#, 1
	note F_, 2
	noisesampleset 1
	note C_, 2
	callchannel .sub2
	noisesampleset 1
	note C_, 2
.loop1
	noisesampleset 3
	note F_, 2
	noisesampleset 1
	note C_, 2
	loopchannel 3, .loop1
	noisesampleset 3
	note C_, 1
	note C_, 1
	noisesampleset 1
	note C_, 2
	noisesampleset 3
	note F_, 1
	note F_, 1
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 1
	note D#, 2
	stereopanning $f
	note D#, 2
	noisesampleset 1
	note A_, 1
	noisesampleset 3
	note C_, 1
	stereopanning $ff
	note D#, 1
	callchannel .sub3
	noisesampleset 3
	note D#, 2
	note D#, 2
	callchannel .sub1
	noisesampleset 1
	stereopanning $f
	note A_, 1
	note A_, 1
	stereopanning $ff
	noisesampleset 3
	note D#, 1
	note C_, 1
	noisesampleset 1
	note F_, 2
	note D#, 1
	note D#, 1
	callchannel .sub3
	noisesampleset 3
	note D#, 2
	note D#, 2
	note C_, 1
	note C_, 1
	stereopanning $f0
	note D#, 1
	stereopanning $ff
	note D#, 1
	note C_, 1
	note D#, 2
	note D#, 1
	callchannel .sub1
	noisesampleset 3
	note D#, 2
	note D#, 2
	note C_, 1
	note D#, 1
	stereopanning $f0
	note D#, 1
	stereopanning $ff
	note D#, 1
	note D#, 2
	note D#, 2
	note C_, 1
	note D#, 1
	stereopanning $f0
	note D#, 1
	stereopanning $ff
	note D#, 1
	note D#, 2
	note D#, 2
	callchannel .sub1
	note C_, 1
	noisesampleset 3
	note C_, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	stereopanning $f0
	note D#, 1
	stereopanning $ff
	noisesampleset 3
	note C_, 1
	noisesampleset 1
	note C#, 2
	noisesampleset 3
	note D#, 2
	noisesampleset 1
	stereopanning $f0
	note A_, 1
	note A_, 1
	stereopanning $ff
	noisesampleset 3
	note D#, 1
	stereopanning $f0
	note D#, 1
	stereopanning $ff
	note D#, 2
	note D#, 2
	note C_, 1
	note C_, 1
	note D#, 2
	note D#, 2
	stereopanning $f0
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	stereopanning $ff
	note D#, 2
	note C_, 1
	note D#, 1
.loop2
	noisesampleset 1
	note C#, 2
	noisesampleset 3
	note D#, 1
	loopchannel 2, .loop2
	noisesampleset 1
	note C#, 2
	noisesampleset 3
	note D#, 2
	callchannel .sub1
	noisesampleset 1
	note A#, 2
	noisesampleset 3
	note D#, 2
	callchannel .sub1
	callchannel .sub4
	callchannel .sub5
	noisesampleset 3
	note E_, 2
	stereopanning $f0
	note D#, 2
	stereopanning $ff
	note D#, 2
	callchannel .sub1
	note D#, 2
	noisesampleset 3
	note C_, 2
	note C_, 2
	noisesampleset 1
.loop3
	noisesampleset 3
	note A#, 2
	note A#, 2
	note D_, 2
	note A#, 2
	note D_, 2
	note A#, 2
	note D_, 2
	note A#, 2
	loopchannel 2, .loop3
	noisesampleset 3
	note A#, 2
	note A#, 2
	note D_, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note D_, 2
	note A#, 2
	noisesampleset 1
	note C_, 2
	note C_, 2
	noisesampleset 3
	note D#, 2
	note D#, 2
	note C_, 1
	note C_, 1
	note D#, 2
	note B_, 4
	noisesampleset 1
	callchannel .sub5
	callchannel .sub4
	callchannel .sub5
	callchannel .sub4
	noisesampleset 3
	note C_, 2
	note C_, 2
	note B_, 4
	note C_, 2
	note C_, 2
	note B_, 4
	note C_, 2
	note B_, 4
	noisesampleset 1
	stereopanning $f
	note A_, 4
	note A_, 2
	noisesampleset 3
	stereopanning $f0
	note D#, 1
	note D#, 1
	stereopanning $f
	note D#, 2
	stereopanning $ff
.loop4
	noisesampleset 3
	note D#, 2
	note D#, 2
	stereopanning $f0
	note F#, 2
	stereopanning $ff
	note D#, 2
	loopchannel 4, .loop4
.loop5
	noisesampleset 3
	note D#, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note C_, 1
	note C_, 1
	note D#, 2
	loopchannel 2, .loop5
	jumpchannel .mainloop

.sub1
	noisesampleset 3
	note C_, 2
	note D#, 2
	endchannel

.sub2
	noisesampleset 3
	note D#, 2
	noisesampleset 1
	note C_, 2
	note B_, 2
	note C_, 2
	note B_, 2
	note C_, 2
	noisesampleset 3
	note F_, 1
	noisesampleset 1
	note B_, 1
	note C_, 1
	noisesampleset 3
	note D#, 1
	noisesampleset 3
	note D#, 2
	noisesampleset 1
	note C_, 2
	note B_, 2
	note C_, 2
	note B_, 2
	note C_, 2
	noisesampleset 3
	note F_, 2
	endchannel

.sub3
	noisesampleset 3
	note D#, 4
	note F_, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note C_, 1
	note D#, 1
	stereopanning $f0
	note D#, 1
	stereopanning $ff
	note D#, 1
	endchannel

.sub4
	noisesampleset 3
	note E_, 2
	stereopanning $f0
	note D#, 2
	stereopanning $ff
	note C_, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D#, 2
	endchannel

.sub5
	noisesampleset 3
	note B_, 2
	note D#, 2
	note C_, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note C_, 2
	note D#, 2
	endchannel
