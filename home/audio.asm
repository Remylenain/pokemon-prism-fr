_LoadMusicByte::
; wCurMusicByte = [a:de]
	call Bankswitch
	ld a, [de]
	ld [wCurMusicByte], a
	ld a, BANK(LoadMusicByte)
Bankswitch:
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	ret

IF !DEF(GBS)
FadeToMapMusic::
	push hl
	push de
	push bc
	push af

	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	jr z, .popOffRegsAndReturn

	ld a, 8
	ld [wMusicFade], a
	ld a, e
	ld [wMapMusic], a
	ld [wMusicFadeIDLo], a
	ld a, d
	ld [wMusicFadeIDHi], a
.popOffRegsAndReturn
	jr PopOffRegsAndReturn

MapSetup_Sound_Off::
	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	ret z
ENDC

; fallthrough
TurnSoundOff::
	push hl
	push de
	push bc
	push af

	callba _MapSetup_Sound_Off

	jr PopOffRegsAndReturn

UpdateSound::

	push hl
	push de
	push bc
	push af

	callba _UpdateSound_SkipMusicCheck

	jr PopOffRegsAndReturn

IF !DEF(GBS)
_PlayMapMusic:
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	pop de
	ld a, e
	ld [wMapMusic], a
ENDC

; fallthrough
PlayMusic::
; Play music de.

	push hl
	push de
	push bc
	push af

	bankpushcall _PlayMusic, PlayMusic_BankPush

IF DEF(GBS)
	assert @ == PopOffRegsAndReturn
ELSE
	jr PopOffRegsAndReturn
ENDC

IF !DEF(GBS)
PlayMusic2::
; Stop playing music, then play music de.

	push hl
	push de
	push bc
	push af

	bankpushcall _PlayMusic, PlayMusic2_BankPush

	jr PopOffRegsAndReturn

Script_playmapmusic::
; script command 0x82
PlayMapMusic::
	push hl
	push de
	push bc
	push af

	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	call nz, _PlayMapMusic
	jr PopOffRegsAndReturn

EnterMapMusic::
	push hl
	push de
	push bc
	push af

	xor a
	ld [wDontPlayMapMusicOnReload], a
	call GetMapMusic
	call _PlayMapMusic
ENDC

PopOffRegsAndReturn::
	pop af
PopOffBCDEHLAndReturn::
	pop bc
	pop de
	pop hl
	ret

IF !DEF(GBS)
GetMapHeaderAttribute_PopOffBCDEHLAndReturn:
	ld c, a
	jr PopOffBCDEHLAndReturn

TryRestartMapMusic::
	call PopSoundstate
	push af
	ld a, [wDontPlayMapMusicOnReload]
	and a
	jr nz, DontRestartMapMusic
	pop af
	ret nc
RestartMapMusic::
	push hl
	push de
	push bc
	push af
	ld a, [wMapMusic]
	ld e, a
	ld d, 0
	call PlayMusic
	jr PopOffRegsAndReturn

WaitPlaySFX::
	call WaitSFX
	; fallthrough

PlaySFX::
; Play sound effect de.
; Sound effects are ordered by priority (highest to lowest)

	push hl
	push de
	push bc
	push af

	; Is something already playing?
	call CheckSFX
	jr nc, .play

	; Does it have priority?
	ld a, [wCurSFX]
	cp e
	jr c, PopOffRegsAndReturn

.play
	ld a, e
	ld [wCurSFX], a

	callba _PlaySFX
	jr PopOffRegsAndReturn

KillPlayWaitSFX:
	call Script_killsfx
	jr PlayWaitSFX

WaitPlayWaitSFX:
	call WaitSFX

PlayWaitSFX::
	call PlaySFX
	; fallthrough

Script_waitsfx::
; script command 0x86
WaitSFX::
; infinite loop until sfx is done playing

	push hl
	push de
	push bc
	ld bc, wChannel6Flags - wChannel5Flags
	jr .handleLoop
.loop
	call DelayFrame
.handleLoop
	call CheckSFX
	jr c, .loop
	jr PopOffBCDEHLAndReturn

