Music_BattleArcadeBattle:
	channelcount 3
	channel 1, Music_BattleArcadeBattle_Ch1
	channel 2, Music_BattleArcadeBattle_Ch2
	channel 3, Music_BattleArcadeBattle_Ch3

Music_BattleArcadeBattle_Ch1:
	tempo 102
	dutycycle $3
	notetype $c, $b4
	vibrato $11, $12
.repeat1
	octave 3
	note G_, 2
	note C_, 1
	octave 4
	note C_, 1
	loopchannel 4, .repeat1
	octave 3
.repeat2
	note F_, 2
	octave 2
	note A#, 1
	octave 3
	note A#, 1
	loopchannel 3, .repeat2
	note F_, 2
	octave 2
	note A#, 2
	note G_, 6
	note G#, 6
	note A#, 4
	note G_, 2
	note A#, 4
	note G#, 6
	note F_, 4
	octave 3
	note G_, 6
	note G#, 6
	note A#, 4
	note G_, 2
	note A#, 4
	note G#, 6
	note F_, 4
	callchannel .sub1
	note C_, 2
	note G_, 2
	note C#, 2
	note F_, 2
	callchannel .sub1
	note F_, 2
	octave 4
	note C_, 2
	note C#, 4
.loop
	stereopanning $f
	octave 3
	callchannel .sub2
	note G#, 12
	note G#, 2
	note G_, 2
	note F_, 8
	note A#, 8
	callchannel .sub2
	octave 4
	note C#, 12
	note C#, 2
	note C_, 2
	note C#, 8
	note D#, 8
	note C_, 6
	octave 3
	note A#, 10
	note E_, 6
	note C_, 10
	note D_, 8
	octave 2
	note A#, 4
	octave 3
	note D_, 4
	note F_, 4
	note G_, 4
	note A#, 4
	octave 4
	note D_, 4
	octave 3
	note C_, 10
	octave 2
	note C_, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 2
	octave 3
	note C_, 2
	octave 2
	note C_, 4
	note C_, 4
	octave 3
	note C_, 2
	note C_, 2
	note C_, 2
	note D_, 8
	octave 2
	note A#, 4
	octave 3
	note D_, 4
	note F_, 4
	note A#, 4
	octave 4
	note F_, 4
	note D_, 4
	note E_, 12
	note D_, 4
	note C_, 16
	dutycycle $2
	intensity $84
	vibrato $0, $0
.repeat3
	callchannel .sub3
	callchannel .sub3
	callchannel .sub4
	callchannel .sub4
	loopchannel 2, .repeat3
	dutycycle $3
	intensity $b4
	vibrato $11, $12
	octave 2
	callchannel Music_BattleArcadeBattle_Common_1
	callchannel Music_BattleArcadeBattle_Common_2
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 4
	note D_, 2
	note D_, 2
	note D_, 2
	note E_, 2
	note E_, 2
	note E_, 2
	note E_, 4
	note E_, 2
	note E_, 2
	note G_, 1
	note B_, 1
	callchannel .sub5
	forceoctave $1b
	callchannel .sub5
	forceoctave 2
	callchannel .sub5
	forceoctave 0
	callchannel .sub5
.repeat4
	octave 4
	note C_, 6
	note C#, 10
	octave 3
	note G_, 6
	note G#, 6
	note C#, 4
	loopchannel 2, .repeat4
	octave 4
	note C_, 6
	note C#, 6
	note G_, 4
	octave 3
	note G_, 6
	note G#, 6
	octave 5
	note C#, 4
	note C_, 2
	octave 3
	note C_, 4
	octave 5
	note C#, 2
	octave 3
	note C#, 4
	octave 4
	note G_, 4
	octave 5
	note C_, 2
	octave 2
	note G_, 4
	octave 5
	note C#, 2
	octave 2
	note G#, 4
	octave 4
	note A#, 3
	note __, 1
	jumpchannel .loop

.sub1
	note G_, 2
	note C_, 2
	note F_, 2
	note A#, 2
	note G_, 2
	note C_, 2
	note G#, 2
	note C_, 2
	note G_, 2
	note C#, 2
	note F_, 2
	note A#, 2
	endchannel

.sub2
	note C_, 6
	note G_, 6
	note F_, 4
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note E_, 2
	note F_, 2
	note G_, 2
	endchannel

.sub3
	note F_, 2
	note C_, 2
	note F_, 2
	note A_, 2
	octave 5
	note C_, 2
	octave 4
	note A_, 2
	note F_, 2
	note C_, 2
	endchannel

.sub4
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	note E_, 2
	note C_, 2
	endchannel

.subrepeat
	note F_, 2
