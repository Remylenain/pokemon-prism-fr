Music_MtMoon:
	channelcount 4
	channel 1, Music_MtMoon_Ch1
	channel 2, Music_MtMoon_Ch2
	channel 3, Music_MtMoon_Ch3
	channel 4, Music_MtMoon_Ch4

Music_MtMoon_Ch1:
	tempo 208
	volume $77
	dutycycle $2
	tone $0001
	vibrato $8, $14
	stereopanning $f0
	notetype $c, $45
	note __, 2
	jumpchannel Music_MtMoon_Common

Music_MtMoon_Ch2:
	vibrato $b, $15
	dutycycle $2
	notetype $c, $84
	stereopanning $f
	; fallthrough

Music_MtMoon_Common:
	octave 4
	note D#, 6
	note C#, 6
.repeat1
	octave 3
	note B_, 2
	octave 4
	note C#, 2
	note D#, 2
	note G_, 2
	note D#, 2
	note C#, 6
	loopchannel 2, .repeat1
	octave 3
	note B_, 2
	note A#, 2
	note B_, 6
	octave 4
	note C#, 10
	note G#, 6
.repeat2
	note F#, 6
	note E_, 2
	note F#, 2
	note G#, 2
	octave 5
	note C_, 2
	octave 4
	note G#, 2
	loopchannel 2, .repeat2
	note F#, 6
	note E_, 2
	note D#, 2
	note E_, 6
	note F#, 6
	note E_, 4
	jumpchannel Music_MtMoon_Common

Music_MtMoon_Ch3:
	notetype $c, $28
.loop
	callchannel .sub
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	loopchannel 3, .loop
	callchannel .sub
	note D#, 2
	note E_, 2
.repeat
	note E_, 2
	note G#, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	note G#, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	note G#, 2
	loopchannel 4, .repeat
	jumpchannel .loop

.sub
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D#, 2
	note G_, 2
	endchannel

Music_MtMoon_Ch4:
	togglenoise $5
	notetype $c
.loop
	stereopanning $f
	note A#, 4
	note A#, 8
	note A#, 4
	stereopanning $f0
	note A#, 4
	note A#, 4
	note A#, 4
	stereopanning $f
	note A#, 4
	note A#, 4
	stereopanning $f0
	note A#, 8
	jumpchannel .loop
