; Currently, must be in the same bank as the sound engine.

PlayTrainerEncounterMusic::
; input: e = trainer type
	; turn fade off
	xor a
	ld [wMusicFade], a
	; play nothing for one frame
	push de
	ld de, 0 ; id: Music_Nothing
	call PlayMusic
	call DelayFrame
	; play new song
	call MaxVolume
	pop de
	ld d, $00
	ld hl, TrainerEncounterMusic
	add hl, de
	ld e, [hl]
	jp PlayMusic

TrainerEncounterMusic:
	db MUSIC_HIKER_ENCOUNTER                  ; TRAINER_NONE
	db MUSIC_YOUNGSTER_ENCOUNTER              ; JOSIAH
	db MUSIC_TWINS_ENCOUNTER                  ; BROOKLYN
	db MUSIC_YOUNGSTER_ENCOUNTER              ; RINJI
	db MUSIC_OFFICER_ENCOUNTER                ; EDISON
	db MUSIC_OFFICER_ENCOUNTER                ; AYAKA
	db MUSIC_TWINS_ENCOUNTER                  ; CADENCE
	db MUSIC_OFFICER_ENCOUNTER                ; ANDRE
	db MUSIC_BEAUTY_ENCOUNTER                 ; BRUCE
	db MUSIC_RIVAL_ENCOUNTER                  ; RIVAL1
	db MUSIC_HIKER_ENCOUNTER                  ; MURA
	db MUSIC_HIKER_ENCOUNTER                  ; YUKI
	db MUSIC_HIKER_ENCOUNTER                  ; KOJI
	db MUSIC_OFFICER_ENCOUNTER                ; DAICHI
	db MUSIC_DUBIOUS_ENCOUNTER                ; DELINQUENTF
	db MUSIC_HIKER_ENCOUNTER                  ; SORA
	db MUSIC_OFFICER_ENCOUNTER                ; CHAMPION
	db MUSIC_TOUGH_ENCOUNTER                  ; PATROLLER
	db MUSIC_MAGMA_ENCOUNTER                  ; SCIENTIST
	db MUSIC_YOUNGSTER_ENCOUNTER              ; YOUNGSTER
	db MUSIC_YOUNGSTER_ENCOUNTER              ; SCHOOLBOY
	db MUSIC_TOUGH_ENCOUNTER                  ; BIRD_KEEPER
	db MUSIC_LASS_ENCOUNTER                   ; LASS
	db MUSIC_SWIMMERF_ENCOUNTER               ; CHEERLEADER
	db MUSIC_HIKER_ENCOUNTER                  ; COOLTRAINERM
	db MUSIC_BEAUTY_ENCOUNTER                 ; COOLTRAINERF
	db MUSIC_BEAUTY_ENCOUNTER                 ; BEAUTY
	db MUSIC_POKEMANIAC_ENCOUNTER             ; POKEMANIAC
	db MUSIC_ROCKET_ENCOUNTER                 ; GRUNTM
	db MUSIC_HIKER_ENCOUNTER                  ; GENTLEMAN
	db MUSIC_BEAUTY_ENCOUNTER                 ; SKIER
	db MUSIC_SWIMMERF_ENCOUNTER               ; TEACHER
	db MUSIC_BEAUTY_ENCOUNTER                 ; SHERYL
	db MUSIC_YOUNGSTER_ENCOUNTER              ; BUG_CATCHER
	db MUSIC_HIKER_ENCOUNTER                  ; FISHER
	db MUSIC_HIKER_ENCOUNTER                  ; SWIMMERM
	db MUSIC_SWIMMERF_ENCOUNTER               ; SWIMMERF
	db MUSIC_TOUGH_ENCOUNTER                  ; SAILOR
	db MUSIC_DUBIOUS_ENCOUNTER                ; SUPER_NERD
	db MUSIC_RIVAL_ENCOUNTER                  ; SILVER
	db MUSIC_HIKER_ENCOUNTER                  ; GUITARIST
	db MUSIC_HIKER_ENCOUNTER                  ; HIKER
	db MUSIC_HIKER_ENCOUNTER                  ; BIKER
	db MUSIC_OFFICER_ENCOUNTER                ; JOE
	db MUSIC_POKEMANIAC_ENCOUNTER             ; BURGLAR
	db MUSIC_HIKER_ENCOUNTER                  ; FIREBREATHER
	db MUSIC_POKEMANIAC_ENCOUNTER             ; JUGGLER
	db MUSIC_HIKER_ENCOUNTER                  ; BLACKBELT_T
	db MUSIC_DUBIOUS_ENCOUNTER                ; PSYCHIC_T
	db MUSIC_TWINS_ENCOUNTER                  ; PICNICKER
	db MUSIC_YOUNGSTER_ENCOUNTER              ; CAMPER
	db MUSIC_SAGE_ENCOUNTER                   ; SAGE
	db MUSIC_SAGE_ENCOUNTER                   ; MEDIUM
	db MUSIC_DUBIOUS_ENCOUNTER                ; BOARDER
	db MUSIC_HIKER_ENCOUNTER                  ; POKEFANM
	db MUSIC_DUBIOUS_ENCOUNTER                ; DELINQUENTM
	db MUSIC_TWINS_ENCOUNTER                  ; TWINS
	db MUSIC_LASS_ENCOUNTER                   ; POKEFANF
	db MUSIC_HIKER_ENCOUNTER                  ; RED
	db MUSIC_RIVAL_ENCOUNTER                  ; BLUE
	db MUSIC_OFFICER_ENCOUNTER                ; OFFICER
	db MUSIC_HIKER_ENCOUNTER                  ; MINER
	db MUSIC_HIKER_ENCOUNTER                  ; KARPMAN
	db MUSIC_HIKER_ENCOUNTER                  ; ARCADEPC_GROUP
	db MUSIC_HIKER_ENCOUNTER                  ; LILY
	db MUSIC_HIKER_ENCOUNTER                  ; LOIS
	db MUSIC_HIKER_ENCOUNTER                  ; SPARKY
	db MUSIC_HIKER_ENCOUNTER                  ; GOLD
	db MUSIC_HIKER_ENCOUNTER                  ; GIOVANNI
	db MUSIC_HIKER_ENCOUNTER                  ; ERNEST
	db MUSIC_HIKER_ENCOUNTER                  ; TRAINERKRIS
	db MUSIC_KIMONO_ENCOUNTER                 ; KIMONO_GIRL
	db MUSIC_HIKER_ENCOUNTER                  ; BUGSY
	db MUSIC_HIKER_ENCOUNTER                  ; WHITNEY
	db MUSIC_HIKER_ENCOUNTER                  ; SABRINA
	db MUSIC_HIKER_ENCOUNTER                  ; CANDELA
	db MUSIC_HIKER_ENCOUNTER                  ; BLANCHE
	db MUSIC_HIKER_ENCOUNTER                  ; SPARK_T
	db MUSIC_HIKER_ENCOUNTER                  ; BROWN
	db MUSIC_LASS_ENCOUNTER                   ; GUITARISTF
	db MUSIC_HIKER_ENCOUNTER                  ; CAL
