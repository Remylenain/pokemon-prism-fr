MiningScript::
	killsfx
	checkflag ENGINE_POKEMON_MODE
	sif true
		end
	; Regular players won't have a mining pick anyways...
	; Putting this here simplifies the code later on.
	checkflag ENGINE_WILDS_DISABLED
	sif true
		end
	opentext
	; Check mining pick
	checkitem IRON_PICKAXE
	sif true, then
		copybytetovar wMiningPickaxeMode
	selse
		writebyte 2
	sendif
	scriptjumptable .MiningModes
	sif false, then
		copybytetovar wIronPickaxeStepCount
		multiplyvar -1
		addvar 250
		copyvartobyte wScriptBuffer
		checkitem IRON_PICKAXE
		sif true, then
			copybytetovar wMiningPickaxeMode
		selse
			writebyte 2 ;pretend we're always in mode 3 if we don't have the Iron Pickaxe
		sendif
		playsound SFX_READ_TEXT_2
		loadarray .MiningFailureTextsArray
		readarrayhalfword 0
		writebyte 0
		jumptext -1
	selse
		copyvartobyte wScriptBuffer
	sendif

	;We have mining pick
	playwaitsfx SFX_BEAT_UP
	scall ExtractItem
	sif false, then
		writetext NoItemExtracted
	selse
		; save the obtained item in case our bag is full
		copyvartobyte wSavedMiningItem
		; special check for fossil
		sif =, FOSSIL, then
			; check for fossil case
			checkitem FOSSIL_CASE
			sif false, then
				writebyte 2
				loadvar wSavedMiningItem, 0
			selse
				writehalfword wFossilCaseCount
				copyhalfwordvartovar
				sif >, FOSSIL_CASE_SIZE - 1, then
					writebyte 1
				selse
					addvar 1
					copyvartohalfwordvar
					addhalfwordvartovar
					random 4
					copyvartohalfwordvar
					addhalfwordtohalfwordvar 1
					loadhalfwordvar $ff
					writebyte 0
				sendif
			sendif
			writetext ReceivedFossilText
			loadarray .FossilTextArray
			readarrayhalfword 0
			sif false, then
				killsfx
				playwaitsfx SFX_ITEM
			selse
				buttonsound
			sendif
			writetext -1
			sif true, then
				writebyte 0
			selse
				writebyte 1
			sendif
		selse
			verbosegiveitem SPECIAL_ITEM, 1
		sendif

		sif true, then
			waitbutton
			loadvar wSavedMiningItem, 0
		selse
			closetextend
		sendif
	sendif
	copybytetovar wScriptBuffer
	sif =, 1, then
		takeitem MINING_PICK, 1
	selse
		loadvar wIronPickaxeStepCount, 0
	sendif

	writebyte 1
	givecraftingEXP CRAFT_MINING
	closetextend

.MiningModes:
	dw .onlyCheckIronPick
	dw .smartCheckBothPicks
	dw .onlyCheckNormalPicks

.onlyCheckIronPick:
; iron pick is already before call
	writebyte 250
	comparevartobyte wIronPickaxeStepCount
	sif true
		writebyte 2
	end

.smartCheckBothPicks:
	scall .onlyCheckIronPick
	sif false
		; checkitem from fallthrough

; fallthrough
.onlyCheckNormalPicks:
	checkitem MINING_PICK
	; sif true, writebyte 1 would be a noop
	end

.MiningFailureTextsArray:
	dw IronPickaxeNotChargedText
.MiningFailureTextsArrayEntrySizeEnd:
	dw IronPickaxeNotChargedNoMiningPickText
	dw NoMiningPickText

.FossilTextArray:
	dw PutFossilInCaseText
.FossilTextArrayEntrySizeEnd:
	dw NoRoomForFossilText
	dw NoFossilCaseText

