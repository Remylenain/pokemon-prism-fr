	ctxt "Flame" ; species name
	done
	dw 9, 250 ; height, weight

	db .page2 - .page1
.page1
	ctxt "Once it has stored"
	next "up enough heat,"
	next "this #mon's"
	done
.page2
	ctxt "body temperature"
	next "can reach up to"
	next "@"
	start_asm
	ld a, [wOptions2]
	and 1 << 2
	ld hl, .metric_entry
	ret z
	ld hl, .imperial_entry
	ret
.metric_entry
	ctxt "900 degrees C."
	done
.imperial_entry
	ctxt "1,650 degrees F."
	done
