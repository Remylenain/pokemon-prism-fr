	ctxt "Live Coal" ; species name
	done
	dw 7, 214 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It naturally spits"
	next "@"
	start_asm
	ld a, [wOptions2]
	and 1 << 2
	ld hl, .metric_entry
	ret z
	ld hl, .imperial_entry
	ret
.metric_entry
	ctxt "a 600 degree C"
	next "flame. It is said"
	done
.imperial_entry
	ctxt "an 1,100 degree F"
	next "flame. It is said"
	done
.page2
	ctxt "when many appear,"
	next "it heralds a"
	next "volcanic eruption."
	done
