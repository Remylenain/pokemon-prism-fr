	ctxt "Blast" ; species name
	done
	dw 16, 680 ; height, weight

	db .page2 - .page1
.page1
	ctxt "When launching"
	next "@"
	start_asm
	ld a, [wOptions2]
	and 1 << 2
	ld hl, .metric_entry
	ret z
	ld hl, .imperial_entry
	ret
.metric_entry
	ctxt "2,000 degree C"
	next "fireballs, its"
	done
.imperial_entry
	ctxt "3,600 degree F"
	next "fireballs, its"
	done
.page2
	ctxt "body takes on a"
	next "whitish hue from"
	next "the intense heat."
	done