.sub5
	octave 3
	note F_, 2
	octave 2
	note F_, 2
	loopchannel 3, .subrepeat
	endchannel

Music_BattleArcadeBattle_Ch2:
	dutycycle $1
	notetype $c, $c7
	octave 5
	note C_, 1
	octave 4
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
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	callchannel .sub
	note C#, 4
	callchannel .sub
	note C#, 4
	octave 4
	callchannel .sub
	note C#, 4
	octave 5
	callchannel .sub
	octave 4
	note G_, 4
.loop
	stereopanning $f0
	note F_, 8
	note D#, 5
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 6
	note C_, 2
	intensity $57
	note C_, 2
	intensity $c7
	note C_, 2
	note F_, 2
	note G_, 2
	note G#, 4
	note A#, 2
	note G#, 2
	note G_, 4
	note G#, 2
	note G_, 2
	note F_, 5
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 2
	note D#, 2
	note C#, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 8
	octave 3
	note A#, 8
	octave 4
	note D_, 6
	octave 3
	note G_, 2
	intensity $57
	note G_, 2
	intensity $c7
	note G_, 2
	octave 4
	note F_, 2
	note G_, 2
	note G#, 4
	note A#, 1
	note G#, 1
	note G_, 1
	note G#, 1
	note G_, 4
	note F_, 1
	note E_, 1
	note G_, 1
	note G#, 1
	note A#, 8
	note G#, 8
	note G_, 10
	intensity $c3
	note G_, 2
	note G_, 2
	note G_, 2
	intensity $c7
	note G_, 4
	intensity $b7
	note F_, 2
	intensity $97
	note G_, 2
	intensity $87
	note A#, 4
	intensity $77
	octave 5
	note D_, 2
	intensity $57
	note F_, 2
	intensity $c7
	octave 4
	note A#, 8
	note D_, 8
	note F_, 6
	note A#, 4
	note A_, 2
	note G_, 2
	note F_, 2
	note E_, 4
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note C#, 1
	note C_, 4
	note G_, 4
	note G_, 2
	note A#, 2
	note G_, 4
	note G_, 4
	note A#, 8
	note D_, 8
	note F_, 6
	note A#, 4
	note D_, 2
	note F_, 2
	note A#, 2
	octave 5
	note C_, 8
	octave 4
	note C_, 5
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 6
	note A#, 2
	octave 5
	note C_, 4
	octave 4
	note E_, 4
	note C_, 6
	octave 3
	note A_, 14
	octave 4
	note C_, 4
	octave 3
	note A_, 4
	octave 4
	note C_, 4
	octave 3
	note A#, 6
	octave 4
	note F_, 14
	octave 3
	note A#, 4
	octave 4
	note F_, 4
	note D_, 4
	note C_, 6
	octave 3
	note A_, 14
	octave 4
	note C_, 4
	note E_, 2
	note D_, 2
	note C_, 2
	note E_, 2
	note D_, 2
	octave 3
	note A#, 4
	octave 4
	note F_, 10
	note G_, 6
	note F_, 3
	note __, 1
	note F_, 2
	note D_, 4
	intensity $c4
	vibrato $11, $12
	callchannel Music_BattleArcadeBattle_Common_1
	callchannel Music_BattleArcadeBattle_Common_2
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 4
	note D_, 2
	note D_, 2
	note D_, 2
	callchannel Music_BattleArcadeBattle_Common_2
	octave 5
	callchannel Music_BattleArcadeBattle_Common_1
	callchannel Music_BattleArcadeBattle_Common_2
	note G_, 2
	note G_, 2
	note G_, 2
	note G_, 4
	note G_, 2
	note G_, 2
	note G_, 2
	callchannel Music_BattleArcadeBattle_Common_1
	intensity $c7
	vibrato $0, $0
	octave 4
	note G_, 4
	note C_, 2
	note G#, 4
	note G#, 2
	octave 3
	note G_, 2
	note G_, 2
	octave 4
	note E_, 4
	octave 3
	note G#, 2
	octave 4
	note F_, 4
	note F_, 2
	octave 3
	note G#, 2
	note G#, 2
	octave 4
	note G_, 4
	note C_, 2
	note G#, 4
	note G#, 2
	note C_, 2
	note C_, 2
	note G_, 4
	note C_, 2
	note G#, 4
	note G#, 2
	note F_, 2
	note F_, 2
	octave 5
	note C_, 4
	octave 4
	note G_, 2
	octave 5
	note C#, 4
	note C#, 2
	octave 4
	note C_, 2
	note C_, 2
	note G_, 4
	note C_, 2
	note G#, 4
	note G#, 2
	note C#, 2
	note C#, 2
.repeat
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	loopchannel 2, .repeat
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 1
	note G#, 1
	note A#, 1
	jumpchannel .loop

