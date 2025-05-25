	ctxt "Tiny Mouse" ; species name
	done
	dw 3, 20 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It is unskilled at"
	next "storing electric"
	next "power. Any kind of"
	done
.page2
	ctxt "shock causes it to"
	next "discharge energy"
	next "spontaneously."
	done
