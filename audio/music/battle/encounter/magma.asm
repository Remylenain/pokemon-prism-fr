Music_LookMagma:
	channelcount 4
	channel 1, Music_LookMagma_Ch1
	channel 2, Music_LookMagma_Ch2
	channel 3, Music_LookMagma_Ch3
	channel 4, Music_LookMagma_Ch4


Music_LookMagma_Ch1:
	volume $77
	dutycycle $0
	stereopanning $f
	vibrato $12, $15
	tempo 128
	tone $0001
	notetype $6, $72
	octave 4
	note D_, 2
	note E_, 2
	note F_, 2
	note E_, 2
	note D#, 2
	note D_, 2
	note C#, 4
	note C_, 4
	octave 3
	note B_, 2
	note B_, 2
	note A_, 4
	note B_, 4
	octave 4
	note C#, 4
	intensity $50
	note A_, 16
	note A_, 16
	intensity $62
	note B_, 4
	note G_, 4
	octave 3
	note G_, 2
	octave 4
	note D_, 2
	note F_, 2
	note A_, 2
	note B_, 2
	octave 5
	note C_, 1
	octave 4
	note B_, 1
	note A_, 4
	note G_, 2
	note A_, 1
	note G_, 1
	note D_, 4
	intensity $50
	octave 5
	note C_, 16
	note C_, 16
	intensity $62
	note D_, 4
	octave 4
	note B_, 4
	note D_, 2
	note F_, 2
	note A_, 2
	octave 5
	note D_, 2
	note F_, 2
	note G_, 1
	note F_, 1
	note D_, 4
	octave 4
	note B_, 2
	octave 5
	note C_, 1
	octave 4
	note B_, 1
	note G_, 4
	notetype $c, $81
Music_LookMagma_Ch1_loop_1:
	callchannel Music_LookMagma_Ch1_branch_1
	callchannel Music_LookMagma_Ch1_branch_1
	callchannel Music_LookMagma_Ch1_branch_1
	note F_, 1
	octave 5
	note D_, 1
	note F_, 1
	note D_, 2
	note F_, 1
	octave 4
	note A_, 2
	loopchannel 2, Music_LookMagma_Ch1_loop_1
	intensity $72
	note E_, 1
	note E_, 5
	note E_, 1
	note E_, 9
	note E_, 1
	note E_, 5
	intensity $65
	note G#, 1
	note C#, 1
	octave 3
	note A#, 1
	note C#, 1
	octave 4
	note G_, 1
	note C_, 1
	octave 3
	note G_, 1
	note C_, 1
	octave 4
	note F#, 1
	octave 3
	note B_, 1
	intensity $72
	octave 4
	note E_, 1
	note E_, 5
	note E_, 1
	note E_, 9
	note E_, 1
	note E_, 3
	notetype $8, $72
	note __, 2
	note A_, 2
	note A#, 4
	note A#, 2
	note B_, 2
	notetype $6, $72
	note B_, 2
	octave 5
	note C#, 2
	jumpchannel Music_LookMagma_Ch1

Music_LookMagma_Ch1_branch_1:
	octave 5
	note D_, 2
	note F_, 3
	note F_, 1
	octave 4
	note A_, 2
	endchannel

Music_LookMagma_Ch2:
	dutycycle $3
	stereopanning $f0
	vibrato $12, $25
	tone $0001
	notetype $c, $92
	octave 5
	note D_, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 2
	note C_, 2
	octave 4
	note B_, 1
	note B_, 1
	note A_, 2
	note B_, 2
	octave 5
	note C#, 2
	note D_, 1
	octave 4
	note D_, 1
	note A_, 1
	note G#, 2
	note A_, 2
	note B_, 1
	octave 5
	note C_, 2
	octave 4
	note B_, 4
	note F_, 2
	note G_, 2
	octave 5
	note D_, 2
	notetype $6, $52
	octave 3
	note D_, 2
	note G_, 2
	note A_, 2
	octave 4
	note D_, 2
	note F#, 2
	note G_, 1
	note F#, 1
	note E_, 4
	note D_, 2
	note E_, 1
	note D_, 1
	octave 3
	note A_, 4
	notetype $c, $92
	octave 3
	note F_, 1
	octave 4
	note F_, 1
	note A_, 1
	note G#, 2
	note A_, 1
	note A#, 1
	note B_, 1
	octave 5
	note C_, 2
	note D_, 4
	octave 4
	note G_, 2
	octave 5
	note D_, 2
	note G_, 2
	notetype $6, $62
	octave 3
	note G_, 2
	octave 4
	note D_, 2
	note F_, 2
	note A_, 2
	octave 5
	note D_, 2
	note E_, 1
	note D_, 1
	octave 4
	note B_, 4
	note G_, 2
	note A_, 1
	note G_, 1
	note D_, 4
	notetype $c, $70
	octave 3
	note A_, 8
	note B_, 8
	octave 4
	note C_, 8
	octave 3
	note B_, 8
	octave 4
	note D_, 8
	note E_, 8
	note F_, 8
	note G_, 8
	intensity $92
	note A_, 1
	note A_, 5
	note A_, 1
	note A_, 9
	note A_, 1
	note A_, 5
	intensity $87
	note G#, 4
	note G_, 4
	note F#, 2
	intensity $92
	note A_, 1
	note A_, 5
	note A_, 1
	note A_, 9
	note A_, 1
	note A_, 3
	notetype $8, $92
	note __, 2
	note A_, 2
	note A#, 4
	note A#, 2
	note B_, 2
	notetype $c, $92
	note B_, 1
	octave 5
	note C#, 1
	jumpchannel Music_LookMagma_Ch2

