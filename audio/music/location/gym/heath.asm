Music_HeathGym:
	channelcount 3
	channel 1, Music_HeathGym_Ch1
	channel 2, Music_HeathGym_Ch2
	channel 3, Music_HeathGym_Ch3

Music_HeathGym_Ch1:
	tempo 224
	volume $77
	dutycycle $0
	stereopanning $f0
	notetype $c, $44
	note __, 1
	jumpchannel Music_HeathGym_Common

Music_HeathGym_Ch2:
	tone $0002
	dutycycle $0
	stereopanning $f
	notetype $c, $a4
	; fallthrough

Music_HeathGym_Common:
	octave 4
	note C_, 4
	octave 3
	note A#, 4
	octave 4
	note C#, 2
	note D#, 2
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 4
	octave 3
	note A#, 4
	jumpchannel Music_HeathGym_Common

Music_HeathGym_Ch3:
	notetype $c, $10
.loop
	octave 2
	note G#, 2
	octave 3
	note C#, 2
	note E_, 2
	note __, 10
	jumpchannel .loop
