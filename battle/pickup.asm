CheckPickup::
	ld d, 0
	ld a, [wPartyCount]
.mon_loop
	sla d
	dec a
	ld [wCurPartyMon], a
	push af
	ld hl, wPartySpecies
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp EGG
	jr z, .next_mon
	ld [wCurSpecies], a
	ld a, MON_DVS
	call GetPartyParamLocation
	push de
	call CalcMonAbility
	pop de
	cp ABILITY_PICKUP
	jr nz, .next_mon
	call RandomPercentage
	cp 10
	jr nc, .next_mon
	ld a, MON_ITEM
	call GetPartyParamLocation
	ld a, [hl]
	and a
	jr nz, .next_mon
	inc d ; equivalent to set 0, d because d's lowest bit must be clear here
	push hl
	call RandomPercentage
	ld hl, .chances - 1
.item_selection_loop
	inc hl
	cp [hl]
	jr nc, .item_selection_loop
	ld bc, 10
	ld a, l
	sub LOW(.chances)
	ld hl, .items
	rst AddNTimes
	ld a, MON_LEVEL
	call GetPartyParam
	dec a
	call SimpleDivide ; note that c = 10 because AddNTimes and GetPartyParam preserve bc
	ld c, b
	ld b, 0
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hl], a
.next_mon
	pop af
	jr nz, .mon_loop
	ld a, d
.print_messages_loop
	srl a
	push af
	jr nc, .skip_message
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call SkipNames
	ld d, h
	ld e, l
	call CopyName1
	ld a, MON_ITEM
	call GetPartyParam
	ld [wd265], a
	call GetItemName
	ld hl, MonPickedUpPickupItem
	call StdBattleTextBox
.skip_message
	ld hl, wCurPartyMon
	inc [hl]
	pop af
	jr nz, .print_messages_loop
	ret

.chances
	db 30, 40, 50, 60, 70, 80, 90, 94, 98, 99, 100 ;cumulative percentages

.items
; Row corresponds to the random value
; Col corresponds to the level bracket
	db POTION,       ANTIDOTE,     SUPER_POTION, TINYMUSHROOM, REPEL,        ESCAPE_ROPE,  FULL_HEAL,    HYPER_POTION, BIG_MUSHROOM, REVIVE       ; 30%
	db ANTIDOTE,     SUPER_POTION, TINYMUSHROOM, REPEL,        ESCAPE_ROPE,  FULL_HEAL,    HYPER_POTION, BIG_MUSHROOM, REVIVE,       RARE_CANDY   ; 10%
	db SUPER_POTION, TINYMUSHROOM, REPEL,        ESCAPE_ROPE,  FULL_HEAL,    HYPER_POTION, BIG_MUSHROOM, REVIVE,       RARE_CANDY,   TRADE_STONE  ; 10%
	db TINYMUSHROOM, REPEL,        ESCAPE_ROPE,  FULL_HEAL,    HYPER_POTION, BIG_MUSHROOM, REVIVE,       RARE_CANDY,   TRADE_STONE,  NUGGET       ; 10%
	db REPEL,        ESCAPE_ROPE,  FULL_HEAL,    HYPER_POTION, BIG_MUSHROOM, REVIVE,       RARE_CANDY,   TRADE_STONE,  NUGGET,       HEART_SCALE  ; 10%
	db ESCAPE_ROPE,  FULL_HEAL,    HYPER_POTION, BIG_MUSHROOM, REVIVE,       RARE_CANDY,   TRADE_STONE,  MOON_STONE,   HEART_SCALE,  FULL_RESTORE ; 10%
	db FULL_HEAL,    HYPER_POTION, BIG_MUSHROOM, REVIVE,       RARE_CANDY,   TRADE_STONE,  MOON_STONE,   HEART_SCALE,  FULL_RESTORE, MAX_REVIVE   ; 10%
	db HYPER_POTION, GREAT_BALL,   REVIVE,       RARE_CANDY,   BIG_PEARL,    MOON_STONE,   HEART_SCALE,  FULL_RESTORE, MAX_REVIVE,   LEFTOVERS    ; 4%
	db ORNGAPRICORN, CYANAPRICORN, GREYAPRICORN, YLW_APRICORN, BLK_APRICORN, RED_APRICORN, BLU_APRICORN, PNK_APRICORN, WHT_APRICORN, GRN_APRICORN ; 4% - Replace with Generic Apricorn that is picked based on ballmaking level
	db HYPER_POTION, NUGGET,       KINGS_ROCK,   MOON_STONE,   ETHER,        EVERSTONE,    MAX_REVIVE,   ELIXIR,       BERSERK_GENE, BERSERK_GENE ; 1%
	db NUGGET,       KINGS_ROCK,   MOON_STONE,   ETHER,        EVERSTONE,    MAX_REVIVE,   ELIXIR,       POWER_HERB,   LEFTOVERS,    PRISM_SCALE  ; 1%
