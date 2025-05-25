Music_BattleTowerBattleRoom:
	channelcount 4
	channel 1, Music_BattleTowerBattleRoom_Ch1
	channel 2, Music_BattleTowerBattleRoom_Ch2
	channel 3, Music_BattleTowerBattleRoom_Ch3
	channel 4, Music_BattleTowerBattleRoom_Ch4

Music_BattleTowerBattleRoom_Ch1:
	tempo 160
	volume $77
	tone $0001
	vibrato $12, $34
	stereopanning $f
	notetype $6, $94
.loop
	note __, 16
	note __, 16
	note __, 12
	note __, 12
	dutycycle $2
	octave 3
	note C_, 2
	note E_, 2
	note G_, 4
	callchannel .sub
	note C_, 4
	note __, 4
	intensity $92
	note G_, 2
	note F_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	octave 4
	note E_, 2
	note G_, 2
	note E_, 2
	octave 3
	note G_, 2
	note E_, 2
	intensity $94
	callchannel .sub
	octave 2
	note A#, 4
	note __, 4
	intensity $92
	octave 3
	note G_, 2
	note D#, 2
	note C_, 2
	note F_, 2
	note A_, 2
	octave 4
	note C_, 2
	note F_, 2
	note C_, 2
	octave 3
	note A_, 2
	note F_, 2
	intensity $93
	note D_, 2
	note __, 2
	note E_, 4
	note F_, 4
	note G_, 2
	note A_, 2
	note A#, 8
	octave 2
	note A#, 8
	octave 3
	note C_, 2
	note __, 2
	note D_, 4
	note E_, 4
	note F_, 2
	note G_, 2
	note A_, 8
	octave 2
	note A_, 8
	note A#, 2
	note __, 2
	octave 3
	note C_, 4
	note D_, 4
	note D#, 2
	note F_, 2
	note D#, 4
	note F_, 4
	note G_, 4
	note A#, 4
	octave 4
	note C_, 2
	note __, 2
	octave 3
	note F_, 4
	note __, 4
	octave 2
	note A_, 2
	octave 3
	note C_, 2
	note E_, 4
	note __, 4
	dutycycle $3
	note C_, 2
	note E_, 2
	note G_, 4
	note A_, 4
	note F_, 8
	note F_, 2
	note G_, 2
	note A_, 8
	note G_, 4
	note F_, 4
	note D_, 8
	note A#, 2
	note D_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	note A_, 2
	note A#, 2
	octave 4
	note C_, 2
	note D_, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note F_, 4
	octave 3
	note F_, 8
	note C#, 2
	note D#, 2
	note F_, 8
	note G_, 4
	note F_, 4
	note F_, 4
	note C_, 8
	note G_, 2
	note F_, 2
	note E_, 8
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	note G_, 2
	note E_, 2
	note C_, 4
	note F_, 8
	note C_, 2
	note F_, 2
	note A_, 8
	note A#, 4
	octave 4
	note C_, 4
	octave 3
	note A#, 4
	note F_, 8
	note A#, 4
	octave 4
	note D_, 8
	octave 3
	note A#, 2
	note A_, 2
	note F_, 4
	note G#, 4
	note F_, 8
	note G#, 4
	note F_, 4
	note D#, 4
	note C#, 4
	note F_, 4
	intensity $94
	octave 4
	note C_, 4
	octave 3
	note E_, 6
	note __, 2
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 4
	note __, 12
	jumpchannel .loop

.sub
	note A_, 2
	note __, 2
	note C_, 4
	note __, 4
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note C_, 4
	note F_, 4
	note __, 4
	note A_, 4
	note G_, 2
	note __, 2
	endchannel

Music_BattleTowerBattleRoom_Ch2:
	vibrato $12, $34
.loop
	dutycycle $3
	notetype $6, $b8
	octave 3
	note F_, 2
	note __, 2
	octave 2
	note A_, 4
	note __, 4
	octave 3
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	octave 2
	note A_, 4
	octave 3
	note F_, 4
	note __, 4
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note F_, 2
	note __, 2
	octave 2
	note A_, 4
	note __, 4
	tone $0001
	note A_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	note F_, 4
	note __, 4
	tone 0
	intensity $b7
	note G_, 2
	octave 4
	note C_, 2
	note E_, 4
	callchannel .sub
	note A#, 4
	note __, 2
	note F_, 2
	notetype $c, $b7
	note C_, 12
	notetype $6, $b7
	callchannel .sub
	notetype $c, $b7
	note A#, 2
	note __, 1
	note G_, 1
	note A_, 12
	note A#, 1
	note __, 1
	note A#, 4
	note G_, 1
	note A_, 1
	note A#, 4
	note D_, 4
	note A_, 1
	note __, 1
	note A_, 4
	note G_, 1
	note A_, 1
	note F_, 8
	note G_, 1
	note __, 1
	note G_, 4
	note A#, 1
	note A_, 1
	note A#, 4
	note D#, 4
	note F_, 1
	note __, 1
	note F_, 4
	note G_, 1
	note F_, 1
	note E_, 8
	stereopanning $f0
	dutycycle $2
	note F_, 6
	note A_, 1
	note A#, 1
	octave 5
	note C_, 4
	octave 4
	note A#, 2
	note A_, 2
	note A#, 16
	note A#, 6
	note G_, 1
	note A_, 1
	note A#, 4
	octave 5
	note C_, 2
	octave 4
	note A#, 2
	note A_, 6
	note A#, 1
	note A_, 1
	note G_, 8
	note A_, 6
	note F_, 1
	note A_, 1
	octave 5
	note C_, 4
	note D_, 2
	note D#, 2
	note D_, 6
	note C_, 2
	octave 4
	note A#, 8
	octave 5
	note C#, 6
	note C_, 2
	octave 4
	note A#, 2
	note G#, 2
	note F_, 2
	note G#, 2
	note G_, 5
	note __, 1
	notetype $6, $b7
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 4
	note __, 4
	stereopanning $ff
	dutycycle $3
	octave 3
	note C_, 2
	note D_, 2
	note E_, 4
	jumpchannel .loop

