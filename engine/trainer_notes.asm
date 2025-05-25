TrainerNotes_:
	call TN_PrintToD
	call TN_PrintLocation
	call TN_PrintLV
	call TN_PrintCharacteristics
	jp TN_PrintAbility

TN_PrintToD:
	ld de, .caughtat
	hlcoord 1, 8
	call PlaceString
	ld a, [wTempMonCaughtTime]
	and $c0
	ld de, .unknown
	jr z, .print
	rlca
	rlca
	cp 2
	ld de, .morn
	jr c, .print
	ld de, .day
	jr z, .print
	ld de, .nite
.print
	hlcoord 5, 8
	jp PlaceText

.caughtat
	db "Met@"

.morn
	ctxt "in the morning"
	done

.day
	ctxt "during the day"
	done

.nite
	ctxt "at night"
	done

.unknown
	ctxt "at unkwn time"
	done

TN_PrintLocation:
	ld de, .unknown
	ld a, [wTempMonCaughtLocation]
	and $7f
	jr z, .print
	cp $7e
	jr z, .print
	ld de, .event
	cp $7f
	jr z, .print
	ld e, a
	callba GetLandmarkName
	ld de, .regular
.print
	hlcoord 1, 10
	jp PlaceText

.unknown
	ctxt "Unknown Location"
	done

.event
	ctxt "Event #mon"
	done

.regular
	text "<STRBF1>"
	done

TN_PrintLV:
	ld a, [wTempMonCaughtLevel]
	and $3f
	hlcoord 1, 12
	jr z, .unknown
	cp 1
	jr z, .hatched
	cp 63
	jr z, .max
	ld [wTrainerNotes_EncounterLevel], a
	ld de, .metat
	call PlaceText
	ld de, wTrainerNotes_EncounterLevel
	lb bc,   1,  3
	hlcoord  8, 12
	jp PrintNum
.hatched
	ld de, .egg
	jp PlaceText
.unknown
	ld de, .str_unknown
	jp PlaceText
.max
	ld de, .str_max
	jp PlaceText

.metat
	text "Met at ", $6e
	done

.egg
	ctxt "Hatched from Egg"
	done

.str_unknown
	ctxt "Given in a trade"
	done

.str_max
	text "Met at ", $6e, "63+"
	done

TN_PrintCharacteristics:
	; b = currently highest stat value
	; e = currently highest stat index
	ld hl, wTempMonDVs
	; construct the HP value while accessing the others
	; d will hold it in the end
	lb de, 0, 2
	ld a, [hl]
	and $f
	ld c, a
	; c = defense
	ld a, [hli]
	swap a
	and $f
	; a = attack
	cp c
	; e = 2 from above
	ld b, c
	jr c, .first_cmp_done
	; attack currently max
	dec e ; e = 1
	ld b, a
.first_cmp_done
	rrca
	rl d
	srl c
	rl d
	ld a, [hl]
	and $f
	ld c, a
	; c = speed
	ld a, [hl]
	swap a
	and $f
	; a = special
	cp c
	; h = max value from the second DV byte
	; l = max index from the second DV byte
	ld l, 5
	ld h, c
	jr c, .got_sub_max
	dec l ; l = 4
	ld h, a
.got_sub_max
	rrca
	rl d
	srl c
	rl d
	ld a, b
	cp h
	jr nc, .got_main_max
	ld e, l
	ld b, h
.got_main_max
	ld a, b
	cp d
	jr nc, .skiphp
	ld e, 0
	ld b, d
.skiphp
	ld a, 4
	cp e
	jr nz, .skipspx
	; since DVs don't have SpA/SpD split, we determine it by OT ID
	ld a, [wTempMonID + 1]
	bit 0, a
	jr nz, .skipspx
	dec e
.skipspx
	; index with e * 5 + b % 5
	ld a, b
	ld c, 5
	call SimpleDivide
	add a
	add LOW(Characteristics)
	ld l, a
	adc HIGH(Characteristics)
	sub l
	ld h, a
	ld bc, 10
	ld a, e
	rst AddNTimes
	ld a, [hli]
	ld d, [hl]
	ld e, a
	hlcoord 1, 14
	jp PlaceText

TN_PrintAbility:
	ld hl, wTempMon
	call CalcPartyMonAbility
	ld [wd265], a
	call GetAbilityName
	hlcoord 1, 16
	jp PlaceString

Characteristics:
	dw .HP0, .HP1, .HP2, .HP3, .HP4
	dw .Attack0, .Attack1, .Attack2, .Attack3, .Attack4
	dw .Defense0, .Defense1, .Defense2, .Defense3, .Defense4
	dw .SpecialAttack0, .SpecialAttack1, .SpecialAttack2, .SpecialAttack3, .SpecialAttack4
	dw .SpecialDefense0, .SpecialDefense1, .SpecialDefense2, .SpecialDefense3, .SpecialDefense4
	dw .Speed0, .Speed1, .Speed2, .Speed3, .Speed4

.HP0:
	ctxt "Loves to eat"
	done
.HP1:
	ctxt "Takes plenty of"
	nl   "siestas"
	done
.HP2:
	ctxt "Nods off a lot"
	done
.HP3:
	ctxt "Scatters things"
	nl   "often"
	done
.HP4:
	ctxt "Likes to relax"
	done

.Attack0:
	ctxt "Proud of its"
	nl   "power"
	done
.Attack1:
	ctxt "Likes to thrash"
	nl   "about"
	done
.Attack2:
	ctxt "A little quick"
	nl   "tempered"
	done
.Attack3:
	ctxt "Likes to fight"
	done
.Attack4:
	ctxt "Quick tempered"
	done

.Defense0:
	ctxt "Sturdy body"
	done
.Defense1:
	ctxt "Capable of taking"
	nl   "hits"
	done
.Defense2:
	ctxt "Highly persistent"
	done
.Defense3:
	ctxt "Good endurance"
	done
.Defense4:
	ctxt "Good perseverance"
	done

.SpecialAttack0:
	ctxt "Highly curious"
	done
.SpecialAttack1:
	ctxt "Mischievous"
	done
.SpecialAttack2:
	ctxt "Thoroughly"
	nl   "cunning"
	done
.SpecialAttack3:
	ctxt "Often lost in"
	nl   "thought"
	done
.SpecialAttack4:
	ctxt "Very finicky"
	done

.SpecialDefense0:
	ctxt "Strong willed"
	done
.SpecialDefense1:
	ctxt "Somewhat vain"
	done
.SpecialDefense2:
	ctxt "Strongly defiant"
	done
.SpecialDefense3:
	ctxt "Hates to lose"
	done
.SpecialDefense4:
	ctxt "Somewhat stubborn"
	done

.Speed0:
	ctxt "Likes to run"
	done
.Speed1:
	ctxt "Alert to sounds"
	done
.Speed2:
	ctxt "Impetuous and"
	nl   "silly"
	done
.Speed3:
	ctxt "Somewhat of a"
	nl   "clown"
	done
.Speed4:
	ctxt "Quick to flee"
	done
