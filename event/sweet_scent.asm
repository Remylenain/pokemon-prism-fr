SweetScentFromMenu:
	ld hl, SweetScentScript
	call QueueScript
	ld a, 1
	ld [wFieldMoveSucceeded], a
	ret

SweetScentScript:
	reloadmappart
	special UpdateTimePals
	callasm GetPartyNick
	farwritetext SweetScentText
	closetext

	farscall FieldMovePokepicScript

	callasm SweetScentEncounter
	sif false
		farjumptext SweetScentNothingHere
	randomwildmon
	startbattle
	reloadmapafterbattle
	end

SweetScentEncounter:
	callba CanUseSweetScent
	jr nc, .save_carry
	callba GetMapEncounterRate
	ld a, b
	and a
	jr z, .save_carry ; CF = 0
	callba ChooseWildEncounter
.save_carry
	ld a, 0
	rla
	ldh [hScriptVar], a
	ret