.sub
	note C_, 6
	note D#, 6
	note C#, 4
	note C_, 2
	note C#, 4
	note D#, 6
	endchannel

Music_BattleArcadeBattle_Common_1:
	note F_, 2
	note F_, 2
	note F_, 2
	note F_, 4
	note F_, 2
	note F_, 2
	note F_, 2
	endchannel

Music_BattleArcadeBattle_Common_2:
	note E_, 2
	note E_, 2
	note E_, 2
	note E_, 4
	note E_, 2
	note E_, 2
	note E_, 2
	endchannel

Music_BattleArcadeBattle_Ch3:
	notetype $c, $19
	octave 3
	note C_, 16
	note C#, 16
.repeat1
	note C_, 2
	note G_, 2
	note F_, 2
	note D#, 2
	note F_, 2
	note D#, 2
	note C#, 2
	note D#, 2
	loopchannel 8, .repeat1
.loop
	note C_, 4
	note D#, 2
	note G_, 2
	callchannel .sub1
	note C_, 2
	note G_, 2
	note F_, 2
	note G#, 2
.repeat2
	note C#, 2
	note G#, 2
	note F_, 2
	note G#, 2
	loopchannel 3, .repeat2
	note C#, 2
	note G#, 2
	note G_, 2
	note G#, 2
	callchannel .sub1
	callchannel .sub1
.repeat3
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	note C#, 2
	note F_, 2
	loopchannel 3, .repeat3
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	octave 2
	note A_, 2
	octave 3
	note D#, 2
.repeat4
	octave 2
	note G_, 2
	octave 3
	note D_, 2
	octave 2
	note A#, 2
	octave 3
	note D_, 2
	loopchannel 4, .repeat4
	callchannel .sub2
	callchannel .sub2
	octave 2
	callchannel .sub3
	octave 2
	note A_, 2
	note A_, 2
	octave 3
	callchannel .sub4
	note D_, 2
	note D_, 2
	octave 2
	note G#, 2
	note G#, 2
	callchannel .sub3
	note D_, 2
	note D_, 2
	callchannel .sub4
	note G_, 2
	note E_, 2
	note F_, 2
	note D_, 2
	callchannel .sub5
	callchannel .sub6
	callchannel .sub5
.repeat5
	octave 2
	note A_, 2
	octave 3
	note F_, 2
	loopchannel 4, .repeat5
.repeat6
	note C_, 2
	note F_, 2
	loopchannel 4, .repeat6
	callchannel .sub6
.repeat7
	note D_, 2
	note G_, 2
	loopchannel 4, .repeat7
.repeat8
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	loopchannel 4, .repeat8
	callchannel .sub7
	note C_, 2
	octave 4
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note G_, 2
	octave 2
	note G_, 2
	octave 3
	note G#, 2
	octave 2
	note G#, 2
	octave 3
	note G#, 2
	callchannel .sub8
	callchannel .sub7
	note C_, 2
	note G_, 2
	callchannel .sub7
	note C#, 2
	note A#, 2
	jumpchannel .loop

.sub1
	note C_, 2
	note G_, 2
	note D#, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note D#, 2
	note G_, 2
	endchannel

.sub2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	loopchannel 8, .sub2
.repeatX
	note C_, 2
	note G_, 2
	loopchannel 8, .repeatX
	endchannel

.sub3
	note A_, 3
	note __, 1
	note A_, 2
	octave 3
	note C_, 3
	note __, 1
	note C_, 2
	note C_, 2
	octave 2
	note A_, 3
	note __, 1
	note A_, 2
	octave 3
	note C_, 2
	note C_, 2
	endchannel

.sub4
	note C_, 2
	note C_, 2
	octave 2
	note A#, 3
	note __, 1
	note A#, 2
	octave 3
	note F_, 3
	note __, 1
	note F_, 2
	note F_, 2
	octave 2
	note A#, 3
	note __, 1
	note A#, 2
	octave 3
	note F_, 2
	note F_, 2
	endchannel

.sub5
	note C_, 2
	note F_, 2
	loopchannel 4, .sub5
.repeatY
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	loopchannel 4, .repeatY
.repeatZ
	octave 2
	note G_, 2
	octave 3
	note D_, 2
	loopchannel 4, .repeatZ
	endchannel

.sub6
	octave 2
	note A_, 2
	octave 3
	note E_, 2
	loopchannel 4, .sub6
	endchannel

.sub7
	note C_, 2
	octave 4
	note C_, 2
	octave 3
	note C_, 2
	octave 4
	note C#, 2
	octave 3
.sub8
	note C#, 2
	octave 4
	note C#, 2
	octave 3
	endchannel
