UpdateCageKeyDoorsScript::
	writebyte 0
	pushvar
.loop
	pullvar
	scall GetCageKeyDoorArrayPointer
	iffalse .skip
	cmdwitharrayargs
	db changeblock_command, %111, 2, 3, 4
	endcmdwitharrayargs
.skip
	popvar
	addvar 1
	pushvar
	comparevartobyte wCageKeyDoorsArrayLength
	if_equal 1, .loop
	popvar
	return_if_callback_else_end

HandleCageKeyDoor::
	scall GetCageKeyDoorArrayPointer
	sif true
		end
	playsound SFX_READ_TEXT_2
	checkitem CAGE_KEY
	sif false
		jumptext .need_key_text
	scall TryUnlockDoor
	sif false
		end
	setevent -1
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	scall UpdateCageKeyDoorsScript
	refreshscreen 0
	reloadmappart
	end

.need_key_text
	ctxt "You need a Cage"
	line "Key to unlock"
	cont "this door."
	done

TryUnlockDoor::
	; returns true or false indicating whether the door is unlocked
	opentext
	checkcode VAR_MAPGROUP
	if_equal GROUP_EAGULOU_CITY, .unlock
	checkevent EVENT_EAGULOU_GYM_B1F_ITEM_CAGE_KEY
	sif true, then
		checkevent EVENT_EAGULOU_DOOR_2
		iftrue .unlock
		takeitem CAGE_KEY, 2
		sif false
			jumptext .cant_use_text
		giveitem CAGE_KEY, 2
	sendif
.unlock
	writetext .want_to_unlock_text
	yesorno
	sif true
		writetext .unlocked_text
	closetextend

.want_to_unlock_text
	ctxt "Do you want to"
	line "unlock this door?"
	done

.unlocked_text
	ctxt "Unlocked the door!"
	sdone

.cant_use_text
	ctxt "You try your key,"
	line "but the lock holds"
	cont "fast."

	para "Maybe this key"
	line "only works in the"
	cont "Eagulou City Gym?"
	done

GetCageKeyDoorArrayPointer:
	copybytetohalfwordvar wCageKeyDoorsArrayPointer
	loadarray -1, 5
	copybytetovar wCageKeyDoorsArrayBank
	copyvartobyte wScriptArrayBank
	readarrayhalfword 0
	checkevent -1
	end
