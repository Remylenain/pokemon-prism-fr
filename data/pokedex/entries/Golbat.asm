	ctxt "Bat" ; species name
	done
	dw 16, 550 ; height, weight

	db .page2 - .page1
.page1
	ctxt "When it plunges"
	next "its fangs into its"
	next "prey, it instantly"
	done
.page2
	ctxt "draws and gulps"
	next "down more than@"
	start_asm
	ld a, [wOptions2]
	and 1 << 2
	ld hl, .metric_entry
	ret z
	ld hl, .imperial_entry
	ret
.metric_entry
	ctxt ""
	next "300 ml of blood."
	done
.imperial_entry
	ctxt " ten"
	next "ounces of blood."
	done
