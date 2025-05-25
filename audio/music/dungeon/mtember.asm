Music_MtEmber:
	channelcount 3
	channel 1, Music_MtEmber_Ch1
	channel 2, Music_MtEmber_Ch2
	channel 3, Music_MtEmber_Ch3

Music_MtEmber_Ch1:
	stereopanning $f
	tempo $AE
	volume $77
Music_MtEmber_Ch1_loop:
	vibrato $08, $14
	notetype $C, $93
Music_MtEmber_Ch1_sub1:
	callchannel Music_MtEmber_Ch1_br1
	callchannel Music_MtEmber_Ch1_br1
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	loopchannel 3, Music_MtEmber_Ch1_sub1
	callchannel Music_MtEmber_Ch1_br1
	callchannel Music_MtEmber_Ch1_br1
	note D#, 2
	note E_, 2
	note E_, 2
	note G#, 2
Music_MtEmber_Ch1_sub2:
	callchannel Music_MtEmber_Ch1_br2
	callchannel Music_MtEmber_Ch1_br2
	note E_, 2
	note G#, 2
	loopchannel 3, Music_MtEmber_Ch1_sub2
	callchannel Music_MtEmber_Ch1_br2
	callchannel Music_MtEmber_Ch1_br2
Music_MtEmber_Ch1_sub3:
	callchannel Music_MtEmber_Ch1_br1
	callchannel Music_MtEmber_Ch1_br1
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	loopchannel 4, Music_MtEmber_Ch1_sub3
	octave 4
	note F_, 2
	note F_, 2
	note __, 2
	note F_, 2
	note E_, 2
	note E_, 2
	note D#, 2
	note D#, 2
	note __, 2
	note D#, 2
	note D_, 2
	note D_, 2
	tempo $AB
	octave 1
	note A#, 1
	note B_, 1
	octave 2
	callchannel Music_MtEmber_SHARE_1
	note F_, 1
	tempo $C3
	octave 1
	note A#, 1
	note B_, 1
	octave 2
	callchannel Music_MtEmber_SHARE_1
	note F_, 1
	tempo $D4
	octave 1
	note A#, 1
	note B_, 1
	octave 2
	callchannel Music_MtEmber_SHARE_1
	note F_, 1
	tempo $EA
	octave 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 2
	callchannel Music_MtEmber_SHARE_1
	tempo $F6
	octave 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 2
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	tempo $FF
	octave 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 2
	note C_, 1
	note C#, 1
	note D_, 1
	octave 1
	note F#, 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 2
	note C_, 1
	note C#, 1
	octave 1
	note F_, 1
	note F#, 1
	note G_, 1
	note G#, 1
	note A_, 1
	note A#, 1
	note B_, 1
	octave 2
	note C_, 1
	tempo $AE
	octave 4
	note D_, 2
	note D_, 2
	note __, 2
	note D_, 2
	note D#, 2
	note D#, 2
	note E_, 2
	note E_, 2
	note __, 2
	note E_, 2
	note F_, 2
	note F_, 2
Music_MtEmber_Ch1_sub4:
	octave 3
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note D#, 2
	octave 2
	note B_, 2
	loopchannel 4, Music_MtEmber_Ch1_sub4
	callchannel Music_MtEmber_Ch1_br3
Music_MtEmber_Ch1_sub5:
	callchannel Music_MtEmber_Ch1_br3
	octave 2
	note A_, 2
	note F_, 2
	note A_, 2
	note F_, 2
	octave 3
	note C#, 2
	loopchannel 2, Music_MtEmber_Ch1_sub5
	callchannel Music_MtEmber_Ch1_br3
	callchannel Music_MtEmber_Ch1_br3
	callchannel Music_MtEmber_Ch1_br3
	octave 2
	note A_, 2
	note F_, 2
	octave 3
	note A_, 2
	note F_, 2
	callchannel Music_MtEmber_Ch1_br4
	callchannel Music_MtEmber_Ch1_br4
	note A_, 2
	note F_, 2
