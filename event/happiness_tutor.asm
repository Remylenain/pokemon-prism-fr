Special_GoldenrodHappinessMoveTutor:
	ld hl, .IntroText
	call PrintText
	call YesNoBox
	jr c, .cancel
	ld hl, .WhichOneText
	call PrintText

	ld b, 6
	callba SelectMonFromParty
	jr c, .cancel

	ld a, [wCurPartySpecies]
	cp EGG
	ld hl, .EggText
	jr z, .show_text_and_exit

	call IsAPokemon
	ld hl, .NotPokemonText
	jr c, .show_text_and_exit

	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call SkipNames
	ld de, wStringBuffer3
	rst CopyBytes

	ld a, MON_HAPPINESS
	call GetPartyParam
	cp 200
	ld hl, .NotHappyEnoughText
	jr c, .show_text_and_exit

	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, HappinessMoves
	add hl, bc
	ld a, [hl]
	ld [wPutativeTMHMMove], a
	ld d, a

	ld a, MON_MOVES
	call GetPartyParamLocation
	ld b, 4
.loop
	ld a, [hli]
	and a
	jr z, .ask_learn
	cp d
	jr z, .already_knows
	dec b
	jr nz, .loop
.ask_learn
	ld a, d
	ld [wd265], a
	call GetMoveName
	ld hl, wStringBuffer1
	ld de, wStringBuffer2
	ld bc, wStringBuffer2 - wStringBuffer1
	rst CopyBytes

	ld hl, .AskTeachMoveText
	call PrintText
	call YesNoBox
	jr nc, .teach
.cancel
	ld hl, .DeclinedText
.show_text_and_exit
	jp PrintText

.teach
	predef LearnMove
	ld a, BANK(FarText_PleaseComeAgain)
	ld hl, FarText_PleaseComeAgain
	jp FarPrintText

.already_knows
	ld hl, .HappyButKnowsText
	jp PrintText

.IntroText
	ctxt "I'm very good at"
	line "judging how happy"
	para "#mon are with"
	line "their trainers."

	para "Would you mind if"
	line "I evaluated yours?"
	done

.WhichOneText
	ctxt "Which one should I"
	line "evaluate?"
	prompt

.AskTeachMoveText
	ctxt "Oh<...>"
	line "Your <STRBF3><...>"

	para "It really seems to"
	line "love you!"

	para "I think it can use"
	line "<STRBF2> with"
	cont "great ease!"

	para "Would you like me"
	line "to teach the move"
	para "<STRBF2> to"
	line "your <STRBF3>?"
	done

.DeclinedText
	ctxt "Aww, you don't want"
	line "me to?"
	done

.EggText
	ctxt "Oh, your Egg<...>"

	para "It may be happier"
	line "sunny-side up."

	para "Pfft<...>"
	line "I'm kidding!"
	done

.NotPokemonText
	ctxt "Oh, your<...>"
	line "Wait<...>"

	para "What even is this?"
	line "That's a #mon"
	para "I've never seen"
	line "before!"
	done

.NotHappyEnoughText
	ctxt "Oh<...>"
	line "Your <STRBF3><...>"

	para "You may want to"
	line "spend a little"
	cont "more time with it."
	done

.HappyButKnowsText
	ctxt "Oh<...>"
	line "Your <STRBF3><...>"

	para "It really seems to"
	line "love you!"

	para "Oh, it makes me so"
	line "happy!"
	done

