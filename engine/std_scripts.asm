StdScripts::
	dba PokeCenterNurseScript
	dba DifficultBookshelfScript
	dba PictureBookshelfScript
	dba MagazineBookshelfScript
	dba FastCurrentScript
	dba MerchandiseShelfScript
	dba TownMapScript
	dba MiningScript
	dba JumpingShoesScript
	dba SmeltingScript
	dba TrashCanScript
	dba AskStrengthScript
	dba AskRockSmashScript
	dba PokeCenterSignScript
	dba MartSignScript
	dba MagnetTrainSignScript
	dba ElevatorButtonScript
	dba InitializeEventsScript
	dba GymStatue1Script
	dba GymStatue2Script
	dba PCScript
	dba GameCornerCoinVendorScript
	dba HappinessCheckScript
	dba TVTextScript
	dba HandleCageKeyDoor
	dba TradeScript
	dba QRCodeScript
	dba OasisScript
	dba MagneticTapeDriveScript

PokeCenterNurseScript:
	opentext
	checktime 1 << NITE
	sif true, then
		farwritetext NurseNiteText
	selse
		checktime 1 << MORN
		sif true, then
			farwritetext NurseMornText
		selse
			farwritetext NurseDayText
		sendif
	sendif
	buttonsound
	; only do this once
	farwritetext NurseAskHealText
	yesorno
	sif true, then
		farwritetext NurseTakePokemonText
		pause 20
		spriteface LAST_TALKED, LEFT
		pause 10
		special HealParty
		writebyte 0 ; Machine is at a Pokemon Center
		special HealMachineAnim
		waitsfx
		spriteface LAST_TALKED, DOWN
		pause 10
		checkflag ENGINE_POKERUS
		sif false, then
			special SpecialCheckPokerus
			sif true, then
				; already cleared earlier in the script
				setflag ENGINE_POKERUS
				farjumptext NursePokerusText
			sendif
		sendif
		farwritetext NurseReturnPokemonText
		pause 20
	sendif
	farwritetext NurseGoodbyeText
	spriteface LAST_TALKED, UP
	pause 10
	spriteface LAST_TALKED, DOWN
	pause 10
	endtext

DifficultBookshelfScript:
	farjumptext DifficultBookshelfText

PictureBookshelfScript:
	farjumptext PictureBookshelfText

MagazineBookshelfScript:
	farjumptext MagazineBookshelfText

FastCurrentScript:
	farjumptext FastCurrentText

MerchandiseShelfScript:
	farjumptext MerchandiseShelfText

MagneticTapeDriveScript:
	farjumptext MagneticTapeDriveText

TownMapScript:
	opentext
	farwritetext TownMapText
	waitbutton
	special Special_TownMap
	closetextend

JumpingShoesScript:
	checkevent EVENT_JUMPING_SHOES
	sif false
		end
	playsound SFX_JUMP_OVER_LEDGE
	checkcode VAR_FACING
	multiplyvar 2
	addhalfwordtovar .movements
	applymovement PLAYER, -1
	end

.movements
	jump_step_down
	step_end

	jump_step_up
	step_end

	jump_step_left
	step_end

	jump_step_right
	step_end

TrashCanScript:
	farjumptext TrashCanText

PCScript:
	opentext
	special PokemonCenterPC
	closetextend

ElevatorButtonScript:
	playsound SFX_READ_TEXT_2
	pause 15
	playsound SFX_ELEVATOR_END
	end

PokeCenterSignScript:
	farjumptext PokeCenterSignText

MartSignScript:
	farjumptext MartSignText

MagnetTrainSignScript:
	farjumptext MagnetTrainSignText

;PRISM: This needs a couple
InitializeEventsScript:
	wildoff
	setevent EVENT_NO_POKEDEX_YET
	setevent EVENT_LAUREL_CITY_HIDDEN_TOTODILE
	setevent EVENT_BROOKLYN_NOT_IN_FOREST
	setevent EVENT_AGGRON_NOT_IN_FIRELIGHT
	setevent EVENT_FIRELIGHT_POLICE
	setevent EVENT_NOBU_NOT_IN_HOUSE
	setevent EVENT_SAXIFRAGE_LIGHT_OFF_1
	setevent EVENT_SAXIFRAGE_LIGHT_OFF_2
	setevent EVENT_SAXIFRAGE_LIGHT_OFF_3
	setevent EVENT_BLUE_NOT_ON_FIRST_FLOOR
	setevent EVENT_PHLOX_LAB_OFFICER
	setevent EVENT_FAMBACO
	setevent EVENT_INITIALIZED_EVENTS
	variablesprite SPRITE_CASTRO_GYM_1, SPRITE_KOJI
	variablesprite SPRITE_CASTRO_GYM_2, SPRITE_KOJI
	variablesprite SPRITE_CASTRO_GYM_3, SPRITE_KOJI
	variablesprite SPRITE_CASTRO_GYM_4, SPRITE_KOJI
	return

