	ctxt "Snow Land" ; species name
	done
	dw 13, 266 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It freezes prey by"
	next "blowing its @"
	start_asm
	ld a, [wOptions2]
	and 1 << 2
	ld hl, .metric_entry
	ret z
	ld hl, .imperial_entry
	ret
.metric_entry
	ctxt "-60"
	next "degree C breath."
	done
.imperial_entry
	ctxt "-58"
	next "degree F breath."
	done
.page2
	ctxt "It is said to then"
	next "secretly display"
	next "its prey."
	done
