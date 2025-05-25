Music_LookRocket:
	channelcount 4
	channel 1, Music_LookRocket_Ch1
	channel 2, Music_LookRocket_Ch2
	channel 3, Music_LookRocket_Ch3
	channel 4, Music_LookRocket_Ch4

Music_LookRocket_Ch1:
	tempo 123
	volume $77
	forceoctave $2
	stereopanning $f
	dutycycle $3
	vibrato $5, $64
	notetype $c, $a8
	octave 4
	note C_, 1
	note D_, 1
	callchannel Music_LibRocket_1
.loop
	callchannel Music_LibRocket_2
	callchannel Music_LibRocket_3
	callchannel Music_LibRocket_4
	jumpchannel .loop

Music_LookRocket_Ch2:
	forceoctave $2
	vibrato $4, $64
	dutycycle $3
	notetype $c, $b7
	stereopanning $ff
	octave 5
	note C_, 1
	note D_, 1
	callchannel Music_LibRocket_5
.loop
	intensity $b7
	callchannel Music_LibRocket_3
	callchannel Music_LibRocket_6
	jumpchannel .loop

Music_LookRocket_Ch3:
	forceoctave $2
	vibrato $4, $22
	notetype $c, $14
	stereopanning $f0
	note __, 2
	callchannel Music_LibRocket_7
.loop
	callchannel Music_LibRocket_8
	callchannel Music_LibRocket_9_WithIntensity
	callchannel Music_LibRocket_10_WithIntensity
	callchannel Music_LibRocket_9
	callchannel Music_LibRocket_11
	jumpchannel .loop

Music_LookRocket_Ch4:
	togglenoise $3
	notetype $c
	note __, 2
.loop
	callchannel Music_LibRocket_NoiseA
.repeat
	callchannel Music_LibRocket_NoiseB
	loopchannel 7, .repeat
	jumpchannel .loop