GymStatue1Script:
	mapnametotext 0
	farjumptext GymStatue_CityGymText

GymStatue2Script:
	mapnametotext 0
	opentext
	farwritetext GymStatue_CityGymText
	buttonsound
	farjumptext GymStatue_WinningTrainersText

GameCornerCoinVendorScript:
	faceplayer
	opentext
	farwritetext CoinVendor_WelcomeText
	buttonsound
	checkitem COIN_CASE
	sif false
		farjumptext CoinVendor_NoCoinCaseText
	farwritetext CoinVendor_IntroText
.loop
	special Special_DisplayMoneyAndCoinBalance
	loadmenudata .MenuHeader
	verticalmenu
	closewindow
	sif >, 2
.cancel
		farjumptext CoinVendor_CancelText
	anonjumptable
	dw .cancel
	dw .Buy50
	dw .Buy500

.Buy50
	checkcoins 9949
	sif false
		farjumptext CoinVendor_CoinCaseFullText
	checkmoney 0, 1000
	sif =, 2
		farjumptext CoinVendor_NotEnoughMoneyText
	givecoins 50
	takemoney 0, 1000
	waitsfx
	playsound SFX_TRANSACTION
	farwritetext CoinVendor_Buy50CoinsText
	jump .loop

.Buy500
	checkcoins 9499
	sif false
		farjumptext CoinVendor_CoinCaseFullText
	checkmoney 0, 10000
	sif =, 2
		farjumptext CoinVendor_NotEnoughMoneyText
	givecoins 500
	takemoney 0, 10000
	waitsfx
	playsound SFX_TRANSACTION
	farwritetext CoinVendor_Buy500CoinsText
	jump .loop

.MenuHeader
	db $40 ; flags
	db 04, 00 ; start coords
	db 11, 15 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $80 ; flags
	db 3 ; items
	db " 50 :  ¥1000@"
	db "500 : ¥10000@"
	db "Cancel@"

HappinessCheckScript:
	faceplayer
	opentext
	special GetFirstPokemonHappiness
	sif <, 50
		farjumptext HappinessText1
	sif <, 150
		farjumptext HappinessText2
	farjumptext HappinessText3

TVTextScript:
	checkcode VAR_FACING
	sif =, UP
		farjumptext TVText
	farjumptext OopsWrongSideText

TalkToTrainerScript::
	faceplayer
	trainerflagaction CHECK_FLAG
	sif true
		scripttalkafter
	loadmemtrainer
	encountermusic
	jump StartBattleWithMapTrainerScript

SeenByTrainerScript::
	loadmemtrainer
	encountermusic
	showemote EMOTE_SHOCK, LAST_TALKED, 30, 0
	callasm TrainerWalkToPlayer
	applymovement2 wMovementBuffer
	writepersonxy LAST_TALKED
	faceperson PLAYER, LAST_TALKED
	; fallthrough

StartBattleWithMapTrainerScript:
	opentext
	trainertext 0
	waitbutton
	closetext
	loadmemtrainer
	startbattle
	reloadmapafterbattle
	trainerflagaction SET_FLAG
	callasm FreezeTrainerFacing
	loadvar wRunningTrainerBattleScript, -1
	scripttalkafter

TradeScript:
	faceplayer
	opentext
	scriptstartasm
	ldh a, [hScriptVar]
	ld e, a
	callba NPCTrade
	scriptstopasm
	endtext

OasisScript:
	opentext
	writetext .its_an_oasis_text
	yesorno
	closetext
	sif false
		end
	special ClearBGPalettes
	special HealParty
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	jumptext .party_healed_text

.its_an_oasis_text
	ctxt "It's an oasis!"

	para "Want to take a"
	line "relaxing dip?"
	done

.party_healed_text
	ctxt "That was soothing!"

	para "Your #mon are"
	line "now fully healed!"
	done