HappinessMoves:
	db BURNING_MIST
	db BURNING_MIST
	db BURNING_MIST
	db MORNING_SUN
	db MORNING_SUN
	db MORNING_SUN
	db POWER_GEM
	db POWER_GEM
	db POWER_GEM
	db X_SCISSOR    ;  10
	db X_SCISSOR
	db X_SCISSOR
	db METEOR_MASH
	db METEOR_MASH
	db MIASMA
	db DRILL_PECK
	db DRILL_PECK
	db DRILL_PECK
	db POWER_BALLAD
	db POWER_BALLAD ;  20
	db HAZE
	db HAZE
	db PAIN_SPLIT
	db PAIN_SPLIT
	db FLY
	db METEOR_MASH
	db EXTREMESPEED
	db EXTREMESPEED
	db EXTREMESPEED
	db FIRE_BLAST   ;  30
	db FIRE_BLAST
	db PERISH_SONG
	db PERISH_SONG
	db PERISH_SONG
	db MOONBLAST
	db MOONBLAST
	db FUTURE_SIGHT
	db FUTURE_SIGHT
	db MOONLIGHT
	db MOONLIGHT    ;  40
	db OUTRAGE
	db OUTRAGE
	db THUNDER_FANG
	db THUNDER_FANG
	db THUNDER_FANG
	db CONFUSE_RAY
	db CONFUSE_RAY
	db MOONBLAST
	db MOONBLAST
	db STORM_FRONT  ;  50
	db STORM_FRONT
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db DRAIN_PUNCH
	db DRAIN_PUNCH
	db ROLLOUT
	db ROLLOUT
	db DRAGON_DANCE
	db DRAGON_DANCE
	db SPITE        ;  60
	db SPITE
	db SPITE
	db AMNESIA
	db AMNESIA
	db AMNESIA
	db DRAIN_PUNCH
	db DRAIN_PUNCH
	db SWORDS_DANCE
	db MIASMA
	db MIASMA       ;  70
	db MIASMA
	db VAPORIZE
	db VAPORIZE
	db METEOR_MASH
	db METEOR_MASH
	db METEOR_MASH
	db NASTY_PLOT
	db NASTY_PLOT
	db GROWTH
	db GROWTH       ;  80
	db BASS_TREMOR
	db BASS_TREMOR
	db BASS_TREMOR
	db FLAMETHROWER
	db FLAMETHROWER
	db DRAGON_PULSE
	db DRAGON_PULSE
	db POWER_BALLAD
	db POWER_BALLAD
	db PERISH_SONG  ;  90
	db PERISH_SONG
	db MOONBLAST
	db MOONBLAST
	db MOONBLAST
	db RAPID_SPIN
	db METEOR_MASH
	db METEOR_MASH
	db DRAGON_DANCE
	db DRAGON_DANCE
	db SPIKES       ; 100
	db SPIKES
	db SOFTBOILED
	db SOFTBOILED
	db EARTH_POWER
	db EARTH_POWER
	db DESTINY_BOND
	db GHOST_HAMMER
	db DRAGON_DANCE
	db CRUNCH
	db CRUNCH       ; 110
	db DRAGON_DANCE
	db DRAGON_DANCE
	db HAZE
	db BARRIER
	db HEAD_SMASH
	db BARRIER
	db HEAD_SMASH
	db AQUA_JET
	db AQUA_JET
	db AQUA_JET     ; 120
	db AQUA_JET
	db AQUA_JET
	db CRUNCH
	db BASS_TREMOR
	db BULLET_PUNCH
	db BUBBLEBEAM
	db BULLET_PUNCH
	db BUBBLEBEAM
	db VAPORIZE
	db VAPORIZE     ; 130
	db WILD_CHARGE
	db DISABLE
	db EARTH_POWER
	db AQUA_JET
	db BASS_TREMOR
	db WILD_CHARGE
	db METALLURGY
	db PAIN_SPLIT
	db RAPID_SPIN
	db RAPID_SPIN   ; 140
	db HEAD_SMASH
	db HEAD_SMASH
	db MINIMIZE
	db AEROBLAST
	db SHOCK_SMOG
	db SACRED_FIRE
	db AURA_SPHERE
	db AURA_SPHERE
	db AURA_SPHERE
	db GROWTH       ; 150
	db GROWTH
	db GROWTH
	db GROWTH
	db GROWTH
	db FEINT_ATTACK
	db FEINT_ATTACK
	db FEINT_ATTACK
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db FOCUS_ENERGY ; 160
	db RECOVER
	db RECOVER
	db AURA_SPHERE
	db AURA_SPHERE
	db AURA_SPHERE
	db AURA_SPHERE
	db POISON_GAS
	db POISON_GAS
	db OUTRAGE
	db AQUA_JET     ; 170
	db AQUA_JET
	db SWEET_SCENT
	db PERISH_SONG
	db MOONLIGHT
	db AGILITY
	db AGILITY
	db MOONBLAST
	db MOONBLAST
	db PURSUIT
	db PURSUIT      ; 180
	db PURSUIT
	db AGILITY
	db FOCUS_ENERGY
	db FOCUS_ENERGY
	db MIASMA
	db MIASMA
	db AQUA_JET
	db AQUA_JET
	db DRAGON_DANCE
	db DRAGON_DANCE ; 190
	db CROSS_CHOP
	db CROSS_CHOP
	db DRAGON_DANCE
	db DRAGON_DANCE
	db SPRING_BUDS
	db AURA_SPHERE
	db AURA_SPHERE
	db HYDRO_PUMP
	db GROWTH
	db SLUDGE_BOMB  ; 200
	db SLUDGE_BOMB
	db MIASMA
	db MIASMA
	db SMOKESCREEN
	db SMOKESCREEN
	db DRAGON_DANCE
	db SPIKES
	db RAPID_SPIN
	db SPIKES
	db AQUA_JET     ; 210
	db AQUA_JET
	db METALLURGY
	db MACH_PUNCH
	db MACH_PUNCH
	db CRUNCH
	db QUICK_ATTACK
	db QUICK_ATTACK
	db ACID_ARMOR
	db ACID_ARMOR
	db HEAD_SMASH   ; 220
	db HEAD_SMASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db NIGHT_SLASH
	db MIASMA
	db MIASMA
	db HEAD_SMASH   ; 230
	db METALLURGY
	db METALLURGY
	db METALLURGY
	db METALLURGY
	db CRUNCH
	db DRAIN_PUNCH
	db DRAIN_PUNCH
	db BASS_TREMOR
	db BULLET_PUNCH
	db BUBBLEBEAM   ; 240
	db SWEET_KISS
	db HAZE
	db FLARE_BLITZ
	db AQUA_JET
	db AEROBLAST
	db CROSS_CHOP
	db CROSS_CHOP
	db CROSS_CHOP
	db AURA_SPHERE
	db LAVA_POOL    ; 250
	db GROWTH
	db BULLET_PUNCH
	db TACKLE       ; placeholder
	db MIASMA
	db TACKLE       ; placeholder
	db TACKLE       ; placeholder