Music_LookMagma_Ch3:
	notetype $6, $25
	note __, 4
Music_LookMagma_Ch3_loop_main:
	octave 2
	note A_, 2
	note __, 2
	note A_, 2
	note __, 2
	note A_, 2
	note __, 2
	note A_, 2
	note __, 2
	octave 1
	note A_, 2
	note __, 2
	note A_, 2
	note __, 2
	note A_, 2
	octave 2
	note C#, 2
	note E_, 2
	note A_, 2
	callchannel Music_LookMagma_Ch3_branch_1
	octave 3
	note E_, 2
	note F_, 1
	note __, 1
	note C#, 2
	note D_, 1
	note __, 1
	octave 2
	note G#, 2
	note A_, 1
	note __, 1
	note F_, 2
	note G_, 1
	note __, 1
	callchannel Music_LookMagma_Ch3_branch_1
	note G_, 2
	note D_, 2
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 4
	note G#, 4
Music_LookMagma_Ch3_loop_1:
	note D_, 5
	note __, 1
	note A_, 2
	note G#, 2
	note __, 2
	note G#, 2
	note __, 2
	loopchannel 8, Music_LookMagma_Ch3_loop_1
Music_LookMagma_Ch3_loop_2:
	note F#, 1
	note __, 1
	note F#, 2
	note __, 8
	note F#, 1
	note __, 1
	note F#, 2
	intensity $27
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	note D#, 2
	octave 2
	note B_, 2
	note __, 2
	octave 4
	note D_, 4
	intensity $25
	octave 2
	note F#, 1
	note __, 1
	note F#, 4
	note __, 16
	note __, 10
	loopchannel 2, Music_LookMagma_Ch3_loop_2
	jumpchannel Music_LookMagma_Ch3_loop_main

Music_LookMagma_Ch3_branch_1:
	note F_, 2
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 4
	octave 1
	note A_, 4
	octave 2
	note D_, 3
	note __, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 2
	note C#, 2
	note F_, 4
	note D_, 8
	note __, 8
	endchannel
	endchannel

Music_LookMagma_Ch4:
	togglenoise $3
	notetype $6
	note G#, 2
	note G#, 2
Music_LookMagma_Ch4_loop_main:
	note C_, 1
	note C_, 1
	note C_, 2
	note C_, 2
	note C_, 2
	note C_, 4
	note C_, 4
	note C_, 2
	note C_, 2
	note C_, 4
	note C_, 4
	note B_, 4
Music_LookMagma_Ch4_loop_1:
	note D#, 4
	note G#, 2
	note G#, 2
	note B_, 4
	note G#, 2
	note G#, 2
	note G#, 2
	note G#, 2
	note C_, 2
	note G#, 2
	note D#, 4
	note C_, 2
	note C_, 2
	note C_, 4
	note C_, 2
	note G#, 2
	note B_, 4
	note D#, 2
	note D#, 2
	note C#, 2
	note G#, 2
	note C#, 2
	note G#, 2
	note C#, 2
	note C#, 2
	note C_, 2
	note G#, 2
	loopchannel 2, Music_LookMagma_Ch4_loop_1
Music_LookMagma_Ch4_loop_2:
	note C_, 4
	note G#, 2
	note C_, 2
	note D_, 4
	note C_, 2
	note D#, 2
	note C_, 2
	note G#, 1
	note G#, 1
	note G#, 2
	note C_, 2
	note D_, 4
	note C_, 2
	note G#, 2
	note C_, 4
	note G#, 2
	note C_, 2
	note D_, 4
	note C_, 2
	note G#, 2
	note C_, 2
	note B_, 4
	note C_, 2
	note G#, 2
	note C_, 4
	note G#, 2
	loopchannel 2, Music_LookMagma_Ch4_loop_2
	callchannel Music_LookMagma_Ch4_branch_1
	note C_, 2
	note C_, 10
	note B_, 4
	note G#, 2
	note G#, 2
	note G#, 2
	note G#, 2
	note G#, 2
	note G#, 2
	note A_, 4
	callchannel Music_LookMagma_Ch4_branch_1
	note C_, 2
	note C_, 2
	note __, 4
	notetype $8
	note G#, 2
	note G#, 2
	note G#, 4
	note G#, 2
	note G#, 2
	notetype $6
	note G#, 2
	note G#, 2
	note B_, 4
	jumpchannel Music_LookMagma_Ch4_loop_main

Music_LookMagma_Ch4_branch_1:
	note C_, 2
	note C_, 10
	note C_, 2
	note C_, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 2
	note D#, 4
	note B_, 4
	endchannel
