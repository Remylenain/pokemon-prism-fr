LoadEnemyMon:
; Initialize enemy monster parameters
; To do this we pull the species from wTempEnemyMonSpecies

; Notes:
;   BattleRandom is used to ensure sync between Game Boys

; Clear the whole enemy mon struct (wEnemyMon)
	xor a
	ld hl, wEnemyMonSpecies
	ld bc, wEnemyMonEnd - wEnemyMon
	call ByteFill
	ld a, 1
	ld [wEnemyJustSentMonOut], a

; We don't need to be here if we're in a link battle
	ld a, [wLinkMode]
	and a
	jr nz, .init_enemy_non_zero

; and also in a BattleTower-Battle
	ld a, [wInBattleTowerBattle]
	and 5
.init_enemy_non_zero
	jp nz, InitEnemyMon

; Check ability of top party mon and store into b. Used for Compoundeyes. This needs to
; be done before the wildmon species metadata is loaded since this also needs to load
; species metadata on its own
	ld hl, wPartyMon1 ; Yes, always the lead, even if fainted
	call CalcPartyMonAbility
	ld b, a

; Make sure everything knows what species we're working with
	ld a, [wTempEnemyMonSpecies]
	ld [wEnemyMonSpecies], a
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a

; Grab the BaseData for this species. Preserve bc (partymon1 ability)
	push bc
	call GetBaseData
	pop bc

; Let's get the item:

; Is the item predetermined?
	ld a, [wBattleMode]
	dec a
	jr z, .wild_item

; If we're in a trainer battle, the item is in the party struct
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMon1Item
	call GetPartyLocation ; bc = PartyMon[wCurPartyMon] - wPartyMons
	ld a, [hl]
	jr .update_item

.wild_item
; In a wild battle, we pull from the item slots in BaseData

; Force Item1
; Used for Ho-Oh, Lugia and Snorlax encounters
	ld a, [wWildMonCustomItem]
	and a
	jr z, .not_custom_item
	ld [wEnemyMonItem], a
	xor a
	ld [wWildMonCustomItem], a
	jr .got_enemy_item
.not_custom_item
	ld a, [wBattleType]
	cp BATTLETYPE_FORCEITEM
	ld a, [wBaseItems]
	jr z, .update_item

; Failing that, it's all up to chance
;  Effective chances:
;    75% None
;    23% Item1
;     2% Item2

; Chance of getting an item: 37.5%/25% with/without Compoundeyes
	ld a, b
	ld c, $40
	cp ABILITY_COMPOUNDEYES
	jr nz, .no_compoundeyes
	set 5, c ; c = $60
.no_compoundeyes
	call BattleRandom
	cp c
	ld a, NO_ITEM
	jr nc, .update_item

; From there, an 8% chance for Item2
	callba BattleRandomPercentage
	cp 8 ; 8% of 25% = 2% Item2
	ld a, [wBaseItems]
	jr nc, .update_item
	ld a, [wBaseItems + 1]

.update_item
	ld [wEnemyMonItem], a
.got_enemy_item
; Initialize DVs

	ld a, [wBattleMode]
	and a
	jr z, .init_DVs

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .init_DVs

	ld hl, wEnemyBackupDVs
	ld de, wEnemyMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jr .done_DVs

.init_DVs

; Trainer DVs
; All trainers have preset DVs, determined by class
; See GetTrainerDVs for more on that
	callba GetTrainerDVs
; These are the DVs we'll use if we're actually in a trainer battle
	ld a, [wBattleMode]
	dec a
	jr nz, .update_DVs

; Wild DVs
; Here's where the fun starts

; Roaming monsters (Entei, Raikou) work differently
; They have their own structs, which are shorter than normal
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .not_roaming

; Grab HP
	ld hl, wRoamMon1HP
	ld a, [hli]
; Check if the HP has been initialized
	or [hl]
; We'll do something with the result in a minute
	push af

; Grab DVs
	ld hl, wRoamMon1DVs + 1
	ld a, [hld]
	ld c, a
	ld b, [hl]

; Get back the result of our check
	pop af
; If the RoamMon struct has already been initialized, we're done
	jr nz, .update_DVs

; If it hasn't, we need to initialize the DVs
; (HP is initialized at the end of the battle)
	ld hl, wRoamMon1DVs + 1
	call BattleRandom
	ld [hld], a
	ld c, a
	call BattleRandom
	ld [hl], a
	ld b, a
; We're done with DVs
	jr .update_DVs

.not_roaming
; Register a contains wBattleType

; Forced shiny battle type
; Used by Red Gyarados at Lake of Rage
	cp BATTLETYPE_SHINY
	lb bc, ATKDEFDV_SHINY, SPDSPCDV_SHINY
	jr z, .update_DVs

.check_park_minigame
; If we're in the park minigame, DVs are already generated
	CheckEngine ENGINE_PARK_MINIGAME
	jr z, .generate_DVs
	ld hl, wParkMinigameCurrentSpotDVs
	ld a, [hli]
	ld b, a
	ld c, [hl]
	jr .update_DVs