ExtractItem:
	copybytetovar wSavedMiningItem
	sif true
		end
	copybytetovar wMiningLevel
	divideby 2
	loadarray MiningPickItemTable, 1
	variablestablerandom VSR_MINING, 100
	readarray -1
	sif !=, SPECIAL_ITEM
		end
	copybytetovar wMapGroup
	addvar -1
	loadarray MiningSpecialItems, 1
	readarray 0
	end

NoMiningPickText:
	ctxt "You need a Mining"
	line "Pick to mine."
	done

IronPickaxeNotChargedNoMiningPickText:
	ctxt "You need a Mining"
	line "Pick to mine, and"
	para "t@"
	text_jump IronPickaxeNotChargedText.continue

IronPickaxeNotChargedText:
	text "T@"
.continue
	ctxt "he Iron Pickaxe"
	line "isn't charged yet."
	para "Walk @"
	deciram wScriptBuffer, 1, 3
	ctxt " more"
	line "step@"
	start_asm
	ld hl, .ending
	ld a, [wScriptBuffer]
	dec a
	ret z
	ld a, "s"
	ld [bc], a
	inc bc
	ret
.ending
	ctxt " for it to"
	cont "recharge."
	done

NoItemExtracted::
	ctxt "Unable to extract"
	line "anything."
	sdone

ReceivedFossilText:
	ctxt "<PLAYER> received"
	line "a Fossil!"
	done

PutFossilInCaseText:
	ctxt "<PLAYER> put the"
	line "Fossil in the"
	cont "Fossil Case."
	done

NoRoomForFossilText:
	ctxt "But the Fossil"
	line "Case is full<...>"
	sdone

NoFossilCaseText:
	ctxt "But <PLAYER> doesn't"
	line "have a Fossil"
	cont "Case<...>"
	sdone

MiningPickItemTable:
	; pick the first 100 items starting at an index of level/2
	rept 29
		db NO_ITEM
	endr
	rept 7
		db GOLD_DUST
	endr
	rept 10
		db HEART_SCALE
	endr
	rept 13
		db COAL
		db ORE
	endr
	db HARD_STONE
	db REVIVE
	db SPECIAL_ITEM
	db SPECIAL_ITEM
	rept 5
		db EVERSTONE
	endr
	db HARD_STONE
	db SPECIAL_ITEM
	db KINGS_ROCK
	db SPECIAL_ITEM
	db REVIVE
	db SPECIAL_ITEM
	rept 2
		db COAL
		db ORE
	endr
	rept 4
		db HEART_SCALE
	endr
	db FOSSIL
	db LEAF_STONE
	db FIRE_STONE
	db WATER_STONE
	db THUNDERSTONE
	db SHINY_STONE
	db TRADE_STONE
	db DAWN_STONE
	db DUSK_STONE
	rept 8
		db COAL
		db ORE
	endr
	db HARD_STONE
	db CHARCOAL
	db KINGS_ROCK
	db KINGS_ROCK
	db REVIVE
	db STARDUST
	rept 9
		db SPECIAL_ITEM
	endr
	db LIGHT_CLAY
	db REVIVE
	db STARDUST
	db MAX_REVIVE
	db NUGGET
	db STAR_PIECE
	db LEAF_STONE
	db FIRE_STONE
	db WATER_STONE
	db THUNDERSTONE
	db SHINY_STONE
	db TRADE_STONE
	db DAWN_STONE
	db DUSK_STONE
	db BIG_NUGGET

	assert (@ - MiningPickItemTable) == 150

