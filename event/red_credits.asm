RedCredits::
	xor a ; MUSIC_NONE
	ld [wMusicFadeIDLo], a
	ld [wMusicFadeIDHi], a
	ld a, 10
	ld [wMusicFade], a
	callba FadeOutPalettes
	xor a
	ld [wVramState], a
	ldh [hMapAnims], a
	callba RedCredits_PrepVideoData
	ld c, 8
	call DelayFrames
	call DisableSpriteUpdates
	ld a, SPAWN_RED
	ld [wSpawnAfterChampion], a
	ld a, [wStatusFlags]
	ld b, a
	jpba Credits
