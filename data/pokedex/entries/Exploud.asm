	ctxt "Loud Noise" ; species name
	done
	dw 15, 840 ; height, weight

	db .page2 - .page1
.page1
	ctxt "Its howls can be"
	next "heard over @"
	start_asm
	ld a, [wOptions2]
	and 1 << 2
	ld hl, .metric_entry
	ret z
	ld hl, .imperial_entry
	ret
.metric_entry
	ctxt "ten"
	next "kilometers away."
	done
.imperial_entry
	ctxt "six"
	next "miles away."
	done
.page2
	ctxt "It emits all sorts"
	next "of noises from the"
	next "ports on its body."
	done