MiningSpecialItems: ;Ordered by Map Group
	db NO_ITEM ; Intro Area & Cave
	db ICY_ROCK ; Caper
	db COAL ; Oxalis
	db COAL ; Spurge
	db LEAF_STONE ; Heath
	db WATER_STONE ; Laurel & Magikarp Caverns
	db NO_ITEM ; Torenia
	db ORE ; Phacelia
	db HARD_STONE ; Saxifrage
	db ICY_ROCK ; Phlox
	db NO_ITEM ; Acania
	db ENERGYPOWDER ; Route 68
	db ICY_ROCK ; Route 69
	db ICY_ROCK ; Route 70
	db ICY_ROCK ; Route 71
	db ICY_ROCK ; Route 72
	db DAMP_ROCK ; Route 73
	db STARDUST ; Route 74
	db COAL ; Route 75
	db NO_ITEM ; Route 76
	db GOLD_DUST ; Route 77
	db SOFT_SAND ; Route 78
	db SMOOTH_ROCK ; Route 79
	db SOFT_SAND ; Route 80
	db BRICK_PIECE ; Route 81
	db SMOOTH_ROCK ; Route 82
	db DAMP_ROCK ; Route 83
	db ICY_ROCK ; Route 84
	db HEAT_ROCK ; Route 85
	db FOSSIL ; Route 86 & Faraway Island
	db WATER_STONE ; Acqua Mines
	db GOLD_DUST ; Mound Cave
	db ENERGYPOWDER ; Laurel Forest
	db FOSSIL ; Milos Catacombs
	db FIRE_STONE ; Provincial Park
	db FIRE_STONE ; Firelight Caverns
	db LIGHT_CLAY ; Naljo Ruins
	db ICY_ROCK ; Clathrite
	db COAL ; Naljo Border
	db COAL ; N/A
	db ORE ; Long Tunnel
	;Rijon
	db FOSSIL ; Seashore
	db HARD_STONE ; Gravel
	db HARD_STONE ; Merson
	db EVERSTONE ; Hayward
	db NO_ITEM ; Owsauri
	db ENERGYPOWDER ; Moraga
	db ENERGYPOWDER ; Jaeru
	db DUSK_STONE ; Botan
	db NO_ITEM ; Castro
	db HEAT_ROCK ; Eagulou
	db GOLD_DUST ; Rijon League
	db NO_ITEM ; Route 47
	db STARDUST ; Route 48
	db NO_ITEM ; Route 49
	db NO_ITEM ; Route 50
	db NO_ITEM ; Route 51
	db DAMP_ROCK ; Route 52
	db HARD_STONE ; Route 53
	db HARD_STONE ; Route 54
	db COAL ; Route 55
	db HEAT_ROCK ; Route 56
	db NO_ITEM ; Route 57
	db ORE ; Route 58
	db ENERGYPOWDER ; Route 59
	db NO_ITEM ; Route 60
	db NO_ITEM ; Route 61
	db NO_ITEM ; Route 62
	db COAL ; Route 63
	db HARD_STONE ; Route 64
	db GOLD_DUST ; Route 65
	db DAMP_ROCK ; Route 66
	db GOLD_DUST ; Route 67
	db HARD_STONE ; Merson Cave
	db ICY_ROCK ; Silk Tunnel & Mt. Boulder B1F
	db NO_ITEM ; Castro Forest
	db LEAF_STONE ; Mt. Boulder B2F
	db NO_ITEM ; Rijon Underground
	db MOON_STONE ; Seneca Caverns
	db NO_ITEM ; Haunted Forest & Mansion
	; Etc
	db KINGS_ROCK ; Azalea
	db NO_ITEM ; Ilex Forest
	db TRADE_STONE ; Route 34
	db THUNDERSTONE ; Goldenrod & Goldenrod Cape
	db TRADE_STONE ; Saffron
	db FIRE_STONE ; Olcan Isle
	db NO_ITEM ; Battle Arcade
	db FIRE_STONE ; Ember Brook & Mt. Ember
	db DAWN_STONE ; Southerly & Surroundings
	db NO_ITEM ; Pokecenter Backrooms
	db NO_ITEM ; Battle Tower Rooms
	db NO_ITEM ; Phlox Labs
	db NO_ITEM ; Phancero Room
	db FOSSIL ; Mystery Zone
	db STAR_PIECE ; Sevii Islands