DontRestartMapMusic:
	pop af
	xor a
	ld [wMapMusic], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	xor a
	ld [wDontPlayMapMusicOnReload], a
	ret

PlayCryHeader::
; Play cry header at hl
	anonbankpush CryHeaders

PlayCryHeader_BankPush:
	ld a, [hli]
	cp $ff
	jr z, .ded
	ld e, a
	ld d, 0

	ld a, [hli]
	ld [wCryPitch], a
	ld a, [hli]
	ld [wCryPitch + 1], a
	ld a, [hli]
	ld [wCryLength], a
	ld a, [hl]
	ld [wCryLength + 1], a
	jpba _PlayCryHeader

.ded
	ld e, 0
	call LoadDEDCryHeader
	jp PlayDEDCry
ENDC

PlayMusic_BankPush:
	ld a, e
	and a
	jp z, _MapSetup_Sound_Off
	jp _PlayMusic

; TODO: Fix this to actually reset sound data
IF !DEF(GBS)
PlayMusic2_BankPush:
	push de
	ld de, MUSIC_NONE
	call _PlayMusic
	call DelayFrame
	pop de
	jp _PlayMusic

IsSFXPlaying::
; Return carry if no sound effect is playing.
; The inverse of CheckSFX.
	ld a, [wChannel5Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	ld a, [wChannel6Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	ld a, [wChannel7Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	ld a, [wChannel8Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	scf
	ret

.playing
	pop hl
	and a
	ret

MaxVolume::
	ld a, $77 ; max
	ld [wVolume], a
	ret

LowVolume::
	ld a, $33 ; 40%
	ld [wVolume], a
	ret

VolumeOff::
	xor a
	ld [wVolume], a
	ret

FadeInMusic::
	ld a, 4 | 1 << 7
	ld [wMusicFade], a
	ret

SkipMusic::
; Skip a frames of music
	ldh [hBuffer], a
	ld a, [wMusicPlaying]
	push af
	xor a
	ld [wMusicPlaying], a
	ldh a, [hBuffer]
.loop
	call UpdateSound
	dec a
	jr nz, .loop
	pop af
	ld [wMusicPlaying], a
	ret

SpecialMapMusic::
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .surf
	cp PLAYER_SURF_PIKA
	jr z, .surf

.no
	and a
	ret

.surf
	ld de, MUSIC_SURF
	scf
	ret

CheckSFX::
; Return carry if any SFX channels are active.
	ld bc, wChannel6Flags - wChannel5Flags
	ld a, 4
	ld hl, wChannel5Flags
.check_each_channel
	bit SOUND_CHANNEL_ON, [hl]
	jr nz, .playing
	add hl, bc
	dec a
	jr nz, .check_each_channel
	and a
	ret
.playing
	scf
	ret

TerminateExpBarSound::
	xor a
	ld [wChannel5Flags], a
	ld [wSoundInput], a
	ldh [rNR10], a
	ldh [rNR11], a
	ldh [rNR12], a
	ldh [rNR13], a
	ldh [rNR14], a
	ret

ChannelsOff::
; Quickly turn off music channels
	xor a
	ld [wChannel1Flags], a
	ld [wChannel2Flags], a
	ld [wChannel3Flags], a
	ld [wChannel4Flags], a
	ld [wSoundInput], a
	ret

Script_killsfx::
	call KillSFXEntryPoint
	jp DelayFrame

SFXChannelsOff::
; Quickly turn off sound effect channels
	xor a
	ld [wSoundInput], a
KillSFXEntryPoint::
	xor a
	ld [wChannel5Flags], a
	ld [wChannel6Flags], a
	ld [wChannel7Flags], a
	ld [wChannel8Flags], a
	ret

PushSoundstate::
	push hl
	push de
	push bc

	call SFXChannelsOff ; kill SFX
	call DelayFrame ; sync tracks

	di
	callba _PushSoundstate

	jr PopOffBCDEHLAndReti


PopSoundstate::
	push hl
	push de
	push bc

	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame ; sync tracks

	di
	callba _PopSoundstate

PopOffBCDEHLAndReti:
	pop bc
	pop de
	pop hl
	reti
ENDC