Music_MtEmber_Ch1_sub6:
	callchannel Music_MtEmber_Ch1_br4
	loopchannel 6, Music_MtEmber_Ch1_sub6
Music_MtEmber_Ch1_sub7:
	callchannel Music_MtEmber_Ch1_br5
	callchannel Music_MtEmber_Ch1_br5
	note G#, 2
	note E_, 2
	loopchannel 2, Music_MtEmber_Ch1_sub7
Music_MtEmber_Ch1_sub8:
	callchannel Music_MtEmber_Ch1_br5
	loopchannel 4, Music_MtEmber_Ch1_sub8
	note G#, 2
	note E_, 2
	note __, 16
	note __, 8
Music_MtEmber_Ch1_sub9:
	note D#, 2
	note G_, 2
	note D#, 2
	note C#, 6
	loopchannel 4, Music_MtEmber_Ch1_sub9
	note D#, 2
	note __, 16
	note __, 16
	jumpchannel Music_MtEmber_Ch1_loop
Music_MtEmber_Ch1_br1:
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	note G_, 2
	endchannel
Music_MtEmber_Ch1_br2:
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	note G#, 2
	endchannel
Music_MtEmber_Ch1_br3:
	octave 2
	note A_, 2
	note F_, 2
	octave 3
	note C#, 2
	endchannel
Music_MtEmber_Ch1_br4:
	octave 4
	note C#, 2
	octave 3
	note A_, 2
	note F_, 2
	endchannel
Music_MtEmber_Ch1_br5:
	note G#, 2
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	endchannel

Music_MtEmber_Ch2:
Music_MtEmber_Ch2_loop:
	dutycycle 2
	vibrato $0B, $15
	notetype $C, $b3
	octave 4
	note D#, 6
	note C#, 6
Music_MtEmber_Ch2_sub1:
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	note D#, 2
	note G_, 2
	note D#, 2
	note C#, 6
	loopchannel 2, Music_MtEmber_Ch2_sub1
	callchannel Music_MtEmber_Ch2_br1
	note G#, 6
	note F#, 6
	note E_, 2
	note F#, 2
	note G#, 2
	octave 5
	note C_, 2
	callchannel Music_MtEmber_Ch2_br2
	note E_, 2
	note D#, 2
	note E_, 6
	note F#, 6
	note E_, 4
	dutycycle 0
	note D#, 6
	note C#, 6
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	callchannel Music_MtEmber_Ch2_br3
	note D#, 2
	note G_, 2
	note D#, 2
	note C#, 6
	callchannel Music_MtEmber_Ch2_br1
	note G#, 2
	note G#, 2
	note __, 2
	note G#, 2
	note A_, 2
	note A_, 2
	note A#, 2
	note A#, 2
	note __, 2
	note A#, 2
	note B_, 2
	note B_, 2
Music_MtEmber_Ch2_sub2:
	note __, 8
	loopchannel 8, Music_MtEmber_Ch2_sub2
	note B_, 2
	note B_, 2
	note __, 2
	note B_, 2
	note A#, 2
	note A#, 2
	note A_, 2
	note A_, 2
	note __, 2
	note A_, 2
	note G#, 2
	note G#, 2
	note C#, 8
	note __, 2
	octave 3
	note B_, 6
	note A#, 2
	note B_, 2
	octave 4
	callchannel Music_MtEmber_Ch2_br3
	callchannel Music_MtEmber_Ch2_br3
	note D#, 6
	note G_, 6
	dutycycle 2
	octave 3
	callchannel Music_MtEmber_Ch2_br4
	octave 4
	note C#, 2
	octave 3
	note A_, 2
	note G_, 6
	note F_, 2
	note G_, 2
	note A_, 2
	octave 4
	note C#, 2
	octave 3
	note A_, 2
	note G_, 6
	note A_, 6
	octave 4
	note C#, 6
	callchannel Music_MtEmber_Ch2_br4
	octave 5
	note C#, 2
	octave 4
	note A_, 2
	note G_, 6
	note A_, 2
	octave 5
	note C#, 2
	octave 4
	note A_, 2
	note G_, 6
	note A_, 6
	octave 5
	note C#, 6
	octave 4
	note F#, 8
	note __, 2
	note E_, 6
	note D#, 2
	note E_, 2
	note G#, 2
	octave 5
	note C_, 2
	callchannel Music_MtEmber_Ch2_br2
	note G#, 6
	octave 5
	note C_, 6
	octave 3
	note D#, 2
	note G_, 2
	note D#, 2
	note C#, 6
	note D#, 2
	note G_, 2
	note D#, 2
	note C#, 6
	octave 2
	note E_, 2
	note G#, 2
	octave 3
	note C_, 2
	note E_, 2
	note G#, 2
	octave 4