.generate_DVs
; Generate new random DVs
	call BattleRandom
	ld b, a
	call BattleRandom
	ld c, a

.update_DVs
; Input DVs in register bc
	ld hl, wEnemyMonDVs
	ld a, b
	ld [hli], a
	ld [hl], c
.done_DVs

; Set happiness
	ld a, [wBattleMode]
	dec a
	ld a, $ff ; Give the enemy mon max happiness...
	jr nz, .load_happiness ; ...if it's a Trainer battle.
	ld a, BASE_HAPPINESS
.load_happiness
	ld [wEnemyMonHappiness], a
; Set level
	ld a, [wCurPartyLevel]
	ld [wEnemyMonLevel], a
; Fill stats
	ld de, wEnemyMonMaxHP
	ld b, FALSE
	ld hl, wEnemyMonDVs + (MON_STAT_EXP - 1) - (MON_DVS)
	predef CalcPkmnStats

; If we're in a trainer battle,
; get the rest of the parameters from the party struct
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr z, .opponent_party

; If we're in a wild battle, check wild-specific stuff
	and a
	jr z, .tree_mon

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .load_moves

.tree_mon
; If we're headbutting trees, some monsters enter battle asleep
	call CheckSleepingTreeMon
	sbc a
	and SLP ; sets a to SLP (7 turns) if the function returned carry, 0 otherwise
	ld hl, wEnemyMonStatus
	ld [hli], a

	xor a
	ld [hli], a ; wEnemyMonSemistatus

; Full HP..
	ld a, [wEnemyMonMaxHP]
	ld [hli], a
	ld a, [wEnemyMonMaxHP + 1]
	ld [hl], a

; ..unless it's a RoamMon
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .load_moves

; Grab HP
	ld hl, wRoamMon1HP
	ld a, [hli]
; Check if it's been initialized again
	or [hl]
	jr z, .initialize_roam_mon_HP
; Update from the struct if it has
	ld a, [hl]
	ld [wEnemyMonHP + 1], a
	jr .load_moves

.initialize_roam_mon_HP
	ld a, [wEnemyMonHP + 1]
	ld [hld], a
	ld a, [wEnemyMonHP]
	ld [hl], a
	jr .load_moves

.opponent_party
; Get HP from the party struct
	ld hl, (wOTPartyMon1HP + 1)
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld a, [hld]
	ld [wEnemyMonHP + 1], a
	ld a, [hld]
	ld [wEnemyMonHP], a

; Make sure everything knows which monster the opponent is using
	ld a, [wCurPartyMon]
	ld [wCurOTMon], a

; Get status from the party struct
	dec hl
	ld a, [hl] ; OTPartyMonStatus
	ld [wEnemyMonStatus], a

.load_moves
	ld hl, wBaseType1
	ld de, wEnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

; Get moves
	ld de, wEnemyMonMoves
; Are we in a trainer battle?
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr nz, .wild_mon_moves
; Then copy moves from the party struct
	ld hl, wOTPartyMon1Moves
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld bc, NUM_MOVES
	rst CopyBytes
	jr .load_PP

.wild_mon_moves
; Clear wEnemyMonMoves
	ld a, [wWildMonCustomMoves]
	and a
	jr z, .no_custom_wild_mon_moves
	ld hl, wWildMonCustomMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	xor a
	ld [wWildMonCustomMoves], a
	jr .load_PP
.no_custom_wild_mon_moves
	xor a
	ld h, d
	ld l, e
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
; Make sure the predef knows this isn't a partymon
	ld [wFillMoves_IsPartyMon], a
; Fill moves based on level
	predef FillMoves

.load_PP
; Trainer battle?
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr z, .load_trainer_PP

; Fill wild PP
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	predef FillPP
	jr .done_loading_PP

.load_trainer_PP
; Copy PP from the party struct
	ld hl, wOTPartyMon1PP
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld de, wEnemyMonPP
	ld bc, NUM_MOVES
	rst CopyBytes
.done_loading_PP

; Only the first five base stats are copied..
	ld hl, wBaseStats
	ld de, wEnemyMonBaseStats
	ld b, wBaseSpecialDefense - wBaseStats
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop

	ld a, [wBaseCatchRate]
	ld [de], a
	inc de

	ld a, [wBaseExp]
	ld [de], a

	ld a, [wTempEnemyMonSpecies]
	ld [wd265], a

	call GetPokemonName

; Did we catch it?
	ld a, [wBattleMode]
	and a
	ret z

; Update enemy nick
	ld hl, wStringBuffer1
	ld de, wEnemyMonNick
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

; Saw this mon
	ld a, [wTempEnemyMonSpecies]
	dec a
	ld c, a
	ld b, SET_FLAG
	ld hl, wPokedexSeen
	predef FlagAction

	ld hl, wEnemyMonStats
	ld de, wEnemyStats
	ld bc, wEnemyMonStatsEnd - wEnemyMonStats
	rst CopyBytes

	jp CalcEnemyAbility