.sub
	note F_, 2
	note __, 2
	note F_, 8
	note C_, 2
	note F_, 2
	octave 5
	note C_, 8
	octave 4
	note A#, 4
	note A_, 4
	endchannel

Music_BattleTowerBattleRoom_Ch3:
	vibrato $12, $34
	notetype $6, $16
.loop
	stereopanning $ff
	callchannel .sub
	note C_, 2
	note __, 2
	note F_, 4
	note __, 4
	octave 2
	note A_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	note F_, 4
	note __, 4
	stereopanning $f0
	note C_, 8
	callchannel .sub
	note C_, 2
	note __, 2
	note F_, 4
	note __, 4
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note E_, 4
	note C_, 4
	note __, 4
	note C_, 2
	note __, 2
	callchannel .sub
	octave 2
	note A#, 2
	note __, 2
	octave 3
	note D#, 4
	note __, 4
	octave 2
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	octave 3
	note C_, 4
	note F_, 4
	note __, 4
	note C_, 1
	note __, 1
	note C_, 2
	octave 2
	note A#, 2
	note __, 2
	note A#, 4
	note F_, 4
	octave 3
	note F_, 1
	note __, 1
	note F_, 2
	octave 2
	note A#, 2
	note __, 2
	octave 3
	note D_, 2
	note __, 2
	note F_, 8
	note C_, 2
	note __, 2
	note C_, 4
	octave 2
	note F_, 4
	octave 3
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note C_, 2
	note __, 2
	note F_, 8
	note D#, 2
	note __, 2
	note D#, 4
	octave 2
	note G_, 4
	octave 3
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	octave 2
	note G_, 2
	note __, 2
	note A#, 2
	note __, 2
	octave 3
	note D#, 8
	note F_, 2
	note __, 2
	note C_, 4
	note __, 4
	note C_, 2
	octave 2
	note F_, 2
	note G_, 4
	note __, 4
	stereopanning $ff
	note G_, 2
	octave 3
	note C_, 2
	note E_, 4
	note F_, 4
	note C_, 8
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A_, 4
	note C_, 6
	note __, 2
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note F_, 4
	note D_, 8
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A#, 4
	note A_, 4
	note F_, 4
	note D_, 4
	note F_, 4
	note C#, 8
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A#, 4
	note F_, 8
	note C#, 1
	note __, 1
	note C#, 1
	note __, 1
	note C_, 4
	note F_, 8
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note G_, 4
	note C_, 4
	note D_, 4
	note E_, 4
	note F_, 4
	note C_, 8
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A_, 4
	note C_, 8
	note F_, 2
	note __, 2
	note F_, 4
	octave 2
	note A#, 8
	octave 3
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note A#, 4
	octave 2
	note A#, 4
	octave 3
	note D_, 4
	note E_, 4
	note F_, 4
	octave 2
	note G#, 8
	octave 3
	note C#, 1
	note __, 1
	note C#, 1
	note __, 1
	note G#, 4
	octave 2
	note G#, 8
	octave 3
	note C#, 4
	note C_, 4
	note G_, 8
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note G_, 4
	note __, 12
	jumpchannel .loop

.sub
	octave 3
	note C_, 2
	note __, 2
	note F_, 4
	note __, 4
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note F_, 4
	note C_, 4
	note __, 4
	note C_, 2
	note __, 2
	endchannel

Music_BattleTowerBattleRoom_Ch4:
	togglenoise $3
	notetype $c
.loop
	callchannel .sub1
	callchannel .sub2
	note D_, 4
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	callchannel .sub1
	callchannel .sub3
	callchannel .sub1
.repeat1
	callchannel .sub3
	callchannel .sub2
	callchannel .sub4
	loopchannel 2, .repeat1
	callchannel .sub2
	note D_, 8
.repeat2
	callchannel .sub5
	callchannel .sub6
	loopchannel 3, .repeat2
	callchannel .sub5
	note D_, 4
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	jumpchannel .loop

.sub1
	note D_, 2
	note D_, 4
	note D_, 1
	note D_, 1
.sub2
	note D_, 2
	note D_, 4
	note D_, 1
	note D_, 1
	endchannel

.sub3
	note D_, 2
	note D_, 4
	note D_, 1
	note D_, 1
.sub6
	note D_, 2
	note D_, 2
	note D_, 1
	note C#, 1
	note D_, 1
	note C#, 1
	endchannel

.sub5
	note D_, 2
	note C#, 2
	note D_, 2
	note D_, 1
	note C#, 1
	note D_, 2
	note C#, 2
	note D_, 2
	note D_, 1
	note C#, 1
.sub4
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 1
	note D_, 1
	endchannel
