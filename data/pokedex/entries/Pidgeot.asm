	ctxt "Bird" ; species name
	done
	dw 15, 395 ; height, weight

	db .page2 - .page1
.page1
	ctxt "Its outstanding"
	next "vision allows it"
	next "to spot splashing"
	done
.page2
	ctxt "Magikarp, even"
	next "while flying at"
	next "@"
	start_asm
	ld a, [wOptions2]
	and 1 << 2
	ld hl, .metric_entry
	ret z
	ld hl, .imperial_entry
	ret
.metric_entry
	ctxt "1,000 meters."
	done
.imperial_entry
	ctxt "3,300 feet."
	done
