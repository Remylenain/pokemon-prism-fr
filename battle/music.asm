PlayBattleMusic:
	push hl
	push de
	push bc

	xor a
	ld [wMusicFade], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	call MaxVolume

	ld a, [wBattleType]
	cp BATTLETYPE_SUICUNE
	ld de, MUSIC_SUICUNE_BATTLE
	jp z, .done
	cp BATTLETYPE_ROAMING
	jp z, .done

	; Are we fighting a trainer?
	ld a, [wOtherTrainerClass]
	and a
	jr nz, .trainermusic

	ld a, [wTempEnemyMonSpecies]
	ld hl, .legendaries
	call .loadfromarray
	jr c, .done

	ld hl, .wilds
	call .getregionmusicfromarray
	jr .done

.trainermusic
	ld hl, .trainers
	call .loadfromarray
	jr c, .done

	ld de, MUSIC_KANTO_GYM_LEADER_BATTLE
	callba IsKantoGymLeader
	jr c, .done

	ld de, MUSIC_RIJON_GYM_LEADER_BATTLE
	callba IsRijonGymLeader
	jr c, .done

	ld de, MUSIC_NALJO_GYM_LEADER_BATTLE
	callba IsNaljoGymLeader
	jr c, .done

	ld de, MUSIC_JOHTO_GYM_LEADER_BATTLE
	callba IsJohtoGymLeader
	jr c, .done

.othertrainer
	ld a, [wLinkMode]
	and a
	ld de, MUSIC_JOHTO_TRAINER_BATTLE
	jr nz, .done

	ld hl, .normal_trainers
	call .getregionmusicfromarray

.done
	call PlayMusic

	pop bc
	pop de
	pop hl
	ret

.loadfromarray
	ld e, 3
	call IsInArray
	ret nc
	inc hl
	jr .found

.getregionmusicfromarray
	push hl
	callba RegionCheck
	pop hl
	ld d, 0
	add hl, de
	add hl, de
.found
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ret

.legendaries
	dbw ARTICUNO, MUSIC_KANTO_LEGENDARY
	dbw ZAPDOS,   MUSIC_KANTO_LEGENDARY
	dbw MOLTRES,  MUSIC_KANTO_LEGENDARY
	dbw MEWTWO,   MUSIC_KANTO_LEGENDARY
	dbw MEW,      MUSIC_MEW_BATTLE
	dbw PHANCERO, MUSIC_KANTO_LEGENDARY
	dbw HO_OH,    MUSIC_HOOH_BATTLE
	dbw LUGIA,    MUSIC_LUGIA_BATTLE
	dbw KYOGRE,   MUSIC_HOENN_LEGENDARY
	dbw GROUDON,  MUSIC_HOENN_LEGENDARY
	dbw RAYQUAZA, MUSIC_HOENN_LEGENDARY
	db $ff

.wilds
	dw MUSIC_NALJO_WILD_BATTLE
	dw MUSIC_RIJON_WILD_BATTLE
	dw MUSIC_JOHTO_WILD_BATTLE
	dw MUSIC_RIJON_WILD_BATTLE
	dw MUSIC_SEVII_WILD_BATTLE
	dw MUSIC_TUNOD_WILD_BATTLE
	dw MUSIC_NALJO_WILD_BATTLE

.trainers
	dbw RED,            MUSIC_WORLD_CHAMPION_BATTLE
	dbw GOLD,           MUSIC_CHAMPION_BATTLE
	dbw BROWN,          MUSIC_HOENN_CHAMPION_BATTLE
	dbw CHAMPION,       MUSIC_CHAMPION_BATTLE
	dbw PATROLLER,      MUSIC_PALETTE_BATTLE
	dbw GRUNTM,         MUSIC_ROCKET_BATTLE
	dbw ARCADEPC_GROUP, MUSIC_BATTLE_ARCADE_BATTLE
	dbw ERNEST,         MUSIC_TUNOD_GYM_BATTLE
	dbw RIVAL1,         MUSIC_RIVAL_BATTLE
	dbw SCIENTIST,      MUSIC_MAGMA_BATTLE
	dbw YUKI,           MUSIC_RIJON_E4_BATTLE
	dbw SORA,           MUSIC_RIJON_E4_BATTLE
	dbw MURA,           MUSIC_RIJON_E4_BATTLE
	dbw DAICHI,         MUSIC_RIJON_E4_BATTLE
	dbw CANDELA,        MUSIC_TOWER_TYCOON_BATTLE
	dbw BLANCHE,        MUSIC_TOWER_TYCOON_BATTLE
	dbw SPARK_T,        MUSIC_TOWER_TYCOON_BATTLE
	db $ff

.normal_trainers
	dw MUSIC_NALJO_TRAINER_BATTLE
	dw MUSIC_RIJON_TRAINER_BATTLE
	dw MUSIC_JOHTO_TRAINER_BATTLE
	dw MUSIC_KANTO_TRAINER_BATTLE
	dw MUSIC_SEVII_TRAINER_BATTLE
	dw MUSIC_TUNOD_TRAINER_BATTLE
	dw MUSIC_JOHTO_TRAINER_BATTLE