Music_MtEmber_Ch2_sub4:
	note C_, 2
	note E_, 2
	note G#, 2
	loopchannel 6, Music_MtEmber_Ch2_sub4
	note C_, 2
	note D#, 2
Music_MtEmber_Ch2_sub3:
	callchannel Music_MtEmber_Ch1_br1
	callchannel Music_MtEmber_Ch1_br1
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	loopchannel 2, Music_MtEmber_Ch2_sub3
	jumpchannel Music_MtEmber_Ch2_loop
Music_MtEmber_Ch2_br1:
	octave 3
	note B_, 2
	note A#, 2
	note B_, 6
	octave 4
	note C#, 8
	note __, 2
	endchannel
Music_MtEmber_Ch2_br2:
	octave 4
	note G#, 2
	note F#, 6
	note E_, 2
	note F#, 2
	note G#, 2
	octave 5
	note C_, 2
	octave 4
	note G#, 2
	note F#, 6
	endchannel
Music_MtEmber_Ch2_br3:
	note D#, 2
	note G_, 2
	note D#, 2
	note C#, 6
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	endchannel
Music_MtEmber_Ch2_br4:
	note G_, 8
	note __, 2
	note F_, 6
	note E_, 2
	note F_, 2
	note A_, 2
	endchannel

Music_MtEmber_Ch3:
Music_MtEmber_Ch3_loop:
	stereopanning $f0
	notetype $F, $00
Music_MtEmber_Ch3_sub1:
	note __, 16
	loopchannel 9, Music_MtEmber_Ch3_sub1
	note __, 6
	dutycycle 4
	octave 3
	notetype $6, $14
	note __, 1
	note B_, 1
	octave 4
	callchannel Music_MtEmber_SHARE_1
	note __, 2
	callchannel Music_MtEmber_SHARE_1
	note F_, 1
	note __, 16
	note __, 16
	note __, 10
	dutycycle 1
	intensity $11
	octave 5
	note E_, 8
	octave 4
	note B_, 8
	octave 5
	note D#, 8
	octave 4
	note A#, 8
	octave 5
	note D_, 8
	octave 4
	note A_, 8
	octave 5
	note C#, 8
	octave 4
	note G#, 8
	octave 5
	note C_, 8
	octave 4
	note G_, 8
	note B_, 8
	note F#, 8
	note A#, 8
	note F_, 8
	note A_, 8
	note E_, 8
	notetype $F, $11
	note __, 16
	dutycycle 4
	notetype $6, $14
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	note __, 2
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	notetype $C, $00
Music_MtEmber_Ch3_sub2:
	note __, 16
	loopchannel 21, Music_MtEmber_Ch3_sub2
	note __, 7
	jumpchannel Music_MtEmber_Ch3_loop
;Shared channels
Music_MtEmber_SHARE_1:
	note C_, 1
	note C#, 1
	note D_, 1
	note D#, 1
	note E_, 1
	endchannel
